// Nommage SCREAMING_SNAKE_CASE volontaire pour le catalogue de données
// (SHAPE_TOPICS), en miroir direct des modules TypeScript source — voir
// `calcul_catalog.dart` pour l'explication complète.
// ignore_for_file: constant_identifier_names, non_constant_identifier_names

/// PALIER 6 — Les Figures géométriques
///
/// Carré, rectangle, triangle, cercle — les 4 figures de base du primaire,
/// sans leurs variantes. Contrairement au Palier "Les Calculs" (français
/// uniquement, lié au système scolaire français), le vocabulaire des
/// figures géométriques de base est universel : ce palier est disponible
/// dans les 4 langues supportées par l'app (fr/en/es/ar), avec le contenu
/// porté par des maps multi-langues directement ici — même procédé que
/// `letter_formation_catalog.dart`/`word_catalog.dart`.
///
/// Le traçage réutilise tel quel l'infrastructure des lettres
/// (`LetterTraceCell`, `lib/utils/trace_validation.dart`) : chaque figure
/// est une map `{'char': ..., 'steps': [...]}` où chaque step a un `pathD`
/// SVG sur un viewBox 200×200, exactement comme dans
/// `letter_formation_catalog.dart` (la lettre "o" y est déjà un cercle
/// tracé en un seul geste — même technique reprise ici pour le cercle).
class ShapeTopic {
  final String id;
  final Map<String, String> name;
  final Map<String, String> funFactTitle;
  final Map<String, String> funFactBody;
  final int sides;
  final int corners;
  final bool hasCurvedSides;
  final List<Map<String, dynamic>> steps;

  /// Formule du périmètre, en langage enfant ("Périmètre = côté × 4"),
  /// affichée dans la carte "Astuces" du cours (`cours_figure_screen.dart`).
  final Map<String, String> perimeterFormula;

  /// Formule de l'aire, même carte "Astuces".
  final Map<String, String> areaFormula;

  const ShapeTopic({
    required this.id,
    required this.name,
    required this.funFactTitle,
    required this.funFactBody,
    required this.sides,
    required this.corners,
    required this.hasCurvedSides,
    required this.steps,
    required this.perimeterFormula,
    required this.areaFormula,
  });

  /// Map compatible avec `LetterTraceCell`/`MiniLetterFrame`
  /// (`{'char': ..., 'steps': [...]}`), qui n'attendent qu'un identifiant
  /// pour détecter un changement de contenu — pas de vraie notion de
  /// "caractère" pour une figure, donc on y met simplement [id].
  Map<String, dynamic> get traceData => {'char': id, 'steps': steps};
}

