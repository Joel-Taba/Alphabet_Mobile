import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../hooks/use_countdown.dart';
import 'amani_mascot.dart';

/// Délai avant le retour automatique au parcours — assez long pour lire le
/// message, assez court pour ne pas faire attendre.
const _autoBackDelay = Duration(milliseconds: 3500);

/// Bandeau affiché en haut d'un écran d'exercice en mode "évaluation",
/// montrant le temps restant. Vire au rouge dans les 30 dernières secondes.
/// Port de `EvaluationTimerBadge` (`src/components/amani/EvaluationTimer.tsx`).
class EvaluationTimerBadge extends StatelessWidget {
  final int remaining;

  const EvaluationTimerBadge({super.key, required this.remaining});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final ev = t['evaluation'] as Map<String, dynamic>? ?? {};
    final low = remaining <= 30;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: low ? const Color(0xFFC03E3E) : AmaniColors.textPrimary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(CupertinoIcons.timer, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            '${ev['badge'] ?? ''} · ${ev['timeLeft'] ?? ''} ${formatCountdown(remaining)}',
            style: TextStyle(
              fontFamily: kBalooFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Écran de fin d'évaluation (temps écoulé), bloquant. Reconduit
/// automatiquement vers l'accueil après un court délai, mais le bouton reste
/// disponible pour ne pas forcer l'attente. Doit être utilisé dans un
/// [Stack] (voir [Positioned.fill]). Port de `EvaluationCompleteOverlay`.
class EvaluationCompleteOverlay extends StatefulWidget {
  final VoidCallback onBack;

  const EvaluationCompleteOverlay({super.key, required this.onBack});

  @override
  State<EvaluationCompleteOverlay> createState() =>
      _EvaluationCompleteOverlayState();
}

class _EvaluationCompleteOverlayState extends State<EvaluationCompleteOverlay> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_autoBackDelay, widget.onBack);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final ev = t['evaluation'] as Map<String, dynamic>? ?? {};

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
              const SizedBox(height: 12),
              const Icon(
                CupertinoIcons.gift_fill,
                color: Color(0xFFA9784F),
                size: 26,
              ),
              const SizedBox(height: 8),
              Text(
                ev['finishedTitle'] ?? '',
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
                ev['finishedMessage'] ?? '',
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
                child: ElevatedButton(
                  onPressed: widget.onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AmaniColors.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    ev['backToPath'] ?? '',
                    style: TextStyle(
                      fontFamily: kBalooFontFamily,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
