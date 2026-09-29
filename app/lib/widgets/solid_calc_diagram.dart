import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/amani_theme.dart';
import '../data/solid_calc_problem.dart';
import '../data/solid3d_catalog.dart';

/// Schéma statique (pas d'animation ici, voir `SolidFoldAnimation` pour le
/// cours) illustrant le problème de volume actif -- projection isométrique
/// classique ("faux cube en 2D" : un rectangle de face + deux
/// parallélogrammes pour donner l'illusion de la profondeur), même principe
/// de sobriété que `ShapeCalcDiagram` : uniquement les cotations utiles au
/// calcul en cours.
class SolidCalcDiagram extends StatelessWidget {
  final SolidCalcProblem problem;
  final double width;
  final double height;

  const SolidCalcDiagram({
    super.key,
    required this.problem,
    this.width = 260,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _SolidCalcPainter(problem)),
    );
  }
}

/// Même couleur que l'animation du cours (`solidColor`, palette
/// `kSolidColors`) : dessus éclairé plus clair, côté plus sombre, arêtes
/// dans une version foncée de la même teinte.
class _SolidCalcPainter extends CustomPainter {
  final SolidCalcProblem problem;
  final Color _front;
  final Color _top;
  final Color _side;
  final Color _stroke;

  _SolidCalcPainter(this.problem)
    : _front = solidColor(problem.shapeId),
      _top = Color.lerp(solidColor(problem.shapeId), Colors.white, 0.28)!,
      _side = Color.lerp(solidColor(problem.shapeId), Colors.black, 0.22)!,
      _stroke = Color.lerp(solidColor(problem.shapeId), Colors.black, 0.6)!;

  @override
  void paint(Canvas canvas, Size size) {
    final outline = Paint()
      ..color = _stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeJoin = StrokeJoin.round;
    final dashed = Paint()
      ..color = _stroke.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final d = problem.dimensions;
    const unit = 'm';

    switch (problem.shapeId) {
      case 'cube':
        _box(
          canvas,
          size,
          outline,
          '${d['side']} $unit',
          '${d['side']} $unit',
          '${d['side']} $unit',
        );
        break;
      case 'pave':
        _box(
          canvas,
          size,
          outline,
          '${d['length']} $unit',
          '${d['width']} $unit',
          '${d['height']} $unit',
        );
        break;
      case 'pyramide':
        _pyramide(
          canvas,
          size,
          outline,
          dashed,
          '${d['side']} $unit',
          '${d['height']} $unit',
        );
        break;
      case 'prisme':
        _prisme(
          canvas,
          size,
          outline,
          dashed,
          '${d['base']} $unit',
          '${d['height']} $unit',
          '${d['length']} $unit',
        );
        break;
      case 'cylindre':
        _cylindre(
          canvas,
          size,
          outline,
          dashed,
          '${d['radius']} $unit',
          '${d['height']} $unit',
        );
        break;
      case 'cone':
        _cone(
          canvas,
          size,
          outline,
          dashed,
          '${d['radius']} $unit',
          '${d['height']} $unit',
        );
        break;
      case 'sphere':
        _sphere(canvas, size, outline, dashed, '${d['radius']} $unit');
        break;
    }
  }

