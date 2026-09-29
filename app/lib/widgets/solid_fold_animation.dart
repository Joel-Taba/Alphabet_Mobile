import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;
import '../data/solid3d_catalog.dart';

/// Anime le patron d'un solide (voir `Solid3DTopic.faces`) : toutes les faces
/// reposent d'abord à plat sur un plan horizontal (vu de dessus, en biais,
/// comme une feuille posée sur une table), puis se relèvent -- une par une
/// pour les solides "boîte", toute la surface courbe d'un coup pour le
/// cylindre, le cône et la sphère -- jusqu'au solide fermé. Rendu mat dans
/// la couleur du solide (palette `kSolidColors`, sans cadre autour) : chaque
/// face est ombrée selon son orientation par rapport à une lumière venant
/// du haut-gauche (éclairage de Lambert), avec une ombre douce au sol qui
/// apparaît à mesure que le solide se forme.
///
/// L'enfant peut faire pivoter la vue en gardant le doigt (ou le clic
/// souris) posé sur le dessin et en le déplaçant. Pas de bouton ici : le
/// "Relancer" vit dans le menu déroulant de l'écran (`TraceControlsToolbar`),
/// qui incrémente `replaySeed` pour rejouer l'animation.
class SolidFoldAnimation extends StatefulWidget {
  final List<NetFace> faces;
  final Color color;
  final int replaySeed;
  final double initialPitch;
  final double initialYaw;

  const SolidFoldAnimation({
    super.key,
    required this.faces,
    required this.color,
    this.replaySeed = 0,
    this.initialPitch = -1.12,
    this.initialYaw = -0.62,
  });

  @override
  State<SolidFoldAnimation> createState() => _SolidFoldAnimationState();
}

/// Part du temps total pendant laquelle le patron reste immobile à plat
/// avant le premier pliage, pour que l'enfant voie bien toutes les faces
/// posées sur le plan horizontal.
const double _kHoldFraction = 0.18;

/// Direction vers la lumière, dans le repère de la vue (x à droite, y vers
/// le bas de l'écran, z qui s'éloigne) : haut-gauche, légèrement de face.
final Vector3 _kLight = Vector3(-0.45, -0.72, -0.53)..normalize();

/// Force de la perspective (`Matrix4.setEntry(3, 2, …)`) : l'œil se trouve
/// alors en z = -1/_kPerspective dans le repère de la vue.
const double _kPerspective = 0.0011;
final Vector3 _kEye = Vector3(0, 0, -1 / _kPerspective);

