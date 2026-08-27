import 'package:flutter/material.dart';
import '../theme/amani_theme.dart';

enum AmaniButtonVariant { primary, secondary, danger, ghost }

/// Bouton Amani avec effet 3D "pressable".
class AmaniButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final AmaniButtonVariant variant;
  final IconData? icon;
  final bool fullWidth;
  final bool disabled;

  const AmaniButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AmaniButtonVariant.primary,
    this.icon,
    this.fullWidth = false,
    this.disabled = false,
  });

  @override
  State<AmaniButton> createState() => _AmaniButtonState();
}

class _AmaniButtonState extends State<AmaniButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.disabled || widget.onPressed == null;

    Color bg;
    Color fg;
    Color shadow;

    if (isDisabled) {
      bg = AmaniColors.disabled;
      fg = AmaniColors.textSecondary;
      shadow = Colors.transparent;
    } else {
      switch (widget.variant) {
        case AmaniButtonVariant.primary:
          bg = AmaniColors.primary; // bg-primary en React : brun (#A9784F)
          fg = AmaniColors.surface;
          shadow = AmaniColors.primaryDark;
          break;
        case AmaniButtonVariant.secondary:
          bg = AmaniColors.secondary; // bg-secondary en React : vert (#8FBF6F)
          fg = AmaniColors.surface;
          shadow = AmaniColors.secondaryDark;
          break;
        case AmaniButtonVariant.danger:
          bg = AmaniColors.error;
          fg = AmaniColors.surface;
          shadow = const Color(0xFFB53D3D);
          break;
        case AmaniButtonVariant.ghost:
          bg = Colors.transparent;
          fg = AmaniColors.primary;
          shadow = Colors.transparent;
          break;
      }
    }

    final isGhost = widget.variant == AmaniButtonVariant.ghost;
    final yOffset = _isPressed && !isDisabled && !isGhost ? 4.0 : 0.0;
    final shadowHeight = isGhost || isDisabled ? 0.0 : (_isPressed ? 0.0 : 4.0);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (!isDisabled) widget.onPressed!();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, yOffset, 0),
        width: widget.fullWidth ? double.infinity : null,
        height: 58,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(29),
          boxShadow: [
            if (shadowHeight > 0)
              BoxShadow(
                color: shadow,
                offset: Offset(0, shadowHeight),
                blurRadius: 0,
              ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisSize: widget.fullWidth
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: fg, size: 24),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: TextStyle(
                    color: fg,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
