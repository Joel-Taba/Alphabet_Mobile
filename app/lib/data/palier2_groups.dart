/// PALIER 2 — Progression pas à pas (Cours → Exercices)
///
/// Découpe les 26 minuscules, 10 chiffres et 26 majuscules en petits groupes
/// de 5 caractères (ou moins pour le dernier groupe d'une série), dans l'ordre
/// exact où ils doivent être enseignés puis exercés sur le chemin en zigzag :
/// lettres a→e, chiffres 0→4, lettres f→j, chiffres 5→9, puis le reste des
/// minuscules, puis les majuscules par groupes de 5. Port fidèle de
/// `src/data/palier2-groups.ts`.
enum ProgressionGroupKind { lettres, chiffres }

class ProgressionGroup {
  final String id;
  final ProgressionGroupKind kind;
  final List<String> chars;
  final Map<String, String> title;

  const ProgressionGroup(this.id, this.kind, this.chars, this.title);
}

const List<ProgressionGroup> _baseGroups = [
  ProgressionGroup(
    'l1',
    ProgressionGroupKind.lettres,
    ['a', 'b', 'c', 'd', 'e'],
    {'fr': 'Lettres a → e', 'en': 'Letters a → e', 'es': 'Letras a → e', 'ar': 'حروف a → e'},
  ),
  ProgressionGroup(
    'd1',
    ProgressionGroupKind.chiffres,
    ['0', '1', '2', '3', '4'],
    {'fr': 'Chiffres 0 → 4', 'en': 'Digits 0 → 4', 'es': 'Números 0 → 4', 'ar': 'أرقام 0 → 4'},
  ),
  ProgressionGroup(
    'l2',
    ProgressionGroupKind.lettres,
    ['f', 'g', 'h', 'i', 'j'],
    {'fr': 'Lettres f → j', 'en': 'Letters f → j', 'es': 'Letras f → j', 'ar': 'حروف f → j'},
  ),
  ProgressionGroup(
    'd2',
    ProgressionGroupKind.chiffres,
    ['5', '6', '7', '8', '9'],
    {'fr': 'Chiffres 5 → 9', 'en': 'Digits 5 → 9', 'es': 'Números 5 → 9', 'ar': 'أرقام 5 → 9'},
  ),
  ProgressionGroup(
    'l3',
    ProgressionGroupKind.lettres,
    ['k', 'l', 'm', 'n', 'o'],
    {'fr': 'Lettres k → o', 'en': 'Letters k → o', 'es': 'Letras k → o', 'ar': 'حروف k → o'},
  ),
  ProgressionGroup(
    'l4',
    ProgressionGroupKind.lettres,
    ['p', 'q', 'r', 's', 't'],
    {'fr': 'Lettres p → t', 'en': 'Letters p → t', 'es': 'Letras p → t', 'ar': 'حروف p → t'},
  ),
  ProgressionGroup(
    'l5',
    ProgressionGroupKind.lettres,
    ['u', 'v', 'w', 'x', 'y'],
    {'fr': 'Lettres u → y', 'en': 'Letters u → y', 'es': 'Letras u → y', 'ar': 'حروف u → y'},
  ),
  ProgressionGroup(
    'l6',
    ProgressionGroupKind.lettres,
    ['z'],
    {'fr': 'Lettre z', 'en': 'Letter z', 'es': 'Letra z', 'ar': 'حرف z'},
  ),
  ProgressionGroup(
    'u1',
    ProgressionGroupKind.lettres,
    ['A', 'B', 'C', 'D', 'E'],
    {
      'fr': 'Majuscules A → E',
      'en': 'Uppercase A → E',
      'es': 'Mayúsculas A → E',
      'ar': 'حروف كبيرة A → E',
    },
  ),
  ProgressionGroup(
    'u2',
    ProgressionGroupKind.lettres,
    ['F', 'G', 'H', 'I', 'J'],
    {
      'fr': 'Majuscules F → J',
      'en': 'Uppercase F → J',
      'es': 'Mayúsculas F → J',
      'ar': 'حروف كبيرة F → J',
    },
  ),
  ProgressionGroup(
    'u3',
    ProgressionGroupKind.lettres,
    ['K', 'L', 'M', 'N', 'O'],
    {
      'fr': 'Majuscules K → O',
      'en': 'Uppercase K → O',
      'es': 'Mayúsculas K → O',
      'ar': 'حروف كبيرة K → O',
    },
  ),
  ProgressionGroup(
    'u4',
    ProgressionGroupKind.lettres,
    ['P', 'Q', 'R', 'S', 'T'],
    {
      'fr': 'Majuscules P → T',
      'en': 'Uppercase P → T',
      'es': 'Mayúsculas P → T',
      'ar': 'حروف كبيرة P → T',
    },
  ),
  ProgressionGroup(
    'u5',
    ProgressionGroupKind.lettres,
    ['U', 'V', 'W', 'X', 'Y'],
    {
      'fr': 'Majuscules U → Y',
      'en': 'Uppercase U → Y',
      'es': 'Mayúsculas U → Y',
      'ar': 'حروف كبيرة U → Y',
    },
  ),
  ProgressionGroup(
    'u6',
    ProgressionGroupKind.lettres,
    ['Z'],
    {'fr': 'Majuscule Z', 'en': 'Uppercase Z', 'es': 'Mayúscula Z', 'ar': 'حرف كبير Z'},
  ),
];

/// Groupes de progression du Palier 2. [langName] (`Lang.name` : 'fr' | 'en'
/// | 'es' | 'ar') n'affecte plus la composition des groupes (identique dans
/// toutes les langues) mais reste accepté pour ne pas changer la signature
/// utilisée par tous les appelants.
List<ProgressionGroup> getPalier2Groups(String langName) => _baseGroups;

final Map<String, ProgressionGroup> _groupMap = {
  for (final g in _baseGroups) g.id: g,
};
final Map<String, Map<String, ProgressionGroup>> _groupMaps = {
  'fr': _groupMap,
  'en': _groupMap,
  'es': _groupMap,
  'ar': _groupMap,
};

Map<String, ProgressionGroup> getPalier2GroupMap(String langName) =>
    _groupMaps[langName] ?? _groupMaps['fr']!;

/// Retrouve le groupe de progression auquel appartient un caractère donné.
ProgressionGroup? findGroupForChar(String char, [String langName = 'fr']) {
  for (final g in getPalier2Groups(langName)) {
    if (g.chars.contains(char)) return g;
  }
  return null;
}
