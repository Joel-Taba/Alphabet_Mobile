import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../hooks/use_exercise_settings.dart';
import '../data/letter_formation_catalog.dart';
import '../data/palier2_groups.dart';
import '../utils/trace_validation.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/cahier_frame.dart';
import '../widgets/repetition_row.dart';

/// Exercice complet d'écriture d'une lettre/chiffre : Phase A (chaque signe
/// exercé séparément) puis Phase B (la lettre écrite d'un seul geste continu).
/// Port fidèle de `src/routes/exercice.lettre.$char.tsx`.
class ExerciceLettreScreen extends StatefulWidget {
  final String char;
  final String? pg;
  const ExerciceLettreScreen({super.key, required this.char, this.pg});

  @override
  State<ExerciceLettreScreen> createState() => _ExerciceLettreScreenState();
}

enum _StepStatus { idle, drawing, success, retry }

class _CompletedStep {
  final int stepIdx;
  final Color strokeColor;
  const _CompletedStep(this.stepIdx, this.strokeColor);
}

const double _kLetterTolerancePx = 27;

class _ExerciceLettreScreenState extends State<ExerciceLettreScreen> {
  late ExerciseSettings _settings;
  final Set<int> _doneSteps = {};
  int _currentStepIdx = 0;
  final List<_CompletedStep> _completedSteps = [];
  _StepStatus _stepStatus = _StepStatus.idle;
  bool _letterSuccess = false;

