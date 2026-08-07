/// PALIER 3 — Les Mots
///
/// Banque de mots courts (filtrée depuis mots.tex) : uniquement des mots dont
/// l'orthographe française, la traduction anglaise ET la traduction
/// espagnole ne comportent que des lettres a→z déjà apprises (aucun accent,
/// trait d'union ou espace), afin que chaque mot reste traçable avec les
/// signes du Palier 2 — dans les trois langues, la traduction servant ici à
/// l'internationalisation de l'application plutôt qu'à un exercice de
/// vocabulaire multilingue. Pour l'espagnol, les accents (á/é/í/ó/ú) sont donc
/// volontairement omis (ex. "avion" et non "avión") ; le ñ reste autorisé
/// puisqu'il est enseigné comme lettre à part entière. Port fidèle de
/// `src/data/word-catalog.ts`.
class WordEntry {
  final String id;
  final String fr;
  final String en;
  final String es;
  final String theme;

  const WordEntry(this.id, this.fr, this.en, this.es, this.theme);

  /// Texte du mot dans la langue active (`Lang.name` : 'fr' | 'en' | 'es').
  String text(String lang) {
    switch (lang) {
      case 'en':
        return en;
      case 'es':
        return es;
      default:
        return fr;
    }
  }
}

const List<WordEntry> WORD_CATALOG = [
  // ─── Animaux ───
  WordEntry('chat', 'chat', 'cat', 'gato', 'animaux'),
  WordEntry('chien', 'chien', 'dog', 'perro', 'animaux'),
  WordEntry('lion', 'lion', 'lion', 'leon', 'animaux'),
  WordEntry('tigre', 'tigre', 'tiger', 'tigre', 'animaux'),
  WordEntry('ours', 'ours', 'bear', 'oso', 'animaux'),
  WordEntry('singe', 'singe', 'monkey', 'mono', 'animaux'),
  WordEntry('vache', 'vache', 'cow', 'vaca', 'animaux'),
  WordEntry('zebre', 'zebre', 'zebra', 'cebra', 'animaux'),
  WordEntry('mouton', 'mouton', 'sheep', 'oveja', 'animaux'),
  WordEntry('cochon', 'cochon', 'pig', 'cerdo', 'animaux'),
  WordEntry('canard', 'canard', 'duck', 'pato', 'animaux'),
  WordEntry('cygne', 'cygne', 'swan', 'cisne', 'animaux'),
  WordEntry('lapin', 'lapin', 'rabbit', 'conejo', 'animaux'),
  WordEntry('renard', 'renard', 'fox', 'zorro', 'animaux'),
  WordEntry('loup', 'loup', 'wolf', 'lobo', 'animaux'),

  // ─── Nourriture ───
  WordEntry('kiwi', 'kiwi', 'kiwi', 'kiwi', 'nourriture'),
  WordEntry('miel', 'miel', 'honey', 'miel', 'nourriture'),
  WordEntry('citron', 'citron', 'lemon', 'limon', 'nourriture'),
  WordEntry('riz', 'riz', 'rice', 'arroz', 'nourriture'),
  WordEntry('poire', 'poire', 'pear', 'pera', 'nourriture'),
  WordEntry('cerise', 'cerise', 'cherry', 'cereza', 'nourriture'),
  WordEntry('raisin', 'raisin', 'grape', 'uva', 'nourriture'),
  WordEntry('tomate', 'tomate', 'tomato', 'tomate', 'nourriture'),
  WordEntry('mais', 'mais', 'corn', 'maiz', 'nourriture'),
  WordEntry('pain', 'pain', 'bread', 'pan', 'nourriture'),
  WordEntry('lait', 'lait', 'milk', 'leche', 'nourriture'),
  WordEntry('sucre', 'sucre', 'sugar', 'azucar', 'nourriture'),
  WordEntry('yaourt', 'yaourt', 'yogurt', 'yogur', 'nourriture'),
  WordEntry('gateau', 'gateau', 'cake', 'pastel', 'nourriture'),
  WordEntry('creme', 'creme', 'cream', 'crema', 'nourriture'),

  // ─── Maison ───
  WordEntry('table', 'table', 'table', 'mesa', 'maison'),
  WordEntry('lit', 'lit', 'bed', 'cama', 'maison'),
  WordEntry('porte', 'porte', 'door', 'puerta', 'maison'),
  WordEntry('chaise', 'chaise', 'chair', 'silla', 'maison'),
  WordEntry('radio', 'radio', 'radio', 'radio', 'maison'),
  WordEntry('livre', 'livre', 'book', 'libro', 'maison'),
  WordEntry('papier', 'papier', 'paper', 'papel', 'maison'),
  WordEntry('crayon', 'crayon', 'pencil', 'lapiz', 'maison'),
  WordEntry('regle', 'regle', 'ruler', 'regla', 'maison'),
  WordEntry('sac', 'sac', 'bag', 'bolsa', 'maison'),
  WordEntry('tasse', 'tasse', 'cup', 'taza', 'maison'),
  WordEntry('verre', 'verre', 'glass', 'vaso', 'maison'),
  WordEntry('bol', 'bol', 'bowl', 'bol', 'maison'),
  WordEntry('clef', 'clef', 'key', 'llave', 'maison'),
  WordEntry('poupee', 'poupee', 'doll', 'muñeca', 'maison'),

  // ─── Vêtements ───
  WordEntry('short', 'short', 'shorts', 'short', 'vetements'),
  WordEntry('poncho', 'poncho', 'poncho', 'poncho', 'vetements'),
  WordEntry('jupe', 'jupe', 'skirt', 'falda', 'vetements'),
  WordEntry('botte', 'botte', 'boot', 'bota', 'vetements'),
  WordEntry('polo', 'polo', 'polo', 'polo', 'vetements'),
  WordEntry('beret', 'beret', 'beret', 'boina', 'vetements'),
  WordEntry('gant', 'gant', 'glove', 'guante', 'vetements'),
  WordEntry('noeud', 'noeud', 'bow', 'lazo', 'vetements'),
  WordEntry('bouton', 'bouton', 'button', 'boton', 'vetements'),
  WordEntry('jean', 'jean', 'jeans', 'jean', 'vetements'),

  // ─── École ───
  WordEntry('classe', 'classe', 'class', 'clase', 'ecole'),
  WordEntry('gomme', 'gomme', 'eraser', 'goma', 'ecole'),
  WordEntry('carte', 'carte', 'card', 'carta', 'ecole'),
  WordEntry('signe', 'signe', 'sign', 'signo', 'ecole'),
  WordEntry('lettre', 'lettre', 'letter', 'letra', 'ecole'),
  WordEntry('ligne', 'ligne', 'line', 'linea', 'ecole'),
  WordEntry('encre', 'encre', 'ink', 'tinta', 'ecole'),
  WordEntry('banc', 'banc', 'bench', 'banco', 'ecole'),
  WordEntry('texte', 'texte', 'text', 'texto', 'ecole'),
  WordEntry('note', 'note', 'note', 'nota', 'ecole'),

  // ─── Nature ───
  WordEntry('soleil', 'soleil', 'sun', 'sol', 'nature'),
  WordEntry('lune', 'lune', 'moon', 'luna', 'nature'),
  WordEntry('nuage', 'nuage', 'cloud', 'nube', 'nature'),
  WordEntry('pluie', 'pluie', 'rain', 'lluvia', 'nature'),
  WordEntry('neige', 'neige', 'snow', 'nieve', 'nature'),
  WordEntry('vent', 'vent', 'wind', 'viento', 'nature'),
  WordEntry('fleur', 'fleur', 'flower', 'flor', 'nature'),
  WordEntry('arbre', 'arbre', 'tree', 'arbol', 'nature'),
  WordEntry('mer', 'mer', 'sea', 'mar', 'nature'),
  WordEntry('foret', 'foret', 'forest', 'bosque', 'nature'),

  // ─── Corps ───
  WordEntry('main', 'main', 'hand', 'mano', 'corps'),
  WordEntry('nez', 'nez', 'nose', 'nariz', 'corps'),
  WordEntry('pied', 'pied', 'foot', 'pie', 'corps'),
  WordEntry('jambe', 'jambe', 'leg', 'pierna', 'corps'),
  WordEntry('coude', 'coude', 'elbow', 'codo', 'corps'),
  WordEntry('cou', 'cou', 'neck', 'cuello', 'corps'),
  WordEntry('doigt', 'doigt', 'finger', 'dedo', 'corps'),
  WordEntry('dent', 'dent', 'tooth', 'diente', 'corps'),
  WordEntry('yeux', 'yeux', 'eyes', 'ojos', 'corps'),
  WordEntry('ventre', 'ventre', 'belly', 'panza', 'corps'),

  // ─── Divers (véhicules, famille, couleurs) ───
  WordEntry('auto', 'auto', 'car', 'coche', 'divers'),
  WordEntry('train', 'train', 'train', 'tren', 'divers'),
  WordEntry('camion', 'camion', 'truck', 'camion', 'divers'),
  WordEntry('bateau', 'bateau', 'boat', 'barco', 'divers'),
  WordEntry('avion', 'avion', 'plane', 'avion', 'divers'),
  WordEntry('maman', 'maman', 'mom', 'mami', 'divers'),
  WordEntry('papa', 'papa', 'dad', 'papi', 'divers'),
  WordEntry('ami', 'ami', 'friend', 'amigo', 'divers'),
  WordEntry('bleu', 'bleu', 'blue', 'azul', 'divers'),
  WordEntry('rouge', 'rouge', 'red', 'rojo', 'divers'),
];

