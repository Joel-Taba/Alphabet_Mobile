// ignore_for_file: constant_identifier_names

import 'dart:math';
import '../i18n/translations.dart' show tFormat;
import 'solid3d_catalog.dart';

/// PALIER "Figures géométriques" — Exercice "Solides 3D"
///
/// Génère un unique problème de calcul de volume par page d'exercice (pas
/// de réglage "Répétitions", même principe que `shape_calc_problem.dart`
/// pour les figures planes) -- énoncé complet avec une mise en situation
/// réaliste et les mesures écrites directement dans le texte, sur le même
/// registre "terrain/réservoir" déjà en place pour le périmètre/l'aire.
const Map<String, Map<String, String>> _SOLID_STATEMENT_TEMPLATES = {
  'cube': {
    'fr': 'Une caisse cubique mesure {side} m de côté.',
    'en': 'A cubic crate measures {side} m on each side.',
    'es': 'Una caja cúbica mide {side} m de lado.',
    'ar': 'صندوقٌ مكعب طول ضلعه {side} م.',
  },
  'pave': {
    'fr':
        'Un réservoir a la forme d\'un pavé droit de {length} m de long, {width} m de large et {height} m de haut.',
    'en':
        'A tank is shaped like a rectangular box {length} m long, {width} m wide and {height} m tall.',
    'es':
        'Un depósito tiene forma de prisma rectangular de {length} m de largo, {width} m de ancho y {height} m de alto.',
    'ar':
        'خزانٌ على شكل متوازي مستطيلات طوله {length} م وعرضه {width} م وارتفاعه {height} م.',
  },
  'pyramide': {
    'fr':
        'Une tente a la forme d\'une pyramide à base carrée de {side} m de côté et {height} m de hauteur.',
    'en':
        'A tent is shaped like a square-based pyramid with a base of {side} m and a height of {height} m.',
    'es':
        'Una carpa tiene forma de pirámide de base cuadrada de {side} m de lado y {height} m de altura.',
    'ar':
        'خيمةٌ على شكل هرم قاعدته مربعة طول ضلعها {side} م وارتفاعه {height} م.',
  },
  'prisme': {
    'fr':
        'Un abri de jardin a la forme d\'un prisme triangulaire : sa base triangulaire mesure {base} m de base et {height} m de hauteur, pour une longueur de {length} m.',
    'en':
        'A garden shed is shaped like a triangular prism: its triangular base is {base} m wide and {height} m tall, over a length of {length} m.',
    'es':
        'Un cobertizo tiene forma de prisma triangular: su base triangular mide {base} m de base y {height} m de altura, con una longitud de {length} m.',
    'ar':
        'كوخُ حديقة على شكل منشور مثلثي: قاعدته المثلثة عرضها {base} م وارتفاعها {height} م، بطول {length} م.',
  },
  'cylindre': {
    'fr':
        'Une citerne d\'eau a la forme d\'un cylindre de {radius} m de rayon et {height} m de hauteur.',
    'en':
        'A water tank is shaped like a cylinder with a radius of {radius} m and a height of {height} m.',
    'es':
        'Un depósito de agua tiene forma de cilindro de {radius} m de radio y {height} m de altura.',
    'ar':
        'خزانُ ماء على شكل أسطوانة نصف قطرها {radius} م وارتفاعها {height} م.',
  },
  'cone': {
    'fr':
        'Un tas de sable a la forme d\'un cône de {radius} m de rayon et {height} m de hauteur.',
    'en':
        'A pile of sand is shaped like a cone with a radius of {radius} m and a height of {height} m.',
    'es':
        'Un montón de arena tiene forma de cono de {radius} m de radio y {height} m de altura.',
    'ar': 'كومةُ رمل على شكل مخروط نصف قطره {radius} م وارتفاعه {height} م.',
  },
  'sphere': {
    'fr':
        'Une grande boule décorative a la forme d\'une sphère de {radius} m de rayon.',
    'en':
        'A large decorative ball is shaped like a sphere with a radius of {radius} m.',
    'es':
        'Una gran bola decorativa tiene forma de esfera de {radius} m de radio.',
    'ar': 'كرةُ زينة كبيرة على شكل كرة نصف قطرها {radius} م.',
  },
};

