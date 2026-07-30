import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../data/word_catalog.dart';
import '../data/letter_formation_catalog.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/letter_trace_cell.dart';

/// Exercice d'écriture des mots du Palier 3 : trace chaque lettre du mot dans
/// l'ordre. Port fidèle de `src/routes/exercice.mots.$groupId.tsx`.
class ExerciceMotsScreen extends StatefulWidget {
  final String groupId;
  const ExerciceMotsScreen({super.key, required this.groupId});

  @override
  State<ExerciceMotsScreen> createState() => _ExerciceMotsScreenState();
}

class _ExerciceMotsScreenState extends State<ExerciceMotsScreen> {
  final Set<String> _doneWords = {};

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final lang = context.watch<LanguageProvider>().lang;
    final speech = context.read<SignSpeechService>();
    final cm = t['coursMots'] as Map<String, dynamic>? ?? {};
    final em = t['exerciceMots'] as Map<String, dynamic>? ?? {};
    final el = t['exerciceListe'] as Map<String, dynamic>? ?? {};

    final group = PALIER3_GROUP_MAP[widget.groupId];
    final groupIdx = PALIER3_GROUPS.indexWhere((g) => g.id == widget.groupId);
    final nextGroup = groupIdx >= 0 && groupIdx < PALIER3_GROUPS.length - 1 ? PALIER3_GROUPS[groupIdx + 1] : null;

    if (group == null) {
      return Scaffold(
        backgroundColor: AmaniColors.background,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('"${widget.groupId}" ${cm['notFound'] ?? ''}', style: AmaniTheme.titleStyle.copyWith(fontSize: 18)),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => context.go('/accueil'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(color: AmaniColors.secondary, borderRadius: BorderRadius.circular(999)),
                    child: Text(cm['backToList'] ?? '', style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final groupTitle = group.title[lang.name] ?? '';
    final allDone = _doneWords.length == group.words.length;

    return Scaffold(
      backgroundColor: AmaniColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              decoration: BoxDecoration(color: AmaniColors.background, border: Border(bottom: BorderSide(color: AmaniColors.textPrimary.withValues(alpha: 0.1)))),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/cours/mots/${widget.groupId}'),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(color: AmaniColors.surface, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Color(0x1F000000), blurRadius: 6)]),
                      child: const Icon(CupertinoIcons.arrow_left, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(groupTitle, style: AmaniTheme.titleStyle.copyWith(fontSize: 22)),
                        Text(tFormat(em['wordsReady'] ?? '', {'done': _doneWords.length, 'total': group.words.length}), style: AmaniTheme.bodyStyle.copyWith(fontSize: 12, color: AmaniColors.textSecondary)),
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
                    decoration: BoxDecoration(color: AmaniColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AmaniColors.textPrimary.withValues(alpha: 0.1))),
                    child: Row(
                      children: [
                        AmaniMascot(pose: allDone ? AmaniPose.celebration : AmaniPose.encouragement, size: AmaniSize.small),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(allDone ? (em['allDoneTitle'] ?? '') : (em['introTitle'] ?? ''), style: AmaniTheme.titleStyle.copyWith(fontSize: 14)),
                              const SizedBox(height: 2),
                              Text(allDone ? (em['allDoneBody'] ?? '') : (em['introBody'] ?? ''), style: AmaniTheme.bodyStyle.copyWith(fontSize: 12, color: AmaniColors.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  for (final word in group.words) ...[
                    _WordTraceRow(
                      word: word,
                      lang: lang,
                      onSpeak: () => speech.speak(word.text(lang.name), lang),
                      done: _doneWords.contains(word.id),
                      onDone: () => setState(() => _doneWords.add(word.id)),
                      doneLabel: el['done'] ?? 'Terminé !',
                    ),
                    const SizedBox(height: 12),
                  ],

                  if (allDone && nextGroup != null)
                    GestureDetector(
                      onTap: () => context.go('/cours/mots/${nextGroup.id}'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(color: const Color(0xFF4A90E2), borderRadius: BorderRadius.circular(18), boxShadow: const [BoxShadow(color: Color(0x334A90E2), blurRadius: 12, offset: Offset(0, 4))]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                tFormat(em['nextGroup'] ?? '', {'titre': nextGroup.title[lang.name] ?? ''}),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w800, fontSize: 15, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(CupertinoIcons.chevron_right, color: Colors.white, size: 18),
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

class _WordTraceRow extends StatefulWidget {
  final WordEntry word;
  final Lang lang;
  final VoidCallback onSpeak;
  final bool done;
  final VoidCallback onDone;
  final String doneLabel;

  const _WordTraceRow({required this.word, required this.lang, required this.onSpeak, required this.done, required this.onDone, required this.doneLabel});

  @override
  State<_WordTraceRow> createState() => _WordTraceRowState();
}

class _WordTraceRowState extends State<_WordTraceRow> {
  final Set<int> _solvedIdx = {};

  @override
  Widget build(BuildContext context) {
    final text = widget.word.text(widget.lang.name);
    final letters = text.split('').map((c) => LETTER_MAP[c]).whereType<dynamic>().toList();
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
        border: Border.all(color: widget.done ? AmaniColors.secondary.withValues(alpha: 0.6) : AmaniColors.textPrimary.withValues(alpha: 0.1)),
        boxShadow: [BoxShadow(color: widget.done ? const Color(0x2E8FBF6F) : const Color(0x144A3B2A), blurRadius: widget.done ? 16 : 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(color: AmaniColors.surface, border: Border(bottom: BorderSide(color: AmaniColors.textPrimary.withValues(alpha: 0.1)))),
            child: Row(
              children: [
                Expanded(
                  child: Text(text, style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w700, fontSize: 14, color: AmaniColors.textPrimary)),
                ),
                if (widget.done) Text('✓ ${widget.doneLabel}', style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w700, fontSize: 13, color: AmaniColors.secondary)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: widget.onSpeak,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(color: const Color(0x264A90E2), shape: BoxShape.circle),
                    child: const Icon(CupertinoIcons.speaker_2_fill, size: 14, color: Color(0xFF2D6BBF)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < letters.length; i++) ...[
                    LetterTraceCell(
                      letter: letters[i],
                      size: 64,
                      isActive: i == activeIdx,
                      onSolved: () {
                        setState(() => _solvedIdx.add(i));
                        if (_solvedIdx.length == letters.length) widget.onDone();
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
