import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../data/letter_style_resolver.dart';
import '../data/word_cloze.dart';
import '../theme/amani_theme.dart';
import 'letter_trace_cell.dart';

/// Un jeton glissé porte son index (pour le retirer de la pioche une fois
/// utilisé) et la lettre qu'il représente.
class _DragPayload {
  final int optionIndex;
  final String letter;
  const _DragPayload(this.optionIndex, this.letter);
}

/// Exercice à trous glisser-déposer pour un mot du Palier "Mots" : une
/// lettre est masquée (voir `buildWordCloze`), l'enfant doit glisser la
/// bonne lettre — parmi plusieurs jetons proposés — dans la case vide.
/// Alternative au tracé (`WordTraceAttempt`) pour une partie des groupes de
/// mots, voir `kClozeGroupIds` dans `word_catalog.dart`. Contrairement au
/// tracé, un seul essai suffit : pas de notion de répétitions ici, le
/// principe est la reconnaissance/le placement, pas le geste d'écriture.
class WordClozeAttempt extends StatefulWidget {
  final WordClozeSpec spec;
  final String style;
  final double cellSize;
  final VoidCallback onSolved;

  /// `true` si ce mot a déjà été résolu lors d'une session précédente
  /// (persistance permanente) : la case s'affiche d'emblée remplie de la
  /// bonne lettre, sans jetons à glisser.
  final bool initiallyDone;

  const WordClozeAttempt({
    super.key,
    required this.spec,
    required this.style,
    this.cellSize = 48,
    required this.onSolved,
    this.initiallyDone = false,
  });

  @override
  State<WordClozeAttempt> createState() => _WordClozeAttemptState();
}

class _WordClozeAttemptState extends State<WordClozeAttempt> {
  late bool _solved = widget.initiallyDone;
  bool _wrongFeedback = false;
  final Set<int> _usedOptions = {};
  Timer? _feedbackTimer;
  final Map<int, GlobalKey<_ShakeChipState>> _chipKeys = {};

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    super.dispose();
  }

  Map<String, dynamic> _formationFor(String char) =>
      getLetterFormation(char, widget.style) ?? {'char': char};

  void _handleDrop(_DragPayload payload) {
    if (_solved || _usedOptions.contains(payload.optionIndex)) return;
    if (payload.letter.toLowerCase() ==
        widget.spec.correctLetter.toLowerCase()) {
      _feedbackTimer?.cancel();
      setState(() {
        _solved = true;
        _usedOptions.add(payload.optionIndex);
        _wrongFeedback = false;
      });
      widget.onSolved();
      return;
    }
    setState(() => _wrongFeedback = true);
    _chipKeys[payload.optionIndex]?.currentState?.shake();
    _feedbackTimer?.cancel();
    _feedbackTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _wrongFeedback = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final spec = widget.spec;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (var i = 0; i < spec.letters.length; i++)
              if (i == spec.blankIndex)
                _BlankSlot(
                  size: widget.cellSize,
                  wrong: _wrongFeedback,
                  filled: _solved
                      ? _formationFor(spec.correctLetter)
                      : null,
                  onAccept: _handleDrop,
                )
              else
                LetterTraceCell(
                  letter: _formationFor(spec.letters[i]),
                  size: widget.cellSize,
                  isActive: false,
                  given: true,
                ),
          ],
        ),
        if (!_solved) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < spec.options.length; i++)
                if (!_usedOptions.contains(i)) _draggableChip(i),
            ],
          ),
        ],
      ],
    );
  }

  Widget _draggableChip(int index) {
    final letter = widget.spec.options[index];
    final key = _chipKeys.putIfAbsent(
      index,
      () => GlobalKey<_ShakeChipState>(),
    );
    final glyph = LetterTraceCell(
      letter: _formationFor(letter),
      size: widget.cellSize * 0.8,
      isActive: false,
      given: true,
    );
    final payload = _DragPayload(index, letter);
    return Draggable<_DragPayload>(
      data: payload,
      feedback: Material(
        color: Colors.transparent,
        child: _ShakeChip(key: key, child: glyph),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: glyph),
      child: _ShakeChip(key: key, child: glyph),
    );
  }
}

/// Case vide (le trou) — cible de glisser-déposer : verte puis figée sur la
/// lettre une fois résolue, rouge brièvement sur un mauvais dépôt — même
/// convention de couleurs que `_PuzzleSlot`
/// (`exercice_puzzle_formule_screen.dart`) et "Compose le nombre !".
class _BlankSlot extends StatelessWidget {
  final double size;
  final bool wrong;
  final Map<String, dynamic>? filled;
  final ValueChanged<_DragPayload> onAccept;

  const _BlankSlot({
    required this.size,
    required this.wrong,
    required this.filled,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    if (filled != null) {
      return LetterTraceCell(letter: filled, size: size, isActive: false, given: true);
    }
    return DragTarget<_DragPayload>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) => onAccept(details.data),
      builder: (context, candidateData, rejectedData) {
        final hovering = candidateData.isNotEmpty;
        final borderColor = wrong
            ? AmaniColors.error
            : hovering
            ? AmaniColors.primary.withValues(alpha: 0.6)
            : AmaniColors.textPrimary.withValues(alpha: 0.3);
        final fillColor = wrong
            ? AmaniColors.error.withValues(alpha: 0.14)
            : hovering
            ? AmaniColors.primary.withValues(alpha: 0.08)
            : AmaniColors.background;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            '?',
            style: TextStyle(
              fontFamily: kBalooFontFamily,
              fontWeight: FontWeight.w800,
              fontSize: size * 0.4,
              color: borderColor,
            ),
          ),
        );
      },
    );
  }
}

/// Jeton de lettre pouvant se secouer horizontalement sur un mauvais dépôt
/// — même principe que `PuzzlePieceCardState.shake()`
/// (`lib/widgets/puzzle_piece.dart`).
class _ShakeChip extends StatefulWidget {
  final Widget child;
  const _ShakeChip({super.key, required this.child});

  @override
  State<_ShakeChip> createState() => _ShakeChipState();
}

class _ShakeChipState extends State<_ShakeChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeCtrl;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  void shake() => _shakeCtrl.forward(from: 0);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeCtrl,
      builder: (context, child) {
        final t = _shakeCtrl.value;
        final dx = math.sin(t * math.pi * 6) * (1 - t) * 7;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: widget.child,
    );
  }
}
