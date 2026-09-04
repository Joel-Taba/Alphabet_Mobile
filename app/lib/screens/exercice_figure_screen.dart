import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/progress_service.dart';
import '../data/shape_catalog.dart';
import '../hooks/use_accessibility_settings.dart';
import '../hooks/use_exercise_settings.dart';
import '../hooks/use_tracing_scroll_lock.dart';
import '../services/evaluation_session.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/cahier_frame.dart';
import '../widgets/letter_trace_cell.dart';
import '../widgets/exercise_complete_popup.dart';
import '../widgets/evaluation_timer.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Exercice du Palier "Figures géométriques" : trace la figure à main levée,
/// `ExerciseSettings.repetitions` fois de suite, en réutilisant tel quel le
/// mécanisme de traçage des lettres (`LetterTraceCell`) — une figure n'est
/// qu'une suite de traits/courbes, exactement comme une lettre.
class ExerciceFigureScreen extends StatefulWidget {
  final String shapeId;
  final String? amaniEval;
  const ExerciceFigureScreen({
    super.key,
    required this.shapeId,
    this.amaniEval,
  });

  @override
  State<ExerciceFigureScreen> createState() => _ExerciceFigureScreenState();
}

/// Identifiant fixe de cette évaluation (Palier "Figures géométriques") —
/// voir `EvaluationSessionController.ensureContext`.
const String _kEvalId = 'figures';

class _ExerciceFigureScreenState extends State<ExerciceFigureScreen> {
  int _activeIdx = 0;
  final Set<int> _doneIndices = {};
  int _count = 0;
  int _restartKey = 0;
  bool _awaitingRepeatCompletion = false;

  bool get _isEvaluation => widget.amaniEval == '1';
  bool _showFirstSubjectAnnouncement = false;
  Map<String, dynamic>? _resumeOffer;

  late final ExerciseSettings _settings;
  late final EvaluationSessionController _session;

  @override
  void initState() {
    super.initState();
    _session = context.read<EvaluationSessionController>();
    _settings = ExerciseSettings()..addListener(_onSettingsChanged);
    _settings.load().then((_) => _regenerate());
    if (_isEvaluation) _initEvaluation();
  }

  void _onSettingsChanged() {
    if (!mounted) return;
    setState(_regenerate);
  }

  void _regenerate() {
    _count = _settings.repetitions;
    _activeIdx = 0;
    _doneIndices.clear();
  }

  Future<void> _initEvaluation() async {
    if (!mounted) return;
    final continuing = _session.ensureContext(_kEvalId);
    _session.configureSubjects(SHAPE_TOPICS.length);
    if (continuing) return;
    final saved = await _session.readSavedProgress(_kEvalId);
    if (!mounted) return;
    if (saved != null) {
      setState(() => _resumeOffer = saved);
    } else {
      setState(() => _showFirstSubjectAnnouncement = true);
    }
  }

  Future<void> _handleStartFirstSubject() async {
    final minutes = await readEvaluationDurationMinutes();
    if (!mounted) return;
    _session.start(minutes * 60);
    setState(() => _showFirstSubjectAnnouncement = false);
  }

