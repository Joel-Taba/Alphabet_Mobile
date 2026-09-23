import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../services/progress_service.dart';
import '../data/calcul_catalog.dart';
import '../hooks/use_exercise_settings.dart';
import '../hooks/use_countdown.dart';
import '../hooks/use_tracing_scroll_lock.dart';
import '../services/evaluation_session.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/mcq_answer.dart';
import '../widgets/digit_keypad_answer.dart';
import '../widgets/exercise_complete_popup.dart';
import '../widgets/evaluation_timer.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../utils/navigation_helpers.dart';

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

/// Identifiant fixe de cette évaluation (Palier "Les Calculs") — voir
/// `EvaluationSessionController.ensureContext`, distingue cette évaluation
/// de celles des autres paliers pour que chacune ait son propre chrono,
/// son propre décompte de sujets, et sa propre reprise éventuelle.
const String _kEvalId = 'calculs';

class _ExerciceCalculScreenState extends State<ExerciceCalculScreen> {
  int _activeIdx = 0;
  final Set<int> _doneIndices = {};
  final Set<int> _timedOutIndices = {};
  int _restartKey = 0;

  /// `true` uniquement lorsque le dernier problème manquant vient d'être
  /// résolu PENDANT cette visite (voir `_onProblemDone`) -- jamais lors de
  /// la restauration d'un exercice déjà entièrement résolu lors d'une
  /// session précédente (voir `_regenerate`). Sans cette distinction,
  /// rouvrir un exercice déjà terminé ferait immédiatement réapparaître la
  /// pop-up de félicitations (confettis compris), comme dans
  /// `exercice_lettre_screen.dart`.
  bool _justCompletedThisVisit = false;
  bool _awaitingRepeatCompletion = false;
  List<CalculProblem> _problems = const [];

  bool get _isEvaluation => widget.amaniEval == '1';
  int? get _mentalCalcSeconds =>
      findCalculTopic(widget.topicId)?.mentalCalcSeconds;
  CountdownController? _mentalCountdown;

  late final ExerciseSettings _settings;
  late final EvaluationSessionController _session;
  bool _showFirstSubjectAnnouncement = false;
  Map<String, dynamic>? _resumeOffer;

  @override
  void initState() {
    super.initState();
    _session = context.read<EvaluationSessionController>();
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
    _justCompletedThisVisit = false;
    // Persistance permanente : un problème déjà résolu lors d'une session
    // précédente le reste pour toujours (voir `ProgressProvider`) -- jamais
    // en évaluation (session chronométrée à part) ni après "Recommencer"
    // (l'enfant vient alors explicitement de choisir de tout refaire).
    if (!_isEvaluation && _restartKey == 0 && mounted) {
      final progress = context.read<ProgressProvider>();
      for (var i = 0; i < _problems.length; i++) {
        if (progress.isCompleted(
          typeEtape: 'CALCUL',
          modalite: 'EXERCICE',
          etapeCode: '${widget.topicId}-$i',
        )) {
          _doneIndices.add(i);
        }
      }
      final firstNotDone = List.generate(
        _problems.length,
        (i) => i,
      ).firstWhere((i) => !_doneIndices.contains(i), orElse: () => _problems.length - 1);
      _activeIdx = _problems.isEmpty ? 0 : firstNotDone;
    }
  }

  Future<void> _initEvaluation() async {
    if (!mounted) return;
    final continuing = _session.ensureContext(_kEvalId);
    _session.configureSubjects(CALCUL_TOPICS.length);
    _startMentalCountdownForActive();
    if (continuing) return;
    final saved = await _session.readSavedProgress(_kEvalId);
    if (!mounted) return;
    if (saved != null) {
      setState(() => _resumeOffer = saved);
    } else {
      setState(() => _showFirstSubjectAnnouncement = true);
    }
  }

  /// Lance réellement le chrono de l'évaluation — appelé seulement quand
  /// l'enfant appuie sur "Continuer" (premier sujet) ou "Reprendre", jamais
  /// automatiquement à l'ouverture de l'écran : le temps annoncé doit
  /// toujours être celui actuellement réglé dans Profil, relu à cet instant
  /// précis plutôt que mis en cache plus tôt.
  Future<void> _handleStartFirstSubject() async {
    final minutes = await readEvaluationDurationMinutes();
    if (!mounted) return;
    _session.start(minutes * 60);
    setState(() => _showFirstSubjectAnnouncement = false);
    _startMentalCountdownForActive();
  }

