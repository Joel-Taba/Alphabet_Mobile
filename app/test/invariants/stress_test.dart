import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/data/calcul_catalog.dart';
import 'package:gentle_paths_academy/data/shape_catalog.dart';
import 'package:gentle_paths_academy/data/solid3d_catalog.dart';
import 'package:gentle_paths_academy/logic/progress_rules.dart';
import 'package:gentle_paths_academy/services/evaluation_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_env.dart';

/// Historique d'un enfant qui a joué pendant [days] jours, [perDay]
/// réussites par jour (surtout des tentatives de calcul, la source de
/// croissance la plus rapide du journal).
String bigHistory({int days = 180, int perDay = 120}) {
  final start = DateTime(2026, 3, 1);
  final entries = <Map<String, Object>>[];
  var n = 0;
  for (var d = 0; d < days; d++) {
    for (var i = 0; i < perDay; i++) {
      final topic = CALCUL_TOPICS[n % CALCUL_TOPICS.length].id;
      entries.add({
        'typeEtape': 'CALCUL',
        'modalite': 'EXERCICE',
        'etapeCode': '$topic-$n',
        'palier': 5,
        'points': 10,
        'dateReussite': start
            .add(Duration(days: d, minutes: i))
            .toIso8601String(),
        'synced': true,
      });
      n++;
    }
  }
  return jsonEncode(entries);
}

void main() {
  test('6 mois d\'historique (21 600 réussites) : chargement rapide, '
      'chaque nouvelle réussite reste instantanée', () async {
    await resetTestEnv({'amani_progress_log': bigHistory()});
    final load = Stopwatch()..start();
    final p = (await createProgress()).progress;
    load.stop();
    expect(p.stats.totalPoints, 21600 * 10);
    expect(
      load.elapsedMilliseconds,
      lessThan(3000),
      reason: 'chargement en ${load.elapsedMilliseconds} ms',
    );

    // Une rafale de 500 réussites (une longue séance de calcul).
    final burst = Stopwatch()..start();
    for (var i = 0; i < 500; i++) {
      await p.awardCompletion(
        typeEtape: 'FIGURE',
        modalite: 'EXERCICE',
        etapeCode: 'carre-$i',
        palier: 6,
      );
      // Ce que l'interface relit à chaque point gagné.
      p.stats;
      p.currentStreak;
    }
    burst.stop();
    expect(
      burst.elapsedMilliseconds / 500,
      lessThan(5),
      reason: '${burst.elapsedMilliseconds / 500} ms par réussite',
    );

    // Le parcours entier recalcule toutes ses étapes à chaque point gagné.
    final rules = Stopwatch()..start();
    for (var i = 0; i < 100; i++) {
      for (final t in CALCUL_TOPICS) {
        ProgressRules.topicDone(p, 'CALCUL', t.id);
      }
      for (final t in SHAPE_TOPICS) {
        ProgressRules.topicDone(p, 'FIGURE', t.id);
      }
      for (final t in SOLID3D_TOPICS) {
        ProgressRules.topicDone(p, 'SOLIDE', t.id);
      }
    }
    rules.stop();
    expect(
      rules.elapsedMilliseconds / 100,
      lessThan(2),
      reason: '${rules.elapsedMilliseconds / 100} ms par affichage du parcours',
    );
  });

  test(
    'fermeture brutale juste après une réussite : rien n\'est perdu',
    () async {
      await resetTestEnv();
      final p = (await createProgress()).progress;
      await p.awardCompletion(
        typeEtape: 'LETTRE',
        modalite: 'EXERCICE',
        etapeCode: 'a',
        palier: 2,
      );
      // Le système met l'app en arrière-plan puis la tue, sans attendre
      // l'écriture différée (600 ms).
      p.didChangeAppLifecycleState(AppLifecycleState.paused);
      await settle();
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString('amani_progress_log');
      expect(stored, isNotNull, reason: 'écrit dès le passage en arrière-plan');
      expect(stored, contains('"etapeCode":"a"'));
    },
  );

  test(
    'rafale de réussites : une seule écriture disque, pas une par point',
    () async {
      await resetTestEnv();
      final p = (await createProgress()).progress;
      var writes = 0;
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final before = prefs.getString('amani_progress_log');
      for (var i = 0; i < 50; i++) {
        await p.awardCompletion(
          typeEtape: 'CALCUL',
          modalite: 'EXERCICE',
          etapeCode: 'cp-addition-$i',
          palier: 5,
        );
        if (prefs.getString('amani_progress_log') != before) writes++;
      }
      expect(writes, 0, reason: 'rien n\'est écrit pendant la rafale');
      await Future<void>.delayed(const Duration(milliseconds: 700));
      await settle();
      final after = prefs.getString('amani_progress_log');
      expect(after, isNotNull);
      expect(
        (jsonDecode(after!) as List).length,
        50,
        reason: 'une écriture groupée contient toute la rafale',
      );
    },
  );

  test('évaluation avec des centaines de réponses : reprise exacte', () async {
    await resetTestEnv();
    final s = EvaluationSessionController();
    s.ensureContext('calculs');
    s.configureSubjects(25);
    s.start(1800);
    for (var i = 0; i < 400; i++) {
      s.recordItemDone('sujet-${i ~/ 16}-${i % 16}');
    }
    await s.persistProgress();
    final s2 = EvaluationSessionController();
    s2.ensureContext('calculs');
    final saved = await s2.readSavedProgress('calculs');
    s2.resumeFrom(saved!);
    expect(s2.completedItems.length, 400);
    expect(s2.isItemDone('sujet-24-15'), isTrue);
    s.dispose();
    s2.dispose();
  });
}
