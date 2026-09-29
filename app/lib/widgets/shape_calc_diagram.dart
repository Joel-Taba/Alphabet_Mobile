import 'package:flutter/material.dart';
import '../theme/amani_theme.dart';
import '../data/shape_calc_problem.dart';

/// Schéma léger (trait + remplissage discret) annotant UNIQUEMENT les
/// dimensions nécessaires au problème actif (`ShapeCalcProblem.dimensions`)
/// — jamais toutes les mesures possibles de la figure, pour que l'essentiel
/// de l'information de l'exercice tienne dans ce dessin plutôt que dans un
/// énoncé long. Géométrie de base alignée sur `ShapeGlyph`
/// (`lib/widgets/shape_glyph.dart`), avec en plus les cotations.
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
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _ShapeCalcPainter(problem)),
    );
  }
}

const _kStroke = AmaniColors.textPrimary;
const _kFill = Color(0x268FBF6F); // AmaniColors.secondary à faible opacité

class _ShapeCalcPainter extends CustomPainter {
  final ShapeCalcProblem problem;
  const _ShapeCalcPainter(this.problem);

  @override
  void paint(Canvas canvas, Size size) {
    final outline = Paint()
      ..color = _kStroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = _kFill
      ..style = PaintingStyle.fill;
    final dashed = Paint()
      ..color = _kStroke.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final d = problem.dimensions;
    // Les dimensions données sont toujours exactes -- seule la réponse
    // (calculée à partir de π ≈ 3,14) est arrondie, voir
    // `ShapeCalcProblem.isApproximate` et `exerciceFigure.roundedHint`.
    const unit = 'm';

    switch (problem.shapeId) {
      case 'carre':
        _square(canvas, size, fill, outline, d['side']!, unit);
        break;
      case 'rectangle':
        _rectangle(canvas, size, fill, outline, d['length']!, d['width']!, unit);
        break;
      case 'triangle':
        if (problem.kind == ShapeCalcKind.perimeter) {
          _trianglePerimeter(
            canvas, size, fill, outline, d['a']!, d['b']!, d['c']!, unit,
          );
        } else {
          _triangleArea(
            canvas, size, fill, outline, dashed, d['base']!, d['height']!, unit,
          );
        }
        break;
      case 'cercle':
        _circle(canvas, size, fill, outline, dashed, d['radius']!, unit);
        break;
      case 'parallelogramme':
        if (problem.kind == ShapeCalcKind.perimeter) {
          _parallelogramPerimeter(canvas, size, fill, outline, d['a']!, d['b']!, unit);
        } else {
          _parallelogramArea(
            canvas, size, fill, outline, dashed, d['base']!, d['height']!, unit,
          );
        }
        break;
      case 'losange':
        if (problem.kind == ShapeCalcKind.perimeter) {
          _losangePerimeter(canvas, size, fill, outline, d['side']!, unit);
        } else {
          _losangeArea(
            canvas, size, fill, outline, dashed,
            d['bigDiagonal']!, d['smallDiagonal']!, unit,
          );
        }
        break;
    }
  }

  // ─── Helpers ────────────────────────────────────────────────────────────

  void _label(Canvas canvas, String text, Offset center, {Color? bg}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: kBalooFontFamily,
          fontWeight: FontWeight.w800,
          fontSize: 13,
          color: _kStroke,
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
      Paint()..color = bg ?? AmaniColors.surface,
    );
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  void _tick(Canvas canvas, Offset mid, Offset dir, Paint paint) {
    final perp = Offset(-dir.dy, dir.dx);
    canvas.drawLine(mid - perp * 5, mid + perp * 5, paint);
  }

