import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../services/progress_service.dart';
import '../data/sign_exercise_catalog.dart';
import '../widgets/sign_glyph.dart';
import '../widgets/cahier_frame.dart';
import '../hooks/use_animation_speed.dart';

const Map<String, Color> _familyColor = {
  'point': AmaniColors.textPrimary,
  'courbe': Color(0xFFC03E3E),
  'crochet': Color(0xFF2D6BBF),
  'trait': AmaniColors.textPrimary,
};
const Map<String, Color> _familyBg = {
  'point': AmaniColors.surface,
  'courbe': Color(0xFFFDEAEA),
  'crochet': Color(0xFFEAF1FB),
  'trait': AmaniColors.background,
};

SignFamily _familyFromKey(String key) => SignFamily.values.firstWhere(
  (f) => f.name == key,
  orElse: () => SignFamily.trait,
);

class CoursFamilyScreen extends StatefulWidget {
  final String family;
  const CoursFamilyScreen({super.key, required this.family});

  @override
  State<CoursFamilyScreen> createState() => _CoursFamilyScreenState();
}

class _CoursFamilyScreenState extends State<CoursFamilyScreen>
    with SingleTickerProviderStateMixin {
  late List<dynamic> _entries;
  dynamic _selectedSign;
  late AnimationController _controller;
  late int _animDurationMs;

  String? get _prevFamily {
    final idx = FAMILY_ORDER.indexOf(widget.family);
    return idx > 0 ? FAMILY_ORDER[idx - 1] : null;
  }

  String? get _nextFamily {
    final idx = FAMILY_ORDER.indexOf(widget.family);
    return idx >= 0 && idx < FAMILY_ORDER.length - 1
        ? FAMILY_ORDER[idx + 1]
        : null;
  }

  @override
  void initState() {
    super.initState();
    _entries = EXERCISE_CATALOG
        .where((e) => e['family'] == widget.family)
        .toList();
    _selectedSign = _entries.isNotEmpty ? _entries.first : null;
    _animDurationMs = scaleDuration(
      4000,
      context.read<AnimationSpeedProvider>().speed,
    );
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _animDurationMs),
    );
    _playAnimation();
  }

  void _playAnimation() {
    if (_selectedSign == null) return;
    _controller
      ..reset()
      ..forward();
    final lang = context.read<LanguageProvider>().lang;
    context.read<SignSpeechService>().speak(
      _selectedSign['consigne'][lang.name] ?? '',
      lang,
    );
    // Les points du cours ne sont attribués qu'une fois TOUTES les variantes
    // de la famille consultées — jamais dès l'ouverture du cours.
    context.read<ProgressProvider>().markCoursItemViewed(
      typeEtape: 'SIGNE',
      groupCode: widget.family,
      itemCode: _selectedSign['id'] as String,
      totalItems: _entries.length,
      palier: 1,
    );
  }

  void _selectSign(dynamic sign) {
    setState(() => _selectedSign = sign);
    _playAnimation();
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
    final coursFamily = t['coursFamily'] as Map<String, dynamic>? ?? {};
    final titles = coursFamily['titles'] as Map<String, dynamic>? ?? {};
    final title = titles[widget.family] as String? ?? widget.family;
    final color = _familyColor[widget.family] ?? AmaniColors.textPrimary;
    final bg = _familyBg[widget.family] ?? AmaniColors.surface;
    final speech = context.read<SignSpeechService>();

    return Scaffold(
      backgroundColor: AmaniColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // En-tête
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              decoration: BoxDecoration(
                color: bg,
                border: Border(
                  bottom: BorderSide(color: color.withValues(alpha: 0.12)),
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
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Color(0x1A000000), blurRadius: 6),
                        ],
                      ),
                      child: const Icon(CupertinoIcons.arrow_left, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        color: color,
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
                  if (_selectedSign != null)
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
                          Text(
                            _selectedSign['label'][lang.name] ?? '',
                            style: AmaniTheme.titleStyle.copyWith(fontSize: 19),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: SizedBox(
                              width: 240,
                              height: 240,
                              child: CahierFrame(
                                width: 240,
                                height: 240,
                                child: AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, _) => CustomPaint(
                                    painter: _StrokeAnimPainter(
                                      pathD: _selectedSign['pathD'] as String,
                                      startXY: Offset(
                                        (_selectedSign['startXY'] as List)[0]
                                            .toDouble(),
                                        (_selectedSign['startXY'] as List)[1]
                                            .toDouble(),
                                      ),
                                      endXY: Offset(
                                        (_selectedSign['endXY'] as List)[0]
                                            .toDouble(),
                                        (_selectedSign['endXY'] as List)[1]
                                            .toDouble(),
                                      ),
                                      strokeColor: Color(
                                        int.parse(
                                          (_selectedSign['strokeColor']
                                                  as String)
                                              .replaceFirst('#', '0xFF'),
                                        ),
                                      ),
                                      progress: _controller.value,
                                      animDurationMs: _animDurationMs,
                                      family:
                                          _selectedSign['family'] as String? ??
                                          '',
                                    ),
                                    size: const Size(240, 240),
                                  ),
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
                                    _selectedSign['consigne'][lang.name] ?? '',
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
                              label: coursFamily['exercer'] ?? "M'exercer",
                              bg: AmaniColors.secondary,
                              fg: Colors.white,
                              filled: true,
                              onTap: () => context.push(
                                '/exercice-liste?family=${widget.family}',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),
                  Text(
                    '${coursFamily['variantsTitle'] ?? ''} (${_entries.length})',
                    style: TextStyle(
                      fontFamily: kBalooFontFamily,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 0.4,
                      color: AmaniColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.92,
                        ),
                    itemCount: _entries.length,
                    itemBuilder: (context, i) {
                      final item = _entries[i];
                      final isSelected =
                          _selectedSign != null &&
                          _selectedSign['id'] == item['id'];
                      return GestureDetector(
                        onTap: () => _selectSign(item),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AmaniColors.surface
                                : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected
                                  ? AmaniColors.secondary
                                  : const Color(0xFFE5E5E5),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: isSelected ? 0.08 : 0.04,
                                ),
                                blurRadius: isSelected ? 10 : 4,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: SizedBox(
                                  height: 18,
                                  child: isSelected
                                      ? const Icon(
                                          CupertinoIcons
                                              .check_mark_circled_solid,
                                          size: 16,
                                          color: AmaniColors.secondary,
                                        )
                                      : null,
                                ),
                              ),
                              Container(
                                width: 76,
                                height: 76,
                                decoration: const BoxDecoration(
                                  color: AmaniColors.background,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: SignGlyph(
                                  family: _familyFromKey(item['family']),
                                  variant: item['variant'] ?? 'vertical',
                                  stroke: Color(
                                    int.parse(
                                      (item['strokeColor'] as String)
                                          .replaceFirst('#', '0xFF'),
                                    ),
                                  ),
                                  size: 50,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(top: 8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: isSelected
                                          ? AmaniColors.secondary.withValues(
                                              alpha: 0.2,
                                            )
                                          : const Color(0xFFF0F0F0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  item['label'][lang.name] ?? '',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: kBalooFontFamily,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.5,
                                    color: isSelected
                                        ? AmaniColors.secondaryDark
                                        : const Color(0xFF333333),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_prevFamily != null)
                        GestureDetector(
                          onTap: () => context.go('/cours/${_prevFamily!}'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: AmaniColors.textPrimary.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0D000000),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.chevron_left,
                                  size: 16,
                                  color: AmaniColors.textPrimary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  t['common']?['previous'] ?? 'Précédent',
                                  style: TextStyle(
                                    fontFamily: kBalooFontFamily,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: AmaniColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        const SizedBox(),
                      if (_nextFamily != null)
                        GestureDetector(
                          onTap: () => context.go('/cours/${_nextFamily!}'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x22000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Text(
                                  t['common']?['next'] ?? 'Suivant',
                                  style: TextStyle(
                                    fontFamily: kBalooFontFamily,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  CupertinoIcons.chevron_right,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
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
  final bool filled;

  const _PillButton({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
    required this.onTap,
    this.filled = false,
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

/// Peint le guide en pointillés + le trait qui se dessine progressivement +
/// le stylet animé, au rythme de [progress] (0 → 1).
class _StrokeAnimPainter extends CustomPainter {
  final String pathD;
  final Offset startXY;
  final Offset endXY;
  final Color strokeColor;
  final double progress;
  final String family;

  /// Durée totale de l'animation, déjà mise à l'échelle selon le réglage de
  /// vitesse (voir AnimationController dans _CoursFamilyScreenState) — sert
  /// à faire alterner la pastille départ/arrivée fusionnée sur un rythme
  /// stable en temps réel plutôt qu'en fraction de progression.
  final int animDurationMs;

  _StrokeAnimPainter({
    required this.pathD,
    required this.startXY,
    required this.endXY,
    required this.strokeColor,
    required this.progress,
    required this.animDurationMs,
    this.family = '',
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 200.0;
    canvas.save();
    canvas.scale(scale, scale);

    final fullPath = parseSvgPathData(pathD);
    // Le point se remplit (disque) plutôt que de rester un simple contour.
    final isPoint = family == 'point';

    if (isPoint) {
      canvas.drawPath(
        fullPath,
        Paint()
          ..color = const Color(0xFF9BB5CC)
          ..style = PaintingStyle.fill,
      );
    }

    // Guide en pointillés
    final guidePaint = Paint()
      ..color = const Color(0xFF9BB5CC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      dashPath(fullPath, dashArray: CircularIntervalList<double>([6, 8])),
      guidePaint,
    );

    if (isPoint) {
      canvas.drawPath(
        fullPath,
        Paint()
          ..color = strokeColor
          ..style = PaintingStyle.fill,
      );
    }

    // Trait animé
    Offset? penPos;
    for (final metric in fullPath.computeMetrics()) {
      final len = metric.length * progress;
      final extracted = metric.extractPath(0, len);
      canvas.drawPath(
        extracted,
        Paint()
          ..color = strokeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round,
      );
      if (progress < 1) {
        final tangent = metric.getTangentForOffset(len);
        if (tangent != null) penPos = tangent.position;
      }
    }

    // Pastille(s) départ/arrivée (disparaissent en fin de tracé)
    final startEndMerged = (startXY - endXY).distance < 0.5;
    if (startEndMerged) {
      if (progress <= 0.98) {
        final elapsedMs = progress * animDurationMs;
        final cyclePos = (elapsedMs % 2000) / 2000;
        final markerColor = cyclePos < 0.5
            ? const Color(0xFF8FBF6F)
            : const Color(0xFFE05252);
        canvas.drawCircle(startXY, 3, Paint()..color = markerColor);
        canvas.drawCircle(
          startXY,
          3,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      }
    } else {
      if (progress <= 0.90) {
        canvas.drawCircle(startXY, 3, Paint()..color = const Color(0xFF8FBF6F));
        canvas.drawCircle(
          startXY,
          3,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      }
      if (progress <= 0.98) {
        canvas.drawCircle(endXY, 3, Paint()..color = const Color(0xFFE05252));
        canvas.drawCircle(
          endXY,
          3,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      }
    }

    // Stylet
    if (progress < 0.98 && penPos != null) {
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
  bool shouldRepaint(covariant _StrokeAnimPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.pathD != pathD;
}
