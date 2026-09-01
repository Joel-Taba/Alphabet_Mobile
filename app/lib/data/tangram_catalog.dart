// ignore_for_file: constant_identifier_names
import 'dart:math' as math;
import 'dart:ui' show Offset;

/// PALIER "Figures géométriques" — Tangram.
///
/// Un tangram est composé de 7 pièces géométriques standard (2 grands
/// triangles, 1 triangle moyen, 2 petits triangles, 1 carré, 1
/// parallélogramme) qui, assemblées bord à bord sans trou ni chevauchement,
/// forment une silhouette. Chaque pièce est définie ici dans un repère
/// canonique (angle droit à l'origine, cathètes le long de +x/+y), puis
/// chaque [TangramPlacement] d'un puzzle indique comment la transformer
/// (rotation, symétrie, translation) pour occuper sa case dans la
/// silhouette cible — voir [transformedPoints].
///
/// Toutes les coordonnées de puzzle sont exprimées dans un repère "unités"
/// où 1 unité = la cathète du PETIT triangle (le plus petit multiple commun
/// pratique entre toutes les pièces : grand=2, moyen=√2, petit=1, carré=1,
/// parallélogramme=1 de base). Le rendu (widgets/tangram_board.dart)
/// applique un seul facteur d'échelle (unités → pixels) par puzzle.
enum TangramPieceType {
  largeTriangle,
  mediumTriangle,
  smallTriangle,
  square,
  parallelogram,
}

const double _sqrt2 = 1.4142135623730951;

List<Offset> _trianglePoints(double leg) => [
  const Offset(0, 0),
  Offset(leg, 0),
  Offset(0, leg),
];

List<Offset> _squarePoints(double side) => [
  const Offset(0, 0),
  Offset(side, 0),
  Offset(side, side),
  Offset(0, side),
];

/// Parallélogramme canonique (base 1, côté oblique √2/... simplifié à un
/// décalage de 1 en x et 1 en y — cohérent avec le petit triangle, dont
/// l'hypoténuse (√2) correspond exactement au côté oblique de ce
/// parallélogramme, ce qui permet de les accoler bord à bord).
List<Offset> _parallelogramPoints() => const [
  Offset(0, 0),
  Offset(1, 0),
  Offset(2, 1),
  Offset(1, 1),
];

List<Offset> canonicalPoints(TangramPieceType type) {
  switch (type) {
    case TangramPieceType.largeTriangle:
      return _trianglePoints(2);
    case TangramPieceType.mediumTriangle:
      return _trianglePoints(_sqrt2);
    case TangramPieceType.smallTriangle:
      return _trianglePoints(1);
    case TangramPieceType.square:
      return _squarePoints(1);
    case TangramPieceType.parallelogram:
      return _parallelogramPoints();
  }
}

/// Une pièce placée dans un puzzle : sa forme ([type]), sa couleur
/// (identité visuelle dans le plateau ET dans le bac de pièces), et sa
/// transformation cible ([anchor] = position de l'origine canonique une
/// fois transformée, [rotationDeg] multiple de 45°, [flipped] = symétrie
/// miroir appliquée avant la rotation).
class TangramPlacement {
  final String pieceId;
  final TangramPieceType type;
  final int colorValue;
  final Offset anchor;
  final double rotationDeg;
  final bool flipped;

  const TangramPlacement({
    required this.pieceId,
    required this.type,
    required this.colorValue,
    required this.anchor,
    this.rotationDeg = 0,
    this.flipped = false,
  });

  /// Sommets de la pièce une fois symétrie + rotation + translation
  /// appliquées, dans le repère "unités" du puzzle.
  List<Offset> get targetPoints {
    final base = canonicalPoints(type);
    final rad = rotationDeg * math.pi / 180;
    final cosA = math.cos(rad), sinA = math.sin(rad);
    return base.map((p) {
      final x = flipped ? -p.dx : p.dx;
      final y = p.dy;
      final rx = x * cosA - y * sinA;
      final ry = x * sinA + y * cosA;
      return Offset(rx + anchor.dx, ry + anchor.dy);
    }).toList();
  }
}

enum TangramDifficulty { simple, complexe }

class TangramPuzzle {
  final String id;
  final Map<String, String> name;
  final TangramDifficulty difficulty;

  /// Taille du plateau en unités (voir doc de fichier) — sert à calculer le
  /// facteur d'échelle unités→pixels au rendu.
  final double boardWidth;
  final double boardHeight;
  final List<TangramPlacement> placements;