final Map<String, WordEntry> WORD_MAP = {for (final w in WORD_CATALOG) w.id: w};

const Map<String, Map<String, String>> THEME_TITLES = {
  'animaux': {'fr': 'Animaux', 'en': 'Animals', 'es': 'Animales'},
  'nourriture': {'fr': 'Nourriture', 'en': 'Food', 'es': 'Comida'},
  'maison': {'fr': 'Maison', 'en': 'House', 'es': 'Casa'},
  'vetements': {'fr': 'Vêtements', 'en': 'Clothes', 'es': 'Ropa'},
  'ecole': {'fr': 'École', 'en': 'School', 'es': 'Escuela'},
  'nature': {'fr': 'Nature', 'en': 'Nature', 'es': 'Naturaleza'},
  'corps': {'fr': 'Corps', 'en': 'Body', 'es': 'Cuerpo'},
  'divers': {
    'fr': 'Autour de nous',
    'en': 'All around us',
    'es': 'A nuestro alrededor',
  },
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
      final base =
          THEME_TITLES[theme] ?? {'fr': theme, 'en': theme, 'es': theme};
      final title = chunkCount > 1
          ? {
              'fr': '${base['fr']} ${i + 1}',
              'en': '${base['en']} ${i + 1}',
              'es': '${base['es']} ${i + 1}',
            }
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

/// Difficulté progressive des mots croisés du Palier 3 : de 2 à 10 mots par
/// grille. Une grille est insérée dans le parcours (voir parcours_screen.dart)
/// après chaque groupe de mots à index impair.
const List<int> PALIER3_CROSSWORD_LEVELS = [2, 3, 4, 5, 6, 7, 8, 9, 10];

/// Groupe de mots qui suit une grille de mots croisés donnée dans le
/// parcours — sert de cible au bouton "Suivant" une fois la grille résolue
/// (voir CrosswordPlay). La grille de niveau N est insérée après le groupe
/// d'index (2 * indexDuNiveau + 1), donc le groupe suivant est à l'index
/// (2 * indexDuNiveau + 2).
WordGroup? nextWordGroupAfterCrossword(int level) {
  final levelIdx = PALIER3_CROSSWORD_LEVELS.indexOf(level);
  if (levelIdx < 0) return null;
  final groupIdx = 2 * levelIdx + 2;
  return groupIdx < PALIER3_GROUPS.length ? PALIER3_GROUPS[groupIdx] : null;
}
