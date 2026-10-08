// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:math' as math;
import 'dart:ui' show Color, Offset;
import 'package:flutter/widgets.dart' show Alignment, Axis;
import 'package:vector_math/vector_math_64.dart' show Matrix4, Vector3;

/// PALIER "Figures géométriques" — Solides 3D.
///
/// Remplace les anciennes étapes "Tangram" du parcours (`triangle-simple`,
/// `carre-simple`, `carre-double`, `rectangle`, `maison` --
/// `TangramDifficulty.simple` dans `tangram_catalog.dart`, qui étaient
/// verrouillées en permanence dans le parcours réel, voir
/// `parcours_screen.dart`) par de véritables solides construits à partir
/// des figures planes déjà vues : un cube (6 carrés), un pavé droit (6
/// rectangles), une pyramide à base carrée (1 carré + 4 triangles), un
/// prisme droit à base triangulaire (2 triangles + 2 rectangles + 1
/// rectangle de base) -- puis trois solides à surface courbe, dont le patron
/// est calculé automatiquement par [_unfold] : le cylindre (2 disques + un
/// rectangle enroulé), le cône (un disque + un éventail) et la sphère
/// (découpée en quartiers, comme une peau d'orange).
///
/// Chaque [SolidFace] décrit comment ce panneau se replie depuis le patron
/// à plat jusqu'au solide fermé (voir `widgets/solid_fold_animation.dart`) :
/// [flatOffset] est sa position à plat relative à l'origine de son parent
/// ([parentIndex], -1 pour la face racine, jamais animée), [hinge] est le
/// point de pivot (dans le repère LOCAL de la face elle-même, ex.
/// `Alignment(0,1)` = bas-centre), [axis]/[sign] l'axe et le sens de
/// rotation, [targetAngleDeg] l'angle final : 90° pour un pliage "boîte"
/// (cube, pavé, embouts du prisme), ou l'angle qui fait converger les faces
/// vers une arête/un sommet pour la pyramide et le toit du prisme --
/// θ = atan2(hauteur, base/2), démontré dans le plan d'implémentation
/// (triangle rectangle formé par le pli, hypoténuse = pente de la face).
enum SolidFaceShape { square, rectangle, triangle }

class SolidFace {
  final SolidFaceShape shape;
  final double width;
  final double height;
  final Offset flatOffset;
  final Alignment hinge;
  final Axis axis;
  final double sign;
  final double targetAngleDeg;
  final int parentIndex;

  const SolidFace({
    required this.shape,
    required this.width,
    required this.height,
    required this.flatOffset,
    required this.hinge,
    required this.axis,
    required this.sign,
    required this.targetAngleDeg,
    required this.parentIndex,
  });
}

class Solid3DTopic {
  final String id;
  final Map<String, String> name;
  final Map<String, String> funFactTitle;
  final Map<String, String> funFactBody;
  final Map<String, String> volumeFormula;
  final List<NetFace> faces;

  const Solid3DTopic({
    required this.id,
    required this.name,
    required this.funFactTitle,
    required this.funFactBody,
    required this.volumeFormula,
    required this.faces,
  });
}

/// Face du patron telle que l'anime `SolidFoldAnimation` : un polygone
/// quelconque exprimé directement dans le repère du patron posé à plat
/// (plan z = 0, le solide se forme du côté z < 0, vers l'observateur).
///
/// Une face enfant pivote autour de la charnière [hingeA]→[hingeB] (arête
/// partagée avec son parent, en coordonnées du patron) d'un angle final
/// [angle] (radians, règle de la main droite autour de l'axe A→B). Les
/// faces de même [step] se replient en même temps : une face à la fois pour
/// les solides "boîte", mais toute la surface courbe d'un coup pour le
/// cylindre, le cône et la sphère (le rectangle s'enroule, l'éventail se
/// referme, les quartiers de la pelure d'orange se rejoignent). [smooth]
/// marque une facette de surface courbe : pas de liseré d'arête, pour que
/// les facettes se fondent en une surface lisse.
class NetFace {
  final List<Offset> polygon;
  final int parentIndex;
  final Offset hingeA;
  final Offset hingeB;
  final double angle;
  final int step;
  final bool smooth;

