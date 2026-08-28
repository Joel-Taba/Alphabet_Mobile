import 'package:flutter/material.dart';
import 'lettered_choice_button.dart';

const List<String> _letters = ['A', 'B', 'C', 'D', 'E', 'F'];

/// Grille de réponses "A/B/C/D..." en 2 colonnes — même mécanique de tap
/// (correct verrouille en vert, incorrect flashe en rouge puis se réactive)
/// que `McqAnswer`, mais avec le rendu en pilules lettrées de
/// `LetteredChoiceButton` et un contenu de choix libre (texte ou icône) via
/// [contentBuilder]. Générique sur `T` pour couvrir les 3 mini-jeux du
/// Palier "Figures géométriques" (noms de figures, Vrai/Faux, clés d'objet).
class LetteredChoiceGrid<T> extends StatefulWidget {
  final List<T> choices;
  final T correctChoice;
  final Widget Function(T choice) contentBuilder;
  final bool isActive;
  final bool isFuture;
  final bool solved;
  final VoidCallback onSolved;
  final int columns;

  const LetteredChoiceGrid({
    super.key,
    required this.choices,
    required this.correctChoice,
    required this.contentBuilder,
    required this.isActive,
    required this.isFuture,
    required this.solved,
    required this.onSolved,
    this.columns = 2,
  });

  @override
  State<LetteredChoiceGrid<T>> createState() => _LetteredChoiceGridState<T>();
}

class _LetteredChoiceGridState<T> extends State<LetteredChoiceGrid<T>> {
  T? _wrongChoice;

  void _handleTap(T choice) {
    if (!widget.isActive || widget.isFuture || widget.solved) return;
    if (choice == widget.correctChoice) {
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
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: widget.columns,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.4,
      children: [
        for (var i = 0; i < widget.choices.length; i++)
          LetteredChoiceButton(
            letter: i < _letters.length ? _letters[i] : '${i + 1}',
            content: widget.contentBuilder(widget.choices[i]),
            state: widget.solved && widget.choices[i] == widget.correctChoice
                ? ChoiceVisualState.correct
                : _wrongChoice == widget.choices[i]
                ? ChoiceVisualState.wrong
                : ChoiceVisualState.idle,
            dimmed: widget.solved && widget.choices[i] != widget.correctChoice,
            onTap: () => _handleTap(widget.choices[i]),
          ),
      ],
    );
  }
}
