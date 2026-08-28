import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../data/shape_catalog.dart';
import '../hooks/use_exercise_settings.dart';
import '../widgets/realistic_object_icon.dart';
import '../widgets/shape_glyph.dart';
import '../widgets/quiz_bubble_card.dart';
import '../widgets/lettered_choice_grid.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Mini-jeu bonus "Quel objet a cette forme ?" — associe une figure à un
/// objet du quotidien de même forme (emoji, aucun asset nécessaire).
/// Réutilise `McqAnswer` (choix textuels génériques, ici des emoji).
class ExerciceFigureObjetScreen extends StatefulWidget {
  const ExerciceFigureObjetScreen({super.key});

  @override
  State<ExerciceFigureObjetScreen> createState() =>
      _ExerciceFigureObjetScreenState();
}

class _ExerciceFigureObjetScreenState extends State<ExerciceFigureObjetScreen> {
  late final ExerciseSettings _settings;
  List<String> _items = const [];
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
      return SHAPE_TOPICS[rand.nextInt(SHAPE_TOPICS.length)].id;
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
    final fo = t['figureObjet'] as Map<String, dynamic>? ?? {};
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
                      (fo['title'] ?? '').toString(),
                      style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
                    ),
                  ),
                  if (_items.isNotEmpty)
                    Text(
                      (fo['scoreLabel'] ?? '{score}/{total}')
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
                                ? (fo['doneBody'] ?? '').toString()
                                : (fo['instruction'] ?? '').toString(),
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
                    _ObjetCard(
                      key: ValueKey('$i-r$_restartKey'),
                      shapeId: _items[i],
                      choiceSeed: _restartKey * 1000 + i + 7919,
                      lang: lang,
                      promptTemplate: (fo['promptLabel'] ?? '{shape}')
                          .toString(),
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

class _ObjetCard extends StatelessWidget {
  final String shapeId;
  final int choiceSeed;
  final Lang lang;
  final String promptTemplate;
  final bool isActive;
  final bool isFuture;
  final bool done;
  final VoidCallback onDone;

  const _ObjetCard({
    super.key,
    required this.shapeId,
    required this.choiceSeed,
    required this.lang,
    required this.promptTemplate,
    required this.isActive,
    required this.isFuture,
    required this.done,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final fo = t['figureObjet'] as Map<String, dynamic>? ?? {};
    final topic = findShapeTopic(shapeId)!;
    final shapeName = topic.name[lang.name] ?? topic.name['fr']!;
    final correctKey = SHAPE_OBJECT_KEY[shapeId]!;
    final choices = SHAPE_OBJECT_KEY.values.toList()
      ..shuffle(Random(choiceSeed));

    return Opacity(
      opacity: isFuture ? 0.4 : 1,
      child: Column(
        children: [
          QuizBubbleCard(
            label: (fo['title'] ?? 'Objets').toString(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShapeGlyph(shapeId: shapeId, size: 44, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  promptTemplate.replaceAll('{shape}', shapeName),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: kBalooFontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          LetteredChoiceGrid<String>(
            choices: choices,
            correctChoice: correctKey,
            contentBuilder: (choice) =>
                RealisticObjectIcon(objectKey: choice, size: 34),
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
