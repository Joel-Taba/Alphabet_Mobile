import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'cahier_frame.dart';

/// Petit cadre "cahier" montrant une lettre ou un chiffre en train de se
/// former — chaque geste s'anime l'un après l'autre puis reste tracé, sans
/// pointillé guide ni rejeu manuel. Port fidèle de
/// `MiniLetterFrame`/`AnimatedStroke` (`cours.syllabes.$consonant.tsx`),
/// extrait en widget partagé pour être réutilisé partout où une lettre/un
/// chiffre doit s'animer à titre de démonstration (Palier "Syllabes",
/// Palier "Calculs"...).
class MiniLetterFrame extends StatefulWidget {
  final Map<String, dynamic>? letter;
  final int delayMs;
  final double size;

  /// Écart entre le début de deux gestes consécutifs, et durée de tracé
  /// d'un geste. Par défaut (260/500), les gestes se chevauchent légèrement
  /// — convient à des lettres à 1-2 gestes très liés. Pour des figures à
  /// plusieurs côtés bien distincts (carré, rectangle, triangle), passer
  /// `stepGapMs == stepDrawMs` (ex. 700/700) pour que chaque côté se trace
  /// entièrement avant que le suivant ne commence.
  final int stepGapMs;
  final int stepDrawMs;

  const MiniLetterFrame({
    super.key,
    required this.letter,
    this.delayMs = 0,
    this.size = 76,
    this.stepGapMs = 260,
    this.stepDrawMs = 500,
  });

  @override
  State<MiniLetterFrame> createState() => _MiniLetterFrameState();
}

class _MiniLetterFrameState extends State<MiniLetterFrame>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  int get _stepCount => (widget.letter?['steps'] as List?)?.length ?? 0;

  Duration get _totalDuration =>
      Duration(milliseconds: _stepCount * widget.stepGapMs + 500);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _totalDuration);
    _play();
  }

  void _play() {
    _controller.reset();
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(covariant MiniLetterFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.letter != widget.letter) {
      _controller.duration = _totalDuration;
      _play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final letter = widget.letter;
    if (letter == null) {
      return CahierFrame(width: widget.size, height: widget.size, rounded: 12);
    }
    final steps = (letter['steps'] as List).cast<Map<String, dynamic>>();
    return CahierFrame(
      width: widget.size,
      height: widget.size,
      rounded: 12,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final elapsedMs =
              _controller.value * _controller.duration!.inMilliseconds;
          return CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _MiniLetterPainter(
              steps: steps,
              elapsedMs: elapsedMs,
              stepGapMs: widget.stepGapMs.toDouble(),
              stepDrawMs: widget.stepDrawMs.toDouble(),
            ),
          );
        },
      ),
    );
  }
}

class _MiniLetterPainter extends CustomPainter {
  final List<Map<String, dynamic>> steps;
  final double elapsedMs;
  final double stepGapMs;
  final double stepDrawMs;

  _MiniLetterPainter({
    required this.steps,
    required this.elapsedMs,
    required this.stepGapMs,
    required this.stepDrawMs,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 200.0;
    canvas.save();
    canvas.scale(scale, scale);
    for (int i = 0; i < steps.length; i++) {
      final stepStart = i * stepGapMs;
      final stepProgress = ((elapsedMs - stepStart) / stepDrawMs).clamp(0.0, 1.0);
      if (stepProgress <= 0) continue;
      final path = parseSvgPathData(steps[i]['pathD'] as String);
      final color = Color(
        int.parse(
          (steps[i]['strokeColor'] as String).replaceFirst('#', '0xFF'),
        ),
      );
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round;
      if (stepProgress >= 1.0) {
        canvas.drawPath(path, paint);
      } else {
        for (final metric in path.computeMetrics()) {
          canvas.drawPath(
            metric.extractPath(0, metric.length * stepProgress),
            paint,
          );
        }
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MiniLetterPainter oldDelegate) =>
      oldDelegate.elapsedMs != elapsedMs || oldDelegate.steps != steps;
}
