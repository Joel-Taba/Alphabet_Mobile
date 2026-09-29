// ignore_for_file: constant_identifier_names

import 'dart:math';
import '../i18n/translations.dart' show tFormat;
import 'shape_catalog.dart';

/// PALIER 6 — Exercice "Figures géométriques"
///
/// Génère un petit problème de calcul (périmètre ou aire) pour une figure du
/// catalogue (`shape_catalog.dart`), en réutilisant exactement les formules
/// déjà enseignées dans la carte "Astuces" du cours
/// (`ShapeTopic.perimeterFormula`/`areaFormula`) — même principe de
/// génération procédurale seedée que `CalculTopic.generateProblems` dans
/// `calcul_catalog.dart`.
///
/// Contrairement au Palier "Calculs", ce palier ne propose qu'UN SEUL
/// problème par page d'exercice (pas de réglage "Répétitions") : la variété
/// vient du choix aléatoire (périmètre/aire, dimensions) renouvelé à chaque
/// "Relancer", pas d'une liste.
///
/// L'énoncé est une véritable mise en situation calquée sur les exercices
/// scolaires réels (terrain, champ, bassin, jardin...), chiffres inclus
/// directement dans le texte -- pas juste "cette figure" avec des nombres
/// visibles seulement sur le schéma.
enum ShapeCalcKind { perimeter, area }

/// π arrondi à 2 décimales -- suffisant pour un calcul de cercle au niveau
/// primaire ; la réponse elle-même est ensuite arrondie à l'entier le plus
/// proche (voir [ShapeCalcProblem.isApproximate]) pour rester saisissable
/// sur un clavier limité aux chiffres 0-9, sans virgule.
const double kApproxPi = 3.14;

/// Modèles d'énoncé par figure, chiffres inclus via `{clé}` (voir
/// `ShapeCalcProblem.dimensions`, interpolés par `tFormat`). Pour les
/// figures dont le périmètre et l'aire ne portent pas sur les mêmes
/// dimensions (triangle, parallélogramme, losange), une clé distincte
/// `'<figure>_perimeter'`/`'<figure>_area'` fournit un énoncé propre à
/// chaque calcul ; sinon (carré, rectangle, cercle, mêmes dimensions dans
/// les deux cas) un seul modèle sert pour les deux, voir [_templateKey].
/// Mise en situation type "terrain/champ/bassin/jardin", calquée sur des
/// énoncés scolaires réels (ex. "Le terrain... est un carré qui mesure
/// 18 m de côté", "Un champ rectangulaire mesure 45 m de large et 69 m de
/// long", "Un bassin circulaire a un rayon de 3 m"...).
const Map<String, Map<String, String>> _STATEMENT_TEMPLATES = {
  'carre': {
    'fr': 'Un terrain carré mesure {side} m de côté.',
    'en': 'A square plot of land measures {side} m on each side.',
    'es': 'Un terreno cuadrado mide {side} m de lado.',
    'ar': 'أرضٌ مربعة الشكل طول ضلعها {side} م.',
  },
  'rectangle': {
    'fr': 'Un champ rectangulaire mesure {length} m de long et {width} m de large.',
    'en': 'A rectangular field is {length} m long and {width} m wide.',
    'es': 'Un campo rectangular mide {length} m de largo y {width} m de ancho.',
    'ar': 'حقلٌ مستطيل الشكل طوله {length} م وعرضه {width} م.',
  },
  'cercle': {
    'fr': 'Un bassin rond a un rayon de {radius} m.',
    'en': 'A round pond has a radius of {radius} m.',
    'es': 'Un estanque redondo tiene un radio de {radius} m.',
    'ar': 'بركةٌ دائرية نصف قطرها {radius} م.',
  },
  'triangle_perimeter': {
    'fr': 'Un champ triangulaire a des côtés de {a} m, {b} m et {c} m.',
    'en': 'A triangular field has sides of {a} m, {b} m and {c} m.',
    'es': 'Un terreno triangular tiene lados de {a} m, {b} m y {c} m.',
    'ar': 'حقلٌ مثلث الشكل أضلاعه {a} م و{b} م و{c} م.',
  },
  'triangle_area': {
    'fr': 'Un champ triangulaire a une base de {base} m et une hauteur de {height} m.',
    'en': 'A triangular field has a base of {base} m and a height of {height} m.',
    'es': 'Un terreno triangular tiene una base de {base} m y una altura de {height} m.',
    'ar': 'حقلٌ مثلث الشكل قاعدته {base} م وارتفاعه {height} م.',
  },
  'parallelogramme_perimeter': {
    'fr': 'Un champ en forme de parallélogramme a des côtés de {a} m et {b} m.',
    'en': 'A parallelogram-shaped field has sides of {a} m and {b} m.',
    'es': 'Un terreno en forma de paralelogramo tiene lados de {a} m y {b} m.',
    'ar': 'حقلٌ على شكل متوازي أضلاع طول ضلعيه {a} م و{b} م.',
  },
  'parallelogramme_area': {
    'fr': 'Un champ en forme de parallélogramme a une base de {base} m et une hauteur de {height} m.',
    'en': 'A parallelogram-shaped field has a base of {base} m and a height of {height} m.',
    'es': 'Un terreno en forma de paralelogramo tiene una base de {base} m y una altura de {height} m.',
    'ar': 'حقلٌ على شكل متوازي أضلاع قاعدته {base} م وارتفاعه {height} م.',
  },
  'losange_perimeter': {
    'fr': 'Un jardin en forme de losange a des côtés de {side} m.',
    'en': 'A rhombus-shaped garden has sides of {side} m.',
    'es': 'Un jardín en forma de rombo tiene lados de {side} m.',
    'ar': 'حديقةٌ على شكل معين طول ضلعها {side} م.',
  },
  'losange_area': {
    'fr': 'Un jardin en forme de losange a des diagonales de {bigDiagonal} m et {smallDiagonal} m.',
    'en': 'A rhombus-shaped garden has diagonals of {bigDiagonal} m and {smallDiagonal} m.',
    'es': 'Un jardín en forma de rombo tiene diagonales de {bigDiagonal} m y {smallDiagonal} m.',
    'ar': 'حديقةٌ على شكل معين قطراها {bigDiagonal} م و{smallDiagonal} م.',
  },
};

