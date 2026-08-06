import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/sign_glyph.dart';
import '../theme/amani_theme.dart';

enum SignCardState { normal, selected, correct, incorrect, misplaced, locked }

class SignCard extends StatefulWidget {
  final SignFamily family;
  final SignCardState state;
  final double size;
  final VoidCallback? onClick;
  final String? label;

  const SignCard({
    super.key,
    required this.family,
    this.state = SignCardState.normal,
    this.size = 88.0,
    this.onClick,
    this.label,
  });

  @override
  State<SignCard> createState() => _SignCardState();
}

class _SignCardState extends State<SignCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void didUpdateWidget(SignCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state == SignCardState.incorrect &&
        oldWidget.state != SignCardState.incorrect) {
      _shakeController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color stroke;

    switch (widget.family) {
      case SignFamily.trait:
        bg = const Color(0xFFFFFFFF);
        stroke = const Color(0xFF4A3B2A);
        break;
      case SignFamily.courbe:
        bg = const Color(0xFFE05252);
        stroke = const Color(0xFFFFFFFF);
        break;
      case SignFamily.point:
        bg = const Color(0xFFF5EDE0);
        stroke = const Color(0xFF4A3B2A);
        break;
      case SignFamily.crochet:
        bg = const Color(0xFF4A90E2);
        stroke = const Color(0xFFFFFFFF);
        break;
    }

    BoxDecoration decoration;
    Widget? overlay;
    Color? badgeBg;

    final isLocked = widget.state == SignCardState.locked;

    if (isLocked) {
      decoration = BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x2E000000), offset: Offset(0, 3)),
        ],
      );
      overlay = const Icon(
        CupertinoIcons.lock_fill,
        color: Colors.white,
        size: 16,
      );
      badgeBg = AmaniColors.textSecondary;
    } else {
      Color ringColor = Colors.transparent;
      switch (widget.state) {
        case SignCardState.normal:
          break;
        case SignCardState.selected:
          ringColor = AmaniColors.textPrimary;
          break;
        case SignCardState.correct:
          ringColor = AmaniColors.success;
          overlay = const Icon(Icons.check, color: Colors.white, size: 18);
          badgeBg = AmaniColors.success;
          break;
        case SignCardState.incorrect:
          ringColor = AmaniColors.error;
          overlay = const Icon(Icons.close, color: Colors.white, size: 18);
          badgeBg = AmaniColors.error;
          break;
        case SignCardState.misplaced:
          ringColor = AmaniColors.warning;
          overlay = const Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 18,
          );
          badgeBg = AmaniColors.warning;
          break;
        default:
          break;
      }

      decoration = BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: ringColor != Colors.transparent
            ? Border.all(color: ringColor, width: 4)
            : null,
        boxShadow: const [
          BoxShadow(color: Color(0x2E000000), offset: Offset(0, 3)),
        ],
      );
    }

    final double glyphSize = widget.size * 0.7;

    Widget card = Container(
      width: widget.size,
      height: widget.size,
      decoration: decoration,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: ColorFiltered(
              colorFilter: isLocked
                  ? const ColorFilter.matrix([
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0,
                      0,
                      0,
                      0.5,
                      0,
                    ])
                  : const ColorFilter.mode(
                      Colors.transparent,
                      BlendMode.multiply,
                    ),
              child: SignGlyph(
                family: widget.family,
                stroke: stroke,
                size: glyphSize,
              ),
            ),
          ),
          if (overlay != null)
            Positioned(
              top: -8,
              right: -8,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: badgeBg,
                  shape: BoxShape.circle,
                ),
                child: Center(child: overlay),
              ),
            ),
        ],
      ),
    );

    if (widget.state == SignCardState.incorrect) {
      card = AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          final sineValue =
              (4 * 3.14159 * _shakeController.value).abs() < 3.14159
              ? (10 * _shakeController.value)
              : (-10 * _shakeController.value); // Approximation du shake
          return Transform.translate(
            offset: Offset(sineValue % 5, 0),
            child: child,
          );
        },
        child: card,
      );
    }

    return GestureDetector(
      onTap: isLocked ? null : widget.onClick,
      child: MouseRegion(
        cursor: isLocked
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: card,
      ),
    );
  }
}
