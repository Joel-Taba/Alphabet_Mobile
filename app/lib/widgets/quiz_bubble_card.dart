import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/amani_theme.dart';
import '../utils/text_case.dart';

/// Carte de question des mini-jeux (Quiz / Vrai ou Faux / Objets) : grande
/// carte en dégradé de la couleur du palier (terracotta par défaut pour les
/// "Figures géométriques"), décorée de figures en filigrane, avec une
/// étiquette en haut à gauche ([label]) et, en option, le numéro de la
/// question à droite ([badge], ex. "2 / 5"). [feedback] colore le contour
/// une fois l'enfant a répondu (vert = juste, rouge = faux) et affiche un
/// médaillon ✓ / ✕.
class QuizBubbleCard extends StatelessWidget {
  final String label;
  final Widget child;
  final String? badge;
  final Color accent;
  final bool? feedback;

  const QuizBubbleCard({
    super.key,
    required this.label,
    required this.child,
    this.badge,
    this.accent = fill,
    this.feedback,
  });

  static const Color fill = Color(0xFFB85454);
  static const Color border = Color(0xFF7A3535);

  @override
  Widget build(BuildContext context) {
    final light = Color.lerp(accent, const Color(0xFFFFD6A5), 0.35)!;
    final ring = switch (feedback) {
      true => AmaniColors.success,
      false => AmaniColors.error,
      null => Colors.white.withValues(alpha: 0.0),
    };
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 18),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 560),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accent, light],
              ),
              border: Border.all(color: ring, width: 4),
              boxShadow: [
                BoxShadow(
                  color: (feedback == null ? accent : ring).withValues(
                    alpha: 0.35,
                  ),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CustomPaint(
                painter: const _ShapesWatermark(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // L'étiquette rétrécit si besoin : sur un petit
                          // téléphone, "Quel objet a cette forme ?" + le
                          // numéro débordaient de la carte.
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: AlignmentDirectional.centerStart,
                              child: _Chip(
                                icon: LucideIcons.helpCircle,
                                text: capitalizeFirst(label),
                              ),
                            ),
                          ),
                          if (badge != null) ...[
                            const SizedBox(width: 8),
                            _Chip(text: badge!),
                          ],
                        ],
                      ),
                      const SizedBox(height: 18),
                      child,
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (feedback != null)
            Positioned(
              top: -14,
              right: -6,
              child: TweenAnimationBuilder<double>(
                key: ValueKey(feedback),
                tween: Tween(begin: 0.4, end: 1),
                duration: const Duration(milliseconds: 380),
                curve: Curves.elasticOut,
                builder: (context, s, child) =>
                    Transform.scale(scale: s, child: child),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ring,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Icon(
                    feedback! ? LucideIcons.check : LucideIcons.x,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData? icon;
  final String text;
  const _Chip({this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 5),
          ],
          Text(
            text,
            style: TextStyle(
              fontFamily: kBalooFontFamily,
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
              letterSpacing: 0.4,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Figures en filigrane (cercle, triangle, carré) dans les coins de la
/// carte -- rappel discret du thème, sans gêner la lecture.
class _ShapesWatermark extends CustomPainter {
  const _ShapesWatermark();

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.13)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeJoin = StrokeJoin.round;
    canvas.drawCircle(Offset(size.width - 18, size.height - 10), 42, p);
    final tri = Path()
      ..moveTo(-8, size.height - 6)
      ..lineTo(34, size.height - 70)
      ..lineTo(76, size.height - 6)
      ..close();
    canvas.drawPath(tri, p);
    canvas.save();
    canvas.translate(size.width - 70, 18);
    canvas.rotate(0.35);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, 34, 34),
        const Radius.circular(6),
      ),
      p..color = Colors.white.withValues(alpha: 0.09),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShapesWatermark oldDelegate) => false;
}
