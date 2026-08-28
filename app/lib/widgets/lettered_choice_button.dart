import 'package:flutter/material.dart';
import '../theme/amani_theme.dart';

enum ChoiceVisualState { idle, correct, wrong }

/// Bouton de réponse en pilule avec pastille "A/B/C/D" — même esprit que les
/// templates de quiz colorés, avec la charte de l'application. [content] est
/// libre (texte ou icône) pour couvrir les 3 mini-jeux du Palier "Figures
/// géométriques" (nom de figure, "Vrai"/"Faux", icône d'objet).
class LetteredChoiceButton extends StatelessWidget {
  final String letter;
  final Widget content;
  final ChoiceVisualState state;
  final bool dimmed;
  final VoidCallback onTap;

  const LetteredChoiceButton({
    super.key,
    required this.letter,
    required this.content,
    required this.state,
    required this.dimmed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color badgeBg;
    final Color pillBg;
    final Color pillBorder;
    switch (state) {
      case ChoiceVisualState.correct:
        badgeBg = AmaniColors.success;
        pillBg = AmaniColors.success.withValues(alpha: 0.14);
        pillBorder = AmaniColors.success;
        break;
      case ChoiceVisualState.wrong:
        badgeBg = AmaniColors.error;
        pillBg = AmaniColors.error.withValues(alpha: 0.12);
        pillBorder = AmaniColors.error;
        break;
      case ChoiceVisualState.idle:
        badgeBg = const Color(0xFF7A3535);
        pillBg = Colors.white;
        pillBorder = const Color(0xFF7A3535).withValues(alpha: 0.25);
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: dimmed ? 0.4 : 1,
        duration: const Duration(milliseconds: 200),
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: pillBg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: pillBorder, width: 2),
            boxShadow: const [
              BoxShadow(color: Color(0x144A3B2A), blurRadius: 6),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: badgeBg,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  letter,
                  style: TextStyle(
                    fontFamily: kBalooFontFamily,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(child: content),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
