import 'package:flutter/material.dart';
import '../theme/amani_theme.dart';
import '../utils/trace_validation.dart';

enum _CellStatus { idle, drawing, retry, solved }

const double _kCellTolerancePx = 27;

/// Case carrée façon mots croisés : trace une lettre entière (tous ses
/// signes, un geste après l'autre) dans un même cadre bien centré. Utilisée
/// à la fois pour les rangées de mots et les grilles de mots croisés. Port
/// fidèle de `src/components/amani/LetterTraceCell.tsx`.
class LetterTraceCell extends StatefulWidget {
  final dynamic letter;
  final double size;
  final bool isActive;
  final bool given;
  final VoidCallback? onSolved;

  const LetterTraceCell({
    super.key,
    required this.letter,
    this.size = 64,
    required this.isActive,
    this.given = false,
    this.onSolved,
  });

  @override
  State<LetterTraceCell> createState() => _LetterTraceCellState();
}

class _LetterTraceCellState extends State<LetterTraceCell> {
  final List<Offset> _userPoints = [];
  List<Offset> _refPoints = [];
  int _currentStepIdx = 0;
  final List<int> _completedSteps = [];
  _CellStatus _status = _CellStatus.idle;

  List get _steps => widget.letter['steps'] as List;
  bool get _solved => widget.given || _status == _CellStatus.solved;
  dynamic get _activeStep =>
      _currentStepIdx < _steps.length ? _steps[_currentStepIdx] : null;

  @override
  void initState() {
    super.initState();
    _sampleRef();
  }

  @override
  void didUpdateWidget(LetterTraceCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.letter['char'] != widget.letter['char']) {
      _currentStepIdx = 0;
      _completedSteps.clear();
      _status = _CellStatus.idle;
      _sampleRef();
    }
  }

  void _sampleRef() {
    final step = _activeStep;
    _refPoints = (step != null && !_solved)
        ? sampleSvgPath(step['pathD'] as String, 40)
        : [];
  }

  void _onPanStart(DragStartDetails d) {
    if (widget.given ||
        !widget.isActive ||
        _activeStep == null ||
        _solved ||
        _status == _CellStatus.retry)
      return;
    setState(() {
      _status = _CellStatus.drawing;
      _userPoints.clear();
      _userPoints.add(_toSvg(d.localPosition));
    });
  }

  Offset _toSvg(Offset p) {
    final sc = widget.size / 200.0;
    final ox = (widget.size - 200 * sc) / 2;
    final oy = (widget.size - 200 * sc) / 2;
    return Offset((p.dx - ox) / sc, (p.dy - oy) / sc);
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (_status != _CellStatus.drawing) return;
    setState(() => _userPoints.add(_toSvg(d.localPosition)));
  }

  void _onPanEnd(DragEndDetails d) {
    if (_status != _CellStatus.drawing) return;
    final result = validateTrace(_userPoints, _refPoints, _kCellTolerancePx);
    if (result.valid) {
      setState(() {
        _completedSteps.add(_currentStepIdx);
        _userPoints.clear();
      });
      if (_currentStepIdx + 1 < _steps.length) {
        Future.delayed(const Duration(milliseconds: 350), () {
          if (!mounted) return;
          setState(() {
            _currentStepIdx += 1;
            _status = _CellStatus.idle;
            _sampleRef();
          });
        });
      } else {
        setState(() => _status = _CellStatus.solved);
        widget.onSolved?.call();
      }
    } else {
      setState(() => _status = _CellStatus.retry);
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() {
          _userPoints.clear();
          _status = _CellStatus.idle;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.given
        ? AmaniColors.primary.withValues(alpha: 0.4)
        : _solved
        ? AmaniColors.secondary
        : widget.isActive
        ? AmaniColors.primary.withValues(alpha: 0.5)
        : AmaniColors.textPrimary.withValues(alpha: 0.12);
    final bg = widget.given ? AmaniColors.surface : Colors.white;

    return Container(
      width: widget.size,
      height: widget.size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 2),
        color: bg,
      ),
      child: widget.given
          ? Center(
              child: Text(
                widget.letter['char'] as String,
                style: TextStyle(
                  fontFamily: kBalooFontFamily,
                  fontWeight: FontWeight.w800,
                  fontSize: widget.size * 0.5,
                  color: AmaniColors.primary,
                ),
              ),
            )
          : Stack(
              children: [
                CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _CellPainter(
                    steps: _steps,
                    currentStepIdx: _currentStepIdx,
                    completedSteps: _completedSteps,
                    status: _status,
                    solved: _solved,
                    userPoints: _userPoints,
                    cellSize: widget.size,
                    isActive: widget.isActive,
                  ),
                ),
                GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: Container(
                    color: Colors.transparent,
                    width: widget.size,
                    height: widget.size,
                  ),
                ),
              ],
            ),
    );
  }
}

