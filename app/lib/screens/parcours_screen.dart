import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../i18n/translations.dart';
import '../theme/amani_theme.dart';
import '../widgets/amani_mascot.dart';
import '../data/palier2_groups.dart';
import '../data/word_catalog.dart';
import '../data/syllable_catalog.dart';
import '../data/calcul_catalog.dart';
import '../data/shape_catalog.dart';
import '../data/tangram_catalog.dart';
import '../data/sign_exercise_catalog.dart' show FAMILY_ORDER;
import '../utils/text_case.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

const String _bonusRibbonSvg = 'M6 16 H34 L30 34 H10 Z M10 22 H30 M12 28 H28';
const String _bonusArcSvg = 'M12 16 C14 8 26 8 28 16';

/// Ordre des niveaux du Palier "Les Calculs" — sert à retrouver l'index de
/// niveau (0=CP … 4=CM2) d'un [CalculTopic] sans dépendre d'un nombre fixe
/// de sujets par niveau (variable depuis l'ajout des tables de
/// multiplication, une par une, en CE1).
const List<String> _calculNiveaux = ['CP', 'CE1', 'CE2', 'CM1', 'CM2'];

enum StepKind {
  active,
  locked,
  bonus,
  wordsearch,
  vraiFaux,
  composeNombre,
  figureQuiz,
  figureVraiFaux,
  figureObjet,
  medal,
  header,
}

class Step {
  final StepKind kind;
  final String? iconType; // "feuille" | "branche"
  final String? title;
  final String? subtitle;
  final String? tagline;
  final int? palierNum;
  final Color? bannerBg;
  final Color? bannerBorder;
  final IconData? bannerIcon;

  const Step({
    required this.kind,
    this.iconType,
    this.title,
    this.subtitle,
    this.tagline,
    this.palierNum,
    this.bannerBg,
    this.bannerBorder,
    this.bannerIcon,
  });
}

class StepEntry {
  final Step step;
  final int side; // -1, 0, 1
  final String? to;
  Color? color;
  Color? borderColor;
  int? number;

  StepEntry(this.step, this.side, {this.to});
}

class ParcoursScreen extends StatefulWidget {
  /// Numéro de palier (1-6, voir `awardCompletion(palier: ...)`) vers lequel
  /// défiler au premier affichage — utilisé au retour d'une évaluation de
  /// fin de palier réussie, pour amener directement l'enfant au palier
  /// suivant plutôt que de le laisser en haut de la liste.
  final int? scrollToPalier;

  const ParcoursScreen({super.key, this.scrollToPalier});

  @override
  State<ParcoursScreen> createState() => _ParcoursScreenState();
}

class _ParcoursScreenState extends State<ParcoursScreen> {
  int _activeStepIdx = 1;
  final ScrollController _scrollController = ScrollController();

