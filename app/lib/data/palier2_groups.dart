/// PALIER 2 — Progression pas à pas (Cours → Exercices)
///
/// Découpe les 26 minuscules, 10 chiffres et 26 majuscules en petits groupes
/// de 5 caractères (ou moins pour le dernier groupe d'une série), dans l'ordre
/// exact où ils doivent être enseignés puis exercés sur le chemin en zigzag.
/// Port fidèle de `src/data/palier2-groups.ts`.
enum ProgressionGroupKind { lettres, chiffres }

class ProgressionGroup {
  final String id;
  final ProgressionGroupKind kind;
  final List<String> chars;
  final Map<String, String> title;

  const ProgressionGroup(this.id, this.kind, this.chars, this.title);
}

const List<ProgressionGroup> PALIER2_GROUPS = [
  ProgressionGroup('l1', ProgressionGroupKind.lettres, ['a', 'b', 'c', 'd', 'e'],
      {'fr': 'Suivant', 'en': 'Letters a → e'}),
  ProgressionGroup('d1', ProgressionGroupKind.chiffres, ['0', '1', '2', '3', '4'],
      {'fr': 'Chiffres 0 → 4', 'en': 'Digits 0 → 4'}),
  ProgressionGroup('l2', ProgressionGroupKind.lettres, ['f', 'g', 'h', 'i', 'j'],
      {'fr': 'Lettres f → j', 'en': 'Letters f → j'}),
  ProgressionGroup('d2', ProgressionGroupKind.chiffres, ['5', '6', '7', '8', '9'],
      {'fr': 'Chiffres 5 → 9', 'en': 'Digits 5 → 9'}),
  ProgressionGroup('l3', ProgressionGroupKind.lettres, ['k', 'l', 'm', 'n', 'o'],
      {'fr': 'Lettres k → o', 'en': 'Letters k → o'}),
  ProgressionGroup('l4', ProgressionGroupKind.lettres, ['p', 'q', 'r', 's', 't'],
      {'fr': 'Lettres p → t', 'en': 'Letters p → t'}),
  ProgressionGroup('l5', ProgressionGroupKind.lettres, ['u', 'v', 'w', 'x', 'y'],
      {'fr': 'Lettres u → y', 'en': 'Letters u → y'}),
  ProgressionGroup('l6', ProgressionGroupKind.lettres, ['z'], {'fr': 'Lettre z', 'en': 'Letter z'}),
  ProgressionGroup('u1', ProgressionGroupKind.lettres, ['A', 'B', 'C', 'D', 'E'],
      {'fr': 'Majuscules A → E', 'en': 'Uppercase A → E'}),
  ProgressionGroup('u2', ProgressionGroupKind.lettres, ['F', 'G', 'H', 'I', 'J'],
      {'fr': 'Majuscules F → J', 'en': 'Uppercase F → J'}),
  ProgressionGroup('u3', ProgressionGroupKind.lettres, ['K', 'L', 'M', 'N', 'O'],
      {'fr': 'Majuscules K → O', 'en': 'Uppercase K → O'}),
  ProgressionGroup('u4', ProgressionGroupKind.lettres, ['P', 'Q', 'R', 'S', 'T'],
      {'fr': 'Majuscules P → T', 'en': 'Uppercase P → T'}),
  ProgressionGroup('u5', ProgressionGroupKind.lettres, ['U', 'V', 'W', 'X', 'Y'],
      {'fr': 'Majuscules U → Y', 'en': 'Uppercase U → Y'}),
  ProgressionGroup('u6', ProgressionGroupKind.lettres, ['Z'], {'fr': 'Majuscule Z', 'en': 'Uppercase Z'}),
];

final Map<String, ProgressionGroup> PALIER2_GROUP_MAP = {
  for (final g in PALIER2_GROUPS) g.id: g,
};

/// Retrouve le groupe de progression auquel appartient un caractère donné.
ProgressionGroup? findGroupForChar(String char) {
  for (final g in PALIER2_GROUPS) {
    if (g.chars.contains(char)) return g;
  }
  return null;
}