  const NetFace({
    required this.polygon,
    required this.parentIndex,
    this.hingeA = Offset.zero,
    this.hingeB = Offset.zero,
    this.angle = 0,
    this.step = 0,
    this.smooth = false,
  });
}

/// Rotation d'une face autour de sa charnière, à l'avancement [t] (0 = à
/// plat, 1 = pliée), en coordonnées du patron.
Matrix4 hingeMatrix(NetFace f, double t) {
  final a = f.hingeA;
  final d = f.hingeB - f.hingeA;
  return Matrix4.identity()
    ..translateByDouble(a.dx, a.dy, 0.0, 1.0)
    ..rotate(Vector3(d.dx, d.dy, 0), f.angle * t)
    ..translateByDouble(-a.dx, -a.dy, 0.0, 1.0);
}

/// Matrice (patron à plat → 3D) de chaque face : celle de son parent
/// composée avec sa propre rotation autour de la charnière, [progressOf]
/// donnant l'avancement du pliage de chaque face (0→1). Utilisé par
/// l'animation (`SolidFoldAnimation`) et par les tests, qui vérifient qu'à
/// 1 chaque solide se referme exactement.
List<Matrix4> foldMatrices(
  List<NetFace> faces,
  double Function(NetFace face) progressOf,
) {
  final absolute = <Matrix4>[];
  for (final f in faces) {
    if (f.parentIndex == -1) {
      absolute.add(Matrix4.identity());
      continue;
    }
    absolute.add(
      absolute[f.parentIndex].clone()..multiply(hingeMatrix(f, progressOf(f))),
    );
  }
  return absolute;
}

/// Sommets d'une [SolidFace] dans sa boîte locale [0,width]×[0,height] --
/// pour un triangle, la base longe le bord de la charnière et le sommet
/// pointe vers le bord opposé.
List<Offset> _legacyVertices(SolidFace face) {
  final w = face.width, h = face.height;
  if (face.shape != SolidFaceShape.triangle) {
    return [Offset.zero, Offset(w, 0), Offset(w, h), Offset(0, h)];
  }
  if (face.hinge.y == 1) return [Offset(w / 2, 0), Offset(0, h), Offset(w, h)];
  if (face.hinge.y == -1) {
    return [Offset(w / 2, h), Offset.zero, Offset(w, 0)];
  }
  if (face.hinge.x == 1) return [Offset(0, h / 2), Offset(w, 0), Offset(w, h)];
  return [Offset(w, h / 2), Offset.zero, Offset(0, h)];
}

/// Convertit les patrons "boîte" décrits face par face ([SolidFace]) en
/// [NetFace] : même géométrie, une face repliée après l'autre.
List<NetFace> _fromLegacy(List<SolidFace> faces) {
  final origins = <Offset>[];
  final out = <NetFace>[];
  var step = 0;
  for (final f in faces) {
    final origin = f.parentIndex == -1
        ? Offset.zero
        : origins[f.parentIndex] + f.flatOffset;
    origins.add(origin);
    final polygon = [for (final v in _legacyVertices(f)) v + origin];
    if (f.parentIndex == -1) {
      out.add(NetFace(polygon: polygon, parentIndex: -1));
      continue;
    }
    final hinge =
        origin +
        Offset((f.hinge.x + 1) / 2 * f.width, (f.hinge.y + 1) / 2 * f.height);
    final dir = f.axis == Axis.horizontal
        ? const Offset(1, 0)
        : const Offset(0, 1);
    out.add(
      NetFace(
        polygon: polygon,
        parentIndex: f.parentIndex,
        hingeA: hinge,
        hingeB: hinge + dir,
        angle: f.targetAngleDeg * math.pi / 180 * f.sign,
        step: step++,
      ),
    );
  }
  return out;
}