  /// Une ancre stable par numéro de palier (1-6), posée sur la bannière
  /// d'en-tête correspondante (`_PalierBanner`) — permet de défiler jusqu'à
  /// un palier précis via `Scrollable.ensureVisible` sans calcul d'offset
  /// manuel. Un palier absent pour la langue active (Syllabes/Calculs,
  /// français uniquement) n'est simplement jamais attaché : le défilement
  /// est alors silencieusement ignoré plutôt que de planter.
  final Map<int, GlobalKey> _palierKeys = {
    for (var i = 1; i <= 6; i++) i: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _loadActiveStep();
    if (widget.scrollToPalier != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToPalier());
    }
  }

  void _scrollToPalier() {
    final key = _palierKeys[widget.scrollToPalier];
    final ctx = key?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }

  Future<void> _loadActiveStep() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt('accueil_current_step_idx');
    if (saved != null && mounted) {
      setState(() => _activeStepIdx = saved);
    }
  }

  Future<void> _activate(int index) async {
    setState(() => _activeStepIdx = index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accueil_current_step_idx', index);
  }

  void _onStepTap(int index, String? to, Map<String, dynamic> t) {
    _activate(index);
    if (to != null) {
      context.push(to);
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AmaniColors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 96),
        content: Text(
          t['parcours']?['comingSoon'] ?? 'Cette étape arrive bientôt !',
          style: TextStyle(
            fontFamily: kBalooFontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  List<StepEntry> _buildSteps(Map<String, dynamic> t, Lang lang) {
    final paliers = (t['parcours']?['paliers'] as List?) ?? [];
    String pal(int i, String key) =>
        (paliers.length > i ? paliers[i][key] : null) ?? '';
    final palier2Groups = getPalier2Groups(lang.name);

    final steps = <StepEntry>[
      // ─── PALIER 1 : Les Signes de base ───
      StepEntry(
        Step(
          kind: StepKind.header,
          title: pal(0, 'title'),
          subtitle: pal(0, 'subtitle'),
          tagline: pal(0, 'tagline'),
          palierNum: 1,
          bannerBg: const Color(0xFF8FBF6F),
          bannerBorder: const Color(0xFF5E8E3E),
          bannerIcon: LucideIcons.leaf,
        ),
        0,
      ),
      StepEntry(
        const Step(kind: StepKind.active, iconType: 'feuille'),
        -1,
        to: '/cours/trait',
      ),
      StepEntry(
        const Step(kind: StepKind.active, iconType: 'branche'),
        1,
        to: '/exercice-liste?family=trait',
      ),
      StepEntry(
        const Step(kind: StepKind.locked, iconType: 'feuille'),
        -1,
        to: '/cours/crochet',
      ),
      StepEntry(
        const Step(kind: StepKind.locked, iconType: 'branche'),
        1,
        to: '/exercice-liste?family=crochet',
      ),
      StepEntry(
        const Step(kind: StepKind.locked, iconType: 'feuille'),
        -1,
        to: '/cours/courbe',
      ),
      StepEntry(
        const Step(kind: StepKind.locked, iconType: 'branche'),
        1,
        to: '/exercice-liste?family=courbe',
      ),
      StepEntry(
        const Step(kind: StepKind.locked, iconType: 'feuille'),
        -1,
        to: '/cours/point',
      ),
      StepEntry(
        const Step(kind: StepKind.locked, iconType: 'branche'),
        1,
        to: '/exercice-liste?family=point',
      ),
      StepEntry(
        const Step(kind: StepKind.medal),
        0,
        to: '/exercice-liste?family=${FAMILY_ORDER[0]}&amaniEval=1',
      ),

      // ─── PALIER 2 : Combinatoire ───
      StepEntry(
        Step(
          kind: StepKind.header,
          title: pal(1, 'title'),
          subtitle: pal(1, 'subtitle'),
          tagline: pal(1, 'tagline'),
          palierNum: 2,
          bannerBg: const Color(0xFFA9784F),
          bannerBorder: const Color(0xFF7A5332),
          bannerIcon: LucideIcons.penLine,
        ),
        0,
      ),
    ];

    for (var idx = 0; idx < palier2Groups.length; idx++) {
      final kind = idx == 0 ? StepKind.active : StepKind.locked;
      final group = palier2Groups[idx];
      steps.add(
        StepEntry(
          Step(kind: kind, iconType: 'feuille'),
          -1,
          to: '/cours/lettres/formation/${group.chars.first}?pg=${group.id}',
        ),
      );
      steps.add(
        StepEntry(
          Step(kind: kind, iconType: 'branche'),
          1,
          to: '/exercice-liste?group=${group.id}',
        ),
      );
    }
    steps.add(
      StepEntry(
        const Step(kind: StepKind.medal),
        0,
        to: '/exercice/lettre/${palier2Groups[0].chars.first}?pg=${palier2Groups[0].id}&amaniEval=1',
      ),
    );

    // ─── PALIER 3 : Les Syllabes (français uniquement — méthode de lecture
    // "consonne + voyelle" spécifique au français) ───
    if (lang == Lang.fr) {
      steps.add(
        StepEntry(
          Step(
            kind: StepKind.header,
            title: pal(2, 'title'),
            subtitle: pal(2, 'subtitle'),
            tagline: pal(2, 'tagline'),
            palierNum: 3,
            bannerBg: const Color(0xFFD07A04),
            bannerBorder: const Color(0xFFA25F03),
            bannerIcon: LucideIcons.bookOpen,
          ),
          0,
        ),
      );

      for (var idx = 0; idx < SYLLABLE_GROUPS.length; idx++) {
        final kind = idx == 0 ? StepKind.active : StepKind.locked;
        final group = SYLLABLE_GROUPS[idx] as Map<String, dynamic>;
        steps.add(
          StepEntry(
            Step(kind: kind, iconType: 'feuille'),
            -1,
            to: '/cours/syllabes/${group['consonant']}',
          ),
        );
        steps.add(
          StepEntry(
            Step(kind: kind, iconType: 'branche'),
            1,
            to: '/exercice/syllabes/${group['consonant']}',
          ),
        );
      }
      final firstConsonant =
          (SYLLABLE_GROUPS.first as Map<String, dynamic>)['consonant'];
      steps.add(
        StepEntry(
          const Step(kind: StepKind.medal),
          0,
          to: '/exercice/syllabes/$firstConsonant?amaniEval=1',
        ),
      );
    }

    // ─── PALIER 3/4 : Les Mots (numéro 4 seulement si le palier Syllabes
    // précède, c'est-à-dire en français) ───
    steps.add(
      StepEntry(
        Step(
          kind: StepKind.header,
          title: pal(3, 'title'),
          subtitle: pal(3, 'subtitle'),
          tagline: pal(3, 'tagline'),
          palierNum: lang == Lang.fr ? 4 : 3,
          bannerBg: const Color(0xFF4A90E2),
          bannerBorder: const Color(0xFF2D6BBF),
          bannerIcon: LucideIcons.bookOpen,
        ),
        0,
      ),
    );

    for (var idx = 0; idx < PALIER3_GROUPS.length; idx++) {
      final kind = idx == 0 ? StepKind.active : StepKind.locked;
      final group = PALIER3_GROUPS[idx];
      steps.add(
        StepEntry(
          Step(kind: kind, iconType: 'feuille'),
          -1,
          to: '/cours/mots/${group.id}',
        ),
      );
      steps.add(
        StepEntry(
          Step(kind: kind, iconType: 'branche'),
          1,
          to: '/exercice/mots/${group.id}',
        ),
      );
      if (idx % 2 == 1) {
        final levelIdx = (idx - 1) ~/ 2;
        if (levelIdx < PALIER3_WORD_PUZZLE_LEVELS.length) {
          final level = PALIER3_WORD_PUZZLE_LEVELS[levelIdx];
          steps.add(
            StepEntry(
              const Step(kind: StepKind.wordsearch),
              0,
              to: '/exercice/mots-meles/lvl$level',
            ),
          );
        }
      }
    }
    steps.add(
      StepEntry(
        const Step(kind: StepKind.medal),
        0,
        to: '/exercice/mots/${PALIER3_GROUPS[0].id}?amaniEval=1',
      ),
    );

    // ─── PALIER 5 : Les Calculs (français uniquement — nomenclature CP/CE1/
    // CE2/CM1/CM2 propre au système scolaire français) ───
    if (lang == Lang.fr) {
      steps.add(
        StepEntry(
          Step(
            kind: StepKind.header,
            title: pal(4, 'title'),
            subtitle: pal(4, 'subtitle'),
            tagline: pal(4, 'tagline'),
            palierNum: 5,
            bannerBg: const Color(0xFF8B5FBF),
            bannerBorder: const Color(0xFF6B3F94),
            bannerIcon: LucideIcons.calculator,
          ),
          0,
        ),
      );

      for (var idx = 0; idx < CALCUL_TOPICS.length; idx++) {
        final kind = idx == 0 ? StepKind.active : StepKind.locked;
        final topic = CALCUL_TOPICS[idx];
        steps.add(
          StepEntry(
            Step(kind: kind, iconType: 'feuille'),
            -1,
            to: '/cours/calcul/${topic.id}',
          ),
        );
        steps.add(
          StepEntry(
            Step(kind: kind, iconType: 'branche'),
            1,
            to: '/exercice/calcul/${topic.id}',
          ),
        );
        final isLastOfNiveau =
            idx == CALCUL_TOPICS.length - 1 ||
            CALCUL_TOPICS[idx + 1].niveau != topic.niveau;
        if (isLastOfNiveau) {
          final niveauIdx = _calculNiveaux.indexOf(topic.niveau);
          steps.add(
            StepEntry(
              const Step(kind: StepKind.vraiFaux),
              0,
              to: '/exercice/calcul-vrai-faux/$niveauIdx',
            ),
          );
          steps.add(
            StepEntry(
              const Step(kind: StepKind.composeNombre),
              0,
              to: '/exercice/calcul-compose/$niveauIdx',
            ),
          );
        }
      }
      steps.add(
        StepEntry(
          const Step(kind: StepKind.medal),
          0,
          to: '/exercice/calcul/${CALCUL_TOPICS[0].id}?amaniEval=1',
        ),
      );
    }

    // ─── PALIER 6 : Les Figures géométriques (vocabulaire universel, pas
    // lié au système scolaire français — disponible dans les 4 langues,
    // contrairement à Syllabes/Calculs) ───
    final figuresPalier =
        t['parcours']?['figuresPalier'] as Map<String, dynamic>?;
    steps.add(
      StepEntry(
        Step(
          kind: StepKind.header,
          title: figuresPalier?['title'] ?? '',
          subtitle: figuresPalier?['subtitle'] ?? '',
          tagline: figuresPalier?['tagline'] ?? '',
          palierNum: 6,
          bannerBg: const Color(0xFFE07A7A),
          bannerBorder: const Color(0xFFB85454),
          bannerIcon: LucideIcons.shapes,
        ),
        0,
      ),
    );

    for (var idx = 0; idx < SHAPE_TOPICS.length; idx++) {
      final kind = idx == 0 ? StepKind.active : StepKind.locked;
      final topic = SHAPE_TOPICS[idx];
      steps.add(
        StepEntry(
          Step(kind: kind, iconType: 'feuille'),
          -1,
          to: '/cours/figure/${topic.id}',
        ),
      );
      steps.add(
        StepEntry(
          Step(kind: kind, iconType: 'branche'),
          1,
          to: '/exercice/figure/${topic.id}',
        ),
      );
    }
    final tangramSimple = tangramPuzzlesByDifficulty(TangramDifficulty.simple);
    for (var idx = 0; idx < tangramSimple.length; idx++) {
      const kind = StepKind.locked;
      final puzzle = tangramSimple[idx];
      steps.add(
        StepEntry(
          const Step(kind: kind, iconType: 'feuille'),
          -1,
          to: '/cours/tangram/${puzzle.id}',
        ),
      );
      steps.add(
        StepEntry(
          const Step(kind: kind, iconType: 'branche'),
          1,
          to: '/exercice/tangram/${puzzle.id}',
        ),
      );
    }
    steps.add(
      StepEntry(
        const Step(kind: StepKind.figureQuiz),
        0,
        to: '/exercice/figure-quiz',
      ),
    );
    steps.add(
      StepEntry(
        const Step(kind: StepKind.figureVraiFaux),
        0,
        to: '/exercice/figure-vrai-faux',
      ),
    );
    steps.add(
      StepEntry(
        const Step(kind: StepKind.figureObjet),
        0,
        to: '/exercice/figure-objet',
      ),
    );
    steps.add(
      StepEntry(
        const Step(kind: StepKind.medal),
        0,
        to: '/exercice/figure/${SHAPE_TOPICS[0].id}?amaniEval=1',
      ),
    );

    // Chaque étape hérite de la couleur du dernier en-tête de palier rencontré.
    // Numérotation continue de toutes les étapes (hors en-têtes de palier),
    // pour le petit badge rappelant la position dans le parcours. Les étapes
    // bonus/médaille n'affichent jamais ce badge (voir les branches
    // `StepKind.bonus`/`StepKind.medal` du switch de rendu plus bas) : on ne
    // leur attribue donc pas non plus de numéro, pour que la suite visible
    // de numéros reste toujours consécutive (sans ce saut, une étape bonus
    // ou médaille "consommait" un numéro jamais affiché, créant un trou
    // visible dans la séquence).
    Color currentColor = const Color(0xFF8FBF6F);
    Color currentBorder = const Color(0xFF5E8E3E);
    int stepNumber = 0;
    for (final entry in steps) {
      if (entry.step.kind == StepKind.header) {
        currentColor = entry.step.bannerBg ?? currentColor;
        currentBorder = entry.step.bannerBorder ?? currentBorder;
      } else {
        entry.color = currentColor;
        entry.borderColor = currentBorder;
        if (entry.step.kind != StepKind.bonus &&
            entry.step.kind != StepKind.medal) {
          stepNumber += 1;
          entry.number = stepNumber;
        }
      }
    }

    return steps;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final lang = context.watch<LanguageProvider>().lang;
    final steps = _buildSteps(t, lang);
    final nonHeaderCount = steps
        .where((s) => s.step.kind != StepKind.header)
        .length;
    final turns = math.max(8, (nonHeaderCount / 2).ceil());

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AmaniColors.background, AmaniColors.backgroundAlt],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête de page
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t['parcours']?['title'] ?? '',
                            style: AmaniTheme.titleStyle.copyWith(
                              fontSize: 24,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            t['parcours']?['subtitle'] ?? '',
                            style: AmaniTheme.bodyStyle.copyWith(
                              color: AmaniColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const AmaniMascot(
                      pose: AmaniPose.encouragement,
                      size: AmaniSize.small,
                    ),
                  ],
                ),
              ),

              // Chemin en zigzag
              LayoutBuilder(
                builder: (context, constraints) {
                  final width =
                      constraints.maxWidth - 48; // padding horizontal 24+24
                  const stepHeight = 62.0;
                  final pathHeight = turns * stepHeight + 40;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _ZigzagPainter(
                              turns: turns,
                              stepHeight: stepHeight,
                              width: width,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            for (int i = 0; i < steps.length; i++)
                              _StepRow(
                                entry: steps[i],
                                index: i,
                                width: width,
                                isCurrent: i == _activeStepIdx,
                                t: t,
                                onTap: () => _onStepTap(i, steps[i].to, t),
                                anchorKey: steps[i].step.kind == StepKind.header
                                    ? _palierKeys[steps[i].step.palierNum]
                                    : null,
                              ),
                            SizedBox(height: pathHeight * 0.05 + 8),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Trace le chemin reliant les étapes non pas par un simple pointillé mais
/// par une piste de petites empreintes de pas alternées (gauche/droite),
/// façon sentier — même géométrie en zigzag (courbes de Bézier quadratiques
/// entre un point de contrôle gauche et un point de contrôle droit,
/// alternés à chaque tour) qu'auparavant, seul le style du tracé change.
class _ZigzagPainter extends CustomPainter {
  final int turns;
  final double stepHeight;
  final double width;

  _ZigzagPainter({
    required this.turns,
    required this.stepHeight,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = width / 2;
    final leftX = width * 0.2;
    final rightX = width * 0.8;

    // Le tracé n'a de sens que sur `turns` tours (une estimation à partir du
    // nombre d'étapes), mais la colonne réelle des étapes peut être
    // légèrement plus haute ou plus basse selon la mise en page effective —
    // on construit directement le chemin à l'échelle finale (plutôt que de
    // le dessiner "nature" puis d'appliquer un `canvas.scale` non-uniforme,
    // qui déformerait chaque empreinte) pour qu'il couvre exactement toute
    // la hauteur réservée, jusqu'à la dernière étape.
    final naturalHeight = 20 + turns * stepHeight;
    final vScale = (naturalHeight > 0 && size.height > 0)
        ? size.height / naturalHeight
        : 1.0;
    final scaledStepHeight = stepHeight * vScale;

    final path = Path();
    double y = 20 * vScale;
    path.moveTo(centerX, y);
    for (var i = 0; i < turns; i++) {
      final controlX = i.isEven ? leftX : rightX;
      final endY = y + scaledStepHeight;
      path.quadraticBezierTo(controlX, y + scaledStepHeight / 2, centerX, endY);
      y = endY;
    }

    final footColor = const Color(0xFF000000).withValues(alpha: 0.32);
    const stepDistance = 22.0; // écart entre deux empreintes le long du sentier
    const strideOffset = 4.5; // écart latéral gauche/droite (démarche)

    var stepIndex = 0;
    for (final metric in path.computeMetrics()) {
      var distance = 6.0;
      while (distance < metric.length) {
        final tangent = metric.getTangentForOffset(distance);
        if (tangent != null) {
          final angle = tangent.vector.direction;
          _drawFootprint(
            canvas,
            tangent.position,
            angle,
            stepIndex.isEven,
            footColor,
            strideOffset,
          );
          stepIndex++;
        }
        distance += stepDistance;
      }
    }
  }

  /// Empreinte façon patte d'animal (un gros coussinet principal + 4
  /// coussinets d'orteils en éventail devant) — reprend le style de
  /// l'image de référence fournie par l'utilisateur, plutôt qu'une simple
  /// semelle de chaussure. L'axe local +X (après rotation par [angle])
  /// pointe dans le sens de la marche : le coussinet principal reste en
  /// arrière, les orteils en éventail devant.
  void _drawFootprint(
    Canvas canvas,
    Offset center,
    double angle,
    bool isLeft,
    Color color,
    double strideOffset,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.translate(0, (isLeft ? -1 : 1) * strideOffset);

    final pad = Paint()..color = color;

    // Coussinet principal : ovale légèrement aplati, en arrière.
    canvas.save();
    canvas.translate(-3.5, 0);
    canvas.rotate(0.05);
    canvas.scale(1.15, 0.9);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 8.5, height: 7.5),
      pad,
    );
    canvas.restore();

    // 4 coussinets d'orteils en éventail devant, chacun légèrement pivoté
    // pour évoquer des doigts qui s'écartent.
    const toeOffsets = [
      Offset(4.6, -4.4),
      Offset(6.6, -1.6),
      Offset(6.6, 1.6),
      Offset(4.6, 4.4),
    ];
    const toeAngles = [-0.7, -0.25, 0.25, 0.7];
    for (var i = 0; i < 4; i++) {
      canvas.save();
      canvas.translate(toeOffsets[i].dx, toeOffsets[i].dy);
      canvas.rotate(toeAngles[i]);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: 4.2, height: 2.8),
        pad,
      );
      canvas.restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ZigzagPainter oldDelegate) =>
      oldDelegate.turns != turns ||
      oldDelegate.width != width ||
      oldDelegate.stepHeight != stepHeight;
}

class _StepRow extends StatelessWidget {
  final StepEntry entry;
  final int index;
  final double width;
  final bool isCurrent;
  final Map<String, dynamic> t;
  final VoidCallback? onTap;

  /// Ancre stable posée sur la bannière (voir `_ParcoursScreenState._palierKeys`),
  /// non `null` uniquement pour une entrée d'en-tête de palier.
  final GlobalKey? anchorKey;

  const _StepRow({
    required this.entry,
    required this.index,
    required this.width,
    required this.isCurrent,
    required this.t,
    this.onTap,
    this.anchorKey,
  });

  @override
  Widget build(BuildContext context) {
    final step = entry.step;

    if (step.kind == StepKind.header) {
      return KeyedSubtree(
        key: anchorKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: _PalierBanner(step: step),
        ),
      );
    }

    final offset = entry.side * (width * 0.22);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Align(
        alignment: Alignment.topCenter,
        child: Transform.translate(
          offset: Offset(offset, 0),
          child: GestureDetector(
            onTap: onTap,
            child: _StepNode(
              step: step,
              isCurrent: isCurrent,
              color: entry.color ?? AmaniColors.secondary,
              borderColor: entry.borderColor ?? AmaniColors.secondaryDark,
              number: entry.number,
              t: t,
            ),
          ),
        ),
      ),
    );
  }
}

class _PalierBanner extends StatelessWidget {
  final Step step;
  const _PalierBanner({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            step.bannerBg ?? AmaniColors.secondary,
            step.bannerBorder ?? AmaniColors.secondaryDark,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: step.bannerBorder ?? AmaniColors.secondaryDark,
            offset: const Offset(0, 6),
          ),
          const BoxShadow(
            color: Color(0x384A3B2A),
            offset: Offset(0, 10),
            blurRadius: 24,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -16,
            top: -24,
            child: Opacity(
              opacity: 0.2,
              child: Transform.rotate(
                angle: 0.2,
                child: const Icon(
                  LucideIcons.leaf,
                  size: 96,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Icon(
                  step.bannerIcon ?? LucideIcons.leaf,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      capitalizeFirst(step.subtitle ?? ''),
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 1.4,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      step.title ?? '',
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w800,
                        fontSize: 19,
                        height: 1.15,
                        color: Colors.white,
                      ),
                    ),
                    if ((step.tagline ?? '').isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          step.tagline!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${step.palierNum ?? ''}',
                  style: TextStyle(
                    fontFamily: kBalooFontFamily,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepNode extends StatefulWidget {
  final Step step;
  final bool isCurrent;
  final Color color;
  final Color borderColor;
  final int? number;
  final Map<String, dynamic> t;

  const _StepNode({
    required this.step,
    required this.isCurrent,
    required this.color,
    required this.borderColor,
    this.number,
    required this.t,
  });

  @override
  State<_StepNode> createState() => _StepNodeState();
}

class _StepNodeState extends State<_StepNode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pingController;

  @override
  void initState() {
    super.initState();
    _pingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _pingController.dispose();
    super.dispose();
  }

  String get _stepLabel {
    final parcours = widget.t['parcours'] as Map<String, dynamic>? ?? {};
    if (widget.step.kind == StepKind.wordsearch) {
      return parcours['wordSearchStep'] ?? '';
    }
    if (widget.step.kind == StepKind.vraiFaux) {
      return parcours['vraiFauxStep'] ?? '';
    }
    if (widget.step.kind == StepKind.composeNombre) {
      return parcours['composeStep'] ?? '';
    }
    if (widget.step.kind == StepKind.figureQuiz) {
      return parcours['figureQuizStep'] ?? '';
    }
    if (widget.step.kind == StepKind.figureVraiFaux) {
      return parcours['figureVraiFauxStep'] ?? '';
    }
    if (widget.step.kind == StepKind.figureObjet) {
      return parcours['figureObjetStep'] ?? '';
    }
    if (widget.step.iconType == 'branche') {
      return parcours['exerciceStep'] ?? '';
    }
    return parcours['coursStep'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final parcours = widget.t['parcours'] as Map<String, dynamic>? ?? {};

    switch (widget.step.kind) {
      case StepKind.header:
        return const SizedBox.shrink();

      case StepKind.active:
      case StepKind.locked:
        final bool bigNode =
            widget.step.kind == StepKind.active || widget.isCurrent;
        final double dim = bigNode ? 96 : 64;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isCurrent)
              _StartPill(
                borderColor: widget.borderColor,
                label: parcours['start'] ?? 'Commencer',
              ),
            if (widget.isCurrent) const SizedBox(height: 10),
            SizedBox(
              width: dim + 24,
              height: dim + 24,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  if (widget.isCurrent)
                    _PingRing(
                      controller: _pingController,
                      color: widget.color,
                      size: dim,
                    ),
                  if (widget.isCurrent)
                    _CurrentSparkles(color: widget.borderColor),
                  Container(
                    width: dim,
                    height: dim,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bigNode ? widget.color : AmaniColors.disabled,
                      border: Border.all(
                        color: bigNode
                            ? widget.borderColor
                            : AmaniColors.disabled,
                        width: 4,
                      ),
                      boxShadow: AmaniShadows.card,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      widget.step.iconType == 'branche'
                          ? LucideIcons.pen
                          : LucideIcons.bookOpen,
                      size: bigNode
                          ? (widget.step.iconType == 'branche' ? 38 : 40)
                          : (widget.step.iconType == 'branche' ? 24 : 26),
                      color: bigNode
                          ? Colors.white
                          : AmaniColors.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                  if (widget.number != null)
                    Positioned(
                      // Le cercle est centré dans une boîte 24px plus grande
                      // (padding uniforme de 12px de chaque côté, pour la
                      // marge du ping-ring) : le badge se cale sur le coin
                      // haut-droit du cercle, décalé de 4px vers l'extérieur
                      // — mêmes proportions que "-top-1 -right-1" en React.
                      top: 8,
                      right: 8,
                      child: _NumberBadge(
                        number: widget.number!,
                        color: widget.borderColor,
                        muted: !widget.isCurrent,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              capitalizeFirst(_stepLabel),
              style: TextStyle(
                fontFamily: kBalooFontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 11,
                letterSpacing: 0.6,
                color: bigNode
                    ? Colors.black
                    : AmaniColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        );

      case StepKind.wordsearch:
        final bool bigWs = widget.isCurrent;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isCurrent)
              _StartPill(
                borderColor: widget.borderColor,
                label: parcours['start'] ?? 'Commencer',
              ),
            if (widget.isCurrent) const SizedBox(height: 10),
            Stack(
              clipBehavior: Clip.none,
              children: [
                if (widget.isCurrent)
                  _CurrentSparkles(color: widget.borderColor),
                Container(
                  width: bigWs ? 80 : 56,
                  height: bigWs ? 80 : 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: bigWs ? widget.color : AmaniColors.disabled,
                    border: Border.all(
                      color: bigWs ? widget.borderColor : AmaniColors.disabled,
                      width: 4,
                    ),
                    boxShadow: AmaniShadows.card,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    LucideIcons.search,
                    size: bigWs ? 36 : 24,
                    color: bigWs
                        ? Colors.white
                        : AmaniColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
                if (widget.number != null)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: _NumberBadge(
                      number: widget.number!,
                      color: widget.borderColor,
                      muted: !widget.isCurrent,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              capitalizeFirst(_stepLabel),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: kBalooFontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 11,
                color: bigWs
                    ? widget.borderColor
                    : AmaniColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        );

      case StepKind.vraiFaux:
      case StepKind.composeNombre:
      case StepKind.figureQuiz:
      case StepKind.figureVraiFaux:
      case StepKind.figureObjet:
        final bool bigGame = widget.isCurrent;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isCurrent)
              _StartPill(
                borderColor: widget.borderColor,
                label: parcours['start'] ?? 'Commencer',
              ),
            if (widget.isCurrent) const SizedBox(height: 10),
            Stack(
              clipBehavior: Clip.none,
              children: [
                if (widget.isCurrent)
                  _CurrentSparkles(color: widget.borderColor),
                Container(
                  width: bigGame ? 80 : 56,
                  height: bigGame ? 80 : 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: bigGame ? widget.color : AmaniColors.disabled,
                    border: Border.all(
                      color: bigGame
                          ? widget.borderColor
                          : AmaniColors.disabled,
                      width: 4,
                    ),
                    boxShadow: AmaniShadows.card,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    switch (widget.step.kind) {
                      StepKind.vraiFaux ||
                      StepKind.figureVraiFaux => LucideIcons.helpCircle,
                      StepKind.figureQuiz => LucideIcons.shapes,
                      StepKind.figureObjet => LucideIcons.smile,
                      _ => LucideIcons.puzzle,
                    },
                    size: bigGame ? 36 : 24,
                    color: bigGame
                        ? Colors.white
                        : AmaniColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
                if (widget.number != null)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: _NumberBadge(
                      number: widget.number!,
                      color: widget.borderColor,
                      muted: !widget.isCurrent,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              capitalizeFirst(_stepLabel),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: kBalooFontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 11,
                color: bigGame
                    ? widget.borderColor
                    : AmaniColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        );

      case StepKind.bonus:
        return Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AmaniColors.disabled,
            border: Border.all(color: AmaniColors.disabled, width: 4),
            boxShadow: AmaniShadows.card,
          ),
          alignment: Alignment.center,
          child: _SvgIcon(
            svg: '$_bonusRibbonSvg $_bonusArcSvg',
            viewBox: const Size(40, 40),
            size: 30,
            color: AmaniColors.textSecondary,
            fill: false,
          ),
        );

      case StepKind.medal:
        return Container(
          width: 80,
          height: 80,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AmaniColors.disabled,
            border: Border.all(color: AmaniColors.disabled, width: 4),
            boxShadow: AmaniShadows.card,
          ),
          child: Image.asset(
            'assets/images/amani-victoire-palier-badge.png',
            fit: BoxFit.cover,
          ),
        );
    }
  }
}

class _StartPill extends StatelessWidget {
  final Color borderColor;
  final String label;
  const _StartPill({required this.borderColor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
          decoration: BoxDecoration(
            color: AmaniColors.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: AmaniShadows.card,
          ),
          child: Text(
            capitalizeFirst(label),
            style: TextStyle(
              fontFamily: kBalooFontFamily,
              fontWeight: FontWeight.w800,
              fontSize: 13,
              letterSpacing: 0.6,
              color: Colors.black,
            ),
          ),
        ),
        Positioned(
          bottom: -5,
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                color: AmaniColors.surface,
                border: Border(
                  bottom: BorderSide(color: borderColor, width: 2),
                  right: BorderSide(color: borderColor, width: 2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PingRing extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  final double size;

  const _PingRing({
    required this.controller,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = Curves.easeOut.transform(controller.value);
        return Opacity(
          opacity: (1 - t).clamp(0.0, 1.0),
          child: Transform.scale(
            scale: 1 + t * 0.6,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.3),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Petit badge numéroté qui rappelle la position de l'étape dans le
/// parcours — port fidèle de `NumberBadge` (`_app.accueil.tsx`).
class _NumberBadge extends StatelessWidget {
  final int number;
  final Color color;
  final bool muted;

  const _NumberBadge({
    required this.number,
    required this.color,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = muted ? const Color(0xFF9C8F79) : color;
    // Diamètre assez large pour qu'un nombre à 3 chiffres (l'étape 100 et
    // au-delà) reste toujours entièrement lisible à l'intérieur du cercle,
    // pas seulement les nombres à 1-2 chiffres.
    final digits = '$number'.length;
    final size = digits >= 3 ? 32.0 : (digits == 2 ? 26.0 : 24.0);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AmaniColors.surface,
        border: Border.all(
          color: muted ? const Color(0xFFD8CCB8) : color,
          width: 2,
        ),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 2)],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            '$number',
            maxLines: 1,
            style: TextStyle(
              fontFamily: kBalooFontFamily,
              fontWeight: FontWeight.w800,
              fontSize: 11,
              color: c,
            ),
          ),
        ),
      ),
    );
  }
}

/// Quelques étincelles discrètes autour de l'étape en cours, pour un léger
/// effet ludique — port fidèle de `CurrentSparkles` (`_app.accueil.tsx`).
class _CurrentSparkles extends StatelessWidget {
  final Color color;
  const _CurrentSparkles({required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -12,
          left: -20,
          child: Transform.rotate(
            angle: -0.21,
            child: Icon(
              LucideIcons.sparkle,
              size: 14,
              color: color.withValues(alpha: 0.7),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: -24,
          child: Transform.rotate(
            angle: 0.31,
            child: Icon(
              LucideIcons.sparkle,
              size: 10,
              color: color.withValues(alpha: 0.5),
            ),
          ),
        ),
        Positioned(
          bottom: -4,
          left: -24,
          child: Transform.rotate(
            angle: 0.1,
            child: Icon(
              LucideIcons.sparkle,
              size: 8,
              color: color.withValues(alpha: 0.4),
            ),
          ),
        ),
      ],
    );
  }
}

class _SvgIcon extends StatelessWidget {
  final String svg;
  final Size viewBox;
  final double size;
  final Color color;
  final bool fill;

  const _SvgIcon({
    required this.svg,
    required this.viewBox,
    required this.size,
    required this.color,
    this.fill = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SvgPathPainter(
          svg: svg,
          viewBox: viewBox,
          color: color,
          fill: fill,
        ),
      ),
    );
  }
}

class _SvgPathPainter extends CustomPainter {
  final String svg;
  final Size viewBox;
  final Color color;
  final bool fill;

  _SvgPathPainter({
    required this.svg,
    required this.viewBox,
    required this.color,
    required this.fill,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(
      size.width / viewBox.width,
      size.height / viewBox.height,
    );
    canvas.save();
    canvas.translate(
      (size.width - viewBox.width * scale) / 2,
      (size.height - viewBox.height * scale) / 2,
    );
    canvas.scale(scale, scale);
    final path = parseSvgPathData(svg);
    final paint = Paint()
      ..color = color
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SvgPathPainter oldDelegate) =>
      oldDelegate.svg != svg || oldDelegate.color != color;
}
