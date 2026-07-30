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

/// Décomposition "flore" décorative de la branche d'exercice, port fidèle du
/// tracé SVG `BrancheExerciseIcon` (src/routes/_app.accueil.tsx).
const String _brancheIconSvg = '''
M 45,115 C 47,95 51,70 57,50 C 63,32 75,18 90,10
C 87,16 77,26 68,41 C 59,56 53,76 49,115 Z
M 50,78 C 41,64 32,51 22,35 C 20,43 27,53 36,67 C 42,74 46,79 50,78 Z
M 23,38 L 15,33 L 21,45 Z M 27,47 L 16,45 L 26,54 Z M 32,56 L 20,58 L 31,64 Z M 37,65 L 23,71 L 38,73 Z
M 26,38 L 35,34 L 29,46 Z M 32,50 L 42,44 L 35,57 Z M 39,61 L 48,55 L 42,67 Z
M 86,13 L 73,15 L 82,23 Z M 78,21 L 64,25 L 74,32 Z M 70,32 L 54,38 L 66,43 Z M 63,45 L 47,51 L 59,56 Z M 57,58 L 42,64 L 53,68 Z M 51,70 L 37,77 L 48,80 Z
M 81,19 L 90,23 L 77,29 Z M 73,30 L 86,35 L 69,41 Z M 65,42 L 80,48 L 62,53 Z M 58,54 L 72,61 L 55,65 Z M 52,66 L 66,72 L 49,76 Z
''';

const String _medalRibbonsSvg =
    'M11 22 C 8 18 8 12 12 10 M29 22 C 32 18 32 12 28 10';
const String _medalCheckSvg = 'M17 22 L20 25 L24 19';
const String _bonusRibbonSvg = 'M6 16 H34 L30 34 H10 Z M10 22 H30 M12 28 H28';
const String _bonusArcSvg = 'M12 16 C14 8 26 8 28 16';

enum StepKind { active, locked, bonus, crossword, medal, header }

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
  final bool showMascot;

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
    this.showMascot = false,
  });
}

class StepEntry {
  final Step step;
  final int side; // -1, 0, 1
  final String? to;
  Color? color;
  Color? borderColor;

  StepEntry(this.step, this.side, {this.to});
}

class ParcoursScreen extends StatefulWidget {
  const ParcoursScreen({super.key});

  @override
  State<ParcoursScreen> createState() => _ParcoursScreenState();
}

class _ParcoursScreenState extends State<ParcoursScreen> {
  static const List<int> _crosswordLevels = [2, 3, 4, 5, 6, 7, 8, 9, 10];

