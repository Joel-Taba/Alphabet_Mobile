import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/progress_service.dart';
import '../data/solid3d_catalog.dart';
import '../widgets/directional_icon.dart';
import '../widgets/solid_fold_animation.dart';
import '../widgets/trace_controls_toolbar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../widgets/unbroken_text.dart';
import '../utils/navigation_helpers.dart';

class CoursSolideScreen extends StatefulWidget {
  final String solidId;
  const CoursSolideScreen({super.key, required this.solidId});

  @override
  State<CoursSolideScreen> createState() => _CoursSolideScreenState();
}

class _CoursSolideScreenState extends State<CoursSolideScreen> {
  /// Incrémenté par « Relancer » : rejoue l'animation depuis le patron à plat.
  int _replaySeed = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onTopicActivated());
  }

  void _onTopicActivated() {
    final topic = findSolid3DTopic(widget.solidId);
    if (topic == null || !mounted) return;
    context.read<ProgressProvider>().awardCompletion(
      typeEtape: 'SOLIDE',
      modalite: 'COURS',
      etapeCode: topic.id,
      palier: 6,
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final t = languageProvider.t;
    final lang = languageProvider.lang;
    final cs = t['coursSolide'] as Map<String, dynamic>? ?? {};
    final common = t['common'] as Map<String, dynamic>? ?? {};
    final topic = findSolid3DTopic(widget.solidId);

    if (topic == null) {
      return Scaffold(
        backgroundColor: AmaniColors.background,
        body: SafeArea(
          child: Center(
            child: GestureDetector(
              onTap: () => goHome(context),
              child: Text(cs['notFound'] ?? ''),
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
    final volumeFormula =
        topic.volumeFormula[lang.name] ?? topic.volumeFormula['fr']!;

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
                    child: UnbrokenText(
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
                  // Le solide en 3D : ses faces posées à plat, qui se
                  // replient une à une pour former la figure (rétabli le
                  // 2026-10-15 à la demande de l'utilisateur).
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: TraceControlsToolbar.heightFor(2),
                    ),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SolidFoldAnimation(
                            key: ValueKey(topic.id),
                            faces: topic.faces,
                            color: solidColor(topic.id),
                            replaySeed: _replaySeed,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: TraceControlsToolbar(
                            muteLabel: common['muteVoice'] ?? '',
                            unmuteLabel: common['unmuteVoice'] ?? '',
                            // Ce cours ne lit aucune consigne.
                            showMute: false,
                            actions: [
                              ToolbarAction(
                                icon: LucideIcons.rotateCcw,
                                label: common['replay'] ?? 'Relancer',
                                background: const Color(0x1FB85454),
                                foreground: const Color(0xFF7A2E2E),
                                onTap: () => setState(() => _replaySeed++),
                              ),
                              ToolbarAction(
                                icon: Icons.play_arrow_rounded,
                                label: cs['practice'] ?? "S'entrainer",
                                background: const Color(0xFFB85454),
                                foreground: Colors.white,
                                onTap: () => context.push(
                                  '/exercice/solide/${topic.id}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Carte "Définition"
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

                  // Carte "Astuces" : formule de volume.
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
                                (cs['astuceTitle'] ?? 'Astuce').toString(),
                                style: AmaniTheme.titleStyle.copyWith(
                                  fontSize: 14,
                                  color: const Color(0xFF1565C0),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                (cs['volumeLabel'] ?? 'Volume').toString(),
                                style: AmaniTheme.bodyStyle.copyWith(
                                  fontSize: 12,
                                  color: AmaniColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  volumeFormula,
                                  style: TextStyle(
                                    fontFamily: kBalooFontFamily,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: const Color(0xFF1A1A1A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          context.push('/exercice/solide/${topic.id}'),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(cs['practice'] ?? "S'entrainer"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB85454),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: TextStyle(
                          fontFamily: kBalooFontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
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