  @override
  void initState() {
    super.initState();
    _settings = ExerciseSettings()..addListener(_onSettingsChanged);
    _settings.load();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakStart());
  }

  void _onSettingsChanged() {
    if (mounted) setState(_resetAll);
  }

  void _speakStart() {
    final letter = LETTER_MAP[widget.char];
    if (letter == null || !mounted) return;
    final lang = context.read<LanguageProvider>().lang;
    final t = context.read<LanguageProvider>().t;
    final el = t['exerciceLettre'] as Map<String, dynamic>? ?? {};
    context.read<SignSpeechService>().speak(tFormat(el['speakStart'] ?? '', {'name': letter['name'][lang.name] ?? ''}), lang);
  }

  void _resetAll() {
    _doneSteps.clear();
    _currentStepIdx = 0;
    _completedSteps.clear();
    _stepStatus = _StepStatus.idle;
    _letterSuccess = false;
  }

  @override
  void dispose() {
    _settings.removeListener(_onSettingsChanged);
    _settings.dispose();
    super.dispose();
  }

  void _handleStepSuccess(List steps) {
    final activeStep = steps[_currentStepIdx];
    final t = context.read<LanguageProvider>().t;
    final lang = context.read<LanguageProvider>().lang;
    final speech = context.read<SignSpeechService>();
    final el = t['exerciceLettre'] as Map<String, dynamic>? ?? {};
    final letter = LETTER_MAP[widget.char]!;

    setState(() {
      _completedSteps.add(_CompletedStep(_currentStepIdx, Color(int.parse((activeStep['strokeColor'] as String).replaceFirst('#', '0xFF')))));
    });

    if (_currentStepIdx + 1 < steps.length) {
      speech.speak(el['speakNextStep'] ?? '', lang);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        setState(() {
          _currentStepIdx += 1;
          _stepStatus = _StepStatus.idle;
        });
      });
    } else {
      speech.speak(tFormat(el['speakLetterDone'] ?? '', {'name': letter['name'][lang.name] ?? ''}), lang);
      setState(() => _letterSuccess = true);
    }
  }

  void _handleStepRetry(List steps) {
    final activeStep = steps[_currentStepIdx];
    final t = context.read<LanguageProvider>().t;
    final lang = context.read<LanguageProvider>().lang;
    final el = t['exerciceLettre'] as Map<String, dynamic>? ?? {};
    context.read<SignSpeechService>().speak(tFormat(el['speakRetryStep'] ?? '', {'desc': activeStep['description'][lang.name] ?? ''}), lang);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final lang = context.watch<LanguageProvider>().lang;
    final speech = context.read<SignSpeechService>();
    final el = t['exerciceLettre'] as Map<String, dynamic>? ?? {};
    final elL = t['exerciceListe'] as Map<String, dynamic>? ?? {};
    final letter = LETTER_MAP[widget.char];

    final progressionGroup = (widget.pg != null ? PALIER2_GROUP_MAP[widget.pg] : null) ?? findGroupForChar(widget.char);
    final groupId = progressionGroup?.id ?? 'l1';

    if (letter == null) {
      return Scaffold(
        backgroundColor: AmaniColors.background,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('"${widget.char}" ${el['notFound'] ?? ''}', style: AmaniTheme.titleStyle.copyWith(fontSize: 18)),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => context.go('/exercice-liste?group=l1'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(color: AmaniColors.secondary, borderRadius: BorderRadius.circular(999)),
                    child: Text(el['backToNotebook'] ?? '', style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final steps = letter['steps'] as List;
    final allLetters = progressionGroup != null
        ? progressionGroup.chars.map((c) => LETTER_MAP[c]).whereType<dynamic>().toList()
        : VOWELS;
    final currentIdx = allLetters.indexWhere((l) => l['char'] == widget.char);
    final nextLetter = currentIdx >= 0 && currentIdx < allLetters.length - 1 ? allLetters[currentIdx + 1] : null;
    final allStepsDone = _doneSteps.length == steps.length;

    return Scaffold(
      backgroundColor: AmaniColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  decoration: BoxDecoration(color: AmaniColors.background, border: Border(bottom: BorderSide(color: AmaniColors.textPrimary.withValues(alpha: 0.1)))),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.go('/exercice-liste?group=$groupId'),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(color: AmaniColors.surface, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Color(0x1F000000), blurRadius: 6)]),
                          child: const Icon(CupertinoIcons.arrow_left, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${el['title'] ?? 'Tracer'} "${letter['char']}"', style: AmaniTheme.titleStyle.copyWith(fontSize: 20)),
                            Text(
                              '${tFormat(el['signsReady'] ?? '', {'done': _doneSteps.length, 'total': steps.length})} · ${letter['name'][lang.name] ?? ''}',
                              style: AmaniTheme.bodyStyle.copyWith(fontSize: 12, color: AmaniColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => speech.speak(letter['consigne'][lang.name] ?? '', lang),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(color: AmaniColors.primary, shape: BoxShape.circle),
                          child: const Icon(CupertinoIcons.speaker_2_fill, size: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Bandeau d'état
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: AmaniColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AmaniColors.textPrimary.withValues(alpha: 0.1))),
                        child: Row(
                          children: [
                            AmaniMascot(pose: _letterSuccess ? AmaniPose.celebration : allStepsDone ? AmaniPose.demonstration : AmaniPose.encouragement, size: AmaniSize.small),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _letterSuccess ? (el['successAll'] ?? '') : allStepsDone ? (el['finalTitle'] ?? '') : (el['practiceStepsTitle'] ?? ''),
                                    style: AmaniTheme.titleStyle.copyWith(fontSize: 14),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _letterSuccess
                                        ? (el['successAllSub'] ?? '')
                                        : allStepsDone
                                            ? (el['finalHint'] ?? '')
                                            : tFormat(el['practiceStepsHint'] ?? '', {'reps': _settings.repetitions}),
                                    style: AmaniTheme.bodyStyle.copyWith(fontSize: 12, color: AmaniColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Phase A
                      for (int i = 0; i < steps.length; i++) ...[
                        RepetitionRow(
                          entry: TraceableEntry(
                            id: '${letter['char']}-step-$i',
                            pathD: steps[i]['pathD'] as String,
                            startXY: Offset((steps[i]['startXY'] as List)[0].toDouble(), (steps[i]['startXY'] as List)[1].toDouble()),
                            strokeColor: Color(int.parse((steps[i]['strokeColor'] as String).replaceFirst('#', '0xFF'))),
                          ),
                          label: steps[i]['description'][lang.name] ?? '',
                          repetitions: _settings.repetitions,
                          tolerance: _settings.tolerance,
                          doneLabel: elL['done'] ?? 'Terminé !',
                          onSpeak: () => speech.speak(steps[i]['description'][lang.name] ?? '', lang),
                          onAllDone: () => setState(() => _doneSteps.add(i)),
                          badge: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AmaniColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(999)),
                            child: Text('${el['stepPrefix'] ?? 'Signe'} ${i + 1}', style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w800, fontSize: 10.5, color: AmaniColors.primary)),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Phase B
                      if (!allStepsDone)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AmaniColors.surface.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AmaniColors.textPrimary.withValues(alpha: 0.2), style: BorderStyle.solid),
                          ),
                          child: Column(
                            children: [
                              Icon(CupertinoIcons.lock_fill, size: 22, color: AmaniColors.textPrimary.withValues(alpha: 0.4)),
                              const SizedBox(height: 8),
                              Text(el['finalLocked'] ?? '', textAlign: TextAlign.center, style: AmaniTheme.bodyStyle.copyWith(fontSize: 12.5, color: AmaniColors.textSecondary)),
                            ],
                          ),
                        )
                      else ...[
                        Center(
                          child: _LetterDrawingCanvas(
                            letter: letter,
                            currentStepIdx: _currentStepIdx,
                            completedSteps: _completedSteps,
                            stepStatus: _stepStatus,
                            onStatusChange: (s) => setState(() => _stepStatus = s),
                            onSuccess: () => _handleStepSuccess(steps),
                            onRetry: () => _handleStepRetry(steps),
                            w: 270,
                            h: 270,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: AmaniColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AmaniColors.textPrimary.withValues(alpha: 0.1))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${el['formulaTitle'] ?? ''} "${letter['char']}"', style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w800, fontSize: 13, color: AmaniColors.textPrimary)),
                                  Text('${_completedSteps.length} / ${steps.length} ${el['validated'] ?? ''}', style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w800, fontSize: 12, color: AmaniColors.secondary)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  for (int i = 0; i < steps.length; i++) _FormulaBadge(
                                    label: ((steps[i]['description'][lang.name] ?? '') as String).split(' ').first,
                                    index: i,
                                    isDone: _completedSteps.any((c) => c.stepIdx == i),
                                    isCurrent: i == _currentStepIdx && !_letterSuccess,
                                  ),
                                  Text('=  ${letter['char']}', style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w800, fontSize: 18, color: AmaniColors.primary)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () => setState(_resetAll),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(color: AmaniColors.secondary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14), border: Border.all(color: AmaniColors.secondary.withValues(alpha: 0.3))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(CupertinoIcons.restart, size: 16, color: AmaniColors.secondaryDark),
                                const SizedBox(width: 8),
                                Text(el['resetAll'] ?? '', style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w800, fontSize: 14, color: AmaniColors.secondaryDark)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),

            if (_letterSuccess)
              _SuccessOverlay(
                letter: letter,
                nextLetter: nextLetter,
                groupId: groupId,
                onClose: () => setState(() => _letterSuccess = false),
                onReset: () => setState(_resetAll),
              ),
          ],
        ),
      ),
    );
  }
}

class _FormulaBadge extends StatelessWidget {
  final String label;
  final int index;
  final bool isDone;
  final bool isCurrent;

  const _FormulaBadge({required this.label, required this.index, required this.isDone, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    final bg = isDone ? const Color(0x268FBF6F) : isCurrent ? const Color(0x26A9784F) : const Color(0xFFF2F2F2);
    final fg = isDone ? const Color(0xFF5E8E3E) : isCurrent ? AmaniColors.primary : AmaniColors.disabled;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999), border: Border.all(color: fg.withValues(alpha: 0.4))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: isDone
                ? const Icon(CupertinoIcons.check_mark, size: 10, color: Color(0xFF5E8E3E))
                : Text('${index + 1}', style: TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w800, fontSize: 10, color: fg)),
          ),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w700, fontSize: 11, color: fg)),
        ],
      ),
    );
  }
}

