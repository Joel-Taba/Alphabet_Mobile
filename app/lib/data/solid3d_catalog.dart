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

// ─── Cône (rayon R, hauteur H) ─────────────────────────────────────────
// Patron classique : un disque et un "éventail" (portion de disque) qui
// s'enroule autour de lui jusqu'à se refermer en pointe.
List<NetFace> _coneFaces() {
  const n = 32;
  const r = 65.0;
  const h = 130.0;
  final base = [
    for (var k = 0; k < n; k++)
      Vector3(
        r * math.cos(2 * math.pi * k / n + math.pi / 2),
        r * math.sin(2 * math.pi * k / n + math.pi / 2),
        0,
      ),
  ];
  final apex = Vector3(0, 0, -h);
  final polys = <List<Vector3>>[base];
  final parents = <int>[-1];
  final steps = <int>[0];
  final smooth = <bool>[false];
  final triIndex = <int, int>{};
  void addTri(int k, int parent) {
    triIndex[k] = polys.length;
    polys.add([base[k], base[(k + 1) % n], apex]);
    parents.add(parent);
    steps.add(0);
    smooth.add(true);
  }

  addTri(0, 0);
  for (var k = 1; k <= n ~/ 2; k++) {
    addTri(k, triIndex[k - 1]!);
  }
  for (var k = n - 1; k > n ~/ 2; k--) {
    addTri(k, triIndex[(k + 1) % n]!);
  }
  return _unfold(polys: polys, parents: parents, steps: steps, smooth: smooth);
}

