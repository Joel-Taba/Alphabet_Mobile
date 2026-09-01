import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../services/progress_service.dart';
import '../data/calcul_catalog.dart';
import '../data/letter_style_resolver.dart';
import '../hooks/use_accessibility_settings.dart';
import '../hooks/use_writing_style.dart';
import '../hooks/use_exercise_settings.dart';
import '../hooks/use_countdown.dart';
import '../services/evaluation_session.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/word_trace_attempt.dart';
import '../widgets/mcq_answer.dart';
import '../widgets/digit_keypad_answer.dart';
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
  final Set<int> _timedOutIndices = {};
  int _restartKey = 0;
  bool _awaitingRepeatCompletion = false;
  List<CalculProblem> _problems = const [];

  bool get _isEvaluation => widget.amaniEval == '1';
  bool get _isMentalCalc =>
      findCalculTopic(widget.topicId)?.isMentalCalc ?? false;
  int _mentalDuration = kDefaultMentalCalcDuration;
  CountdownController? _mentalCountdown;

  late final ExerciseSettings _settings;
  bool _showFirstSubjectAnnouncement = false;

  @override
  void initState() {
    super.initState();
    _settings = ExerciseSettings()..addListener(_onSettingsChanged);
    _settings.load().then((_) {
      _regenerate();
      if (_isEvaluation) _initEvaluation();
    });
  }

  void _onSettingsChanged() {
    if (!mounted) return;
    setState(_regenerate);
    _startMentalCountdownForActive();
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
    _timedOutIndices.clear();
  }

  Future<void> _initEvaluation() async {
    final minutes = await readEvaluationDurationMinutes();
    final mentalSeconds = await readMentalCalcDurationSeconds();
    if (!mounted) return;
    _mentalDuration = mentalSeconds;
    final session = context.read<EvaluationSessionController>();
    session.startIfNeeded(minutes * 60);
    final isFirst = session.configureSubjects(CALCUL_TOPICS.length);
    if (isFirst) setState(() => _showFirstSubjectAnnouncement = true);
    _startMentalCountdownForActive();
  }

  /// Chronomètre propre au problème actif (sujet "calcul mental", en
  /// évaluation seulement) — distinct du chrono global de l'évaluation :
  /// il redémarre à chaque nouveau problème plutôt que de courir pour toute
  /// l'évaluation, l'objectif étant de mesurer l'automatisme sur CHAQUE
  /// calcul plutôt que d'imposer un budget global.
  void _startMentalCountdownForActive() {
    final old = _mentalCountdown;
    final applies =
        _isEvaluation &&
        _isMentalCalc &&
        _activeIdx < _problems.length &&
        !_doneIndices.contains(_activeIdx);
    final idx = _activeIdx;
    setState(() {
      _mentalCountdown = applies
          ? (CountdownController(
              durationSeconds: _mentalDuration,
              onExpire: () {
                if (mounted) _onProblemTimeout(idx);
              },
            )..addListener(() {
              if (mounted) setState(() {});
            }))
          : null;
    });
    old?.dispose();
  }

  @override
  void dispose() {
    _mentalCountdown?.dispose();
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
    _startMentalCountdownForActive();
  }

  /// Le temps imparti pour le problème actif s'est écoulé (calcul mental,
  /// évaluation) : on passe au suivant sans créditer la réussite — répondre
  /// juste mais trop lentement ne valide pas l'automatisme visé.
  void _onProblemTimeout(int i) {
    if (_doneIndices.contains(i)) return;
    setState(() {
      _timedOutIndices.add(i);
      _doneIndices.add(i);
      if (i + 1 < _problems.length) {
        _activeIdx = i + 1;
      }
    });
    if (_doneIndices.length >= _problems.length && _awaitingRepeatCompletion) {
      context.read<ProgressProvider>().awardRestartBonus();
      setState(() => _awaitingRepeatCompletion = false);
    }
    _startMentalCountdownForActive();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final cc = t['coursCalcul'] as Map<String, dynamic>? ?? {};
    final ec = t['exerciceCalcul'] as Map<String, dynamic>? ?? {};
    final ev = t['evaluation'] as Map<String, dynamic>? ?? {};
    final el = t['exerciceListe'] as Map<String, dynamic>? ?? {};
    final session = context.watch<EvaluationSessionController>();
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
                  onTap: () =>
                      context.canPop() ? context.pop() : context.go('/accueil'),
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
                if (_isEvaluation && session.isRunning)
                  EvaluationTimerBadge(
                    remaining: session.remainingSeconds,
                    subjectsDone: session.subjectsDone,
                    subjectTotal: session.subjectTotal,
                  ),
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
                          timedOut: _timedOutIndices.contains(i),
                          doneLabel: el['done'] ?? 'Terminé !',
                          timedOutLabel:
                              ec['mentalTimeout'] ?? 'Temps écoulé !',
                          mentalRemaining: i == _activeIdx
                              ? _mentalCountdown?.remaining
                              : null,
                          onDone: () => _onProblemDone(i),
                        ),
                        const SizedBox(height: 12),
                      ],
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
                  _startMentalCountdownForActive();
                },
              ),
            if (_isEvaluation && session.expired)
              EvaluationCompleteOverlay(
                onBack: () => context.go('/accueil?scrollToPalier=6'),
              ),
            if (_isEvaluation &&
                _showFirstSubjectAnnouncement &&
                !session.expired)
              EvaluationSubjectAnnouncement(
                title: tFormat(ev['firstSubjectTitle'] ?? '', {
                  'title': topic.title,
                }),
                subtitle: ev['firstSubjectBody'] ?? '',
                onContinue: () =>
                    setState(() => _showFirstSubjectAnnouncement = false),
              ),
            if (allDone &&
                _isEvaluation &&
                evaluationNextTopic != null &&
                !session.expired)
              EvaluationSubjectAnnouncement(
                title: ev['nextSubjectTitle'] ?? '',
                subtitle: tFormat(ev['nextSubjectBody'] ?? '', {
                  'title': evaluationNextTopic.title,
                }),
                onContinue: () {
                  session.advanceSubject();
                  context.go(
                    '/exercice/calcul/${evaluationNextTopic.id}?amaniEval=1',
                  );
                },
              ),
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
  final bool timedOut;
  final String doneLabel;
  final String timedOutLabel;
  final int? mentalRemaining;
  final VoidCallback onDone;

  const _ProblemRow({
    super.key,
    required this.problem,
    required this.isActive,
    required this.isFuture,
    required this.done,
    this.timedOut = false,
    required this.doneLabel,
    this.timedOutLabel = '',
    this.mentalRemaining,
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
            color: widget.timedOut
                ? AmaniColors.warning.withValues(alpha: 0.6)
                : widget.done
                ? AmaniColors.secondary.withValues(alpha: 0.6)
                : AmaniColors.textPrimary.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: widget.timedOut
                  ? const Color(0x2EE3B873)
                  : widget.done
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  if (widget.timedOut)
                    Text(
                      '⏱ ${widget.timedOutLabel}',
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AmaniColors.warning,
                      ),
                    )
                  else if (widget.done)
                    Text(
                      '✓ ${widget.doneLabel}',
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AmaniColors.secondary,
                      ),
                    )
                  else if (widget.mentalRemaining != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: widget.mentalRemaining! <= 5
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
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.mentalRemaining}s',
                            style: TextStyle(
                              fontFamily: kBalooFontFamily,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => speech.speak(widget.problem.display, lang),
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
            if (widget.problem.keypadAnswer)
              DigitKeypadAnswer(
                correctAnswer: widget.problem.answer,
                isActive: widget.isActive,
                isFuture: widget.isFuture,
                solved: widget.done,
                onSolved: widget.onDone,
              )
            else if (widget.problem.choices != null)
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
              Builder(
                builder: (context) {
                  // Boîtes englobantes des deux nombres élargies avec le
                  // réglage "Taille de l'interface" (Profil > Réglages) --
                  // sans ça, une fois `WordTraceAttempt` agrandi, ses
                  // chiffres wrapperaient sur plusieurs lignes dans une
                  // largeur restée calée sur l'ancienne taille de case,
                  // cassant la mise en page de l'équation.
                  final uiScale = context.read<AccessibilitySettings>().uiScale;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    // Défilement horizontal de secours : à taille
                    // d'interface élevée et pour de grands nombres,
                    // l'équation peut dépasser la largeur de l'écran --
                    // mieux vaut pouvoir la faire défiler que la voir
                    // débordée/rognée.
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: (digits.length * 62.0 + 24) * uiScale,
                            child: WordTraceAttempt(
                              letters: digits,
                              cellSize: 56,
                              solved: _solved,
                              isActive: widget.isActive,
                              isFuture: widget.isFuture,
                              onLetterSolved: (i) {
                                setState(() {
                                  _solved.add(i);
                                  _maybeDone(
                                    digits.length,
                                    digitsSecond.length,
                                  );
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
                            width: (digitsSecond.length * 62.0 + 24) * uiScale,
                            child: WordTraceAttempt(
                              letters: digitsSecond,
                              cellSize: 56,
                              solved: _solvedSecond,
                              isActive: widget.isActive,
                              isFuture: widget.isFuture,
                              onLetterSolved: (i) {
                                setState(() {
                                  _solvedSecond.add(i);
                                  _maybeDone(
                                    digits.length,
                                    digitsSecond.length,
                                  );
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
