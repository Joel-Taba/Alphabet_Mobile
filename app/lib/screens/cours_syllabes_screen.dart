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
import '../widgets/letter_trace_cell.dart';
import '../widgets/mini_letter_frame.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Cours du Palier "Les syllabes" : apprend la formation consonne + voyelle
/// (ex. "b + a = ba") puis montre un mot-exemple contenant la syllabe.
/// Français uniquement — voir le filtre par langue dans parcours_screen.dart.
/// Port fidèle de `src/routes/cours.syllabes.$consonant.tsx`.
class CoursSyllabesScreen extends StatefulWidget {
  final String consonant;
  const CoursSyllabesScreen({super.key, required this.consonant});

  @override
  State<CoursSyllabesScreen> createState() => _CoursSyllabesScreenState();
}

class _CoursSyllabesScreenState extends State<CoursSyllabesScreen> {
  int _syllableIdx = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onSyllableActivated());
  }

  @override
  void didUpdateWidget(covariant CoursSyllabesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.consonant != widget.consonant) {
      setState(() => _syllableIdx = 0);
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _onSyllableActivated(),
      );
    }
  }

  /// Parle la syllabe active et journalise sa consultation — les points du
  /// cours ne sont attribués qu'une fois toutes les syllabes de la consonne
  /// consultées.
  void _onSyllableActivated() {
    final group = findSyllableGroupForConsonant(widget.consonant);
    if (group == null || !mounted) return;
    final syllables = group['syllables'] as List;
    final idx = _syllableIdx.clamp(0, syllables.length - 1);
    final current = syllables[idx] as Map<String, dynamic>;
    final lang = context.read<LanguageProvider>().lang;
    final t = context.read<LanguageProvider>().t;
    final cs = t['coursSyllabes'] as Map<String, dynamic>? ?? {};

    context.read<SignSpeechService>().speak(
      tFormat(cs['speakFormation'] ?? '', {
        'consonant': current['consonant'],
        'vowel': current['vowel'],
        'syllable': current['syllable'],
      }),
      lang,
    );
    context.read<ProgressProvider>().markCoursItemViewed(
      typeEtape: 'SYLLABE',
      groupCode: widget.consonant,
      itemCode: current['syllable'] as String,
      totalItems: syllables.length,
      palier: 3,
    );
  }

  void _selectSyllable(int i) {
    setState(() => _syllableIdx = i);
    _onSyllableActivated();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final lang = context.watch<LanguageProvider>().lang;
    final speech = context.read<SignSpeechService>();
    final style = context.watch<WritingStyleProvider>().style.name;
    final cs = t['coursSyllabes'] as Map<String, dynamic>? ?? {};

    final group = findSyllableGroupForConsonant(widget.consonant);

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
    final idx = _syllableIdx.clamp(0, syllables.length - 1);
    final current = syllables[idx] as Map<String, dynamic>;
    final groupIdx = SYLLABLE_GROUPS.indexWhere((g) => g['id'] == group['id']);
    final nextGroup = groupIdx >= 0 && groupIdx < SYLLABLE_GROUPS.length - 1
        ? SYLLABLE_GROUPS[groupIdx + 1] as Map<String, dynamic>
        : null;

    final consonantLetter = getLetterFormation(
      current['consonant'] as String,
      style,
    );
    final vowelLetter = getLetterFormation(current['vowel'] as String, style);
    final wordLetters = (current['exampleWord'] as String)
        .split('')
        .map((c) => getLetterFormation(c, style))
        .whereType<dynamic>()
        .toList();

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
                      child: DirectionalIcon(LucideIcons.arrowLeft, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tFormat(cs['consonantTitle'] ?? '', {
                            'consonant': '"${group['consonant']}"',
                          }),
                          style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
                        ),
                        Text(
                          tFormat(cs['syllableCount'] ?? '', {
                            'count': syllables.length,
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
                  // Carte de la syllabe : consonne + voyelle = syllabe
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1F000000),
                          blurRadius: 20,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MiniLetterFrame(
                              letter: consonantLetter,
                              delayMs: 0,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              '+',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AmaniColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            MiniLetterFrame(
                              letter: vowelLetter,
                              delayMs: 650,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              '=',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AmaniColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              current['syllable'] as String,
                              style: TextStyle(
                                fontFamily: kBalooFontFamily,
                                fontWeight: FontWeight.w800,
                                fontSize: 34,
                                color: AmaniColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Divider(
                          color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          tFormat(cs['exampleWordLabel'] ?? '', {
                            'syllable': current['syllable'],
                          }),
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            letterSpacing: 0.3,
                            color: AmaniColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              // Centré plutôt que collé à gauche, pour que le
                              // mot d'exemple ressorte bien — le défilement
                              // horizontal reste un filet de sécurité pour un
                              // mot trop long pour la largeur disponible.
                              child: Center(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (final l in wordLetters) ...[
                                        LetterTraceCell(
                                          letter: l,
                                          size: 40,
                                          isActive: false,
                                          given: true,
                                        ),
                                        const SizedBox(width: 4),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => speech.speak(
                                current['exampleWord'] as String,
                                lang,
                              ),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0x264A90E2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  LucideIcons.volume2,
                                  size: 16,
                                  color: Color(0xFF2D6BBF),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Navigation entre les syllabes de la consonne
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var i = 0; i < syllables.length; i++)
                        GestureDetector(
                          onTap: () => _selectSyllable(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: i == idx
                                  ? AmaniColors.primary
                                  : AmaniColors.surface,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: i == idx
                                    ? AmaniColors.primary
                                    : AmaniColors.textPrimary.withValues(
                                        alpha: 0.1,
                                      ),
                              ),
                            ),
                            child: Text(
                              syllables[i]['syllable'] as String,
                              style: TextStyle(
                                fontFamily: kBalooFontFamily,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: i == idx
                                    ? Colors.white
                                    : AmaniColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () => context.push(
                        '/exercice/syllabes/${widget.consonant}',
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AmaniColors.secondary,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x338FBF6F),
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
                                cs['practice'] ?? '',
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
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  if (nextGroup != null) ...[
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => context.go(
                          '/cours/syllabes/${nextGroup['consonant']}',
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AmaniColors.surface,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: AmaniColors.textPrimary.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tFormat(cs['nextConsonant'] ?? '', {
                                  'consonant': nextGroup['consonant'],
                                }),
                                style: TextStyle(
                                  fontFamily: kBalooFontFamily,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                  color: AmaniColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              DirectionalIcon(LucideIcons.chevronRight,
                                size: 14,
                                color: AmaniColors.textPrimary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
