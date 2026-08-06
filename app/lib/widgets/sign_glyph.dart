import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

enum SignFamily { trait, courbe, point, crochet }

class SignFamilyColors {
  final Color bg;
  final Color stroke;
  const SignFamilyColors(this.bg, this.stroke);
}

/// Couleurs de badge par famille de signe — copie exacte de
/// `glyphColorByFamily` (src/components/amani/SignGlyph.tsx).
const Map<SignFamily, SignFamilyColors> glyphColorByFamily = {
  SignFamily.trait: SignFamilyColors(Color(0xFFFFFFFF), Color(0xFF4A3B2A)),
  SignFamily.courbe: SignFamilyColors(Color(0xFFE05252), Color(0xFFFFFFFF)),
  SignFamily.point: SignFamilyColors(Color(0xFFF5EDE0), Color(0xFF4A3B2A)),
  SignFamily.crochet: SignFamilyColors(Color(0xFF4A90E2), Color(0xFFFFFFFF)),
};

String signFamilyKey(SignFamily f) => f.name;

const double _sw = 16.0;
const double _pad = 28.0;
const double _cx = 100.0;

class SignGlyph extends StatelessWidget {
  final SignFamily family;
  final Color stroke;
  final String variant;
  final String? strokeDasharray;
  final double? strokeWidth;
  final double size;

  const SignGlyph({
    super.key,
    required this.family,
    this.stroke = const Color(0xFF4A3B2A),
    this.variant = 'vertical',
    this.strokeDasharray,
    this.strokeWidth,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SignPainter(
          family: family,
          stroke: stroke,
          variant: variant,
          strokeDasharray: strokeDasharray,
          strokeWidth: strokeWidth ?? (strokeDasharray != null ? 4.5 : _sw),
        ),
      ),
    );
  }
}

class _SignPainter extends CustomPainter {
  final SignFamily family;
  final Color stroke;
  final String variant;
  final String? strokeDasharray;
  final double strokeWidth;

  _SignPainter({
    required this.family,
    required this.stroke,
    required this.variant,
    this.strokeDasharray,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Le viewport React est 0 0 200 200. On applique un scale.
    final scale = size.width / 200.0;
    canvas.save();
    canvas.scale(scale, scale);

    final paint = Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final isDashed = strokeDasharray != null;
    if (isDashed) {
      // Pour cet exemple on simplifie les dashes à [10, 10]
      // Dans une implémentation complète, on parserait strokeDasharray
    }

    switch (family) {
      case SignFamily.trait:
        _drawTrait(canvas, paint);
        break;
      case SignFamily.courbe:
        _drawCourbe(canvas, paint);
        break;
      case SignFamily.point:
        _drawPoint(canvas, paint);
        break;
      case SignFamily.crochet:
        _drawCrochet(canvas, paint);
        break;
    }

    canvas.restore();
  }

  void _drawTrait(Canvas canvas, Paint paint) {
    double x1 = _cx, y1 = _pad, x2 = _cx, y2 = 200 - _pad;
    if (variant == 'horizontal') {
      x1 = _pad;
      y1 = _cx;
      x2 = 200 - _pad;
      y2 = _cx;
    } else if (variant == 'oblique-gauche') {
      x1 = 40;
      y1 = 40;
      x2 = 160;
      y2 = 160;
    } else if (variant == 'oblique-droit') {
      x1 = 160;
      y1 = 40;
      x2 = 40;
      y2 = 160;
    }
    _drawLine(canvas, paint, Offset(x1, y1), Offset(x2, y2));
  }

  void _drawCourbe(Canvas canvas, Paint paint) {
    if (variant == 'open-right') {
      _drawPath(canvas, paint, 'M 130 35 A 65 65 0 0 0 130 165');
    } else if (variant == 'open-left') {
      _drawPath(canvas, paint, 'M 70 35 A 65 65 0 0 1 70 165');
    } else if (variant == 'bridge') {
      _drawPath(canvas, paint, 'M 35 130 A 65 65 0 0 1 165 130');
    } else if (variant == 'bowl') {
      _drawPath(canvas, paint, 'M 35 70 A 65 65 0 0 0 165 70');
    } else if (variant == 'closed') {
      paint.style = PaintingStyle.stroke;
      canvas.drawCircle(const Offset(100, 100), 68, paint);
    } else {
      _drawPath(canvas, paint, 'M 75 45 A 55 55 0 0 0 75 155');
      _drawPath(canvas, paint, 'M 125 45 A 55 55 0 0 1 125 155');
    }
  }

  void _drawPoint(Canvas canvas, Paint paint) {
    paint.style = strokeDasharray != null
        ? PaintingStyle.stroke
        : PaintingStyle.fill;

    if (variant == 'top') {
      canvas.drawCircle(const Offset(_cx, 60), 18, paint);
    } else if (variant == 'bottom') {
      canvas.drawCircle(const Offset(_cx, 140), 18, paint);
    } else if (variant == 'double') {
      canvas.drawCircle(const Offset(68, 100), 16, paint);
      canvas.drawCircle(const Offset(132, 100), 16, paint);
    } else {
      canvas.drawCircle(const Offset(_cx, 100), 18, paint);
    }
  }

  void _drawCrochet(Canvas canvas, Paint paint) {
    String d = 'M 150 70 A 45 45 0 0 0 60 70 L 60 170';
    if (variant == 'top-left') {
      d = 'M 50 70 A 45 45 0 0 1 140 70 L 140 170';
    } else if (variant == 'bottom-right') {
      d = 'M 60 30 L 60 130 A 45 45 0 0 0 150 130';
    } else if (variant == 'bottom-left') {
      d = 'M 140 30 L 140 130 A 45 45 0 0 1 50 130';
    } else if (variant == 'double-crochet-gauche') {
      d = 'M 65 55 C 65 25, 130 25, 130 80 L 130 120 C 130 175, 65 175, 65 145';
    } else if (variant == 'double-crochet-droit') {
      d = 'M 135 55 C 135 25, 70 25, 70 80 L 70 120 C 70 175, 135 175, 135 145';
    } else if (variant == 'double-crochet-gauche-droit') {
      d = 'M 60 55 C 60 25, 100 25, 100 80 L 100 120 C 100 175, 140 175, 140 145';
    } else if (variant == 'double-crochet-droit-gauche') {
      d = 'M 140 55 C 140 25, 100 25, 100 80 L 100 120 C 100 175, 60 175, 60 145';
    }
    _drawPath(canvas, paint, d);
  }

  void _drawLine(Canvas canvas, Paint paint, Offset p1, Offset p2) {
    if (strokeDasharray != null) {
      final path = Path()
        ..moveTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy);
      canvas.drawPath(
        dashPath(path, dashArray: CircularIntervalList<double>([10, 10])),
        paint,
      );
    } else {
      canvas.drawLine(p1, p2, paint);
    }
  }

  void _drawPath(Canvas canvas, Paint paint, String svgPath) {
    final path = parseSvgPathData(svgPath);
    if (strokeDasharray != null) {
      canvas.drawPath(
        dashPath(path, dashArray: CircularIntervalList<double>([10, 10])),
        paint,
      );
    } else {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_SignPainter oldDelegate) {
    return oldDelegate.family != family ||
        oldDelegate.stroke != stroke ||
        oldDelegate.variant != variant ||
        oldDelegate.strokeDasharray != strokeDasharray ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
