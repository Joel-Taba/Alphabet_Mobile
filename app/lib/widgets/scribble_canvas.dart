import 'package:flutter/material.dart';

/// Page blanche de dessin libre, sans aucune cible ni validation — juste un
/// trait qui suit le doigt. Port fidèle de la partie "griffonnage" de
/// `src/routes/_app.bibliotheque.tsx`.
class ScribbleCanvas extends StatefulWidget {
  final Color penColor;
  const ScribbleCanvas({super.key, required this.penColor});

  @override
  State<ScribbleCanvas> createState() => ScribbleCanvasState();
}

class ScribbleCanvasState extends State<ScribbleCanvas> {
  final List<List<Offset>> _strokes = [];

  void clear() => setState(_strokes.clear);

  void _onPanStart(DragStartDetails d) {
    setState(() => _strokes.add([d.localPosition]));
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() => _strokes.last.add(d.localPosition));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      child: CustomPaint(
        painter: _ScribblePainter(strokes: _strokes, color: widget.penColor),
        size: Size.infinite,
      ),
    );
  }
}

class _ScribblePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color color;
  _ScribblePainter({required this.strokes, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final dotPaint = Paint()..color = color..style = PaintingStyle.fill;
    for (final stroke in strokes) {
      if (stroke.length < 2) {
        if (stroke.isNotEmpty) canvas.drawCircle(stroke.first, 3, dotPaint);
        continue;
      }
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (final p in stroke.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ScribblePainter oldDelegate) => true;
}