/// Question fermante générique (comme `exerciceFigure.calcPerimeterPrompt`)
/// -- volontairement neutre ("ce solide") pour éviter tout accord de genre
/// par langue, le nom précis du solide étant déjà dans l'en-tête de l'écran.
class SolidCalcProblem {
  final String shapeId;
  final Map<String, int> dimensions;
  final int answer;

  /// Solide courbe (π ≈ 3,14) : la réponse attendue est arrondie à l'entier
  /// le plus proche, et l'écran le rappelle sous la question.
  final bool isApproximate;

  const SolidCalcProblem({
    required this.shapeId,
    required this.dimensions,
    required this.answer,
    this.isApproximate = false,
  });
}

String solidCalcStatement(SolidCalcProblem problem, String lang) {
  final template = _SOLID_STATEMENT_TEMPLATES[problem.shapeId];
  if (template == null) return '';
  final text = template[lang] ?? template['fr'] ?? '';
  return tFormat(text, problem.dimensions);
}

/// [seed] varie à chaque "Relancer" pour tirer de nouvelles dimensions.
SolidCalcProblem generateSolidCalcProblem(Solid3DTopic topic, int seed) {
  final rng = Random(seed);
  switch (topic.id) {
    case 'cube':
      final side = 2 + rng.nextInt(5); // 2-6
      return SolidCalcProblem(
        shapeId: topic.id,
        dimensions: {'side': side},
        answer: side * side * side,
      );

    case 'pave':
      final length = 3 + rng.nextInt(6); // 3-8
      final width = 2 + rng.nextInt(5); // 2-6
      final height = 2 + rng.nextInt(5); // 2-6
      return SolidCalcProblem(
        shapeId: topic.id,
        dimensions: {'length': length, 'width': width, 'height': height},
        answer: length * width * height,
      );

    case 'pyramide':
      final side = 3 + rng.nextInt(7); // 3-9
      var height = 3 + rng.nextInt(7); // 3-9
      while ((side * side * height) % 3 != 0) {
        height += 1;
      }
      return SolidCalcProblem(
        shapeId: topic.id,
        dimensions: {'side': side, 'height': height},
        answer: (side * side * height) ~/ 3,
      );

    case 'prisme':
      final base = 3 + rng.nextInt(7); // 3-9
      var height = 2 + rng.nextInt(7); // 2-8
      if ((base * height).isOdd) height += 1;
      final length = 3 + rng.nextInt(7); // 3-9
      final baseArea = (base * height) ~/ 2;
      return SolidCalcProblem(
        shapeId: topic.id,
        dimensions: {'base': base, 'height': height, 'length': length},
        answer: baseArea * length,
      );

    case 'cylindre':
    case 'cone':
    case 'sphere':
      return _roundProblem(topic.id, rng);

    default:
      // Ne devrait jamais arriver (tous les `SOLID3D_TOPICS` sont couverts
      // ci-dessus) -- filet de sécurité plutôt qu'une exception.
      return const SolidCalcProblem(
        shapeId: 'cube',
        dimensions: {'side': 3},
        answer: 27,
      );
  }
}

/// Volume × 300 en entiers (π ≈ 3,14 = 314/100, et le ÷ 3 du cône et de la
/// sphère), pour arrondir sans erreur de virgule flottante.
int _volumeTimes300(String id, int radius, int height) {
  switch (id) {
    case 'cylindre':
      return 3 * 314 * radius * radius * height;
    case 'cone':
      return 314 * radius * radius * height;
    default: // sphère
      return 4 * 314 * radius * radius * radius;
  }
}

/// Cylindre, cône, sphère : on retire des dimensions tant que le volume
/// exact tombe pile sur ",5" -- l'arrondi serait alors ambigu pour un
/// enfant (on arrondit au-dessus ou au-dessous ?).
SolidCalcProblem _roundProblem(String id, Random rng) {
  while (true) {
    final radius = id == 'sphere'
        ? 1 +
              rng.nextInt(4) // 1-4
        : 1 + rng.nextInt(5); // 1-5
    final height = 2 + rng.nextInt(8); // 2-9
    final x = _volumeTimes300(id, radius, height);
    if (x % 300 == 150) continue;
    final answer = (x + 150) ~/ 300;
    return SolidCalcProblem(
      shapeId: id,
      dimensions: id == 'sphere'
          ? {'radius': radius}
          : {'radius': radius, 'height': height},
      answer: answer,
      isApproximate: true,
    );
  }
}