class _SolidFoldAnimationState extends State<SolidFoldAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late double _pitch;
  late double _yaw;
  late int _stepCount;
  late Rect _footprint;
  late bool _roundFootprint;

  @override
  void initState() {
    super.initState();
    _pitch = widget.initialPitch;
    _yaw = widget.initialYaw;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4400),
    );
    _prepare();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  /// Calculs qui ne dépendent que du patron : nombre d'étapes de pliage et
  /// emprise au sol du solide fermé (pour placer son ombre).
  void _prepare() {
    var maxStep = -1;
    for (final f in widget.faces) {
      if (f.parentIndex != -1) maxStep = math.max(maxStep, f.step);
    }
    _stepCount = maxStep + 1;

    final closed = _absoluteMatrices(1.0);
    var minX = double.infinity, minY = double.infinity;
    var maxX = -double.infinity, maxY = -double.infinity;
    for (var i = 0; i < widget.faces.length; i++) {
      for (final v in widget.faces[i].polygon) {
        final p = closed[i].transform3(Vector3(v.dx, v.dy, 0));
        minX = math.min(minX, p.x);
        minY = math.min(minY, p.y);
        maxX = math.max(maxX, p.x);
        maxY = math.max(maxY, p.y);
      }
    }
    _footprint = Rect.fromLTRB(minX, minY, maxX, maxY);
    _roundFootprint = widget.faces.length > 8;
  }

  @override
  void didUpdateWidget(covariant SolidFoldAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.faces != widget.faces) _prepare();
    if (oldWidget.replaySeed != widget.replaySeed) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _foldProgress(double globalT) =>
      ((globalT - _kHoldFraction) / (1 - _kHoldFraction)).clamp(0.0, 1.0);

  /// Avancement (0→1) du pliage de l'étape [step] : les étapes se suivent,
  /// chacune sur une tranche égale du temps de pliage.
  double _localT(int step, double globalT) {
    if (_stepCount == 0) return 1;
    final g = _foldProgress(globalT);
    final start = step / _stepCount;
    final end = (step + 1) / _stepCount;
    if (g <= start) return 0;
    if (g >= end) return 1;
    return Curves.easeInOut.transform((g - start) / (end - start));
  }

  /// Matrice (patron à plat → 3D) de chaque face à l'instant [globalT] --
  /// voir [foldMatrices].
  List<Matrix4> _absoluteMatrices(double globalT) =>
      foldMatrices(widget.faces, (f) => _localT(f.step, globalT));

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = math.min(constraints.maxWidth, 360.0);
        final h = w * 0.82;

        return GestureDetector(
          onPanUpdate: (d) {
            setState(() {
              // Glisser horizontalement fait tourner le solide sur la
              // "table" (autour de la verticale), verticalement change
              // la hauteur du regard.
              _yaw -= d.delta.dx * 0.009;
              _pitch = (_pitch - d.delta.dy * 0.008).clamp(-1.55, 0.2);
            });
          },
          // Pas de cadre : le solide flotte directement sur la page ; le
          // détecteur reste "opaque" pour capter le glisser sur toute la
          // zone, même entre les faces.
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: w,
            height: h,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => _buildScene(w, h),
            ),
          ),
        );
      },
    );
  }

  /// Tout ce qui dépend de `_controller.value` est calculé ici, à chaque
  /// frame -- `AnimatedBuilder` ne reconstruit que ce `builder`, jamais le
  /// `build()` englobant.
  Widget _buildScene(double w, double h) {
    final faces = widget.faces;
    final globalT = _controller.value;
    final formed = Curves.easeInOut.transform(_foldProgress(globalT));
    final absolute = _absoluteMatrices(globalT);

    // Cadrage automatique à chaque image : on centre sur le barycentre des
    // sommets (en 3D) et on ajuste l'échelle à leur rayon -- le patron à
    // plat est donc entièrement visible au départ, puis la vue se resserre
    // naturellement sur le solide à mesure qu'il se referme.
    final pts = <Vector3>[];
    for (var i = 0; i < faces.length; i++) {
      for (final v in faces[i].polygon) {
        pts.add(absolute[i].transform3(Vector3(v.dx, v.dy, 0)));
      }
    }
    final center = Vector3.zero();
    for (final p in pts) {
      center.add(p);
    }
    center.scale(1 / pts.length);
    var radius = 1.0;
    for (final p in pts) {
      radius = math.max(radius, (p - center).length);
    }
    final fill = 0.54 - 0.18 * formed;
    final sc = fill * math.min(w, h * 1.25) / radius;

    // Caméra : on regarde la "table" (plan du patron) un peu plus du dessus
    // tant que le patron est à plat, puis on descend vers une vue de 3/4 ;
    // la rotation horizontale se fait autour de la verticale (axe z du
    // patron), pour que les arêtes verticales restent verticales à l'écran.
    final pitch = _pitch + 0.28 * (1 - formed);
    final view = Matrix4.identity()
      ..setEntry(3, 2, _kPerspective)
      ..rotateX(pitch)
      ..rotateZ(_yaw)
      ..scaleByDouble(sc, sc, sc, 1.0)
      ..translateByDouble(-center.x, -center.y, -center.z, 1.0);

    // Une fois le solide refermé, ses faces tournées vers l'arrière ne sont
    // jamais visibles : on ne les peint plus. Sinon, près des bords de la
    // silhouette d'une surface courbe, une facette arrière peut passer
    // devant une facette avant voisine (tri par barycentre imparfait) et
    // laisser une bande claire parasite.
    final closed = _foldProgress(globalT) >= 1.0;
    final hidden = <bool>[];
    final combinedMatrices = <Matrix4>[];
    final depth = <double>[];
    final shade = <double>[];
    for (var i = 0; i < faces.length; i++) {
      final combined = view.clone()..multiply(absolute[i]);
      combinedMatrices.add(combined);
      final c = _centroid(faces[i].polygon);
      final mid = combined.transform3(Vector3(c.dx, c.dy, 0));
      depth.add(mid.z);
      final p0 = combined.transform3(Vector3.zero());
      final p1 = combined.transform3(Vector3(0, 0, 1));
      final n = (p1 - p0)..normalize();
      // La face du patron tournée vers +z (le dessous, quand il est posé à
      // plat) devient l'extérieur du solide une fois replié. Elle nous
      // tourne le dos si sa normale s'éloigne de l'œil -- test fait depuis
      // la vraie position de l'œil (perspective), sinon les facettes du
      // bord de la silhouette, vues un peu de côté, disparaîtraient.
      final facingAway = n.dot(mid - _kEye) > 0;
      hidden.add(closed && facingAway);
      // Normale orientée vers l'observateur : c'est la face visible qu'on
      // éclaire.
      if (facingAway) n.negate();
      shade.add(math.max(0.0, n.dot(_kLight)));
    }

    // +z s'éloigne de l'observateur : on peint du plus lointain au plus
    // proche (algorithme du peintre).
    final order = List<int>.generate(faces.length, (i) => i)
      ..sort((a, b) => depth[b].compareTo(depth[a]));

    // Projection à l'écran faite ici même (perspective comprise), puis un
    // seul `CustomPaint` pour toutes les faces. Un widget `Transform` 3D par
    // face (première version) faisait disparaître certaines facettes
    // verticales : le moteur calcule la zone de dessin d'une face en
    // "dé-projetant" l'écran à travers sa rotation, ce qui dégénère quand la
    // face est perpendiculaire au plan du patron.
    final screenCenter = Offset(w / 2, h / 2);
    final projected = <_ProjectedFace>[
      for (final i in order)
        if (!hidden[i])
          _ProjectedFace(
            points: [
              for (final v in faces[i].polygon)
                _project(combinedMatrices[i], v) + screenCenter,
            ],
            color: _shaded(widget.color, shade[i]),
            smooth: faces[i].smooth,
          ),
    ];

    final fp = _footprint;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Ombre douce au sol, sous le solide fermé, décalée à l'opposé de
        // la lumière -- n'apparaît qu'à mesure que le solide se relève.
        // Elle reste dans le plan de la table : un seul `Transform` à plat,
        // sans risque de dégénérescence.
        Positioned.fill(
          child: Transform(
            alignment: Alignment.center,
            transform: view,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: w / 2 + fp.left + 10 * formed - 4,
                  top: h / 2 + fp.top + 10 * formed - 4,
                  child: Container(
                    width: fp.width + 8,
                    height: fp.height + 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        _roundFootprint ? fp.shortestSide / 2 + 4 : 10,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.32 * formed),
                          blurRadius: 26,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(child: CustomPaint(painter: _ScenePainter(projected))),
      ],
    );
  }
}

