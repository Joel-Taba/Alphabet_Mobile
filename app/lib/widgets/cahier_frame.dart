import 'package:flutter/material.dart';

/// Fond quadrillé + lignes réglées façon cahier français (Seyès simplifié),
/// utilisé comme cadre pour tous les tracés de signes/lettres (cours et
/// exercices). Port fidèle de `src/components/amani/CahierFrame.tsx`.
class CahierFrame extends StatelessWidget {
  final Widget? child;
  final double rounded;
  final double? width;
  final double? height;

  const CahierFrame({super.key, this.child, this.rounded = 16, this.width, this.height});

  static const _gridLineColor = Color(0xFFC5D8F0);
  static const _gridBg = Color(0xFFF8FBFF);
  static const _ruledLineColor = Color(0x40A0C0E0);
  static const _baselineColor = Color(0xFF4A90E2);

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
        decoration: const BoxDecoration(color: _gridBg),
        child: CustomPaint(
          painter: _GridPainter(),
          foregroundPainter: _RuledLinesPainter(),
          child: child,
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CahierFrame._gridLineColor
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 8) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 8) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}

class _RuledLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (final (pct, isBaseline) in CahierFrame._ruledLines) {
      final y = size.height * pct / 100;
      final paint = Paint()
        ..color = isBaseline ? CahierFrame._baselineColor : CahierFrame._ruledLineColor
        ..strokeWidth = isBaseline ? 1.5 : 1;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RuledLinesPainter oldDelegate) => false;
}
