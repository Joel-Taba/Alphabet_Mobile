import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/data/sign_exercise_catalog.dart';
import 'package:gentle_paths_academy/logic/progress_rules.dart';

/// Progression simulée : un simple ensemble d'étapes réussies.
class FakeProgress implements ProgressQuery {
  final Set<String> done = {};

  void mark(String type, String modalite, String code) =>
      done.add('$type|$modalite|$code');

  @override
  bool isCompleted({
    required String typeEtape,
    required String modalite,
    required String etapeCode,
  }) => done.contains('$typeEtape|$modalite|$etapeCode');

  @override
  bool isTopicExercised(String typeEtape, String topicId) => done.any((k) {
    final parts = k.split('|');
    if (parts[0] != typeEtape || parts[1] != 'EXERCICE') return false;
    final cut = parts[2].lastIndexOf('-');
    return cut != -1 && parts[2].substring(0, cut) == topicId;
  });
}

void main() {
  group('Étape courante', () {
    test('première étape non terminée', () {
      expect(ProgressRules.currentGroupIndex([true, true, false, false]), 2);
      expect(ProgressRules.currentGroupIndex([false, true]), 0);
    });
    test('tout terminé : la dernière reste l\'étape courante', () {
      expect(ProgressRules.currentGroupIndex([true, true, true]), 2);
    });
  });

  group('Une étape n\'est terminée que si cours ET exercices sont faits', () {
    test('lettres : exercices seuls, cours seul, tout', () {
      final p = FakeProgress();
      p.mark('LETTRE', 'EXERCICE', 'a');
      p.mark('LETTRE', 'EXERCICE', 'e');
      expect(
        ProgressRules.groupDone(p, 'LETTRE', 'g1', ['a', 'e']),
        isFalse,
        reason: 'cours pas fait',
      );
      p.mark('LETTRE', 'COURS', 'g1');
      expect(
        ProgressRules.groupDone(p, 'LETTRE', 'g1', ['a', 'e', 'i']),
        isFalse,
        reason: 'un exercice manque',
      );
      expect(ProgressRules.groupDone(p, 'LETTRE', 'g1', ['a', 'e']), isTrue);
    });

    test('un puzzle-formule ("a-puzzle") ne valide pas la lettre "a"', () {
      final p = FakeProgress()
        ..mark('LETTRE', 'COURS', 'g1')
        ..mark('LETTRE', 'EXERCICE', 'a-puzzle');
      expect(ProgressRules.groupDone(p, 'LETTRE', 'g1', ['a']), isFalse);
    });

    test('ouvrir un cours ne suffit pas à terminer un sujet de calcul', () {
      final p = FakeProgress()..mark('CALCUL', 'COURS', 'ce1-table-2');
      expect(ProgressRules.topicDone(p, 'CALCUL', 'ce1-table-2'), isFalse);
      p.mark('CALCUL', 'EXERCICE', 'ce1-table-2-0');
      expect(ProgressRules.topicDone(p, 'CALCUL', 'ce1-table-2'), isTrue);
      expect(
        ProgressRules.topicDone(p, 'CALCUL', 'ce1-table-1'),
        isFalse,
        reason: 'la table de 2 ne valide pas la table de 1',
      );
    });

    test('famille de signes : il faut TOUS ses exercices', () {
      final family = FAMILY_ORDER.first;
      final ids = EXERCISE_CATALOG
          .where((e) => e['family'] == family)
          .map((e) => e['id'] as String)
          .toList();
      final p = FakeProgress()..mark('SIGNE', 'COURS', family);
      for (final id in ids.skip(1)) {
        p.mark('SIGNE', 'EXERCICE', id);
      }
      expect(ProgressRules.signFamilyDone(p, family), isFalse);
      p.mark('SIGNE', 'EXERCICE', ids.first);
      expect(ProgressRules.signFamilyDone(p, family), isTrue);
      expect(ProgressRules.signFamilyDone(p, 'famille-inexistante'), isFalse);
    });
  });
}
