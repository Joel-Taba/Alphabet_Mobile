import 'package:flutter/material.dart';
import '../theme/amani_theme.dart';
import '../data/calcul_catalog.dart';

/// Statut d'une case après une tentative complète, façon "Wordle" — même
/// principe que le clavier des tables de multiplication
/// (`digit_keypad_answer.dart`) : vert le nombre/signe est bien placé,
/// jaune il fait partie de la solution mais au mauvais endroit, rouge il
/// n'en fait pas partie du tout. Nombres et signes sont comparés
/// séparément (deux "alphabets" différents).
enum _TileStatus { green, yellow, red }

List<_TileStatus> _wordleStatuses<T>(List<T> guess, List<T> solution) {
  final n = guess.length;
  final statuses = List<_TileStatus>.filled(n, _TileStatus.red);
  final remaining = <T, int>{};
  for (var i = 0; i < n; i++) {
    if (guess[i] == solution[i]) {
      statuses[i] = _TileStatus.green;
    } else {
      remaining[solution[i]] = (remaining[solution[i]] ?? 0) + 1;
    }
  }
  for (var i = 0; i < n; i++) {
    if (statuses[i] == _TileStatus.green) continue;
    final g = guess[i];
    if ((remaining[g] ?? 0) > 0) {
      statuses[i] = _TileStatus.yellow;
      remaining[g] = remaining[g]! - 1;
    }
  }
  return statuses;
}

Color _colorForStatus(_TileStatus? status) {
  switch (status) {
    case _TileStatus.green:
      return AmaniColors.success;
    case _TileStatus.yellow:
      return AmaniColors.warning;
    case _TileStatus.red:
      return AmaniColors.error;
    case null:
      return AmaniColors.textPrimary.withValues(alpha: 0.15);
  }
}

/// Interaction du mini-jeu "Compose le nombre !" : des cases vides à
/// remplir (nombres et signes) puis un pool de tuiles tapables en-dessous.
/// Taper une tuile la place dans la prochaine case vide de son type et la
/// désactive dans le pool ; taper une case remplie la remet dans le pool.
/// La validation est automatique dès que toutes les cases sont remplies —
/// vert et [onCorrect] si le résultat correspond à la cible, rouge puis
/// vidage automatique sinon (les tuiles restent réutilisables).
///
/// Le parent doit donner une [Key] différente par puzzle (ex.
/// `ValueKey(puzzleIndex)`) pour que l'état morden se réinitialise
/// automatiquement au changement de puzzle.
class NumberComposePuzzleWidget extends StatefulWidget {
  final NumberComposePuzzle puzzle;
  final VoidCallback onCorrect;

  const NumberComposePuzzleWidget({
    super.key,
    required this.puzzle,
    required this.onCorrect,
  });

  @override
  State<NumberComposePuzzleWidget> createState() =>
      _NumberComposePuzzleWidgetState();
}

