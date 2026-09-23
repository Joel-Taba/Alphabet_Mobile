import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../data/word_catalog.dart';
import '../data/letter_style_resolver.dart';
import '../hooks/use_writing_style.dart';
import '../services/progress_service.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/word_trace_attempt.dart';
import '../widgets/word_cloze_attempt.dart';
import '../data/word_cloze.dart';
import '../widgets/exercise_complete_popup.dart';
import '../widgets/free_writing_sheet.dart';
import '../widgets/evaluation_timer.dart';
import '../services/evaluation_session.dart';
import '../hooks/use_accessibility_settings.dart';
import '../hooks/use_exercise_settings.dart';
import '../hooks/use_tracing_scroll_lock.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../utils/navigation_helpers.dart';

/// Exercice d'écriture des mots du Palier 3 : trace chaque lettre du mot dans
/// l'ordre. Port fidèle de `src/routes/exercice.mots.$groupId.tsx`.
class ExerciceMotsScreen extends StatefulWidget {
  final String groupId;
  final String? amaniEval;

  /// Id du mot ciblé par le bouton haltère (page de cours) : l'écran
  /// n'affiche alors que ce seul mot, au lieu de tout le groupe.
  final String? onlyWordId;

  const ExerciceMotsScreen({
    super.key,
    required this.groupId,
    this.amaniEval,
    this.onlyWordId,
  });

  @override
  State<ExerciceMotsScreen> createState() => _ExerciceMotsScreenState();
}

/// Identifiant fixe de cette évaluation (Palier "Les Mots") — voir
/// `EvaluationSessionController.ensureContext`.
const String _kEvalId = 'mots';

class _ExerciceMotsScreenState extends State<ExerciceMotsScreen> {
  final Set<String> _doneWords = {};
  int _restartKey = 0;
  bool _awaitingRepeatCompletion = false;

  /// `true` après "Continuer en mode libre" (voir [ExerciseCompletePopup]) :
  /// masque la pop-up de fin sans jamais toucher à `_doneWords` -- tous les
  /// mots restent acquis, seule la feuille d'écriture libre en bas de page
  /// reste praticable ensuite.
  bool _freeModeOnly = false;

  /// `true` après la toute première restauration de `_doneWords` depuis
  /// `ProgressProvider` (voir `build`) -- une seule fois, sans quoi elle se
  /// referait à chaque reconstruction et annulerait aussitôt le
  /// "Recommencer" explicite de `ExerciseCompletePopup` (voir le
  /// commentaire équivalent dans `exercice_liste_screen.dart`).
  bool _restoredFromProgress = false;

