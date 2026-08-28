import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/amani_theme.dart';

/// Animation de billes pour les tout premiers calculs de CP (2 opérandes
/// petites, `illustrateA`/`illustrateB` non nuls) — remplace l'affichage
/// statique `_ObjectRow` (`cours_calcul_screen.dart`) uniquement pour ces
/// petits calculs, pour ne pas surcharger l'interface ailleurs. Addition :
/// les billes du second groupe arrivent en sautillant puis fusionnent avec
/// le premier groupe. Soustraction : les billes retirées s'entrechoquent,
/// se cassent en deux puis sont balayées par le vent jusqu'à disparaître.
const double _kBallSize = 30;
const double _kBallGap = 8;
const Color _kBallColorA = Color(0xFF8B5FBF);
const Color _kBallColorB = Color(0xFFE3B873);
const double _kHopSpace = 22;

class _Ball extends StatelessWidget {
  final Color color;
  const _Ball({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _kBallSize,
      height: _kBallSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

/// Les billes du groupe B glissent vers le groupe A en sautillant
/// (rebond façon `Curves.bounceOut` sur l'axe vertical) jusqu'à former une
/// seule rangée fusionnée — illustre l'addition.
class AdditionBallsDemo extends StatefulWidget {
  final int countA;
  final int countB;
  const AdditionBallsDemo({
    super.key,
    required this.countA,
    required this.countB,
  });

  @override
  State<AdditionBallsDemo> createState() => _AdditionBallsDemoState();
}

class _AdditionBallsDemoState extends State<AdditionBallsDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _play();
  }

  void _play() {
    _controller.reset();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(covariant AdditionBallsDemo old) {
    super.didUpdateWidget(old);
    if (old.countA != widget.countA || old.countB != widget.countB) _play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.countA + widget.countB;
    const step = _kBallSize + _kBallGap;
    final rowWidth = total * step - _kBallGap;
    const groupGap = 40.0;
    return SizedBox(
      width: rowWidth + groupGap,
      height: _kBallSize + _kHopSpace,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final slideT = Curves.easeInOut.transform(_controller.value);
          // Rebond vertical : chaque bille du groupe B "atterrit" avec un
          // petit rebond façon balle qui sautille, au lieu de glisser à
          // plat — Curves.bounceOut part du sol, on l'inverse pour partir
          // d'en haut et retomber en sautillant jusqu'au sol (hop = 0).
          final bounceT = Curves.bounceOut.transform(_controller.value);
          final hop = _kHopSpace * (1 - bounceT);
          return Stack(
            children: [
              for (var i = 0; i < widget.countA; i++)
                Positioned(
                  left: groupGap / 2 + i * step,
                  top: _kHopSpace,
                  child: const _Ball(color: _kBallColorA),
                ),
              for (var j = 0; j < widget.countB; j++)
                Positioned(
                  left:
                      groupGap / 2 +
                      (widget.countA + j) * step +
                      groupGap * (1 - slideT),
                  top: _kHopSpace + hop,
                  child: const _Ball(color: _kBallColorB),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Les [countRemoved] dernières billes s'entrechoquent (petit tremblement),
/// se cassent en deux moitiés puis sont balayées par le vent (dérive
/// horizontale + rotation + disparition en fondu) — illustre la
/// soustraction avec une animation joviale plutôt qu'une simple disparition.
class SoustractionBallsDemo extends StatefulWidget {
  final int countA;
  final int countRemoved;
  const SoustractionBallsDemo({
    super.key,
    required this.countA,
    required this.countRemoved,
  });

  @override
  State<SoustractionBallsDemo> createState() => _SoustractionBallsDemoState();
}

class _SoustractionBallsDemoState extends State<SoustractionBallsDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _play();
  }

  void _play() {
    _controller.reset();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(covariant SoustractionBallsDemo old) {
    super.didUpdateWidget(old);
    if (old.countA != widget.countA || old.countRemoved != widget.countRemoved) {
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
    const step = _kBallSize + _kBallGap;
    final rowWidth = widget.countA * step - _kBallGap;
    final keptCount = widget.countA - widget.countRemoved;
    const windDistance = 70.0;
    return SizedBox(
      width: rowWidth + windDistance,
      height: _kBallSize + 24,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          // Étape 1 (0-25%) : les billes retirées s'entrechoquent.
          final wiggleT = (t / 0.25).clamp(0.0, 1.0);
          final wiggle = wiggleT < 1
              ? math.sin(wiggleT * math.pi * 3) * 4 * (1 - wiggleT)
              : 0.0;
          // Étape 2 (25-40%) : elles se cassent en deux (écart qui s'ouvre).
          final crackT = ((t - 0.25) / 0.15).clamp(0.0, 1.0);
          final crackGap = crackT * 7;
          // Étape 3 (40-100%) : le vent emporte les deux moitiés au loin,
          // en rotation, jusqu'à disparaître.
          final sweepT = Curves.easeIn.transform(((t - 0.4) / 0.6).clamp(0.0, 1.0));
          final windDrift = sweepT * windDistance;
          final rotation = sweepT * 0.9;
          final opacity = 1 - sweepT;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              for (var i = 0; i < keptCount; i++)
                Positioned(
                  top: 12,
                  left: i * step,
                  child: const _Ball(color: _kBallColorA),
                ),
              for (var j = 0; j < widget.countRemoved; j++) ...[
                // Moitié supérieure : dérive vers le haut-droite en tournant.
                Positioned(
                  top: 12 - crackGap - sweepT * 14,
                  left: (keptCount + j) * step + wiggle + windDrift,
                  child: Opacity(
                    opacity: opacity,
                    child: Transform.rotate(
                      angle: -rotation,
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: 0.5,
                          child: const _Ball(color: AmaniColors.disabled),
                        ),
                      ),
                    ),
                  ),
                ),
                // Moitié inférieure : dérive vers le bas-droite en tournant
                // dans l'autre sens, un peu plus lentement (vent).
                Positioned(
                  top: 12 + _kBallSize / 2 + crackGap + sweepT * 10,
                  left: (keptCount + j) * step + wiggle + windDrift * 0.75,
                  child: Opacity(
                    opacity: opacity,
                    child: Transform.rotate(
                      angle: rotation,
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          heightFactor: 0.5,
                          child: const _Ball(color: AmaniColors.disabled),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