String _templateKey(String shapeId, ShapeCalcKind kind) {
  final kindKey =
      '${shapeId}_${kind == ShapeCalcKind.perimeter ? 'perimeter' : 'area'}';
  if (_STATEMENT_TEMPLATES.containsKey(kindKey)) return kindKey;
  return shapeId;
}

/// Énoncé complet du problème (mise en situation + chiffres réels), dans la
/// langue [lang] -- affiché avant la question de calcul proprement dite
/// (voir `exerciceFigure.calcPerimeterPrompt`/`calcAreaPrompt`).
String shapeCalcStatement(ShapeCalcProblem problem, String lang) {
  final key = _templateKey(problem.shapeId, problem.kind);
  final template = _STATEMENT_TEMPLATES[key];
  if (template == null) return '';
  final text = template[lang] ?? template['fr'] ?? '';
  return tFormat(text, problem.dimensions);
}

class ShapeCalcProblem {
  final String shapeId;
  final ShapeCalcKind kind;

  /// Dimensions nécessaires à CE problème précis, sous la forme attendue par
  /// `ShapeCalcDiagram` et par le modèle d'énoncé (`{clé}` dans
  /// `_STATEMENT_TEMPLATES`) : `side`, `length`/`width`, `a`/`b`/`c`,
  /// `base`/`height`, `radius`, `bigDiagonal`/`smallDiagonal`...
  final Map<String, int> dimensions;

  /// Réponse attendue, toujours un entier (arrondi pour le cercle).
  final int answer;

  /// `true` seulement pour le cercle : la réponse est un arrondi à l'entier
  /// le plus proche plutôt qu'une valeur exacte -- l'énoncé le précise.
  final bool isApproximate;

  const ShapeCalcProblem({
    required this.shapeId,
    required this.kind,
    required this.dimensions,
    required this.answer,
    this.isApproximate = false,
  });
}

/// Génère un unique problème pour [topic] -- [seed] varie à chaque
/// "Relancer" pour tirer un nouveau choix périmètre/aire et de nouvelles
/// dimensions.
ShapeCalcProblem generateShapeCalcProblem(ShapeTopic topic, int seed) {
  final rng = Random(seed);
  final kind = rng.nextBool() ? ShapeCalcKind.perimeter : ShapeCalcKind.area;
  return _generateOne(topic.id, kind, rng);
}

