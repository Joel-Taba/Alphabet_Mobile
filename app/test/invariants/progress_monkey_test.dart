import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/services/progress_service.dart';

import '../helpers/test_env.dart';

/// Test "singe" : des centaines d'actions tirées au hasard (réussir une
/// étape, rejouer, bonus de reprise, fermer/rouvrir l'app, perdre puis
/// retrouver le réseau...). Après CHAQUE action, on compare la
/// progression à un modèle simple tenu à côté, et on vérifie des règles
/// qui doivent toujours être vraies.
void main() {
  setUp(resetTestEnv);

  const types = ['LETTRE', 'MOT', 'CALCUL', 'FIGURE', 'SOLIDE'];
  const topics = ['cube', 'ce1-table-2', 'carre', 'a', 'chat'];

  for (final seed in [1, 2, 3, 4, 5]) {
    test('suite aléatoire n°$seed : la progression reste cohérente', () async {
      final rand = Random(seed);
      final env = await createProgress();
      var p = env.progress;
      final model = <String>{}; // étapes réussies "type|modalite|code"
      var modelPoints = 0;
      var lastPoints = 0;

      void checkInvariants(String step) {
        final points = p.stats.totalPoints;
        expect(points, modelPoints, reason: 'points après : $step');
        expect(
          points >= lastPoints,
          isTrue,
          reason: 'les points ne doivent jamais baisser ($step)',
        );
        lastPoints = points;
        for (final type in types) {
          for (final modalite in ['COURS', 'EXERCICE']) {
            for (final topic in topics) {
              for (final code in [topic, '$topic-0', '$topic-1']) {
                expect(
                  p.isCompleted(
                    typeEtape: type,
                    modalite: modalite,
                    etapeCode: code,
                  ),
                  model.contains('$type|$modalite|$code'),
                  reason: '$type $modalite $code après : $step',
                );
              }
            }
            // Convention de l'app : le sujet d'un exercice est tout ce qui
            // précède le dernier "-" de son code (ou le code entier).
            String topicOf(String code) {
              final cut = code.lastIndexOf('-');
              return cut == -1 ? code : code.substring(0, cut);
            }

            final exercisedTopics = {
              for (final k in model)
                if (k.startsWith('$type|EXERCICE|'))
                  topicOf(k.substring('$type|EXERCICE|'.length)),
            };
            for (final t in topics) {
              expect(
                p.isTopicExercised(type, t),
                exercisedTopics.contains(t),
                reason: '$type sujet $t après : $step',
              );
            }
          }
        }
      }

      for (var i = 0; i < 250; i++) {
        final action = rand.nextInt(10);
        String step;
        if (action < 6) {
          final type = types[rand.nextInt(types.length)];
          final modalite = rand.nextBool() ? 'COURS' : 'EXERCICE';
          final topic = topics[rand.nextInt(topics.length)];
          final code = modalite == 'EXERCICE' && rand.nextBool()
              ? '$topic-${rand.nextInt(2)}'
              : topic;
          step = 'réussir $type $modalite $code';
          final key = '$type|$modalite|$code';
          final result = await p.awardCompletion(
            typeEtape: type,
            modalite: modalite,
            etapeCode: code,
            palier: 1,
          );
          if (model.add(key)) {
            modelPoints += pointsParModalite[modalite]!;
            expect(result.alreadyCompleted, isFalse, reason: step);
          } else {
            expect(result.pointsAwarded, 0, reason: 'rejouer ne rapporte rien');
          }
        } else if (action == 6) {
          step = 'bonus de reprise';
          modelPoints += await p.awardRestartBonus();
        } else if (action == 7) {
          step = 'fermer puis rouvrir l\'app';
          p = await reopen(p);
        } else if (action == 8) {
          step = 'réseau retrouvé';
          env.backend.online = true;
          await p.syncPendingProgression();
        } else {
          step = 'réseau perdu';
          env.backend.online = false;
        }
        checkInvariants('#$i $step');
      }
    });
  }
}
