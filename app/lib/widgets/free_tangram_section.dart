import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../data/tangram_catalog.dart';
import 'tangram_board.dart';
import 'amani_mascot.dart';
import 'confetti_burst.dart';
import 'scroll_handle.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Onglet "Tangram" du Mode Libre : puzzles bien plus complexes (animaux,
/// objets...) que ceux du Palier "Figures géométriques", pour les enfants
/// déjà à l'aise avec le principe. Plutôt qu'une liste à choisir, le bouton
/// "Nouveau tangram" pioche à chaque fois un puzzle différent au hasard
/// parmi tout le catalogue complexe — l'enfant découvre, ne sélectionne pas.
class FreeTangramSection extends StatefulWidget {
  const FreeTangramSection({super.key});

  @override
  State<FreeTangramSection> createState() => _FreeTangramSectionState();
}

class _FreeTangramSectionState extends State<FreeTangramSection> {
  final _random = math.Random();
  late TangramPuzzle _puzzle;
  bool _solved = false;
  int _restartKey = 0;
  final _confettiKey = GlobalKey<ConfettiBurstState>();

  @override
  void initState() {
    super.initState();
    final pool = tangramPuzzlesByDifficulty(TangramDifficulty.complexe);
    _puzzle = pool[_random.nextInt(pool.length)];
  }

  void _newTangram() {
    final pool = tangramPuzzlesByDifficulty(TangramDifficulty.complexe);
    var next = _puzzle;
    if (pool.length > 1) {
      while (identical(next, _puzzle)) {
        next = pool[_random.nextInt(pool.length)];
      }
    }
    setState(() {
      _puzzle = next;
      _solved = false;
      _restartKey++;
    });
  }

  /// Tangram terminé : confettis puis, après un court délai pour en
  /// profiter, un nouveau tangram automatiquement.
  void _onPuzzleSolved() {
    setState(() => _solved = true);
    _confettiKey.currentState?.play();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) _newTangram();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final lang = context.watch<LanguageProvider>().lang;
    final ft = t['freeTangram'] as Map<String, dynamic>? ?? {};
    final name = _puzzle.name[lang.name] ?? _puzzle.name['fr']!;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    pose: _solved
                        ? AmaniPose.celebration
                        : AmaniPose.encouragement,
                    size: AmaniSize.small,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      _solved
                          ? (ft['doneBody'] ?? '')
                          : (ft['instruction'] ?? ''),
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
            GestureDetector(
              onTap: _newTangram,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
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
                    const Icon(
                      LucideIcons.shuffle,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ft['newTangram'] ?? 'Nouveau tangram',
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              name,
              textAlign: TextAlign.center,
              style: AmaniTheme.titleStyle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const ScrollHandle(),
            const SizedBox(height: 8),
            // Pas de cadre supplémentaire ici : le plateau lui-même (fond
            // clair + contour, voir `TangramBoard`) tient déjà lieu
            // d'espace de jeu, avec le bac de pièces juste en dessous —
            // l'empiler dans UN SECOND cadre ne faisait que rogner les
            // silhouettes les plus grandes sans rien apporter.
            Center(
              child: TangramBoard(
                key: ValueKey('${_puzzle.id}-$_restartKey'),
                puzzle: _puzzle,
                // Plus grand qu'ailleurs dans l'app : le Mode Libre propose
                // des silhouettes bien plus sophistiquées (voir le
                // catalogue complexe) qui profitent d'un espace plus
                // généreux — sans risque de déborder, `TangramBoard` réduit
                // maintenant automatiquement l'unité si besoin pour tenir
                // dans la largeur disponible.
                unitSize: 76,
                onSolved: _onPuzzleSolved,
              ),
            ),
          ],
        ),
        Positioned.fill(child: ConfettiBurst(key: _confettiKey)),
      ],
    );
  }
}
