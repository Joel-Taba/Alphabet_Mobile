import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../data/shape_catalog.dart';
import '../hooks/use_exercise_settings.dart';
import '../widgets/confetti_burst.dart';
import '../widgets/quiz_bubble_card.dart';
import '../widgets/lettered_choice_button.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Mini-jeu bonus "Vrai ou Faux ?" du Palier "Figures géométriques" —
/// affirmations simples sur les propriétés des figures, calqué directement
/// sur `exercice_calcul_vrai_faux_screen.dart` (même structure d'écran, un
/// nouveau modèle de contenu `ShapeStatement`).
class ExerciceFigureVraiFauxScreen extends StatefulWidget {
  const ExerciceFigureVraiFauxScreen({super.key});

  @override
  State<ExerciceFigureVraiFauxScreen> createState() =>
      _ExerciceFigureVraiFauxScreenState();
}

class _ExerciceFigureVraiFauxScreenState
    extends State<ExerciceFigureVraiFauxScreen> {
  late final ExerciseSettings _settings;
  List<ShapeStatement> _items = const [];
  int _index = 0;
  int _score = 0;
  int _restartKey = 0;
  bool? _lastCorrect;
  bool? _guessedTrue;
  bool _locked = false;
  final _confettiKey = GlobalKey<ConfettiBurstState>();

  @override
  void initState() {
    super.initState();
    _settings = ExerciseSettings()..addListener(_onSettingsChanged);
    _settings.load().then((_) => _regenerate());
  }

  void _onSettingsChanged() {
    if (!mounted) return;
    setState(_regenerate);
  }

  void _regenerate() {
    final pool = [...SHAPE_STATEMENTS]..shuffle(Random(_restartKey));
    final count = _settings.repetitions.clamp(1, pool.length);
    _items = pool.take(count).toList();
    _index = 0;
    _score = 0;
    _lastCorrect = null;
    _locked = false;
  }

  @override
  void dispose() {
    _settings.removeListener(_onSettingsChanged);
    _settings.dispose();
    super.dispose();
  }

  void _answer(bool guessTrue) {
    if (_locked || _index >= _items.length) return;
    final correct = guessTrue == _items[_index].isTrue;
    setState(() {
      _locked = true;
      _lastCorrect = correct;
      _guessedTrue = guessTrue;
      if (correct) _score++;
    });
    if (correct) _confettiKey.currentState?.play();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _index++;
        _lastCorrect = null;
        _guessedTrue = null;
        _locked = false;
      });
    });
  }

  void _restart() {
    setState(() {
      _restartKey++;
      _regenerate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final t = languageProvider.t;
    final lang = languageProvider.lang;
    final vf = t['figureVraiFaux'] as Map<String, dynamic>? ?? {};
    final common = t['common'] as Map<String, dynamic>? ?? {};

    final done = _items.isNotEmpty && _index >= _items.length;
    final current = !done && _items.isNotEmpty ? _items[_index] : null;

    return Scaffold(
      backgroundColor: AmaniColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  decoration: BoxDecoration(
                    color: AmaniColors.background,
                    border: Border(
                      bottom: BorderSide(
                        color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.canPop()
                            ? context.pop()
                            : context.go('/accueil'),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AmaniColors.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x1F000000),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: DirectionalIcon(
                            LucideIcons.arrowLeft,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          (vf['title'] ?? '').toString(),
                          style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
                        ),
                      ),
                      if (_items.isNotEmpty)
                        Text(
                          (vf['scoreLabel'] ?? '{score}/{total}')
                              .toString()
                              .replaceAll('{score}', '$_score')
                              .replaceAll('{total}', '${_items.length}'),
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AmaniColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: done
                          ? _DoneCard(
                              title: (vf['doneTitle'] ?? '').toString(),
                              body: (vf['doneBody'] ?? '').toString(),
                              replayLabel: (common['replay'] ?? 'Relancer')
                                  .toString(),
                              onReplay: _restart,
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  (vf['instruction'] ?? '').toString(),
                                  textAlign: TextAlign.center,
                                  style: AmaniTheme.bodyStyle.copyWith(
                                    fontSize: 14,
                                    color: AmaniColors.textSecondary,
                                  ),
                                ),
                                QuizBubbleCard(
                                  label: (vf['title'] ?? 'Vrai ou faux ?')
                                      .toString(),
                                  child: Text(
                                    current == null
                                        ? ''
                                        : (current.display[lang.name] ??
                                              current.display['fr']!),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: kBalooFontFamily,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    LetteredChoiceButton(
                                      letter: 'A',
                                      content: Text(
                                        (vf['true'] ?? 'Vrai').toString(),
                                        style: TextStyle(
                                          fontFamily: kBalooFontFamily,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          color: AmaniColors.textPrimary,
                                        ),
                                      ),
                                      state: _guessedTrue == true
                                          ? (_lastCorrect!
                                                ? ChoiceVisualState.correct
                                                : ChoiceVisualState.wrong)
                                          : ChoiceVisualState.idle,
                                      dimmed: false,
                                      onTap: () => _answer(true),
                                    ),
                                    const SizedBox(width: 14),
                                    LetteredChoiceButton(
                                      letter: 'B',
                                      content: Text(
                                        (vf['false'] ?? 'Faux').toString(),
                                        style: TextStyle(
                                          fontFamily: kBalooFontFamily,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          color: AmaniColors.textPrimary,
                                        ),
                                      ),
                                      state: _guessedTrue == false
                                          ? (_lastCorrect!
                                                ? ChoiceVisualState.correct
                                                : ChoiceVisualState.wrong)
                                          : ChoiceVisualState.idle,
                                      dimmed: false,
                                      onTap: () => _answer(false),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned.fill(child: ConfettiBurst(key: _confettiKey)),
          ],
        ),
      ),
    );
  }
}

class _DoneCard extends StatelessWidget {
  final String title;
  final String body;
  final String replayLabel;
  final VoidCallback onReplay;

  const _DoneCard({
    required this.title,
    required this.body,
    required this.replayLabel,
    required this.onReplay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: AmaniTheme.bodyStyle.copyWith(
            fontSize: 14,
            color: AmaniColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: onReplay,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFB85454),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  LucideIcons.rotateCcw,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  replayLabel,
                  style: TextStyle(
                    fontFamily: kBalooFontFamily,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
