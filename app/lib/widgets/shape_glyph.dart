import 'package:flutter/material.dart';

/// Icône simple d'une figure de base (carré, rectangle, triangle, cercle) —
/// utilisée dans les mini-jeux du Palier "Figures géométriques" (ex.
/// "Quelle est cette figure ?"). Formes dessinées directement (bordures/
/// `CustomPaint`), aucun asset nécessaire.
class ShapeGlyph extends StatelessWidget {
  final String shapeId;
  final Color color;
  final double size;
  const ShapeGlyph({
    super.key,
    required this.shapeId,
    this.color = const Color(0xFFB85454),
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    switch (shapeId) {
      case 'carre':
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(border: Border.all(color: color, width: size * 0.08)),
        );
      case 'rectangle':
        return Container(
          width: size * 1.4,
          height: size * 0.75,
          decoration: BoxDecoration(border: Border.all(color: color, width: size * 0.08)),
        );
      case 'triangle':
        return CustomPaint(
          size: Size(size, size),
          painter: _TrianglePainter(color: color, strokeWidth: size * 0.08),
        );
      case 'cercle':
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: size * 0.08),
          ),
        );
      case 'parallelogramme':
        return CustomPaint(
          size: Size(size * 1.4, size * 0.8),
          painter: _ParallelogramPainter(color: color, strokeWidth: size * 0.08),
        );
      case 'losange':
        return CustomPaint(
          size: Size(size, size),
          painter: _LosangePainter(color: color, strokeWidth: size * 0.08),
        );
      default:
        return SizedBox(width: size, height: size);
    }
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  const _TrianglePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

class _ParallelogramPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  const _ParallelogramPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.25, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width * 0.75, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ParallelogramPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

class _LosangePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  const _LosangePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, size.height / 2)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _LosangePainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}
