import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../services/progress_service.dart';
import '../data/calcul_catalog.dart';
import '../widgets/posed_operation_demo.dart';
import '../widgets/small_calc_balls.dart';
import '../widgets/directional_icon.dart';
import '../widgets/trace_controls_toolbar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../utils/navigation_helpers.dart';

/// Extrait les deux opérandes d'un `CalculProblem.display` (ex. "34 + 89")
/// pour les widgets de démonstration "opération posée" — évite d'ajouter des
/// champs numériques dédiés aux générateurs existants.
List<int>? _parseOperands(String display, String operatorSymbol) {
  final parts = display.split(operatorSymbol);
  if (parts.length != 2) return null;
  final a = int.tryParse(parts[0].trim());
  final b = int.tryParse(parts[1].trim());
  if (a == null || b == null) return null;
  return [a, b];
}

/// Extrait numérateur/dénominateur des deux fractions d'un `display` du
/// type "1/2 + 1/3", pour `FractionPoseeDemo`.
List<int>? _parseFractionOperands(String display) {
  final m = RegExp(r'^(\d+)/(\d+) \+ (\d+)/(\d+)$').firstMatch(display.trim());
  if (m == null) return null;
  return [
    int.parse(m.group(1)!),
    int.parse(m.group(2)!),
    int.parse(m.group(3)!),
    int.parse(m.group(4)!),
  ];
}

/// Cours du Palier "Les Calculs" : présente le concept du sujet (avec une
/// petite animation et, pour les tout premiers sujets, des objets à
/// compter) puis une carte mnémotechnique pour faciliter la mémorisation.
/// Français uniquement — voir le filtre par langue dans parcours_screen.dart,
/// sur le même principe que le Palier "Les Syllabes".
class CoursCalculScreen extends StatefulWidget {
  final String topicId;
  const CoursCalculScreen({super.key, required this.topicId});

  @override
  State<CoursCalculScreen> createState() => _CoursCalculScreenState();
}