/// Déplie automatiquement un solide convexe décrit par ses faces en 3D
/// (repère du patron : base posée sur z = 0, solide du côté z < 0) le long
/// de l'arbre [parents] (chaque parent doit précéder ses enfants).
///
/// Pour chaque face enfant, on la fait pivoter autour de l'arête partagée
/// avec son parent jusqu'à aligner leurs normales extérieures : elle se
/// retrouve alors dans le plan du parent, de l'autre côté de l'arête
/// (dépliage d'un polyèdre convexe). En composant ces rotations depuis la
/// racine, on obtient la position à plat de chaque face ; l'angle de
/// pliage à rejouer dans l'animation est l'opposé de l'angle de dépliage.
List<NetFace> _unfold({
  required List<List<Vector3>> polys,
  required List<int> parents,
  required List<int> steps,
  required List<bool> smooth,
}) {
  final center = Vector3.zero();
  var count = 0;
  for (final poly in polys) {
    for (final v in poly) {
      center.add(v);
      count++;
    }
  }
  center.scale(1 / count);

  Vector3 centroidOf(List<Vector3> poly) {
    final c = Vector3.zero();
    for (final v in poly) {
      c.add(v);
    }
    return c..scale(1 / poly.length);
  }

  // Normale extérieure (méthode de Newell, robuste pour tout polygone plan).
  Vector3 outwardNormal(List<Vector3> poly) {
    final n = Vector3.zero();
    for (var i = 0; i < poly.length; i++) {
      final a = poly[i], b = poly[(i + 1) % poly.length];
      n.x += (a.y - b.y) * (a.z + b.z);
      n.y += (a.z - b.z) * (a.x + b.x);
      n.z += (a.x - b.x) * (a.y + b.y);
    }
    n.normalize();
    if (n.dot(centroidOf(poly) - center) < 0) n.negate();
    return n;
  }

  Offset flat(Matrix4 m, Vector3 v) {
    final r = m.transform3(v.clone());
    return Offset(r.x, r.y);
  }

  final unfoldMatrices = <Matrix4>[];
  final out = <NetFace>[];
  for (var i = 0; i < polys.length; i++) {
    final parent = parents[i];
    if (parent == -1) {
      final m = Matrix4.identity();
      unfoldMatrices.add(m);
      out.add(
        NetFace(
          polygon: [for (final v in polys[i]) flat(m, v)],
          parentIndex: -1,
          smooth: smooth[i],
        ),
      );
      continue;
    }
    final shared = [
      for (final v in polys[i])
        if (polys[parent].any((w) => (w - v).length < 1e-6)) v,
    ];
    final a = shared[0], b = shared[1];
    final e = (b - a)..normalize();
    final nc = outwardNormal(polys[i]);
    final np = outwardNormal(polys[parent]);
    final alpha = math.atan2(e.dot(nc.cross(np)), nc.dot(np));
    final rotation = Matrix4.identity()
      ..translateByDouble(a.x, a.y, a.z, 1.0)
      ..rotate(e, alpha)
      ..translateByDouble(-a.x, -a.y, -a.z, 1.0);
    final m = unfoldMatrices[parent].clone()..multiply(rotation);
    unfoldMatrices.add(m);
    out.add(
      NetFace(
        polygon: [for (final v in polys[i]) flat(m, v)],
        parentIndex: parent,
        hingeA: flat(unfoldMatrices[parent], a),
        hingeB: flat(unfoldMatrices[parent], b),
        angle: -alpha,
        step: steps[i],
        smooth: smooth[i],
      ),
    );
  }
  return out;
}

