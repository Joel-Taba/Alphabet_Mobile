import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../data/word_catalog.dart';
import '../utils/word_search_generator.dart';
import 'amani_mascot.dart';
import 'confetti_burst.dart';
import 'scroll_handle.dart';
import 'word_search_play.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Section "Mots mêlés" du Mode Libre : une grille aléatoire à volonté,
/// piochée dans `WORD_CATALOG` (même banque de mots simples et courants,
/// maximum 6 lettres, que les leçons "Les Mots" de la page d'accueil — un
/// enfant de primaire doit pouvoir les reconnaître) plutôt que dans une
/// banque de mots plus vaste et plus complexe. Port fidèle de
/// `FreeWordSearchSection` dans `src/routes/_app.bibliotheque.tsx`.
class FreeWordSearchSection extends StatefulWidget {
  const FreeWordSearchSection({super.key});

  @override
  State<FreeWordSearchSection> createState() => _FreeWordSearchSectionState();
}

class _FreeWordSearchSectionState extends State<FreeWordSearchSection> {
  GeneratedWordSearch? _wordSearch;
  int _gameKey = 0;
  final _rand = Random();
  final _confettiKey = GlobalKey<ConfettiBurstState>();

  @override
  void initState() {
    super.initState();
    _newGame();
  }

  void _newGame() {
    final wordCount = _rand.nextBool() ? 5 : 6;
    final seed = _rand.nextInt(1000000);
    setState(() {
      _wordSearch = generateWordSearch(WORD_CATALOG, wordCount, seed);
      _gameKey++;
    });
  }

  /// Grille terminée : confettis puis, après un court délai pour en
  /// profiter, une nouvelle grille automatiquement.
  void _onGridSolved() {
    _confettiKey.currentState?.play();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) _newGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final mlm = t['modeLibreMeles'] as Map<String, dynamic>? ?? {};

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    pose: AmaniPose.motsMeles,
                    size: AmaniSize.small,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mlm['title'] ?? '',
                          style: AmaniTheme.titleStyle.copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          mlm['intro'] ?? '',
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
              onTap: _newGame,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x334A90E2),
                      blurRadius: 10,
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
                      mlm['newGame'] ?? '',
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
            const SizedBox(height: 16),

            const ScrollHandle(),
            const SizedBox(height: 8),

            if (_wordSearch != null)
              WordSearchPlay(
                key: ValueKey(_gameKey),
                wordSearch: _wordSearch!,
                onSolved: _onGridSolved,
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  mlm['generating'] ?? '',
                  textAlign: TextAlign.center,
                  style: AmaniTheme.bodyStyle.copyWith(
                    fontSize: 13,
                    color: AmaniColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
        Positioned.fill(child: ConfettiBurst(key: _confettiKey)),
      ],
    );
  }
}
