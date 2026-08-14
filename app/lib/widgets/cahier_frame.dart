import 'package:flutter/material.dart';

/// Lignes réglées façon cahier français (Seyès simplifié), utilisées comme
/// cadre pour tous les tracés de signes/lettres (cours et exercices).
/// Port fidèle de `src/components/amani/CahierFrame.tsx`.
class CahierFrame extends StatelessWidget {
  final Widget? child;
  final double rounded;
  final double? width;
  final double? height;

  const CahierFrame({
    super.key,
    this.child,
    this.rounded = 16,
    this.width,
    this.height,
  });

  static const _paperBg = Color(0xFFFFFFFF);
  static const _ruledLineColor = Color(0xFF4A90E2);
  static const _baselineColor = Color(0xFFE05252);

  // {pct, isBaseline} — 4 lignes strictement équidistantes (intervalle 60,
  // dans le système de coordonnées 200×200 partagé par tout le catalogue de
  // lettres) : HAMPE_TOP=10, CORPS_TOP=70, BASELINE=130, JAMBE_BOT=190. Pas
  // de ligne dédiée séparée pour les majuscules : elles rejoignent la même
  // ligne haute que les lettres à hampe (b/d/f/h/k/l/t).
  static const List<(double, bool)> _ruledLines = [
    (5, false),
    (35, false),
    (65, true),
    (95, false),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(rounded),
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(color: _paperBg),
        child: CustomPaint(
          foregroundPainter: _RuledLinesPainter(),
          child: child,
        ),
      ),
    );
  }
}

class _RuledLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (final (pct, isBaseline) in CahierFrame._ruledLines) {
      final y = size.height * pct / 100;
      final paint = Paint()
        ..color =
            (isBaseline
                    ? CahierFrame._baselineColor
                    : CahierFrame._ruledLineColor)
                .withValues(alpha: 0.8)
        ..strokeWidth = isBaseline ? 1.5 : 1;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RuledLinesPainter oldDelegate) => false;
}
