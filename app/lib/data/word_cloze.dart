import 'dart:math';
import 'word_catalog.dart';

/// Spécification d'un exercice à trous pour un mot : quelle lettre est
/// masquée et quelles options (bonne lettre incluse) sont proposées au
/// glisser-déposer. Pure donnée, aucune dépendance Flutter.
class WordClozeSpec {
  final WordEntry word;
  final List<String> letters;
  final int blankIndex;
  final List<String> options;

  const WordClozeSpec({
    required this.word,
    required this.letters,
    required this.blankIndex,
    required this.options,
  });

  String get correctLetter => letters[blankIndex];
}

/// Construit la spécification à trous d'un mot, dans la langue active.
/// Déterministe par mot (graine = `word.id.hashCode`) : la position du
/// trou et les distracteurs proposés ne changent pas d'une ouverture à
/// l'autre de l'exercice, seulement d'un mot à l'autre. Les distracteurs
/// sont puisés parmi les autres lettres du même groupe de mots, pour ne
/// nécessiter aucun contenu supplémentaire.
WordClozeSpec buildWordCloze(WordEntry word, String lang, WordGroup group) {
  final text = word.text(lang);
  final letters = text.split('');
  final rng = Random(word.id.hashCode);
  final blankIndex = rng.nextInt(letters.length);
  final correct = letters[blankIndex];

  final pool = <String>{
    for (final w in group.words)
      if (w.id != word.id) ...w.text(lang).split(''),
  }..remove(correct);
  final distractors = (pool.toList()..shuffle(rng)).take(3).toList();
  final options = [...distractors, correct]..shuffle(rng);

  return WordClozeSpec(
    word: word,
    letters: letters,
    blankIndex: blankIndex,
    options: options,
  );
}
