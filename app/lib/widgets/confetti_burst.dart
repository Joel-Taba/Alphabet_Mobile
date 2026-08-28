import 'dart:math' as math;
import 'package:flutter/material.dart';

const List<Color> _kConfettiColors = [
  Color(0xFFE05252), // rouge
  Color(0xFF2D6BBF), // bleu
  Color(0xFF5E8E3E), // vert
  Color(0xFFE3B873), // or
  Color(0xFF8B5FBF), // violet
  Color(0xFFD07A04), // orange
];

const int _kDurationMs = 2000;

class _ConfettiPiece {
  final Offset start;
  final Offset velocity;
  final Color color;
  final double size;
  final double rotationSpeed;
  final double initialRotation;
  final bool isRect;
  const _ConfettiPiece({
    required this.start,
    required this.velocity,
    required this.color,
    required this.size,
    required this.rotationSpeed,
    required this.initialRotation,
    required this.isRect,
  });
}

/// Petite explosion de confettis, jouée à la demande via [play()] (référencé
/// par un `GlobalKey<ConfettiBurstState>` depuis l'écran parent) — pour
/// célébrer une bonne réponse, par exemple sur les pages "Vrai ou Faux".
/// À superposer en `Positioned.fill` par-dessus le contenu de l'écran, dans
/// un `Stack` — le widget est transparent aux interactions (`IgnorePointer`)
/// et ne dessine rien tant que [play] n'a pas été appelé.
class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({super.key});

  @override
  State<ConfettiBurst> createState() => ConfettiBurstState();
}

class ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  List<_ConfettiPiece> _pieces = const [];
  final _rand = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _kDurationMs),
    );
  }

  /// Déclenche une nouvelle explosion "grandeur nature" qui recouvre tout
  /// l'écran : plusieurs points de départ répartis sur toute la largeur,
  /// chacun projetant ses confettis dans un large cône vers le haut, pour
  /// que les morceaux retombent sur toute la surface visible. [origin] est
  /// ignoré si non fourni (comportement par défaut, seul cas utilisé
  /// aujourd'hui) — conservé pour un déclenchement ponctuel centré.
  void play({Offset? origin}) {
    final size = context.size ?? const Size(320, 500);
    final origins = origin != null
        ? [origin]
        : [
            Offset(size.width * 0.15, size.height * 0.6),
            Offset(size.width * 0.5, size.height * 0.35),
            Offset(size.width * 0.85, size.height * 0.6),
          ];
    const totalPieces = 160;
    _pieces = List.generate(totalPieces, (i) {
      final start = origins[i % origins.length];
      final angle = -math.pi / 2 + (_rand.nextDouble() - 0.5) * math.pi * 1.7;
      final speed = 220 + _rand.nextDouble() * 430;
      return _ConfettiPiece(
        start: start,
        velocity: Offset(math.cos(angle) * speed, math.sin(angle) * speed),
        color: _kConfettiColors[_rand.nextInt(_kConfettiColors.length)],
        size: 6 + _rand.nextDouble() * 7,
        rotationSpeed: (_rand.nextDouble() - 0.5) * 10,
        initialRotation: _rand.nextDouble() * math.pi * 2,
        isRect: _rand.nextBool(),
      );
    });
    setState(() {});
    _controller
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _ConfettiPainter(pieces: _pieces, t: _controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiPiece> pieces;
  final double t;

  const _ConfettiPainter({required this.pieces, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    if (pieces.isEmpty || t <= 0) return;
    const gravity = 420.0;
    final elapsed = t * (_kDurationMs / 1000);
    final opacity = t < 0.7 ? 1.0 : (1 - (t - 0.7) / 0.3).clamp(0.0, 1.0);
    for (final p in pieces) {
      final dx = p.start.dx + p.velocity.dx * elapsed;
      final dy =
          p.start.dy + p.velocity.dy * elapsed + 0.5 * gravity * elapsed * elapsed;
      final rotation = p.initialRotation + p.rotationSpeed * elapsed;
      final paint = Paint()..color = p.color.withValues(alpha: opacity);
      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(rotation);
      if (p.isRect) {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.5),
          paint,
        );
      } else {
        canvas.drawCircle(Offset.zero, p.size * 0.4, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) =>
      old.t != t || old.pieces != pieces;
}