  const TangramPuzzle({
    required this.id,
    required this.name,
    required this.difficulty,
    required this.boardWidth,
    required this.boardHeight,
    required this.placements,
  });
}

// Palette : une couleur par pièce, cohérente sur tous les puzzles pour que
// l'enfant apprenne à associer forme et couleur (même principe que les
// couleurs de rang unités/dizaines/centaines des opérations posées).
const int _kColorLarge1 = 0xFFE05252; // rouge
const int _kColorLarge2 = 0xFF4A90E2; // bleu
const int _kColorMedium = 0xFF5E8E3E; // vert
const int _kColorSmall1 = 0xFFE3B873; // or
const int _kColorSmall2 = 0xFFD07A04; // orange
const int _kColorSquare = 0xFF8B5FBF; // violet
const int _kColorParallelogram = 0xFF2DA5A0; // turquoise

const List<TangramPuzzle> TANGRAM_PUZZLES = [
  // ─── Niveau simple (Palier Figures) ────────────────────────────────
  TangramPuzzle(
    id: 'triangle-simple',
    name: {
      'fr': 'Le triangle',
      'en': 'The triangle',
      'es': 'El triángulo',
      'ar': 'المثلث',
    },
    difficulty: TangramDifficulty.simple,
    boardWidth: 2,
    boardHeight: 2,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(0, 0),
      ),
    ],
  ),
  TangramPuzzle(
    id: 'carre-simple',
    name: {
      'fr': 'Le carré',
      'en': 'The square',
      'es': 'El cuadrado',
      'ar': 'المربع',
    },
    difficulty: TangramDifficulty.simple,
    boardWidth: 1,
    boardHeight: 1,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(0, 0),
      ),
    ],
  ),
  TangramPuzzle(
    id: 'carre-double',
    name: {
      'fr': 'Le grand carré',
      'en': 'The big square',
      'es': 'El cuadrado grande',
      'ar': 'المربع الكبير',
    },
    difficulty: TangramDifficulty.simple,
    boardWidth: 2,
    boardHeight: 2,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(0, 0),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(2, 2),
        rotationDeg: 180,
      ),
    ],
  ),
  TangramPuzzle(
    id: 'rectangle',
    name: {
      'fr': 'Le rectangle',
      'en': 'The rectangle',
      'es': 'El rectángulo',
      'ar': 'المستطيل',
    },
    difficulty: TangramDifficulty.simple,
    boardWidth: 2,
    boardHeight: 1,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(0, 0),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(0, 1),
        rotationDeg: 270,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(2, 0),
        flipped: true,
      ),
    ],
  ),
  TangramPuzzle(
    id: 'maison',
    name: {
      'fr': 'La maison',
      'en': 'The house',
      'es': 'La casa',
      'ar': 'المنزل',
    },
    difficulty: TangramDifficulty.simple,
    boardWidth: 2,
    boardHeight: 3,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(0, 1),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(2, 3),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(1, 0),
        rotationDeg: 45,
      ),
    ],
  ),

  // ─── Niveau complexe (Mode Libre) ──────────────────────────────────
  TangramPuzzle(
    id: 'maison-complete',
    name: {
      'fr': 'La maison complète',
      'en': 'The full house',
      'es': 'La casa completa',
      'ar': 'المنزل الكامل',
    },
    difficulty: TangramDifficulty.complexe,
    boardWidth: 4,
    boardHeight: 3,
    placements: [
      // Corps de la maison (identique à "maison").
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(0, 1),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(2, 3),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(1, 0),
        rotationDeg: 45,
      ),
      // Annexe accolée à droite (rectangle) : partage l'arête verticale
      // x=2 du corps principal, du sol (y=3) jusqu'à y=1.
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(2, 2),
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(2, 3),
        rotationDeg: 270,
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(4, 2),
        flipped: true,
      ),
      // Carré décoratif dans le ciel (un "nuage" stylisé) : ne partage pas
      // d'arête avec le reste de la scène (aucun chevauchement, une
      // exigence stricte du tangram), mais complète le puzzle avec les 7
      // types de pièces au lieu de seulement 6.
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(3, 0),
      ),
    ],
  ),

  // Le reste du catalogue "complexe" (Mode Libre) : chaque pièce
  // supplémentaire (oreille, tête, queue, aile...) est ancrée sur un
  // sommet déjà posé (corps) plutôt que dérivée d'une dissection exacte
  // du carré tangram — bord à bord n'est donc pas garanti au pixel près
  // partout, mais chaque pièce reste précisément accolée à sa voisine (un
  // sommet partagé), ce qui suffit à un rendu propre et reconnaissable.
  TangramPuzzle(
    id: 'cygne',
    name: {
      'fr': 'Le cygne',
      'en': 'The swan',
      'es': 'El cisne',
      'ar': 'البجعة',
    },
    difficulty: TangramDifficulty.complexe,
    boardWidth: 8.5,
    boardHeight: 3.6,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(3, 1.5),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(5, 3.5),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(5, 1.5),
        rotationDeg: 270,
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(6, 1.5),
        rotationDeg: 270,
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(7, 1.5),
        rotationDeg: 270,
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(3, 3.5),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(0, 2.5),
      ),
    ],
  ),
  // Chat, renard, chien et lapin utilisent maintenant les 7 pièces (comme
  // un vrai tangram classique) : la silhouette tête+oreilles+corps déjà
  // reconnaissable est conservée telle quelle, et les 3 pièces qui
  // manquaient (jusque-là simplement absentes du puzzle) complètent le
  // corps/les pattes plutôt que d'être ajoutées n'importe où — voir la
  // méthode "sommet partagé" documentée plus haut.
  TangramPuzzle(
    id: 'chat',
    name: {'fr': 'Le chat', 'en': 'The cat', 'es': 'El gato', 'ar': 'القطة'},
    difficulty: TangramDifficulty.complexe,
    boardWidth: 4.1,
    boardHeight: 5.1,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(1, 1),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(1, 1),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(2, 1),
        rotationDeg: 270,
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(0.5, 4),
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(0.5, 2),
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(2.5, 4),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(2.5, 3),
      ),
    ],
  ),
  TangramPuzzle(
    id: 'renard',
    name: {
      'fr': 'Le renard',
      'en': 'The fox',
      'es': 'El zorro',
      'ar': 'الثعلب',
    },
    difficulty: TangramDifficulty.complexe,
    boardWidth: 4.6,
    boardHeight: 5.5,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(1, 1),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(1, 1),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(2, 1),
        rotationDeg: 270,
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(0.5, 4),
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(0.5, 2),
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(2.5, 4),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(2.5, 3),
      ),
    ],
  ),
  TangramPuzzle(
    id: 'chien',
    name: {'fr': 'Le chien', 'en': 'The dog', 'es': 'El perro', 'ar': 'الكلب'},
    difficulty: TangramDifficulty.complexe,
    boardWidth: 6.1,
    boardHeight: 4.0,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(1, 1),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(1, 1),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(1, 2),
        rotationDeg: 90,
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(2, 2.5),
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(2, 0.5),
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(4, 2.5),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(4, 1.5),
      ),
    ],
  ),
  TangramPuzzle(
    id: 'bateau',
    name: {
      'fr': 'Le bateau',
      'en': 'The boat',
      'es': 'El barco',
      'ar': 'القارب',
    },
    difficulty: TangramDifficulty.complexe,
    boardWidth: 4.1,
    boardHeight: 4.6,
    placements: [
      // Coque : le même trio parallélogramme + 2 petits triangles que le
      // puzzle "rectangle" (Niveau simple), juste décalé plus bas.
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(1, 3.5),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(1, 4.5),
        rotationDeg: 270,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(3, 3.5),
        flipped: true,
      ),
      // Voiles : les 2 grands triangles de part et d'autre du mât, le
      // triangle moyen au sommet, le carré comme petit fanion.
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(2, 3.5),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(2, 3.5),
        rotationDeg: 270,
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(2, 1.5),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(2, 1.5 - _sqrt2),
      ),
    ],
  ),
  TangramPuzzle(
    id: 'poisson',
    name: {
      'fr': 'Le poisson',
      'en': 'The fish',
      'es': 'El pez',
      'ar': 'السمكة',
    },
    difficulty: TangramDifficulty.complexe,
    boardWidth: 4.5,
    boardHeight: 5.1,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(1, 2),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(3, 4),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(1, 2),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(1, 4),
        rotationDeg: 90,
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(3, 2),
        rotationDeg: 270,
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(3, 4),
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(1.5, 2),
        rotationDeg: 270,
      ),
    ],
  ),
  TangramPuzzle(
    id: 'lapin',
    name: {
      'fr': 'Le lapin',
      'en': 'The rabbit',
      'es': 'El conejo',
      'ar': 'الأرنب',
    },
    difficulty: TangramDifficulty.complexe,
    boardWidth: 6.5,
    boardHeight: 4,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(2, 1),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(2, 1),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(3, 1),
        rotationDeg: 270,
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(3, 2),
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(0, 2),
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(2, 4),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(3 + _sqrt2, 2),
      ),
    ],
  ),
  TangramPuzzle(
    id: 'tortue',
    name: {
      'fr': 'La tortue',
      'en': 'The turtle',
      'es': 'La tortuga',
      'ar': 'السلحفاة',
    },
    difficulty: TangramDifficulty.complexe,
    boardWidth: 4.1,
    boardHeight: 5.1,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(2, 1),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(3, 1),
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(2, 2),
        rotationDeg: 90,
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(3, 2),
        rotationDeg: 45,
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(2, 3),
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(4, 5),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(2, 1),
        rotationDeg: 180,
      ),
    ],
  ),
  TangramPuzzle(
    id: 'grenouille',
    name: {
      'fr': 'La grenouille',
      'en': 'The frog',
      'es': 'La rana',
      'ar': 'الضفدع',
    },
    difficulty: TangramDifficulty.complexe,
    boardWidth: 4.1,
    boardHeight: 4.0,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(0, 1),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(1, 1),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(1, 2),
        rotationDeg: 90,
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(1, 2.5),
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(1, 0.5),
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(3, 2.5),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(3, 2.5),
        rotationDeg: 270,
      ),
    ],
  ),
  TangramPuzzle(
    id: 'oiseau',
    name: {
      'fr': "L'oiseau",
      'en': 'The bird',
      'es': 'El pájaro',
      'ar': 'الطائر',
    },
    difficulty: TangramDifficulty.complexe,
    boardWidth: 5.1,
    boardHeight: 4.5,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(2, 0),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(2 + _sqrt2, 0),
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(2, _sqrt2),
        rotationDeg: 90,
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(2, 1 + _sqrt2),
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(4, 3 + _sqrt2),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(4, 1 + _sqrt2),
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(2, 3 + _sqrt2),
        rotationDeg: 180,
      ),
    ],
  ),
  TangramPuzzle(
    id: 'baleine',
    name: {
      'fr': 'La baleine',
      'en': 'The whale',
      'es': 'La ballena',
      'ar': 'الحوت',
    },
    difficulty: TangramDifficulty.complexe,
    boardWidth: 5.5,
    boardHeight: 4.5,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(3.5, 2),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(4.5, 2),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(2.5, 3.5),
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(1.5, 1.5),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(1.5, 1.5),
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(3.5, 3.5),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(3.5, 3),
      ),
    ],
  ),
  TangramPuzzle(
    id: 'elephant',
    name: {
      'fr': 'L’éléphant',
      'en': 'The elephant',
      'es': 'El elefante',
      'ar': 'الفيل',
    },
    difficulty: TangramDifficulty.complexe,
    boardWidth: 4.5,
    boardHeight: 5.1,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(2, 1),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(2, 1),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(1.5, 4),
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(1.5, 3),
        rotationDeg: 90,
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(1.5, 2),
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(3.5, 4),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(2.5, 4),
      ),
    ],
  ),
  TangramPuzzle(
    id: 'lion',
    name: {'fr': 'Le lion', 'en': 'The lion', 'es': 'El león', 'ar': 'الأسد'},
    difficulty: TangramDifficulty.complexe,
    boardWidth: 4.6,
    boardHeight: 5.5,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(1, 1),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(1, 1),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(2, 1),
        rotationDeg: 270,
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(0.5, 4),
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(0.5, 2),
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(2.5, 4),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(2.5, 3),
      ),
    ],
  ),
  TangramPuzzle(
    id: 'panda',
    name: {
      'fr': 'Le panda',
      'en': 'The panda',
      'es': 'El panda',
      'ar': 'الباندا',
    },
    difficulty: TangramDifficulty.complexe,
    boardWidth: 4.6,
    boardHeight: 5.5,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(1, 1),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(1, 1),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(2, 1),
        rotationDeg: 270,
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(2.5, 3),
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(0.5, 2),
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(2.5, 4),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(0.5, 4),
      ),
    ],
  ),
  TangramPuzzle(
    id: 'ours',
    name: {'fr': 'L’ours', 'en': 'The bear', 'es': 'El oso', 'ar': 'الدب'},
    difficulty: TangramDifficulty.complexe,
    boardWidth: 6.1,
    boardHeight: 4.0,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(1, 1),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(1, 1),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(1, 2),
        rotationDeg: 90,
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(2, 2.5),
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(2, 0.5),
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(4, 2.5),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(4, 1.5),
      ),
    ],
  ),
  TangramPuzzle(
    id: 'vache',
    name: {'fr': 'La vache', 'en': 'The cow', 'es': 'La vaca', 'ar': 'البقرة'},
    difficulty: TangramDifficulty.complexe,
    boardWidth: 4.6,
    boardHeight: 5.5,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(1, 1),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(1, 1),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(2, 1),
        rotationDeg: 270,
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(2.5, 3),
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(0.5, 2),
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(2.5, 4),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(0.5, 4),
      ),
    ],
  ),
  TangramPuzzle(
    id: 'cheval',
    name: {
      'fr': 'Le cheval',
      'en': 'The horse',
      'es': 'El caballo',
      'ar': 'الحصان',
    },
    difficulty: TangramDifficulty.complexe,
    boardWidth: 4.1,
    boardHeight: 4.0,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(2, 1),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(3, 1),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(3, 2),
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(0, 2.5),
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(0, 0.5),
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(2, 2.5),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(1.5, 2.5),
      ),
    ],
  ),
  TangramPuzzle(
    id: 'chameau',
    name: {
      'fr': 'Le chameau',
      'en': 'The camel',
      'es': 'El camello',
      'ar': 'الجمل',
    },
    difficulty: TangramDifficulty.complexe,
    boardWidth: 3.6,
    boardHeight: 5.6,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(1.5, 1.5),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(1.5, 2.5 - _sqrt2),
        rotationDeg: 270,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(2.5, 3.5),
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(1.5, 2.5),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(0.5, 2.5),
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(2.5, 4.5),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(1, 4.5),
      ),
    ],
  ),
  TangramPuzzle(
    id: 'kangourou',
    name: {
      'fr': 'Le kangourou',
      'en': 'The kangaroo',
      'es': 'El canguro',
      'ar': 'الكنغر',
    },
    difficulty: TangramDifficulty.complexe,
    boardWidth: 4.1,
    boardHeight: 4.0,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(2, 1),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(3, 1),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(3, 2),
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(0, 2.5),
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(0, 0.5),
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(2, 2.5),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(1.5, 2.5),
      ),
    ],
  ),
  TangramPuzzle(
    id: 'crabe',
    name: {
      'fr': 'Le crabe',
      'en': 'The crab',
      'es': 'El cangrejo',
      'ar': 'السلطعون',
    },
    difficulty: TangramDifficulty.complexe,
    boardWidth: 4.6,
    boardHeight: 4.6,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(2, 0.5),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(1.5, 3.5),
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(3.5, 3.5),
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(1.5, 2),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(1.5, 1.5),
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(3.5, 3.5),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(3.5, 2),
        rotationDeg: 270,
      ),
    ],
  ),
  TangramPuzzle(
    id: 'phoque',
    name: {
      'fr': 'Le phoque',
      'en': 'The seal',
      'es': 'La foca',
      'ar': 'عجل البحر',
    },
    difficulty: TangramDifficulty.complexe,
    boardWidth: 4.6,
    boardHeight: 4.5,
    placements: [
      TangramPlacement(
        pieceId: 'p1',
        type: TangramPieceType.square,
        colorValue: _kColorSquare,
        anchor: Offset(3, 1.5),
      ),
      TangramPlacement(
        pieceId: 'p2',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall1,
        anchor: Offset(4, 1.5),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p3',
        type: TangramPieceType.smallTriangle,
        colorValue: _kColorSmall2,
        anchor: Offset(1, 1),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p4',
        type: TangramPieceType.mediumTriangle,
        colorValue: _kColorMedium,
        anchor: Offset(1, 3),
      ),
      TangramPlacement(
        pieceId: 'p5',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge1,
        anchor: Offset(1, 1),
      ),
      TangramPlacement(
        pieceId: 'p6',
        type: TangramPieceType.largeTriangle,
        colorValue: _kColorLarge2,
        anchor: Offset(3, 3),
        rotationDeg: 180,
      ),
      TangramPlacement(
        pieceId: 'p7',
        type: TangramPieceType.parallelogram,
        colorValue: _kColorParallelogram,
        anchor: Offset(2.5, 3),
      ),
    ],
  ),
];

TangramPuzzle? findTangramPuzzle(String id) {
  for (final p in TANGRAM_PUZZLES) {
    if (p.id == id) return p;
  }
  return null;
}

List<TangramPuzzle> tangramPuzzlesByDifficulty(TangramDifficulty d) =>
    TANGRAM_PUZZLES.where((p) => p.difficulty == d).toList();