  void _handleResume(Map<String, dynamic> saved) {
    _session.resumeFrom(saved);
    setState(() {
      _resumeOffer = null;
      // Les identifiants sauvegardés sont `'$topicId-$index'` (voir
      // `_onProblemDone`/`_onProblemTimeout`) — ne retient que ceux du
      // sujet affiché ici, et seulement leur index, pour retrouver l'état
      // de `_doneIndices`/`_activeIdx` exactement comme avant la sortie.
      final prefix = '${widget.topicId}-';
      _doneIndices.clear();
      for (final id in _session.completedItems) {
        if (id.startsWith(prefix)) {
          final idx = int.tryParse(id.substring(prefix.length));
          if (idx != null) _doneIndices.add(idx);
        }
      }
      if (_doneIndices.isNotEmpty) {
        _activeIdx = (_doneIndices.reduce((a, b) => a > b ? a : b) + 1).clamp(
          0,
          _problems.isEmpty ? 0 : _problems.length - 1,
        );
      }
    });
    _startMentalCountdownForActive();
    final savedIdx = saved['currentSubjectIndex'] as int? ?? 0;
    if (savedIdx >= 0 && savedIdx < CALCUL_TOPICS.length) {
      final savedTopic = CALCUL_TOPICS[savedIdx];
      if (savedTopic.id != widget.topicId) {
        context.replace('/exercice/calcul/${savedTopic.id}?amaniEval=1');
      }
    }
  }

  void _handleRestart() {
    unawaited(_session.clearSavedProgress(_kEvalId));
    setState(() {
      _resumeOffer = null;
      _showFirstSubjectAnnouncement = true;
    });
  }

