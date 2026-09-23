import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../services/progress_service.dart';
import '../data/sign_exercise_catalog.dart';
import '../data/flores_gong_nota.dart';
import '../widgets/sign_glyph.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../utils/navigation_helpers.dart';

/// Leçon d'ouverture du Palier 1 "Les Signes de base", avant le premier
/// signe (le trait) : présente les quatre signes fondamentaux de la méthode
/// Flores Gong Nota (trait vertical, crochet haut-droit, cercle fermé,
/// point) puis le texte institutionnel qui justifie la démarche (UNESCO,
/// Francophonie, acquisition en 21 jours). Contenu French-only, sur le même
/// principe que le Palier "Les Calculs" -- voir `parcours_screen.dart`, où
/// cette étape n'est générée que pour `Lang.fr`.
///
/// Ne comporte aucun tracé : simple étape d'information, marquée acquise dès
/// la première consultation (voir [_onActivated]), pour ne bloquer la
/// progression que le temps de sa lecture.
const List<String> kSignesIntroIds = [
  'trait-vertical-full',
  'crochet-top-right-full',
  'courbe-closed-full',
  'point-center-full',
];

class CoursSignesIntroScreen extends StatefulWidget {
  const CoursSignesIntroScreen({super.key});

  @override
  State<CoursSignesIntroScreen> createState() =>
      _CoursSignesIntroScreenState();
}

class _CoursSignesIntroScreenState extends State<CoursSignesIntroScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onActivated());
  }

  void _onActivated() {
    if (!mounted) return;
    context.read<ProgressProvider>().awardCompletion(
      typeEtape: 'SIGNE_INTRO',
      modalite: 'COURS',
      etapeCode: 'intro',
      palier: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final lang = context.watch<LanguageProvider>().lang;
    final csi = t['coursSignesIntro'] as Map<String, dynamic>? ?? {};
    final signNames = csi['signNames'] as Map<String, dynamic>? ?? {};
    final paragraphs = [
      csi['paragraph1'] ?? '',
      csi['paragraph2'] ?? '',
      csi['paragraph3'] ?? '',
    ];

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
                      csi['title'] ?? 'Les 4 signes de base',
                      style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context
                        .read<SignSpeechService>()
                        .speak(paragraphs.join(' '), lang),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AmaniColors.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Color(0x1F000000), blurRadius: 6),
                        ],
                      ),
                      child: const Icon(
                        LucideIcons.volume2,
                        size: 18,
                        color: AmaniColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Présentation des quatre signes de base.
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
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 18,
                      runSpacing: 18,
                      children: [
                        for (final id in kSignesIntroIds)
                          _SignePreview(
                            id: id,
                            label: signNames[id] as String? ?? '',
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  for (var i = 0; i < paragraphs.length; i++) ...[
                    _AstuceCard(text: paragraphs[i]),
                    if (i < paragraphs.length - 1) const SizedBox(height: 12),
                  ],
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

class _SignePreview extends StatelessWidget {
  final String id;
  final String label;
  const _SignePreview({required this.id, required this.label});

  @override
  Widget build(BuildContext context) {
    final entry = EXERCISE_MAP[id] as Map<String, dynamic>?;
    final family = SignFamily.values.firstWhere(
      (f) => f.name == entry?['family'],
      orElse: () => SignFamily.trait,
    );
    final variant = entry?['variant'] as String? ?? 'vertical';
    final stroke = STROKE_FAMILLE[entry?['family']] ?? AmaniColors.textPrimary;
    return SizedBox(
      width: 84,
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              color: AmaniColors.surface,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SignGlyph(
              family: family,
              variant: variant,
              stroke: stroke,
              strokeWidth: 10,
              size: 46,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AmaniTheme.bodyStyle.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AmaniColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Carte "astuce" -- même habillage que la carte "Le sais-tu ?" du Palier
/// "Figures géométriques" (`cours_figure_screen.dart`), réutilisé ici pour
/// présenter le texte institutionnel par paragraphes plutôt qu'en un seul
/// bloc.
class _AstuceCard extends StatelessWidget {
  final String text;
  const _AstuceCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBBDEFB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AmaniTheme.bodyStyle.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