class _CellPainter extends CustomPainter {
  final List steps;
  final int currentStepIdx;
  final List<int> completedSteps;
  final _CellStatus status;
  final bool solved;
  final List<Offset> userPoints;
  final double cellSize;
  final bool isActive;

  _CellPainter({
    required this.steps,
    required this.currentStepIdx,
    required this.completedSteps,
    required this.status,
    required this.solved,
    required this.userPoints,
    required this.cellSize,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = cellSize / 200.0;
    final lineWidth = (cellSize / 9).clamp(3.0, 100.0);

    if (solved) {
      for (var i = 0; i < steps.length; i++) {
        final pts = sampleSvgPath(steps[i]['pathD'] as String, 35);
        if (pts.length < 2) continue;
        _drawPolyline(
          canvas,
          pts,
          scale,
          Color(
            int.parse(
              (steps[i]['strokeColor'] as String).replaceFirst('#', '0xFF'),
            ),
          ),
          lineWidth,
        );
      }
      return;
    }

    // Guides des étapes non complétées
    for (var idx = 0; idx < steps.length; idx++) {
      if (completedSteps.contains(idx)) continue;
      final isCurrentStep = idx == currentStepIdx;
      final pts = sampleSvgPath(steps[idx]['pathD'] as String, 30);
      if (pts.length < 2) continue;
      final color = isCurrentStep
          ? (status == _CellStatus.retry
                ? AmaniColors.error
                : const Color(0xFF9BB5CC))
          : const Color(0xFFB8CCE0);
      _drawPolyline(
        canvas,
        pts,
        scale,
        color.withValues(alpha: isCurrentStep ? 0.85 : 0.3),
        isCurrentStep ? 13 : 10,
      );
    }

    // Étapes complétées
    for (final idx in completedSteps) {
      final pts = sampleSvgPath(steps[idx]['pathD'] as String, 35);
      if (pts.length < 2) continue;
      _drawPolyline(
        canvas,
        pts,
        scale,
        Color(
          int.parse(
            (steps[idx]['strokeColor'] as String).replaceFirst('#', '0xFF'),
          ),
        ),
        lineWidth,
      );
    }

    // Tracé en cours
    if (userPoints.isNotEmpty) {
      _drawPolyline(
        canvas,
        userPoints,
        scale,
        const Color(0xFF5BAA6A),
        lineWidth,
      );
    }

    // Pastille de départ
    if (isActive &&
        !solved &&
        (status == _CellStatus.idle || status == _CellStatus.retry) &&
        currentStepIdx < steps.length) {
      final startXY = steps[currentStepIdx]['startXY'] as List;
      final startPt = Offset(
        startXY[0].toDouble() * scale,
        startXY[1].toDouble() * scale,
      );
      canvas.drawCircle(startPt, 6, Paint()..color = const Color(0xFF5BAA6A));
      canvas.drawCircle(
        startPt,
        6,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  void _drawPolyline(
    Canvas canvas,
    List<Offset> pts,
    double scale,
    Color color,
    double strokeWidth,
  ) {
    final path = Path()..moveTo(pts.first.dx * scale, pts.first.dy * scale);
    for (final p in pts.skip(1)) {
      path.lineTo(p.dx * scale, p.dy * scale);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _CellPainter oldDelegate) => true;
}