class _LetterDrawingCanvas extends StatefulWidget {
  final dynamic letter;
  final int currentStepIdx;
  final List<_CompletedStep> completedSteps;
  final _StepStatus stepStatus;
  final ValueChanged<_StepStatus> onStatusChange;
  final VoidCallback onSuccess;
  final VoidCallback onRetry;
  final double w;
  final double h;

  const _LetterDrawingCanvas({
    required this.letter,
    required this.currentStepIdx,
    required this.completedSteps,
    required this.stepStatus,
    required this.onStatusChange,
    required this.onSuccess,
    required this.onRetry,
    required this.w,
    required this.h,
  });

  @override
  State<_LetterDrawingCanvas> createState() => _LetterDrawingCanvasState();
}

class _LetterDrawingCanvasState extends State<_LetterDrawingCanvas> {
  final List<Offset> _userPoints = [];
  List<Offset> _refPoints = [];

  dynamic get _activeStep {
    final steps = widget.letter['steps'] as List;
    return widget.currentStepIdx < steps.length ? steps[widget.currentStepIdx] : null;
  }

  @override
  void initState() {
    super.initState();
    _sampleRef();
  }

  @override
  void didUpdateWidget(_LetterDrawingCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStepIdx != widget.currentStepIdx) _sampleRef();
  }

  void _sampleRef() {
    final step = _activeStep;
    _refPoints = step != null ? sampleSvgPath(step['pathD'] as String, 45) : [];
  }

  double get _scale => (widget.w < widget.h ? widget.w : widget.h) / 200.0;
  Offset get _origin => Offset((widget.w - 200 * _scale) / 2, (widget.h - 200 * _scale) / 2);
  Offset _toSvg(Offset p) => Offset((p.dx - _origin.dx) / _scale, (p.dy - _origin.dy) / _scale);

  void _onPanStart(DragStartDetails d) {
    if (_activeStep == null || widget.stepStatus == _StepStatus.success || widget.stepStatus == _StepStatus.retry) return;
    setState(() {
      widget.onStatusChange(_StepStatus.drawing);
      _userPoints.clear();
      _userPoints.add(_toSvg(d.localPosition));
    });
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (widget.stepStatus != _StepStatus.drawing) return;
    setState(() => _userPoints.add(_toSvg(d.localPosition)));
  }

  void _onPanEnd(DragEndDetails d) {
    if (widget.stepStatus != _StepStatus.drawing) return;
    final result = validateTrace(_userPoints, _refPoints, _kLetterTolerancePx);
    if (result.valid) {
      widget.onStatusChange(_StepStatus.success);
      widget.onSuccess();
    } else {
      widget.onStatusChange(_StepStatus.retry);
      widget.onRetry();
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        setState(() {
          _userPoints.clear();
          widget.onStatusChange(_StepStatus.idle);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.stepStatus == _StepStatus.success
        ? AmaniColors.secondary
        : widget.stepStatus == _StepStatus.retry
            ? AmaniColors.error
            : const Color(0x40A9784F);

    return Container(
      width: widget.w,
      height: widget.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor, width: 2)),
      child: CahierFrame(
        width: widget.w,
        height: widget.h,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(widget.w, widget.h),
              painter: _LetterCanvasPainter(
                letter: widget.letter,
                currentStepIdx: widget.currentStepIdx,
                completedSteps: widget.completedSteps,
                stepStatus: widget.stepStatus,
                userPoints: _userPoints,
                scale: _scale,
                origin: _origin,
              ),
            ),
            GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: Container(color: Colors.transparent, width: widget.w, height: widget.h),
            ),
          ],
        ),
      ),
    );
  }
}

