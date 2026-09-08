import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../data/syllable_catalog.dart';
import '../data/letter_style_resolver.dart';
import '../hooks/use_writing_style.dart';
import '../services/progress_service.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/word_trace_attempt.dart';
import '../widgets/exercise_complete_popup.dart';
import '../widgets/evaluation_timer.dart';
import '../services/evaluation_session.dart';
import '../hooks/use_accessibility_settings.dart';
import '../hooks/use_exercise_settings.dart';
import '../hooks/use_tracing_scroll_lock.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Exercice d'écriture des syllabes : trace la consonne puis la voyelle pour
/// former chaque syllabe. Port fidèle de
/// `src/routes/exercice.syllabes.$consonant.tsx`.
class ExerciceSyllabesScreen extends StatefulWidget {
  final String consonant;
  final String? amaniEval;
  const ExerciceSyllabesScreen({
    super.key,
    required this.consonant,
    this.amaniEval,
  });

  @override
  State<ExerciceSyllabesScreen> createState() => _ExerciceSyllabesScreenState();
}

/// Identifiant fixe de cette évaluation (Palier "Les Syllabes") — voir
/// `EvaluationSessionController.ensureContext`.
const String _kEvalId = 'syllabes';

class _ExerciceSyllabesScreenState extends State<ExerciceSyllabesScreen> {
  final Set<String> _doneSyllables = {};
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
    _settings.load();
    if (_isEvaluation) _initEvaluation();
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _initEvaluation() async {
    if (!mounted) return;
    final continuing = _session.ensureContext(_kEvalId);
    _session.configureSubjects(SYLLABLE_GROUPS.length);
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
      _doneSyllables
        ..clear()
        ..addAll(_session.completedItems);
    });
    final savedIdx = saved['currentSubjectIndex'] as int? ?? 0;
    if (savedIdx >= 0 && savedIdx < SYLLABLE_GROUPS.length) {
      final savedConsonant =
          (SYLLABLE_GROUPS[savedIdx] as Map<String, dynamic>)['consonant']
              as String;
      if (savedConsonant != widget.consonant) {
        context.go('/exercice/syllabes/$savedConsonant?amaniEval=1');
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

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final lang = context.watch<LanguageProvider>().lang;
    final speech = context.read<SignSpeechService>();
    final cs = t['coursSyllabes'] as Map<String, dynamic>? ?? {};
    final es = t['exerciceSyllabes'] as Map<String, dynamic>? ?? {};
    final el = t['exerciceListe'] as Map<String, dynamic>? ?? {};
    final ev = t['evaluation'] as Map<String, dynamic>? ?? {};
    final session = context.watch<EvaluationSessionController>();

    final group = findSyllableGroupForConsonant(widget.consonant);
    final groupIdx = SYLLABLE_GROUPS.indexWhere(
      (g) => g['consonant'] == widget.consonant,
    );
    final nextGroup = groupIdx >= 0 && groupIdx < SYLLABLE_GROUPS.length - 1
        ? SYLLABLE_GROUPS[groupIdx + 1] as Map<String, dynamic>
        : null;
    // En évaluation, une fois la dernière consonne atteinte on reboucle sur
    // la première — seul le chronomètre décide de la fin de la session.
    final evaluationNextGroup = _isEvaluation && groupIdx >= 0
        ? SYLLABLE_GROUPS[(groupIdx + 1) % SYLLABLE_GROUPS.length]
              as Map<String, dynamic>
        : null;

    if (group == null) {
      return Scaffold(
        backgroundColor: AmaniColors.background,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '"${widget.consonant}" ${cs['notFound'] ?? ''}',
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
                      cs['backToList'] ?? '',
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

    final syllables = group['syllables'] as List;
    final allDone = _doneSyllables.length == syllables.length;

    void onSyllableDone(String syllable) {
      setState(() => _doneSyllables.add(syllable));
      if (_isEvaluation) _session.recordItemDone(syllable);
      context.read<ProgressProvider>().awardCompletion(
        typeEtape: 'SYLLABE',
        modalite: 'EXERCICE',
        etapeCode: syllable,
        palier: 3,
      );
      if (_doneSyllables.length >= syllables.length &&
          _awaitingRepeatCompletion) {
        context.read<ProgressProvider>().awardRestartBonus();
        setState(() => _awaitingRepeatCompletion = false);
      }
    }

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
                            context.go('/cours/syllabes/${widget.consonant}'),
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
                              tFormat(cs['consonantTitle'] ?? '', {
                                'consonant': '"${widget.consonant}"',
                              }),
                              style: AmaniTheme.titleStyle.copyWith(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              tFormat(es['syllablesReady'] ?? '', {
                                'done': _doneSyllables.length,
                                'total': syllables.length,
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
                                    ? (es['allDoneTitle'] ?? '')
                                    : (es['introTitle'] ?? ''),
                                style: AmaniTheme.titleStyle.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                allDone
                                    ? (es['allDoneBody'] ?? '')
                                    : (es['introBody'] ?? ''),
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
                        // avec une séparation entre chaque syllabe — même
                        // traitement qu'aux Paliers 1 et 2 (voir
                        // `exercice_liste_screen.dart`/`exercice_lettre_screen.dart`).
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
                                      int gi = 0;
                                      gi < syllables.length;
                                      gi++
                                    ) ...[
                                      if (gi > 0)
                                        Divider(
                                          height: 1,
                                          color: AmaniColors.textPrimary
                                              .withValues(alpha: 0.1),
                                        ),
                                      _SyllableTraceRow(
                                        key: ValueKey(
                                          '${syllables[gi]['syllable']}-r$_restartKey',
                                        ),
                                        entry:
                                            syllables[gi]
                                                as Map<String, dynamic>,
                                        onSpeak: () => speech.speak(
                                          syllables[gi]['syllable'] as String,
                                          lang,
                                        ),
                                        done: _doneSyllables.contains(
                                          syllables[gi]['syllable'] as String,
                                        ),
                                        onDone: () => onSyllableDone(
                                          syllables[gi]['syllable'] as String,
                                        ),
                                        doneLabel: el['done'] ?? 'Terminé !',
                                        exampleWordPrefix:
                                            es['exampleWordPrefix'] ?? '',
                                        repetitions: _settings.repetitions,
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
            if (allDone && !_isEvaluation)
              ExerciseCompletePopup(
                onBackHome: () => context.go('/accueil'),
                onNext: nextGroup != null
                    ? () => context.go(
                        '/cours/syllabes/${nextGroup['consonant']}',
                      )
                    : null,
                onRestart: () {
                  setState(() {
                    _doneSyllables.clear();
                    _restartKey++;
                    _awaitingRepeatCompletion = true;
                  });
                },
              ),
            if (_isEvaluation && session.expired)
              EvaluationCompleteOverlay(
                onBack: () => context.go('/accueil?scrollToPalier=4'),
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
                  'title': widget.consonant,
                }),
                subtitle: ev['firstSubjectBody'] ?? '',
                continueLabel: ev['startFirstSubject'],
                onContinue: _handleStartFirstSubject,
              ),
            if (allDone &&
                _isEvaluation &&
                evaluationNextGroup != null &&
                !session.expired)
              EvaluationSubjectAnnouncement(
                title: ev['nextSubjectTitle'] ?? '',
                subtitle: tFormat(ev['nextSubjectBody'] ?? '', {
                  'title': evaluationNextGroup['consonant'],
                }),
                onContinue: () {
                  session.advanceSubject((groupIdx + 1) % SYLLABLE_GROUPS.length);
                  context.go(
                    '/exercice/syllabes/${evaluationNextGroup['consonant']}?amaniEval=1',
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _SyllableTraceRow extends StatefulWidget {
  final Map<String, dynamic> entry;
  final VoidCallback onSpeak;
  final bool done;
  final VoidCallback onDone;
  final String doneLabel;
  final String exampleWordPrefix;
  final int repetitions;

  const _SyllableTraceRow({
    super.key,
    required this.entry,
    required this.onSpeak,
    required this.done,
    required this.onDone,
    required this.doneLabel,
    required this.exampleWordPrefix,
    required this.repetitions,
  });

  @override
  State<_SyllableTraceRow> createState() => _SyllableTraceRowState();
}

class _SyllableTraceRowState extends State<_SyllableTraceRow> {
  late List<Set<int>> _solvedByRep;
  int _activeRep = 0;

  // Case de répétition volontairement petite : les 2 lettres d'une syllabe
  // sont resserrées (voir `_spacingApart`/`_desiredInkGap` ci-dessous) pour
  // se lire comme une seule unité, pas comme un mot en cours d'assemblage.
  static const double _letterCellSize = 62;
  static const double _repSpacingApart = 2;
  // Léger chevauchement volontaire (négatif) plutôt qu'un simple contact
  // (0) : la case active passe toujours au-dessus de sa voisine à l'écran
  // (voir `WordTraceAttempt.build`, tri par z-order), donc le tracé n'en
  // souffre jamais, même chevauchées. Volontairement modeste : au-delà, les
  // traits des deux lettres commenceraient à se confondre visuellement l'un
  // dans l'autre, ce qui nuirait à la lisibilité plutôt qu'au tracé
  // lui-même — la vraie limite n'est donc pas technique mais visuelle.
  static const double _repDesiredInkGap = -3;

  @override
  void initState() {
    super.initState();
    _resetReps();
  }

  @override
  void didUpdateWidget(covariant _SyllableTraceRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.repetitions != widget.repetitions ||
        oldWidget.entry['syllable'] != widget.entry['syllable']) {
      setState(_resetReps);
    }
  }

  void _resetReps() {
    _solvedByRep = List.generate(widget.repetitions, (_) => <int>{});
    _activeRep = 0;
  }

  @override
  Widget build(BuildContext context) {
    final style = context.watch<WritingStyleProvider>().style.name;
    final syllable = widget.entry['syllable'] as String;
    final letters = syllable
        .split('')
        .map((c) => getLetterFormation(c, style))
        .whereType<dynamic>()
        .toList();
    // Largeur exacte pour les 2 lettres d'une syllabe, resserrées — voir
    // `_letterCellSize`/`_repSpacingApart` ci-dessus. `WordTraceAttempt`
    // multiplie sa taille de case par le réglage "Taille de l'interface"
    // (défaut 1.4, voir `AccessibilitySettings.uiScale`) : cette largeur
    // doit suivre la même échelle, sous peine de ne plus laisser assez de
    // place pour les 2 lettres sur une seule ligne (empilées verticalement
    // à la place). +24 pour le padding interne de `WordTraceAttempt`
    // (`EdgeInsets.all(12)`, de chaque côté).
    final uiScale = context.watch<AccessibilitySettings>().uiScale;
    final effLetterCellSize = _letterCellSize * uiScale;
    final cellContentWidth =
        effLetterCellSize * 2 + _repSpacingApart + 24;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête — simple filet de séparation, la feuille de cahier
        // partagée (voir `_buildBody` plus bas) fournit déjà fond/bordure/
        // ombre à l'échelle de toute la page.
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      syllable,
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AmaniColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '${widget.exampleWordPrefix} « ${widget.entry['exampleWord']} »',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: kBalooFontFamily,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          color: AmaniColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
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
                onTap: widget.onSpeak,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0x264A90E2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.volume2,
                    size: 14,
                    color: Color(0xFF2D6BBF),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          // Répétitions agencées horizontalement, comme les cases de
          // répétition des signes (`RepetitionRow`) — chaque case bordée
          // délimite clairement le début et la fin d'une itération de la
          // syllabe. Un unique quadrillage Seyès peint sur TOUTE la largeur
          // disponible derrière la grille (voir `showOwnGridLines: false`
          // ci-dessous) — jamais un quadrillage propre à chaque case, qui
          // s'arrêterait à sa largeur au lieu de couvrir toute la feuille de
          // cahier, comme au Palier 1 (`RepetitionRow`).
          child: LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 10.0;
              final rowHeight = effLetterCellSize + 24;
              final perRow =
                  ((constraints.maxWidth + spacing) /
                          (cellContentWidth + spacing))
                      .floor()
                      .clamp(1, widget.repetitions == 0 ? 1 : widget.repetitions);
              final rows = (widget.repetitions / perRow).ceil();

              return SizedBox(
                width: constraints.maxWidth,
                child: CustomPaint(
                  painter: _SyllableCahierLinesPainter(
                    rows: rows,
                    rowHeight: rowHeight,
                    rowSpacing: spacing,
                    lineScale: effLetterCellSize / 200,
                  ),
                  child: Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      for (var rep = 0; rep < widget.repetitions; rep++)
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _solvedByRep[rep].length == letters.length
                                  ? AmaniColors.secondary.withValues(
                                      alpha: 0.6,
                                    )
                                  : rep == _activeRep
                                  ? const Color(0x40A9784F)
                                  : const Color(0x1A4A3B2A),
                            ),
                          ),
                          child: SizedBox(
                            width: cellContentWidth,
                            child: WordTraceAttempt(
                              letters: letters,
                              cellSize: _letterCellSize,
                              spacingApart: _repSpacingApart,
                              desiredInkGap: _repDesiredInkGap,
                              transparent: true,
                              showOwnGridLines: false,
                              showLetterBorders: false,
                              alwaysTight: true,
                              solved: _solvedByRep[rep],
                              isActive: rep == _activeRep,
                              isFuture: rep > _activeRep,
                              onLetterSolved: (i) {
                                setState(() {
                                  _solvedByRep[rep].add(i);
                                  if (_solvedByRep[rep].length ==
                                      letters.length) {
                                    if (rep + 1 < widget.repetitions) {
                                      _activeRep = rep + 1;
                                    } else {
                                      widget.onDone();
                                    }
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Quadrillage Seyès partagé derrière toute la grille de répétitions d'une
/// syllabe — copie de `_LetterCahierLinesPainter`
/// (`letter_repetition_row.dart`), même formule de centrage (`originDy`)
/// puisque `WordTraceAttempt` utilise le même padding interne de 12 de
/// chaque côté.
class _SyllableCahierLinesPainter extends CustomPainter {
  static const List<double> _positions = [10, 70, 130, 190];

  final int rows;
  final double rowHeight;
  final double rowSpacing;
  final double lineScale;

  _SyllableCahierLinesPainter({
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
  bool shouldRepaint(covariant _SyllableCahierLinesPainter oldDelegate) =>
      oldDelegate.rows != rows ||
      oldDelegate.rowHeight != rowHeight ||
      oldDelegate.rowSpacing != rowSpacing ||
      oldDelegate.lineScale != lineScale;
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
