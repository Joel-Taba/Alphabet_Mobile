import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/amani_theme.dart';

/// Clavier de saisie façon calculatrice pour les exercices de calcul des
/// Paliers "Figures géométriques" et "Solides 3D" : un écran affiche le
/// nombre tapé, l'enfant compose sa réponse chiffre par chiffre puis appuie
/// sur "Valider". Aucun signe opératoire, uniquement les chiffres 0-9 et deux
/// actions (effacer, valider).
///
/// Style "petit appareil" : un boîtier crème qui porte un écran brun sombre
/// (chiffres crème type afficheur, curseur qui clignote) et des touches
/// rondes en relief qui s'enfoncent au toucher -- recoloré à la charte
/// Amani. En cas d'erreur l'écran rougit et tremble ; en cas de réussite il
/// passe au vert.
class ShapeAnswerKeypad extends StatefulWidget {
  final int correctAnswer;
  final bool isActive;
  final bool isFuture;
  final bool solved;
  final VoidCallback onSolved;

  const ShapeAnswerKeypad({
    super.key,
    required this.correctAnswer,
    required this.isActive,
    required this.isFuture,
    required this.solved,
    required this.onSolved,
  });

  @override
  State<ShapeAnswerKeypad> createState() => _ShapeAnswerKeypadState();
}

enum _Feedback { none, correct, wrong }

const Color _kScreenTop = Color(0xFF3A2E21);
const Color _kScreenBottom = Color(0xFF55432F);
const Color _kScreenDigits = Color(0xFFFBF1DC);

