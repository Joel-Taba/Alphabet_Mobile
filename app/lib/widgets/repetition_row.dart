import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import '../theme/amani_theme.dart';
import '../utils/trace_validation.dart';
import 'amani_mascot.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Un tracé unique (signe atomique ou étape de lettre/chiffre) pouvant être
/// exercé en cahier. Port fidèle de `src/components/amani/RepetitionRow.tsx`.
class TraceableEntry {
  final String id;
  final String pathD;
  final Offset startXY;

  /// Où le tracé s'arrête. Null : seule la pastille de départ est affichée
  /// (comportement historique — utilisé pour les étapes de lettre).
  final Offset? endXY;
  final Color strokeColor;

  /// Le point se remplit (disque) plutôt que de rester un simple contour.
  final String family;

  const TraceableEntry({
    required this.id,
    required this.pathD,
    required this.startXY,
    this.endXY,
    required this.strokeColor,
    this.family = '',
  });
}

enum OccurrenceStatus { idle, drawing, success, retry }

class OccurrenceState {
  OccurrenceStatus status;
  int attempts;
  OccurrenceState({this.status = OccurrenceStatus.idle, this.attempts = 0});
}

class RepetitionRow extends StatefulWidget {
  final TraceableEntry entry;
  final String label;
  final VoidCallback onSpeak;
  final Widget? badge;
  final int repetitions;
  final num tolerance;
  final String doneLabel;
  final VoidCallback? onAllDone;

  /// Étape verrouillée tant que la précédente n'est pas réussie
  /// (reproduction dans l'ordre des signes d'une lettre).
  final bool locked;

  const RepetitionRow({
    super.key,
    required this.entry,
    required this.label,
    required this.onSpeak,
    this.badge,
    required this.repetitions,
    required this.tolerance,
    required this.doneLabel,
    this.onAllDone,
    this.locked = false,
  });

  @override
  State<RepetitionRow> createState() => _RepetitionRowState();
}

class _RepetitionRowState extends State<RepetitionRow> {
  late List<OccurrenceState> _occurrences;
  int _activeIndex = 0;
  bool _allDone = false;

  static const double _occW = 100;
  static const double _occH = 140;

  @override
  void initState() {
    super.initState();
    _resetOccurrences();
  }

