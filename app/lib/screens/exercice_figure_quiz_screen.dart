import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../data/shape_catalog.dart';
import '../hooks/use_exercise_settings.dart';
import '../widgets/quiz_bubble_card.dart';
import '../widgets/lettered_choice_grid.dart';
import '../widgets/shape_glyph.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Mini-jeu bonus "Quelle est cette figure ?" du Palier "Figures
/// géométriques" — purement ludique, sans points ni progression, comme les
/// mini-jeux du Palier "Les Calculs". Une figure est dessinée
/// (`ShapeGlyph`), l'enfant touche son nom parmi les 4 possibles (réutilise
/// `McqAnswer`, déjà générique sur des choix textuels).
class ExerciceFigureQuizScreen extends StatefulWidget {
  const ExerciceFigureQuizScreen({super.key});

  @override
  State<ExerciceFigureQuizScreen> createState() =>
      _ExerciceFigureQuizScreenState();
}

class _Prompt {
  final String shapeId;
  final int choiceSeed;
  const _Prompt(this.shapeId, this.choiceSeed);
}

class _ExerciceFigureQuizScreenState extends State<ExerciceFigureQuizScreen> {
  late final ExerciseSettings _settings;
  List<_Prompt> _items = const [];
  int _activeIdx = 0;
  final Set<int> _doneIndices = {};
  int _restartKey = 0;

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
    final base = _restartKey * 1000;
    _items = List.generate(_settings.repetitions, (i) {
      final rand = Random(base + i);
      final shape = SHAPE_TOPICS[rand.nextInt(SHAPE_TOPICS.length)];
      return _Prompt(shape.id, base + i + 7919);
    });
    _activeIdx = 0;
    _doneIndices.clear();
  }

  @override
  void dispose() {
    _settings.removeListener(_onSettingsChanged);
    _settings.dispose();
    super.dispose();
  }

  void _onItemDone(int i) {
    setState(() {
      _doneIndices.add(i);
      if (i + 1 < _items.length) _activeIdx = i + 1;
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
    final languageProvider = context.watch<LanguageProvider>();
    final t = languageProvider.t;
    final lang = languageProvider.lang;
    final fq = t['figureQuiz'] as Map<String, dynamic>? ?? {};
    final common = t['common'] as Map<String, dynamic>? ?? {};

    final done = _items.isNotEmpty && _doneIndices.length == _items.length;

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
                      (fq['title'] ?? '').toString(),
                      style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
                    ),
                  ),
                  if (_items.isNotEmpty)
                    Text(
                      (fq['scoreLabel'] ?? '{score}/{total}')
                          .toString()
                          .replaceAll('{score}', '${_doneIndices.length}')
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
                        AmaniMascot(
                          pose: done
                              ? AmaniPose.celebration
                              : AmaniPose.encouragement,
                          size: AmaniSize.small,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            done
                                ? (fq['doneBody'] ?? '').toString()
                                : (fq['instruction'] ?? '').toString(),
                            style: AmaniTheme.bodyStyle.copyWith(
                              fontSize: 13,
                              color: AmaniColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  for (var i = 0; i < _items.length; i++) ...[
                    _QuizCard(
                      key: ValueKey('$i-r$_restartKey'),
                      item: _items[i],
                      lang: lang,
                      isActive: i == _activeIdx,
                      isFuture: i > _activeIdx,
                      done: _doneIndices.contains(i),
                      onDone: () => _onItemDone(i),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (done)
                    GestureDetector(
                      onTap: _restart,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB85454),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              LucideIcons.rotateCcw,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              (common['replay'] ?? 'Relancer').toString(),
                              style: TextStyle(
                                fontFamily: kBalooFontFamily,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  final _Prompt item;
  final Lang lang;
  final bool isActive;
  final bool isFuture;
  final bool done;
  final VoidCallback onDone;

  const _QuizCard({
    super.key,
    required this.item,
    required this.lang,
    required this.isActive,
    required this.isFuture,
    required this.done,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final fq = t['figureQuiz'] as Map<String, dynamic>? ?? {};
    final topic = findShapeTopic(item.shapeId)!;
    final correctName = topic.name[lang.name] ?? topic.name['fr']!;
    final shuffledIds = [for (final s in SHAPE_TOPICS) s.id]
      ..shuffle(Random(item.choiceSeed));
    final choices = shuffledIds
        .map(
          (id) =>
              findShapeTopic(id)!.name[lang.name] ??
              findShapeTopic(id)!.name['fr']!,
        )
        .toList();

    return Opacity(
      opacity: isFuture ? 0.4 : 1,
      child: Column(
        children: [
          QuizBubbleCard(
            label: (fq['title'] ?? 'Quiz').toString(),
            child: ShapeGlyph(
              shapeId: item.shapeId,
              size: 70,
              color: Colors.white,
            ),
          ),
          LetteredChoiceGrid<String>(
            choices: choices,
            correctChoice: correctName,
            contentBuilder: (name) => Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: kBalooFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AmaniColors.textPrimary,
              ),
            ),
            isActive: isActive,
            isFuture: isFuture,
            solved: done,
            onSolved: onDone,
          ),
        ],
      ),
    );
  }
}
