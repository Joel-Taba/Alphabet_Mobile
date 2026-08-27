import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../data/word_bank_full.dart';
import '../utils/crossword_generator.dart';
import 'amani_mascot.dart';
import 'crossword_play.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Section "Mots croisés" du Mode Libre : une grille aléatoire à volonté,
/// piochée dans la banque complète de mots. Port fidèle de
/// `FreeCrosswordSection` dans `src/routes/_app.bibliotheque.tsx`.
class FreeCrosswordSection extends StatefulWidget {
  const FreeCrosswordSection({super.key});

  @override
  State<FreeCrosswordSection> createState() => _FreeCrosswordSectionState();
}

class _FreeCrosswordSectionState extends State<FreeCrosswordSection> {
  GeneratedCrossword? _crossword;
  int _gameKey = 0;
  final _rand = Random();

  @override
  void initState() {
    super.initState();
    _newGame();
  }

  void _newGame() {
    final wordCount = _rand.nextBool() ? 5 : 6;
    final seed = _rand.nextInt(1000000);
    setState(() {
      _crossword = generateCrossword(FULL_WORD_BANK, wordCount, seed);
      _gameKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final mlc = t['modeLibreCroises'] as Map<String, dynamic>? ?? {};

    return Column(
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
                pose: AmaniPose.motsCroises,
                size: AmaniSize.small,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mlc['title'] ?? '',
                      style: AmaniTheme.titleStyle.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      mlc['intro'] ?? '',
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
                  mlc['newGame'] ?? '',
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

        if (_crossword != null)
          CrosswordPlay(key: ValueKey(_gameKey), crossword: _crossword!)
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Text(
              mlc['generating'] ?? '',
              textAlign: TextAlign.center,
              style: AmaniTheme.bodyStyle.copyWith(
                fontSize: 13,
                color: AmaniColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}