  @override
  void didUpdateWidget(RepetitionRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.repetitions != widget.repetitions ||
        oldWidget.entry.id != widget.entry.id) {
      setState(_resetOccurrences);
    }
  }

  void _resetOccurrences() {
    _occurrences = List.generate(widget.repetitions, (_) => OccurrenceState());
    _activeIndex = 0;
    _allDone = false;
  }

  void _handleSuccess(int idx) {
    setState(() {
      _occurrences[idx].status = OccurrenceStatus.success;
      if (idx + 1 < widget.repetitions) {
        _activeIndex = idx + 1;
      } else {
        _allDone = true;
        widget.onAllDone?.call();
      }
    });
  }

  void _handleRetry(int idx) {
    setState(() {
      _occurrences[idx].status = OccurrenceStatus.idle;
      _occurrences[idx].attempts += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.locked ? 0.5 : 1,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _allDone
                ? AmaniColors.secondary.withValues(alpha: 0.6)
                : AmaniColors.textPrimary.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: _allDone
                  ? const Color(0x2E8FBF6F)
                  : const Color(0x144A3B2A),
              blurRadius: _allDone ? 16 : 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AmaniColors.surface,
                border: Border(
                  bottom: BorderSide(
                    color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (widget.badge != null) ...[
                    widget.badge!,
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AmaniColors.textPrimary,
                      ),
                    ),
                  ),
                  if (_allDone)
                    Text(
                      '✓ ${widget.doneLabel}',
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AmaniColors.secondary,
                      ),
                    ),
                  const SizedBox(width: 8),
                  if (widget.locked)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.lock,
                        size: 15,
                        color: AmaniColors.textSecondary,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: widget.onSpeak,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AmaniColors.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.volume2,
                          size: 16,
                          color: AmaniColors.textPrimary,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Zone du cahier, lignes réglées façon Seyès — les répétitions
            // remplissent chaque ligne horizontalement (autant qu'il en
            // tient, généralement 3) puis passent à la ligne suivante une
            // fois la largeur disponible pleine, plutôt que de s'étirer sur
            // une seule ligne à défilement horizontal.
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              constraints: const BoxConstraints(maxHeight: 330),
              child: SingleChildScrollView(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const spacing = 10.0;
                    final perRow = ((constraints.maxWidth + spacing) /
                            (_occW + spacing))
                        .floor()
                        .clamp(1, _occurrences.isEmpty ? 1 : _occurrences.length);
                    final rows = (_occurrences.length / perRow).ceil();

                    return SizedBox(
                      width: constraints.maxWidth,
                      child: CustomPaint(
                        painter: _SeyesLinesPainter(
                          rows: rows,
                          rowHeight: _occH,
                          rowSpacing: spacing,
                        ),
                        child: Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: [
                            for (int i = 0; i < _occurrences.length; i++)
                              _OccurrenceCanvas(
                                entry: widget.entry,
                                state: _occurrences[i],
                                isActive:
                                    i == _activeIndex &&
                                    !_allDone &&
                                    !widget.locked,
                                onSuccess: () => _handleSuccess(i),
                                onRetry: () => _handleRetry(i),
                                w: _occW,
                                h: _occH,
                                tolerancePct: widget.tolerance,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeyesLinesPainter extends CustomPainter {
  // Mêmes 4 lignes équidistantes (intervalle 60 dans l'espace lettre 0-200)
  // que CahierFrame.dart, converties en pixels ici via l'échelle fixe de
  // _OccurrenceCanvas (sc=0.5, oy=20) : pixelY = yLettre * 0.5, répété pour
  // chaque ligne de répétitions (le Wrap fait autant de lignes qu'il en
  // tient horizontalement) afin que le quadrillage couvre toute la largeur
  // réelle, sur toutes les lignes, plutôt que de rester calé sur une seule.
  static const List<double> _positions = [10, 70, 130, 190];

  final int rows;
  final double rowHeight;
  final double rowSpacing;

  _SeyesLinesPainter({
    required this.rows,
    required this.rowHeight,
    required this.rowSpacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int r = 0; r < rows; r++) {
      final rowTop = r * (rowHeight + rowSpacing);
      for (int i = 0; i < _positions.length; i++) {
        final y = rowTop + _positions[i] * 0.5;
        final isBaseline = i == 2;
        final paint = Paint()
          ..color =
              (isBaseline ? const Color(0xFFE05252) : const Color(0xFF4A90E2))
                  .withValues(alpha: 0.5)
          ..strokeWidth = isBaseline ? 1.5 : 1;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SeyesLinesPainter oldDelegate) =>
      oldDelegate.rows != rows ||
      oldDelegate.rowHeight != rowHeight ||
      oldDelegate.rowSpacing != rowSpacing;
}

class _OccurrenceCanvas extends StatefulWidget {
  final TraceableEntry entry;
  final OccurrenceState state;
  final bool isActive;
  final VoidCallback onSuccess;
  final VoidCallback onRetry;
  final double w;
  final double h;
  final num tolerancePct;

  const _OccurrenceCanvas({
    required this.entry,
    required this.state,
    required this.isActive,
    required this.onSuccess,
    required this.onRetry,
    required this.w,
    required this.h,
    required this.tolerancePct,
  });

  @override
  State<_OccurrenceCanvas> createState() => _OccurrenceCanvasState();
}

class _OccurrenceCanvasState extends State<_OccurrenceCanvas> {
  final List<Offset> _userPoints = [];
  List<Offset> _refPoints = [];
  late OccurrenceStatus _localStatus;
  Timer? _mergeBlinkTimer;
  bool _mergeGreenPhase = true;

  /// La mascotte de réussite ne reste affichée que quelques secondes : au-delà,
  /// elle cachait le signe que l'enfant venait de tracer avec succès, ce qui
  /// nuit à l'apprentissage (voir `build`, où la teinte verte de fond reste
  /// affichée, elle, tant que l'occurrence est réussie).
  bool _showSuccessMascot = false;
  static const _successMascotDuration = Duration(milliseconds: 1500);

  bool get _startEndMerged {
    final end = widget.entry.endXY;
    if (end == null) return false;
    return (widget.entry.startXY - end).distance < 0.5;
  }

  @override
  void initState() {
    super.initState();
    _localStatus = widget.state.status;
    _refPoints = sampleSvgPath(widget.entry.pathD, 30);
    _maybeStartMergeBlink();
  }

  void _maybeStartMergeBlink() {
    if (!_startEndMerged) return;
    _mergeBlinkTimer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      if (!mounted) return;
      setState(() => _mergeGreenPhase = !_mergeGreenPhase);
    });
  }

  @override
  void didUpdateWidget(_OccurrenceCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.status != widget.state.status) {
      final enteringSuccess =
          widget.state.status == OccurrenceStatus.success &&
          _localStatus != OccurrenceStatus.success;
      setState(() {
        _localStatus = widget.state.status;
        if (enteringSuccess) _showSuccessMascot = true;
      });
      if (enteringSuccess) _scheduleSuccessMascotHide();
    }
    if (oldWidget.entry.pathD != widget.entry.pathD) {
      _refPoints = sampleSvgPath(widget.entry.pathD, 30);
    }
  }

  void _scheduleSuccessMascotHide() {
    Future.delayed(_successMascotDuration, () {
      if (mounted) setState(() => _showSuccessMascot = false);
    });
  }

  @override
  void dispose() {
    _mergeBlinkTimer?.cancel();
    super.dispose();
  }

  double get _scale => (widget.w < widget.h ? widget.w : widget.h) / 200.0;
  Offset get _origin =>
      Offset((widget.w - 200 * _scale) / 2, (widget.h - 200 * _scale) / 2);

  Offset _toSvg(Offset canvasPt) => Offset(
    (canvasPt.dx - _origin.dx) / _scale,
    (canvasPt.dy - _origin.dy) / _scale,
  );

  void _onPanStart(DragStartDetails details) {
    if (!widget.isActive || _localStatus == OccurrenceStatus.success) return;
    setState(() {
      _localStatus = OccurrenceStatus.drawing;
      _userPoints.clear();
      _userPoints.add(_toSvg(details.localPosition));
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_localStatus != OccurrenceStatus.drawing) return;
    setState(() => _userPoints.add(_toSvg(details.localPosition)));
  }

  void _onPanEnd(DragEndDetails details) {
    if (_localStatus != OccurrenceStatus.drawing) return;
    final tolerancePx = (widget.tolerancePct / 100) * 200;
    final result = validateTrace(_userPoints, _refPoints, tolerancePx);
    if (result.valid) {
      setState(() {
        _localStatus = OccurrenceStatus.success;
        _showSuccessMascot = true;
      });
      _scheduleSuccessMascotHide();
      Future.delayed(const Duration(milliseconds: 600), widget.onSuccess);
    } else {
      setState(() => _localStatus = OccurrenceStatus.retry);
      Future.delayed(const Duration(milliseconds: 2400), () {
        if (!mounted) return;
        setState(() {
          _userPoints.clear();
          _localStatus = OccurrenceStatus.idle;
        });
        widget.onRetry();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _localStatus == OccurrenceStatus.success
        ? AmaniColors.secondary
        : widget.isActive
        ? const Color(0x40A9784F)
        : const Color(0x1A4A3B2A);

    return Container(
      width: widget.w,
      height: widget.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Stack(
        children: [
          CustomPaint(
            size: Size(widget.w, widget.h),
            painter: _OccurrencePainter(
              entry: widget.entry,
              status: _localStatus,
              userPoints: _userPoints,
              refPoints: _refPoints,
              scale: _scale,
              origin: _origin,
              mergeGreenPhase: _mergeGreenPhase,
            ),
          ),
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: Container(
              color: Colors.transparent,
              width: widget.w,
              height: widget.h,
            ),
          ),
          if (_localStatus == OccurrenceStatus.success)
            Positioned.fill(
              child: Container(
                color: const Color(0x1A8FBF6F),
                alignment: Alignment.center,
                // La mascotte n'apparaît que brièvement (voir
                // `_scheduleSuccessMascotHide`) pour ne pas cacher durablement
                // le signe que l'enfant vient de tracer — seule la teinte
                // verte ci-dessus reste comme marqueur de réussite.
                child: AnimatedOpacity(
                  opacity: _showSuccessMascot ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const AmaniMascot(
                    pose: AmaniPose.miniReussite,
                    size: AmaniSize.avatar,
                  ),
                ),
              ),
            ),
          if (_localStatus == OccurrenceStatus.retry)
            Positioned.fill(
              child: Container(
                color: const Color(0x1AF0C040),
                alignment: Alignment.center,
                child: const AmaniMascot(
                  pose: AmaniPose.miniReessai,
                  size: AmaniSize.avatar,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OccurrencePainter extends CustomPainter {
  final TraceableEntry entry;
  final OccurrenceStatus status;
  final List<Offset> userPoints;
  final List<Offset> refPoints;
  final double scale;
  final Offset origin;
  final bool mergeGreenPhase;

  _OccurrencePainter({
    required this.entry,
    required this.status,
    required this.userPoints,
    required this.refPoints,
    required this.scale,
    required this.origin,
    this.mergeGreenPhase = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (status != OccurrenceStatus.success) {
      canvas.save();
      canvas.translate(origin.dx, origin.dy);
      canvas.scale(scale, scale);
      final guideColor = status == OccurrenceStatus.retry
          ? const Color(0xE6D9A84A)
          : const Color(0xBF9BB5CC);
      if (entry.family == 'point') {
        canvas.drawPath(
          parseSvgPathData(entry.pathD),
          Paint()
            ..color = guideColor
            ..style = PaintingStyle.fill,
        );
      }
      final guidePaint = Paint()
        ..color = guideColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;
      final guidePath = dashPath(
        parseSvgPathData(entry.pathD),
        dashArray: CircularIntervalList<double>([7, 5]),
      );
      canvas.drawPath(guidePath, guidePaint);
      canvas.restore();

      // Pastille(s) départ/arrivée
      final startPt = Offset(
        entry.startXY.dx * scale + origin.dx,
        entry.startXY.dy * scale + origin.dy,
      );
      final end = entry.endXY;
      final merged = end != null && (entry.startXY - end).distance < 0.5;

      if (merged) {
        final markerColor = mergeGreenPhase
            ? const Color(0xFF5BAA6A)
            : const Color(0xFFE05252);
        canvas.drawCircle(startPt, 5, Paint()..color = markerColor);
        canvas.drawCircle(
          startPt,
          5,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      } else {
        canvas.drawCircle(startPt, 5, Paint()..color = const Color(0xFF5BAA6A));
        canvas.drawCircle(
          startPt,
          5,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
        if (end != null) {
          final endPt = Offset(
            end.dx * scale + origin.dx,
            end.dy * scale + origin.dy,
          );
          canvas.drawCircle(endPt, 5, Paint()..color = const Color(0xFFE05252));
          canvas.drawCircle(
            endPt,
            5,
            Paint()
              ..color = Colors.white
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1,
          );
        }
      }
    }

    if (status == OccurrenceStatus.success && refPoints.length >= 2) {
      final path = Path()
        ..moveTo(
          refPoints.first.dx * scale + origin.dx,
          refPoints.first.dy * scale + origin.dy,
        );
      for (final pt in refPoints.skip(1)) {
        path.lineTo(pt.dx * scale + origin.dx, pt.dy * scale + origin.dy);
      }
      if (entry.family == 'point') {
        canvas.drawPath(
          path,
          Paint()
            ..color = entry.strokeColor
            ..style = PaintingStyle.fill,
        );
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = entry.strokeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      return;
    }

    if (userPoints.isNotEmpty) {
      final path = Path()
        ..moveTo(
          userPoints.first.dx * scale + origin.dx,
          userPoints.first.dy * scale + origin.dy,
        );
      for (final pt in userPoints.skip(1)) {
        path.lineTo(pt.dx * scale + origin.dx, pt.dy * scale + origin.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF5BAA6A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OccurrencePainter oldDelegate) => true;
}