class _ShapeAnswerKeypadState extends State<ShapeAnswerKeypad>
    with TickerProviderStateMixin {
  String _entry = '';
  _Feedback _feedback = _Feedback.none;
  Timer? _timer;
  late final AnimationController _shake;
  late final AnimationController _caret;

  static const _maxDigits = 4;

  @override
  void initState() {
    super.initState();
    _shake = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _caret = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shake.dispose();
    _caret.dispose();
    super.dispose();
  }

  bool get _locked =>
      !widget.isActive ||
      widget.isFuture ||
      widget.solved ||
      _feedback != _Feedback.none;

  void _tapDigit(String digit) {
    if (_locked || _entry.length >= _maxDigits) return;
    if (_entry == '0') {
      setState(() => _entry = digit);
      return;
    }
    setState(() => _entry += digit);
  }

  void _backspace() {
    if (_locked || _entry.isEmpty) return;
    setState(() => _entry = _entry.substring(0, _entry.length - 1));
  }

  void _validate() {
    if (_locked || _entry.isEmpty) return;
    final guess = int.tryParse(_entry);
    if (guess == widget.correctAnswer) {
      setState(() => _feedback = _Feedback.correct);
      _timer = Timer(const Duration(milliseconds: 650), () {
        if (mounted) widget.onSolved();
      });
    } else {
      setState(() => _feedback = _Feedback.wrong);
      HapticFeedback.mediumImpact();
      _shake.forward(from: 0);
      _timer = Timer(const Duration(milliseconds: 1100), () {
        if (mounted) {
          setState(() {
            _entry = '';
            _feedback = _Feedback.none;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final interactive = widget.isActive && !widget.isFuture && !widget.solved;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Container(
        width: 250,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFBF3), Color(0xFFF1E6D3)],
          ),
          border: Border.all(color: const Color(0xFFE6D6BC)),
          boxShadow: [
            BoxShadow(
              color: AmaniColors.textPrimary.withValues(alpha: 0.16),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
            const BoxShadow(
              color: Colors.white,
              blurRadius: 2,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _shake,
              builder: (context, child) {
                final dx =
                    math.sin(_shake.value * math.pi * 6) *
                    10 *
                    (1 - _shake.value);
                return Transform.translate(offset: Offset(dx, 0), child: child);
              },
              child: _Screen(
                entry: _entry,
                feedback: _feedback,
                caret: _caret,
                showCaret: interactive && _feedback == _Feedback.none,
              ),
            ),
            if (interactive) ...[
              const SizedBox(height: 16),
              for (final row in const [
                ['1', '2', '3'],
                ['4', '5', '6'],
                ['7', '8', '9'],
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (final d in row)
                        _RoundKey(label: d, onTap: () => _tapDigit(d)),
                    ],
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _RoundKey(
                    icon: Icons.backspace_rounded,
                    style: _KeyStyle.action,
                    onTap: _backspace,
                  ),
                  _RoundKey(label: '0', onTap: () => _tapDigit('0')),
                  _RoundKey(
                    icon: Icons.check_rounded,
                    style: _KeyStyle.validate,
                    onTap: _validate,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Écran de l'appareil : fond brun sombre bombé, sans texte, chiffres
/// crème alignés à droite comme une calculatrice, curseur clignotant.
class _Screen extends StatelessWidget {
  final String entry;
  final _Feedback feedback;
  final Animation<double> caret;
  final bool showCaret;

  const _Screen({
    required this.entry,
    required this.feedback,
    required this.caret,
    required this.showCaret,
  });

  @override
  Widget build(BuildContext context) {
    final glow = switch (feedback) {
      _Feedback.correct => AmaniColors.success,
      _Feedback.wrong => AmaniColors.error,
      _Feedback.none => null,
    };
    final colors = switch (feedback) {
      _Feedback.correct => const [Color(0xFF3F6B3A), Color(0xFF5B8F4F)],
      _Feedback.wrong => const [Color(0xFF7A2E2E), Color(0xFF9C3F3F)],
      _Feedback.none => const [_kScreenTop, _kScreenBottom],
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      height: 78,
      padding: const EdgeInsets.fromLTRB(14, 8, 16, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
        border: Border.all(
          color: glow ?? const Color(0xFF2A2118),
          width: glow == null ? 1.5 : 2.5,
        ),
        boxShadow: [
          if (glow != null)
            BoxShadow(
              color: glow.withValues(alpha: 0.55),
              blurRadius: 16,
              spreadRadius: 1,
            ),
          BoxShadow(
            color: AmaniColors.textPrimary.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Reflet en haut de l'écran, comme une vitre.
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              height: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.10),
                    Colors.white.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          if (feedback != _Feedback.none)
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                feedback == _Feedback.correct
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                size: 26,
                color: _kScreenDigits.withValues(alpha: 0.85),
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Réduit (comme une calculatrice) plutôt que de déborder de
                // l'afficheur en très grand texte.
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      entry.isEmpty ? '0' : entry,
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w800,
                        fontSize: 38,
                        height: 1.0,
                        letterSpacing: 2,
                        fontFeatures: const [FontFeature.tabularFigures()],
                        color: entry.isEmpty
                            ? _kScreenDigits.withValues(alpha: 0.28)
                            : _kScreenDigits,
                        shadows: [
                          Shadow(
                            color: _kScreenDigits.withValues(alpha: 0.35),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (showCaret)
                  FadeTransition(
                    opacity: caret,
                    child: Container(
                      width: 3,
                      height: 30,
                      margin: const EdgeInsets.only(left: 4, bottom: 3),
                      decoration: BoxDecoration(
                        color: AmaniColors.warning,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _KeyStyle { digit, action, validate }

/// Touche ronde en relief (dégradé clair en haut, ombre portée en bas) qui
/// s'enfonce légèrement au toucher.
class _RoundKey extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final _KeyStyle style;
  final VoidCallback onTap;

  const _RoundKey({
    this.label,
    this.icon,
    this.style = _KeyStyle.digit,
    required this.onTap,
  });

  @override
  State<_RoundKey> createState() => _RoundKeyState();
}

class _RoundKeyState extends State<_RoundKey> {
  bool _pressed = false;

  void _set(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final (top, bottom, fg, rim) = switch (widget.style) {
      _KeyStyle.digit => (
        Colors.white,
        const Color(0xFFF2E7D5),
        AmaniColors.textPrimary,
        const Color(0xFFE3D3B8),
      ),
      _KeyStyle.action => (
        const Color(0xFFF6DDC8),
        const Color(0xFFE8BF9E),
        AmaniColors.primaryDark,
        const Color(0xFFD6A67F),
      ),
      _KeyStyle.validate => (
        const Color(0xFFA8D48A),
        AmaniColors.secondaryDark,
        Colors.white,
        const Color(0xFF5E8E3E),
      ),
    };

    return GestureDetector(
      onTapDown: (_) => _set(true),
      onTapUp: (_) {
        _set(false);
        HapticFeedback.selectionClick();
        widget.onTap();
      },
      onTapCancel: () => _set(false),
      child: AnimatedScale(
        scale: _pressed ? 0.9 : 1,
        duration: const Duration(milliseconds: 90),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _pressed ? [bottom, top] : [top, bottom],
            ),
            border: Border.all(color: rim, width: 1.2),
            boxShadow: _pressed
                ? [
                    BoxShadow(
                      color: AmaniColors.textPrimary.withValues(alpha: 0.12),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: rim.withValues(alpha: 0.9),
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: AmaniColors.textPrimary.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: widget.label != null
              ? Text(
                  widget.label!,
                  style: TextStyle(
                    fontFamily: kBalooFontFamily,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: fg,
                  ),
                )
              : Icon(widget.icon, size: 24, color: fg),
        ),
      ),
    );
  }
}