  int _activeStepIdx = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadActiveStep();
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
          style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  List<StepEntry> _buildSteps(Map<String, dynamic> t) {
    final paliers = (t['parcours']?['paliers'] as List?) ?? [];
    String pal(int i, String key) => (paliers.length > i ? paliers[i][key] : null) ?? '';

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
          bannerIcon: Icons.eco_rounded,
        ),
        0,
      ),
      StepEntry(const Step(kind: StepKind.active, iconType: 'feuille'), -1, to: '/cours/point'),
      StepEntry(const Step(kind: StepKind.active, iconType: 'branche'), 1, to: '/exercice-liste?family=point'),
      StepEntry(const Step(kind: StepKind.locked, iconType: 'feuille'), -1, to: '/cours/courbe'),
      StepEntry(const Step(kind: StepKind.locked, iconType: 'branche'), 1, to: '/exercice-liste?family=courbe'),
      StepEntry(const Step(kind: StepKind.locked, iconType: 'feuille'), -1, to: '/cours/crochet'),
      StepEntry(const Step(kind: StepKind.locked, iconType: 'branche'), 1, to: '/exercice-liste?family=crochet'),
      StepEntry(const Step(kind: StepKind.locked, iconType: 'feuille'), -1, to: '/cours/trait'),
      StepEntry(const Step(kind: StepKind.locked, iconType: 'branche'), 1, to: '/exercice-liste?family=trait'),
      StepEntry(const Step(kind: StepKind.medal, showMascot: true), 0, to: '/exercice-liste'),

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
          bannerIcon: Icons.edit_note_rounded,
        ),
        0,
      ),
    ];

    for (var idx = 0; idx < PALIER2_GROUPS.length; idx++) {
      final kind = idx == 0 ? StepKind.active : StepKind.locked;
      final group = PALIER2_GROUPS[idx];
      steps.add(StepEntry(Step(kind: kind, iconType: 'feuille'), -1, to: '/cours/lettres/formation/${group.chars.first}?pg=${group.id}'));
      steps.add(StepEntry(Step(kind: kind, iconType: 'branche'), 1, to: '/exercice-liste?group=${group.id}'));
    }
    steps.add(StepEntry(const Step(kind: StepKind.medal), 0, to: '/exercice'));

    // ─── PALIER 3 : Les Mots ───
    steps.add(StepEntry(
      Step(
        kind: StepKind.header,
        title: pal(2, 'title'),
        subtitle: pal(2, 'subtitle'),
        tagline: pal(2, 'tagline'),
        palierNum: 3,
        bannerBg: const Color(0xFF4A90E2),
        bannerBorder: const Color(0xFF2D6BBF),
        bannerIcon: Icons.menu_book_rounded,
      ),
      0,
    ));

    for (var idx = 0; idx < PALIER3_GROUPS.length; idx++) {
      final kind = idx == 0 ? StepKind.active : StepKind.locked;
      final group = PALIER3_GROUPS[idx];
      steps.add(StepEntry(Step(kind: kind, iconType: 'feuille'), -1, to: '/cours/mots/${group.id}'));
      steps.add(StepEntry(Step(kind: kind, iconType: 'branche'), 1, to: '/exercice/mots/${group.id}'));
      if (idx % 2 == 1) {
        final levelIdx = (idx - 1) ~/ 2;
        if (levelIdx < _crosswordLevels.length) {
          final level = _crosswordLevels[levelIdx];
          steps.add(StepEntry(const Step(kind: StepKind.crossword), 0, to: '/exercice/mots-croises/lvl$level'));
        }
      }
    }
    steps.add(StepEntry(const Step(kind: StepKind.medal), 0, to: '/exercice'));

    // Chaque étape hérite de la couleur du dernier en-tête de palier rencontré.
    Color currentColor = const Color(0xFF8FBF6F);
    Color currentBorder = const Color(0xFF5E8E3E);
    for (final entry in steps) {
      if (entry.step.kind == StepKind.header) {
        currentColor = entry.step.bannerBg ?? currentColor;
        currentBorder = entry.step.bannerBorder ?? currentBorder;
      } else {
        entry.color = currentColor;
        entry.borderColor = currentBorder;
      }
    }

    return steps;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final steps = _buildSteps(t);
    final nonHeaderCount = steps.where((s) => s.step.kind != StepKind.header).length;
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
                            style: AmaniTheme.titleStyle.copyWith(fontSize: 24, height: 1.2),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            t['parcours']?['subtitle'] ?? '',
                            style: AmaniTheme.bodyStyle.copyWith(color: AmaniColors.textSecondary, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const AmaniMascot(pose: AmaniPose.encouragement, size: AmaniSize.small),
                  ],
                ),
              ),

              // Chemin en zigzag
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth - 48; // padding horizontal 24+24
                  const stepHeight = 62.0;
                  final pathHeight = turns * stepHeight + 40;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _ZigzagPainter(turns: turns, stepHeight: stepHeight, width: width),
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

class _ZigzagPainter extends CustomPainter {
  final int turns;
  final double stepHeight;
  final double width;

  _ZigzagPainter({required this.turns, required this.stepHeight, required this.width});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = width / 2;
    final leftX = width * 0.2;
    final rightX = width * 0.8;
    final path = Path();
    double y = 20;
    path.moveTo(centerX, y);
    for (var i = 0; i < turns; i++) {
      final controlX = i.isEven ? leftX : rightX;
      final endY = y + stepHeight;
      path.quadraticBezierTo(controlX, y + stepHeight / 2, centerX, endY);
      y = endY;
    }

    final paint = Paint()
      ..color = const Color(0xFFA9784F).withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final dashed = dashPath(path, dashArray: CircularIntervalList<double>([2, 13]));
    canvas.drawPath(dashed, paint);
  }

  @override
  bool shouldRepaint(covariant _ZigzagPainter oldDelegate) =>
      oldDelegate.turns != turns || oldDelegate.width != width;
}

class _StepRow extends StatelessWidget {
  final StepEntry entry;
  final int index;
  final double width;
  final bool isCurrent;
  final Map<String, dynamic> t;
  final VoidCallback? onTap;

