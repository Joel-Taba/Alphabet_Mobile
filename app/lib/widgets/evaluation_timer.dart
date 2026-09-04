import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../hooks/use_countdown.dart';
import '../services/evaluation_session.dart';
import 'amani_mascot.dart';
import 'confetti_burst.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Délai avant le retour automatique au parcours — assez long pour lire le
/// message, assez court pour ne pas faire attendre.
const _autoBackDelay = Duration(milliseconds: 3500);

/// Bandeau affiché en haut d'un écran d'exercice en mode "évaluation",
/// montrant le temps restant (centré) et, en dessous, une barre d'étapes
/// façon parcours d'achat (cercle coché par sujet déjà réalisé, cercle
/// numéroté pour les suivants) — pour que l'enfant sache exactement où il
/// en est dans l'évaluation. Vire au rouge dans les 30 dernières secondes.
/// Port de `EvaluationTimerBadge` (`src/components/amani/EvaluationTimer.tsx`).
class EvaluationTimerBadge extends StatelessWidget {
  final int remaining;
  final int? subjectsDone;
  final int? subjectTotal;

  const EvaluationTimerBadge({
    super.key,
    required this.remaining,
    this.subjectsDone,
    this.subjectTotal,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final ev = t['evaluation'] as Map<String, dynamic>? ?? {};
    final low = remaining <= 30;
    final showSubjects = (subjectTotal ?? 0) > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ).copyWith(bottom: showSubjects ? 12 : 10),
      color: low ? const Color(0xFFC03E3E) : AmaniColors.textPrimary,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.timer, color: Colors.white, size: 16),
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
          if (showSubjects) ...[
            const SizedBox(height: 8),
            _SubjectStepper(done: subjectsDone ?? 0, total: subjectTotal!),
          ],
        ],
      ),
    );
  }
}

/// Barre d'étapes façon "shopping basket → confirmation" (cercle coché et
/// plein pour chaque sujet déjà réussi, cercle numéroté et vide pour les
/// suivants, reliés par un trait), en version réduite pour tenir dans le
/// bandeau d'évaluation — sans libellé sous chaque cercle (pas la place) et
/// défilable horizontalement si le nombre de sujets est grand.
class _SubjectStepper extends StatelessWidget {
  final int done;
  final int total;

  const _SubjectStepper({required this.done, required this.total});

  static const double _dot = 20;
  static const double _lineWidth = 18;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < total; i++) ...[
            _StepDot(isDone: i < done, number: i + 1),
            if (i < total - 1)
              Container(
                width: _lineWidth,
                height: 2,
                color: Colors.white.withValues(alpha: i < done ? 0.9 : 0.25),
              ),
          ],
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool isDone;
  final int number;

  const _StepDot({required this.isDone, required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _SubjectStepper._dot,
      height: _SubjectStepper._dot,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDone ? Colors.white : Colors.transparent,
        border: isDone
            ? null
            : Border.all(
                color: Colors.white.withValues(alpha: 0.45),
                width: 1.5,
              ),
      ),
      child: isDone
          ? Icon(LucideIcons.check, size: 12, color: AmaniColors.textPrimary)
          : Text(
              '$number',
              style: TextStyle(
                fontFamily: kBalooFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
    );
  }
}

/// Popup bloquante proposée à l'entrée d'une évaluation pour laquelle une
/// progression sauvegardée existe (l'enfant l'avait quittée en cours de
/// route) : reprendre exactement là où il s'était arrêté (même sujet,
/// même temps restant, mêmes sujets déjà réussis) ou recommencer entièrement
/// à zéro. Doit être utilisée dans un [Stack] (voir [Positioned.fill]).
class EvaluationResumeOffer extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;

  const EvaluationResumeOffer({
    super.key,
    required this.onResume,
    required this.onRestart,
  });

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
                pose: AmaniPose.reflexion,
                size: AmaniSize.medium,
              ),
              const SizedBox(height: 12),
              const Icon(
                LucideIcons.history,
                color: Color(0xFFA9784F),
                size: 26,
              ),
              const SizedBox(height: 8),
              Text(
                ev['resumeTitle'] ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: kBalooFontFamily,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: AmaniColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                ev['resumeBody'] ?? '',
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
                  onPressed: onResume,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AmaniColors.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    ev['resumeContinueButton'] ?? '',
                    style: TextStyle(
                      fontFamily: kBalooFontFamily,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onRestart,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AmaniColors.textPrimary,
                    side: const BorderSide(color: AmaniColors.disabled),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    ev['resumeRestartButton'] ?? '',
                    style: TextStyle(
                      fontFamily: kBalooFontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AmaniColors.textPrimary,
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

/// Popup bloquante annonçant le sujet de l'évaluation en cours — soit "1er
/// sujet" à l'entrée dans l'évaluation, soit "Bravo, sujet suivant" une
/// fois le sujet précédent réussi. Doit être utilisée dans un [Stack] (voir
/// [Positioned.fill]).
class EvaluationSubjectAnnouncement extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onContinue;

  const EvaluationSubjectAnnouncement({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onContinue,
  });

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
                pose: AmaniPose.encouragement,
                size: AmaniSize.medium,
              ),
              const SizedBox(height: 12),
              const Icon(
                LucideIcons.flagTriangleRight,
                color: Color(0xFFA9784F),
                size: 26,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: kBalooFontFamily,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: AmaniColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
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
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AmaniColors.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    ev['continueSubject'] ?? 'Continuer',
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
  final _confettiKey = GlobalKey<ConfettiBurstState>();

  @override
  void initState() {
    super.initState();
    _timer = Timer(_autoBackDelay, _handleBack);
    // Après le premier layout seulement : `ConfettiBurst.play()` a besoin de
    // `context.size` pour répartir ses confettis sur tout l'écran.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiKey.currentState?.play();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Termine la session d'évaluation partagée avant de sortir, pour qu'une
  /// prochaine évaluation reparte avec un chrono neuf plutôt que de
  /// retrouver celui-ci déjà expiré.
  void _handleBack() {
    context.read<EvaluationSessionController>().reset();
    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final ev = t['evaluation'] as Map<String, dynamic>? ?? {};

    return Positioned.fill(
      child: Stack(
        children: [
          Container(
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
                    LucideIcons.gift,
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
                      onPressed: _handleBack,
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
          Positioned.fill(child: ConfettiBurst(key: _confettiKey)),
        ],
      ),
    );
  }
}