// ─── Cylindre (rayon R, hauteur H) ─────────────────────────────────────
// Patron classique : un disque en bas, le grand rectangle (la surface
// latérale, découpée en fines bandes verticales qui s'enroulent ensemble)
// et un disque en haut, tous deux accrochés à la bande du milieu.
List<NetFace> _cylindreFaces() {
  const n = 32;
  const r = 55.0;
  const h = 120.0;
  List<Vector3> ring(double z) => [
    for (var k = 0; k < n; k++)
      Vector3(
        r * math.cos(2 * math.pi * k / n + math.pi / 2),
        r * math.sin(2 * math.pi * k / n + math.pi / 2),
        z,
      ),
  ];
  final bottom = ring(0), top = ring(-h);
  final polys = <List<Vector3>>[bottom];
  final parents = <int>[-1];
  final steps = <int>[0];
  final smooth = <bool>[false];
  final stripIndex = <int, int>{};
  void addStrip(int k, int parent) {
    final k1 = (k + 1) % n;
    stripIndex[k] = polys.length;
    polys.add([bottom[k], bottom[k1], top[k1], top[k]]);
    parents.add(parent);
    steps.add(0);
    smooth.add(true);
  }

  addStrip(0, 0);
  for (var k = 1; k <= n ~/ 2; k++) {
    addStrip(k, stripIndex[k - 1]!);
  }
  for (var k = n - 1; k > n ~/ 2; k--) {
    addStrip(k, stripIndex[(k + 1) % n]!);
  }
  polys.add(top);
  parents.add(stripIndex[0]!);
  steps.add(1);
  smooth.add(false);
  return _unfold(polys: polys, parents: parents, steps: steps, smooth: smooth);
}

double _slant(double halfBase, double height) =>
    math.sqrt(halfBase * halfBase + height * height);

/// Angle de pliage (depuis le patron à plat) pour une face qui doit
/// converger vers une arête/un sommet au-dessus du centre (triangles de la
/// pyramide, pans du toit du prisme) -- PAS l'angle d'élévation θ de la face
/// par rapport à la base (atan2(hauteur, demi-base)), mais son supplément
/// 180°-θ : replier exactement à 90° donne un panneau vertical (comme un mur
/// de boîte), donc pour qu'il penche ensuite vers l'intérieur jusqu'à
/// converger au-dessus du centre, il faut continuer la rotation AU-DELÀ de
/// la verticale. Démontré par calcul direct des coordonnées du sommet replié
/// (voir le commentaire de [SolidFace]) : avec 180°-θ, les sommets de toutes
/// les faces convergentes tombent exactement au même point.
double _foldAngleDeg(double height, double halfBase) =>
    180 - math.atan2(height, halfBase) * 180 / math.pi;

// ─── Cube (côté S) ──────────────────────────────────────────────────────
List<SolidFace> _cubeFaces() {
  const s = 120.0;
  return [
    const SolidFace(
      shape: SolidFaceShape.square,
      width: s,
      height: s,
      flatOffset: Offset(0, 0),
      hinge: Alignment(0, 0),
      axis: Axis.horizontal,
      sign: 0,
      targetAngleDeg: 0,
      parentIndex: -1,
    ),
    const SolidFace(
      shape: SolidFaceShape.square,
      width: s,
      height: s,
      flatOffset: Offset(0, -s),
      hinge: Alignment(0, 1),
      axis: Axis.horizontal,
      sign: 1,
      targetAngleDeg: 90,
      parentIndex: 0,
    ),
    const SolidFace(
      shape: SolidFaceShape.square,
      width: s,
      height: s,
      flatOffset: Offset(0, s),
      hinge: Alignment(0, -1),
      axis: Axis.horizontal,
      sign: -1,
      targetAngleDeg: 90,
      parentIndex: 0,
    ),
    const SolidFace(
      shape: SolidFaceShape.square,
      width: s,
      height: s,
      flatOffset: Offset(-s, 0),
      hinge: Alignment(1, 0),
      axis: Axis.vertical,
      sign: -1,
      targetAngleDeg: 90,
      parentIndex: 0,
    ),
    const SolidFace(
      shape: SolidFaceShape.square,
      width: s,
      height: s,
      flatOffset: Offset(s, 0),
      hinge: Alignment(-1, 0),
      axis: Axis.vertical,
      sign: 1,
      targetAngleDeg: 90,
      parentIndex: 0,
    ),
    const SolidFace(
      shape: SolidFaceShape.square,
      width: s,
      height: s,
      flatOffset: Offset(s, 0),
      hinge: Alignment(-1, 0),
      axis: Axis.vertical,
      sign: 1,
      targetAngleDeg: 90,
      parentIndex: 4, // enfant de "droite" -- referme la boîte
    ),
  ];
}

