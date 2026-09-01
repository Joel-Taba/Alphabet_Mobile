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

  const ShapeTopic({
    required this.id,
    required this.name,
    required this.funFactTitle,
    required this.funFactBody,
    required this.sides,
    required this.corners,
    required this.hasCurvedSides,
    required this.steps,
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
      'fr': '4 côtés égaux !',
      'en': '4 equal sides!',
      'es': '¡4 lados iguales!',
      'ar': '4 أضلاع متساوية!',
    },
    funFactBody: {
      'fr':
          'Comme une fenêtre ou une case de damier ! Ses 4 côtés ont tous '
          'exactement la même longueur, et ses 4 coins sont bien droits.',
      'en':
          'Like a window or a checkerboard square! All 4 sides are exactly '
          'the same length, and all 4 corners are perfectly straight.',
      'es':
          '¡Como una ventana o una casilla de un tablero! Sus 4 lados '
          'tienen exactamente la misma longitud, y sus 4 esquinas son bien '
          'rectas.',
      'ar':
          'مثل النافذة أو مربع رقعة الشطرنج! أضلاعه الأربعة متساوية تمامًا '
          'في الطول، وزواياه الأربع قائمة تمامًا.',
    },
    sides: 4,
    corners: 4,
    hasCurvedSides: false,
    // Base (côté du bas) exactement sur la ligne d'écriture de base (y=130,
    // la ligne rouge de `CahierFrame`, système de coordonnées 200×200
    // partagé avec les lettres) — aucune figure ne doit dépasser cette
    // ligne, tout comme une lettre sans jambage.
    steps: [
      {
        'family': 'trait',
        'pathD': 'M 60 50 L 140 50',
        'startXY': [60, 50],
        'strokeColor': '#2D6BBF',
      },
      {
        'family': 'trait',
        'pathD': 'M 140 50 L 140 130',
        'startXY': [140, 50],
        'strokeColor': '#5E8E3E',
      },
      {
        'family': 'trait',
        'pathD': 'M 140 130 L 60 130',
        'startXY': [140, 130],
        'strokeColor': '#D0524A',
      },
      {
        'family': 'trait',
        'pathD': 'M 60 130 L 60 50',
        'startXY': [60, 130],
        'strokeColor': '#8B5FBF',
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
      'fr': '2 longs côtés, 2 courts côtés !',
      'en': '2 long sides, 2 short sides!',
      'es': '¡2 lados largos, 2 lados cortos!',
      'ar': 'ضلعان طويلان وضلعان قصيران!',
    },
    funFactBody: {
      'fr':
          'Comme une porte ou un écran de tablette ! Il a 4 coins bien '
          'droits, mais contrairement au carré, ses côtés ne sont pas tous '
          'pareils.',
      'en':
          'Like a door or a tablet screen! It has 4 straight corners, but '
          'unlike the square, its sides aren\'t all the same.',
      'es':
          '¡Como una puerta o la pantalla de una tableta! Tiene 4 esquinas '
          'bien rectas, pero a diferencia del cuadrado, sus lados no son '
          'todos iguales.',
      'ar':
          'مثل الباب أو شاشة الجهاز اللوحي! له 4 زوايا قائمة، لكن على عكس '
          'المربع، أضلاعه ليست كلها متساوية.',
    },
    sides: 4,
    corners: 4,
    hasCurvedSides: false,
    steps: [
      {
        'family': 'trait',
        'pathD': 'M 40 70 L 160 70',
        'startXY': [40, 70],
        'strokeColor': '#2D6BBF',
      },
      {
        'family': 'trait',
        'pathD': 'M 160 70 L 160 130',
        'startXY': [160, 70],
        'strokeColor': '#5E8E3E',
      },
      {
        'family': 'trait',
        'pathD': 'M 160 130 L 40 130',
        'startXY': [160, 130],
        'strokeColor': '#D0524A',
      },
      {
        'family': 'trait',
        'pathD': 'M 40 130 L 40 70',
        'startXY': [40, 130],
        'strokeColor': '#8B5FBF',
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
      'fr': '3 côtés, 3 coins pointus !',
      'en': '3 sides, 3 pointy corners!',
      'es': '¡3 lados, 3 esquinas puntiagudas!',
      'ar': '3 أضلاع و3 زوايا مدببة!',
    },
    funFactBody: {
      'fr':
          'Comme une part de pizza ou le toit d\'une maison ! C\'est la '
          'figure avec le moins de côtés possible.',
      'en':
          'Like a slice of pizza or the roof of a house! It\'s the shape '
          'with the fewest possible sides.',
      'es':
          '¡Como una porción de pizza o el techo de una casa! Es la figura '
          'con la menor cantidad de lados posible.',
      'ar':
          'مثل قطعة البيتزا أو سقف المنزل! إنه الشكل الذي يحتوي على أقل '
          'عدد ممكن من الأضلاع.',
    },
    sides: 3,
    corners: 3,
    hasCurvedSides: false,
    // Base exactement sur la ligne d'écriture de base (y=130).
    steps: [
      {
        'family': 'trait',
        'pathD': 'M 100 30 L 150 130',
        'startXY': [100, 30],
        'strokeColor': '#2D6BBF',
      },
      {
        'family': 'trait',
        'pathD': 'M 150 130 L 50 130',
        'startXY': [150, 130],
        'strokeColor': '#5E8E3E',
      },
      {
        'family': 'trait',
        'pathD': 'M 50 130 L 100 30',
        'startXY': [50, 130],
        'strokeColor': '#D0524A',
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
      'fr': 'Pas un seul coin !',
      'en': 'Not a single corner!',
      'es': '¡Ni una sola esquina!',
      'ar': 'لا زوايا على الإطلاق!',
    },
    funFactBody: {
      'fr':
          'Comme une roue ou une pizza entière ! Il n\'a ni côté droit ni '
          'coin : tout est rond, tout le tour.',
      'en':
          'Like a wheel or a whole pizza! It has no straight sides and no '
          'corners: it\'s round all the way around.',
      'es':
          '¡Como una rueda o una pizza entera! No tiene lados rectos ni '
          'esquinas: todo es redondo, en todo su contorno.',
      'ar':
          'مثل عجلة أو بيتزا كاملة! ليس له أضلاع مستقيمة ولا زوايا: كله '
          'مستدير طوال الوقت.',
    },
    sides: 0,
    corners: 0,
    hasCurvedSides: true,
    // Cercle tangent à la ligne de base (bas du cercle à y=130).
    steps: [
      {
        'family': 'courbe',
        'pathD': 'M 100 30 A 50 50 0 1 0 100.05 30',
        'startXY': [100, 30],
        'strokeColor': '#E05252',
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

/// Un objet du quotidien évoquant chaque figure, pour "Quel objet a cette
/// forme ?" — clé consommée par `RealisticObjectIcon`
/// (widgets/realistic_object_icon.dart), qui dessine chaque objet en
/// vectoriel ombré plutôt que d'utiliser un emoji plat.
const Map<String, String> SHAPE_OBJECT_KEY = {
  'carre': 'window',
  'rectangle': 'door',
  'triangle': 'pizza',
  'cercle': 'ball',
};

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
];
