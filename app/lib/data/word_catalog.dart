/// PALIER 3 — Les Mots
///
/// Banque de mots courts (filtrée depuis mots.tex) : uniquement des mots dont
/// l'orthographe française ET la traduction anglaise ne comportent que des
/// lettres a→z déjà apprises, afin que chaque mot reste traçable avec les
/// signes du Palier 2 — en français comme en anglais, la traduction anglaise
/// servant ici à l'internationalisation de l'application plutôt qu'à un
/// exercice de vocabulaire bilingue. Port fidèle de `src/data/word-catalog.ts`.
class WordEntry {
  final String id;
  final String fr;
  final String en;
  final String theme;

  const WordEntry(this.id, this.fr, this.en, this.theme);

  /// Texte du mot dans la langue active.
  String text(String lang) => lang == 'en' ? en : fr;
}

const List<WordEntry> WORD_CATALOG = [
  // ─── Animaux ───
  WordEntry('chat', 'chat', 'cat', 'animaux'),
  WordEntry('chien', 'chien', 'dog', 'animaux'),
  WordEntry('lion', 'lion', 'lion', 'animaux'),
  WordEntry('tigre', 'tigre', 'tiger', 'animaux'),
  WordEntry('ours', 'ours', 'bear', 'animaux'),
  WordEntry('singe', 'singe', 'monkey', 'animaux'),
  WordEntry('vache', 'vache', 'cow', 'animaux'),
  WordEntry('cheval', 'cheval', 'horse', 'animaux'),
  WordEntry('mouton', 'mouton', 'sheep', 'animaux'),
  WordEntry('cochon', 'cochon', 'pig', 'animaux'),
  WordEntry('canard', 'canard', 'duck', 'animaux'),
  WordEntry('poule', 'poule', 'hen', 'animaux'),
  WordEntry('lapin', 'lapin', 'rabbit', 'animaux'),
  WordEntry('renard', 'renard', 'fox', 'animaux'),
  WordEntry('loup', 'loup', 'wolf', 'animaux'),

  // ─── Nourriture ───
  WordEntry('pomme', 'pomme', 'apple', 'nourriture'),
  WordEntry('miel', 'miel', 'honey', 'nourriture'),
  WordEntry('orange', 'orange', 'orange', 'nourriture'),
  WordEntry('riz', 'riz', 'rice', 'nourriture'),
  WordEntry('poire', 'poire', 'pear', 'nourriture'),
  WordEntry('cerise', 'cerise', 'cherry', 'nourriture'),
  WordEntry('banane', 'banane', 'banana', 'nourriture'),
  WordEntry('tomate', 'tomate', 'tomato', 'nourriture'),
  WordEntry('carotte', 'carotte', 'carrot', 'nourriture'),
  WordEntry('pain', 'pain', 'bread', 'nourriture'),
  WordEntry('lait', 'lait', 'milk', 'nourriture'),
  WordEntry('sucre', 'sucre', 'sugar', 'nourriture'),
  WordEntry('fromage', 'fromage', 'cheese', 'nourriture'),
  WordEntry('bonbon', 'bonbon', 'candy', 'nourriture'),
  WordEntry('chocolat', 'chocolat', 'chocolate', 'nourriture'),

  // ─── Maison ───
  WordEntry('table', 'table', 'table', 'maison'),
  WordEntry('lit', 'lit', 'bed', 'maison'),
  WordEntry('porte', 'porte', 'door', 'maison'),
  WordEntry('chaise', 'chaise', 'chair', 'maison'),
  WordEntry('lampe', 'lampe', 'lamp', 'maison'),
  WordEntry('livre', 'livre', 'book', 'maison'),
  WordEntry('cahier', 'cahier', 'notebook', 'maison'),
  WordEntry('crayon', 'crayon', 'pencil', 'maison'),
  WordEntry('stylo', 'stylo', 'pen', 'maison'),
  WordEntry('sac', 'sac', 'bag', 'maison'),
  WordEntry('tasse', 'tasse', 'cup', 'maison'),
  WordEntry('verre', 'verre', 'glass', 'maison'),
  WordEntry('couteau', 'couteau', 'knife', 'maison'),
  WordEntry('clef', 'clef', 'key', 'maison'),
  WordEntry('ballon', 'ballon', 'balloon', 'maison'),

  // ─── Vêtements ───
  WordEntry('robe', 'robe', 'dress', 'vetements'),
  WordEntry('veste', 'veste', 'jacket', 'vetements'),
  WordEntry('jupe', 'jupe', 'skirt', 'vetements'),
  WordEntry('pantalon', 'pantalon', 'trousers', 'vetements'),
  WordEntry('chemise', 'chemise', 'shirt', 'vetements'),
  WordEntry('chapeau', 'chapeau', 'hat', 'vetements'),
  WordEntry('gant', 'gant', 'glove', 'vetements'),
  WordEntry('ceinture', 'ceinture', 'belt', 'vetements'),
  WordEntry('cravate', 'cravate', 'tie', 'vetements'),
  WordEntry('jean', 'jean', 'jeans', 'vetements'),

  // ─── École ───
  WordEntry('classe', 'classe', 'class', 'ecole'),
  WordEntry('gomme', 'gomme', 'eraser', 'ecole'),
  WordEntry('ardoise', 'ardoise', 'slate', 'ecole'),
  WordEntry('alphabet', 'alphabet', 'alphabet', 'ecole'),
  WordEntry('lettre', 'lettre', 'letter', 'ecole'),
  WordEntry('mot', 'mot', 'word', 'ecole'),
  WordEntry('exercice', 'exercice', 'exercise', 'ecole'),
  WordEntry('feuille', 'feuille', 'sheet', 'ecole'),
  WordEntry('texte', 'texte', 'text', 'ecole'),
  WordEntry('note', 'note', 'note', 'ecole'),

  // ─── Nature ───
  WordEntry('soleil', 'soleil', 'sun', 'nature'),
  WordEntry('lune', 'lune', 'moon', 'nature'),
  WordEntry('nuage', 'nuage', 'cloud', 'nature'),
  WordEntry('pluie', 'pluie', 'rain', 'nature'),
  WordEntry('neige', 'neige', 'snow', 'nature'),
  WordEntry('vent', 'vent', 'wind', 'nature'),
  WordEntry('fleur', 'fleur', 'flower', 'nature'),
  WordEntry('arbre', 'arbre', 'tree', 'nature'),
  WordEntry('mer', 'mer', 'sea', 'nature'),
  WordEntry('montagne', 'montagne', 'mountain', 'nature'),

  // ─── Corps ───
  WordEntry('main', 'main', 'hand', 'corps'),
  WordEntry('nez', 'nez', 'nose', 'corps'),
  WordEntry('pied', 'pied', 'foot', 'corps'),
  WordEntry('jambe', 'jambe', 'leg', 'corps'),
  WordEntry('oreille', 'oreille', 'ear', 'corps'),
  WordEntry('dos', 'dos', 'back', 'corps'),
  WordEntry('doigt', 'doigt', 'finger', 'corps'),
  WordEntry('dent', 'dent', 'tooth', 'corps'),
  WordEntry('yeux', 'yeux', 'eyes', 'corps'),
  WordEntry('ventre', 'ventre', 'belly', 'corps'),

  // ─── Divers (véhicules, famille, couleurs) ───
  WordEntry('voiture', 'voiture', 'car', 'divers'),
  WordEntry('train', 'train', 'train', 'divers'),
  WordEntry('camion', 'camion', 'truck', 'divers'),
  WordEntry('bateau', 'bateau', 'boat', 'divers'),
  WordEntry('avion', 'avion', 'airplane', 'divers'),
  WordEntry('maman', 'maman', 'mom', 'divers'),
  WordEntry('papa', 'papa', 'dad', 'divers'),
  WordEntry('ami', 'ami', 'friend', 'divers'),
  WordEntry('bleu', 'bleu', 'blue', 'divers'),
  WordEntry('rouge', 'rouge', 'red', 'divers'),
];

