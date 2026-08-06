import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import '../theme/amani_theme.dart';

class InteractiveCanvas extends StatefulWidget {
  final String targetSvgPath;
  final Function(bool isSuccess) onDrawingComplete;
  final double tolerance;

  const InteractiveCanvas({
    super.key,
    required this.targetSvgPath,
    required this.onDrawingComplete,
    this.tolerance = 30.0, // Distance max autorisée
  });

  @override
  State<InteractiveCanvas> createState() => _InteractiveCanvasState();
}

class _InteractiveCanvasState extends State<InteractiveCanvas> {
  final List<Offset> _points = [];
  bool _isDrawing = false;
  Path? _targetPathCache;
  ui.PathMetrics? _targetMetrics;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _initTargetPath();
  }

  @override
  void didUpdateWidget(InteractiveCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetSvgPath != widget.targetSvgPath) {
      _initTargetPath();
      _points.clear();
    }
  }

  void _initTargetPath() {
    // Parse the SVG path string into a Flutter Path object
    final path = parseSvgPathData(widget.targetSvgPath);
    _targetPathCache = path;
    _targetMetrics = path.computeMetrics();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDrawing = true;
      _points.clear(); // Reset on new stroke
      _points.add(details.localPosition);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isDrawing) {
      setState(() {
        _points.add(details.localPosition);
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDrawing = false;
    });
    _evaluateDrawing();
  }

  void _evaluateDrawing() {
    if (_points.length < 5 || _targetMetrics == null) {
      widget.onDrawingComplete(false);
      return;
    }

    // Simplification pour la validation de tracé : on vérifie que la
    // majorité des points dessinés sont proches du tracé cible. Le tracé
    // cible est défini dans un espace SVG 200x200 ; on le remet à l'échelle
    // du canvas réel (_scale) avant de comparer les distances, sinon la
    // validation échoue systématiquement dès que le canvas n'est pas 200px.
    int validPoints = 0;
    final double toleranceAtScale = widget.tolerance * _scale;

    for (final point in _points) {
      bool isNear = false;

      for (final metric in _targetMetrics!) {
        for (double d = 0; d < metric.length; d += 10.0) {
          final targetPoint = metric.getTangentForOffset(d)?.position;
          if (targetPoint != null) {
            final scaledTargetPoint = targetPoint * _scale;
            final distance = (point - scaledTargetPoint).distance;
            if (distance <= toleranceAtScale) {
              isNear = true;
              break;
            }
          }
        }
        if (isNear) break;
      }

      if (isNear) validPoints++;
    }

    // Si plus de 70% des points sont dans la zone de tolérance
    final double accuracy = validPoints / _points.length;
    final bool isSuccess = accuracy >= 0.70;

    widget.onDrawingComplete(isSuccess);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0, // Toujours carré comme la grille Seyès web (200x200)
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AmaniColors.disabled, width: 2),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Le rendu s'adapte à la taille réelle, mais les coordonnées SVG sont 200x200.
            _scale = constraints.maxWidth / 200.0;
            return GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: CustomPaint(
                painter: _CanvasPainter(
                  targetPath: _targetPathCache,
                  drawnPoints: _points,
                  scale: _scale,
                ),
                size: Size.infinite,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CanvasPainter extends CustomPainter {
  final Path? targetPath;
  final List<Offset> drawnPoints;
  final double scale;

  _CanvasPainter({
    required this.targetPath,
    required this.drawnPoints,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Dessiner le chemin cible en pointillés gris clair
    if (targetPath != null) {
      canvas.save();
      canvas.scale(scale, scale);

      final targetPaint = Paint()
        ..color = const Color(0xFFE5E0D8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      // Pointillés simulés via path_drawing (ou solid line très claire)
      final dashedPath = dashPath(
        targetPath!,
        dashArray: CircularIntervalList<double>([0.1, 24.0]),
      );

      canvas.drawPath(dashedPath, targetPaint);
      canvas.restore();
    }

    // 2. Dessiner le tracé de l'utilisateur
    if (drawnPoints.isNotEmpty) {
      final userPaint = Paint()
        ..color = AmaniColors.textPrimary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16.0 * scale
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final path = Path();
      path.moveTo(drawnPoints.first.dx, drawnPoints.first.dy);

      for (int i = 1; i < drawnPoints.length; i++) {
        path.lineTo(drawnPoints[i].dx, drawnPoints[i].dy);
      }

      canvas.drawPath(path, userPaint);
    }
  }

  @override
  bool shouldRepaint(_CanvasPainter oldDelegate) {
    return true; // Simple re-render continuously while drawing
  }
}
