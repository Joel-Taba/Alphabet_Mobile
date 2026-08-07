import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
import '../widgets/letter_trace_cell.dart';

/// Cours de mots du Palier 3 : chaque mot est déjà écrit avec des lettres
/// connues, l'enfant écoute et regarde. Port fidèle de
/// `src/routes/cours.mots.$groupId.tsx`.
class CoursMotsScreen extends StatelessWidget {
  final String groupId;
  const CoursMotsScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final lang = context.watch<LanguageProvider>().lang;
    final speech = context.read<SignSpeechService>();
    final cm = t['coursMots'] as Map<String, dynamic>? ?? {};

    final group = PALIER3_GROUP_MAP[groupId];
    final groupIdx = PALIER3_GROUPS.indexWhere((g) => g.id == groupId);
    final prevGroup = groupIdx > 0 ? PALIER3_GROUPS[groupIdx - 1] : null;
    final nextGroup = groupIdx >= 0 && groupIdx < PALIER3_GROUPS.length - 1
        ? PALIER3_GROUPS[groupIdx + 1]
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
                  '"$groupId" ${cm['notFound'] ?? ''}',
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
                    onTap: () => context.go('/accueil'),
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
                          groupTitle,
                          style: AmaniTheme.titleStyle.copyWith(fontSize: 22),
                        ),
                        Text(
                          tFormat(cm['wordCount'] ?? '', {
                            'count': group.words.length,
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
                        const AmaniMascot(
                          pose: AmaniPose.demonstration,
                          size: AmaniSize.small,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cm['introTitle'] ?? '',
                                style: AmaniTheme.titleStyle.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                cm['introBody'] ?? '',
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

                  for (final word in group.words) ...[
                    _WordCard(
                      word: word,
                      lang: lang,
                      // Le mot n'est considéré "consulté" que lorsque l'enfant
                      // en écoute la prononciation — pas dès l'affichage de
                      // la carte, qui se produit pour tous les mots dès
                      // l'ouverture de la page.
                      onSpeak: () {
                        speech.speak(word.text(lang.name), lang);
                        context.read<ProgressProvider>().markCoursItemViewed(
                          typeEtape: 'MOT',
                          groupCode: groupId,
                          itemCode: word.id,
                          totalItems: group.words.length,
                          palier: lang == Lang.fr ? 4 : 3,
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],

                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const AmaniMascot(
                        pose: AmaniPose.invitation,
                        size: AmaniSize.small,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.push('/exercice/mots/$groupId'),
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
                                    tFormat(cm['practiceGroup'] ?? '', {
                                      'titre': groupTitle,
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
                                  CupertinoIcons.play_fill,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (prevGroup != null)
                        _NavPill(
                          label: prevGroup.title[lang.name] ?? '',
                          leading: true,
                          onTap: () =>
                              context.go('/cours/mots/${prevGroup.id}'),
                        )
                      else
                        const SizedBox(),
                      if (nextGroup != null)
                        _NavPill(
                          label: nextGroup.title[lang.name] ?? '',
                          leading: false,
                          filled: true,
                          onTap: () =>
                              context.go('/cours/mots/${nextGroup.id}'),
                        )
                      else
                        const SizedBox(),
                    ],
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

class _WordCard extends StatelessWidget {
  final WordEntry word;
  final Lang lang;
  final VoidCallback onSpeak;
  const _WordCard({
    required this.word,
    required this.lang,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    final style = context.watch<WritingStyleProvider>().style.name;
    final text = word.text(lang.name);
    final letters = text
        .split('')
        .map((c) => getLetterFormation(c, style))
        .whereType<dynamic>()
        .toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AmaniColors.textPrimary.withValues(alpha: 0.1),
        ),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Expanded(
            child: letters.isEmpty
                ? Text(
                    text,
                    style: TextStyle(
                      fontFamily: kBalooFontFamily,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: AmaniColors.textPrimary,
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final letter in letters) ...[
                          LetterTraceCell(
                            letter: letter,
                            size: 48,
                            isActive: false,
                            given: true,
                          ),
                          const SizedBox(width: 6),
                        ],
                      ],
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onSpeak,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0x264A90E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.speaker_2_fill,
                size: 18,
                color: Color(0xFF2D6BBF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavPill extends StatelessWidget {
  final String label;
  final bool leading;
  final bool filled;
  final VoidCallback onTap;
  const _NavPill({
    required this.label,
    required this.leading,
    this.filled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      leading ? CupertinoIcons.chevron_left : CupertinoIcons.chevron_right,
      size: 14,
      color: filled ? Colors.white : AmaniColors.textPrimary,
    );
    final text = Text(
      label,
      style: TextStyle(
        fontFamily: kBalooFontFamily,
        fontWeight: FontWeight.w800,
        fontSize: 13,
        color: filled ? Colors.white : AmaniColors.textPrimary,
      ),
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 170),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF4A90E2) : AmaniColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: filled
              ? null
              : Border.all(
                  color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: leading
              ? [icon, const SizedBox(width: 6), Flexible(child: text)]
              : [Flexible(child: text), const SizedBox(width: 6), icon],
        ),
      ),
    );
  }
}