const List<ShapeTopic> SHAPE_TOPICS = [
  ShapeTopic(
    id: 'carre',
    name: {
      'fr': 'Le carré',
      'en': 'The square',
      'es': 'El cuadrado',
      'ar': 'المربع',
    },
    funFactTitle: {
      'fr': 'Qu\'est-ce qu\'un carré ?',
      'en': 'What is a square?',
      'es': '¿Qué es un cuadrado?',
      'ar': 'ما هو المربع؟',
    },
    funFactBody: {
      'fr':
          'Un carré est une figure plate à 4 côtés. Ses 4 côtés ont exactement '
          'la même longueur et ses 4 coins sont des angles droits (90°).',
      'en':
          'A square is a flat shape with 4 sides. All 4 sides have exactly '
          'the same length and all 4 corners are right angles (90°).',
      'es':
          'Un cuadrado es una figura plana con 4 lados. Sus 4 lados tienen '
          'exactamente la misma longitud y sus 4 esquinas son ángulos rectos (90°).',
      'ar':
          'المربع شكل مسطح يحتوي على 4 أضلاع. أضلاعه الأربعة متساوية تمامًا '
          'في الطول، وزواياه الأربع قائمة (90°).',
    },
    sides: 4,
    corners: 4,
    hasCurvedSides: false,
    perimeterFormula: {
      'fr': 'Périmètre = côté × 4',
      'en': 'Perimeter = side × 4',
      'es': 'Perímetro = lado × 4',
      'ar': 'المحيط = الضلع × 4',
    },
    areaFormula: {
      'fr': 'Aire = côté × côté',
      'en': 'Area = side × side',
      'es': 'Área = lado × lado',
      'ar': 'المساحة = الضلع × الضلع',
    },
    // Base (côté du bas) exactement sur la ligne d'écriture de base (y=130,
    // la ligne rouge de `CahierFrame`, système de coordonnées 200×200
    // partagé avec les lettres) — aucune figure ne doit dépasser cette
    // ligne, tout comme une lettre sans jambage.
    // Ordre et sens de formation : violet (gauche, haut→bas), rouge (bas,
    // gauche→droite), vert (droite, bas→haut), bleu (haut, droite→gauche) --
    // une boucle continue anti-horaire démarrant en haut à gauche.
    steps: [
      {
        'family': 'trait',
        'pathD': 'M 60 50 L 60 130',
        'startXY': [60, 50],
        'strokeColor': '#8B5FBF',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 60 130 L 140 130',
        'startXY': [60, 130],
        'strokeColor': '#D0524A',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 140 130 L 140 50',
        'startXY': [140, 130],
        'strokeColor': '#5E8E3E',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 140 50 L 60 50',
        'startXY': [140, 50],
        'strokeColor': '#2D6BBF',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 60 50 L 140 130',
        'startXY': [60, 50],
        'strokeColor': '#9E6B2E',
        'strokeWidth': 5,
        'dashed': true,
      },
      {
        'family': 'trait',
        'pathD': 'M 140 50 L 60 130',
        'startXY': [140, 50],
        'strokeColor': '#9E6B2E',
        'strokeWidth': 5,
        'dashed': true,
      },
    ],
  ),
  ShapeTopic(
    id: 'rectangle',
    name: {
      'fr': 'Le rectangle',
      'en': 'The rectangle',
      'es': 'El rectángulo',
      'ar': 'المستطيل',
    },
    funFactTitle: {
      'fr': 'Qu\'est-ce qu\'un rectangle ?',
      'en': 'What is a rectangle?',
      'es': '¿Qué es un rectángulo?',
      'ar': 'ما هو المستطيل؟',
    },
    funFactBody: {
      'fr':
          'Un rectangle est un quadrilatère (une figure plate à quatre côtés) '
          'qui possède quatre angles droits.',
      'en':
          'A rectangle is a quadrilateral (a flat shape with four sides) '
          'that has four right angles.',
      'es':
          'Un rectángulo es un cuadrilátero (una figura plana de cuatro lados) '
          'que tiene cuatro ángulos rectos.',
      'ar':
          'المستطيل شكل رباعي (شكل مسطح بأربعة أضلاع) '
          'يمتلك أربع زوايا قائمة.',
    },
    sides: 4,
    corners: 4,
    hasCurvedSides: false,
    perimeterFormula: {
      'fr': 'Périmètre = (longueur + largeur) × 2',
      'en': 'Perimeter = (length + width) × 2',
      'es': 'Perímetro = (longitud + anchura) × 2',
      'ar': 'المحيط = (الطول + العرض) × 2',
    },
    areaFormula: {
      'fr': 'Aire = longueur × largeur',
      'en': 'Area = length × width',
      'es': 'Área = longitud × anchura',
      'ar': 'المساحة = الطول × العرض',
    },
    // Même ordre et sens de formation que le carré ci-dessus : violet
    // (gauche, haut→bas), rouge (bas, gauche→droite), vert (droite,
    // bas→haut), bleu (haut, droite→gauche).
    steps: [
      {
        'family': 'trait',
        'pathD': 'M 40 70 L 40 130',
        'startXY': [40, 70],
        'strokeColor': '#8B5FBF',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 40 130 L 160 130',
        'startXY': [40, 130],
        'strokeColor': '#D0524A',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 160 130 L 160 70',
        'startXY': [160, 130],
        'strokeColor': '#5E8E3E',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 160 70 L 40 70',
        'startXY': [160, 70],
        'strokeColor': '#2D6BBF',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 40 70 L 160 130',
        'startXY': [40, 70],
        'strokeColor': '#9E6B2E',
        'strokeWidth': 5,
        'dashed': true,
      },
      {
        'family': 'trait',
        'pathD': 'M 160 70 L 40 130',
        'startXY': [160, 70],
        'strokeColor': '#9E6B2E',
        'strokeWidth': 5,
        'dashed': true,
      },
    ],
  ),
  ShapeTopic(
    id: 'triangle',
    name: {
      'fr': 'Le triangle',
      'en': 'The triangle',
      'es': 'El triángulo',
      'ar': 'المثلث',
    },
    funFactTitle: {
      'fr': 'Qu\'est-ce qu\'un triangle ?',
      'en': 'What is a triangle?',
      'es': '¿Qué es un triángulo?',
      'ar': 'ما هو المثلث؟',
    },
    funFactBody: {
      'fr':
          'Un triangle est une figure géométrique à trois côtés, '
          'trois sommets et trois angles.',
      'en':
          'A triangle is a geometric shape with three sides, '
          'three vertices and three angles.',
      'es':
          'Un triángulo es una figura geométrica con tres lados, '
          'tres vértices y tres ángulos.',
      'ar':
          'المثلث شكل هندسي يحتوي على ثلاثة أضلاع، '
          'ثلاثة رؤوس وثلاث زوايا.',
    },
    sides: 3,
    corners: 3,
    hasCurvedSides: false,
    perimeterFormula: {
      'fr': 'Périmètre = somme des 3 côtés',
      'en': 'Perimeter = sum of the 3 sides',
      'es': 'Perímetro = suma de los 3 lados',
      'ar': 'المحيط = مجموع الأضلاع الثلاثة',
    },
    areaFormula: {
      'fr': 'Aire = (base × hauteur) ÷ 2',
      'en': 'Area = (base × height) ÷ 2',
      'es': 'Área = (base × altura) ÷ 2',
      'ar': 'المساحة = (القاعدة × الارتفاع) ÷ 2',
    },
    // Base exactement sur la ligne d'écriture de base (y=130). Ordre de
    // formation : rouge (bas-gauche→sommet), bleu (sommet→bas-droite), vert
    // (bas-droite→bas-gauche) -- une boucle continue.
    steps: [
      {
        'family': 'trait',
        'pathD': 'M 100 30 L 50 130',
        'startXY': [100, 30],
        'strokeColor': '#D0524A',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 100 30 L 150 130',
        'startXY': [100, 30],
        'strokeColor': '#2D6BBF',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 150 130 L 50 130',
        'startXY': [150, 130],
        'strokeColor': '#5E8E3E',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 100 30 L 100 130',
        'startXY': [100, 30],
        'strokeColor': '#9E6B2E',
        'strokeWidth': 5,
        'dashed': true,
      },
    ],
  ),
  ShapeTopic(
    id: 'cercle',
    name: {
      'fr': 'Le cercle',
      'en': 'The circle',
      'es': 'El círculo',
      'ar': 'الدائرة',
    },
    funFactTitle: {
      'fr': 'Qu\'est-ce qu\'un cercle ?',
      'en': 'What is a circle?',
      'es': '¿Qué es un círculo?',
      'ar': 'ما هي الدائرة؟',
    },
    funFactBody: {
      'fr':
          'Un cercle est une ligne courbe plane fermée dont tous les points '
          'sont situés à égale distance d\'un point unique appelé le centre.',
      'en':
          'A circle is a closed flat curved line where all points are at '
          'an equal distance from a single point called the centre.',
      'es':
          'Un círculo es una línea curva plana cerrada en la que todos los '
          'puntos están a la misma distancia de un punto único llamado centro.',
      'ar':
          'الدائرة خط منحنٍ مستوٍ مغلق، جميع نقاطه تقع على مسافة '
          'متساوية من نقطة واحدة تُسمّى المركز.',
    },
    sides: 0,
    corners: 0,
    hasCurvedSides: true,
    perimeterFormula: {
      'fr': 'Périmètre = 2 × π × rayon',
      'en': 'Perimeter = 2 × π × radius',
      'es': 'Perímetro = 2 × π × radio',
      'ar': 'المحيط = 2 × π × نصف القطر',
    },
    areaFormula: {
      'fr': 'Aire = π × rayon × rayon',
      'en': 'Area = π × radius × radius',
      'es': 'Área = π × radio × radio',
      'ar': 'المساحة = π × نصف القطر × نصف القطر',
    },
    // Cercle tangent à la ligne de base (bas du cercle à y=130).
    steps: [
      {
        'family': 'courbe',
        'pathD': 'M 100 30 A 50 50 0 1 0 100.05 30',
        'startXY': [100, 30],
        'strokeColor': '#E05252',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 100 80 L 150 80',
        'startXY': [100, 80],
        'strokeColor': '#9E6B2E',
        'strokeWidth': 5,
        'dashed': true,
      },
    ],
  ),
  ShapeTopic(
    id: 'parallelogramme',
    name: {
      'fr': 'Le parallélogramme',
      'en': 'The parallelogram',
      'es': 'El paralelogramo',
      'ar': 'متوازي الأضلاع',
    },
    funFactTitle: {
      'fr': 'Qu\'est-ce qu\'un parallélogramme ?',
      'en': 'What is a parallelogram?',
      'es': '¿Qué es un paralelogramo?',
      'ar': 'ما هو متوازي الأضلاع؟',
    },
    funFactBody: {
      'fr':
          'Un parallélogramme est une figure plate à 4 côtés. Ses côtés '
          'opposés sont égaux et parallèles (ils ne se touchent jamais), '
          'mais ses coins ne sont pas des angles droits.',
      'en':
          'A parallelogram is a flat shape with 4 sides. Its opposite sides '
          'are equal and parallel (they never meet), but its corners are '
          'not right angles.',
      'es':
          'Un paralelogramo es una figura plana con 4 lados. Sus lados '
          'opuestos son iguales y paralelos (nunca se tocan), pero sus '
          'esquinas no son ángulos rectos.',
      'ar':
          'متوازي الأضلاع شكل مسطح يحتوي على 4 أضلاع. أضلاعه المتقابلة '
          'متساوية ومتوازية (لا تلتقي أبداً)، لكن زواياه ليست قائمة.',
    },
    sides: 4,
    corners: 4,
    hasCurvedSides: false,
    perimeterFormula: {
      'fr': 'Périmètre = (côté a + côté b) × 2',
      'en': 'Perimeter = (side a + side b) × 2',
      'es': 'Perímetro = (lado a + lado b) × 2',
      'ar': 'المحيط = (الضلع أ + الضلع ب) × 2',
    },
    areaFormula: {
      'fr': 'Aire = base × hauteur',
      'en': 'Area = base × height',
      'es': 'Área = base × altura',
      'ar': 'المساحة = القاعدة × الارتفاع',
    },
    // Base exactement sur la ligne d'écriture de base (y=130), sommet haut
    // décalé de +20 en x par rapport au sommet bas correspondant (le
    // "penchement" du parallélogramme) -- même gabarit largeur/hauteur que
    // le carré/rectangle pour rester visuellement cohérent dans le cours.
    // Même ordre et sens de formation : violet (gauche, haut→bas), rouge
    // (bas, gauche→droite), vert (droite, bas→haut), bleu (haut,
    // droite→gauche).
    steps: [
      {
        'family': 'trait',
        'pathD': 'M 70 50 L 50 130',
        'startXY': [70, 50],
        'strokeColor': '#8B5FBF',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 50 130 L 150 130',
        'startXY': [50, 130],
        'strokeColor': '#D0524A',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 150 130 L 170 50',
        'startXY': [150, 130],
        'strokeColor': '#5E8E3E',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 170 50 L 70 50',
        'startXY': [170, 50],
        'strokeColor': '#2D6BBF',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 70 50 L 70 130',
        'startXY': [70, 50],
        'strokeColor': '#9E6B2E',
        'strokeWidth': 5,
        'dashed': true,
      },
    ],
  ),
  ShapeTopic(
    id: 'losange',
    name: {
      'fr': 'Le losange',
      'en': 'The rhombus',
      'es': 'El rombo',
      'ar': 'المعين',
    },
    funFactTitle: {
      'fr': 'Qu\'est-ce qu\'un losange ?',
      'en': 'What is a rhombus?',
      'es': '¿Qué es un rombo?',
      'ar': 'ما هو المعين؟',
    },
    funFactBody: {
      'fr':
          'Un losange est un quadrilatère (une figure plate à quatre côtés) '
          'dont tous les côtés ont la même longueur.',
      'en':
          'A rhombus is a quadrilateral (a flat shape with four sides) '
          'where all sides have the same length.',
      'es':
          'Un rombo es un cuadrilátero (una figura plana de cuatro lados) '
          'en el que todos los lados tienen la misma longitud.',
      'ar':
          'المعين شكل رباعي (شكل مسطح بأربعة أضلاع) '
          'جميع أضلاعه متساوية في الطول.',
    },
    sides: 4,
    corners: 4,
    hasCurvedSides: false,
    perimeterFormula: {
      'fr': 'Périmètre = côté × 4',
      'en': 'Perimeter = side × 4',
      'es': 'Perímetro = lado × 4',
      'ar': 'المحيط = الضلع × 4',
    },
    areaFormula: {
      'fr': 'Aire = (grande diagonale × petite diagonale) ÷ 2',
      'en': 'Area = (long diagonal × short diagonal) ÷ 2',
      'es': 'Área = (diagonal mayor × diagonal menor) ÷ 2',
      'ar': 'المساحة = (القطر الكبير × القطر الصغير) ÷ 2',
    },
    // Losange tangent à la ligne de base (sommet bas à y=130), sommets
    // gauche/droite à mi-hauteur -- même gabarit que le cercle pour la
    // pointe basse. Boucle continue anti-horaire démarrant au sommet haut.
    steps: [
      {
        'family': 'trait',
        'pathD': 'M 100 50 L 60 90',
        'startXY': [100, 50],
        'strokeColor': '#8B5FBF',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 60 90 L 100 130',
        'startXY': [60, 90],
        'strokeColor': '#D0524A',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 100 130 L 140 90',
        'startXY': [100, 130],
        'strokeColor': '#5E8E3E',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 140 90 L 100 50',
        'startXY': [140, 90],
        'strokeColor': '#2D6BBF',
        'strokeWidth': 8,
      },
      {
        'family': 'trait',
        'pathD': 'M 100 50 L 100 130',
        'startXY': [100, 50],
        'strokeColor': '#9E6B2E',
        'strokeWidth': 5,
        'dashed': true,
      },
      {
        'family': 'trait',
        'pathD': 'M 60 90 L 140 90',
        'startXY': [60, 90],
        'strokeColor': '#9E6B2E',
        'strokeWidth': 5,
        'dashed': true,
      },
    ],
  ),
];

