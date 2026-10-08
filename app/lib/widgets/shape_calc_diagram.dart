import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/amani_theme.dart';
import '../data/shape_calc_problem.dart';

/// Illustration joyeuse et colorée du problème actif, adaptée à l'enfant :
/// chaque figure apparaît dans une mise en scène (terrain de foot, piscine,
/// cerf-volant…) avec uniquement les cotations utiles à l'exercice.
class ShapeCalcDiagram extends StatelessWidget {
  final ShapeCalcProblem problem;
  final double width;
  final double height;

  const ShapeCalcDiagram({
    super.key,
    required this.problem,
    this.width = 260,
    this.height = 190,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(painter: _ShapeCalcPainter(problem)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Painter principal
// ─────────────────────────────────────────────────────────────────────────────

class _ShapeCalcPainter extends CustomPainter {
  final ShapeCalcProblem problem;
  const _ShapeCalcPainter(this.problem);

  @override
  void paint(Canvas canvas, Size size) {
    final d = problem.dimensions;
    const unit = 'm';
    switch (problem.shapeId) {
      case 'carre':
        _drawCarre(canvas, size, d['side']!, unit);
        break;
      case 'rectangle':
        _drawRectangle(canvas, size, d['length']!, d['width']!, unit);
        break;
      case 'triangle':
        if (problem.kind == ShapeCalcKind.perimeter) {
          _drawTrianglePerimeter(canvas, size, d['a']!, d['b']!, d['c']!, unit);
        } else {
          _drawTriangleArea(canvas, size, d['base']!, d['height']!, unit);
        }
        break;
      case 'cercle':
        _drawCercle(canvas, size, d['radius']!, unit);
        break;
      case 'parallelogramme':
        if (problem.kind == ShapeCalcKind.perimeter) {
          _drawParallelogramPerimeter(canvas, size, d['a']!, d['b']!, unit);
        } else {
          _drawParallelogramArea(canvas, size, d['base']!, d['height']!, unit);
        }
        break;
      case 'losange':
        if (problem.kind == ShapeCalcKind.perimeter) {
          _drawLosangePerimeter(canvas, size, d['side']!, unit);
        } else {
          _drawLosangeArea(canvas, size, d['bigDiagonal']!, d['smallDiagonal']!, unit);
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _ShapeCalcPainter old) => old.problem != problem;

  // ─────────────────────────────────────── Carré — terrain de foot des fourmis

  void _drawCarre(Canvas canvas, Size s, int side, String unit) {
    // Fond herbe
    canvas.drawRect(
      Rect.fromLTWH(0, 0, s.width, s.height),
      Paint()..color = const Color(0xFFD4EDA4),
    );
    // Lignes de gazon alternées
    final grassPaint = Paint()
      ..color = const Color(0xFFBFDC8C)
      ..strokeWidth = s.height / 10;
    for (int i = 0; i < 5; i++) {
      if (i.isEven) {
        canvas.drawLine(
          Offset(0, s.height * 0.1 + i * s.height * 0.18),
          Offset(s.width, s.height * 0.1 + i * s.height * 0.18),
          grassPaint,
        );
      }
    }

    // Carré (terrain)
    final fieldSize = math.min(s.width * 0.56, s.height * 0.68);
    final ox = (s.width - fieldSize) / 2;
    final oy = (s.height - fieldSize) / 2 - 8;
    final rect = Rect.fromLTWH(ox, oy, fieldSize, fieldSize);

    canvas.drawRect(rect, Paint()..color = const Color(0xFF5DB83B));
    canvas.drawRect(
      rect,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    // Ligne médiane (tirets blancs)
    final mid = rect.center;
    _dashedLine(
      canvas,
      Offset(mid.dx, rect.top),
      Offset(mid.dx, rect.bottom),
      Paint()..color = Colors.white..strokeWidth = 1.6,
      dash: 5, gap: 4,
    );
    // Cercle central
    _dashedCircle(
      canvas, mid, fieldSize * 0.18,
      Paint()..color = Colors.white..strokeWidth = 1.6,
    );

    // Fourmis aux 4 coins
    _emoji(canvas, '🐜', Offset(rect.left - 10, rect.top - 12), size: 13);
    _emoji(canvas, '🐜', Offset(rect.right - 4,  rect.top - 12), size: 13);
    _emoji(canvas, '🐜', Offset(rect.left - 10, rect.bottom - 2), size: 13);
    _emoji(canvas, '🐜', Offset(rect.right - 4,  rect.bottom - 2), size: 13);

    // Ticks "côtés égaux"
    final tickPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.4;
    for (final edge in [
      [rect.topLeft, rect.topRight],
      [rect.bottomLeft, rect.bottomRight],
      [rect.topLeft, rect.bottomLeft],
      [rect.topRight, rect.bottomRight],
    ]) {
      _tick(canvas, Offset.lerp(edge[0], edge[1], 0.5)!,
            (edge[1] - edge[0]).normalized(), tickPaint);
    }

    // Label
    _label(canvas, '$side $unit', Offset(rect.center.dx, rect.bottom + 18));
  }

  // ─────────────────────────────────────── Rectangle — piscine des dauphins

  void _drawRectangle(Canvas canvas, Size s, int length, int width, String unit) {
    // Fond ciel/carrelage
    canvas.drawRect(
      Rect.fromLTWH(0, 0, s.width, s.height),
      Paint()..color = const Color(0xFFE1F5FE),
    );

    final pw = s.width * 0.74;
    final ph = s.height * 0.62;
    final ox = (s.width - pw) / 2;
    final oy = (s.height - ph) / 2 - 6;
    final rect = Rect.fromLTWH(ox, oy, pw, ph);

    // Eau
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(10)),
      Paint()..color = const Color(0xFF4FC3F7),
    );
    // Vagues (petites lignes courbes blanches)
    final wavePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    for (int i = 0; i < 3; i++) {
      final wy = rect.top + ph * 0.2 + i * ph * 0.22;
      final path = Path();
      for (double x = rect.left + 4; x < rect.right - 4; x += 16) {
        if (x == rect.left + 4) {
          path.moveTo(x, wy);
        } else {
          path.relativeQuadraticBezierTo(8, -5, 16, 0);
        }
      }
      canvas.drawPath(path, wavePaint);
    }

    // Contour
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(10)),
      Paint()
        ..color = const Color(0xFF0277BD)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    // Dauphin
    _emoji(canvas, '🐬', Offset(rect.center.dx - 8, rect.center.dy - 10), size: 22);

    // Labels
    _label(canvas, '$length $unit', Offset(rect.center.dx, rect.bottom + 18));
    _label(canvas, '$width $unit', Offset(rect.right + 26, rect.center.dy));
  }

  // ─────────────────────────────────────── Triangle — champ (périmètre)

  void _drawTrianglePerimeter(Canvas c, Size s, int a, int b, int cSide, String unit) {
    c.drawRect(
      Rect.fromLTWH(0, 0, s.width, s.height),
      Paint()..color = const Color(0xFFF9F3DC),
    );

    final apex = Offset(s.width / 2, s.height * 0.1);
    final bl = Offset(s.width * 0.18, s.height * 0.84);
    final br = Offset(s.width * 0.82, s.height * 0.84);

    final path = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(br.dx, br.dy)
      ..lineTo(bl.dx, bl.dy)
      ..close();
    c.drawPath(path, Paint()..color = const Color(0xFF66BB6A));
    c.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF2E7D32)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    _emoji(c, '🌻', Offset(s.width / 2 - 8, s.height / 2 - 8), size: 16);

    _label(c, '$a $unit', Offset.lerp(bl, apex, 0.5)! + const Offset(-22, 0));
    _label(c, '$b $unit', Offset.lerp(apex, br, 0.5)! + const Offset(22, 0));
    _label(c, '$cSide $unit', Offset(s.width / 2, bl.dy + 20));
  }

  // ─────────────────────────────────────── Triangle — champ (aire)

  void _drawTriangleArea(Canvas c, Size s, int base, int height, String unit) {
    c.drawRect(
      Rect.fromLTWH(0, 0, s.width, s.height),
      Paint()..color = const Color(0xFFF9F3DC),
    );

    final apex = Offset(s.width * 0.38, s.height * 0.1);
    final bl = Offset(s.width * 0.14, s.height * 0.84);
    final br = Offset(s.width * 0.86, s.height * 0.84);
    final foot = Offset(apex.dx, bl.dy);

    final path = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(br.dx, br.dy)
      ..lineTo(bl.dx, bl.dy)
      ..close();
    c.drawPath(path, Paint()..color = const Color(0xFF66BB6A));
    c.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF2E7D32)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    final dashedPaint = Paint()
      ..color = const Color(0xFF1565C0)
      ..strokeWidth = 1.8;
    _dashedLine(c, apex, foot, dashedPaint);
    _rightAngle(c, foot, const Offset(-1, 0), const Offset(0, -1), dashedPaint);

    _label(c, '$base $unit', Offset(s.width / 2, bl.dy + 20));
    _label(c, '$height $unit', Offset(foot.dx + 34, (apex.dy + foot.dy) / 2));
  }

  // ─────────────────────────────────────── Cercle — grande roue

  void _drawCercle(Canvas c, Size s, int radius, String unit) {
    // Fond ciel
    c.drawRect(
      Rect.fromLTWH(0, 0, s.width, s.height),
      Paint()..color = const Color(0xFFE3F2FD),
    );
    // Nuages décoratifs
    _cloudBlob(c, Offset(s.width * 0.1, s.height * 0.1), 22);
    _cloudBlob(c, Offset(s.width * 0.82, s.height * 0.08), 18);

    final cx = s.width / 2;
    final cy = s.height * 0.46;
    final r = math.min(s.width * 0.34, s.height * 0.38);

    // Pied de la grande roue
    final standPaint = Paint()
      ..color = const Color(0xFF8D6E63)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    c.drawLine(Offset(cx - r * 0.6, cy + r), Offset(cx, cy + r * 0.08), standPaint);
    c.drawLine(Offset(cx + r * 0.6, cy + r), Offset(cx, cy + r * 0.08), standPaint);
    // Sol
    c.drawLine(
      Offset(cx - r * 0.8, cy + r + 1),
      Offset(cx + r * 0.8, cy + r + 1),
      Paint()..color = const Color(0xFF8D6E63)..strokeWidth = 3,
    );

    // Roue (cercle)
    c.drawCircle(
      Offset(cx, cy), r,
      Paint()..color = const Color(0xFFFFF9C4),
    );
    c.drawCircle(
      Offset(cx, cy), r,
      Paint()
        ..color = const Color(0xFFF57F17)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Rayons (8 rayons)
    final spokePaint = Paint()
      ..color = const Color(0xFFFF8F00)
      ..strokeWidth = 1.5;
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      c.drawLine(
        Offset(cx, cy),
        Offset(cx + r * math.cos(angle), cy + r * math.sin(angle)),
        spokePaint,
      );
    }

    // Nacelles
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final gx = cx + r * math.cos(angle);
      final gy = cy + r * math.sin(angle);
      c.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(gx, gy + 6), width: 10, height: 7),
          const Radius.circular(3),
        ),
        Paint()..color = [
          const Color(0xFFF44336), const Color(0xFF2196F3),
          const Color(0xFF4CAF50), const Color(0xFFFF9800),
          const Color(0xFF9C27B0), const Color(0xFF00BCD4),
          const Color(0xFFE91E63), const Color(0xFFFFEB3B),
        ][i],
      );
    }

    // Moyeu central
    c.drawCircle(Offset(cx, cy), 6, Paint()..color = const Color(0xFFBF360C));

    // Rayon en trait interrompu + label
    final dashedPaint = Paint()
      ..color = const Color(0xFF1565C0)
      ..strokeWidth = 1.8;
    _dashedLine(c, Offset(cx, cy), Offset(cx + r, cy), dashedPaint);
    c.drawCircle(Offset(cx, cy), 2, Paint()..color = const Color(0xFF1565C0));
    _label(c, '$radius $unit', Offset(cx + r / 2, cy - 14));
  }

  // ─────────────────────────────────────── Losange — cerf-volant (périmètre)

  void _drawLosangePerimeter(Canvas c, Size s, int side, String unit) {
    _skyBackground(c, s);

    final cx = s.width / 2;
    final cy = s.height * 0.45;
    final hw = s.width * 0.30;  // demi-largeur
    final hh = s.height * 0.38; // demi-hauteur

    final top = Offset(cx, cy - hh);
    final right = Offset(cx + hw, cy);
    final bottom = Offset(cx, cy + hh);
    final left = Offset(cx - hw, cy);

    // 4 triangles colorés (cerf-volant)
    final colors = [
      const Color(0xFFEF5350),
      const Color(0xFF42A5F5),
      const Color(0xFFFFCA28),
      const Color(0xFF66BB6A),
    ];
    final quad = [
      [top, right, Offset(cx, cy)],
      [right, bottom, Offset(cx, cy)],
      [bottom, left, Offset(cx, cy)],
      [left, top, Offset(cx, cy)],
    ];
    for (int i = 0; i < 4; i++) {
      final p = Path()
        ..moveTo(quad[i][0].dx, quad[i][0].dy)
        ..lineTo(quad[i][1].dx, quad[i][1].dy)
        ..lineTo(quad[i][2].dx, quad[i][2].dy)
        ..close();
      c.drawPath(p, Paint()..color = colors[i]);
    }
    // Contour
    final outline = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(left.dx, left.dy)
      ..close();
    c.drawPath(
      outline,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Ficelle
    _kiteString(c, bottom, s.height);

    // Label côté
    _label(c, '$side $unit', Offset.lerp(top, right, 0.5)! + const Offset(16, -4));
    // Ticks côtés égaux
    final tPaint = Paint()..color = Colors.white..strokeWidth = 1.4;
    for (final edge in [[top, right], [right, bottom], [bottom, left], [left, top]]) {
      _tick(c, Offset.lerp(edge[0], edge[1], 0.5)!,
            (edge[1] - edge[0]).normalized(), tPaint);
    }
  }

  // ─────────────────────────────────────── Losange — cerf-volant (aire)

  void _drawLosangeArea(Canvas c, Size s, int big, int small, String unit) {
    _skyBackground(c, s);

    final cx = s.width / 2;
    final cy = s.height * 0.45;
    final hw = s.width * 0.30;
    final hh = s.height * 0.38;

    final top = Offset(cx, cy - hh);
    final right = Offset(cx + hw, cy);
    final bottom = Offset(cx, cy + hh);
    final left = Offset(cx - hw, cy);

    final colors = [
      const Color(0xFFEF5350), const Color(0xFF42A5F5),
      const Color(0xFFFFCA28), const Color(0xFF66BB6A),
    ];
    final quad = [
      [top, right, Offset(cx, cy)],
      [right, bottom, Offset(cx, cy)],
      [bottom, left, Offset(cx, cy)],
      [left, top, Offset(cx, cy)],
    ];
    for (int i = 0; i < 4; i++) {
      final p = Path()
        ..moveTo(quad[i][0].dx, quad[i][0].dy)
        ..lineTo(quad[i][1].dx, quad[i][1].dy)
        ..lineTo(quad[i][2].dx, quad[i][2].dy)
        ..close();
      c.drawPath(p, Paint()..color = colors[i]);
    }
    final outline = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(left.dx, left.dy)
      ..close();
    c.drawPath(outline, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);

    // Diagonales en tirets
    final dp = Paint()..color = Colors.white..strokeWidth = 1.8;
    _dashedLine(c, top, bottom, dp);
    _dashedLine(c, left, right, dp);

    _kiteString(c, bottom, s.height);

    _label(c, '$big $unit', Offset(cx - 26, cy - hh / 2 - 8),
        bgColor: Colors.white.withValues(alpha: 0.9));
    _label(c, '$small $unit', Offset(cx + hw / 2 + 14, cy - 8),
        bgColor: Colors.white.withValues(alpha: 0.9));
  }

  // ─────────────────────────────────────── Parallélogramme — satellite (périmètre)

  void _drawParallelogramPerimeter(Canvas c, Size s, int a, int b, String unit) {
    _spaceBackground(c, s);

    final bl = Offset(s.width * 0.18, s.height * 0.84);
    final br = Offset(s.width * 0.68, s.height * 0.84);
    final slant = Offset(s.width * 0.18, -(s.height * 0.56));
    final tl = bl + slant;
    final tr = br + slant;

    _drawSatellitePanel(c, tl, tr, br, bl,
        color: const Color(0xFF1565C0));

    _label(c, '$a $unit', Offset((bl.dx + br.dx) / 2, bl.dy + 18),
        bgColor: const Color(0xFF0D1B2A).withValues(alpha: 0.9));
    _label(c, '$b $unit', Offset.lerp(tl, bl, 0.5)! + const Offset(-28, 0),
        bgColor: const Color(0xFF0D1B2A).withValues(alpha: 0.9));
  }

  // ─────────────────────────────────────── Parallélogramme — satellite (aire)

  void _drawParallelogramArea(Canvas c, Size s, int base, int height, String unit) {
    _spaceBackground(c, s);

    final bl = Offset(s.width * 0.20, s.height * 0.84);
    final br = Offset(s.width * 0.62, s.height * 0.84);
    final slant = Offset(s.width * 0.22, -(s.height * 0.58));
    final tl = bl + slant;
    final tr = br + slant;
    final foot = Offset(tl.dx, bl.dy);

    _drawSatellitePanel(c, tl, tr, br, bl,
        color: const Color(0xFF1565C0));

    final dp = Paint()..color = const Color(0xFFFFCA28)..strokeWidth = 1.8;
    _dashedLine(c, tl, foot, dp);
    _rightAngle(c, foot, const Offset(-1, 0), const Offset(0, -1), dp);

    _label(c, '$base $unit', Offset((bl.dx + br.dx) / 2, bl.dy + 18),
        bgColor: const Color(0xFF0D1B2A).withValues(alpha: 0.9));
    _label(c, '$height $unit', Offset(foot.dx - 30, (tl.dy + foot.dy) / 2),
        bgColor: const Color(0xFF0D1B2A).withValues(alpha: 0.9));
  }

  // ─────────────────────────────────────── Primitives partagées

  void _drawSatellitePanel(Canvas c, Offset tl, Offset tr, Offset br, Offset bl, {required Color color}) {
    // Corps satellite (petit rectangle)
    final bodyRect = Rect.fromCenter(
      center: Offset((tl.dx + tr.dx) / 2, (tl.dy + tr.dy) / 2 - 14),
      width: 28, height: 18,
    );
    c.drawRRect(
      RRect.fromRectAndRadius(bodyRect, const Radius.circular(4)),
      Paint()..color = const Color(0xFF607D8B),
    );
    c.drawRRect(
      RRect.fromRectAndRadius(bodyRect, const Radius.circular(4)),
      Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1,
    );
    _emoji(c, '🛰️', Offset(bodyRect.left - 4, bodyRect.top - 10), size: 16);

    // Panneau solaire (parallélogramme)
    final path = Path()
      ..moveTo(tl.dx, tl.dy)
      ..lineTo(tr.dx, tr.dy)
      ..lineTo(br.dx, br.dy)
      ..lineTo(bl.dx, bl.dy)
      ..close();
    c.drawPath(path, Paint()..color = color.withValues(alpha: 0.85));

    // Grille panneau solaire (cellules)
    final cellPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..strokeWidth = 0.8;
    for (double t = 0.25; t < 1.0; t += 0.25) {
      c.drawLine(
        Offset.lerp(tl, bl, t)!,
        Offset.lerp(tr, br, t)!,
        cellPaint,
      );
      c.drawLine(
        Offset.lerp(tl, tr, t)!,
        Offset.lerp(bl, br, t)!,
        cellPaint,
      );
    }

    c.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF90CAF9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  void _skyBackground(Canvas c, Size s) {
    c.drawRect(
      Rect.fromLTWH(0, 0, s.width, s.height),
      Paint()..color = const Color(0xFFDEEFFB),
    );
    _cloudBlob(c, Offset(s.width * 0.08, s.height * 0.12), 20);
    _cloudBlob(c, Offset(s.width * 0.78, s.height * 0.08), 16);
  }

  void _spaceBackground(Canvas c, Size s) {
    c.drawRect(
      Rect.fromLTWH(0, 0, s.width, s.height),
      Paint()..color = const Color(0xFF0D1B2A),
    );
    // Étoiles
    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.8);
    final rng = math.Random(42);
    for (int i = 0; i < 24; i++) {
      c.drawCircle(
        Offset(rng.nextDouble() * s.width, rng.nextDouble() * s.height),
        rng.nextDouble() * 1.2 + 0.4,
        starPaint,
      );
    }
  }

  void _cloudBlob(Canvas c, Offset center, double r) {
    final p = Paint()..color = Colors.white.withValues(alpha: 0.9);
    c.drawCircle(center, r, p);
    c.drawCircle(center + Offset(r * 0.9, 0), r * 0.7, p);
    c.drawCircle(center - Offset(r * 0.9, 0), r * 0.65, p);
    c.drawCircle(center + Offset(r * 0.3, -r * 0.5), r * 0.6, p);
  }

  void _kiteString(Canvas c, Offset bottom, double canvasH) {
    final stringPaint = Paint()
      ..color = const Color(0xFF795548)
      ..strokeWidth = 1.4;
    final endY = canvasH * 0.96;
    final path = Path()
      ..moveTo(bottom.dx, bottom.dy)
      ..quadraticBezierTo(
        bottom.dx + 10, bottom.dy + (endY - bottom.dy) * 0.4,
        bottom.dx - 6, endY,
      );
    c.drawPath(path, stringPaint);
    // Petits rubans
    _emoji(c, '🎀', Offset(bottom.dx - 10, bottom.dy + (endY - bottom.dy) * 0.35), size: 10);
  }

  void _label(Canvas canvas, String text, Offset center, {Color? bgColor}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: kBalooFontFamily,
          fontWeight: FontWeight.w800,
          fontSize: 13,
          color: AmaniColors.textPrimary,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final rect = Rect.fromCenter(
      center: center,
      width: tp.width + 10,
      height: tp.height + 4,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(6)),
      Paint()..color = bgColor ?? AmaniColors.surface,
    );
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  void _emoji(Canvas canvas, String emoji, Offset topLeft, {double size = 14}) {
    final tp = TextPainter(
      text: TextSpan(text: emoji, style: TextStyle(fontSize: size)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, topLeft);
  }

  void _tick(Canvas canvas, Offset mid, Offset dir, Paint paint) {
    final perp = Offset(-dir.dy, dir.dx);
    canvas.drawLine(mid - perp * 5, mid + perp * 5, paint);
  }

  void _dashedLine(Canvas canvas, Offset a, Offset b, Paint paint,
      {double dash = 5, double gap = 4}) {
    final total = (b - a).distance;
    final dir = (b - a) / total;
    var t = 0.0;
    bool draw = true;
    while (t < total) {
      final len = draw ? dash : gap;
      final end = (t + len).clamp(0.0, total);
      if (draw) canvas.drawLine(a + dir * t, a + dir * end, paint);
      t += len;
      draw = !draw;
    }
  }

  void _dashedCircle(Canvas canvas, Offset center, double r, Paint paint,
      {double dash = 0.2, double gap = 0.15}) {
    double angle = 0;
    bool draw = true;
    while (angle < math.pi * 2) {
      final len = draw ? dash : gap;
      if (draw) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: r),
          angle, len, false, paint,
        );
      }
      angle += len;
      draw = !draw;
    }
  }

  void _rightAngle(Canvas canvas, Offset corner, Offset u, Offset v, Paint paint) {
    const s = 10.0;
    final p1 = corner + u * s;
    final p2 = corner + u * s + v * s;
    final p3 = corner + v * s;
    canvas.drawPath(
      Path()
        ..moveTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..lineTo(p3.dx, p3.dy),
      paint,
    );
  }
}

