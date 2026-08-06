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

  // {pct, isBaseline}
  static const List<(double, bool)> _ruledLines = [
    (13.5, false),
    (38.5, false),
    (74.5, true),
    (97, false),
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