class _NumberComposePuzzleWidgetState
    extends State<NumberComposePuzzleWidget> {
  late List<int?> _slotNumberTileIdx;
  late List<int?> _slotOperatorTileIdx;
  bool? _feedbackCorrect;
  List<_TileStatus>? _numberStatuses;
  List<_TileStatus>? _operatorStatuses;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    _slotNumberTileIdx = List<int?>.filled(widget.puzzle.slotCount, null);
    _slotOperatorTileIdx = List<int?>.filled(
      widget.puzzle.slotCount - 1,
      null,
    );
    _feedbackCorrect = null;
    _numberStatuses = null;
    _operatorStatuses = null;
  }

  void _tapNumberTile(int tileIdx) {
    if (_feedbackCorrect != null) return;
    if (_slotNumberTileIdx.contains(tileIdx)) return;
    final emptySlot = _slotNumberTileIdx.indexOf(null);
    if (emptySlot == -1) return;
    setState(() => _slotNumberTileIdx[emptySlot] = tileIdx);
    _maybeValidate();
  }

  void _tapOperatorTile(int tileIdx) {
    if (_feedbackCorrect != null) return;
    if (_slotOperatorTileIdx.contains(tileIdx)) return;
    final emptySlot = _slotOperatorTileIdx.indexOf(null);
    if (emptySlot == -1) return;
    setState(() => _slotOperatorTileIdx[emptySlot] = tileIdx);
    _maybeValidate();
  }

  void _clearNumberSlot(int slot) {
    if (_feedbackCorrect != null) return;
    setState(() => _slotNumberTileIdx[slot] = null);
  }

  void _clearOperatorSlot(int slot) {
    if (_feedbackCorrect != null) return;
    setState(() => _slotOperatorTileIdx[slot] = null);
  }

  void _maybeValidate() {
    if (_slotNumberTileIdx.contains(null) ||
        _slotOperatorTileIdx.contains(null)) {
      return;
    }
    final nums = _slotNumberTileIdx
        .map((i) => widget.puzzle.numberTiles[i!])
        .toList();
    final ops = _slotOperatorTileIdx
        .map((i) => widget.puzzle.operatorTiles[i!])
        .toList();
    final correct = evalComposeLeftToRight(nums, ops) == widget.puzzle.target;
    setState(() {
      _feedbackCorrect = correct;
      _numberStatuses = _wordleStatuses<int>(nums, widget.puzzle.solutionNumbers);
      _operatorStatuses = _wordleStatuses<String>(
        ops,
        widget.puzzle.solutionOperators,
      );
    });
    if (correct) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) widget.onCorrect();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1100), () {
        if (mounted) setState(_reset);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < widget.puzzle.slotCount; i++) ...[
              _Slot(
                label: _slotNumberTileIdx[i] != null
                    ? '${widget.puzzle.numberTiles[_slotNumberTileIdx[i]!]}'
                    : '',
                borderColor: _colorForStatus(_numberStatuses?[i]),
                onTap: _slotNumberTileIdx[i] != null
                    ? () => _clearNumberSlot(i)
                    : null,
              ),
              if (i < widget.puzzle.slotCount - 1)
                _Slot(
                  label: _slotOperatorTileIdx[i] != null
                      ? widget.puzzle.operatorTiles[_slotOperatorTileIdx[i]!]
                      : '',
                  borderColor: _colorForStatus(_operatorStatuses?[i]),
                  isOperator: true,
                  onTap: _slotOperatorTileIdx[i] != null
                      ? () => _clearOperatorSlot(i)
                      : null,
                ),
            ],
            const SizedBox(width: 4),
            Text(
              '=',
              style: TextStyle(
                fontFamily: kBalooFontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 26,
                color: AmaniColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${widget.puzzle.target}',
              style: TextStyle(
                fontFamily: kBalooFontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 26,
                color: AmaniColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var i = 0; i < widget.puzzle.numberTiles.length; i++)
              _PoolTile(
                label: '${widget.puzzle.numberTiles[i]}',
                used: _slotNumberTileIdx.contains(i),
                onTap: () => _tapNumberTile(i),
              ),
            for (var i = 0; i < widget.puzzle.operatorTiles.length; i++)
              _PoolTile(
                label: widget.puzzle.operatorTiles[i],
                used: _slotOperatorTileIdx.contains(i),
                isOperator: true,
                onTap: () => _tapOperatorTile(i),
              ),
          ],
        ),
      ],
    );
  }
}

class _Slot extends StatelessWidget {
  final String label;
  final Color borderColor;
  final bool isOperator;
  final VoidCallback? onTap;

  const _Slot({
    required this.label,
    required this.borderColor,
    this.isOperator = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isOperator ? 44 : 52,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: label.isEmpty ? AmaniColors.surface : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: kBalooFontFamily,
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: AmaniColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _PoolTile extends StatelessWidget {
  final String label;
  final bool used;
  final bool isOperator;
  final VoidCallback onTap;

  const _PoolTile({
    required this.label,
    required this.used,
    this.isOperator = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: used ? null : onTap,
      child: AnimatedOpacity(
        opacity: used ? 0.25 : 1,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: isOperator ? 48 : 52,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isOperator
                ? const Color(0x1F8B5FBF)
                : AmaniColors.background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isOperator
                  ? const Color(0xFF8B5FBF)
                  : AmaniColors.textPrimary.withValues(alpha: 0.15),
              width: 2,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: kBalooFontFamily,
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: isOperator
                  ? const Color(0xFF6B3F94)
                  : AmaniColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
