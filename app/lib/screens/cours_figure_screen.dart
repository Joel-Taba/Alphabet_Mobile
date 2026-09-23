import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../services/progress_service.dart';
import '../hooks/use_animation_speed.dart';
import '../data/shape_catalog.dart';
import '../widgets/mini_letter_frame.dart';
import '../widgets/directional_icon.dart';
import '../widgets/trace_controls_toolbar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../utils/navigation_helpers.dart';

/// Cours du Palier "Figures géométriques" : anime le tracé de la figure
/// (réutilise `MiniLetterFrame`, déjà générique), présente ses propriétés en
/// langage simple ("3 côtés, 3 coins"), puis une carte "Le sais-tu ?" avec
/// une association ludique (pizza, fenêtre, roue...). Disponible dans les 4
/// langues de l'app (contenu universel, pas lié au système scolaire
/// français — contrairement aux Paliers "Syllabes"/"Calculs").
class CoursFigureScreen extends StatefulWidget {
  final String shapeId;
  const CoursFigureScreen({super.key, required this.shapeId});

  @override
  State<CoursFigureScreen> createState() => _CoursFigureScreenState();
}

class _CoursFigureScreenState extends State<CoursFigureScreen> {
  int _replaySeed = 0;

  /// `true` juste après l'ouverture de la page ou un changement de figure --
  /// applique alors le délai avant le lancement de l'animation (voir
  /// [kCoursAnimationDelay]). Repassé à `false` dès qu'un rejeu explicite
  /// (bouton "Relancer") est demandé, pour que celui-ci reste immédiat.
  bool _autoplayDelay = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onTopicActivated());
  }

  @override
  void didUpdateWidget(covariant CoursFigureScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shapeId != widget.shapeId) {
      setState(() {
        _replaySeed = 0;
        _autoplayDelay = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _onTopicActivated());
    }
  }

  void _onTopicActivated() {
    final topic = findShapeTopic(widget.shapeId);
    if (topic == null || !mounted) return;
    context.read<ProgressProvider>().awardCompletion(
      typeEtape: 'FIGURE',
      modalite: 'COURS',
      etapeCode: topic.id,
      palier: 6,
    );
  }

  void _speakConsigne(ShapeTopic topic, Lang lang) {
    final text = topic.funFactBody[lang.name] ?? topic.funFactBody['fr']!;
    context.read<SignSpeechService>().speak(text, lang);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final t = languageProvider.t;
    final lang = languageProvider.lang;
    final cf = t['coursFigure'] as Map<String, dynamic>? ?? {};
    final common = t['common'] as Map<String, dynamic>? ?? {};
    final topic = findShapeTopic(widget.shapeId);

    if (topic == null) {
      return Scaffold(
        backgroundColor: AmaniColors.background,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '"${widget.shapeId}" ${cf['notFound'] ?? ''}',
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
                      cf['backToList'] ?? '',
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

    final name = topic.name[lang.name] ?? topic.name['fr']!;
    final funFactTitle =
        topic.funFactTitle[lang.name] ?? topic.funFactTitle['fr']!;
    final funFactBody =
        topic.funFactBody[lang.name] ?? topic.funFactBody['fr']!;
    final perimeterFormula =
        topic.perimeterFormula[lang.name] ?? topic.perimeterFormula['fr']!;
    final areaFormula =
        topic.areaFormula[lang.name] ?? topic.areaFormula['fr']!;
    final properties = topic.hasCurvedSides
        ? (cf['propertiesRound'] ?? '')
        : (cf['propertiesWithCorners'] ?? '{sides}/{corners}')
              .toString()
              .replaceAll('{sides}', '${topic.sides}')
              .replaceAll('{corners}', '${topic.corners}');

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
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1F000000),
                          blurRadius: 20,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: TraceControlsToolbar.heightFor(3),
                      ),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Column(
                            children: [
                              MiniLetterFrame(
                                key: ValueKey('shape-$_replaySeed'),
                                letter: topic.traceData,
                                size: 140,
                                delayMs: _autoplayDelay
                                    ? kCoursAnimationDelay.inMilliseconds
                                    : 0,
                                // Chaque côté doit se tracer entièrement avant
                                // que le suivant ne commence (pas de
                                // chevauchement), pour bien distinguer la
                                // formation figure par figure — contrairement
                                // aux lettres, où un léger chevauchement reste
                                // acceptable.
                                stepGapMs: 700,
                                stepDrawMs: 700,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                properties,
                                textAlign: TextAlign.center,
                                style: AmaniTheme.bodyStyle.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AmaniColors.textPrimary,
                                ),
                              ),
                            ],
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
                                  background: const Color(0x1FB85454),
                                  foreground: const Color(0xFF7A2E2E),
                                  onTap: () => setState(() {
                                    _replaySeed++;
                                    _autoplayDelay = false;
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
                                  label: cf['practice'] ?? "S'entrainer",
                                  background: const Color(0xFFB85454),
                                  foreground: Colors.white,
                                  onTap: () => context.push(
                                    '/exercice/figure/${topic.id}',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Carte mnémotechnique "Le sais-tu ?"
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBE6E6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF0C4C4)),
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
                                funFactTitle,
                                style: AmaniTheme.titleStyle.copyWith(
                                  fontSize: 14,
                                  color: const Color(0xFFB85454),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                funFactBody,
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

                  // Carte "Astuces" : formules de périmètre et d'aire.
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFBBDEFB)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('📐', style: TextStyle(fontSize: 26)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (cf['astuceTitle'] ?? 'Astuces').toString(),
                                style: AmaniTheme.titleStyle.copyWith(
                                  fontSize: 14,
                                  color: const Color(0xFF1565C0),
                                ),
                              ),
                              const SizedBox(height: 8),
                              _FormulaLine(
                                label: (cf['perimeterLabel'] ?? 'Périmètre')
                                    .toString(),
                                formula: perimeterFormula,
                              ),
                              const SizedBox(height: 4),
                              _FormulaLine(
                                label: (cf['areaLabel'] ?? 'Aire').toString(),
                                formula: areaFormula,
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

/// Une ligne "Label : formule" de la carte "Astuces" — label en gras
/// (`AmaniTheme.bodyStyle`), formule en dessous dans une pastille blanche
/// pour bien la distinguer du texte courant, comme une valeur mise en
/// évidence plutôt qu'une simple suite de mots.
class _FormulaLine extends StatelessWidget {
  final String label;
  final String formula;

  const _FormulaLine({required this.label, required this.formula});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AmaniTheme.bodyStyle.copyWith(
            fontSize: 12,
            color: AmaniColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            formula,
            style: TextStyle(
              fontFamily: kBalooFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ),
      ],
    );
  }
}