final Map<String, WordEntry> WORD_MAP = {for (final w in WORD_CATALOG) w.id: w};

const Map<String, Map<String, String>> THEME_TITLES = {
  'animaux': {'fr': 'Animaux', 'en': 'Animals'},
  'nourriture': {'fr': 'Nourriture', 'en': 'Food'},
  'maison': {'fr': 'Maison', 'en': 'House'},
  'vetements': {'fr': 'Vêtements', 'en': 'Clothes'},
  'ecole': {'fr': 'École', 'en': 'School'},
  'nature': {'fr': 'Nature', 'en': 'Nature'},
  'corps': {'fr': 'Corps', 'en': 'Body'},
  'divers': {'fr': 'Autour de nous', 'en': 'All around us'},
};

class WordGroup {
  final String id;
  final String theme;
  final Map<String, String> title;
  final List<WordEntry> words;

  const WordGroup(this.id, this.theme, this.title, this.words);
}

/// Découpe chaque thème en petits groupes de 5 mots, dans l'ordre du
/// catalogue — même logique que `PALIER3_GROUPS` côté React.
final List<WordGroup> PALIER3_GROUPS = (() {
  final groups = <WordGroup>[];
  final byTheme = <String, List<WordEntry>>{};
  for (final word in WORD_CATALOG) {
    byTheme.putIfAbsent(word.theme, () => []).add(word);
  }
  for (final entry in byTheme.entries) {
    final theme = entry.key;
    final words = entry.value;
    const chunkSize = 5;
    final chunkCount = (words.length / chunkSize).ceil();
    for (var i = 0; i < chunkCount; i++) {
      final chunk = words.sublist(
        i * chunkSize,
        ((i + 1) * chunkSize).clamp(0, words.length),
      );
      final base = THEME_TITLES[theme] ?? {'fr': theme, 'en': theme};
      final title = chunkCount > 1
          ? {'fr': '${base['fr']} ${i + 1}', 'en': '${base['en']} ${i + 1}'}
          : base;
      groups.add(
        WordGroup('${theme.substring(0, 2)}${i + 1}', theme, title, chunk),
      );
    }
  }
  return groups;
})();

final Map<String, WordGroup> PALIER3_GROUP_MAP = {
  for (final g in PALIER3_GROUPS) g.id: g,
};