// Extension utilitaire
extension _OffsetNorm on Offset {
  Offset normalized() {
    final d = distance;
    return d == 0 ? this : this / d;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Schéma combiné (périmètre + aire) — affiche TOUTES les dimensions
// ─────────────────────────────────────────────────────────────────────────────

/// Comme [ShapeCalcDiagram] mais prend un [ShapeCombinedProblem] et affiche
/// simultanément toutes les dimensions nécessaires aux deux calculs.
class ShapeCombinedDiagram extends StatelessWidget {
  final ShapeCombinedProblem problem;
  final double width;
  final double height;

  const ShapeCombinedDiagram({
    super.key,
    required this.problem,
    this.width = 260,
    this.height = 190,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(painter: _ShapeCombinedPainter(problem)),
      ),
    );
  }
}

class _ShapeCombinedPainter extends CustomPainter {
  final ShapeCombinedProblem problem;
  const _ShapeCombinedPainter(this.problem);

  @override
  void paint(Canvas canvas, Size size) {
    final d = problem.dimensions;
    const unit = 'm';
    switch (problem.shapeId) {
      case 'carre':
        _drawCarre(canvas, size, d['side']!, unit);
        break;
      case 'rectangle':
        _drawRectangle(canvas, size, d['length']!, d['width']!, unit);
        break;
      case 'triangle':
        _drawTriangleCombined(canvas, size, d['base']!, d['height']!, d['a']!, unit);
        break;
      case 'cercle':
        _drawCercle(canvas, size, d['radius']!, unit);
        break;
      case 'parallelogramme':
        _drawParallelogramCombined(canvas, size, d['base']!, d['height']!, d['sideB']!, unit);
        break;
      case 'losange':
        _drawLosangeCombined(canvas, size, d['bigDiagonal']!, d['smallDiagonal']!, d['side']!, unit);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _ShapeCombinedPainter old) => old.problem != problem;

  // ── Carré — identique au diagramme périmètre (côté suffit pour les deux) ──

  void _drawCarre(Canvas canvas, Size s, int side, String unit) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, s.width, s.height),
      Paint()..color = const Color(0xFFD4EDA4),
    );
    final grassPaint = Paint()
      ..color = const Color(0xFFBFDC8C)
      ..strokeWidth = s.height / 10;
    for (int i = 0; i < 5; i++) {
      if (i.isEven) {
        canvas.drawLine(
          Offset(0, s.height * 0.1 + i * s.height * 0.18),
          Offset(s.width, s.height * 0.1 + i * s.height * 0.18),
          grassPaint,
        );
      }
    }
    final fieldSize = math.min(s.width * 0.56, s.height * 0.68);
    final ox = (s.width - fieldSize) / 2;
    final oy = (s.height - fieldSize) / 2 - 8;
    final rect = Rect.fromLTWH(ox, oy, fieldSize, fieldSize);
    canvas.drawRect(rect, Paint()..color = const Color(0xFF5DB83B));
    canvas.drawRect(rect, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2.5);
    final mid = rect.center;
    _dashedLine(canvas, Offset(mid.dx, rect.top), Offset(mid.dx, rect.bottom),
        Paint()..color = Colors.white..strokeWidth = 1.6, dash: 5, gap: 4);
    _dashedCircle(canvas, mid, fieldSize * 0.18,
        Paint()..color = Colors.white..strokeWidth = 1.6);
    _emoji(canvas, '🐜', Offset(rect.left - 10, rect.top - 12), size: 13);
    _emoji(canvas, '🐜', Offset(rect.right - 4, rect.top - 12), size: 13);
    _emoji(canvas, '🐜', Offset(rect.left - 10, rect.bottom - 2), size: 13);
    _emoji(canvas, '🐜', Offset(rect.right - 4, rect.bottom - 2), size: 13);
    final tickPaint = Paint()..color = Colors.white..strokeWidth = 1.4;
    for (final edge in [
      [rect.topLeft, rect.topRight],
      [rect.bottomLeft, rect.bottomRight],
      [rect.topLeft, rect.bottomLeft],
      [rect.topRight, rect.bottomRight],
    ]) {
      _tick(canvas, Offset.lerp(edge[0], edge[1], 0.5)!,
          (edge[1] - edge[0]).normalized(), tickPaint);
    }
    _label(canvas, '$side $unit', Offset(rect.center.dx, rect.bottom + 18));
  }

  // ── Rectangle — identique (longueur + largeur suffisent pour les deux) ──

  void _drawRectangle(Canvas canvas, Size s, int length, int width, String unit) {
    canvas.drawRect(Rect.fromLTWH(0, 0, s.width, s.height),
        Paint()..color = const Color(0xFFE1F5FE));
    final pw = s.width * 0.74;
    final ph = s.height * 0.62;
    final ox = (s.width - pw) / 2;
    final oy = (s.height - ph) / 2 - 6;
    final rect = Rect.fromLTWH(ox, oy, pw, ph);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(10)),
        Paint()..color = const Color(0xFF4FC3F7));
    final wavePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    for (int i = 0; i < 3; i++) {
      final wy = rect.top + ph * 0.2 + i * ph * 0.22;
      final path = Path();
      for (double x = rect.left + 4; x < rect.right - 4; x += 16) {
        if (x == rect.left + 4) {
          path.moveTo(x, wy);
        } else {
          path.relativeQuadraticBezierTo(8, -5, 16, 0);
        }
      }
      canvas.drawPath(path, wavePaint);
    }
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(10)),
        Paint()..color = const Color(0xFF0277BD)..style = PaintingStyle.stroke..strokeWidth = 2.5);
    _emoji(canvas, '🐬', Offset(rect.center.dx - 8, rect.center.dy - 10), size: 22);
    _label(canvas, '$length $unit', Offset(rect.center.dx, rect.bottom + 18));
    _label(canvas, '$width $unit', Offset(rect.right + 26, rect.center.dy));
  }

  // ── Triangle — isocèle : base + hauteur (tirets) + côté ──

  void _drawTriangleCombined(Canvas c, Size s, int base, int height, int side, String unit) {
    c.drawRect(Rect.fromLTWH(0, 0, s.width, s.height),
        Paint()..color = const Color(0xFFF9F3DC));

    // Triangle isocèle symétrique
    final apex = Offset(s.width / 2, s.height * 0.1);
    final bl = Offset(s.width * 0.14, s.height * 0.84);
    final br = Offset(s.width * 0.86, s.height * 0.84);
    final foot = Offset(apex.dx, bl.dy);

    final path = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(br.dx, br.dy)
      ..lineTo(bl.dx, bl.dy)
      ..close();
    c.drawPath(path, Paint()..color = const Color(0xFF66BB6A));
    c.drawPath(path, Paint()..color = const Color(0xFF2E7D32)..style = PaintingStyle.stroke..strokeWidth = 2.5);
    _emoji(c, '🌻', Offset(s.width / 2 - 8, s.height / 2 - 4), size: 15);

    // Hauteur en tirets
    final dp = Paint()..color = const Color(0xFF1565C0)..strokeWidth = 1.8;
    _dashedLine(c, apex, foot, dp);
    _rightAngle(c, foot, const Offset(-1, 0), const Offset(0, -1), dp);

    // Ticks côtés égaux
    final tPaint = Paint()..color = const Color(0xFF2E7D32).withValues(alpha: 0.7)..strokeWidth = 1.4;
    _tick(c, Offset.lerp(apex, bl, 0.5)!, (bl - apex).normalized(), tPaint);
    _tick(c, Offset.lerp(apex, br, 0.5)!, (br - apex).normalized(), tPaint);

    // Labels
    _label(c, '$base $unit', Offset(s.width / 2, bl.dy + 18));
    _label(c, '$height $unit', Offset(foot.dx + 34, (apex.dy + foot.dy) / 2));
    _label(c, '$side $unit', Offset.lerp(apex, bl, 0.5)! + const Offset(-28, 0));
  }

  // ── Cercle — identique (rayon suffit pour les deux) ──

  void _drawCercle(Canvas c, Size s, int radius, String unit) {
    c.drawRect(Rect.fromLTWH(0, 0, s.width, s.height),
        Paint()..color = const Color(0xFFE3F2FD));
    _cloudBlob(c, Offset(s.width * 0.1, s.height * 0.1), 22);
    _cloudBlob(c, Offset(s.width * 0.82, s.height * 0.08), 18);
    final cx = s.width / 2;
    final cy = s.height * 0.46;
    final r = math.min(s.width * 0.34, s.height * 0.38);
    final standPaint = Paint()..color = const Color(0xFF8D6E63)..strokeWidth = 3.5..strokeCap = StrokeCap.round;
    c.drawLine(Offset(cx - r * 0.6, cy + r), Offset(cx, cy + r * 0.08), standPaint);
    c.drawLine(Offset(cx + r * 0.6, cy + r), Offset(cx, cy + r * 0.08), standPaint);
    c.drawLine(Offset(cx - r * 0.8, cy + r + 1), Offset(cx + r * 0.8, cy + r + 1),
        Paint()..color = const Color(0xFF8D6E63)..strokeWidth = 3);
    c.drawCircle(Offset(cx, cy), r, Paint()..color = const Color(0xFFFFF9C4));
    c.drawCircle(Offset(cx, cy), r,
        Paint()..color = const Color(0xFFF57F17)..style = PaintingStyle.stroke..strokeWidth = 3);
    final spokePaint = Paint()..color = const Color(0xFFFF8F00)..strokeWidth = 1.5;
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      c.drawLine(Offset(cx, cy), Offset(cx + r * math.cos(angle), cy + r * math.sin(angle)), spokePaint);
    }
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final gx = cx + r * math.cos(angle);
      final gy = cy + r * math.sin(angle);
      c.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(gx, gy + 6), width: 10, height: 7),
            const Radius.circular(3)),
        Paint()..color = [
          const Color(0xFFF44336), const Color(0xFF2196F3),
          const Color(0xFF4CAF50), const Color(0xFFFF9800),
          const Color(0xFF9C27B0), const Color(0xFF00BCD4),
          const Color(0xFFE91E63), const Color(0xFFFFEB3B),
        ][i],
      );
    }
    c.drawCircle(Offset(cx, cy), 6, Paint()..color = const Color(0xFFBF360C));
    final dashedPaint = Paint()..color = const Color(0xFF1565C0)..strokeWidth = 1.8;
    _dashedLine(c, Offset(cx, cy), Offset(cx + r, cy), dashedPaint);
    c.drawCircle(Offset(cx, cy), 2, Paint()..color = const Color(0xFF1565C0));
    _label(c, '$radius $unit', Offset(cx + r / 2, cy - 14));
  }

  // ── Parallélogramme combiné : base + hauteur (tirets) + côté oblique ──

  void _drawParallelogramCombined(Canvas c, Size s, int base, int height, int sideB, String unit) {
    _spaceBackground(c, s);

    final bl = Offset(s.width * 0.20, s.height * 0.84);
    final br = Offset(s.width * 0.62, s.height * 0.84);
    final slant = Offset(s.width * 0.22, -(s.height * 0.58));
    final tl = bl + slant;
    final tr = br + slant;
    final foot = Offset(tl.dx, bl.dy);

    _drawSatellitePanel(c, tl, tr, br, bl, color: const Color(0xFF1565C0));

    // Hauteur en tirets
    final dp = Paint()..color = const Color(0xFFFFCA28)..strokeWidth = 1.8;
    _dashedLine(c, tl, foot, dp);
    _rightAngle(c, foot, const Offset(-1, 0), const Offset(0, -1), dp);

    _label(c, '$base $unit', Offset((bl.dx + br.dx) / 2, bl.dy + 18),
        bgColor: const Color(0xFF0D1B2A).withValues(alpha: 0.9));
    _label(c, '$height $unit', Offset(foot.dx - 30, (tl.dy + foot.dy) / 2),
        bgColor: const Color(0xFF0D1B2A).withValues(alpha: 0.9));
    // Côté oblique (gauche)
    _label(c, '$sideB $unit', Offset.lerp(tl, bl, 0.5)! + const Offset(-30, 0),
        bgColor: const Color(0xFF0D1B2A).withValues(alpha: 0.9));
  }

  // ── Losange combiné : deux diagonales (tirets) + côté ──

  void _drawLosangeCombined(Canvas c, Size s, int big, int small, int side, String unit) {
    _skyBackground(c, s);

    final cx = s.width / 2;
    final cy = s.height * 0.45;
    final hw = s.width * 0.30;
    final hh = s.height * 0.38;

    final top = Offset(cx, cy - hh);
    final right = Offset(cx + hw, cy);
    final bottom = Offset(cx, cy + hh);
    final left = Offset(cx - hw, cy);

    final colors = [
      const Color(0xFFEF5350), const Color(0xFF42A5F5),
      const Color(0xFFFFCA28), const Color(0xFF66BB6A),
    ];
    final quad = [
      [top, right, Offset(cx, cy)],
      [right, bottom, Offset(cx, cy)],
      [bottom, left, Offset(cx, cy)],
      [left, top, Offset(cx, cy)],
    ];
    for (int i = 0; i < 4; i++) {
      final p = Path()
        ..moveTo(quad[i][0].dx, quad[i][0].dy)
        ..lineTo(quad[i][1].dx, quad[i][1].dy)
        ..lineTo(quad[i][2].dx, quad[i][2].dy)
        ..close();
      c.drawPath(p, Paint()..color = colors[i]);
    }
    final outline = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(left.dx, left.dy)
      ..close();
    c.drawPath(outline, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);

    // Diagonales en tirets
    final dp = Paint()..color = Colors.white..strokeWidth = 1.8;
    _dashedLine(c, top, bottom, dp);
    _dashedLine(c, left, right, dp);

    _kiteString(c, bottom, s.height);

    // Labels diagonales
    _label(c, '$big $unit', Offset(cx - 26, cy - hh / 2 - 8),
        bgColor: Colors.white.withValues(alpha: 0.9));
    _label(c, '$small $unit', Offset(cx + hw / 2 + 14, cy - 8),
        bgColor: Colors.white.withValues(alpha: 0.9));
    // Label côté (bord haut-droite)
    _label(c, '$side $unit', Offset.lerp(top, right, 0.5)! + const Offset(16, -6),
        bgColor: Colors.white.withValues(alpha: 0.9));
    // Tick côtés égaux
    final tPaint = Paint()..color = Colors.white..strokeWidth = 1.4;
    for (final edge in [[top, right], [right, bottom], [bottom, left], [left, top]]) {
      _tick(c, Offset.lerp(edge[0], edge[1], 0.5)!,
          (edge[1] - edge[0]).normalized(), tPaint);
    }
  }

  // ── Primitives partagées (copie de _ShapeCalcPainter) ──

  void _drawSatellitePanel(Canvas c, Offset tl, Offset tr, Offset br, Offset bl, {required Color color}) {
    final bodyRect = Rect.fromCenter(
      center: Offset((tl.dx + tr.dx) / 2, (tl.dy + tr.dy) / 2 - 14),
      width: 28, height: 18,
    );
    c.drawRRect(RRect.fromRectAndRadius(bodyRect, const Radius.circular(4)),
        Paint()..color = const Color(0xFF607D8B));
    c.drawRRect(RRect.fromRectAndRadius(bodyRect, const Radius.circular(4)),
        Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1);
    _emoji(c, '🛰️', Offset(bodyRect.left - 4, bodyRect.top - 10), size: 16);
    final path = Path()
      ..moveTo(tl.dx, tl.dy)
      ..lineTo(tr.dx, tr.dy)
      ..lineTo(br.dx, br.dy)
      ..lineTo(bl.dx, bl.dy)
      ..close();
    c.drawPath(path, Paint()..color = color.withValues(alpha: 0.85));
    final cellPaint = Paint()..color = Colors.white.withValues(alpha: 0.25)..strokeWidth = 0.8;
    for (double t = 0.25; t < 1.0; t += 0.25) {
      c.drawLine(Offset.lerp(tl, bl, t)!, Offset.lerp(tr, br, t)!, cellPaint);
      c.drawLine(Offset.lerp(tl, tr, t)!, Offset.lerp(bl, br, t)!, cellPaint);
    }
    c.drawPath(path, Paint()..color = const Color(0xFF90CAF9)..style = PaintingStyle.stroke..strokeWidth = 2.5);
  }

  void _skyBackground(Canvas c, Size s) {
    c.drawRect(Rect.fromLTWH(0, 0, s.width, s.height),
        Paint()..color = const Color(0xFFDEEFFB));
    _cloudBlob(c, Offset(s.width * 0.08, s.height * 0.12), 20);
    _cloudBlob(c, Offset(s.width * 0.78, s.height * 0.08), 16);
  }

  void _spaceBackground(Canvas c, Size s) {
    c.drawRect(Rect.fromLTWH(0, 0, s.width, s.height),
        Paint()..color = const Color(0xFF0D1B2A));
    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.8);
    final rng = math.Random(42);
    for (int i = 0; i < 24; i++) {
      c.drawCircle(
        Offset(rng.nextDouble() * s.width, rng.nextDouble() * s.height),
        rng.nextDouble() * 1.2 + 0.4, starPaint,
      );
    }
  }

  void _cloudBlob(Canvas c, Offset center, double r) {
    final p = Paint()..color = Colors.white.withValues(alpha: 0.9);
    c.drawCircle(center, r, p);
    c.drawCircle(center + Offset(r * 0.9, 0), r * 0.7, p);
    c.drawCircle(center - Offset(r * 0.9, 0), r * 0.65, p);
    c.drawCircle(center + Offset(r * 0.3, -r * 0.5), r * 0.6, p);
  }

  void _kiteString(Canvas c, Offset bottom, double canvasH) {
    final stringPaint = Paint()..color = const Color(0xFF795548)..strokeWidth = 1.4;
    final endY = canvasH * 0.96;
    final path = Path()
      ..moveTo(bottom.dx, bottom.dy)
      ..quadraticBezierTo(bottom.dx + 10, bottom.dy + (endY - bottom.dy) * 0.4,
          bottom.dx - 6, endY);
    c.drawPath(path, stringPaint);
    _emoji(c, '🎀', Offset(bottom.dx - 10, bottom.dy + (endY - bottom.dy) * 0.35), size: 10);
  }

  void _label(Canvas canvas, String text, Offset center, {Color? bgColor}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: kBalooFontFamily,
          fontWeight: FontWeight.w800,
          fontSize: 13,
          color: AmaniColors.textPrimary,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final rect = Rect.fromCenter(center: center, width: tp.width + 10, height: tp.height + 4);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)),
        Paint()..color = bgColor ?? AmaniColors.surface);
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  void _emoji(Canvas canvas, String emoji, Offset topLeft, {double size = 14}) {
    final tp = TextPainter(
      text: TextSpan(text: emoji, style: TextStyle(fontSize: size)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, topLeft);
  }

  void _tick(Canvas canvas, Offset mid, Offset dir, Paint paint) {
    final perp = Offset(-dir.dy, dir.dx);
    canvas.drawLine(mid - perp * 5, mid + perp * 5, paint);
  }

  void _dashedLine(Canvas canvas, Offset a, Offset b, Paint paint,
      {double dash = 5, double gap = 4}) {
    final total = (b - a).distance;
    final dir = (b - a) / total;
    var t = 0.0;
    bool draw = true;
    while (t < total) {
      final len = draw ? dash : gap;
      final end = (t + len).clamp(0.0, total);
      if (draw) canvas.drawLine(a + dir * t, a + dir * end, paint);
      t += len;
      draw = !draw;
    }
  }

  void _dashedCircle(Canvas canvas, Offset center, double r, Paint paint,
      {double dash = 0.2, double gap = 0.15}) {
    double angle = 0;
    bool draw = true;
    while (angle < math.pi * 2) {
      final len = draw ? dash : gap;
      if (draw) {
        canvas.drawArc(Rect.fromCircle(center: center, radius: r), angle, len, false, paint);
      }
      angle += len;
      draw = !draw;
    }
  }

  void _rightAngle(Canvas canvas, Offset corner, Offset u, Offset v, Paint paint) {
    const sz = 10.0;
    final p1 = corner + u * sz;
    final p2 = corner + u * sz + v * sz;
    final p3 = corner + v * sz;
    canvas.drawPath(
      Path()..moveTo(p1.dx, p1.dy)..lineTo(p2.dx, p2.dy)..lineTo(p3.dx, p3.dy),
      paint,
    );
  }
}