// ─── Pavé droit (longueur L, largeur l, hauteur H) ─────────────────────
List<SolidFace> _paveFaces() {
  const length = 150.0;
  const depth = 80.0;
  const height = 100.0;
  return [
    const SolidFace(
      shape: SolidFaceShape.rectangle,
      width: length,
      height: height,
      flatOffset: Offset(0, 0),
      hinge: Alignment(0, 0),
      axis: Axis.horizontal,
      sign: 0,
      targetAngleDeg: 0,
      parentIndex: -1,
    ),
    const SolidFace(
      shape: SolidFaceShape.rectangle,
      width: length,
      height: depth,
      flatOffset: Offset(0, -depth),
      hinge: Alignment(0, 1),
      axis: Axis.horizontal,
      sign: 1,
      targetAngleDeg: 90,
      parentIndex: 0,
    ),
    const SolidFace(
      shape: SolidFaceShape.rectangle,
      width: length,
      height: depth,
      flatOffset: Offset(0, height),
      hinge: Alignment(0, -1),
      axis: Axis.horizontal,
      sign: -1,
      targetAngleDeg: 90,
      parentIndex: 0,
    ),
    const SolidFace(
      shape: SolidFaceShape.rectangle,
      width: depth,
      height: height,
      flatOffset: Offset(-depth, 0),
      hinge: Alignment(1, 0),
      axis: Axis.vertical,
      sign: -1,
      targetAngleDeg: 90,
      parentIndex: 0,
    ),
    const SolidFace(
      shape: SolidFaceShape.rectangle,
      width: depth,
      height: height,
      // Décalage = largeur de la RACINE (`length`), pas la largeur propre
      // de cette face (`depth`) : la charnière de "droite" est sur son
      // propre bord GAUCHE (x=0), donc seul le décalage doit "voyager"
      // jusqu'au bord droit de la racine pour l'y accrocher -- contrairement
      // à "gauche" (charnière sur son propre bord droit), où le décalage
      // s'auto-annule quelle que soit la dimension. Pour un cube (toutes
      // dimensions égales) les deux valeurs coïncident, ce qui masquait ce
      // bug jusqu'au pavé (dimensions différentes).
      flatOffset: Offset(length, 0),
      hinge: Alignment(-1, 0),
      axis: Axis.vertical,
      sign: 1,
      targetAngleDeg: 90,
      parentIndex: 0,
    ),
    const SolidFace(
      shape: SolidFaceShape.rectangle,
      width: length,
      height: height,
      flatOffset: Offset(depth, 0),
      hinge: Alignment(-1, 0),
      axis: Axis.vertical,
      sign: 1,
      targetAngleDeg: 90,
      parentIndex: 4,
    ),
  ];
}

// ─── Pyramide à base carrée (côté S, hauteur H) ────────────────────────
List<SolidFace> _pyramideFaces() {
  const s = 120.0;
  const h = 95.0;
  final l = _slant(s / 2, h);
  final theta = _foldAngleDeg(h, s / 2);
  return [
    const SolidFace(
      shape: SolidFaceShape.square,
      width: s,
      height: s,
      flatOffset: Offset(0, 0),
      hinge: Alignment(0, 0),
      axis: Axis.horizontal,
      sign: 0,
      targetAngleDeg: 0,
      parentIndex: -1,
    ),
    SolidFace(
      shape: SolidFaceShape.triangle,
      width: s,
      height: l,
      flatOffset: Offset(0, -l),
      hinge: const Alignment(0, 1),
      axis: Axis.horizontal,
      sign: 1,
      targetAngleDeg: theta,
      parentIndex: 0,
    ),
    SolidFace(
      shape: SolidFaceShape.triangle,
      width: s,
      height: l,
      flatOffset: Offset(0, s),
      hinge: const Alignment(0, -1),
      axis: Axis.horizontal,
      sign: -1,
      targetAngleDeg: theta,
      parentIndex: 0,
    ),
    SolidFace(
      shape: SolidFaceShape.triangle,
      width: l,
      height: s,
      flatOffset: Offset(-l, 0),
      hinge: const Alignment(1, 0),
      axis: Axis.vertical,
      sign: -1,
      targetAngleDeg: theta,
      parentIndex: 0,
    ),
    SolidFace(
      shape: SolidFaceShape.triangle,
      width: l,
      height: s,
      flatOffset: Offset(s, 0),
      hinge: const Alignment(-1, 0),
      axis: Axis.vertical,
      sign: 1,
      targetAngleDeg: theta,
      parentIndex: 0,
    ),
  ];
}