  void _handleResume(Map<String, dynamic> saved) {
    _session.resumeFrom(saved);
    setState(() => _resumeOffer = null);
    final savedIdx = saved['currentSubjectIndex'] as int? ?? 0;
    if (savedIdx >= 0 && savedIdx < SHAPE_TOPICS.length) {
      final savedTopic = SHAPE_TOPICS[savedIdx];
      if (savedTopic.id != widget.shapeId) {
        context.go('/exercice/figure/${savedTopic.id}?amaniEval=1');
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

  @override
  void dispose() {
    if (_isEvaluation) unawaited(_session.persistProgress());
    _settings.removeListener(_onSettingsChanged);
    _settings.dispose();
    super.dispose();
  }

  void _onAttemptDone(int i) {
    setState(() {
      _doneIndices.add(i);
      if (i + 1 < _count) _activeIdx = i + 1;
    });
    context.read<ProgressProvider>().awardCompletion(
      typeEtape: 'FIGURE',
      modalite: 'EXERCICE',
      etapeCode: '${widget.shapeId}-$i',
      palier: 6,
    );
    if (_doneIndices.length >= _count && _awaitingRepeatCompletion) {
      context.read<ProgressProvider>().awardRestartBonus();
      setState(() => _awaitingRepeatCompletion = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final t = languageProvider.t;
    final lang = languageProvider.lang;
    final cf = t['coursFigure'] as Map<String, dynamic>? ?? {};
    final ef = t['exerciceFigure'] as Map<String, dynamic>? ?? {};
    final el = t['exerciceListe'] as Map<String, dynamic>? ?? {};
    final ev = t['evaluation'] as Map<String, dynamic>? ?? {};
    final session = context.watch<EvaluationSessionController>();
    final topic = findShapeTopic(widget.shapeId);

    if (topic == null) {
      return Scaffold(
        backgroundColor: AmaniColors.background,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '"${widget.shapeId}" ${cf['notFound'] ?? ''}',
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
                      cf['backToList'] ?? '',
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

    final name = topic.name[lang.name] ?? topic.name['fr']!;
    final topicIdx = SHAPE_TOPICS.indexWhere((s) => s.id == topic.id);
    final nextTopic = topicIdx >= 0 && topicIdx < SHAPE_TOPICS.length - 1
        ? SHAPE_TOPICS[topicIdx + 1]
        : null;
    final evaluationNextTopic = _isEvaluation && topicIdx >= 0
        ? SHAPE_TOPICS[(topicIdx + 1) % SHAPE_TOPICS.length]
        : null;
    final allDone = _count > 0 && _doneIndices.length == _count;

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
                            context.go('/cours/figure/${widget.shapeId}'),
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
                              name,
                              style: AmaniTheme.titleStyle.copyWith(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              tFormat(ef['problemsReady'] ?? '', {
                                'done': _doneIndices.length,
                                'total': _count,
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
                    physics: tracingAwareScrollPhysics(context),
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
                                        ? (ef['allDoneTitle'] ?? '')
                                        : (ef['introTitle'] ?? ''),
                                    style: AmaniTheme.titleStyle.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    allDone
                                        ? (ef['allDoneBody'] ?? '')
                                        : (ef['introBody'] ?? ''),
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

                      for (var i = 0; i < _count; i++) ...[
                        _ShapeAttemptCard(
                          key: ValueKey('${topic.id}-$i-r$_restartKey'),
                          topic: topic,
                          isActive: i == _activeIdx,
                          isFuture: i > _activeIdx,
                          done: _doneIndices.contains(i),
                          doneLabel: el['done'] ?? 'Terminé !',
                          onDone: () => _onAttemptDone(i),
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
                    ? () => context.go('/cours/figure/${nextTopic.id}')
                    : null,
                onRestart: () {
                  setState(() {
                    _restartKey++;
                    _awaitingRepeatCompletion = true;
                    _regenerate();
                  });
                },
              ),
            if (_isEvaluation && session.expired)
              EvaluationCompleteOverlay(onBack: () => context.go('/accueil')),
            if (_isEvaluation && _resumeOffer != null && !session.expired)
              EvaluationResumeOffer(
                onResume: () => _handleResume(_resumeOffer!),
                onRestart: _handleRestart,
              ),
            if (_isEvaluation &&
                _showFirstSubjectAnnouncement &&
                !session.expired)
              EvaluationSubjectAnnouncement(
                title: tFormat(ev['firstSubjectTitle'] ?? '', {'title': name}),
                subtitle: ev['firstSubjectBody'] ?? '',
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
                      evaluationNextTopic.name[lang.name] ??
                      evaluationNextTopic.name['fr']!,
                }),
                onContinue: () {
                  session.advanceSubject((topicIdx + 1) % SHAPE_TOPICS.length);
                  context.go(
                    '/exercice/figure/${evaluationNextTopic.id}?amaniEval=1',
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _ShapeAttemptCard extends StatelessWidget {
  final ShapeTopic topic;
  final bool isActive;
  final bool isFuture;
  final bool done;
  final String doneLabel;
  final VoidCallback onDone;

  const _ShapeAttemptCard({
    super.key,
    required this.topic,
    required this.isActive,
    required this.isFuture,
    required this.done,
    required this.doneLabel,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    // Cadre de tracé agrandi selon le réglage "Taille de l'interface"
    // (Profil > Réglages) : la hauteur fixe du CahierFrame doit grandir en
    // même temps que la case, sous peine d'être rognée par son `ClipRRect`.
    final uiScale = context.read<AccessibilitySettings>().uiScale;
    final cellSize = 160 * uiScale;
    final frameHeight = 220 * uiScale;

    return Opacity(
      opacity: isFuture ? 0.4 : 1,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: done
                ? AmaniColors.secondary.withValues(alpha: 0.6)
                : AmaniColors.textPrimary.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: done ? const Color(0x2E8FBF6F) : const Color(0x144A3B2A),
              blurRadius: done ? 16 : 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            if (done)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '✓ $doneLabel',
                  style: TextStyle(
                    fontFamily: kBalooFontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AmaniColors.secondary,
                  ),
                ),
              ),
            CahierFrame(
              width: double.infinity,
              height: frameHeight,
              rounded: 12,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Sur un écran étroit, borne la case à la largeur
                  // réellement disponible pour ne jamais déborder du
                  // CahierFrame (qui rogne via son `ClipRRect`).
                  final size = math.min(cellSize, constraints.maxWidth);
                  return Center(
                    child: LetterTraceCell(
                      letter: topic.traceData,
                      size: size,
                      isActive: isActive && !done,
                      transparent: true,
                      strokeWidthScale: 0.55,
                      onSolved: isActive && !done ? onDone : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
