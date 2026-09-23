import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../data/letter_style_resolver.dart';
import '../hooks/use_writing_style.dart';
import '../hooks/use_animation_speed.dart';
import '../data/palier2_groups.dart';
import '../data/flores_gong_nota.dart';
import '../widgets/cahier_frame.dart';
import '../widgets/sign_glyph.dart';
import '../services/progress_service.dart';
import '../widgets/directional_icon.dart';
import '../widgets/trace_controls_toolbar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../utils/navigation_helpers.dart';

/// Choisit la phrase prononcée pour la consigne d'une lettre. La consigne
/// script (voir `letter_formation_catalog.dart`) est déjà une phrase
/// complète ("Pour former la lettre X, je prends...") et se suffit à
/// elle-même ; la cursive, elle, reste au format court enveloppé par
/// [spokenLetterInstruction] ("Pour écrire la lettre X, on procède ainsi :
/// ..."), le temps que ses propres consignes soient réécrites de même.
String _spokenLetterConsigne(
  Lang lang,
  String char,
  String consigne,
  String category,
  String style,
) {
  if (category == 'chiffre') return spokenDigitInstruction(lang, char, consigne);
  if (style == 'script') return consigne;
  return spokenLetterInstruction(lang, char, consigne);
}

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

  late int _stepDurationMs;
  late int _pauseDurationMs;

  @override
  void initState() {
    super.initState();
    final animSpeed = context.read<AnimationSpeedProvider>().speed;
    _stepDurationMs = scaleDuration(2000, animSpeed);
    _pauseDurationMs = scaleDuration(400, animSpeed);
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

  /// Sur ouverture de page -- délai volontaire avant le lancement de
  /// l'animation, pour laisser l'enfant repérer le contenu de la page avant
  /// que le cours ne démarre. Un rejeu explicite (bouton "Relancer") reste,
  /// lui, immédiat -- `immediate: true`, et n'est plus accompagné de la
  /// synthèse vocale (`speak: false`) -- seul le bouton "Consigne" la
  /// déclenche désormais, "Relancer" ne fait rejouer que l'animation.
  void _playAnimation({bool immediate = false, bool speak = true}) {
    if (immediate) {
      _startPlayback(speak: speak);
    } else {
      Future.delayed(kCoursAnimationDelay, () {
        if (mounted) _startPlayback(speak: speak);
      });
    }
  }

  void _startPlayback({bool speak = true}) {
    final style = context.read<WritingStyleProvider>().style.name;
    final letter = getLetterFormation(widget.char, style);
    if (letter == null) return;
    _controller.duration = Duration(milliseconds: _totalMs);
    _controller
      ..reset()
      ..forward();
    final lang = context.read<LanguageProvider>().lang;
    if (speak) {
      final consigne = letter['consigne'][lang.name] ?? '';
      context.read<SignSpeechService>().speak(
        _spokenLetterConsigne(
          lang,
          widget.char,
          consigne,
          letter['category'],
          style,
        ),
        lang,
      );
    }

    // Les points du cours ne sont attribués qu'une fois TOUTES les lettres
    // du groupe consultées — jamais dès l'ouverture du cours.
    final progressionGroup = widget.pg != null
        ? getPalier2GroupMap(lang.name)[widget.pg]
        : null;
    final totalItems = progressionGroup != null
        ? progressionGroup.chars.length
        : 1;
    context.read<ProgressProvider>().markCoursItemViewed(
      typeEtape: 'LETTRE',
      groupCode: progressionGroup?.id ?? 'own-${widget.char}',
      itemCode: widget.char,
      totalItems: totalItems,
      palier: 2,
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
        ? getPalier2GroupMap(lang.name)[widget.pg]
        : null;
    final allLetters = progressionGroup != null
        ? progressionGroup.chars
              .map((c) => getLetterFormation(c, style))
              .whereType<dynamic>()
              .toList()
        : <dynamic>[letter];

    void goTo(dynamic l) {
      if (l == null) return;
      final query = widget.pg != null ? '?pg=${widget.pg}' : '';
      context.replace('/cours/lettres/formation/${l['char']}$query');
    }

    // Titre explicite couvrant tout le groupe de progression (ex. "Formation
    // des lettres "a" à "e""), plutôt que le simple caractère affiché
    // (ex. "a") qui ne renseignait pas sur le contenu réel de la page tant
    // que l'enfant n'avait pas parcouru toute la grille de navigation.
    final isDigitGroup = progressionGroup != null
        ? progressionGroup.kind == ProgressionGroupKind.chiffres
        : letter['category'] == 'chiffre';
    final groupChars = progressionGroup?.chars ?? [letter['char'] as String];
    final pageTitle = groupChars.length > 1
        ? tFormat(
            (isDigitGroup
                    ? cfc['groupTitleDigits']
                    : cfc['groupTitleLetters']) ??
                '',
            {'first': groupChars.first, 'last': groupChars.last},
          )
        : tFormat(
            (isDigitGroup
                    ? cfc['groupTitleDigitSingle']
                    : cfc['groupTitleLetterSingle']) ??
                '',
            {'char': groupChars.first},
          );

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
                          pageTitle,
                          style: AmaniTheme.titleStyle.copyWith(fontSize: 19),
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
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Navigation dans le groupe
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

                  const SizedBox(height: 24),

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
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: TraceControlsToolbar.heightFor(3),
                      ),
                      child: Stack(
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
                                            ((elapsedMs - acc) /
                                                    _stepDurationMs)
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
                          Positioned(
                            top: 0,
                            right: 0,
                            child: TraceControlsToolbar(
                              expandAria:
                                  t['common']?['toolbarExpandAria'] ?? '',
                              collapseAria:
                                  t['common']?['toolbarCollapseAria'] ?? '',
                              actions: [
                                ToolbarAction(
                                  icon: LucideIcons.rotateCcw,
                                  label: t['common']?['replay'] ?? 'Revoir',
                                  background: AmaniColors.secondary.withValues(
                                    alpha: 0.15,
                                  ),
                                  foreground: const Color(0xFF2F4B1C),
                                  onTap: () => _playAnimation(
                                    immediate: true,
                                    speak: false,
                                  ),
                                ),
                                ToolbarAction(
                                  icon: LucideIcons.volume2,
                                  label:
                                      t['common']?['instruction'] ?? 'Consigne',
                                  background: AmaniColors.background,
                                  foreground: Colors.black,
                                  onTap: () => speech.speak(
                                    _spokenLetterConsigne(
                                      lang,
                                      widget.char,
                                      letter['consigne'][lang.name] ?? '',
                                      letter['category'],
                                      style,
                                    ),
                                    lang,
                                  ),
                                ),
                                ToolbarAction(
                                  icon: Icons.play_arrow_rounded,
                                  label:
                                      '${cfc['practice'] ?? "S'entrainer sur"} "${letter['char']}"',
                                  background: AmaniColors.secondary,
                                  foreground: Colors.white,
                                  onTap: () => context.push(
                                    '/exercice/lettre/${letter['char']}${widget.pg != null ? '?pg=${widget.pg}' : ''}',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 10,
                      children: [
                        for (int i = 0; i < steps.length; i++) ...[
                          Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              // Fond clair et uniforme quelle que soit la
                              // famille du signe — un fond sombre rendait
                              // les traits/points (STROKE_FAMILLE brun
                              // foncé) presque invisibles dessus.
                              color: AmaniColors.surface,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: SignGlyph(
                              family: SignFamily.values.firstWhere(
                                (f) => f.name == steps[i]['family'],
                                orElse: () => SignFamily.trait,
                              ),
                              variant: steps[i]['variant'] ?? 'vertical',
                              stroke:
                                  STROKE_FAMILLE[steps[i]['family']] ??
                                  AmaniColors.textPrimary,
                              strokeWidth: 8,
                              size: 36,
                            ),
                          ),
                          if (i < steps.length - 1)
                            Text(
                              '+',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AmaniColors.primary,
                              ),
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
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () => context.push(
          progressionGroup != null
              ? '/exercice-liste?group=${progressionGroup.id}'
              : '/exercice/lettre/${letter['char']}',
        ),
        child: Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: AmaniColors.secondary,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Color(0x33000000), blurRadius: 10)],
          ),
          child: DirectionalIcon(
            LucideIcons.arrowRight,
            size: 24,
            color: Colors.white,
          ),
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

    final zOrderedIdx = List<int>.generate(steps.length, (i) => i)
      ..sort(
        (a, b) => letterFamilyZIndex(
          steps[a]['family'] as String,
        ).compareTo(letterFamilyZIndex(steps[b]['family'] as String)),
      );

    for (final i in zOrderedIdx) {
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
            ..strokeWidth = 10
            ..strokeCap = StrokeCap.round,
        );
      }

      if (isDone) {
        canvas.drawPath(
          path,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 9
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
              ..strokeWidth = 9
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
