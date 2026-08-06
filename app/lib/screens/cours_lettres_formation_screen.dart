import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../data/letter_style_resolver.dart';
import '../hooks/use_writing_style.dart';
import '../data/palier2_groups.dart';
import '../data/flores_gong_nota.dart';
import '../widgets/cahier_frame.dart';
import '../widgets/sign_glyph.dart';

/// Animation multi-signes qui combine les signes de base pour former une
/// lettre ou un chiffre, avec navigation dans le groupe de progression. Port
/// fidèle de `src/routes/cours.lettres.formation.$char.tsx`.
class CoursLettresFormationScreen extends StatefulWidget {
  final String char;
  final String? pg;
  const CoursLettresFormationScreen({super.key, required this.char, this.pg});

  @override
  State<CoursLettresFormationScreen> createState() =>
      _CoursLettresFormationScreenState();
}

class _CoursLettresFormationScreenState
    extends State<CoursLettresFormationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static const int _stepDurationMs = 2000;
  static const int _pauseDurationMs = 400;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1),
    );
    _playAnimation();
  }

  int get _totalMs {
    final style = context.read<WritingStyleProvider>().style.name;
    final letter = getLetterFormation(widget.char, style);
    final steps = (letter?['steps'] as List?)?.length ?? 1;
    return steps * _stepDurationMs + (steps - 1) * _pauseDurationMs;
  }

  void _playAnimation() {
    final style = context.read<WritingStyleProvider>().style.name;
    final letter = getLetterFormation(widget.char, style);
    if (letter == null) return;
    _controller.duration = Duration(milliseconds: _totalMs);
    _controller
      ..reset()
      ..forward();
    final lang = context.read<LanguageProvider>().lang;
    context.read<SignSpeechService>().speak(
      letter['consigne'][lang.name] ?? '',
      lang,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final lang = context.watch<LanguageProvider>().lang;
    final style = context.watch<WritingStyleProvider>().style.name;
    final letter = getLetterFormation(widget.char, style);
    final speech = context.read<SignSpeechService>();
    final cf = t['coursFormation'] as Map<String, dynamic>? ?? {};
    final cfc = t['coursFormationChar'] as Map<String, dynamic>? ?? {};

    if (letter == null) {
      return Scaffold(
        backgroundColor: AmaniColors.background,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '"${widget.char}" ${cfc['notFound'] ?? ''}',
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
                      cfc['backToList'] ?? '',
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

    final steps = letter['steps'] as List;
    final progressionGroup = widget.pg != null
        ? PALIER2_GROUP_MAP[widget.pg]
        : null;
    final allLetters = progressionGroup != null
        ? progressionGroup.chars
              .map((c) => getLetterFormation(c, style))
              .whereType<dynamic>()
              .toList()
        : <dynamic>[letter];
    final groupTitle =
        progressionGroup?.title[lang.name] ?? cfc['vowelsTitle'] ?? '';
    final currentIdx = allLetters.indexWhere((l) => l['char'] == widget.char);
    final prevLetter = currentIdx > 0 ? allLetters[currentIdx - 1] : null;
    final nextLetter = currentIdx >= 0 && currentIdx < allLetters.length - 1
        ? allLetters[currentIdx + 1]
        : null;

    void goTo(dynamic l) {
      if (l == null) return;
      final query = widget.pg != null ? '?pg=${widget.pg}' : '';
      context.go('/cours/lettres/formation/${l['char']}$query');
    }

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
                      child: const Icon(CupertinoIcons.arrow_left, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '"${letter['char']}"',
                          style: AmaniTheme.titleStyle.copyWith(
                            fontSize: 26,
                            color: AmaniColors.primary,
                          ),
                        ),
                        Text(
                          '${tFormat(cf['signeCount'] ?? '', {'count': steps.length})} · ${letter['name'][lang.name] ?? ''}',
                          style: AmaniTheme.bodyStyle.copyWith(
                            fontSize: 13,
                            color: AmaniColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        speech.speak(letter['consigne'][lang.name] ?? '', lang),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AmaniColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        CupertinoIcons.speaker_2_fill,
                        size: 18,
                        color: Colors.white,
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
                  // Animation
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
                        Center(
                          child: SizedBox(
                            width: 260,
                            height: 260,
                            child: CahierFrame(
                              width: 260,
                              height: 260,
                              child: AnimatedBuilder(
                                animation: _controller,
                                builder: (context, _) {
                                  final elapsedMs =
                                      _controller.value * _totalMs;
                                  var stepIdx = 0;
                                  var stepProgress = 0.0;
                                  var acc = 0.0;
                                  for (var i = 0; i < steps.length; i++) {
                                    final stepEnd = acc + _stepDurationMs;
                                    if (elapsedMs <= stepEnd ||
                                        i == steps.length - 1) {
                                      stepIdx = i;
                                      stepProgress =
                                          ((elapsedMs - acc) / _stepDurationMs)
                                              .clamp(0.0, 1.0);
                                      break;
                                    }
                                    acc = stepEnd + _pauseDurationMs;
                                  }
                                  return CustomPaint(
                                    painter: _MultiStepPainter(
                                      steps: steps,
                                      currentStepIdx: stepIdx,
                                      stepProgress: stepProgress,
                                      isFinished: _controller.value >= 1.0,
                                    ),
                                    size: const Size(260, 260),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _PillButton(
                                icon: CupertinoIcons.restart,
                                label: t['common']?['replay'] ?? 'Revoir',
                                bg: AmaniColors.secondary.withValues(
                                  alpha: 0.15,
                                ),
                                fg: AmaniColors.secondaryDark,
                                onTap: _playAnimation,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _PillButton(
                                icon: CupertinoIcons.speaker_2_fill,
                                label:
                                    t['common']?['instruction'] ?? 'Consigne',
                                bg: AmaniColors.background,
                                fg: AmaniColors.textPrimary,
                                onTap: () => speech.speak(
                                  letter['consigne'][lang.name] ?? '',
                                  lang,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: _PillButton(
                            icon: CupertinoIcons.play_fill,
                            label:
                                '${cfc['practice'] ?? "M'exercer sur"} "${letter['char']}"',
                            bg: AmaniColors.secondary,
                            fg: Colors.white,
                            onTap: () => context.push(
                              '/exercice/lettre/${letter['char']}${widget.pg != null ? '?pg=${widget.pg}' : ''}',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Formule
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AmaniColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                      ),
                      boxShadow: const [
                        BoxShadow(color: Color(0x14000000), blurRadius: 8),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${cfc['formulaTitle'] ?? 'Formule'} — ${tFormat(cf['signeCount'] ?? '', {'count': steps.length})}',
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            letterSpacing: 0.4,
                            color: AmaniColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          runSpacing: 10,
                          children: [
                            for (int i = 0; i < steps.length; i++) ...[
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(
                                        int.parse(
                                          (steps[i]['strokeColor'] as String)
                                              .replaceFirst('#', '0xFF'),
                                        ),
                                      ).withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      '#${i + 1}',
                                      style: TextStyle(
                                        fontFamily: kBalooFontFamily,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 10,
                                        color: Color(
                                          int.parse(
                                            (steps[i]['strokeColor'] as String)
                                                .replaceFirst('#', '0xFF'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF4D3E3E),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: SignGlyph(
                                      family: SignFamily.values.firstWhere(
                                        (f) => f.name == steps[i]['family'],
                                        orElse: () => SignFamily.trait,
                                      ),
                                      variant:
                                          steps[i]['variant'] ?? 'vertical',
                                      stroke:
                                          STROKE_FAMILLE[steps[i]['family']] ??
                                          AmaniColors.textPrimary,
                                      strokeWidth: 8,
                                      size: 36,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  SizedBox(
                                    width: 60,
                                    child: Text(
                                      cfc['families']?[steps[i]['family']] ??
                                          '',
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: kBalooFontFamily,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10,
                                        color: Color(
                                          int.parse(
                                            (steps[i]['strokeColor'] as String)
                                                .replaceFirst('#', '0xFF'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (i < steps.length - 1)
                                const Icon(
                                  CupertinoIcons.chevron_right,
                                  size: 14,
                                  color: AmaniColors.primary,
                                ),
                            ],
                            const SizedBox(width: 6),
                            Text(
                              '=',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AmaniColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              letter['char'],
                              style: TextStyle(
                                fontFamily: kBalooFontFamily,
                                fontWeight: FontWeight.w800,
                                fontSize: 38,
                                color: AmaniColors.primary,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Navigation dans le groupe
                  Text(
                    groupTitle,
                    style: TextStyle(
                      fontFamily: kBalooFontFamily,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      letterSpacing: 0.4,
                      color: AmaniColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                    itemCount: allLetters.length,
                    itemBuilder: (context, i) {
                      final l = allLetters[i];
                      final isCurrent = l['char'] == widget.char;
                      return GestureDetector(
                        onTap: () => goTo(l),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? AmaniColors.primary
                                : AmaniColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isCurrent
                                  ? AmaniColors.primary
                                  : AmaniColors.textPrimary.withValues(
                                      alpha: 0.08,
                                    ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            l['char'],
                            style: TextStyle(
                              fontFamily: kBalooFontFamily,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              color: isCurrent
                                  ? Colors.white
                                  : AmaniColors.textPrimary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (prevLetter != null)
                        _NavPill(
                          label: '"${prevLetter['char']}"',
                          leading: true,
                          onTap: () => goTo(prevLetter),
                        )
                      else
                        const SizedBox(),
                      if (nextLetter != null)
                        _NavPill(
                          label: '"${nextLetter['char']}"',
                          leading: false,
                          filled: true,
                          onTap: () => goTo(nextLetter),
                        )
                      else
                        const SizedBox(),
                    ],
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
                  fontWeight: FontWeight.w800,
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

class _NavPill extends StatelessWidget {
  final String label;
  final bool leading;
  final bool filled;
  final VoidCallback onTap;

  const _NavPill({
    required this.label,
    required this.leading,
    this.filled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      leading ? CupertinoIcons.chevron_left : CupertinoIcons.chevron_right,
      size: 14,
      color: filled ? Colors.white : AmaniColors.textPrimary,
    );
    final text = Text(
      label,
      style: TextStyle(
        fontFamily: kBalooFontFamily,
        fontWeight: FontWeight.w800,
        fontSize: 14,
        color: filled ? Colors.white : AmaniColors.textPrimary,
      ),
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: filled ? AmaniColors.primary : AmaniColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: filled
              ? null
              : Border.all(
                  color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: leading
              ? [icon, const SizedBox(width: 6), text]
              : [text, const SizedBox(width: 6), icon],
        ),
      ),
    );
  }
}

class _MultiStepPainter extends CustomPainter {
  final List steps;
  final int currentStepIdx;
  final double stepProgress;
  final bool isFinished;

  _MultiStepPainter({
    required this.steps,
    required this.currentStepIdx,
    required this.stepProgress,
    required this.isFinished,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 200.0;
    canvas.save();
    canvas.scale(scale, scale);

    Offset? penPos;

    for (var i = 0; i < steps.length; i++) {
      final step = steps[i];
      final path = parseSvgPathData(step['pathD'] as String);
      final isActive = i == currentStepIdx;
      final isDone = i < currentStepIdx || isFinished;
      final isFuture = i > currentStepIdx && !isFinished;
      final color = Color(
        int.parse((step['strokeColor'] as String).replaceFirst('#', '0xFF')),
      );

      if (isFuture) {
        canvas.drawPath(
          dashPath(path, dashArray: CircularIntervalList<double>([6, 8])),
          Paint()
            ..color = const Color(0xFF9BB5CC).withValues(alpha: 0.4)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 14
            ..strokeCap = StrokeCap.round,
        );
      }

      if (isDone) {
        canvas.drawPath(
          path,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 12
            ..strokeCap = StrokeCap.round,
        );
      } else if (isActive) {
        for (final metric in path.computeMetrics()) {
          final len = metric.length * stepProgress;
          canvas.drawPath(
            metric.extractPath(0, len),
            Paint()
              ..color = color
              ..style = PaintingStyle.stroke
              ..strokeWidth = 12
              ..strokeCap = StrokeCap.round,
          );
          if (!isFinished) {
            final tangent = metric.getTangentForOffset(len);
            if (tangent != null) penPos = tangent.position;
          }
        }
      }
    }

    if (!isFinished && penPos != null && stepProgress <= 0.98) {
      canvas.drawCircle(penPos, 4.5, Paint()..color = const Color(0xFFA9784F));
      canvas.drawCircle(
        penPos,
        4.5,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MultiStepPainter oldDelegate) =>
      oldDelegate.currentStepIdx != currentStepIdx ||
      oldDelegate.stepProgress != stepProgress ||
      oldDelegate.isFinished != isFinished;
}