// ─── Sphère (rayon R) ──────────────────────────────────────────────────
// Une sphère n'a pas de vrai patron plat : on la découpe comme la peau
// d'une orange en "quartiers" (fuseaux) rattachés à une petite calotte du
// bas. À plat, cela forme une fleur ; les pétales se relèvent tous
// ensemble et se rejoignent en boule, puis la petite calotte du haut vient
// la refermer.
List<NetFace> _sphereFaces() {
  const n = 20; // quartiers
  const m = 8; // bandes de latitude par quartier
  const r = 80.0;
  const capLat = 76 * math.pi / 180;
  final lats = [for (var j = 0; j <= m; j++) -capLat + j * 2 * capLat / m];
  final baseZ = r * math.sin(capLat);
  List<Vector3> ring(double lat) => [
    for (var k = 0; k < n; k++)
      Vector3(
        r * math.cos(lat) * math.cos(2 * math.pi * k / n),
        r * math.cos(lat) * math.sin(2 * math.pi * k / n),
        -(r * math.sin(lat) + baseZ),
      ),
  ];
  final rings = [for (final lat in lats) ring(lat)];
  final polys = <List<Vector3>>[rings[0]];
  final parents = <int>[-1];
  final steps = <int>[0];
  final smooth = <bool>[true];
  var topAnchor = 0;
  for (var k = 0; k < n; k++) {
    final k1 = (k + 1) % n;
    var parent = 0;
    for (var j = 0; j < m; j++) {
      final idx = polys.length;
      polys.add([rings[j][k], rings[j][k1], rings[j + 1][k1], rings[j + 1][k]]);
      parents.add(parent);
      steps.add(0);
      smooth.add(true);
      parent = idx;
    }
    if (k == 0) topAnchor = parent;
  }
  polys.add(rings[m]);
  parents.add(topAnchor);
  steps.add(1);
  smooth.add(true);
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

// ─── Prisme droit à base triangulaire (base B, hauteur du triangle Ht,
// longueur L) ────────────────────────────────────────────────────────────
List<SolidFace> _prismeFaces() {
  const base = 100.0;
  const triHeight = 85.0;
  const length = 140.0;
  final slant = _slant(base / 2, triHeight);
  final theta = _foldAngleDeg(triHeight, base / 2);
  return [
    const SolidFace(
      shape: SolidFaceShape.rectangle,
      width: length,
      height: base,
      flatOffset: Offset(0, 0),
      hinge: Alignment(0, 0),
      axis: Axis.horizontal,
      sign: 0,
      targetAngleDeg: 0,
      parentIndex: -1,
    ),
    const SolidFace(
      shape: SolidFaceShape.triangle,
      width: triHeight,
      height: base,
      flatOffset: Offset(-triHeight, 0),
      hinge: Alignment(1, 0),
      axis: Axis.vertical,
      sign: -1,
      targetAngleDeg: 90,
      parentIndex: 0,
    ),
    const SolidFace(
      shape: SolidFaceShape.triangle,
      width: triHeight,
      height: base,
      flatOffset: Offset(length, 0),
      hinge: Alignment(-1, 0),
      axis: Axis.vertical,
      sign: 1,
      targetAngleDeg: 90,
      parentIndex: 0,
    ),
    SolidFace(
      shape: SolidFaceShape.rectangle,
      width: length,
      height: slant,
      flatOffset: Offset(0, -slant),
      hinge: const Alignment(0, 1),
      axis: Axis.horizontal,
      sign: 1,
      targetAngleDeg: theta,
      parentIndex: 0,
    ),
    SolidFace(
      shape: SolidFaceShape.rectangle,
      width: length,
      height: slant,
      flatOffset: Offset(0, base),
      hinge: const Alignment(0, -1),
      axis: Axis.horizontal,
      sign: -1,
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
      'fr': '6 carrés identiques !',
      'en': '6 identical squares!',
      'es': '¡6 cuadrados idénticos!',
      'ar': '6 مربعات متطابقة!',
    },
    funFactBody: {
      'fr':
          'Comme un dé à jouer ou un cube de sucre ! Ses 6 faces sont des '
          'carrés parfaitement identiques.',
      'en':
          'Like a dice or a sugar cube! Its 6 faces are perfectly '
          'identical squares.',
      'es':
          '¡Como un dado o un terrón de azúcar! Sus 6 caras son cuadrados '
          'perfectamente idénticos.',
      'ar': 'مثل حجر النرد أو مكعب السكر! أوجهه الستة مربعات متطابقة تمامًا.',
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
      'fr': '6 rectangles, pas tous pareils !',
      'en': '6 rectangles, not all the same!',
      'es': '¡6 rectángulos, no todos iguales!',
      'ar': '6 مستطيلات، ليست كلها متشابهة!',
    },
    funFactBody: {
      'fr':
          "Comme une boîte à chaussures ou un carton de lait ! Contrairement "
          "au cube, ses faces opposées sont identiques deux à deux, mais "
          "pas toutes les six.",
      'en':
          "Like a shoebox or a milk carton! Unlike the cube, its opposite "
          "faces match in pairs, but not all six are the same.",
      'es':
          '¡Como una caja de zapatos o un cartón de leche! A diferencia '
          'del cubo, sus caras opuestas son iguales de dos en dos, pero '
          'no las seis.',
      'ar':
          'مثل علبة حذاء أو علبة حليب! على عكس المكعب، أوجهه المتقابلة '
          'متطابقة اثنين اثنين، لكن ليست كلها الستة متشابهة.',
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
      'fr': 'Un carré et 4 triangles !',
      'en': 'A square and 4 triangles!',
      'es': '¡Un cuadrado y 4 triángulos!',
      'ar': 'مربع و4 مثلثات!',
    },
    funFactBody: {
      'fr':
          "Comme les pyramides d'Égypte ! Sa base est un carré, et 4 "
          "triangles se rejoignent tous en un seul point tout en haut.",
      'en':
          "Like the pyramids of Egypt! Its base is a square, and 4 "
          "triangles all meet at a single point at the top.",
      'es':
          '¡Como las pirámides de Egipto! Su base es un cuadrado, y 4 '
          'triángulos se juntan todos en un solo punto arriba.',
      'ar':
          'مثل أهرامات مصر! قاعدته مربعة، وتلتقي 4 مثلثات كلها في نقطة '
          'واحدة في الأعلى.',
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
    id: 'prisme',
    name: {
      'fr': 'Le prisme',
      'en': 'The prism',
      'es': 'El prisma',
      'ar': 'المنشور',
    },
    funFactTitle: {
      'fr': 'Comme une tente !',
      'en': 'Like a tent!',
      'es': '¡Como una tienda de campaña!',
      'ar': 'مثل الخيمة!',
    },
    funFactBody: {
      'fr':
          "Comme une tente de camping ou le toit d'une grange ! Deux "
          "triangles aux extrémités, et trois rectangles tout autour.",
      'en':
          "Like a camping tent or a barn roof! Two triangles at the ends, "
          "and three rectangles all around.",
      'es':
          '¡Como una tienda de campaña o el techo de un granero! Dos '
          'triángulos en los extremos, y tres rectángulos alrededor.',
      'ar':
          'مثل خيمة تخييم أو سقف حظيرة! مثلثان عند الطرفين، وثلاثة '
          'مستطيلات في الجوانب.',
    },
    volumeFormula: {
      'fr': 'Volume = aire de la base × longueur',
      'en': 'Volume = base area × length',
      'es': 'Volumen = área de la base × longitud',
      'ar': 'الحجم = مساحة القاعدة × الطول',
    },
    faces: _fromLegacy(_prismeFaces()),
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
      'fr': '2 disques et un rectangle enroulé !',
      'en': '2 discs and a rolled-up rectangle!',
      'es': '¡2 discos y un rectángulo enrollado!',
      'ar': 'قرصان ومستطيل ملفوف!',
    },
    funFactBody: {
      'fr':
          "Comme une boîte de conserve ou un tambour ! Un grand rectangle "
          "s'enroule pour faire le tour, et deux disques identiques ferment "
          "le haut et le bas.",
      'en':
          "Like a tin can or a drum! A big rectangle rolls up to go all the "
          "way round, and two identical discs close the top and the bottom.",
      'es':
          '¡Como una lata de conservas o un tambor! Un gran rectángulo se '
          'enrolla alrededor, y dos discos idénticos cierran arriba y abajo.',
      'ar':
          'مثل علبة المصبرات أو الطبل! مستطيل كبير يلتف حولها، وقرصان '
          'متطابقان يغلقان الأعلى والأسفل.',
    },
    volumeFormula: {
      'fr': 'Volume = π × rayon × rayon × hauteur   (π ≈ 3,14)',
      'en': 'Volume = π × radius × radius × height   (π ≈ 3.14)',
      'es': 'Volumen = π × radio × radio × altura   (π ≈ 3,14)',
      'ar': 'الحجم = π × نصف القطر × نصف القطر × الارتفاع   (π ≈ 3,14)',
    },
    faces: _cylindreFaces(),
  ),
  Solid3DTopic(
    id: 'cone',
    name: {'fr': 'Le cône', 'en': 'The cone', 'es': 'El cono', 'ar': 'المخروط'},
    funFactTitle: {
      'fr': 'Un disque et un éventail !',
      'en': 'A disc and a fan!',
      'es': '¡Un disco y un abanico!',
      'ar': 'قرص ومروحة!',
    },
    funFactBody: {
      'fr':
          "Comme un cornet de glace ou un chapeau de fête ! Un morceau de "
          "disque en forme d'éventail s'enroule jusqu'à former une pointe, "
          "posé sur un disque.",
      'en':
          "Like an ice-cream cone or a party hat! A fan-shaped piece of disc "
          "rolls up into a point, sitting on a disc.",
      'es':
          '¡Como un cucurucho de helado o un gorro de fiesta! Un trozo de '
          'disco en forma de abanico se enrolla hasta formar una punta, '
          'sobre un disco.',
      'ar':
          'مثل قرن المثلجات أو قبعة الحفلة! قطعة من قرص على شكل مروحة تلتف '
          'حتى تصنع رأسًا مدببًا، فوق قرص.',
    },
    volumeFormula: {
      'fr': 'Volume = (π × rayon × rayon × hauteur) ÷ 3   (π ≈ 3,14)',
      'en': 'Volume = (π × radius × radius × height) ÷ 3   (π ≈ 3.14)',
      'es': 'Volumen = (π × radio × radio × altura) ÷ 3   (π ≈ 3,14)',
      'ar': 'الحجم = (π × نصف القطر × نصف القطر × الارتفاع) ÷ 3   (π ≈ 3,14)',
    },
    faces: _coneFaces(),
  ),
  Solid3DTopic(
    id: 'sphere',
    name: {
      'fr': 'La sphère',
      'en': 'The sphere',
      'es': 'La esfera',
      'ar': 'الكرة',
    },
    funFactTitle: {
      'fr': 'Toute ronde, sans aucun bord !',
      'en': 'Perfectly round, with no edges!',
      'es': '¡Toda redonda, sin ningún borde!',
      'ar': 'مستديرة تمامًا، بلا أي حافة!',
    },
    funFactBody: {
      'fr':
          "Comme un ballon ou une orange ! Tous ses points sont à la même "
          "distance du centre. On ne peut pas l'aplatir sans la découper : "
          "comme la peau d'une orange, ses quartiers se referment en boule.",
      'en':
          "Like a ball or an orange! Every point is the same distance from "
          "the centre. You can't flatten it without cutting it: like orange "
          "peel, its segments close up into a ball.",
      'es':
          '¡Como un balón o una naranja! Todos sus puntos están a la misma '
          'distancia del centro. No se puede aplanar sin cortarla: como la '
          'piel de una naranja, sus gajos se cierran en una bola.',
      'ar':
          'مثل الكرة أو البرتقالة! كل نقاطها على المسافة نفسها من المركز. لا '
          'يمكن تسطيحها دون قصّها: مثل قشرة البرتقال، تنغلق فصوصها لتصنع كرة.',
    },
    volumeFormula: {
      'fr': 'Volume = (4 × π × rayon × rayon × rayon) ÷ 3   (π ≈ 3,14)',
      'en': 'Volume = (4 × π × radius × radius × radius) ÷ 3   (π ≈ 3.14)',
      'es': 'Volumen = (4 × π × radio × radio × radio) ÷ 3   (π ≈ 3,14)',
      'ar':
          'الحجم = (4 × π × نصف القطر × نصف القطر × نصف القطر) ÷ 3   (π ≈ 3,14)',
    },
    faces: _sphereFaces(),
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
