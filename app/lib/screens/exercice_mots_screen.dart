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
import '../widgets/exercise_complete_popup.dart';
import '../widgets/evaluation_timer.dart';
import '../services/evaluation_session.dart';
import '../hooks/use_exercise_settings.dart';
import '../hooks/use_tracing_scroll_lock.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
    setState(() => _resumeOffer = null);
    final savedIdx = saved['currentSubjectIndex'] as int? ?? 0;
    if (savedIdx >= 0 && savedIdx < PALIER3_GROUPS.length) {
      final savedGroup = PALIER3_GROUPS[savedIdx];
      if (savedGroup.id != widget.groupId) {
        context.go('/exercice/mots/${savedGroup.id}?amaniEval=1');
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
    final allDone = _doneWords.length == wordsToShow.length;

    void onWordDone(String wordId) {
      setState(() => _doneWords.add(wordId));
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
                        onTap: () =>
                            context.go('/cours/mots/${widget.groupId}'),
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
                      const SizedBox(height: 14),

                      for (final word in wordsToShow) ...[
                        _WordTraceRow(
                          key: ValueKey('${word.id}-r$_restartKey'),
                          word: word,
                          lang: lang,
                          onSpeak: () =>
                              speech.speak(word.text(lang.name), lang),
                          done: _doneWords.contains(word.id),
                          onDone: () => onWordDone(word.id),
                          doneLabel: el['done'] ?? 'Terminé !',
                          repetitions: _settings.repetitions,
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
                onNext: nextGroup != null
                    ? () => context.go('/cours/mots/${nextGroup.id}')
                    : null,
                onRestart: () {
                  setState(() {
                    _doneWords.clear();
                    _restartKey++;
                    _awaitingRepeatCompletion = true;
                  });
                },
              ),
            if (_isEvaluation && session.expired)
              EvaluationCompleteOverlay(
                // Après Mots, le prochain palier dépend de la langue : les
                // Calculs (5) n'existent qu'en français, sinon on saute
                // directement aux Figures (6).
                onBack: () => context.go(
                  '/accueil?scrollToPalier=${lang == Lang.fr ? 5 : 6}',
                ),
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
                  'title': groupTitle,
                }),
                subtitle: ev['firstSubjectBody'] ?? '',
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
                  context.go(
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

    return Container(
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
          for (var rep = 0; rep < widget.repetitions; rep++) ...[
            if (rep > 0)
              Divider(
                height: 1,
                color: AmaniColors.textPrimary.withValues(alpha: 0.08),
              ),
            WordTraceAttempt(
              letters: letters,
              solved: _solvedByRep[rep],
              isActive: rep == _activeRep,
              isFuture: rep > _activeRep,
              onLetterSolved: (i) {
                setState(() {
                  _solvedByRep[rep].add(i);
                  if (_solvedByRep[rep].length == letters.length) {
                    if (rep + 1 < widget.repetitions) {
                      _activeRep = rep + 1;
                    } else {
                      widget.onDone();
                    }
                  }
                });
              },
            ),
          ],
        ],
      ),
    );
  }
}
