import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../data/calcul_catalog.dart';
import '../hooks/use_exercise_settings.dart';
import '../widgets/number_compose_puzzle.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Mini-jeu bonus "Compose le nombre !" du Palier "Les Calculs" — purement
/// ludique, sans points ni progression, comme les mots croisés/mêlés du
/// Palier "Les Mots". [levelIndex] est l'index dans [COMPOSE_NOMBRE_LEVELS]
/// (0=CP … 4=CM2).
class ExerciceCalculComposeScreen extends StatefulWidget {
  final String levelIndex;
  const ExerciceCalculComposeScreen({super.key, required this.levelIndex});

  @override
  State<ExerciceCalculComposeScreen> createState() =>
      _ExerciceCalculComposeScreenState();
}

class _ExerciceCalculComposeScreenState
    extends State<ExerciceCalculComposeScreen> {
  late final ExerciseSettings _settings;
  List<NumberComposePuzzle> _puzzles = const [];
  int _index = 0;
  int _score = 0;
  int _restartKey = 0;

  int? get _levelIdx => int.tryParse(widget.levelIndex);

  @override
  void initState() {
    super.initState();
    _settings = ExerciseSettings()..addListener(_onSettingsChanged);
    _settings.load().then((_) => _regenerate());
  }

  void _onSettingsChanged() {
    if (!mounted) return;
    setState(_regenerate);
  }

  void _regenerate() {
    final idx = _levelIdx;
    if (idx == null || idx < 0 || idx >= COMPOSE_NOMBRE_LEVELS.length) return;
    final level = COMPOSE_NOMBRE_LEVELS[idx];
    _puzzles = level.generatePuzzles(
      idx * 1000 + _restartKey,
      _settings.repetitions,
    );
    _index = 0;
    _score = 0;
  }

  @override
  void dispose() {
    _settings.removeListener(_onSettingsChanged);
    _settings.dispose();
    super.dispose();
  }

  void _onCorrect() {
    setState(() {
      _score++;
      _index++;
    });
  }

  void _restart() {
    setState(() {
      _restartKey++;
      _regenerate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final cc = t['calculCompose'] as Map<String, dynamic>? ?? {};
    final common = t['common'] as Map<String, dynamic>? ?? {};
    final idx = _levelIdx;
    final level =
        (idx != null && idx >= 0 && idx < COMPOSE_NOMBRE_LEVELS.length)
        ? COMPOSE_NOMBRE_LEVELS[idx]
        : null;

    if (level == null) {
      return Scaffold(
        backgroundColor: AmaniColors.background,
        body: SafeArea(
          child: Center(
            child: GestureDetector(
              onTap: () => context.go('/accueil'),
              child: Text((common['backToHome'] ?? '').toString()),
            ),
          ),
        ),
      );
    }

    final done = _puzzles.isNotEmpty && _index >= _puzzles.length;
    final current = !done && _puzzles.isNotEmpty ? _puzzles[_index] : null;

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
                          level.niveau,
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            letterSpacing: 1.2,
                            color: const Color(0xFF6B3F94),
                          ),
                        ),
                        Text(
                          (cc['title'] ?? level.title).toString(),
                          style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  if (_puzzles.isNotEmpty)
                    Text(
                      (cc['scoreLabel'] ?? '{score}/{total}')
                          .toString()
                          .replaceAll('{score}', '$_score')
                          .replaceAll('{total}', '${_puzzles.length}'),
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AmaniColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: done
                      ? _DoneCard(
                          title: (cc['doneTitle'] ?? '').toString(),
                          body: (cc['doneBody'] ?? '').toString(),
                          replayLabel: (common['replay'] ?? 'Relancer')
                              .toString(),
                          onReplay: _restart,
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              (cc['instruction'] ?? '').toString(),
                              textAlign: TextAlign.center,
                              style: AmaniTheme.bodyStyle.copyWith(
                                fontSize: 13,
                                color: AmaniColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              (cc['target'] ?? 'Obtiens {target} !')
                                  .toString()
                                  .replaceAll(
                                    '{target}',
                                    '${current?.target ?? ''}',
                                  ),
                              style: AmaniTheme.titleStyle.copyWith(
                                fontSize: 22,
                                color: const Color(0xFF6B3F94),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (current != null)
                              NumberComposePuzzleWidget(
                                key: ValueKey(_index),
                                puzzle: current,
                                onCorrect: _onCorrect,
                              ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoneCard extends StatelessWidget {
  final String title;
  final String body;
  final String replayLabel;
  final VoidCallback onReplay;

  const _DoneCard({
    required this.title,
    required this.body,
    required this.replayLabel,
    required this.onReplay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: AmaniTheme.bodyStyle.copyWith(
            fontSize: 14,
            color: AmaniColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: onReplay,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5FBF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  LucideIcons.rotateCcw,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  replayLabel,
                  style: TextStyle(
                    fontFamily: kBalooFontFamily,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
