import 'dart:math';

/// Générateur de calcul mental pour le Mode Libre — indépendant du
/// catalogue du Palier "Les Calculs" (`calcul_catalog.dart`, français
/// uniquement) : ce mini-jeu est un QCM chronométré, pas un exercice de
/// traçage, et son contenu (opérations de base) est universel plutôt que
/// lié au programme scolaire français.
///
/// Trois paliers de difficulté, tirés au hasard à chaque nouveau problème
/// pour varier le rythme : chacun a sa propre plage numérique ET son propre
/// temps imparti (plus l'opération est grande, plus le temps accordé est
/// long) — c'est ce qui répond à "un temps adapté au niveau de difficulté".
enum MentalCalcDifficulty { facile, moyen, difficile }

class MentalCalcProblem {
  final String display;
  final int answer;
  final List<int> choices;
  final int seconds;
  final MentalCalcDifficulty difficulty;

  const MentalCalcProblem({
    required this.display,
    required this.answer,
    required this.choices,
    required this.seconds,
    required this.difficulty,
  });
}

const Map<MentalCalcDifficulty, int> _secondsByDifficulty = {
  MentalCalcDifficulty.facile: 12,
  MentalCalcDifficulty.moyen: 10,
  MentalCalcDifficulty.difficile: 8,
};

MentalCalcProblem generateMentalCalcProblem(Random rand) {
  final difficulty = MentalCalcDifficulty
      .values[rand.nextInt(MentalCalcDifficulty.values.length)];
  final String display;
  final int answer;

  switch (difficulty) {
    case MentalCalcDifficulty.facile:
      // Addition/soustraction à un chiffre — doubles et petites sommes.
      final a = 1 + rand.nextInt(9);
      final b = 1 + rand.nextInt(9);
      if (rand.nextBool()) {
        display = '$a + $b';
        answer = a + b;
      } else {
        final hi = max(a, b);
        final lo = min(a, b);
        display = '$hi − $lo';
        answer = hi - lo;
      }
      break;
    case MentalCalcDifficulty.moyen:
      // Deux chiffres, ou une petite table (× 2 / × 5 / × 10).
      if (rand.nextBool()) {
        final a = 10 + rand.nextInt(40);
        final b = 10 + rand.nextInt(40);
        if (rand.nextBool()) {
          display = '$a + $b';
          answer = a + b;
        } else {
          final hi = max(a, b);
          final lo = min(a, b);
          display = '$hi − $lo';
          answer = hi - lo;
        }
      } else {
        final table = [2, 5, 10][rand.nextInt(3)];
        final n = 1 + rand.nextInt(10);
        display = '$table × $n';
        answer = table * n;
      }
      break;
    case MentalCalcDifficulty.difficile:
      // Deux chiffres avec retenue probable, ou table jusqu'à × 9.
      if (rand.nextBool()) {
        final a = 20 + rand.nextInt(70);
        final b = 20 + rand.nextInt(70);
        if (rand.nextBool()) {
          display = '$a + $b';
          answer = a + b;
        } else {
          final hi = max(a, b);
          final lo = min(a, b);
          display = '$hi − $lo';
          answer = hi - lo;
        }
      } else {
        final table = 2 + rand.nextInt(8);
        final n = 2 + rand.nextInt(9);
        display = '$table × $n';
        answer = table * n;
      }
      break;
  }

  final choices = <int>{answer};
  while (choices.length < 5) {
    final delta = 1 + rand.nextInt(answer > 20 ? 10 : 5);
    final candidate = rand.nextBool() ? answer + delta : answer - delta;
    if (candidate >= 0) choices.add(candidate);
  }
  final choiceList = choices.toList()..shuffle(rand);

  return MentalCalcProblem(
    display: display,
    answer: answer,
    choices: choiceList,
    seconds: _secondsByDifficulty[difficulty]!,
    difficulty: difficulty,
  );
}
