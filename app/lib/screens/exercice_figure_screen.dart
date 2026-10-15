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
import '../widgets/unbroken_text.dart';
import '../widgets/keep_alive_list.dart';

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
  List<ShapeCombinedProblem> _problems = const [];
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
      generateShapeCombinedProblem(topic, topic.id.hashCode ^ _restartKey),
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
                        child: UnbrokenText(
                          name,
                          style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CustomScrollView(
                    physics: tracingAwareScrollPhysics(context),
                    slivers: [
                      // Carte d'intro défilante : avec un grand texte (réglage
                      // "Taille de l'interface", police dyslexie), en-tête + carte
                      // fixes ne laissaient plus aucune place à l'exercice.
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                      ),
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
                                  delegate: keepAliveListDelegate([
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
                                      _CombinedProblemRow(
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

/// Ligne d'exercice combiné : l'enfant calcule à la fois le périmètre ET l'aire
/// de la figure. Chaque champ de réponse possède une icône calculette qui
/// déploie le clavier numérique à la demande.
class _CombinedProblemRow extends StatefulWidget {
  final ShapeCombinedProblem problem;
  final bool isActive;
  final bool isFuture;
  final bool done;
  final String doneLabel;
  final VoidCallback onDone;

  const _CombinedProblemRow({
    super.key,
    required this.problem,
    required this.isActive,
    required this.isFuture,
    required this.done,
    required this.doneLabel,
    required this.onDone,
  });

  @override
  State<_CombinedProblemRow> createState() => _CombinedProblemRowState();
}

class _CombinedProblemRowState extends State<_CombinedProblemRow> {
  bool _perimeterSolved = false;
  bool _areaSolved = false;
  // 'p' = keypad périmètre ouvert, 'a' = keypad aire ouvert, null = fermé
  String? _openField;

  @override
  void initState() {
    super.initState();
    if (widget.done) {
      _perimeterSolved = true;
      _areaSolved = true;
    }
  }

  void _onPerimeterSolved() {
    setState(() {
      _perimeterSolved = true;
      _openField = null;
    });
    if (_areaSolved) widget.onDone();
  }

  void _onAreaSolved() {
    setState(() {
      _areaSolved = true;
      _openField = null;
    });
    if (_perimeterSolved) widget.onDone();
  }

  void _toggle(String fieldId) {
    setState(() => _openField = _openField == fieldId ? null : fieldId);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().lang;
    final t = context.watch<LanguageProvider>().t;
    final ef = t['exerciceFigure'] as Map<String, dynamic>? ?? {};
    final cf = t['coursFigure'] as Map<String, dynamic>? ?? {};
    final statement = shapeCombinedStatement(widget.problem, lang.name);

    return Opacity(
      opacity: widget.isFuture ? 0.4 : 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête : énoncé
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
                if (widget.done)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      '✓ ${widget.doneLabel}',
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AmaniColors.secondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Schéma combiné (toutes dimensions)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ShapeCombinedDiagram(problem: widget.problem),
            ),
          ),

          // Indication d'arrondi pour le cercle
          if (widget.problem.isApproximate && !widget.done)
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

          const SizedBox(height: 10),

          // Champ périmètre
          _buildFieldCard(
            fieldId: 'p',
            labelSymbol: 'P',
            label: (cf['perimeterLabel'] ?? 'Périmètre').toString(),
            answer: widget.problem.perimeterAnswer,
            solved: _perimeterSolved,
            accentColor: const Color(0xFF1565C0),
            accentLight: const Color(0xFFE3F2FD),
            onSolved: _onPerimeterSolved,
          ),

          const SizedBox(height: 6),

          // Champ aire
          _buildFieldCard(
            fieldId: 'a',
            labelSymbol: 'A',
            label: (cf['areaLabel'] ?? 'Aire').toString(),
            answer: widget.problem.areaAnswer,
            solved: _areaSolved,
            accentColor: const Color(0xFF2E7D32),
            accentLight: const Color(0xFFE8F5E9),
            onSolved: _onAreaSolved,
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildFieldCard({
    required String fieldId,
    required String labelSymbol,
    required String label,
    required int answer,
    required bool solved,
    required Color accentColor,
    required Color accentLight,
    required VoidCallback onSolved,
  }) {
    final isOpen = _openField == fieldId && !solved;

    return Column(
      children: [
        // Carte principale
        GestureDetector(
          onTap: solved ? null : () => _toggle(fieldId),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: solved
                  ? accentLight
                  : isOpen
                  ? accentColor.withValues(alpha: 0.08)
                  : const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: solved
                    ? accentColor.withValues(alpha: 0.5)
                    : isOpen
                    ? accentColor.withValues(alpha: 0.4)
                    : const Color(0xFFE0E0E0),
                width: isOpen ? 2 : 1.5,
              ),
            ),
            child: Row(
              children: [
                // Badge symbole
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: solved
                        ? accentColor
                        : accentColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: solved
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 18,
                          )
                        : FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              labelSymbol,
                              style: TextStyle(
                                fontFamily: kBalooFontFamily,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                color: accentColor,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                // Label + valeur
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontFamily: kBalooFontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: AmaniColors.textSecondary,
                        ),
                      ),
                      if (solved)
                        Text(
                          '= $answer m',
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                            color: accentColor,
                          ),
                        )
                      else
                        Text(
                          '= ?',
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: AmaniColors.textPrimary.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Bouton calculatrice (uniquement si non résolu)
                if (!solved)
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isOpen
                          ? accentColor
                          : accentColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.calculator,
                      size: 20,
                      color: isOpen ? Colors.white : accentColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Clavier déployé sous la carte
        if (isOpen)
          Center(
            child: ShapeAnswerKeypad(
              key: ValueKey('kp-$fieldId-${widget.problem.shapeId}'),
              correctAnswer: answer,
              isActive: widget.isActive,
              isFuture: false,
              solved: false,
              onSolved: onSolved,
            ),
          ),
      ],
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