  void _dashedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dashLen = 5.0;
    final total = (b - a).distance;
    final dir = (b - a) / total;
    var travelled = 0.0;
    while (travelled < total) {
      final segEnd = (travelled + dashLen).clamp(0.0, total);
      canvas.drawLine(a + dir * travelled, a + dir * segEnd, paint);
      travelled += dashLen * 2;
    }
  }

  void _rightAngleMark(Canvas canvas, Offset corner, Offset u, Offset v, Paint paint) {
    const s = 10.0;
    final p1 = corner + u * s;
    final p2 = corner + u * s + v * s;
    final p3 = corner + v * s;
    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy);
    canvas.drawPath(path, paint);
  }

  // ─── Figures ────────────────────────────────────────────────────────────

  void _square(Canvas c, Size s, Paint fill, Paint outline, int side, String unit) {
    final rect = Rect.fromLTWH(s.width * 0.28, 20, s.width * 0.44, s.height - 60);
    c.drawRect(rect, fill);
    c.drawRect(rect, outline);
    for (final edge in [
      [rect.bottomLeft, rect.bottomRight],
      [rect.topLeft, rect.topRight],
      [rect.topLeft, rect.bottomLeft],
      [rect.topRight, rect.bottomRight],
    ]) {
      _tick(c, Offset.lerp(edge[0], edge[1], 0.5)!, (edge[1] - edge[0]) / (edge[1] - edge[0]).distance, outline);
    }
    _label(c, '$side $unit', Offset(rect.center.dx, rect.bottom + 24));
  }

  void _rectangle(Canvas c, Size s, Paint fill, Paint outline, int length, int width, String unit) {
    final rect = Rect.fromLTWH(s.width * 0.14, 30, s.width * 0.72, s.height - 80);
    c.drawRect(rect, fill);
    c.drawRect(rect, outline);
    _label(c, '$length $unit', Offset(rect.center.dx, rect.bottom + 24));
    _label(c, '$width $unit', Offset(rect.right + 28, rect.center.dy));
  }

  void _trianglePerimeter(
    Canvas c, Size s, Paint fill, Paint outline, int a, int b, int cSide, String unit,
  ) {
    final apex = Offset(s.width / 2, 18);
    final bl = Offset(s.width * 0.22, s.height - 40);
    final br = Offset(s.width * 0.78, s.height - 40);
    final path = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(br.dx, br.dy)
      ..lineTo(bl.dx, bl.dy)
      ..close();
    c.drawPath(path, fill);
    c.drawPath(path, outline);
    _label(c, '$a $unit', Offset.lerp(bl, apex, 0.5)! + const Offset(-20, 0));
    _label(c, '$b $unit', Offset.lerp(apex, br, 0.5)! + const Offset(20, 0));
    _label(c, '$cSide $unit', Offset(s.width / 2, bl.dy + 22));
  }

  void _triangleArea(
    Canvas c, Size s, Paint fill, Paint outline, Paint dashed,
    int base, int height, String unit,
  ) {
    final apex = Offset(s.width * 0.38, 18);
    final bl = Offset(s.width * 0.18, s.height - 40);
    final br = Offset(s.width * 0.82, s.height - 40);
    final foot = Offset(apex.dx, bl.dy);
    final path = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(br.dx, br.dy)
      ..lineTo(bl.dx, bl.dy)
      ..close();
    c.drawPath(path, fill);
    c.drawPath(path, outline);
    _dashedLine(c, apex, foot, dashed);
    _rightAngleMark(c, foot, const Offset(-1, 0), const Offset(0, -1), dashed);
    _label(c, '$base $unit', Offset(s.width / 2, bl.dy + 22));
    _label(c, '$height $unit', Offset(foot.dx + 34, (apex.dy + foot.dy) / 2));
  }

  void _circle(Canvas c, Size s, Paint fill, Paint outline, Paint dashed, int radius, String unit) {
    final center = Offset(s.width / 2, s.height / 2 - 8);
    final r = s.height * 0.34;
    c.drawCircle(center, r, fill);
    c.drawCircle(center, r, outline);
    final edge = center + Offset(r, 0);
    c.drawLine(center, edge, dashed);
    c.drawCircle(center, 2.5, Paint()..color = _kStroke);
    _label(c, '$radius $unit', Offset(center.dx + r / 2, center.dy - 16));
  }

  void _parallelogramPerimeter(
    Canvas c, Size s, Paint fill, Paint outline, int a, int b, String unit,
  ) {
    final bl = Offset(s.width * 0.18, s.height - 40);
    final br = Offset(s.width * 0.70, s.height - 40);
    // Même décalage constant appliqué aux deux sommets bas → côtés opposés
    // strictement parallèles et de même longueur (vrai parallélogramme,
    // contrairement à un trapèze qui n'aurait qu'une paire de côtés
    // parallèles).
    final slant = Offset(s.width * 0.16, -(s.height - 64));
    final tl = bl + slant;
    final tr = br + slant;
    final path = Path()
      ..moveTo(tl.dx, tl.dy)
      ..lineTo(tr.dx, tr.dy)
      ..lineTo(br.dx, br.dy)
      ..lineTo(bl.dx, bl.dy)
      ..close();
    c.drawPath(path, fill);
    c.drawPath(path, outline);
    _label(c, '$a $unit', Offset((bl.dx + br.dx) / 2, bl.dy + 22));
    _label(c, '$b $unit', Offset.lerp(tl, bl, 0.5)! + const Offset(-26, 0));
  }

  void _parallelogramArea(
    Canvas c, Size s, Paint fill, Paint outline, Paint dashed,
    int base, int height, String unit,
  ) {
    final bl = Offset(s.width * 0.20, s.height - 40);
    final br = Offset(s.width * 0.62, s.height - 40);
    final slant = Offset(s.width * 0.22, -(s.height - 64));
    final tl = bl + slant;
    final tr = br + slant;
    final foot = Offset(tl.dx, bl.dy);
    final path = Path()
      ..moveTo(tl.dx, tl.dy)
      ..lineTo(tr.dx, tr.dy)
      ..lineTo(br.dx, br.dy)
      ..lineTo(bl.dx, bl.dy)
      ..close();
    c.drawPath(path, fill);
    c.drawPath(path, outline);
    _dashedLine(c, tl, foot, dashed);
    _rightAngleMark(c, foot, const Offset(-1, 0), const Offset(0, -1), dashed);
    _label(c, '$base $unit', Offset((bl.dx + br.dx) / 2, bl.dy + 22));
    _label(c, '$height $unit', Offset(foot.dx - 30, (tl.dy + foot.dy) / 2));
  }

  void _losangePerimeter(Canvas c, Size s, Paint fill, Paint outline, int side, String unit) {
    final top = Offset(s.width / 2, 16);
    final bottom = Offset(s.width / 2, s.height - 36);
    final left = Offset(s.width * 0.2, s.height / 2 - 10);
    final right = Offset(s.width * 0.8, s.height / 2 - 10);
    final path = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(left.dx, left.dy)
      ..close();
    c.drawPath(path, fill);
    c.drawPath(path, outline);
    _label(c, '$side $unit', Offset.lerp(top, right, 0.5)! + const Offset(18, -4));
  }

  void _losangeArea(
    Canvas c, Size s, Paint fill, Paint outline, Paint dashed,
    int big, int small, String unit,
  ) {
    final centerY = s.height / 2 - 10;
    final top = Offset(s.width / 2, centerY - s.height * 0.32);
    final bottom = Offset(s.width / 2, centerY + s.height * 0.32);
    final left = Offset(s.width / 2 - s.width * 0.32, centerY);
    final right = Offset(s.width / 2 + s.width * 0.32, centerY);
    final path = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(left.dx, left.dy)
      ..close();
    c.drawPath(path, fill);
    c.drawPath(path, outline);
    _dashedLine(c, left, right, dashed);
    _dashedLine(c, top, bottom, dashed);
    _label(c, '$big $unit', Offset(s.width / 2, top.dy - 14));
    _label(c, '$small $unit', Offset(right.dx + 30, centerY));
  }

  @override
  bool shouldRepaint(covariant _ShapeCalcPainter oldDelegate) =>
      oldDelegate.problem != problem;
}