  const _StepRow({
    required this.entry,
    required this.index,
    required this.width,
    required this.isCurrent,
    required this.t,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final step = entry.step;

    if (step.kind == StepKind.header) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: _PalierBanner(step: step),
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
          colors: [step.bannerBg ?? AmaniColors.secondary, step.bannerBorder ?? AmaniColors.secondaryDark],
        ),
        boxShadow: [
          BoxShadow(color: step.bannerBorder ?? AmaniColors.secondaryDark, offset: const Offset(0, 6)),
          const BoxShadow(color: Color(0x384A3B2A), offset: Offset(0, 10), blurRadius: 24),
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
                child: const Icon(Icons.eco_rounded, size: 96, color: Colors.white),
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
                child: Icon(step.bannerIcon ?? Icons.eco_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (step.subtitle ?? '').toUpperCase(),
                      style: const TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 1.4,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      step.title ?? '',
                      style: const TextStyle(
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
                          style: const TextStyle(
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
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(
                  '${step.palierNum ?? ''}',
                  style: const TextStyle(
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
  final Map<String, dynamic> t;

  const _StepNode({
    required this.step,
    required this.isCurrent,
    required this.color,
    required this.borderColor,
    required this.t,
  });

  @override
  State<_StepNode> createState() => _StepNodeState();
}

class _StepNodeState extends State<_StepNode> with SingleTickerProviderStateMixin {
  late final AnimationController _pingController;

  @override
  void initState() {
    super.initState();
    _pingController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();
  }

  @override
  void dispose() {
    _pingController.dispose();
    super.dispose();
  }

  String get _stepLabel {
    final parcours = widget.t['parcours'] as Map<String, dynamic>? ?? {};
    if (widget.step.kind == StepKind.crossword) return parcours['crosswordStep'] ?? '';
    if (widget.step.iconType == 'branche') return parcours['exerciceStep'] ?? '';
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
        final bool bigNode = widget.step.kind == StepKind.active || widget.isCurrent;
        final double dim = bigNode ? 96 : 64;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isCurrent) _StartPill(borderColor: widget.borderColor, label: parcours['start'] ?? 'Commencer'),
            if (widget.isCurrent) const SizedBox(height: 10),
            SizedBox(
              width: dim + 24,
              height: dim + 24,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (widget.isCurrent) _PingRing(controller: _pingController, color: widget.color, size: dim),
                  Container(
                    width: dim,
                    height: dim,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bigNode ? widget.color : AmaniColors.disabled,
                      border: Border.all(
                        color: bigNode ? widget.borderColor : AmaniColors.disabled,
                        width: 4,
                      ),
                      boxShadow: AmaniShadows.card,
                    ),
                    alignment: Alignment.center,
                    child: widget.step.iconType == 'branche'
                        ? _SvgIcon(
                            svg: _brancheIconSvg,
                            viewBox: const Size(100, 120),
                            size: bigNode ? 46 : 30,
                            color: bigNode ? Colors.white : AmaniColors.textSecondary.withValues(alpha: 0.7),
                            fill: true,
                          )
                        : Icon(
                            Icons.eco_rounded,
                            size: bigNode ? 40 : 26,
                            color: bigNode ? Colors.white : AmaniColors.textSecondary.withValues(alpha: 0.7),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _stepLabel,
              style: TextStyle(
                fontFamily: kBalooFontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 11,
                letterSpacing: 0.6,
                color: bigNode ? widget.borderColor : AmaniColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        );

      case StepKind.crossword:
        final bool big = widget.isCurrent;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isCurrent) _StartPill(borderColor: widget.borderColor, label: parcours['start'] ?? 'Commencer'),
            if (widget.isCurrent) const SizedBox(height: 10),
            Container(
              width: big ? 80 : 56,
              height: big ? 80 : 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: big ? widget.color : AmaniColors.disabled,
                border: Border.all(color: big ? widget.borderColor : AmaniColors.disabled, width: 4),
                boxShadow: AmaniShadows.card,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.grid_view_rounded,
                size: big ? 36 : 24,
                color: big ? Colors.white : AmaniColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _stepLabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: kBalooFontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 11,
                color: big ? widget.borderColor : AmaniColors.textSecondary.withValues(alpha: 0.7),
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
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            if (widget.step.showMascot)
              const Positioned(
                top: -58,
                child: AmaniMascot(pose: AmaniPose.victoirePalier, size: AmaniSize.small),
              ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AmaniColors.disabled,
                border: Border.all(color: AmaniColors.disabled, width: 4),
                boxShadow: AmaniShadows.card,
              ),
              alignment: Alignment.center,
              child: CustomPaint(
                size: const Size(40, 40),
                painter: _MedalPainter(color: AmaniColors.textSecondary),
              ),
            ),
          ],
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
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: kBalooFontFamily,
              fontWeight: FontWeight.w800,
              fontSize: 13,
              letterSpacing: 0.6,
              color: borderColor,
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

  const _PingRing({required this.controller, required this.color, required this.size});

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
              decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: 0.3)),
            ),
          ),
        );
      },
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
        painter: _SvgPathPainter(svg: svg, viewBox: viewBox, color: color, fill: fill),
      ),
    );
  }
}

class _SvgPathPainter extends CustomPainter {
  final String svg;
  final Size viewBox;
  final Color color;
  final bool fill;

  _SvgPathPainter({required this.svg, required this.viewBox, required this.color, required this.fill});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width / viewBox.width, size.height / viewBox.height);
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

class _MedalPainter extends CustomPainter {
  final Color color;
  _MedalPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 40.0;
    canvas.save();
    canvas.scale(scale, scale);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawCircle(const Offset(20, 22), 9, paint);
    canvas.drawPath(parseSvgPathData(_medalRibbonsSvg), paint);
    canvas.drawPath(parseSvgPathData(_medalCheckSvg), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MedalPainter oldDelegate) => oldDelegate.color != color;
}
