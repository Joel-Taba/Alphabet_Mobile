import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/progress_service.dart';
import '../data/tangram_catalog.dart';
import '../widgets/tangram_board.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Cours "Tangram" du Palier "Figures géométriques" : montre la silhouette
/// déjà résolue (aperçu du résultat, non interactif) puis explique le
/// principe — glisser chaque pièce colorée dans la case qui lui correspond.
class CoursTangramScreen extends StatefulWidget {
  final String puzzleId;
  const CoursTangramScreen({super.key, required this.puzzleId});

  @override
  State<CoursTangramScreen> createState() => _CoursTangramScreenState();
}

class _CoursTangramScreenState extends State<CoursTangramScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onTopicActivated());
  }

  void _onTopicActivated() {
    final puzzle = findTangramPuzzle(widget.puzzleId);
    if (puzzle == null || !mounted) return;
    context.read<ProgressProvider>().awardCompletion(
      typeEtape: 'TANGRAM',
      modalite: 'COURS',
      etapeCode: puzzle.id,
      palier: 6,
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final t = languageProvider.t;
    final lang = languageProvider.lang;
    final ct = t['coursTangram'] as Map<String, dynamic>? ?? {};
    final puzzle = findTangramPuzzle(widget.puzzleId);

    if (puzzle == null) {
      return Scaffold(
        backgroundColor: AmaniColors.background,
        body: SafeArea(
          child: Center(
            child: GestureDetector(
              onTap: () =>
                  context.canPop() ? context.pop() : context.go('/accueil'),
              child: Text(ct['notFound'] ?? ''),
            ),
          ),
        ),
      );
    }

    final name = puzzle.name[lang.name] ?? puzzle.name['fr']!;
    final topicIdx = TANGRAM_PUZZLES.indexWhere((p) => p.id == puzzle.id);
    final nextPuzzle = topicIdx >= 0 && topicIdx < TANGRAM_PUZZLES.length - 1
        ? TANGRAM_PUZZLES[topicIdx + 1]
        : null;

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
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go('/accueil'),
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
                    child: Text(
                      name,
                      style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
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
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        IgnorePointer(
                          child: TangramBoard(
                            key: ValueKey(puzzle.id),
                            puzzle: puzzle,
                            startSolved: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
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
                                ct['introTitle'] ?? '',
                                style: AmaniTheme.titleStyle.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                ct['introBody'] ?? '',
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
                  GestureDetector(
                    onTap: () => context.go('/exercice/tangram/${puzzle.id}'),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB85454),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33B85454),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ct['practice'] ?? "S'entrainer",
                            style: TextStyle(
                              fontFamily: kBalooFontFamily,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          DirectionalIcon(
                            LucideIcons.chevronRight,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (nextPuzzle != null) ...[
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () =>
                          context.go('/cours/tangram/${nextPuzzle.id}'),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AmaniColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AmaniColors.textPrimary.withValues(
                              alpha: 0.1,
                            ),
                          ),
                        ),
                        child: Text(
                          tFormat(ct['nextTopic'] ?? '', {
                            'title': nextPuzzle.name[lang.name] ?? '',
                          }),
                          textAlign: TextAlign.center,
                          style: AmaniTheme.bodyStyle.copyWith(
                            fontSize: 13,
                            color: AmaniColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
