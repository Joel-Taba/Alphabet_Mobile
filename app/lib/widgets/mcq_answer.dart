import 'package:flutter/material.dart';
import '../theme/amani_theme.dart';

/// Grille de réponses à choix multiples (QCM) — utilisée quand
/// [CalculProblem.choices] est non `null`, en alternative au traçage de
/// chiffres. Un tap correct verrouille le bouton en vert et déclenche
/// [onSolved] ; un tap incorrect flashe brièvement en rouge puis se
/// réactive, sans bloquer d'autres tentatives.
class McqAnswer extends StatefulWidget {
  final List<String> choices;
  final String correctAnswer;
  final bool isActive;
  final bool isFuture;
  final bool solved;
  final VoidCallback onSolved;

  /// Largeur minimale d'un bouton — 68 (par défaut) convient à des chiffres
  /// courts ; les appelants avec des libellés plus longs (noms de figures...)
  /// peuvent l'élargir pour éviter un retour à la ligne au milieu d'un mot.
  final double minWidth;

  const McqAnswer({
    super.key,
    required this.choices,
    required this.correctAnswer,
    required this.isActive,
    required this.isFuture,
    required this.solved,
    required this.onSolved,
    this.minWidth = 68,
  });

  @override
  State<McqAnswer> createState() => _McqAnswerState();
}

class _McqAnswerState extends State<McqAnswer> {
  String? _wrongChoice;

  void _handleTap(String choice) {
    if (!widget.isActive || widget.isFuture || widget.solved) return;
    if (choice == widget.correctAnswer) {
      setState(() => _wrongChoice = null);
      widget.onSolved();
      return;
    }
    setState(() => _wrongChoice = choice);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _wrongChoice = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: [
          for (final choice in widget.choices)
            _ChoiceButton(
              label: choice,
              state: widget.solved && choice == widget.correctAnswer
                  ? _ChoiceState.correct
                  : _wrongChoice == choice
                  ? _ChoiceState.wrong
                  : _ChoiceState.idle,
              dimmed: widget.solved && choice != widget.correctAnswer,
              onTap: () => _handleTap(choice),
              minWidth: widget.minWidth,
            ),
        ],
      ),
    );
  }
}

enum _ChoiceState { idle, correct, wrong }

class _ChoiceButton extends StatelessWidget {
  final String label;
  final _ChoiceState state;
  final bool dimmed;
  final VoidCallback onTap;
  final double minWidth;

  const _ChoiceButton({
    required this.label,
    required this.state,
    required this.dimmed,
    required this.onTap,
    required this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final Color border;
    switch (state) {
      case _ChoiceState.correct:
        bg = AmaniColors.success.withValues(alpha: 0.18);
        fg = AmaniColors.success;
        border = AmaniColors.success;
        break;
      case _ChoiceState.wrong:
        bg = AmaniColors.error.withValues(alpha: 0.14);
        fg = AmaniColors.error;
        border = AmaniColors.error;
        break;
      case _ChoiceState.idle:
        bg = AmaniColors.surface;
        fg = AmaniColors.textPrimary;
        border = AmaniColors.textPrimary.withValues(alpha: 0.15);
        break;
    }
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: dimmed ? 0.4 : 1,
        duration: const Duration(milliseconds: 200),
        child: Container(
          constraints: BoxConstraints(minWidth: minWidth, minHeight: 52),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: 2),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: kBalooFontFamily,
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: fg,
            ),
          ),
        ),
      ),
    );
  }
}