  /// `true` uniquement lorsque le dernier mot manquant du groupe vient
  /// d'être réussi PENDANT cette visite (voir `onWordDone`) -- jamais lors
  /// de la restauration ci-dessus. Sans cette distinction, rouvrir un
  /// groupe déjà entièrement réussi lors d'une visite précédente faisait
  /// immédiatement réapparaître la pop-up de félicitations (confettis
  /// compris), alors qu'aucun mot n'avait encore été tracé lors de CETTE
  /// visite.
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
    _settings.load();
    if (_isEvaluation) _initEvaluation();
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _initEvaluation() async {
    if (!mounted) return;
    final continuing = _session.ensureContext(_kEvalId);
    _session.configureSubjects(PALIER3_GROUPS.length);
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
      _doneWords
        ..clear()
        ..addAll(_session.completedItems);
    });
    final savedIdx = saved['currentSubjectIndex'] as int? ?? 0;
    if (savedIdx >= 0 && savedIdx < PALIER3_GROUPS.length) {
      final savedGroup = PALIER3_GROUPS[savedIdx];
      if (savedGroup.id != widget.groupId) {
        context.replace('/exercice/mots/${savedGroup.id}?amaniEval=1');
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
    final cm = t['coursMots'] as Map<String, dynamic>? ?? {};
    final em = t['exerciceMots'] as Map<String, dynamic>? ?? {};
    final el = t['exerciceListe'] as Map<String, dynamic>? ?? {};
    final ev = t['evaluation'] as Map<String, dynamic>? ?? {};
    final session = context.watch<EvaluationSessionController>();

    final group = PALIER3_GROUP_MAP[widget.groupId];
    final groupIdx = PALIER3_GROUPS.indexWhere((g) => g.id == widget.groupId);
    final nextGroup = groupIdx >= 0 && groupIdx < PALIER3_GROUPS.length - 1
        ? PALIER3_GROUPS[groupIdx + 1]
        : null;
    // En évaluation, une fois le dernier groupe atteint on reboucle sur le
    // premier — seul le chronomètre décide de la fin de la session.
    final evaluationNextGroup = _isEvaluation && groupIdx >= 0
        ? PALIER3_GROUPS[(groupIdx + 1) % PALIER3_GROUPS.length]
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
                  '"${widget.groupId}" ${cm['notFound'] ?? ''}',
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
                      cm['backToList'] ?? '',
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

    final groupTitle = group.title[lang.name] ?? '';
    final filteredWords = widget.onlyWordId != null
        ? group.words.where((w) => w.id == widget.onlyWordId).toList()
        : <WordEntry>[];
    final wordsToShow = filteredWords.isNotEmpty ? filteredWords : group.words;
    if (!_restoredFromProgress && !_isEvaluation && wordsToShow.isNotEmpty) {
      _restoredFromProgress = true;
      final progress = context.read<ProgressProvider>();
      for (final word in wordsToShow) {
        if (progress.isCompleted(
          typeEtape: 'MOT',
          modalite: 'EXERCICE',
          etapeCode: word.id,
        )) {
          _doneWords.add(word.id);
        }
      }
    }
    final allDone = _doneWords.length == wordsToShow.length;

    void onWordDone(String wordId) {
      setState(() {
        _doneWords.add(wordId);
        if (_doneWords.length >= wordsToShow.length) {
          _justCompletedThisVisit = true;
        }
      });
      if (_isEvaluation) _session.recordItemDone(wordId);
      context.read<ProgressProvider>().awardCompletion(
        typeEtape: 'MOT',
        modalite: 'EXERCICE',
        etapeCode: wordId,
        palier: lang == Lang.fr ? 4 : 3,
      );
      if (_doneWords.length >= wordsToShow.length &&
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
                              groupTitle,
                              style: AmaniTheme.titleStyle.copyWith(
                                fontSize: 22,
                              ),
                            ),
                            Text(
                              tFormat(em['wordsReady'] ?? '', {
                                'done': _doneWords.length,
                                'total': wordsToShow.length,
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
                                    ? (em['allDoneTitle'] ?? '')
                                    : (em['introTitle'] ?? ''),
                                style: AmaniTheme.titleStyle.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                allDone
                                    ? (em['allDoneBody'] ?? '')
                                    : (em['introBody'] ?? ''),
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
                        // avec une séparation entre chaque mot — même
                        // traitement qu'aux Paliers 1, 2 et 3 (voir
                        // `exercice_liste_screen.dart`,
                        // `exercice_lettre_screen.dart`,
                        // `exercice_syllabes_screen.dart`).
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
                                      int wi = 0;
                                      wi < wordsToShow.length;
                                      wi++
                                    ) ...[
                                      if (wi > 0)
                                        Divider(
                                          height: 1,
                                          color: AmaniColors.textPrimary
                                              .withValues(alpha: 0.1),
                                        ),
                                      if (_isEvaluation ||
                                          kClozeGroupIds.contains(
                                            widget.groupId,
                                          ))
                                        _WordClozeRow(
                                          key: ValueKey(
                                            '${wordsToShow[wi].id}-r$_restartKey',
                                          ),
                                          word: wordsToShow[wi],
                                          group: group,
                                          lang: lang,
                                          onSpeak: () => speech.speak(
                                            wordsToShow[wi].spokenText(
                                              lang.name,
                                            ),
                                            lang,
                                          ),
                                          done: _doneWords.contains(
                                            wordsToShow[wi].id,
                                          ),
                                          onDone: () =>
                                              onWordDone(wordsToShow[wi].id),
                                          doneLabel: el['done'] ?? 'Terminé !',
                                          instruction:
                                              em['clozeInstruction'] ?? '',
                                        )
                                      else
                                        _WordTraceRow(
                                          key: ValueKey(
                                            '${wordsToShow[wi].id}-r$_restartKey',
                                          ),
                                          word: wordsToShow[wi],
                                          lang: lang,
                                          onSpeak: () => speech.speak(
                                            wordsToShow[wi].spokenText(
                                              lang.name,
                                            ),
                                            lang,
                                          ),
                                          done: _doneWords.contains(
                                            wordsToShow[wi].id,
                                          ),
                                          onDone: () =>
                                              onWordDone(wordsToShow[wi].id),
                                          doneLabel: el['done'] ?? 'Terminé !',
                                          repetitions: _settings.repetitions,
                                        ),
                                    ],
                                    // Jamais de feuille d'écriture libre sur
                                    // une page d'évaluation chronométrée
                                    // (voir `_isEvaluation`) -- le temps
                                    // imparti ne doit servir qu'au sujet
                                    // évalué.
                                    if (!_isEvaluation)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
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
            if (allDone && _justCompletedThisVisit && !_isEvaluation && !_freeModeOnly)
              ExerciseCompletePopup(
                onBackHome: () => goHome(context),
                onNext: nextGroup != null
                    ? () => context.replace('/cours/mots/${nextGroup.id}')
                    : null,
                onRestart: () {
                  setState(() {
                    _doneWords.clear();
                    _justCompletedThisVisit = false;
                    _restartKey++;
                    _awaitingRepeatCompletion = true;
                    _freeModeOnly = false;
                  });
                },
                onFreeMode: () => setState(() => _freeModeOnly = true),
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
                title: tFormat(ev['firstSubjectTitle'] ?? '', {
                  'title': groupTitle,
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
                  'title': evaluationNextGroup.title[lang.name] ?? '',
                }),
                onContinue: () {
                  session.advanceSubject((groupIdx + 1) % PALIER3_GROUPS.length);
                  context.replace(
                    '/exercice/mots/${evaluationNextGroup.id}?amaniEval=1',
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _WordTraceRow extends StatefulWidget {
  final WordEntry word;
  final Lang lang;
  final VoidCallback onSpeak;
  final bool done;
  final VoidCallback onDone;
  final String doneLabel;
  final int repetitions;

  const _WordTraceRow({
    super.key,
    required this.word,
    required this.lang,
    required this.onSpeak,
    required this.done,
    required this.onDone,
    required this.doneLabel,
    required this.repetitions,
  });

  @override
  State<_WordTraceRow> createState() => _WordTraceRowState();
}

class _WordTraceRowState extends State<_WordTraceRow> {
  late List<Set<int>> _solvedByRep;
  int _activeRep = 0;

  // Taille de lettre pour la grille de répétitions horizontale — voir
  // `_SyllableTraceRow._letterCellSize` (`exercice_syllabes_screen.dart`),
  // même convention.
  static const double _letterCellSize = 62;
  static const double _repSpacingApart = 8;
  // Espace blanc VISIBLE entre l'encre de deux lettres voisines, en pixels
  // écran (l'épaisseur du trait est déjà déduite par `WordTraceAttempt`).
  // Positif, contrairement au Palier "Syllabes" volontairement chevauché
  // pour ne former qu'une seule unité de 2 lettres : un mot compte
  // davantage de lettres et doit se lire comme une suite de lettres bien
  // liées mais chacune clairement distincte. Une valeur de 2 avait été
  // essayée avant que l'épaisseur du trait ne soit prise en compte : elle
  // correspondait en fait à un CHEVAUCHEMENT de 5 px, d'où le contact
  // signalé entre le « u » et le « p » de « loup ».
  static const double _repDesiredInkGap = 7;

  @override
  void initState() {
    super.initState();
    _resetReps();
  }

  @override
  void didUpdateWidget(covariant _WordTraceRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.repetitions != widget.repetitions ||
        oldWidget.word.id != widget.word.id) {
      setState(_resetReps);
    }
  }

  void _resetReps() {
    if (widget.done) {
      final n = widget.word.text(widget.lang.name).length;
      _solvedByRep = List.generate(
        widget.repetitions,
        (_) => Set<int>.of(List.generate(n, (i) => i)),
      );
      _activeRep = widget.repetitions;
      return;
    }
    _solvedByRep = List.generate(widget.repetitions, (_) => <int>{});
    _activeRep = 0;
  }

  @override
  Widget build(BuildContext context) {
    final style = context.watch<WritingStyleProvider>().style.name;
    final text = widget.word.text(widget.lang.name);
    final letters = text
        .split('')
        .map((c) => getLetterFormation(c, style))
        .whereType<dynamic>()
        .toList();
    final n = letters.length;
    // Largeur exacte pour les `n` lettres du mot sur une seule ligne — voir
    // `_SyllableTraceRow` pour le détail du calcul (échelle "Taille de
    // l'interface" + padding interne de `WordTraceAttempt`).
    final uiScale = context.watch<AccessibilitySettings>().uiScale;
    final effLetterCellSize = _letterCellSize * uiScale;
    final cellContentWidth =
        effLetterCellSize * n +
        _repSpacingApart * (n > 0 ? n - 1 : 0) +
        24;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête — simple filet de séparation, la feuille de cahier
        // partagée (voir `_ExerciceMotsScreenState.build`) fournit déjà
        // fond/bordure/ombre à l'échelle de toute la page.
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
                  text,
                  style: TextStyle(
                    fontFamily: kBalooFontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
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
          // délimite clairement le début et la fin d'une itération du mot.
          // Un unique quadrillage Seyès peint sur TOUTE la largeur
          // disponible derrière la grille (voir `showOwnGridLines: false`
          // ci-dessous) — jamais un quadrillage propre à chaque case, qui
          // s'arrêterait à sa largeur au lieu de couvrir toute la feuille de
          // cahier, comme au Palier 1 (`RepetitionRow`).
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Plus espacé qu'aux autres paliers (10 ailleurs) : un mot
              // compte plusieurs lettres consécutives, contrairement à un
              // signe ou une syllabe isolée — sans un vide net entre deux
              // occurrences, l'œil peine à voir où l'une finit et où la
              // suivante commence.
              const spacing = 20.0;
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
                  painter: _WordCahierLinesPainter(
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
                              color: _solvedByRep[rep].length == n
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
                                  if (_solvedByRep[rep].length == n) {
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

/// Rangée d'exercice "à trous" pour un mot : une lettre manquante à
/// glisser-déposer depuis une pioche de jetons, plutôt que le tracé lettre
/// par lettre de `_WordTraceRow`. Utilisée pour les groupes listés dans
/// `kClozeGroupIds`, et pour TOUS les groupes pendant l'évaluation
/// chronométrée (voir le branchement dans `build`, ci-dessus). Un seul
/// essai par mot, pas de répétitions.
class _WordClozeRow extends StatelessWidget {
  final WordEntry word;
  final WordGroup group;
  final Lang lang;
  final VoidCallback onSpeak;
  final bool done;
  final VoidCallback onDone;
  final String doneLabel;
  final String instruction;

  const _WordClozeRow({
    super.key,
    required this.word,
    required this.group,
    required this.lang,
    required this.onSpeak,
    required this.done,
    required this.onDone,
    required this.doneLabel,
    required this.instruction,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.watch<WritingStyleProvider>().style.name;
    final text = word.text(lang.name);
    final spec = buildWordCloze(word, lang.name, group);

    return Column(
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
                  text,
                  style: TextStyle(
                    fontFamily: kBalooFontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AmaniColors.textPrimary,
                  ),
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
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onSpeak,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (instruction.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    instruction,
                    style: TextStyle(
                      fontFamily: kBalooFontFamily,
                      fontSize: 13,
                      color: AmaniColors.textSecondary,
                    ),
                  ),
                ),
              WordClozeAttempt(
                spec: spec,
                style: style,
                onSolved: onDone,
                initiallyDone: done,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Quadrillage Seyès partagé derrière toute la grille de répétitions d'un
/// mot — copie de `_LetterCahierLinesPainter` (`letter_repetition_row.dart`),
/// même formule de centrage (`originDy`) puisque `WordTraceAttempt` utilise
/// le même padding interne de 12 de chaque côté.
class _WordCahierLinesPainter extends CustomPainter {
  static const List<double> _positions = [10, 70, 130, 190];

  final int rows;
  final double rowHeight;
  final double rowSpacing;
  final double lineScale;

  _WordCahierLinesPainter({
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
  bool shouldRepaint(covariant _WordCahierLinesPainter oldDelegate) =>
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