ShapeTopic? findShapeTopic(String id) {
  for (final topic in SHAPE_TOPICS) {
    if (topic.id == id) return topic;
  }
  return null;
}

// ─── Mini-jeux bonus ────────────────────────────────────────────────────
//
// Intercalés dans le zigzag après les 4 sujets Cours/Exercice, sans points
// ni progression — même principe que les mini-jeux du Palier "Les Calculs"
// (`StepKind.vraiFaux`/`composeNombre`, `exercice_calcul_vrai_faux_screen.dart`).
// Un seul niveau de difficulté ici : contrairement à Calcul, il n'y a pas de
// progression CP→CM2 pour 4 figures de base.

// La banque d'objets du quotidien évoquant chaque figure, pour "Quel objet a
// cette forme ?", vit désormais dans `data/shape_object_bank.dart`
// (`SHAPE_OBJECT_BANK`) -- plusieurs dizaines d'objets par figure, piqués au
// hasard à chaque tour, plutôt qu'un unique objet fixe comme ici auparavant.

/// Une affirmation Vrai/Faux sur les propriétés d'une figure, pour le jeu
/// "Vrai ou Faux ?".
class ShapeStatement {
  final Map<String, String> display;
  final bool isTrue;

  /// Brève explication affichée dans le pop-up de correction lorsque
  /// l'enfant se trompe -- rappelle la propriété réelle de la figure,
  /// quelle que soit l'erreur commise (répondre Faux à une affirmation
  /// vraie, ou Vrai à une affirmation fausse).
  final Map<String, String> explanation;

