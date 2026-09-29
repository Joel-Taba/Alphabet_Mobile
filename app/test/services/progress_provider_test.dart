import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/services/family_service.dart';
import 'package:gentle_paths_academy/services/progress_service.dart';

import '../helpers/test_env.dart';

Future<void> award(
  ProgressProvider p,
  String type,
  String modalite,
  String code,
) => p.awardCompletion(
  typeEtape: type,
  modalite: modalite,
  etapeCode: code,
  palier: 1,
);

void main() {
  setUp(resetTestEnv);

  group('Points et déduplication', () {
    test('un nouvel enfant n\'a rien de réalisé', () async {
      final p = (await createProgress()).progress;
      expect(p.stats.totalPoints, 0);
      expect(
        p.isCompleted(
          typeEtape: 'LETTRE',
          modalite: 'EXERCICE',
          etapeCode: 'a',
        ),
        isFalse,
      );
    });

    test('une étape rapporte ses points une seule fois', () async {
      final p = (await createProgress()).progress;
      final first = await p.awardCompletion(
        typeEtape: 'LETTRE',
        modalite: 'EXERCICE',
        etapeCode: 'a',
        palier: 2,
      );
      final again = await p.awardCompletion(
        typeEtape: 'LETTRE',
        modalite: 'EXERCICE',
        etapeCode: 'a',
        palier: 2,
      );
      expect(first.pointsAwarded, pointsParModalite['EXERCICE']);
      expect(again.alreadyCompleted, isTrue);
      expect(again.pointsAwarded, 0);
      expect(p.stats.totalPoints, pointsParModalite['EXERCICE']);
    });

    test(
      'cours et exercice d\'un même code sont deux étapes distinctes',
      () async {
        final p = (await createProgress()).progress;
        await award(p, 'CALCUL', 'COURS', 'ce1-table-2');
        expect(
          p.isCompleted(
            typeEtape: 'CALCUL',
            modalite: 'EXERCICE',
            etapeCode: 'ce1-table-2',
          ),
          isFalse,
        );
        expect(p.isTopicExercised('CALCUL', 'ce1-table-2'), isFalse);
      },
    );
  });

  group('Sujets journalisés par tentative (CALCUL, FIGURE, SOLIDE)', () {
    test('une tentative réussie marque son sujet, et seulement lui', () async {
      final p = (await createProgress()).progress;
      await award(p, 'CALCUL', 'EXERCICE', 'ce1-table-2-4');
      expect(p.isTopicExercised('CALCUL', 'ce1-table-2'), isTrue);
      // Préfixes ou voisins proches : ne doivent PAS être marqués.
      expect(p.isTopicExercised('CALCUL', 'ce1-table-1'), isFalse);
      expect(p.isTopicExercised('CALCUL', 'ce1-table'), isFalse);
      expect(p.isTopicExercised('CALCUL', 'ce1-table-2-4'), isFalse);
      // Même identifiant de sujet, autre type : indépendant.
      expect(p.isTopicExercised('FIGURE', 'ce1-table-2'), isFalse);
    });

    test('les tentatives n\'augmentent pas le nombre de sujets', () async {
      final p = (await createProgress()).progress;
      for (var i = 0; i < 20; i++) {
        await award(p, 'SOLIDE', 'EXERCICE', 'cube-$i');
      }
      expect(p.completedTopicsForType('SOLIDE'), 1);
    });
  });

  group('Persistance', () {
    test('la progression survit à une fermeture de l\'app', () async {
      final p = (await createProgress()).progress;
      await award(p, 'MOT', 'EXERCICE', 'chat');
      await p.awardRestartBonus();
      final points = p.stats.totalPoints;
      final reopened = await reopen(p);
      expect(
        reopened.isCompleted(
          typeEtape: 'MOT',
          modalite: 'EXERCICE',
          etapeCode: 'chat',
        ),
        isTrue,
      );
      expect(reopened.stats.totalPoints, points);
    });

    test(
      'une réussite AVANT la fin du chargement initial n\'est pas perdue',
      () async {
        final p = (await createProgress(waitLoad: false)).progress;
        // Chargement pas encore terminé : l'enfant joue déjà.
        await award(p, 'SYLLABE', 'EXERCICE', 'ba');
        await settle();
        expect(
          p.isCompleted(
            typeEtape: 'SYLLABE',
            modalite: 'EXERCICE',
            etapeCode: 'ba',
          ),
          isTrue,
        );
        final reopened = await reopen(p);
        expect(
          reopened.isCompleted(
            typeEtape: 'SYLLABE',
            modalite: 'EXERCICE',
            etapeCode: 'ba',
          ),
          isTrue,
        );
      },
    );

    test('une entrée abîmée n\'efface pas toute la progression', () async {
      final good = {
        'typeEtape': 'MOT',
        'modalite': 'EXERCICE',
        'etapeCode': 'chat',
        'palier': 4,
        'points': 10,
        'dateReussite': '2026-09-01T10:00:00.000',
        'synced': true,
      };
      await resetTestEnv({
        'amani_progress_log': jsonEncode([
          good,
          {'typeEtape': 'MOT'}, // entrée incomplète
          'pas un objet',
          {...good, 'etapeCode': 'lune', 'dateReussite': 'pas une date'},
        ]),
        'amani_progress_bonus_points': 'pas un nombre',
      });
      final p = (await createProgress()).progress;
      expect(p.isLoaded, isTrue);
      expect(
        p.isCompleted(
          typeEtape: 'MOT',
          modalite: 'EXERCICE',
          etapeCode: 'chat',
        ),
        isTrue,
        reason: 'l\'entrée valide est conservée',
      );
      expect(p.stats.totalPoints, 10);
    });

    test('une réussite pendant un rechargement (changement d\'enfant) '
        'n\'est pas perdue', () async {
      final family = FamilyService();
      await family.ready;
      await family.createChild('Awa');
      final p = (await createProgress()).progress;
      // Rechargement lancé (ex. l'enfant vient d'être créé)...
      final reload = p.rechargerPourEnfantActif();
      // ... et l'enfant ouvre déjà un cours pendant ce temps.
      await award(p, 'FIGURE', 'COURS', 'carre');
      await reload;
      await settle();
      expect(
        p.isCompleted(
          typeEtape: 'FIGURE',
          modalite: 'COURS',
          etapeCode: 'carre',
        ),
        isTrue,
      );
      final reopened = await reopen(p);
      expect(
        reopened.isCompleted(
          typeEtape: 'FIGURE',
          modalite: 'COURS',
          etapeCode: 'carre',
        ),
        isTrue,
      );
    });

    test(
      'app rouverte directement sur un cours (actualisation du '
      'navigateur) : la progression enregistrée n\'est pas écrasée',
      () async {
        final saved = {
          'typeEtape': 'MOT',
          'modalite': 'EXERCICE',
          'etapeCode': 'chat',
          'palier': 4,
          'points': 10,
          'dateReussite': '2026-09-01T10:00:00.000',
          'synced': true,
        };
        await resetTestEnv({
          'amani_progress_log': jsonEncode([saved]),
          'amani_progress_bonus_points': 3,
        });
        final p = (await createProgress(waitLoad: false)).progress;
        // Le cours s'ouvre et se marque "vu" AVANT la fin du chargement.
        await award(p, 'FIGURE', 'COURS', 'carre');
        await p.awardRestartBonus();
        await settle();
        final reopened = await reopen(p);
        expect(
          reopened.isCompleted(
            typeEtape: 'MOT',
            modalite: 'EXERCICE',
            etapeCode: 'chat',
          ),
          isTrue,
          reason: 'la progression déjà enregistrée doit survivre',
        );
        expect(
          reopened.isCompleted(
            typeEtape: 'FIGURE',
            modalite: 'COURS',
            etapeCode: 'carre',
          ),
          isTrue,
        );
        expect(
          reopened.stats.totalPoints,
          greaterThanOrEqualTo(10 + 5 + 3 + 1),
        );
      },
    );

    test('un journal corrompu ne fait pas planter l\'app', () async {
      await resetTestEnv({'amani_progress_log': '{pas du json'});
      final p = (await createProgress()).progress;
      expect(p.isLoaded, isTrue);
      expect(p.stats.totalPoints, 0);
    });
  });

  group('Cours validé seulement quand tout a été vu', () {
    test('pas validé tant qu\'il manque un élément', () async {
      final p = (await createProgress()).progress;
      await p.markCoursItemViewed(
        typeEtape: 'LETTRE',
        groupCode: 'g1',
        itemCode: 'a',
        totalItems: 3,
        palier: 2,
      );
      await p.markCoursItemViewed(
        typeEtape: 'LETTRE',
        groupCode: 'g1',
        itemCode: 'a',
        totalItems: 3,
        palier: 2,
      );
      await p.markCoursItemViewed(
        typeEtape: 'LETTRE',
        groupCode: 'g1',
        itemCode: 'b',
        totalItems: 3,
        palier: 2,
      );
      expect(
        p.isCompleted(typeEtape: 'LETTRE', modalite: 'COURS', etapeCode: 'g1'),
        isFalse,
      );
    });

    test('éléments consultés en rafale : aucun n\'est perdu', () async {
      final p = (await createProgress()).progress;
      // Défilement rapide : tous les appels partent en même temps.
      await Future.wait([
        for (final c in ['a', 'e', 'i', 'o', 'u'])
          p.markCoursItemViewed(
            typeEtape: 'LETTRE',
            groupCode: 'voyelles',
            itemCode: c,
            totalItems: 5,
            palier: 2,
          ),
      ]);
      expect(
        p.isCompleted(
          typeEtape: 'LETTRE',
          modalite: 'COURS',
          etapeCode: 'voyelles',
        ),
        isTrue,
      );
    });
  });

  group('Synchronisation serveur', () {
    test('hors-ligne puis retour du réseau : tout est rattrapé', () async {
      final env = await createProgress(online: false);
      await award(env.progress, 'LETTRE', 'EXERCICE', 'a');
      await award(env.progress, 'LETTRE', 'EXERCICE', 'b');
      expect(env.backend.pushed, isEmpty);
      env.backend.online = true;
      await env.progress.syncPendingProgression();
      expect(
        env.backend.pushed,
        containsAll(['LETTRE|EXERCICE|a', 'LETTRE|EXERCICE|b']),
      );
      // Un second rattrapage ne renvoie rien de plus.
      final before = env.backend.pushed.length;
      await env.progress.syncPendingProgression();
      expect(env.backend.pushed.length, before);
    });
  });

  group('Plusieurs enfants sur le même appareil', () {
    test('la progression d\'un enfant ne fuit jamais vers un autre', () async {
      final family = FamilyService();
      await family.ready;
      await family.createChild('Awa');
      final p = (await createProgress()).progress;
      await award(p, 'SIGNE', 'EXERCICE', 'trait-1');
      p.flushPendingWritesForTest();
      await settle();

      final awaId = family.activeChild!.id;
      await family.createChild('Kofi');
      await p.rechargerPourEnfantActif();
      await settle();
      expect(
        p.isCompleted(
          typeEtape: 'SIGNE',
          modalite: 'EXERCICE',
          etapeCode: 'trait-1',
        ),
        isFalse,
        reason: 'Kofi n\'a rien fait',
      );
      expect(p.stats.totalPoints, 0);

      await family.switchTo(awaId);
      await p.rechargerPourEnfantActif();
      await settle();
      expect(
        p.isCompleted(
          typeEtape: 'SIGNE',
          modalite: 'EXERCICE',
          etapeCode: 'trait-1',
        ),
        isTrue,
        reason: 'la progression d\'Awa est retrouvée',
      );
    });
  });
}
