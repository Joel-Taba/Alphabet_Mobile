import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/amani_theme.dart';
import '../data/solid_calc_problem.dart';
import '../data/solid3d_catalog.dart';

/// Illustration joyeuse du problème de volume actif :
/// - cube → bloc de pierre Minecraft
/// - pavé droit → aquarium avec poissons
/// - pyramide / cylindre → schéma isométrique coloré
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(painter: _SolidCalcPainter(problem)),
      ),
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
        _cubeMC(canvas, size, d['side']!, unit);
        break;
      case 'pave':
        _aquarium(canvas, size, d['length']!, d['width']!, d['height']!, unit);
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

  // ────────────────────────────────── Cube — bloc de pierre Minecraft

  void _cubeMC(Canvas c, Size s, int side, String unit) {
    // Fond : arrière-plan style pixel-art
    c.drawRect(
      Rect.fromLTWH(0, 0, s.width, s.height),
      Paint()..color = const Color(0xFF7DB08A), // herbe minecraft
    );
    // Sol (deux rangées de tuiles)
    final dirtPaint = Paint()..color = const Color(0xFF8B5E3C);
    c.drawRect(
      Rect.fromLTWH(0, s.height * 0.78, s.width, s.height * 0.22),
      dirtPaint,
    );
    // Grille sol
    final gridPaint = Paint()
      ..color = const Color(0xFF6B4426)
      ..strokeWidth = 0.8;
    for (double x = 0; x < s.width; x += s.width / 5) {
      c.drawLine(Offset(x, s.height * 0.78), Offset(x, s.height), gridPaint);
    }
    for (double y = s.height * 0.78; y < s.height; y += s.height * 0.11) {
      c.drawLine(Offset(0, y), Offset(s.width, y), gridPaint);
    }

    // Isometric cube
    final skew = Offset(s.width * 0.17, -s.height * 0.14);
    final fw = s.width * 0.48;
    final fh = s.height * 0.50;
    final origin = Offset(s.width * 0.16, s.height * 0.78);
    final fTL = origin + Offset(0, -fh);
    final fTR = origin + Offset(fw, -fh);
    final fBR = origin + Offset(fw, 0);
    final fBL = origin;
    final stroke = const Color(0xFF3E2723);
    final outlinePaint = Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round;

    // Face avant (pierre grise avec texture fissures)
    final front = Path()
      ..moveTo(fBL.dx, fBL.dy)
      ..lineTo(fBR.dx, fBR.dy)
      ..lineTo(fTR.dx, fTR.dy)
      ..lineTo(fTL.dx, fTL.dy)
      ..close();
    c.drawPath(front, Paint()..color = const Color(0xFF9E9E9E));
    // Grille pixel sur face avant
    _pixelGrid(c, fTL, fTR, fBR, fBL, const Color(0xFF757575), 4);
    c.drawPath(front, outlinePaint);

    // Dessus (plus claire)
    final top = Path()
      ..moveTo(fTL.dx, fTL.dy)
      ..lineTo(fTR.dx, fTR.dy)
      ..lineTo(fTR.dx + skew.dx, fTR.dy + skew.dy)
      ..lineTo(fTL.dx + skew.dx, fTL.dy + skew.dy)
      ..close();
    c.drawPath(top, Paint()..color = const Color(0xFFBDBDBD));
    _pixelGrid(c, fTL + skew, fTR + skew, fTR, fTL, const Color(0xFF9E9E9E), 4);
    c.drawPath(top, outlinePaint);

    // Côté droit (plus sombre)
    final right = Path()
      ..moveTo(fTR.dx, fTR.dy)
      ..lineTo(fBR.dx, fBR.dy)
      ..lineTo(fBR.dx + skew.dx, fBR.dy + skew.dy)
      ..lineTo(fTR.dx + skew.dx, fTR.dy + skew.dy)
      ..close();
    c.drawPath(right, Paint()..color = const Color(0xFF757575));
    _pixelGrid(c, fTR + skew, fTR, fBR, fBR + skew, const Color(0xFF616161), 4);
    c.drawPath(right, outlinePaint);

    // Labels
    _label(c, '$side $unit', Offset((fBL.dx + fBR.dx) / 2, fBL.dy + 16));
    _label(c, '$side $unit', Offset(fBL.dx - 22, (fTL.dy + fBL.dy) / 2));
    _label(
      c,
      '$side $unit',
      Offset(fTR.dx + skew.dx / 2 + 8, fTR.dy + skew.dy / 2 - 8),
    );

    // Icône pixel-art
    _emoji(
      c,
      '⛏️',
      Offset(fTR.dx + skew.dx - 2, fTR.dy + skew.dy - 20),
      size: 14,
    );
  }

  void _pixelGrid(
    Canvas c,
    Offset tl,
    Offset tr,
    Offset br,
    Offset bl,
    Color color,
    int divisions,
  ) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 0.7;
    for (int i = 1; i < divisions; i++) {
      final t = i / divisions;
      c.drawLine(Offset.lerp(tl, tr, t)!, Offset.lerp(bl, br, t)!, p);
      c.drawLine(Offset.lerp(tl, bl, t)!, Offset.lerp(tr, br, t)!, p);
    }
  }

  // ────────────────────────────────── Pavé droit — aquarium

  void _aquarium(
    Canvas c,
    Size s,
    int length,
    int width,
    int height,
    String unit,
  ) {
    // Fond clair (pièce/bureau)
    c.drawRect(
      Rect.fromLTWH(0, 0, s.width, s.height),
      Paint()..color = const Color(0xFFF5F5F5),
    );

    final skew = Offset(s.width * 0.16, -s.height * 0.12);
    final fw = s.width * 0.52;
    final fh = s.height * 0.52;
    final origin = Offset(s.width * 0.14, s.height * 0.80);
    final fTL = origin + Offset(0, -fh);
    final fTR = origin + Offset(fw, -fh);
    final fBR = origin + Offset(fw, 0);
    final fBL = origin;

    // Eau (face avant, bleu semi-transparent)
    final frontWater = Path()
      ..moveTo(fBL.dx, fBL.dy)
      ..lineTo(fBR.dx, fBR.dy)
      ..lineTo(fTR.dx, fTR.dy)
      ..lineTo(fTL.dx, fTL.dy)
      ..close();
    c.drawPath(
      frontWater,
      Paint()..color = const Color(0xFF90CAF9).withValues(alpha: 0.7),
    );

    // Petites vagues
    final wavePaint = Paint()
      ..color = const Color(0xFF42A5F5).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    for (int i = 0; i < 3; i++) {
      final t = 0.2 + i * 0.22;
      final y = fTL.dy + (fBL.dy - fTL.dy) * t;
      final path = Path();
      final steps = 5;
      for (int j = 0; j <= steps; j++) {
        final xFrac = j / steps;
        final x = fTL.dx + (fTR.dx - fTL.dx) * xFrac;
        final wave = (j % 2 == 0) ? 0.0 : -3.0;
        if (j == 0) {
          path.moveTo(x, y + wave);
        } else {
          path.lineTo(x, y + wave);
        }
      }
      c.drawPath(path, wavePaint);
    }

    // Dessus (eau + verre transparent)
    final top = Path()
      ..moveTo(fTL.dx, fTL.dy)
      ..lineTo(fTR.dx, fTR.dy)
      ..lineTo(fTR.dx + skew.dx, fTR.dy + skew.dy)
      ..lineTo(fTL.dx + skew.dx, fTL.dy + skew.dy)
      ..close();
    c.drawPath(
      top,
      Paint()..color = const Color(0xFFB3E5FC).withValues(alpha: 0.5),
    );

    // Côté droit
    final right = Path()
      ..moveTo(fTR.dx, fTR.dy)
      ..lineTo(fBR.dx, fBR.dy)
      ..lineTo(fBR.dx + skew.dx, fBR.dy + skew.dy)
      ..lineTo(fTR.dx + skew.dx, fTR.dy + skew.dy)
      ..close();
    c.drawPath(
      right,
      Paint()..color = const Color(0xFF4FC3F7).withValues(alpha: 0.5),
    );

    // Contours verre
    final glassPaint = Paint()
      ..color = const Color(0xFF0277BD)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeJoin = StrokeJoin.round;
    c.drawPath(frontWater, glassPaint);
    c.drawPath(top, glassPaint);
    c.drawPath(right, glassPaint);

    // Fond de l'aquarium (sable)
    final sandRect = Rect.fromLTWH(
      fBL.dx + 3,
      fBL.dy - 10,
      fBR.dx - fBL.dx - 6,
      10,
    );
    c.drawRect(
      sandRect,
      Paint()..color = const Color(0xFFFFF176).withValues(alpha: 0.6),
    );

    // Poissons et plantes (emojis)
    _emoji(c, '🐟', Offset(fBL.dx + fw * 0.2, fBL.dy - fh * 0.42), size: 18);
    _emoji(c, '🐠', Offset(fBL.dx + fw * 0.55, fBL.dy - fh * 0.65), size: 15);
    _emoji(c, '🌿', Offset(fBL.dx + fw * 0.1, fBL.dy - fh * 0.16), size: 12);
    _emoji(c, '🌿', Offset(fBL.dx + fw * 0.72, fBL.dy - fh * 0.14), size: 11);

    // Labels
    _label(c, '$length $unit', Offset((fBL.dx + fBR.dx) / 2, fBL.dy + 16));
    _label(c, '$height $unit', Offset(fBL.dx - 22, (fTL.dy + fBL.dy) / 2));
    _label(
      c,
      '$width $unit',
      Offset(fTR.dx + skew.dx / 2 + 8, fTR.dy + skew.dy / 2 - 8),
    );
  }

  void _emoji(Canvas c, String emoji, Offset topLeft, {double size = 14}) {
    final tp = TextPainter(
      text: TextSpan(
        text: emoji,
        style: TextStyle(fontSize: size),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, topLeft);
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

  @override
  bool shouldRepaint(covariant _SolidCalcPainter oldDelegate) =>
      oldDelegate.problem != problem;
}