class _LetterCanvasPainter extends CustomPainter {
  final dynamic letter;
  final int currentStepIdx;
  final List<_CompletedStep> completedSteps;
  final _StepStatus stepStatus;
  final List<Offset> userPoints;
  final double scale;
  final Offset origin;

  _LetterCanvasPainter({
    required this.letter,
    required this.currentStepIdx,
    required this.completedSteps,
    required this.stepStatus,
    required this.userPoints,
    required this.scale,
    required this.origin,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final steps = letter['steps'] as List;

    for (var i = 0; i < steps.length; i++) {
      final isCompleted = completedSteps.any((c) => c.stepIdx == i);
      if (isCompleted) continue;
      final isActiveStep = i == currentStepIdx;
      final pts = sampleSvgPath(steps[i]['pathD'] as String, 30);
      if (pts.length < 2) continue;
      final path = Path()..moveTo(pts.first.dx * scale + origin.dx, pts.first.dy * scale + origin.dy);
      for (final p in pts.skip(1)) {
        path.lineTo(p.dx * scale + origin.dx, p.dy * scale + origin.dy);
      }
      final color = isActiveStep ? (stepStatus == _StepStatus.retry ? AmaniColors.error : const Color(0xFF9BB5CC)) : const Color(0xFFB8CCE0);
      canvas.drawPath(
        path,
        Paint()
          ..color = color.withValues(alpha: isActiveStep ? 0.85 : 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = isActiveStep ? 13 : 11
          ..strokeCap = StrokeCap.round,
      );
    }

    for (final completed in completedSteps) {
      final step = steps[completed.stepIdx];
      final pts = sampleSvgPath(step['pathD'] as String, 35);
      if (pts.length < 2) continue;
      final path = Path()..moveTo(pts.first.dx * scale + origin.dx, pts.first.dy * scale + origin.dy);
      for (final p in pts.skip(1)) {
        path.lineTo(p.dx * scale + origin.dx, p.dy * scale + origin.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = completed.strokeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 11
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    if (userPoints.isNotEmpty) {
      final path = Path()..moveTo(userPoints.first.dx * scale + origin.dx, userPoints.first.dy * scale + origin.dy);
      for (final p in userPoints.skip(1)) {
        path.lineTo(p.dx * scale + origin.dx, p.dy * scale + origin.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF5BAA6A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 11
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    if (currentStepIdx < steps.length && (stepStatus == _StepStatus.idle || stepStatus == _StepStatus.retry)) {
      final startXY = steps[currentStepIdx]['startXY'] as List;
      final startPt = Offset(startXY[0].toDouble() * scale + origin.dx, startXY[1].toDouble() * scale + origin.dy);
      canvas.drawCircle(startPt, 8, Paint()..color = const Color(0xFF5BAA6A));
      canvas.drawCircle(startPt, 8, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    }
  }

  @override
  bool shouldRepaint(covariant _LetterCanvasPainter oldDelegate) => true;
}

class _SuccessOverlay extends StatelessWidget {
  final dynamic letter;
  final dynamic nextLetter;
  final String groupId;
  final VoidCallback onClose;
  final VoidCallback onReset;

  const _SuccessOverlay({required this.letter, required this.nextLetter, required this.groupId, required this.onClose, required this.onReset});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final el = t['exerciceLettre'] as Map<String, dynamic>? ?? {};

    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.4),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 30, offset: Offset(0, 12))]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AmaniMascot(pose: AmaniPose.celebration, size: AmaniSize.medium),
              const SizedBox(height: 12),
              Text(el['successTitle'] ?? '', style: AmaniTheme.titleStyle.copyWith(fontSize: 22)),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  style: AmaniTheme.bodyStyle.copyWith(fontSize: 14, color: AmaniColors.textSecondary),
                  children: [
                    TextSpan(text: '${el['successBody'] ?? ''} '),
                    TextSpan(text: '"${letter['char']}"', style: const TextStyle(fontWeight: FontWeight.w800, color: AmaniColors.textPrimary)),
                    const TextSpan(text: ' !'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(color: AmaniColors.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: AmaniColors.secondary, width: 2)),
                alignment: Alignment.center,
                child: Text(letter['char'], style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w800, fontSize: 44, color: AmaniColors.secondary)),
              ),
              const SizedBox(height: 8),
              if (nextLetter != null)
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () => context.go('/exercice/lettre/${nextLetter['char']}?pg=$groupId'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(color: AmaniColors.secondary, borderRadius: BorderRadius.circular(14), boxShadow: const [BoxShadow(color: Color(0x338FBF6F), blurRadius: 10, offset: Offset(0, 4))]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${el['nextLetter'] ?? ''} (${nextLetter['char']})', style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w800, fontSize: 14, color: Colors.white)),
                          const SizedBox(width: 6),
                          const Icon(CupertinoIcons.chevron_right, size: 16, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: onReset,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(color: AmaniColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
                    child: Text(el['practiceAgain'] ?? '', textAlign: TextAlign.center, style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w800, fontSize: 13, color: AmaniColors.primary)),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => context.go('/exercice-liste?group=$groupId'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(el['backToNotebookLink'] ?? '', style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w600, fontSize: 12, color: AmaniColors.textSecondary)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
