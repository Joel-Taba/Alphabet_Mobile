import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/services/evaluation_session.dart';

import '../helpers/test_env.dart';

void main() {
  setUp(resetTestEnv);

  test(
    'une simple ouverture sans rien faire ne laisse aucune reprise',
    () async {
      final s = EvaluationSessionController();
      expect(s.ensureContext('calculs'), isFalse);
      s.start(300);
      await s.persistProgress();
      expect(await s.readSavedProgress('calculs'), isNull);
      s.dispose();
    },
  );

  test('sortie en cours d\'évaluation puis reprise exacte', () async {
    final s = EvaluationSessionController();
    s.ensureContext('calculs');
    s.configureSubjects(5);
    s.start(300);
    s.recordItemDone('cp-addition-0');
    s.recordItemDone('cp-addition-1');
    s.advanceSubject(1);
    await s.persistProgress();

    final s2 = EvaluationSessionController();
    expect(s2.ensureContext('calculs'), isFalse);
    final saved = await s2.readSavedProgress('calculs');
    expect(saved, isNotNull);
    s2.resumeFrom(saved!);
    expect(s2.isItemDone('cp-addition-1'), isTrue);
    expect(s2.subjectsDone, 1);
    expect(s2.currentSubjectIndex, 1);
    expect(s2.remainingSeconds, inInclusiveRange(290, 300));
    s.dispose();
    s2.dispose();
  });

  test('deux évaluations de paliers différents ne se mélangent pas', () async {
    final s = EvaluationSessionController();
    s.ensureContext('calculs');
    s.start(300);
    s.recordItemDone('cp-addition-0');
    // Navigation directe vers une autre évaluation, sans fermer la première.
    expect(s.ensureContext('solides'), isFalse);
    expect(
      s.isItemDone('cp-addition-0'),
      isFalse,
      reason: 'l\'évaluation des solides repart à neuf',
    );
    await settle();
    final calculs = await s.readSavedProgress('calculs');
    expect(calculs, isNotNull, reason: 'la progression des calculs est gardée');
    expect((calculs!['completedItems'] as List), contains('cp-addition-0'));
    s.dispose();
  });

  test('une évaluation terminée ne propose plus de reprise', () async {
    final s = EvaluationSessionController();
    s.ensureContext('calculs');
    s.start(300);
    s.recordItemDone('x-0');
    await settle();
    s.reset();
    await settle();
    expect(await s.readSavedProgress('calculs'), isNull);
    s.dispose();
  });
}
