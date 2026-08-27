import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../data/calcul_catalog.dart';
import '../hooks/use_exercise_settings.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Mini-jeu bonus "Vrai ou Faux ?" du Palier "Les Calculs" — purement
/// ludique, sans points ni progression, comme les mots croisés/mêlés du
/// Palier "Les Mots". [levelIndex] est l'index dans [VRAI_FAUX_LEVELS]
/// (0=CP … 4=CM2).
class ExerciceCalculVraiFauxScreen extends StatefulWidget {
  final String levelIndex;
  const ExerciceCalculVraiFauxScreen({super.key, required this.levelIndex});

  @override
  State<ExerciceCalculVraiFauxScreen> createState() =>
      _ExerciceCalculVraiFauxScreenState();
}

class _ExerciceCalculVraiFauxScreenState
    extends State<ExerciceCalculVraiFauxScreen> {
  late final ExerciseSettings _settings;
  List<TrueFalseEquation> _items = const [];
  int _index = 0;
  int _score = 0;
  int _restartKey = 0;
  bool? _lastCorrect;
  bool _locked = false;

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
    if (idx == null || idx < 0 || idx >= VRAI_FAUX_LEVELS.length) return;
    final level = VRAI_FAUX_LEVELS[idx];
    _items = level.generateItems(idx * 1000 + _restartKey, _settings.repetitions);
    _index = 0;
    _score = 0;
    _lastCorrect = null;
    _locked = false;
  }

  @override
  void dispose() {
    _settings.removeListener(_onSettingsChanged);
    _settings.dispose();
    super.dispose();
  }

  void _answer(bool guessTrue) {
    if (_locked || _index >= _items.length) return;
    final correct = guessTrue == _items[_index].isTrue;
    setState(() {
      _locked = true;
      _lastCorrect = correct;
      if (correct) _score++;
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _index++;
        _lastCorrect = null;
        _locked = false;
      });
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
    final vf = t['calculVraiFaux'] as Map<String, dynamic>? ?? {};
    final common = t['common'] as Map<String, dynamic>? ?? {};
    final idx = _levelIdx;
    final level = (idx != null && idx >= 0 && idx < VRAI_FAUX_LEVELS.length)
        ? VRAI_FAUX_LEVELS[idx]
        : null;

    if (level == null) {
      return Scaffold(
        backgroundColor: AmaniColors.background,
        body: SafeArea(
          child: Center(
            child: GestureDetector(
              onTap: () => context.go('/accueil'),
              child: Text(common['backToHome'] ?? ''),
            ),
          ),
        ),
      );
    }

    final done = _items.isNotEmpty && _index >= _items.length;
    final current = !done && _items.isNotEmpty ? _items[_index] : null;

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
                          (vf['title'] ?? level.title).toString(),
                          style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  if (_items.isNotEmpty)
                    Text(
                      (vf['scoreLabel'] ?? '{score}/{total}')
                          .toString()
                          .replaceAll('{score}', '$_score')
                          .replaceAll('{total}', '${_items.length}'),
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
                          title: (vf['doneTitle'] ?? '').toString(),
                          body: (vf['doneBody'] ?? '').toString(),
                          replayLabel: (common['replay'] ?? 'Relancer')
                              .toString(),
                          onReplay: _restart,
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              (vf['instruction'] ?? '').toString(),
                              textAlign: TextAlign.center,
                              style: AmaniTheme.bodyStyle.copyWith(
                                fontSize: 14,
                                color: AmaniColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 28,
                              ),
                              constraints: const BoxConstraints(minWidth: 260),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: _lastCorrect == null
                                      ? AmaniColors.textPrimary.withValues(
                                          alpha: 0.1,
                                        )
                                      : (_lastCorrect!
                                            ? AmaniColors.success
                                            : AmaniColors.error),
                                  width: 3,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x1F000000),
                                    blurRadius: 20,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Text(
                                current?.display ?? '',
                                style: TextStyle(
                                  fontFamily: kBalooFontFamily,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 30,
                                  color: AmaniColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _AnswerButton(
                                  label: (vf['true'] ?? 'Vrai').toString(),
                                  icon: LucideIcons.check,
                                  color: AmaniColors.success,
                                  onTap: () => _answer(true),
                                ),
                                const SizedBox(width: 16),
                                _AnswerButton(
                                  label: (vf['false'] ?? 'Faux').toString(),
                                  icon: LucideIcons.x,
                                  color: AmaniColors.error,
                                  onTap: () => _answer(false),
                                ),
                              ],
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

class _AnswerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AnswerButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(height: 6),
            Text(
              label,
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