class _CoursCalculScreenState extends State<CoursCalculScreen> {
  int _replaySeed = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onTopicActivated());
  }

  @override
  void didUpdateWidget(covariant CoursCalculScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.topicId != widget.topicId) {
      setState(() {
        _replaySeed = 0;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _onTopicActivated());
    }
  }

  void _onTopicActivated() {
    final topic = findCalculTopic(widget.topicId);
    if (topic == null || !mounted) return;
    context.read<ProgressProvider>().awardCompletion(
      typeEtape: 'CALCUL',
      modalite: 'COURS',
      etapeCode: topic.id,
      palier: 5,
    );
  }

  void _speakConsigne(CalculTopic topic, Lang lang) {
    final body = topic.mnemonicBody[lang.name] ?? topic.mnemonicBody['fr']!;
    context.read<SignSpeechService>().speak(body, lang);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final t = languageProvider.t;
    final lang = languageProvider.lang;
    final cc = t['coursCalcul'] as Map<String, dynamic>? ?? {};
    final common = t['common'] as Map<String, dynamic>? ?? {};
    final topic = findCalculTopic(widget.topicId);

    if (topic == null) {
      return Scaffold(
        backgroundColor: AmaniColors.background,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '"${widget.topicId}" ${cc['notFound'] ?? ''}',
                  style: AmaniTheme.titleStyle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () =>
                      goHome(context),
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
                      cc['backToList'] ?? '',
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

    final isTableTopic = topic.tableNumber != null;
    final isPosedTopic = topic.posedOperation != null;

    // Un seul problème illustré sert de démonstration sur cette page — le
    // premier généré qui porte des objets à compter, sinon le tout premier.
    // Non utilisé pour une table de multiplication (carte dédiée ci-dessous).
    final demoProblems = isTableTopic
        ? const <CalculProblem>[]
        : topic.generateProblems(_replaySeed, 3);
    final demo = isTableTopic
        ? null
        : demoProblems.firstWhere(
            (p) => p.illustrateA != null,
            orElse: () => demoProblems.first,
          );
    final posedOperands = isPosedTopic && demo != null
        ? (topic.posedOperation == 'fraction'
              ? _parseFractionOperands(demo.display)
              : _parseOperands(
                  demo.display,
                  const {
                    'addition': '+',
                    'soustraction': '-',
                    'multiplication': '×',
                    'division': '÷',
                  }[topic.posedOperation]!,
                ))
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
                    onTap: () => goHome(context),
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
                      child: DirectionalIcon(LucideIcons.house, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${cc['levelLabel'] ?? 'Niveau'}: '
                          '${calculNiveauLabel(topic.niveau, lang.name)}',
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            letterSpacing: 1.2,
                            color: const Color(0xFF6B3F94),
                          ),
                        ),
                        Text(
                          topic.title[lang.name] ?? topic.title['fr']!,
                          style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
                        ),
                        Text(
                          topic.subtitle[lang.name] ?? topic.subtitle['fr']!,
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
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: TraceControlsToolbar.heightFor(3),
                    ),
                    child: Stack(
                      children: [
                        if (isTableTopic)
                          _MultiplicationTableCard(
                            tableNumber: topic.tableNumber!,
                          )
                        else if (isPosedTopic && posedOperands != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1F000000),
                                  blurRadius: 20,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: switch (topic.posedOperation) {
                                'addition' => AdditionPoseeDemo(
                                  a: posedOperands[0],
                                  b: posedOperands[1],
                                ),
                                'soustraction' => SoustractionPoseeDemo(
                                  a: posedOperands[0],
                                  b: posedOperands[1],
                                ),
                                'multiplication' => MultiplicationPoseeDemo(
                                  a: posedOperands[0],
                                  b: posedOperands[1],
                                ),
                                'division' => DivisionPoseeDemo(
                                  dividend: posedOperands[0],
                                  divisor: posedOperands[1],
                                ),
                                'fraction' => FractionPoseeDemo(
                                  numA: posedOperands[0],
                                  denomA: posedOperands[1],
                                  numB: posedOperands[2],
                                  denomB: posedOperands[3],
                                ),
                                _ => const SizedBox.shrink(),
                              },
                            ),
                          )
                        else
                          // Carte de démonstration : objets à compter (si
                          // présents) + équation + réponse animée chiffre par
                          // chiffre.
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1F000000),
                                  blurRadius: 20,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                if (demo!.illustrateA != null &&
                                    demo.illustrateB != null) ...[
                                  demo.display.contains('-')
                                      ? SoustractionBallsDemo(
                                          countA: demo.illustrateA!,
                                          countRemoved: demo.illustrateB!,
                                        )
                                      : AdditionBallsDemo(
                                          countA: demo.illustrateA!,
                                          countB: demo.illustrateB!,
                                        ),
                                  const SizedBox(height: 12),
                                ],
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      demo.display,
                                      style: TextStyle(
                                        fontFamily: kBalooFontFamily,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 28,
                                        color: AmaniColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      '=',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: AmaniColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Row(
                                      key: ValueKey('answer-$_replaySeed'),
                                      children: [
                                        Text(
                                          demo.answer,
                                          style: const TextStyle(
                                            fontFamily: 'monospace',
                                            fontWeight: FontWeight.w800,
                                            fontSize: 32,
                                            color: AmaniColors.textPrimary,
                                          ),
                                        ),
                                        if (demo.answerSecondPart != null) ...[
                                          Text(
                                            demo.secondPartSeparator,
                                            style: TextStyle(
                                              fontFamily: kBalooFontFamily,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 22,
                                              color: AmaniColors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            demo.answerSecondPart!,
                                            style: const TextStyle(
                                              fontFamily: 'monospace',
                                              fontWeight: FontWeight.w800,
                                              fontSize: 32,
                                              color: AmaniColors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: TraceControlsToolbar(
                            expandAria: common['toolbarExpandAria'] ?? '',
                            collapseAria: common['toolbarCollapseAria'] ?? '',
                            actions: [
                              ToolbarAction(
                                icon: LucideIcons.rotateCcw,
                                label: common['replay'] ?? 'Relancer',
                                background: const Color(0x1F6B3F94),
                                foreground: const Color(0xFF3F2456),
                                onTap: () => setState(() {
                                  _replaySeed++;
                                }),
                              ),
                              ToolbarAction(
                                icon: LucideIcons.volume2,
                                label: common['instruction'] ?? 'Consigne',
                                background: AmaniColors.background,
                                foreground: Colors.black,
                                onTap: () => _speakConsigne(topic, lang),
                              ),
                              ToolbarAction(
                                icon: Icons.play_arrow_rounded,
                                label: cc['practice'] ?? "S'entrainer",
                                background: const Color(0xFF8B5FBF),
                                foreground: Colors.white,
                                onTap: () => context.push(
                                  '/exercice/calcul/${topic.id}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Carte mnémotechnique "Le sais-tu ?"
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1E9F9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFD9C4EF)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('💡', style: TextStyle(fontSize: 26)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                topic.mnemonicTitle[lang.name] ??
                                    topic.mnemonicTitle['fr']!,
                                style: AmaniTheme.titleStyle.copyWith(
                                  fontSize: 14,
                                  color: const Color(0xFF6B3F94),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                topic.mnemonicBody[lang.name] ??
                                    topic.mnemonicBody['fr']!,
                                style: AmaniTheme.bodyStyle.copyWith(
                                  fontSize: 13,
                                  color: AmaniColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Palette pastel cyclique (une couleur par table, 1 à 10) — pas de
/// correspondance exacte avec une charte existante, juste une couleur
/// distincte par table pour rappeler la fiche de référence papier classique.
const List<Color> _kTableCardBg = [
  Color(0xFFFFF6C8),
  Color(0xFFD9F0DA),
  Color(0xFFFBDDE3),
  Color(0xFFDCEBFB),
  Color(0xFFE6DFF6),
  Color(0xFFF3DCEE),
  Color(0xFFE3E6E8),
  Color(0xFFFBE6CE),
  Color(0xFFDCEEDC),
  Color(0xFFD3EDEA),
];
const List<Color> _kTableCardBorder = [
  Color(0xFFE8D27A),
  Color(0xFF8FBF6F),
  Color(0xFFE9899C),
  Color(0xFF7FAEDE),
  Color(0xFFA98FD6),
  Color(0xFFC97FBE),
  Color(0xFF9AA5AC),
  Color(0xFFE0A85E),
  Color(0xFF6FA36F),
  Color(0xFF5FB3A6),
];

/// Fiche de référence complète d'une table de multiplication (× 0 à × 10),
/// style fiche papier classique — voir le Cours d'un sujet `tableNumber`.
class _MultiplicationTableCard extends StatelessWidget {
  final int tableNumber;
  const _MultiplicationTableCard({required this.tableNumber});

  @override
  Widget build(BuildContext context) {
    final bg = _kTableCardBg[(tableNumber - 1) % _kTableCardBg.length];
    final border =
        _kTableCardBorder[(tableNumber - 1) % _kTableCardBorder.length];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: border, width: 3),
            ),
            alignment: Alignment.center,
            child: Text(
              '$tableNumber',
              style: TextStyle(
                fontFamily: kBalooFontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: AmaniColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 14),
          for (var n = 0; n <= 10; n++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                '$tableNumber × $n = ${tableNumber * n}',
                style: TextStyle(
                  fontFamily: kBalooFontFamily,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AmaniColors.textPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
