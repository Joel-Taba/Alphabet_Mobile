import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Étoile scintillante façon "luciole" : la pointe principale respire
/// (échelle + halo lumineux pulsés) pendant que deux minuscules étoiles
/// compagnes clignotent en décalé tout autour, comme un vol de lucioles.
/// Extrait de `PointsToastHost` (bulle "+N" de fin d'exercice) pour être
/// réutilisé partout où l'on affiche un score en points (ex. le classement
/// de "La Clairière"), plutôt que la simple icône étoile statique.
class TwinklingStar extends StatefulWidget {
  final double size;
  final Color color;

  const TwinklingStar({super.key, this.size = 26, this.color = Colors.white});

  @override
  State<TwinklingStar> createState() => _TwinklingStarState();
}

class _TwinklingStarState extends State<TwinklingStar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unit = widget.size / 26;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final pulse = (math.sin(2 * math.pi * t) + 1) / 2;
        final scale = 0.88 + pulse * 0.28;
        final glow = 0.35 + pulse * 0.65;
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              _firefly(
                t,
                phase: 0.15,
                dx: 9 * unit,
                dy: -8 * unit,
                size: 5 * unit,
              ),
              _firefly(
                t,
                phase: 0.65,
                dx: -9 * unit,
                dy: 7 * unit,
                size: 4 * unit,
              ),
              Transform.scale(
                scale: scale,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: glow * 0.9),
                        blurRadius: 10 * glow,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    LucideIcons.star,
                    color: widget.color,
                    size: 18 * unit,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _firefly(
    double t, {
    required double phase,
    required double dx,
    required double dy,
    required double size,
  }) {
    final blink = math.max(0.0, math.sin(2 * math.pi * (t + phase) * 1.3));
    final center = widget.size / 2;
    return Positioned(
      left: center + dx - size / 2,
      top: center + dy - size / 2,
      child: Opacity(
        opacity: blink,
        child: Icon(LucideIcons.star, color: widget.color, size: size),
      ),
    );
  }
}
