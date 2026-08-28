import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../data/mental_calc_generator.dart';
import '../hooks/use_countdown.dart';
import 'amani_mascot.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Onglet "Calcul" du Mode Libre : calcul mental chronométré façon QCM — un
/// problème, 5 réponses proposées, 2 essais maximum. Le temps imparti est
/// choisi automatiquement selon la difficulté du problème tiré (voir
/// `mental_calc_generator.dart`) plutôt que réglé par l'utilisateur, à la
/// différence du sujet "calcul mental" du Palier "Les Calculs" (traçage,
/// durée fixée dans Profil > Réglages) : ce mini-jeu est un exercice
/// distinct, pas une reprise de ce sujet.
class FreeMentalCalcSection extends StatefulWidget {
  const FreeMentalCalcSection({super.key});

  @override
  State<FreeMentalCalcSection> createState() => _FreeMentalCalcSectionState();
}

class _FreeMentalCalcSectionState extends State<FreeMentalCalcSection> {
  final _random = Random();
  late MentalCalcProblem _problem;
  CountdownController? _countdown;
  int _attempts = 0;
  int? _wrongChoice;
  bool _solved = false;
  bool _showFailure = false;

  @override
  void initState() {
    super.initState();
    _problem = generateMentalCalcProblem(_random);
    _startCountdown();
  }

  @override
  void dispose() {
    _countdown?.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _countdown?.dispose();
    _countdown =
        CountdownController(
          durationSeconds: _problem.seconds,
          onExpire: _onFail,
        )..addListener(() {
          if (mounted) setState(() {});
        });
  }

  void _newProblem() {
    setState(() {
      _problem = generateMentalCalcProblem(_random);
      _attempts = 0;
      _wrongChoice = null;
      _solved = false;
      _showFailure = false;
    });
    _startCountdown();
  }

  void _onChoiceTap(int choice) {
    if (_solved || _showFailure) return;
    if (choice == _problem.answer) {
      _countdown?.dispose();
      _countdown = null;
      setState(() => _solved = true);
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) _newProblem();
      });
      return;
    }
    _attempts++;
    setState(() => _wrongChoice = choice);
    if (_attempts >= 2) {
      _onFail();
      return;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && !_showFailure) setState(() => _wrongChoice = null);
    });
  }

  /// Les 2 essais sont épuisés, ou le temps est écoulé avant une bonne
  /// réponse — dans les deux cas, on montre la réponse et on encourage
  /// plutôt que de simplement passer au problème suivant sans rien dire.
  void _onFail() {
    if (_showFailure) return;
    _countdown?.dispose();
    _countdown = null;
    setState(() => _showFailure = true);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final fc = t['freeMentalCalc'] as Map<String, dynamic>? ?? {};
    final remaining = _countdown?.remaining ?? _problem.seconds;
    final urgent = remaining <= 3;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AmaniColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  AmaniMascot(
                    pose: _solved
                        ? AmaniPose.celebration
                        : AmaniPose.encouragement,
                    size: AmaniSize.small,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      fc['instruction'] ?? '',
                      style: AmaniTheme.bodyStyle.copyWith(
                        fontSize: 12,
                        color: AmaniColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                ),
                boxShadow: const [
                  BoxShadow(color: Color(0x144A3B2A), blurRadius: 10),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: urgent
                          ? const Color(0xFFC03E3E)
                          : AmaniColors.textPrimary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.timer,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${remaining}s',
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${_problem.display} = ?',
                    style: TextStyle(
                      fontFamily: kBalooFontFamily,
                      fontWeight: FontWeight.w800,
                      fontSize: 30,
                      color: AmaniColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        for (final choice in _problem.choices)
                          _MentalChoiceButton(
                            label: '$choice',
                            state: _solved && choice == _problem.answer
                                ? _MentalChoiceState.correct
                                : _wrongChoice == choice
                                ? _MentalChoiceState.wrong
                                : _MentalChoiceState.idle,
                            dimmed: _solved && choice != _problem.answer,
                            onTap: () => _onChoiceTap(choice),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_showFailure)
          Positioned.fill(
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
                      pose: AmaniPose.reconfort,
                      size: AmaniSize.medium,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      tFormat(fc['failTitle'] ?? '', {
                        'answer': '${_problem.answer}',
                      }),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: AmaniColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      fc['failBody'] ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontSize: 14,
                        height: 1.4,
                        color: AmaniColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _newProblem,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AmaniColors.primary,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          fc['failContinue'] ?? '',
                          textAlign: TextAlign.center,
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
          ),
      ],
    );
  }
}

enum _MentalChoiceState { idle, correct, wrong }

class _MentalChoiceButton extends StatelessWidget {
  final String label;
  final _MentalChoiceState state;
  final bool dimmed;
  final VoidCallback onTap;

  const _MentalChoiceButton({
    required this.label,
    required this.state,
    required this.dimmed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final Color border;
    switch (state) {
      case _MentalChoiceState.correct:
        bg = AmaniColors.success.withValues(alpha: 0.18);
        fg = AmaniColors.success;
        border = AmaniColors.success;
        break;
      case _MentalChoiceState.wrong:
        bg = AmaniColors.error.withValues(alpha: 0.14);
        fg = AmaniColors.error;
        border = AmaniColors.error;
        break;
      case _MentalChoiceState.idle:
        bg = AmaniColors.surface;
        fg = AmaniColors.textPrimary;
        border = AmaniColors.textPrimary.withValues(alpha: 0.15);
        break;
    }
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: dimmed ? 0.4 : 1,
        duration: const Duration(milliseconds: 200),
        child: Container(
          constraints: const BoxConstraints(minWidth: 72, minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: 2),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: kBalooFontFamily,
              fontWeight: FontWeight.w800,
              fontSize: 19,
              color: fg,
            ),
          ),
        ),
      ),
    );
  }
}