final List<Solid3DTopic> SOLID3D_TOPICS = [
  Solid3DTopic(
    id: 'cube',
    name: {'fr': 'Le cube', 'en': 'The cube', 'es': 'El cubo', 'ar': 'المكعب'},
    funFactTitle: {
      'fr': 'Qu\'est-ce qu\'un cube ?',
      'en': 'What is a cube?',
      'es': '¿Qué es un cubo?',
      'ar': 'ما هو المكعب؟',
    },
    funFactBody: {
      'fr':
          'Le cube est une boîte magique dont toutes les faces sont des '
          'carrés parfaitement identiques. Qu\'on le tourne dans un sens '
          'ou dans un autre, il a exactement la même forme partout !',
      'en':
          'The cube is a magic box where all faces are perfectly identical '
          'squares. No matter which way you turn it, it looks exactly the '
          'same from every angle!',
      'es':
          '¡El cubo es una caja mágica cuyas caras son cuadrados '
          'perfectamente idénticos. ¡Lo gires como lo gires, tiene '
          'exactamente la misma forma por todos lados!',
      'ar':
          'المكعب صندوق سحري جميع أوجهه مربعات متطابقة تمامًا. '
          'مهما قلبته في أي اتجاه، يبدو بنفس الشكل من كل جانب!',
    },
    volumeFormula: {
      'fr': 'Volume = côté × côté × côté',
      'en': 'Volume = side × side × side',
      'es': 'Volumen = lado × lado × lado',
      'ar': 'الحجم = الضلع × الضلع × الضلع',
    },
    faces: _fromLegacy(_cubeFaces()),
  ),
  Solid3DTopic(
    id: 'pave',
    name: {
      'fr': 'Le pavé droit',
      'en': 'The rectangular box',
      'es': 'El prisma rectangular',
      'ar': 'متوازي المستطيلات',
    },
    funFactTitle: {
      'fr': 'Qu\'est-ce qu\'un pavé droit ?',
      'en': 'What is a rectangular box?',
      'es': '¿Qué es un prisma rectangular?',
      'ar': 'ما هو متوازي المستطيلات؟',
    },
    funFactBody: {
      'fr':
          'Le pavé droit ressemble au cube, mais il est plus étiré. '
          'Ses faces sont des rectangles (et parfois des carrés sur les côtés).',
      'en':
          'The rectangular box looks like a cube, but it is more stretched. '
          'Its faces are rectangles (and sometimes squares on the sides).',
      'es':
          'El prisma rectangular se parece al cubo, pero es más alargado. '
          'Sus caras son rectángulos (y a veces cuadrados en los lados).',
      'ar':
          'متوازي المستطيلات يشبه المكعب، لكنه أكثر امتداداً. '
          'أوجهه مستطيلات (وأحياناً مربعات على الجوانب).',
    },
    volumeFormula: {
      'fr': 'Volume = longueur × largeur × hauteur',
      'en': 'Volume = length × width × height',
      'es': 'Volumen = longitud × anchura × altura',
      'ar': 'الحجم = الطول × العرض × الارتفاع',
    },
    faces: _fromLegacy(_paveFaces()),
  ),
  Solid3DTopic(
    id: 'pyramide',
    name: {
      'fr': 'La pyramide',
      'en': 'The pyramid',
      'es': 'La pirámide',
      'ar': 'الهرم',
    },
    funFactTitle: {
      'fr': 'Qu\'est-ce qu\'une pyramide ?',
      'en': 'What is a pyramid?',
      'es': '¿Qué es una pirámide?',
      'ar': 'ما هو الهرم؟',
    },
    funFactBody: {
      'fr':
          'La pyramide a une grande base posée au sol (souvent un carré ou '
          'un triangle) et des côtés en forme de triangles qui montent '
          'tous pour se rejoindre en un seul point tout en haut.',
      'en':
          'The pyramid has a large base on the ground (often a square or '
          'a triangle) and triangular sides that all rise to meet '
          'at a single point at the very top.',
      'es':
          'La pirámide tiene una gran base en el suelo (a menudo un cuadrado '
          'o un triángulo) y lados en forma de triángulos que suben todos '
          'para unirse en un solo punto en lo más alto.',
      'ar':
          'للهرم قاعدة كبيرة على الأرض (غالباً مربع أو مثلث) وأضلاع '
          'مثلثية الشكل ترتفع جميعها لتلتقي في نقطة واحدة في القمة.',
    },
    volumeFormula: {
      'fr': 'Volume = (aire de la base × hauteur) ÷ 3',
      'en': 'Volume = (base area × height) ÷ 3',
      'es': 'Volumen = (área de la base × altura) ÷ 3',
      'ar': 'الحجم = (مساحة القاعدة × الارتفاع) ÷ 3',
    },
    faces: _fromLegacy(_pyramideFaces()),
  ),
  Solid3DTopic(
    id: 'cylindre',
    name: {
      'fr': 'Le cylindre',
      'en': 'The cylinder',
      'es': 'El cilindro',
      'ar': 'الأسطوانة',
    },
    funFactTitle: {
      'fr': 'Qu\'est-ce qu\'un cylindre ?',
      'en': 'What is a cylinder?',
      'es': '¿Qué es un cilindro?',
      'ar': 'ما هي الأسطوانة؟',
    },
    funFactBody: {
      'fr':
          'Le cylindre a deux faces toutes plates et rondes (une en haut '
          'et une en bas). Entre les deux, son corps est tout rond ! '
          'Si tu le poses à plat, il peut rouler comme un rouleau.',
      'en':
          'The cylinder has two flat round faces (one on top and one on '
          'the bottom). Between them, its body is completely round! '
          'If you lay it on its side, it can roll like a roller.',
      'es':
          'El cilindro tiene dos caras planas y redondas (una arriba y '
          'una abajo). Entre ellas, su cuerpo es completamente redondo. '
          '¡Si lo tumbas, puede rodar como un rodillo!',
      'ar':
          'للأسطوانة وجهان مسطحان ومستديران (واحد في الأعلى وواحد في الأسفل). '
          'بينهما، جسمها مستدير تمامًا! إذا وضعتها على جانبها يمكنها الدحرجة.',
    },
    volumeFormula: {
      'fr': 'Volume = π × rayon × rayon × hauteur   (π ≈ 3,14)',
      'en': 'Volume = π × radius × radius × height   (π ≈ 3.14)',
      'es': 'Volumen = π × radio × radio × altura   (π ≈ 3,14)',
      'ar': 'الحجم = π × نصف القطر × نصف القطر × الارتفاع   (π ≈ 3,14)',
    },
    faces: _cylindreFaces(),
  ),
];

Solid3DTopic? findSolid3DTopic(String id) {
  for (final topic in SOLID3D_TOPICS) {
    if (topic.id == id) return topic;
  }
  return null;
}

/// Palette "California beaches" choisie par l'utilisateur : une couleur par
/// solide, reprise à l'identique par l'animation du cours
/// (`SolidFoldAnimation`) et le schéma de l'exercice (`SolidCalcDiagram`).
const Map<String, Color> kSolidColors = {
  'cube': Color(0xFFFFC067),
  'pave': Color(0xFF66F4FF),
  'pyramide': Color(0xFF66C4FF),
  'prisme': Color(0xFF7D99AA),
  // La palette n'a que 4 teintes : on la reprend dans l'ordre pour que deux
  // solides voisins dans le parcours n'aient jamais la même couleur.
  'cylindre': Color(0xFFFFC067),
  'cone': Color(0xFF66F4FF),
  'sphere': Color(0xFF66C4FF),
};

Color solidColor(String id) => kSolidColors[id] ?? const Color(0xFF7D99AA);
