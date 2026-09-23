import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
/// "S'entrainer"...) en une seule section repliable, exactement comme le
/// menu de navigation rapide entre paliers de la page d'accueil (voir
/// `_PalierQuickNav` dans `parcours_screen.dart`) : repliée par défaut (seul
/// le bouton rond avec la flèche est visible, les actions restent
/// entièrement masquées), un tap la déplie pour révéler les actions sous
/// forme de petits ronds colorés, un second tap la replie. Le dépli se fait
/// verticalement du haut vers le bas (le bouton reste en haut, les actions
/// apparaissent dessous), comme le menu des paliers -- la flèche pointe vers
/// le bas au repos et vers le haut une fois déplié.
class TraceControlsToolbar extends StatefulWidget {
  final List<ToolbarAction> actions;
  final String expandAria;
  final String collapseAria;

  const TraceControlsToolbar({
    super.key,
    required this.actions,
    required this.expandAria,
    required this.collapseAria,
  });

  @override
  State<TraceControlsToolbar> createState() => _TraceControlsToolbarState();

  /// Hauteur occupée par le panneau une fois entièrement déplié (bouton +
  /// une action par ligne) — à utiliser par l'appelant pour garantir, via
  /// un `ConstrainedBox`/`minHeight`, que la carte qui sert de fond au
  /// panneau (l'espace d'animation) reste au moins aussi haute que lui :
  /// sans quoi, pour une carte de démonstration naturellement courte, le
  /// dernier bouton du panneau se retrouverait rogné par les bords du
  /// `Stack`.
  static double heightFor(int actionCount) =>
      (actionCount + 1) * _TraceControlsToolbarState._size +
      actionCount * 8 +
      8; // + le padding vertical (haut+bas) du Container racine du panneau
}

class _TraceControlsToolbarState extends State<TraceControlsToolbar> {
  bool _expanded = false;

  static const double _size = 38;

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
          Semantics(
            button: true,
            label: _expanded ? widget.collapseAria : widget.expandAria,
            child: GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Container(
                width: _size,
                height: _size,
                decoration: BoxDecoration(
                  color: AmaniColors.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _expanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                  size: 18,
                  color: AmaniColors.textSecondary,
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: !_expanded
                ? const SizedBox(width: _size)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final action in widget.actions) ...[
                        const SizedBox(height: 8),
                        _ToolbarButton(action: action, size: _size),
                      ],
                    ],
                  ),
          ),
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