/// Point du patron (repère à plat) projeté à l'écran, relatif au centre
/// du dessin, avec la division perspective.
Offset _project(Matrix4 m, Offset v) {
  final p = m.perspectiveTransform(Vector3(v.dx, v.dy, 0));
  return Offset(p.x, p.y);
}

class _ProjectedFace {
  final List<Offset> points;
  final Color color;
  final bool smooth;
  const _ProjectedFace({
    required this.points,
    required this.color,
    required this.smooth,
  });
}

/// Teinte de la face selon l'éclairage diffus (0 = dos à la lumière,
/// 1 = pleine lumière) : on reste dans la teinte du solide, assombrie dans
/// l'ombre et légèrement éclaircie dans la lumière, plutôt qu'un simple
/// facteur multiplicatif qui ternirait les couleurs vives de la palette.
Color _shaded(Color base, double diffuse) {
  final dark = Color.lerp(base, Colors.black, 0.20)!;
  final light = Color.lerp(base, Colors.white, 0.22)!;
  return Color.lerp(dark, light, diffuse.clamp(0.0, 1.0))!;
}

Offset _centroid(List<Offset> polygon) {
  var x = 0.0, y = 0.0;
  for (final p in polygon) {
    x += p.dx;
    y += p.dy;
  }
  return Offset(x / polygon.length, y / polygon.length);
}

/// Peint les faces déjà projetées, de la plus lointaine à la plus proche.
class _ScenePainter extends CustomPainter {
  final List<_ProjectedFace> faces;
  const _ScenePainter(this.faces);

  @override
  void paint(Canvas canvas, Size size) {
    for (final face in faces) {
      final v = face.points;
      final path = Path()..moveTo(v[0].dx, v[0].dy);
      for (final p in v.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      path.close();

      if (face.smooth) {
        // Facette d'une surface courbe : aplat + contour de la même
        // couleur, qui recouvre les micro-interstices entre facettes
        // voisines pour que la surface paraisse continue.
        canvas.drawPath(path, Paint()..color = face.color);
        canvas.drawPath(
          path,
          Paint()
            ..color = face.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0
            ..strokeJoin = StrokeJoin.round,
        );
        continue;
      }

      // Léger dégradé dans la face (plus clair vers le haut-gauche) pour
      // l'aspect "rendu" plutôt qu'aplat.
      canvas.drawPath(
        path,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(face.color, Colors.white, 0.10)!,
              Color.lerp(face.color, Colors.black, 0.05)!,
            ],
          ).createShader(path.getBounds()),
      );

      // Arêtes adoucies : un liseré clair, comme les arêtes légèrement
      // arrondies de la planche de référence.
      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ScenePainter oldDelegate) => true;
}
