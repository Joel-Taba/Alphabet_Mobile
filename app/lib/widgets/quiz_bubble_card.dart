import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/amani_theme.dart';
import '../utils/text_case.dart';

/// Bulle de question façon "carte de quiz" (coin de dialogue à pointe, façon
/// bande dessinée) — même esprit que les templates de quiz colorés, avec la
/// charte de l'application (terracotta des mini-jeux "Figures géométriques"
/// plutôt que le bleu d'origine) : utilisée par les 3 mini-jeux bonus du
/// Palier "Figures géométriques" (Quiz / Vrai ou Faux / Objets).
class QuizBubbleCard extends StatelessWidget {
  final String label;
  final Widget child;

  const QuizBubbleCard({super.key, required this.label, required this.child});

  static const Color fill = Color(0xFFB85454);
  static const Color border = Color(0xFF7A3535);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 26),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            painter: const _BubblePainter(fill: fill, border: border),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 34),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    capitalizeFirst(label),
                    style: TextStyle(
                      fontFamily: kBalooFontFamily,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  child,
                ],
              ),
            ),
          ),
          Positioned(
            top: -14,
            right: 4,
            child: Transform.rotate(
              angle: 0.25,
              child: const Icon(
                LucideIcons.helpCircle,
                color: Color(0xFFE3B873),
                size: 30,
              ),
            ),
          ),
          Positioned(
            top: -4,
            right: 26,
            child: Transform.rotate(
              angle: -0.2,
              child: const Icon(
                LucideIcons.sparkles,
                color: Color(0xFFE3B873),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  final Color fill;
  final Color border;

  const _BubblePainter({required this.fill, required this.border});

  @override
  void paint(Canvas canvas, Size size) {
    const tailHeight = 18.0;
    const tailWidth = 26.0;
    final tailStart = size.width * 0.16;
    final bodyRect = Rect.fromLTWH(0, 0, size.width, size.height - tailHeight);
    final rrect = RRect.fromRectAndRadius(bodyRect, const Radius.circular(28));

    final body = Path()..addRRect(rrect);
    final tail = Path()
      ..moveTo(tailStart, bodyRect.bottom - 1)
      ..lineTo(tailStart + tailWidth * 0.35, bodyRect.bottom + tailHeight)
      ..lineTo(tailStart + tailWidth, bodyRect.bottom - 1)
      ..close();

    final combined = Path.combine(PathOperation.union, body, tail);

    canvas.drawPath(combined, Paint()..color = fill);
    canvas.drawPath(
      combined,
      Paint()
        ..color = border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) =>
      oldDelegate.fill != fill || oldDelegate.border != border;
}