  /// Chronomètre propre au problème actif (sujet "calcul mental", en
  /// évaluation seulement) — distinct du chrono global de l'évaluation :
  /// il redémarre à chaque nouveau problème plutôt que de courir pour toute
  /// l'évaluation, l'objectif étant de mesurer l'automatisme sur CHAQUE
  /// calcul plutôt que d'imposer un budget global. Ne démarre que si le
  /// chrono global est déjà lancé (pas avant que l'enfant ait fermé
  /// l'annonce du premier sujet, ni pendant une éventuelle proposition de
  /// reprise).
  void _startMentalCountdownForActive() {
    final old = _mentalCountdown;
    final seconds = _mentalCalcSeconds;
    final applies =
        _isEvaluation &&
        _session.isRunning &&
        seconds != null &&
        _activeIdx < _problems.length &&
        !_doneIndices.contains(_activeIdx);
    final idx = _activeIdx;
    setState(() {
      _mentalCountdown = applies
          ? (CountdownController(
              durationSeconds: seconds,
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
    if (_isEvaluation) unawaited(_session.persistProgress());
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
      } else {
        _justCompletedThisVisit = true;
      }
    });
    if (_isEvaluation) _session.recordItemDone('${widget.topicId}-$i');
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
    if (_isEvaluation) _session.recordItemDone('${widget.topicId}-$i');
    if (_doneIndices.length >= _problems.length && _awaitingRepeatCompletion) {
      context.read<ProgressProvider>().awardRestartBonus();
      setState(() => _awaitingRepeatCompletion = false);
    }
    _startMentalCountdownForActive();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final t = languageProvider.t;
    final lang = languageProvider.lang;
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
                      goHome(context),
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
                          child: DirectionalIcon(
                            LucideIcons.house,
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
                              topic.title[lang.name] ?? topic.title['fr']!,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Container(
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
                ),
                Expanded(
                  child: CustomScrollView(
                    physics: tracingAwareScrollPhysics(context),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(12, 16, 12, 48),
                        // Une seule feuille de cahier pour toute la page,
                        // avec une séparation entre chaque problème — même
                        // traitement qu'aux Paliers 1, 2, 3 et 4 (voir
                        // `exercice_liste_screen.dart`,
                        // `exercice_lettre_screen.dart`,
                        // `exercice_syllabes_screen.dart`,
                        // `exercice_mots_screen.dart`).
                        sliver: DecoratedSliver(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AmaniColors.textPrimary.withValues(
                                alpha: 0.1,
                              ),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x144A3B2A),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          sliver: SliverMainAxisGroup(
                            slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.all(4),
                                sliver: SliverList(
                                  delegate: SliverChildListDelegate([
                                    for (
                                      var i = 0;
                                      i < _problems.length;
                                      i++
                                    ) ...[
                                      if (i > 0)
                                        Divider(
                                          height: 1,
                                          color: AmaniColors.textPrimary
                                              .withValues(alpha: 0.1),
                                        ),
                                      _ProblemRow(
                                        key: ValueKey(
                                          '${topic.id}-$i-r$_restartKey',
                                        ),
                                        problem: _problems[i],
                                        isActive: i == _activeIdx,
                                        isFuture: i > _activeIdx,
                                        done: _doneIndices.contains(i),
                                        timedOut: _timedOutIndices.contains(
                                          i,
                                        ),
                                        doneLabel: el['done'] ?? 'Terminé !',
                                        timedOutLabel:
                                            ec['mentalTimeout'] ??
                                            'Temps écoulé !',
                                        mentalRemaining: i == _activeIdx
                                            ? _mentalCountdown?.remaining
                                            : null,
                                        onDone: () => _onProblemDone(i),
                                      ),
                                    ],
                                  ]),
                                ),
                              ),
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: CustomPaint(
                                  painter: _TrailingCahierLinesPainter(),
                                  size: Size.infinite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (allDone && !_isEvaluation && _justCompletedThisVisit)
              ExerciseCompletePopup(
                onBackHome: () => goHome(context),
                onNext: nextTopic != null
                    ? () => context.replace('/cours/calcul/${nextTopic.id}')
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
                onBack: () => goHome(context),
              ),
            if (_isEvaluation && _resumeOffer != null && !session.expired)
              EvaluationResumeOffer(
                onResume: () => _handleResume(_resumeOffer!),
                onRestart: _handleRestart,
              ),
            if (_isEvaluation &&
                _showFirstSubjectAnnouncement &&
                !session.expired)
              EvaluationSubjectAnnouncement(
                title: tFormat(ev['firstSubjectTitle'] ?? '', {
                  'title': topic.title[lang.name] ?? topic.title['fr']!,
                }),
                subtitle: ev['firstSubjectBody'] ?? '',
                continueLabel: ev['startFirstSubject'],
                onContinue: _handleStartFirstSubject,
              ),
            if (allDone &&
                _isEvaluation &&
                evaluationNextTopic != null &&
                !session.expired)
              EvaluationSubjectAnnouncement(
                title: ev['nextSubjectTitle'] ?? '',
                subtitle: tFormat(ev['nextSubjectBody'] ?? '', {
                  'title':
                      evaluationNextTopic.title[lang.name] ??
                      evaluationNextTopic.title['fr']!,
                }),
                onContinue: () {
                  session.advanceSubject((topicIdx + 1) % CALCUL_TOPICS.length);
                  context.replace(
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
  @override
  Widget build(BuildContext context) {
    final speech = context.read<SignSpeechService>();
    final lang = context.watch<LanguageProvider>().lang;

    return Opacity(
      opacity: widget.isFuture ? 0.4 : 1,
      // Feuille de cahier partagée (voir `_ExerciceCalculScreenState.build`)
      // : plus de carte blanche/bordure/ombre propre à chaque problème —
      // juste un filet de séparation sous l'en-tête, comme aux Paliers 1 à
      // 4.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
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
                correctAnswer: widget.problem.answerSecondPart != null
                    ? '${widget.problem.answer}'
                          '${widget.problem.secondPartSeparator}'
                          '${widget.problem.answerSecondPart}'
                    : widget.problem.answer,
                isActive: widget.isActive,
                isFuture: widget.isFuture,
                solved: widget.done,
                onSolved: widget.onDone,
              ),
          ],
        ),
    );
  }
}

/// Prolonge visuellement la feuille de cahier partagée jusqu'en bas de la
/// page quand le contenu ne suffit pas à la remplir — copie de
/// `_TrailingCahierLinesPainter` (`exercice_liste_screen.dart`, Palier 1).
class _TrailingCahierLinesPainter extends CustomPainter {
  static const List<double> _positions = [10, 70, 130, 190];
  static const double _rowHeight = 120;
  static const double _rowSpacing = 10;

  @override
  void paint(Canvas canvas, Size size) {
    const scale = _rowHeight / 200;
    var rowTop = 0.0;
    while (rowTop < size.height) {
      for (var i = 0; i < _positions.length; i++) {
        final y = rowTop + _positions[i] * scale;
        if (y > size.height) break;
        final isBaseline = i == 2;
        final paint = Paint()
          ..color =
              (isBaseline ? const Color(0xFFE05252) : const Color(0xFF4A90E2))
                  .withValues(alpha: 0.5)
          ..strokeWidth = isBaseline ? 1.5 : 1;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }
      rowTop += _rowHeight + _rowSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant _TrailingCahierLinesPainter oldDelegate) =>
      false;
}
