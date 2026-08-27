import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../services/progress_service.dart';
import '../data/calcul_catalog.dart';
import '../data/letter_style_resolver.dart';
import '../hooks/use_writing_style.dart';
import '../widgets/mini_letter_frame.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
      setState(() => _replaySeed = 0);
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

  void _speakConsigne(CalculTopic topic) {
    final lang = context.read<LanguageProvider>().lang;
    context.read<SignSpeechService>().speak(topic.mnemonicBody, lang);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final cc = t['coursCalcul'] as Map<String, dynamic>? ?? {};
    final common = t['common'] as Map<String, dynamic>? ?? {};
    final style = context.watch<WritingStyleProvider>().style.name;
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
                  onTap: () => context.go('/accueil'),
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

    // Un seul problème illustré sert de démonstration sur cette page — le
    // premier généré qui porte des objets à compter, sinon le tout premier.
    final demoProblems = topic.generateProblems(_replaySeed, 3);
    final demo = demoProblems.firstWhere(
      (p) => p.illustrateA != null,
      orElse: () => demoProblems.first,
    );
    final answerDigits = demo.answer
        .split('')
        .map((c) => getLetterFormation(c, style))
        .whereType<dynamic>()
        .toList();
    final answerDigitsSecond = demo.answerSecondPart
        ?.split('')
        .map((c) => getLetterFormation(c, style))
        .whereType<dynamic>()
        .toList();

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
                          topic.niveau,
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            letterSpacing: 1.2,
                            color: const Color(0xFF6B3F94),
                          ),
                        ),
                        Text(
                          topic.title,
                          style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
                        ),
                        Text(
                          topic.subtitle,
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
                  // Carte de démonstration : objets à compter (si présents)
                  // + équation + réponse animée chiffre par chiffre.
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
                        if (demo.illustrateA != null) ...[
                          _ObjectRow(count: demo.illustrateA!),
                          const SizedBox(height: 6),
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
                                for (final d in answerDigits) ...[
                                  MiniLetterFrame(letter: d, size: 52),
                                  const SizedBox(width: 4),
                                ],
                                if (answerDigitsSecond != null) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    demo.secondPartSeparator,
                                    style: TextStyle(
                                      fontFamily: kBalooFontFamily,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 22,
                                      color: AmaniColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  for (final d in answerDigitsSecond) ...[
                                    MiniLetterFrame(letter: d, size: 52),
                                    const SizedBox(width: 4),
                                  ],
                                ],
                              ],
                            ),
                          ],
                        ),
                        if (demo.illustrateB != null) ...[
                          const SizedBox(height: 10),
                          // Pour une soustraction, le second groupe
                          // représente ce qu'on enlève : jetons grisés
                          // plutôt que la même couleur que le premier
                          // groupe, pour bien illustrer la disparition.
                          _ObjectRow(
                            count: demo.illustrateB!,
                            color: demo.display.contains('-')
                                ? AmaniColors.disabled
                                : const Color(0xFF8B5FBF),
                          ),
                        ],
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
                                topic.mnemonicTitle,
                                style: AmaniTheme.titleStyle.copyWith(
                                  fontSize: 14,
                                  color: const Color(0xFF6B3F94),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                topic.mnemonicBody,
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
                          bg: const Color(0x1F6B3F94),
                          fg: const Color(0xFF3F2456),
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
                          onTap: () => _speakConsigne(topic),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Passe aux exercices — pas de "cours suivant" : l'enfant
                  // doit s'entraîner avant de continuer, comme pour les
                  // autres paliers récents (Mots, Syllabes).
                  GestureDetector(
                    onTap: () =>
                        context.push('/exercice/calcul/${topic.id}'),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5FBF),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x338B5FBF),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cc['practice'] ?? "S'entrainer",
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

/// Rangée d'objets à compter (jetons colorés) — utilisée uniquement pour les
/// tout premiers problèmes de CP, où le sens du symbole "+" prime sur le
/// calcul abstrait.
class _ObjectRow extends StatelessWidget {
  final int count;
  final Color color;
  const _ObjectRow({required this.count, this.color = const Color(0xFF8B5FBF)});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        for (var i = 0; i < count; i++)
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
      ],
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
