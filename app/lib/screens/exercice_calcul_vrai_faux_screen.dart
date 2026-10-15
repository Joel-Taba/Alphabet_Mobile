import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../data/calcul_catalog.dart';
import '../hooks/use_exercise_settings.dart';
import '../widgets/confetti_burst.dart';
import '../widgets/directional_icon.dart';
import '../widgets/wrong_answer_popup.dart';
import '../widgets/quiz_bubble_card.dart';
import '../widgets/quiz_kit.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../widgets/unbroken_text.dart';
import '../utils/navigation_helpers.dart';

/// Mini-jeu bonus "Vrai ou Faux ?" du Palier "Les Calculs" — purement
/// ludique, sans points ni progression, comme les mots mêlés du Palier
/// "Les Mots". [levelIndex] est l'index dans [VRAI_FAUX_LEVELS]
/// (0=CP … 4=CM2).
const Color _kAccent = Color(0xFF8B5FBF);

class ExerciceCalculVraiFauxScreen extends StatefulWidget {
  final String levelIndex;
  const ExerciceCalculVraiFauxScreen({super.key, required this.levelIndex});

  @override
  State<ExerciceCalculVraiFauxScreen> createState() =>
      _ExerciceCalculVraiFauxScreenState();
}

class _ExerciceCalculVraiFauxScreenState
    extends State<ExerciceCalculVraiFauxScreen> {
  late final ExerciseSettings _settings;
  List<TrueFalseEquation> _items = const [];
  int _index = 0;
  int _score = 0;
  int _restartKey = 0;
  List<bool?> _results = const [];
  bool? _lastCorrect;
  bool? _guessedTrue;
  bool _locked = false;
  bool _showWrongPopup = false;
  final _confettiKey = GlobalKey<ConfettiBurstState>();

  int? get _levelIdx => int.tryParse(widget.levelIndex);

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
    final idx = _levelIdx;
    if (idx == null || idx < 0 || idx >= VRAI_FAUX_LEVELS.length) return;
    final level = VRAI_FAUX_LEVELS[idx];
    _items = level.generateItems(
      idx * 1000 + _restartKey,
      _settings.repetitions,
    );
    _results = List<bool?>.filled(_items.length, null);
    _index = 0;
    _score = 0;
    _lastCorrect = null;
    _guessedTrue = null;
    _locked = false;
    _showWrongPopup = false;
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
      _results[_index] = correct;
      if (correct) _score++;
    });
    if (correct) {
      _confettiKey.currentState?.play();
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        setState(() {
          _index++;
          _lastCorrect = null;
          _guessedTrue = null;
          _locked = false;
        });
      });
    } else {
      // Laisse le temps de voir le contour rouge avant d'expliquer la bonne
      // réponse, plutôt que d'enchaîner directement sur la question
      // suivante sans que l'enfant sache pourquoi il s'est trompé.
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() => _showWrongPopup = true);
      });
    }
  }

  void _continueAfterWrong() {
    setState(() {
      _showWrongPopup = false;
      _index++;
      _lastCorrect = null;
      _guessedTrue = null;
      _locked = false;
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
    final vf = t['calculVraiFaux'] as Map<String, dynamic>? ?? {};
    final common = t['common'] as Map<String, dynamic>? ?? {};
    final idx = _levelIdx;
    final level = (idx != null && idx >= 0 && idx < VRAI_FAUX_LEVELS.length)
        ? VRAI_FAUX_LEVELS[idx]
        : null;

    if (level == null) {
      return Scaffold(
        backgroundColor: AmaniColors.background,
        body: SafeArea(
          child: Center(
            child: GestureDetector(
              onTap: () => goHome(context),
              child: Text(common['backToHome'] ?? ''),
            ),
          ),
        ),
      );
    }

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
                        onTap: () => goHome(context),
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
                          child: DirectionalIcon(LucideIcons.house, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${vf['levelLabel'] ?? 'Niveau'}: '
                              '${calculNiveauLabel(level.niveau, lang.name)}',
                              style: TextStyle(
                                fontFamily: kBalooFontFamily,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                                letterSpacing: 1.2,
                                color: const Color(0xFF6B3F94),
                              ),
                            ),
                            UnbrokenText(
                              (vf['title'] ??
                                      level.title[lang.name] ??
                                      level.title['fr'])
                                  .toString(),
                              style: AmaniTheme.titleStyle.copyWith(
                                fontSize: 20,
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
                    ],
                  ),
                ),
                QuizProgressBar(
                  accent: _kAccent,
                  dots: [
                    for (var i = 0; i < _results.length; i++)
                      _results[i] == null
                          ? (i == _index ? QuizDot.current : QuizDot.pending)
                          : (_results[i]! ? QuizDot.correct : QuizDot.wrong),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: done
                          ? QuizDoneCard(
                              title: (vf['doneTitle'] ?? '').toString(),
                              body: (vf['doneBody'] ?? '').toString(),
                              score: _score,
                              total: _items.length,
                              replayLabel: (common['replay'] ?? 'Relancer')
                                  .toString(),
                              onReplay: _restart,
                              accent: _kAccent,
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
                                  badge: '${_index + 1} / ${_items.length}',
                                  accent: _kAccent,
                                  feedback: _lastCorrect,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      current?.display ?? '',
                                      style: TextStyle(
                                        fontFamily: kBalooFontFamily,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 40,
                                        letterSpacing: 1,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TrueFalseChoices(
                                  key: ValueKey('tf-$_index-$_restartKey'),
                                  trueLabel: (vf['true'] ?? 'Vrai').toString(),
                                  falseLabel: (vf['false'] ?? 'Faux')
                                      .toString(),
                                  picked: _guessedTrue,
                                  pickedCorrect: _lastCorrect,
                                  onAnswer: _answer,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned.fill(child: ConfettiBurst(key: _confettiKey)),
            if (_showWrongPopup && current != null)
              WrongAnswerPopup(
                correctAnswer:
                    (current.isTrue
                            ? (vf['true'] ?? 'Vrai')
                            : (vf['false'] ?? 'Faux'))
                        .toString(),
                explanation: current.correctDisplay,
                onContinue: _continueAfterWrong,
              ),
          ],
        ),
      ),
    );
  }
}
