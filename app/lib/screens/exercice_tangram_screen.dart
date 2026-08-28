import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/progress_service.dart';
import '../data/tangram_catalog.dart';
import '../widgets/tangram_board.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/exercise_complete_popup.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Exercice "Tangram" : glisser-déposer chaque pièce colorée dans la case
/// qui lui correspond pour reconstituer la silhouette. Après
/// [kMaxMissesBeforeHint] essais ratés, la case de la dernière pièce
/// choisie se met à clignoter (voir `TangramBoard`).
class ExerciceTangramScreen extends StatefulWidget {
  final String puzzleId;
  const ExerciceTangramScreen({super.key, required this.puzzleId});

  @override
  State<ExerciceTangramScreen> createState() => _ExerciceTangramScreenState();
}

class _ExerciceTangramScreenState extends State<ExerciceTangramScreen> {
  bool _done = false;
  int _restartKey = 0;

  void _onSolved() {
    setState(() => _done = true);
    context.read<ProgressProvider>().awardCompletion(
      typeEtape: 'TANGRAM',
      modalite: 'EXERCICE',
      etapeCode: widget.puzzleId,
      palier: 6,
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final t = languageProvider.t;
    final lang = languageProvider.lang;
    final et = t['exerciceTangram'] as Map<String, dynamic>? ?? {};
    final puzzle = findTangramPuzzle(widget.puzzleId);

    if (puzzle == null) {
      return Scaffold(
        backgroundColor: AmaniColors.background,
        body: SafeArea(
          child: Center(
            child: GestureDetector(
              onTap: () =>
                  context.canPop() ? context.pop() : context.go('/accueil'),
              child: Text(et['notFound'] ?? ''),
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
        child: Stack(
          children: [
            Column(
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
                            context.go('/cours/tangram/${widget.puzzleId}'),
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
                              pose: _done
                                  ? AmaniPose.celebration
                                  : AmaniPose.encouragement,
                              size: AmaniSize.small,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                _done
                                    ? (et['doneBody'] ?? '')
                                    : (et['instruction'] ?? ''),
                                style: AmaniTheme.bodyStyle.copyWith(
                                  fontSize: 12,
                                  color: AmaniColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _done
                                ? AmaniColors.secondary.withValues(alpha: 0.6)
                                : AmaniColors.textPrimary.withValues(
                                    alpha: 0.1,
                                  ),
                          ),
                        ),
                        child: TangramBoard(
                          key: ValueKey('${puzzle.id}-$_restartKey'),
                          puzzle: puzzle,
                          onSolved: _onSolved,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_done)
              ExerciseCompletePopup(
                onBackHome: () => context.go('/accueil'),
                onNext: nextPuzzle != null
                    ? () => context.go('/cours/tangram/${nextPuzzle.id}')
                    : null,
                onRestart: () {
                  setState(() {
                    _restartKey++;
                    _done = false;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