ShapeCalcProblem _generateOne(String shapeId, ShapeCalcKind kind, Random rng) {
  switch (shapeId) {
    case 'carre':
      final side = 4 + rng.nextInt(12); // 4-15 m
      return ShapeCalcProblem(
        shapeId: shapeId,
        kind: kind,
        dimensions: {'side': side},
        answer: kind == ShapeCalcKind.perimeter ? side * 4 : side * side,
      );

    case 'rectangle':
      final length = 6 + rng.nextInt(15); // 6-20 m
      var width = 3 + rng.nextInt(12); // 3-14 m
      if (width >= length) width = length - 2;
      if (width < 3) width = 3;
      return ShapeCalcProblem(
        shapeId: shapeId,
        kind: kind,
        dimensions: {'length': length, 'width': width},
        answer: kind == ShapeCalcKind.perimeter
            ? (length + width) * 2
            : length * width,
      );

    case 'triangle':
      if (kind == ShapeCalcKind.perimeter) {
        final a = 4 + rng.nextInt(12);
        final b = 4 + rng.nextInt(12);
        // Le 3e côté doit permettre de fermer le triangle (inégalité
        // triangulaire stricte) : tiré entre |a-b|+1 et a+b-1, limité à
        // 4-15 m. Auparavant tiré librement, il pouvait donner un triangle
        // impossible (ex. 7, 15, 7).
        final minC = max(4, (a - b).abs() + 1);
        final maxC = min(15, a + b - 1);
        final c = minC + rng.nextInt(maxC - minC + 1);
        return ShapeCalcProblem(
          shapeId: shapeId,
          kind: kind,
          dimensions: {'a': a, 'b': b, 'c': c},
          answer: a + b + c,
        );
      }
      final base = 4 + rng.nextInt(13); // 4-16
      var height = 3 + rng.nextInt(10); // 3-12
      if ((base * height).isOdd) height += 1;
      return ShapeCalcProblem(
        shapeId: shapeId,
        kind: kind,
        dimensions: {'base': base, 'height': height},
        answer: (base * height) ~/ 2,
      );

    case 'cercle':
      // Résultat en centièmes, en entiers (π ≈ 3,14) : on re-tire le rayon
      // tant que le résultat tombe pile sur ",5" (ex. aire du cercle de
      // rayon 5 = 78,5), arrondi ambigu pour un enfant.
      int hundredths(int r) => kind == ShapeCalcKind.perimeter
          ? 2 * 314 * r
          : 314 * r * r;
      var radius = 2 + rng.nextInt(9); // 2-10 m
      while (hundredths(radius) % 100 == 50) {
        radius = 2 + rng.nextInt(9);
      }
      final exact = hundredths(radius) / 100;
      return ShapeCalcProblem(
        shapeId: shapeId,
        kind: kind,
        dimensions: {'radius': radius},
        answer: exact.round(),
        isApproximate: true,
      );

    case 'parallelogramme':
      if (kind == ShapeCalcKind.perimeter) {
        final a = 5 + rng.nextInt(12); // 5-16
        var b = 3 + rng.nextInt(10); // 3-12
        if (b >= a) b = a - 2;
        if (b < 3) b = 3;
        return ShapeCalcProblem(
          shapeId: shapeId,
          kind: kind,
          dimensions: {'a': a, 'b': b},
          answer: (a + b) * 2,
        );
      }
      final base = 5 + rng.nextInt(12); // 5-16
      final height = 3 + rng.nextInt(10); // 3-12
      return ShapeCalcProblem(
        shapeId: shapeId,
        kind: kind,
        dimensions: {'base': base, 'height': height},
        answer: base * height,
      );

    case 'losange':
      if (kind == ShapeCalcKind.perimeter) {
        final side = 4 + rng.nextInt(12); // 4-15
        return ShapeCalcProblem(
          shapeId: shapeId,
          kind: kind,
          dimensions: {'side': side},
          answer: side * 4,
        );
      }
      final big = 6 + rng.nextInt(11); // 6-16
      var small = 3 + rng.nextInt(8); // 3-10
      if ((big * small).isOdd) small += 1;
      return ShapeCalcProblem(
        shapeId: shapeId,
        kind: kind,
        dimensions: {'bigDiagonal': big, 'smallDiagonal': small},
        answer: (big * small) ~/ 2,
      );

    default:
      // Ne devrait jamais arriver (tous les `SHAPE_TOPICS` sont couverts
      // ci-dessus) -- filet de sécurité plutôt qu'une exception qui
      // planterait l'écran.
      return ShapeCalcProblem(
        shapeId: shapeId,
        kind: kind,
        dimensions: {'side': 4},
        answer: 16,
      );
  }
}