  void _label(Canvas canvas, String text, Offset center) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: kBalooFontFamily,
          fontWeight: FontWeight.w800,
          fontSize: 12.5,
          color: _stroke,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final rect = Rect.fromCenter(
      center: center,
      width: tp.width + 8,
      height: tp.height + 3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(5)),
      Paint()..color = AmaniColors.surface,
    );
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  void _dashedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dashLen = 5.0;
    final total = (b - a).distance;
    if (total == 0) return;
    final dir = (b - a) / total;
    var travelled = 0.0;
    while (travelled < total) {
      final segEnd = (travelled + dashLen).clamp(0.0, total);
      canvas.drawLine(a + dir * travelled, a + dir * segEnd, paint);
      travelled += dashLen * 2;
    }
  }

  /// Boîte isométrique (cube ou pavé) : face avant + dessus + côté droit,
  /// via un décalage fixe (skew) donnant l'illusion de profondeur.
  void _box(
    Canvas c,
    Size s,
    Paint outline,
    String frontLabel,
    String depthLabel,
    String heightLabel,
  ) {
    final skew = Offset(s.width * 0.17, -s.height * 0.14);
    final fw = s.width * 0.5;
    final fh = s.height * 0.55;
    final origin = Offset(s.width * 0.16, s.height * 0.78);
    final fTL = origin + Offset(0, -fh);
    final fTR = origin + Offset(fw, -fh);
    final fBR = origin + Offset(fw, 0);
    final fBL = origin;

    final front = Path()
      ..moveTo(fBL.dx, fBL.dy)
      ..lineTo(fBR.dx, fBR.dy)
      ..lineTo(fTR.dx, fTR.dy)
      ..lineTo(fTL.dx, fTL.dy)
      ..close();
    c.drawPath(front, Paint()..color = _front);
    c.drawPath(front, outline);

    final top = Path()
      ..moveTo(fTL.dx, fTL.dy)
      ..lineTo(fTR.dx, fTR.dy)
      ..lineTo(fTR.dx + skew.dx, fTR.dy + skew.dy)
      ..lineTo(fTL.dx + skew.dx, fTL.dy + skew.dy)
      ..close();
    c.drawPath(top, Paint()..color = _top);
    c.drawPath(top, outline);

    final side = Path()
      ..moveTo(fTR.dx, fTR.dy)
      ..lineTo(fBR.dx, fBR.dy)
      ..lineTo(fBR.dx + skew.dx, fBR.dy + skew.dy)
      ..lineTo(fTR.dx + skew.dx, fTR.dy + skew.dy)
      ..close();
    c.drawPath(side, Paint()..color = _side);
    c.drawPath(side, outline);

    _label(c, frontLabel, Offset((fBL.dx + fBR.dx) / 2, fBL.dy + 16));
    _label(c, heightLabel, Offset(fBL.dx - 20, (fTL.dy + fBL.dy) / 2));
    _label(
      c,
      depthLabel,
      Offset(fTR.dx + skew.dx / 2 + 6, fTR.dy + skew.dy / 2 - 6),
    );
  }

  void _pyramide(
    Canvas c,
    Size s,
    Paint outline,
    Paint dashed,
    String sideLabel,
    String heightLabel,
  ) {
    final baseSkew = Offset(s.width * 0.22, s.height * 0.10);
    final baseCenter = Offset(s.width * 0.42, s.height * 0.72);
    final apex = Offset(s.width * 0.42, s.height * 0.14);

    final bl = baseCenter + Offset(-s.width * 0.28, 0);
    final br = baseCenter + Offset(s.width * 0.28, 0);
    final bf = baseCenter + Offset(0, s.height * 0.16);
    final bb = baseCenter + Offset(0, -s.height * 0.16) + baseSkew * 0.0;

    final base = Path()
      ..moveTo(bl.dx, bl.dy)
      ..lineTo(bf.dx, bf.dy)
      ..lineTo(br.dx, br.dy)
      ..lineTo(bb.dx, bb.dy)
      ..close();
    c.drawPath(base, Paint()..color = _top);
    c.drawPath(base, outline);

    final faceLeft = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(bl.dx, bl.dy)
      ..lineTo(bf.dx, bf.dy)
      ..close();
    c.drawPath(faceLeft, Paint()..color = _front);
    c.drawPath(faceLeft, outline);

    final faceRight = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(bf.dx, bf.dy)
      ..lineTo(br.dx, br.dy)
      ..close();
    c.drawPath(faceRight, Paint()..color = _side);
    c.drawPath(faceRight, outline);

    _dashedLine(c, apex, baseCenter, dashed);
    _label(c, heightLabel, Offset(apex.dx + 32, (apex.dy + baseCenter.dy) / 2));
    _label(
      c,
      sideLabel,
      Offset((bl.dx + bf.dx) / 2 - 6, (bl.dy + bf.dy) / 2 + 12),
    );
  }

  void _prisme(
    Canvas c,
    Size s,
    Paint outline,
    Paint dashed,
    String baseLabel,
    String heightLabel,
    String lengthLabel,
  ) {
    final depth = Offset(s.width * 0.24, -s.height * 0.13);
    final frontBL = Offset(s.width * 0.16, s.height * 0.82);
    final frontBR = Offset(s.width * 0.56, s.height * 0.82);
    final frontApex = Offset(s.width * 0.36, s.height * 0.32);

    final backBL = frontBL + depth;
    final backBR = frontBR + depth;
    final backApex = frontApex + depth;

    final roofLeft = Path()
      ..moveTo(frontApex.dx, frontApex.dy)
      ..lineTo(frontBL.dx, frontBL.dy)
      ..lineTo(backBL.dx, backBL.dy)
      ..lineTo(backApex.dx, backApex.dy)
      ..close();
    c.drawPath(roofLeft, Paint()..color = _top);
    c.drawPath(roofLeft, outline);

    final roofRight = Path()
      ..moveTo(frontApex.dx, frontApex.dy)
      ..lineTo(backApex.dx, backApex.dy)
      ..lineTo(backBR.dx, backBR.dy)
      ..lineTo(frontBR.dx, frontBR.dy)
      ..close();
    c.drawPath(roofRight, Paint()..color = _side);
    c.drawPath(roofRight, outline);

    final front = Path()
      ..moveTo(frontApex.dx, frontApex.dy)
      ..lineTo(frontBL.dx, frontBL.dy)
      ..lineTo(frontBR.dx, frontBR.dy)
      ..close();
    c.drawPath(front, Paint()..color = _front);
    c.drawPath(front, outline);

    _dashedLine(
      c,
      frontApex,
      Offset((frontBL.dx + frontBR.dx) / 2, frontApex.dy),
      dashed,
    );
    _dashedLine(
      c,
      Offset((frontBL.dx + frontBR.dx) / 2, frontApex.dy),
      Offset((frontBL.dx + frontBR.dx) / 2, frontBL.dy),
      dashed,
    );

    _label(
      c,
      baseLabel,
      Offset((frontBL.dx + frontBR.dx) / 2, frontBL.dy + 16),
    );
    _label(
      c,
      heightLabel,
      Offset(frontApex.dx - 30, (frontApex.dy + frontBL.dy) / 2),
    );
    _label(
      c,
      lengthLabel,
      Offset(
        (frontBR.dx + backBR.dx) / 2 + 10,
        (frontBR.dy + backBR.dy) / 2 - 4,
      ),
    );
  }

  /// Dégradé horizontal d'une surface courbe : claire à gauche (côté
  /// lumière), plus sombre à droite -- donne le volume sans perspective.
  Paint _curvedFill(Rect bounds) => Paint()
    ..shader = LinearGradient(
      colors: [_top, _front, _side],
      stops: const [0.0, 0.45, 1.0],
    ).createShader(bounds);

  /// Demi-ellipse arrière (cachée par le solide) en pointillés.
  void _dashedBackArc(Canvas c, Rect oval, Paint dashed) {
    const segments = 24;
    for (var i = 0; i < segments; i += 2) {
      final a0 = math.pi + math.pi * i / segments;
      final a1 = math.pi + math.pi * (i + 1) / segments;
      c.drawArc(oval, a0, a1 - a0, false, dashed);
    }
  }

  void _cylindre(
    Canvas c,
    Size s,
    Paint outline,
    Paint dashed,
    String radiusLabel,
    String heightLabel,
  ) {
    final cx = s.width * 0.44;
    final rx = s.width * 0.22;
    final ry = rx * 0.32;
    final topY = s.height * 0.2;
    final bottomY = s.height * 0.8;
    final topOval = Rect.fromCenter(
      center: Offset(cx, topY),
      width: rx * 2,
      height: ry * 2,
    );
    final bottomOval = Rect.fromCenter(
      center: Offset(cx, bottomY),
      width: rx * 2,
      height: ry * 2,
    );

    final body = Path()
      ..moveTo(cx - rx, topY)
      ..lineTo(cx - rx, bottomY)
      ..arcTo(bottomOval, math.pi, -math.pi, false)
      ..lineTo(cx + rx, topY)
      ..close();
    c.drawPath(body, _curvedFill(body.getBounds()));
    c.drawPath(body, outline);
    _dashedBackArc(c, bottomOval, dashed);

    c.drawOval(topOval, Paint()..color = _top);
    c.drawOval(topOval, outline);

    // Rayon : du centre du disque du haut jusqu'à son bord.
    c.drawCircle(Offset(cx, topY), 2.4, Paint()..color = _stroke);
    c.drawLine(Offset(cx, topY), Offset(cx + rx, topY), outline);
    _label(c, radiusLabel, Offset(cx + rx / 2, topY - ry - 12));

    // Hauteur : cote verticale à droite du cylindre.
    final hx = cx + rx + 18;
    _dashedLine(c, Offset(hx, topY), Offset(hx, bottomY), dashed);
    _label(c, heightLabel, Offset(hx + 22, (topY + bottomY) / 2));
  }

  void _cone(
    Canvas c,
    Size s,
    Paint outline,
    Paint dashed,
    String radiusLabel,
    String heightLabel,
  ) {
    final cx = s.width * 0.44;
    final rx = s.width * 0.25;
    final ry = rx * 0.3;
    final apex = Offset(cx, s.height * 0.1);
    final baseY = s.height * 0.8;
    final baseOval = Rect.fromCenter(
      center: Offset(cx, baseY),
      width: rx * 2,
      height: ry * 2,
    );

    final body = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(cx - rx, baseY)
      ..arcTo(baseOval, math.pi, -math.pi, false)
      ..close();
    c.drawPath(body, _curvedFill(body.getBounds()));
    c.drawPath(body, outline);
    _dashedBackArc(c, baseOval, dashed);

    // Hauteur : de la pointe au centre de la base.
    final center = Offset(cx, baseY);
    _dashedLine(c, apex, center, dashed);
    c.drawCircle(center, 2.4, Paint()..color = _stroke);
    _label(c, heightLabel, Offset(cx - 26, (apex.dy + baseY) / 2 + 10));

    // Rayon : du centre de la base jusqu'à son bord.
    c.drawLine(center, Offset(cx + rx, baseY), outline);
    _label(c, radiusLabel, Offset(cx + rx / 2, baseY + ry + 12));
  }

  void _sphere(
    Canvas c,
    Size s,
    Paint outline,
    Paint dashed,
    String radiusLabel,
  ) {
    final center = Offset(s.width * 0.44, s.height * 0.5);
    final r = s.height * 0.4;
    final circle = Rect.fromCircle(center: center, radius: r);
    c.drawCircle(
      center,
      r,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.4, -0.45),
          radius: 0.95,
          colors: [_top, _front, _side],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(circle),
    );
    c.drawCircle(center, r, outline);

    // Équateur : moitié avant en trait plein, moitié arrière en pointillés.
    final equator = Rect.fromCenter(
      center: center,
      width: r * 2,
      height: r * 0.5,
    );
    c.drawArc(equator, 0, math.pi, false, outline);
    _dashedBackArc(c, equator, dashed);

    // Rayon : du centre jusqu'au bord.
    c.drawCircle(center, 2.6, Paint()..color = _stroke);
    c.drawLine(center, Offset(center.dx + r, center.dy), outline);
    _label(c, radiusLabel, Offset(center.dx + r / 2, center.dy - r * 0.42));
  }

  @override
  bool shouldRepaint(covariant _SolidCalcPainter oldDelegate) =>
      oldDelegate.problem != problem;
}