  const ShapeStatement({
    required this.display,
    required this.isTrue,
    required this.explanation,
  });
}

const List<ShapeStatement> SHAPE_STATEMENTS = [
  ShapeStatement(
    display: {
      'fr': 'Le carré a 4 côtés égaux.',
      'en': 'The square has 4 equal sides.',
      'es': 'El cuadrado tiene 4 lados iguales.',
      'ar': 'المربع له 4 أضلاع متساوية.',
    },
    isTrue: true,
    explanation: {
      'fr': "C'est vrai ! Les 4 côtés du carré ont toujours la même longueur.",
      'en': "That's true! A square's 4 sides are always the same length.",
      'es':
          '¡Es verdad! Los 4 lados del cuadrado siempre tienen la misma longitud.',
      'ar': 'هذا صحيح! أضلاع المربع الأربعة متساوية دائمًا في الطول.',
    },
  ),
  ShapeStatement(
    display: {
      'fr': 'Le carré a des côtés de longueurs différentes.',
      'en': 'The square has sides of different lengths.',
      'es': 'El cuadrado tiene lados de diferentes longitudes.',
      'ar': 'المربع له أضلاع بأطوال مختلفة.',
    },
    isTrue: false,
    explanation: {
      'fr': 'En fait, les 4 côtés du carré ont tous la même longueur !',
      'en': "Actually, a square's 4 sides are all the same length!",
      'es':
          '¡En realidad, los 4 lados del cuadrado tienen todos la misma longitud!',
      'ar': 'في الحقيقة، أضلاع المربع الأربعة كلها متساوية في الطول!',
    },
  ),
  ShapeStatement(
    display: {
      'fr': 'Le rectangle a 4 coins bien droits.',
      'en': 'The rectangle has 4 straight corners.',
      'es': 'El rectángulo tiene 4 esquinas rectas.',
      'ar': 'المستطيل له 4 زوايا قائمة.',
    },
    isTrue: true,
    explanation: {
      'fr':
          "C'est vrai ! Les 4 coins du rectangle forment toujours un angle droit.",
      'en': "That's true! A rectangle's 4 corners always form a right angle.",
      'es':
          '¡Es verdad! Las 4 esquinas del rectángulo siempre forman un ángulo recto.',
      'ar': 'هذا صحيح! زوايا المستطيل الأربع قائمة دائمًا.',
    },
  ),
  ShapeStatement(
    display: {
      'fr': "Le rectangle n'a que 3 côtés.",
      'en': 'The rectangle only has 3 sides.',
      'es': 'El rectángulo solo tiene 3 lados.',
      'ar': 'المستطيل له 3 أضلاع فقط.',
    },
    isTrue: false,
    explanation: {
      'fr': 'En fait, le rectangle a 4 côtés, pas 3 !',
      'en': 'Actually, a rectangle has 4 sides, not 3!',
      'es': '¡En realidad, el rectángulo tiene 4 lados, no 3!',
      'ar': 'في الحقيقة، للمستطيل 4 أضلاع، وليس 3!',
    },
  ),
  ShapeStatement(
    display: {
      'fr': 'Le triangle a 3 côtés.',
      'en': 'The triangle has 3 sides.',
      'es': 'El triángulo tiene 3 lados.',
      'ar': 'المثلث له 3 أضلاع.',
    },
    isTrue: true,
    explanation: {
      'fr': "C'est vrai ! Le triangle est la figure à 3 côtés et 3 coins.",
      'en': "That's true! A triangle is the shape with 3 sides and 3 corners.",
      'es': '¡Es verdad! El triángulo es la figura con 3 lados y 3 esquinas.',
      'ar': 'هذا صحيح! المثلث هو الشكل الذي له 3 أضلاع و3 زوايا.',
    },
  ),
  ShapeStatement(
    display: {
      'fr': 'Le triangle a 4 coins.',
      'en': 'The triangle has 4 corners.',
      'es': 'El triángulo tiene 4 esquinas.',
      'ar': 'المثلث له 4 زوايا.',
    },
    isTrue: false,
    explanation: {
      'fr': 'En fait, le triangle a seulement 3 coins, pas 4 !',
      'en': 'Actually, a triangle only has 3 corners, not 4!',
      'es': '¡En realidad, el triángulo solo tiene 3 esquinas, no 4!',
      'ar': 'في الحقيقة، للمثلث 3 زوايا فقط، وليس 4!',
    },
  ),
  ShapeStatement(
    display: {
      'fr': 'Le cercle a des coins pointus.',
      'en': 'The circle has pointy corners.',
      'es': 'El círculo tiene esquinas puntiagudas.',
      'ar': 'الدائرة لها زوايا مدببة.',
    },
    isTrue: false,
    explanation: {
      'fr': "En fait, le cercle n'a aucun coin : il est tout rond !",
      'en': "Actually, a circle has no corners at all: it's perfectly round!",
      'es':
          '¡En realidad, el círculo no tiene ninguna esquina: es completamente redondo!',
      'ar': 'في الحقيقة، ليس للدائرة أي زاوية: إنها مستديرة تمامًا!',
    },
  ),
  ShapeStatement(
    display: {
      'fr': "Le cercle n'a aucun côté droit.",
      'en': 'The circle has no straight side at all.',
      'es': 'El círculo no tiene ningún lado recto.',
      'ar': 'الدائرة ليس لها أي ضلع مستقيم.',
    },
    isTrue: true,
    explanation: {
      'fr':
          "C'est vrai ! Le contour du cercle est une courbe, sans aucune ligne droite.",
      'en':
          "That's true! A circle's outline is a curve, with no straight line at all.",
      'es':
          '¡Es verdad! El contorno del círculo es una curva, sin ninguna línea recta.',
      'ar': 'هذا صحيح! محيط الدائرة منحنٍ، بلا أي خط مستقيم.',
    },
  ),
  ShapeStatement(
    display: {
      'fr': 'Le parallélogramme a ses côtés opposés parallèles.',
      'en': 'The parallelogram has parallel opposite sides.',
      'es': 'El paralelogramo tiene los lados opuestos paralelos.',
      'ar': 'متوازي الأضلاع له أضلاع متقابلة متوازية.',
    },
    isTrue: true,
    explanation: {
      'fr':
          "C'est vrai ! Dans un parallélogramme, les côtés opposés sont "
          'toujours parallèles et de même longueur.',
      'en':
          "That's true! In a parallelogram, opposite sides are always "
          'parallel and the same length.',
      'es':
          '¡Es verdad! En un paralelogramo, los lados opuestos siempre son '
          'paralelos y tienen la misma longitud.',
      'ar':
          'هذا صحيح! في متوازي الأضلاع، الأضلاع المتقابلة متوازية دائمًا '
          'ومتساوية في الطول.',
    },
  ),
  ShapeStatement(
    display: {
      'fr': 'Le parallélogramme a ses 4 côtés égaux.',
      'en': 'The parallelogram has 4 equal sides.',
      'es': 'El paralelogramo tiene sus 4 lados iguales.',
      'ar': 'متوازي الأضلاع له 4 أضلاع متساوية.',
    },
    isTrue: false,
    explanation: {
      'fr':
          'En fait, seuls les côtés opposés du parallélogramme sont égaux, '
          'pas forcément tous les 4 !',
      'en':
          "Actually, only the parallelogram's opposite sides are equal, "
          'not necessarily all 4!',
      'es':
          'En realidad, solo los lados opuestos del paralelogramo son '
          'iguales, ¡no necesariamente los 4!',
      'ar':
          'في الحقيقة، فقط الأضلاع المتقابلة في متوازي الأضلاع متساوية، '
          'وليس بالضرورة الأربعة جميعًا!',
    },
  ),
  ShapeStatement(
    display: {
      'fr': 'Le losange a 4 côtés égaux.',
      'en': 'The rhombus has 4 equal sides.',
      'es': 'El rombo tiene 4 lados iguales.',
      'ar': 'المعين له 4 أضلاع متساوية.',
    },
    isTrue: true,
    explanation: {
      'fr': "C'est vrai ! Les 4 côtés du losange ont toujours la même longueur.",
      'en': "That's true! A rhombus's 4 sides are always the same length.",
      'es':
          '¡Es verdad! Los 4 lados del rombo siempre tienen la misma '
          'longitud.',
      'ar': 'هذا صحيح! أضلاع المعين الأربعة متساوية دائمًا في الطول.',
    },
  ),
  ShapeStatement(
    display: {
      'fr': 'Le losange a des coins bien droits.',
      'en': 'The rhombus has straight corners.',
      'es': 'El rombo tiene esquinas rectas.',
      'ar': 'المعين له زوايا قائمة.',
    },
    isTrue: false,
    explanation: {
      'fr':
          'En fait, les coins du losange ne sont pas droits : ils sont '
          'pointus en haut et en bas !',
      'en':
          "Actually, a rhombus's corners aren't straight: they're pointy "
          'at the top and bottom!',
      'es':
          'En realidad, las esquinas del rombo no son rectas: ¡son '
          'puntiagudas arriba y abajo!',
      'ar': 'في الحقيقة، زوايا المعين ليست قائمة: فهي مدببة من فوق ومن تحت!',
    },
  ),
];
