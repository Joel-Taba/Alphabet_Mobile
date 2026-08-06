import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../data/syllable_catalog.dart';
import '../data/letter_style_resolver.dart';
import '../hooks/use_writing_style.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/letter_trace_cell.dart';

/// Exercice d'écriture des syllabes : trace la consonne puis la voyelle pour
/// former chaque syllabe. Port fidèle de
/// `src/routes/exercice.syllabes.$consonant.tsx`.
class ExerciceSyllabesScreen extends StatefulWidget {
  final String consonant;
  const ExerciceSyllabesScreen({super.key, required this.consonant});

  @override
  State<ExerciceSyllabesScreen> createState() => _ExerciceSyllabesScreenState();
}

class _ExerciceSyllabesScreenState extends State<ExerciceSyllabesScreen> {
  final Set<String> _doneSyllables = {};

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

    return Scaffold(
      backgroundColor: AmaniColors.background,
      body: SafeArea(
        child: Column(
          children: [
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
                          BoxShadow(color: Color(0x1F000000), blurRadius: 6),
                        ],
                      ),
                      child: const Icon(CupertinoIcons.arrow_left, size: 20),
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
                          style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
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
                  const SizedBox(height: 14),

                  for (final syllable in syllables) ...[
                    _SyllableTraceRow(
                      entry: syllable as Map<String, dynamic>,
                      onSpeak: () =>
                          speech.speak(syllable['syllable'] as String, lang),
                      done: _doneSyllables.contains(
                        syllable['syllable'] as String,
                      ),
                      onDone: () => setState(
                        () =>
                            _doneSyllables.add(syllable['syllable'] as String),
                      ),
                      doneLabel: el['done'] ?? 'Terminé !',
                      exampleWordPrefix: es['exampleWordPrefix'] ?? '',
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (allDone && nextGroup != null)
                    GestureDetector(
                      onTap: () => context.go(
                        '/cours/syllabes/${nextGroup['consonant']}',
                      ),
                      child: Container(
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
                            Flexible(
                              child: Text(
                                tFormat(es['nextGroup'] ?? '', {
                                  'consonant': nextGroup['consonant'],
                                }),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: kBalooFontFamily,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              CupertinoIcons.chevron_right,
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

  const _SyllableTraceRow({
    required this.entry,
    required this.onSpeak,
    required this.done,
    required this.onDone,
    required this.doneLabel,
    required this.exampleWordPrefix,
  });

  @override
  State<_SyllableTraceRow> createState() => _SyllableTraceRowState();
}

class _SyllableTraceRowState extends State<_SyllableTraceRow> {
  final Set<int> _solvedIdx = {};

  @override
  Widget build(BuildContext context) {
    final style = context.watch<WritingStyleProvider>().style.name;
    final syllable = widget.entry['syllable'] as String;
    final letters = syllable
        .split('')
        .map((c) => getLetterFormation(c, style))
        .whereType<dynamic>()
        .toList();
    var activeIdx = -1;
    for (var i = 0; i < letters.length; i++) {
      if (!_solvedIdx.contains(i)) {
        activeIdx = i;
        break;
      }
    }

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
                      CupertinoIcons.speaker_2_fill,
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
            child: Row(
              children: [
                for (var i = 0; i < letters.length; i++) ...[
                  LetterTraceCell(
                    letter: letters[i],
                    size: 72,
                    isActive: i == activeIdx,
                    onSolved: () {
                      setState(() => _solvedIdx.add(i));
                      if (_solvedIdx.length == letters.length) {
                        widget.onDone();
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
