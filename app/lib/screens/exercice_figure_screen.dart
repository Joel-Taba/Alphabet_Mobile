import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/progress_service.dart';
import '../data/shape_catalog.dart';
import '../data/shape_calc_problem.dart';
import '../hooks/use_exercise_settings.dart';
import '../hooks/use_tracing_scroll_lock.dart';
import '../services/evaluation_session.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/shape_calc_diagram.dart';
import '../widgets/shape_answer_keypad.dart';
import '../widgets/exercise_complete_popup.dart';
import '../widgets/free_writing_sheet.dart';
import '../widgets/evaluation_timer.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../utils/navigation_helpers.dart';

/// Exercice du Palier "Figures géométriques" : un petit problème de calcul
/// (périmètre ou aire) par tentative, avec un schéma annoté donnant les
/// dimensions et un clavier numérique pour saisir la réponse — même
/// architecture "liste de problèmes séquentiels" que le Palier "Calculs"
/// (`exercice_calcul_screen.dart`), réutilisée ici pour les figures.
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
  List<ShapeCalcProblem> _problems = const [];
  int _restartKey = 0;
  bool _awaitingRepeatCompletion = false;

  bool get _isEvaluation => widget.amaniEval == '1';
  bool _showFirstSubjectAnnouncement = false;
  Map<String, dynamic>? _resumeOffer;

  late final EvaluationSessionController _session;

  @override
  void initState() {
    super.initState();
    _session = context.read<EvaluationSessionController>();
    _regenerate();
    if (_isEvaluation) _initEvaluation();
  }

  /// Un seul problème par page d'exercice (pas de réglage "Répétitions" pour
  /// ce palier) : `_problems` reste une liste à un seul élément uniquement
  /// pour réutiliser tel quel le reste de la logique (reprise d'évaluation,
  /// bonus de relance...), déjà écrite pour une liste.
  void _regenerate() {
    final topic = findShapeTopic(widget.shapeId);
    if (topic == null) return;
    _problems = [
      generateShapeCalcProblem(topic, topic.id.hashCode ^ _restartKey),
    ];
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
    setState(() {
      _resumeOffer = null;
      // Identifiants sauvegardés `'$shapeId-$index'` (voir `_onProblemDone`)
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
          _problems.isEmpty ? 0 : _problems.length - 1,
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
    super.dispose();
  }

  void _onProblemDone(int i) {
    setState(() {
      _doneIndices.add(i);
      if (i + 1 < _problems.length) {
        _activeIdx = i + 1;
      }
    });
    if (_isEvaluation) _session.recordItemDone('${widget.shapeId}-$i');
    // Une évaluation de fin de palier teste l'enfant : elle ne doit
    // jamais cocher à sa place les étapes du parcours qu'il n'a pas faites.
    if (!_isEvaluation) {
      context.read<ProgressProvider>().awardCompletion(
        typeEtape: 'FIGURE',
        modalite: 'EXERCICE',
        etapeCode: '${widget.shapeId}-$i',
        palier: 6,
      );
    }
    if (_doneIndices.length >= _problems.length && _awaitingRepeatCompletion) {
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
    final el = t['exerciceListe'] as Map<String, dynamic>? ?? {};
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
                  onTap: () => goHome(context),
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
                          child: DirectionalIcon(LucideIcons.house, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name,
                          style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
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
                ),
                Expanded(
                  child: CustomScrollView(
                    physics: tracingAwareScrollPhysics(context),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(12, 16, 12, 48),
                        // Une seule feuille de cahier pour toute la page,
                        // avec une séparation entre chaque problème — même
                        // traitement que le Palier "Calculs"
                        // (`exercice_calcul_screen.dart`).
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
                                      _ShapeCalcProblemRow(
                                        key: ValueKey(
                                          '${topic.id}-$i-r$_restartKey',
                                        ),
                                        problem: _problems[i],
                                        isActive: i == _activeIdx,
                                        isFuture: i > _activeIdx,
                                        done: _doneIndices.contains(i),
                                        doneLabel: el['done'] ?? 'Terminé !',
                                        onDone: () => _onProblemDone(i),
                                      ),
                                    ],
                                    // Espace libre en dessous de l'unique
                                    // exercice de la page, comme sur les
                                    // pages d'exercice des Paliers 1 à 4
                                    // (`exercice_lettre_screen.dart` et
                                    // consorts) -- jamais en évaluation
                                    // chronométrée.
                                    if (!_isEvaluation)
                                      const Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          12,
                                          20,
                                          12,
                                          8,
                                        ),
                                        child: FreeWritingSheet(),
                                      ),
                                  ]),
                                ),
                              ),
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: CustomPaint(
                                  painter: _TrailingFigureCahierLinesPainter(),
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
            if (allDone && !_isEvaluation)
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

/// Une ligne de la liste = un problème de calcul (périmètre ou aire) : énoncé
/// court, schéma annoté (`ShapeCalcDiagram`) et clavier de saisie
/// (`ShapeAnswerKeypad`) pour la ligne active uniquement — même agencement
/// que `_ProblemRow` dans `exercice_calcul_screen.dart` (Palier "Calculs").
class _ShapeCalcProblemRow extends StatelessWidget {
  final ShapeCalcProblem problem;
  final bool isActive;
  final bool isFuture;
  final bool done;
  final String doneLabel;
  final VoidCallback onDone;

  const _ShapeCalcProblemRow({
    super.key,
    required this.problem,
    required this.isActive,
    required this.isFuture,
    required this.done,
    required this.doneLabel,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().lang;
    final t = context.watch<LanguageProvider>().t;
    final ef = t['exerciceFigure'] as Map<String, dynamic>? ?? {};
    final statement = shapeCalcStatement(problem, lang.name);
    final question = problem.kind == ShapeCalcKind.perimeter
        ? (ef['calcPerimeterPrompt'] ?? '')
        : (ef['calcAreaPrompt'] ?? '');

    return Opacity(
      opacity: isFuture ? 0.4 : 1,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (statement.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            statement,
                            style: TextStyle(
                              fontFamily: kBalooFontFamily,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: AmaniColors.textPrimary,
                            ),
                          ),
                        ),
                      Text(
                        question,
                        style: TextStyle(
                          fontFamily: kBalooFontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AmaniColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (done)
                  Text(
                    '✓ $doneLabel',
                    style: TextStyle(
                      fontFamily: kBalooFontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AmaniColors.secondary,
                    ),
                  ),
              ],
            ),
          ),
          if (problem.isApproximate && !done)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                ef['roundedHint'] ?? '',
                style: TextStyle(
                  fontFamily: kBalooFontFamily,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: AmaniColors.textSecondary,
                ),
              ),
            ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ShapeCalcDiagram(problem: problem),
            ),
          ),
          if (!done)
            Center(
              child: ShapeAnswerKeypad(
                correctAnswer: problem.answer,
                isActive: isActive,
                isFuture: isFuture,
                solved: done,
                onSolved: onDone,
              ),
            ),
        ],
      ),
    );
  }
}

/// Prolonge visuellement la feuille de cahier partagée jusqu'en bas de la
/// page quand le contenu ne suffit pas à la remplir — copie de
/// `_TrailingCahierLinesPainter` (`exercice_calcul_screen.dart`).
class _TrailingFigureCahierLinesPainter extends CustomPainter {
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
  bool shouldRepaint(covariant _TrailingFigureCahierLinesPainter oldDelegate) =>
      false;
}
