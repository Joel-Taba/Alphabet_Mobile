import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../services/sign_speech.dart';
import '../theme/amani_theme.dart';

/// Une action du panneau (voir `TraceControlsToolbar`) : icône seule,
/// couleurs propres à chaque écran appelant (le vert du Palier 1, le violet
/// du Palier "Calculs"...).
class ToolbarAction {
  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  const ToolbarAction({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });
}

/// Regroupe les actions d'une carte de démonstration ("Relancer", "Consigne",
/// "S'entrainer"...) en une colonne de petits ronds colorés, toujours
/// visibles, suivis du bouton "muet" qui coupe la synthèse vocale (voir
/// [SignSpeechService.muted]).
class TraceControlsToolbar extends StatelessWidget {
  final List<ToolbarAction> actions;
  final String muteLabel;
  final String unmuteLabel;

  /// `false` sur un cours qui ne lit aucune consigne.
  final bool showMute;

  const TraceControlsToolbar({
    super.key,
    required this.actions,
    required this.muteLabel,
    required this.unmuteLabel,
    this.showMute = true,
  });

  static const double _size = 38;

  /// Hauteur occupée par le panneau ([actionCount] actions + le bouton
  /// "muet") — à utiliser par l'appelant pour garantir, via un
  /// `ConstrainedBox`/`minHeight`, que la carte qui sert de fond au panneau
  /// (l'espace d'animation) reste au moins aussi haute que lui : sans quoi,
  /// pour une carte de démonstration naturellement courte, le dernier bouton
  /// du panneau se retrouverait rogné par les bords du `Stack`.
  static double heightFor(int actionCount) =>
      (actionCount + 1) * _size +
      actionCount * 8 +
      8; // + le padding vertical (haut+bas) du Container racine du panneau

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 6)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < actions.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            _ToolbarButton(action: actions[i], size: _size),
          ],
          if (showMute) ...[
            if (actions.isNotEmpty) const SizedBox(height: 8),
            _MuteButton(
              size: _size,
              muteLabel: muteLabel,
              unmuteLabel: unmuteLabel,
            ),
          ],
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final ToolbarAction action;
  final double size;

  const _ToolbarButton({required this.action, required this.size});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: action.label,
      child: GestureDetector(
        onTap: action.onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: action.background,
            shape: BoxShape.circle,
          ),
          child: Icon(action.icon, size: 18, color: action.foreground),
        ),
      ),
    );
  }
}

const _mutedSpeakerSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="#000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="M11 5 6.5 9H3v6h3.5L11 19z"/>
  <path d="M15.5 9.5a4 4 0 0 1 0 5"/>
  <path d="M18.5 7a8 8 0 0 1 0 10"/>
  <path d="M3 3l18 18"/>
</svg>''';

/// Coupe/réactive la voix. Actif (fond rouge) tant que l'utilisateur ne le
/// désactive pas lui-même.
class _MuteButton extends StatelessWidget {
  final double size;
  final String muteLabel;
  final String unmuteLabel;

  const _MuteButton({
    required this.size,
    required this.muteLabel,
    required this.unmuteLabel,
  });

  @override
  Widget build(BuildContext context) {
    final speech = context.watch<SignSpeechService>();
    final muted = speech.muted;
    return Semantics(
      button: true,
      toggled: muted,
      label: muted ? unmuteLabel : muteLabel,
      child: GestureDetector(
        onTap: () => speech.setMuted(!muted),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: muted ? AmaniColors.error : AmaniColors.background,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.string(
            _mutedSpeakerSvg,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(
              muted ? Colors.white : AmaniColors.textSecondary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
