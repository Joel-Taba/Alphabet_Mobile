import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/amani_theme.dart';
import 'quiz_kit.dart';

enum ChoiceVisualState { idle, correct, wrong }

/// Bouton de réponse lettré "A/B/C/D" des mini-jeux : tuile blanche en
/// relief (bord inférieur coloré, s'enfonce au toucher), pastille lettrée
/// qui devient ✓ (vert) ou ✕ (rouge, avec une secousse) après le choix.
/// [content] est libre (texte ou emoji) pour couvrir les mini-jeux du
/// Palier "Figures géométriques" (nom de figure, "Vrai"/"Faux", objet) ; il
/// est réduit automatiquement s'il est trop long pour tenir sur une ligne.
class LetteredChoiceButton extends StatefulWidget {
  final String letter;
  final Widget content;
  final ChoiceVisualState state;
  final bool dimmed;
  final VoidCallback onTap;
  final Color accent;

  const LetteredChoiceButton({
    super.key,
    required this.letter,
    required this.content,
    required this.state,
    required this.dimmed,
    required this.onTap,
    this.accent = const Color(0xFF7A3535),
  });

  @override
  State<LetteredChoiceButton> createState() => _LetteredChoiceButtonState();
}

class _LetteredChoiceButtonState extends State<LetteredChoiceButton> {
  bool _down = false;
  int _shakes = 0;

  @override
  void didUpdateWidget(covariant LetteredChoiceButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state &&
        widget.state == ChoiceVisualState.wrong) {
      _shakes++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color tint;
    final Color badge;
    final Color bg;
    switch (widget.state) {
      case ChoiceVisualState.correct:
        tint = AmaniColors.success;
        badge = AmaniColors.success;
        bg = Color.lerp(Colors.white, AmaniColors.success, 0.16)!;
        break;
      case ChoiceVisualState.wrong:
        tint = AmaniColors.error;
        badge = AmaniColors.error;
        bg = Color.lerp(Colors.white, AmaniColors.error, 0.12)!;
        break;
      case ChoiceVisualState.idle:
        tint = widget.accent;
        badge = widget.accent;
        bg = Colors.white;
        break;
    }
    final edge = Color.lerp(tint, Colors.white, 0.55)!;
    final lift = _down ? 1.0 : 4.0;

    return QuizShake(
      trigger: _shakes,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _down = true),
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) {
          setState(() => _down = false);
          HapticFeedback.selectionClick();
          widget.onTap();
        },
        child: AnimatedOpacity(
          opacity: widget.dimmed ? 0.4 : 1,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 90),
            margin: EdgeInsets.only(top: 4 - lift, bottom: lift),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.state == ChoiceVisualState.idle ? edge : tint,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(color: edge, offset: Offset(0, lift)),
                BoxShadow(
                  color: tint.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: Offset(0, lift + 3),
                ),
              ],
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: badge,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: switch (widget.state) {
                    ChoiceVisualState.correct => const Icon(
                      LucideIcons.check,
                      color: Colors.white,
                      size: 20,
                    ),
                    ChoiceVisualState.wrong => const Icon(
                      LucideIcons.x,
                      color: Colors.white,
                      size: 20,
                    ),
                    ChoiceVisualState.idle => Text(
                      widget.letter,
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: widget.content,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
