import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../services/progress_service.dart';
import '../data/shape_catalog.dart';
import '../widgets/mini_letter_frame.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onTopicActivated());
  }

  @override
  void didUpdateWidget(covariant CoursFigureScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shapeId != widget.shapeId) {
      setState(() => _replaySeed = 0);
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
                      context.canPop() ? context.pop() : context.go('/accueil'),
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
                    child: Column(
                      children: [
                        MiniLetterFrame(
                          key: ValueKey('shape-$_replaySeed'),
                          letter: topic.traceData,
                          size: 140,
                          // Chaque côté doit se tracer entièrement avant que
                          // le suivant ne commence (pas de chevauchement),
                          // pour bien distinguer la formation figure par
                          // figure — contrairement aux lettres, où un léger
                          // chevauchement reste acceptable.
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
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _PillButton(
                          icon: LucideIcons.rotateCcw,
                          label: common['replay'] ?? 'Relancer',
                          bg: const Color(0x1FB85454),
                          fg: const Color(0xFF7A2E2E),
                          onTap: () => setState(() => _replaySeed++),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _PillButton(
                          icon: LucideIcons.volume2,
                          label: common['instruction'] ?? 'Consigne',
                          bg: AmaniColors.background,
                          fg: Colors.black,
                          onTap: () => _speakConsigne(topic, lang),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () => context.push('/exercice/figure/${topic.id}'),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                          Text(
                            cf['practice'] ?? "S'entrainer",
                            style: TextStyle(
                              fontFamily: kBalooFontFamily,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
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

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  const _PillButton({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: kBalooFontFamily,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: fg,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
