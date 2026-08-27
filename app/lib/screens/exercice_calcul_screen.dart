import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../services/progress_service.dart';
import '../data/calcul_catalog.dart';
import '../data/letter_style_resolver.dart';
import '../hooks/use_writing_style.dart';
import '../hooks/use_exercise_settings.dart';
import '../hooks/use_countdown.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/word_trace_attempt.dart';
import '../widgets/mcq_answer.dart';
import '../widgets/exercise_complete_popup.dart';
import '../widgets/evaluation_timer.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Exercice du Palier "Les Calculs" : trace la réponse de chaque problème,
/// chiffre par chiffre, en réutilisant le même mécanisme de traçage que les
/// mots/syllabes (`WordTraceAttempt` + catalogue `DIGITS`). Le nombre de
/// problèmes par session vient du réglage "Répétitions" (Profil > Réglages),
/// chaque problème étant distinct plutôt que répété — la variété des
/// problèmes tient ici lieu de répétition.
class ExerciceCalculScreen extends StatefulWidget {
  final String topicId;
  final String? amaniEval;
  const ExerciceCalculScreen({
    super.key,
    required this.topicId,
    this.amaniEval,
  });

  @override
  State<ExerciceCalculScreen> createState() => _ExerciceCalculScreenState();
}

class _ExerciceCalculScreenState extends State<ExerciceCalculScreen> {
  int _activeIdx = 0;
  final Set<int> _doneIndices = {};
  int _restartKey = 0;
  bool _awaitingRepeatCompletion = false;
  List<CalculProblem> _problems = const [];

  bool get _isEvaluation => widget.amaniEval == '1';
  CountdownController? _countdown;
  bool _evaluationExpired = false;

