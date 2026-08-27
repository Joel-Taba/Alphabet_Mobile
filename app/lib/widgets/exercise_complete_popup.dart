import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import 'amani_mascot.dart';
import 'directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Pop-up affiché à la fin de CHAQUE exercice du parcours. Laisse l'enfant
/// choisir entre recommencer l'exercice, enchaîner directement sur le cours
/// suivant, ou revenir à l'accueil — pour pouvoir parcourir tout un palier
/// sans jamais devoir repasser par l'accueil. Port de
/// `src/components/amani/ExerciseCompletePopup.tsx`.
///
/// [onNext] est optionnel : quand il n'y a plus de cours suivant dans le
/// palier (dernier élément), le bouton "Suivant" est simplement absent.
/// [onRestart], lui, est toujours disponible.
class ExerciseCompletePopup extends StatelessWidget {
  final VoidCallback onBackHome;
  final VoidCallback? onNext;
  final VoidCallback onRestart;

  const ExerciseCompletePopup({
    super.key,
    required this.onBackHome,
    this.onNext,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final complete = t['exerciceComplete'] as Map<String, dynamic>? ?? {};
    final common = t['common'] as Map<String, dynamic>? ?? {};

    return Positioned.fill(
      child: Container(
        color: const Color(0x73000000),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AmaniMascot(
                pose: AmaniPose.celebration,
                size: AmaniSize.medium,
              ),
              const SizedBox(height: 16),
              Text(
                complete['title'] ?? 'Exercice terminé !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: kBalooFontFamily,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: AmaniColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                complete['body'] ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: kBalooFontFamily,
                  fontSize: 14,
                  color: AmaniColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: _PopupButton(
                  icon: LucideIcons.rotateCcw,
                  label: common['restart'] ?? 'Recommencer',
                  bg: const Color(0x26D9A84A),
                  fg: const Color(0xFF8A6800),
                  border: const Color(0x66D9A84A),
                  onTap: onRestart,
                ),
              ),
              if (onNext != null) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: _PopupButton(
                    icon: LucideIcons.chevronRight,
                    iconTrailing: true,
                    label: common['next'] ?? 'Suivant',
                    bg: AmaniColors.secondary,
                    fg: Colors.white,
                    filled: true,
                    onTap: onNext!,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: _PopupButton(
                  label: common['backToHome'] ?? "Retour à l'accueil",
                  bg: Colors.white,
                  fg: AmaniColors.textPrimary,
                  border: AmaniColors.textPrimary.withValues(alpha: 0.15),
                  onTap: onBackHome,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PopupButton extends StatelessWidget {
  final IconData? icon;
  final bool iconTrailing;
  final String label;
  final Color bg;
  final Color fg;
  final Color? border;
  final bool filled;
  final VoidCallback onTap;

  const _PopupButton({
    this.icon,
    this.iconTrailing = false,
    required this.label,
    required this.bg,
    required this.fg,
    this.border,
    this.filled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = icon != null
        ? DirectionalIcon(icon!, size: 16, color: fg)
        : null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: border != null
              ? Border.all(color: border!, width: 1.5)
              : null,
          boxShadow: filled
              ? const [
                  BoxShadow(
                    color: Color(0x338FBF6F),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconWidget != null && !iconTrailing) ...[
              iconWidget,
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: kBalooFontFamily,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: fg,
                ),
              ),
            ),
            if (iconWidget != null && iconTrailing) ...[
              const SizedBox(width: 8),
              iconWidget,
            ],
          ],
        ),
      ),
    );
  }
}
