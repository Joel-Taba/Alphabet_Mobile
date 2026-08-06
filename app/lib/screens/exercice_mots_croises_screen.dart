import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../data/word_catalog.dart';
import '../utils/crossword_generator.dart';
import '../widgets/crossword_play.dart';

/// Exercice de mots croisés à difficulté progressive (`lvl2` → 2 mots,
/// `lvl10` → 10 mots). Port fidèle de
/// `src/routes/exercice.mots-croises.$puzzleId.tsx`.
class ExerciceMotsCroisesScreen extends StatelessWidget {
  final String puzzleId;
  const ExerciceMotsCroisesScreen({super.key, required this.puzzleId});

  int? _parseLevel(String id) {
    final m = RegExp(r'^lvl(\d+)$').firstMatch(id);
    if (m == null) return null;
    final n = int.tryParse(m.group(1)!);
    if (n == null || n < 2 || n > 10) return null;
    return n;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final mc = t['motsCroises'] as Map<String, dynamic>? ?? {};
    final cm = t['coursMots'] as Map<String, dynamic>? ?? {};

    final level = _parseLevel(puzzleId);
    final GeneratedCrossword? crossword = level != null
        ? generateCrossword(WORD_CATALOG, level, 1000 + level * 37)
        : null;

    if (level == null || crossword == null) {
      return Scaffold(
        backgroundColor: AmaniColors.background,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mc['generationFailed'] ?? '',
                  style: AmaniTheme.titleStyle.copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
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
                          mc['title'] ?? '',
                          style: AmaniTheme.titleStyle.copyWith(fontSize: 22),
                        ),
                        Text(
                          tFormat(mc['levelSubtitle'] ?? '', {
                            'level': level,
                            'count': crossword.placed.length,
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: CrosswordPlay(crossword: crossword),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