  late final ExerciseSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = ExerciseSettings()..addListener(_onSettingsChanged);
    _settings.load().then((_) => _regenerate());
    if (_isEvaluation) _initEvaluation();
  }

  void _onSettingsChanged() {
    if (!mounted) return;
    setState(_regenerate);
  }

  void _regenerate() {
    final topic = findCalculTopic(widget.topicId);
    if (topic == null) return;
    _problems = topic.generateProblems(
      topic.id.hashCode ^ _restartKey,
      _settings.repetitions,
    );
    _activeIdx = 0;
    _doneIndices.clear();
  }

  Future<void> _initEvaluation() async {
    final minutes = await readEvaluationDurationMinutes();
    if (!mounted) return;
    setState(() {
      _countdown =
          CountdownController(
            durationSeconds: minutes * 60,
            onExpire: () {
              if (mounted) setState(() => _evaluationExpired = true);
            },
          )..addListener(() {
            if (mounted) setState(() {});
          });
    });
  }

  @override
  void dispose() {
    _countdown?.dispose();
    _settings.removeListener(_onSettingsChanged);
    _settings.dispose();
    super.dispose();
  }

  void _onProblemDone(int i) {
    setState(() {
      _doneIndices.add(i);
      if (i + 1 < _problems.length) {
        _activeIdx = i + 1;
      }
    });
    context.read<ProgressProvider>().awardCompletion(
      typeEtape: 'CALCUL',
      modalite: 'EXERCICE',
      etapeCode: '${widget.topicId}-$i',
      palier: 5,
    );
    if (_doneIndices.length >= _problems.length && _awaitingRepeatCompletion) {
      context.read<ProgressProvider>().awardRestartBonus();
      setState(() => _awaitingRepeatCompletion = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final cc = t['coursCalcul'] as Map<String, dynamic>? ?? {};
    final ec = t['exerciceCalcul'] as Map<String, dynamic>? ?? {};
    final el = t['exerciceListe'] as Map<String, dynamic>? ?? {};
    final topic = findCalculTopic(widget.topicId);

    if (topic == null) {
      return Scaffold(
        backgroundColor: AmaniColors.background,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '"${widget.topicId}" ${cc['notFound'] ?? ''}',
                  style: AmaniTheme.titleStyle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => context.go('/accueil'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AmaniColors.secondary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      cc['backToList'] ?? '',
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w700,
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

    final topicIdx = CALCUL_TOPICS.indexWhere((c) => c.id == topic.id);
    final nextTopic = topicIdx >= 0 && topicIdx < CALCUL_TOPICS.length - 1
        ? CALCUL_TOPICS[topicIdx + 1]
        : null;
    final evaluationNextTopic = _isEvaluation && topicIdx >= 0
        ? CALCUL_TOPICS[(topicIdx + 1) % CALCUL_TOPICS.length]
        : null;

    final allDone =
        _problems.isNotEmpty && _doneIndices.length == _problems.length;

    return Scaffold(
      backgroundColor: AmaniColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                if (_isEvaluation && !_evaluationExpired && _countdown != null)
                  EvaluationTimerBadge(remaining: _countdown!.remaining),
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
                        onTap: () =>
                            context.go('/cours/calcul/${widget.topicId}'),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topic.title,
                              style: AmaniTheme.titleStyle.copyWith(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              tFormat(ec['problemsReady'] ?? '', {
                                'done': _doneIndices.length,
                                'total': _problems.length,
                              }),
                              style: AmaniTheme.bodyStyle.copyWith(
                                fontSize: 12,
                                color: AmaniColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AmaniColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AmaniColors.textPrimary.withValues(
                              alpha: 0.1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            AmaniMascot(
                              pose: allDone
                                  ? AmaniPose.celebration
                                  : AmaniPose.encouragement,
                              size: AmaniSize.small,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    allDone
                                        ? (ec['allDoneTitle'] ?? '')
                                        : (ec['introTitle'] ?? ''),
                                    style: AmaniTheme.titleStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    allDone
                                        ? (ec['allDoneBody'] ?? '')
                                        : (ec['introBody'] ?? ''),
                                    style: AmaniTheme.bodyStyle.copyWith(
                                      fontSize: 12,
                                      color: AmaniColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      for (var i = 0; i < _problems.length; i++) ...[
                        _ProblemRow(
                          key: ValueKey('${topic.id}-$i-r$_restartKey'),
                          problem: _problems[i],
                          isActive: i == _activeIdx,
                          isFuture: i > _activeIdx,
                          done: _doneIndices.contains(i),
                          doneLabel: el['done'] ?? 'Terminé !',
                          onDone: () => _onProblemDone(i),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (allDone &&
                          _isEvaluation &&
                          evaluationNextTopic != null)
                        GestureDetector(
                          onTap: () => context.go(
                            '/exercice/calcul/${evaluationNextTopic.id}?amaniEval=1',
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B5FBF),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x338B5FBF),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  tFormat(ec['nextTopic'] ?? '', {
                                    'title': evaluationNextTopic.title,
                                  }),
                                  style: TextStyle(
                                    fontFamily: kBalooFontFamily,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                DirectionalIcon(
                                  LucideIcons.chevronRight,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
            if (allDone && !_isEvaluation)
              ExerciseCompletePopup(
                onBackHome: () => context.go('/accueil'),
                onNext: nextTopic != null
                    ? () => context.go('/cours/calcul/${nextTopic.id}')
                    : null,
                onRestart: () {
                  setState(() {
                    _restartKey++;
                    _awaitingRepeatCompletion = true;
                    _regenerate();
                  });
                },
              ),
            if (_isEvaluation && _evaluationExpired)
              EvaluationCompleteOverlay(onBack: () => context.go('/accueil')),
          ],
        ),
      ),
    );
  }
}

class _ProblemRow extends StatefulWidget {
  final CalculProblem problem;
  final bool isActive;
  final bool isFuture;
  final bool done;
  final String doneLabel;
  final VoidCallback onDone;

  const _ProblemRow({
    super.key,
    required this.problem,
    required this.isActive,
    required this.isFuture,
    required this.done,
    required this.doneLabel,
    required this.onDone,
  });

  @override
  State<_ProblemRow> createState() => _ProblemRowState();
}

class _ProblemRowState extends State<_ProblemRow> {
  final Set<int> _solved = {};
  final Set<int> _solvedSecond = {};

  bool get _hasSecondPart => widget.problem.answerSecondPart != null;

  void _maybeDone(int totalFirst, int totalSecond) {
    final firstDone = _solved.length == totalFirst;
    final secondDone = !_hasSecondPart || _solvedSecond.length == totalSecond;
    if (firstDone && secondDone) widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    final speech = context.read<SignSpeechService>();
    final lang = context.watch<LanguageProvider>().lang;
    final style = context.watch<WritingStyleProvider>().style.name;
    final digits = widget.problem.answer
        .split('')
        .map((c) => getLetterFormation(c, style))
        .whereType<dynamic>()
        .toList();
    final digitsSecond = _hasSecondPart
        ? widget.problem.answerSecondPart!
              .split('')
              .map((c) => getLetterFormation(c, style))
              .whereType<dynamic>()
              .toList()
        : const <dynamic>[];

    return Opacity(
      opacity: widget.isFuture ? 0.4 : 1,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.done
                ? AmaniColors.secondary.withValues(alpha: 0.6)
                : AmaniColors.textPrimary.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: widget.done
                  ? const Color(0x2E8FBF6F)
                  : const Color(0x144A3B2A),
              blurRadius: widget.done ? 16 : 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: AmaniColors.surface,
                border: Border(
                  bottom: BorderSide(
                    color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${widget.problem.display} = ?',
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AmaniColors.textPrimary,
                      ),
                    ),
                  ),
                  if (widget.done)
                    Text(
                      '✓ ${widget.doneLabel}',
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AmaniColors.secondary,
                      ),
                    ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () =>
                        speech.speak(widget.problem.display, lang),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0x268B5FBF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.volume2,
                        size: 14,
                        color: Color(0xFF6B3F94),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.problem.choices != null)
              McqAnswer(
                choices: widget.problem.choices!,
                correctAnswer: widget.problem.answer,
                isActive: widget.isActive,
                isFuture: widget.isFuture,
                solved: widget.done,
                onSolved: widget.onDone,
              )
            else if (!_hasSecondPart)
              WordTraceAttempt(
                letters: digits,
                cellSize: 64,
                solved: _solved,
                isActive: widget.isActive,
                isFuture: widget.isFuture,
                onLetterSolved: (i) {
                  setState(() {
                    _solved.add(i);
                    _maybeDone(digits.length, digitsSecond.length);
                  });
                },
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: digits.length * 62.0 + 24,
                      child: WordTraceAttempt(
                        letters: digits,
                        cellSize: 56,
                        solved: _solved,
                        isActive: widget.isActive,
                        isFuture: widget.isFuture,
                        onLetterSolved: (i) {
                          setState(() {
                            _solved.add(i);
                            _maybeDone(digits.length, digitsSecond.length);
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        widget.problem.secondPartSeparator,
                        style: TextStyle(
                          fontFamily: kBalooFontFamily,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: AmaniColors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: digitsSecond.length * 62.0 + 24,
                      child: WordTraceAttempt(
                        letters: digitsSecond,
                        cellSize: 56,
                        solved: _solvedSecond,
                        isActive: widget.isActive,
                        isFuture: widget.isFuture,
                        onLetterSolved: (i) {
                          setState(() {
                            _solvedSecond.add(i);
                            _maybeDone(digits.length, digitsSecond.length);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
