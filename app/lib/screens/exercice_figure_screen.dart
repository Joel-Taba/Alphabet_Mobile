import 'dart:async';
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
import '../widgets/letter_trace_cell.dart';
import '../widgets/exercise_complete_popup.dart';
import '../widgets/evaluation_timer.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../utils/navigation_helpers.dart';

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

  /// Voir `exercice_calcul_screen.dart::_justCompletedThisVisit`.
  bool _justCompletedThisVisit = false;

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
    _justCompletedThisVisit = false;
    // Persistance permanente : voir `exercice_calcul_screen.dart::_regenerate`.
    if (!_isEvaluation && _restartKey == 0 && mounted) {
      final progress = context.read<ProgressProvider>();
      for (var i = 0; i < _count; i++) {
        if (progress.isCompleted(
          typeEtape: 'FIGURE',
          modalite: 'EXERCICE',
          etapeCode: '${widget.shapeId}-$i',
        )) {
          _doneIndices.add(i);
        }
      }
      final firstNotDone = List.generate(
        _count,
        (i) => i,
      ).firstWhere((i) => !_doneIndices.contains(i), orElse: () => _count - 1);
      _activeIdx = _count == 0 ? 0 : firstNotDone;
    }
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
    setState(() {
      _resumeOffer = null;
      // Identifiants sauvegardés `'$shapeId-$index'` (voir `_onAttemptDone`)
      // — ne retient que ceux du sujet affiché ici, et seulement leur index.
      final prefix = '${widget.shapeId}-';
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
          _count == 0 ? 0 : _count - 1,
        );
      }
    });
    final savedIdx = saved['currentSubjectIndex'] as int? ?? 0;
    if (savedIdx >= 0 && savedIdx < SHAPE_TOPICS.length) {
      final savedTopic = SHAPE_TOPICS[savedIdx];
      if (savedTopic.id != widget.shapeId) {
        context.replace('/exercice/figure/${savedTopic.id}?amaniEval=1');
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
      if (i + 1 < _count) {
        _activeIdx = i + 1;
      } else {
        _justCompletedThisVisit = true;
      }
    });
    if (_isEvaluation) _session.recordItemDone('${widget.shapeId}-$i');
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

                      // Répétitions en grille — remplit d'abord chaque
                      // ligne horizontalement (autant qu'il en tient) puis
                      // passe à la ligne suivante, exactement comme les
                      // répétitions de lettres (`LetterRepetitionRow`),
                      // plutôt qu'une carte pleine largeur par tentative.
                      _ShapeAttemptGrid(
                        key: ValueKey('${topic.id}-r$_restartKey'),
                        topic: topic,
                        count: _count,
                        activeIdx: _activeIdx,
                        doneIndices: _doneIndices,
                        onAttemptDone: _onAttemptDone,
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
                    ? () => context.replace('/cours/figure/${nextTopic.id}')
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
              EvaluationCompleteOverlay(onBack: () => goHome(context)),
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
                      evaluationNextTopic.name[lang.name] ??
                      evaluationNextTopic.name['fr']!,
                }),
                onContinue: () {
                  session.advanceSubject((topicIdx + 1) % SHAPE_TOPICS.length);
                  context.replace(
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

/// Grille des tentatives d'une figure — remplit chaque ligne horizontalement
/// (autant de cases qu'il en tient) puis passe à la ligne suivante, même
/// agencement que les répétitions de lettres (`LetterRepetitionRow`) : un
/// unique quadrillage Seyès partagé derrière un `Wrap` de cases carrées,
/// plutôt qu'une carte pleine largeur par tentative.
class _ShapeAttemptGrid extends StatelessWidget {
  final ShapeTopic topic;
  final int count;
  final int activeIdx;
  final Set<int> doneIndices;
  final ValueChanged<int> onAttemptDone;

  const _ShapeAttemptGrid({
    super.key,
    required this.topic,
    required this.count,
    required this.activeIdx,
    required this.doneIndices,
    required this.onAttemptDone,
  });

  @override
  Widget build(BuildContext context) {
    // Cases agrandies selon le réglage "Taille de l'interface" (Profil >
    // Réglages), comme `LetterRepetitionRow._effOccSize` — un peu plus
    // grandes que pour une lettre simple (110) car une figure a plusieurs
    // sommets/côtés à distinguer, tout en restant assez petites pour que
    // plusieurs tiennent par ligne (l'agencement visé), pas une seule.
    final occSize = 120 * context.watch<AccessibilitySettings>().uiScale;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AmaniColors.textPrimary.withValues(alpha: 0.1),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x144A3B2A),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 10.0;
          final perRow = ((constraints.maxWidth + spacing) / (occSize + spacing))
              .floor()
              .clamp(1, count == 0 ? 1 : count);
          final rows = (count / perRow).ceil();

          return SizedBox(
            width: constraints.maxWidth,
            child: CustomPaint(
              painter: _ShapeCahierLinesPainter(
                rows: rows,
                rowHeight: occSize,
                rowSpacing: spacing,
                lineScale: occSize / 200,
              ),
              child: Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (var i = 0; i < count; i++)
                    LetterTraceCell(
                      key: ValueKey('shape-rep-$i'),
                      letter: topic.traceData,
                      size: occSize,
                      isActive: i == activeIdx && !doneIndices.contains(i),
                      transparent: true,
                      strokeWidthScale: 0.55,
                      onSolved: i == activeIdx && !doneIndices.contains(i)
                          ? () => onAttemptDone(i)
                          : null,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Quadrillage Seyès décoratif derrière la grille — copie de
/// `_LetterCahierLinesPainter` (`letter_repetition_row.dart`), même choix de
/// duplication plutôt que de partager un widget privé entre fichiers.
class _ShapeCahierLinesPainter extends CustomPainter {
  static const List<double> _positions = [10, 70, 130, 190];

  final int rows;
  final double rowHeight;
  final double rowSpacing;
  final double lineScale;

  _ShapeCahierLinesPainter({
    required this.rows,
    required this.rowHeight,
    required this.rowSpacing,
    required this.lineScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final originDy = (rowHeight - 200 * lineScale) / 2;
    for (int r = 0; r < rows; r++) {
      final rowTop = r * (rowHeight + rowSpacing);
      for (int i = 0; i < _positions.length; i++) {
        final y = rowTop + originDy + _positions[i] * lineScale;
        final isBaseline = i == 2;
        final paint = Paint()
          ..color =
              (isBaseline ? const Color(0xFFE05252) : const Color(0xFF4A90E2))
                  .withValues(alpha: 0.5)
          ..strokeWidth = isBaseline ? 1.5 : 1;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ShapeCahierLinesPainter oldDelegate) =>
      oldDelegate.rows != rows ||
      oldDelegate.rowHeight != rowHeight ||
      oldDelegate.rowSpacing != rowSpacing ||
      oldDelegate.lineScale != lineScale;
}
