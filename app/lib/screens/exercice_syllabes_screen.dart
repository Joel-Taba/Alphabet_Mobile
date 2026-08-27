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
import '../hooks/use_countdown.dart';
import '../hooks/use_exercise_settings.dart';
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

class _ExerciceSyllabesScreenState extends State<ExerciceSyllabesScreen> {
  final Set<String> _doneSyllables = {};
  int _restartKey = 0;
  bool _awaitingRepeatCompletion = false;

  bool get _isEvaluation => widget.amaniEval == '1';
  CountdownController? _countdown;
  bool _evaluationExpired = false;

  late final ExerciseSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = ExerciseSettings()..addListener(_onSettingsChanged);
    _settings.load();
    if (_isEvaluation) _initEvaluation();
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
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

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final lang = context.watch<LanguageProvider>().lang;
    final speech = context.read<SignSpeechService>();
    final cs = t['coursSyllabes'] as Map<String, dynamic>? ?? {};
    final es = t['exerciceSyllabes'] as Map<String, dynamic>? ?? {};
    final el = t['exerciceListe'] as Map<String, dynamic>? ?? {};

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
                          child: DirectionalIcon(LucideIcons.arrowLeft,
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
                      const SizedBox(height: 14),

                      for (final syllable in syllables) ...[
                        _SyllableTraceRow(
                          key: ValueKey(
                            '${syllable['syllable']}-r$_restartKey',
                          ),
                          entry: syllable as Map<String, dynamic>,
                          onSpeak: () => speech.speak(
                            syllable['syllable'] as String,
                            lang,
                          ),
                          done: _doneSyllables.contains(
                            syllable['syllable'] as String,
                          ),
                          onDone: () =>
                              onSyllableDone(syllable['syllable'] as String),
                          doneLabel: el['done'] ?? 'Terminé !',
                          exampleWordPrefix: es['exampleWordPrefix'] ?? '',
                          repetitions: _settings.repetitions,
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (allDone &&
                          _isEvaluation &&
                          evaluationNextGroup != null)
                        GestureDetector(
                          onTap: () => context.go(
                            '/exercice/syllabes/${evaluationNextGroup['consonant']}?amaniEval=1',
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A90E2),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x334A90E2),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  tFormat(es['nextGroup'] ?? '', {
                                    'consonant':
                                        evaluationNextGroup['consonant'],
                                  }),
                                  style: TextStyle(
                                    fontFamily: kBalooFontFamily,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                DirectionalIcon(LucideIcons.chevronRight,
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
            if (_isEvaluation && _evaluationExpired)
              EvaluationCompleteOverlay(onBack: () => context.go('/accueil')),
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
          for (var rep = 0; rep < widget.repetitions; rep++) ...[
            if (rep > 0)
              Divider(
                height: 1,
                color: AmaniColors.textPrimary.withValues(alpha: 0.08),
              ),
            WordTraceAttempt(
              letters: letters,
              cellSize: 72,
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
