import 'package:flutter/material.dart';
import '../theme/amani_theme.dart';

/// Statut d'une case après une tentative complète, façon "Wordle" : vert le
/// chiffre est bien placé, jaune il fait partie de la réponse mais au
/// mauvais endroit, rouge il n'en fait pas partie du tout. Gère les chiffres
/// en double correctement (ex. réponse "44") : un chiffre en trop ne peut
/// être compté "jaune" que s'il reste un exemplaire non déjà apparié.
enum _DigitStatus { green, yellow, red }

List<_DigitStatus> _digitStatuses(String guess, String answer) {
  final n = guess.length;
  final statuses = List<_DigitStatus>.filled(n, _DigitStatus.red);
  final remaining = <String, int>{};
  for (var i = 0; i < n; i++) {
    if (guess[i] == answer[i]) {
      statuses[i] = _DigitStatus.green;
    } else {
      remaining[answer[i]] = (remaining[answer[i]] ?? 0) + 1;
    }
  }
  for (var i = 0; i < n; i++) {
    if (statuses[i] == _DigitStatus.green) continue;
    final c = guess[i];
    if ((remaining[c] ?? 0) > 0) {
      statuses[i] = _DigitStatus.yellow;
      remaining[c] = remaining[c]! - 1;
    }
  }
  return statuses;
}

/// Réponse composée chiffre par chiffre à l'aide d'un clavier numérique 0-9
/// permanent et réutilisable (contrairement à `NumberComposePuzzleWidget`,
/// les chiffres ne sont jamais "consommés" — comme un vrai clavier). Utilisé
/// pour les tables de multiplication : l'enfant compose le résultat en
/// touchant les chiffres dans l'ordre, plutôt qu'en le traçant à la main.
/// Une fois toutes les cases remplies, chacune se colore individuellement
/// (vert/jaune/rouge) pour orienter la tentative suivante en cas d'erreur.
class DigitKeypadAnswer extends StatefulWidget {
  final String correctAnswer;
  final bool isActive;
  final bool isFuture;
  final bool solved;
  final VoidCallback onSolved;

  const DigitKeypadAnswer({
    super.key,
    required this.correctAnswer,
    required this.isActive,
    required this.isFuture,
    required this.solved,
    required this.onSolved,
  });

  @override
  State<DigitKeypadAnswer> createState() => _DigitKeypadAnswerState();
}

class _DigitKeypadAnswerState extends State<DigitKeypadAnswer> {
  late List<String?> _slots;
  List<_DigitStatus>? _slotStatuses;

  @override
  void initState() {
    super.initState();
    _slots = List<String?>.filled(widget.correctAnswer.length, null);
  }

  void _reset() {
    _slots = List<String?>.filled(widget.correctAnswer.length, null);
    _slotStatuses = null;
  }

  void _tapDigit(String digit) {
    if (!widget.isActive || widget.isFuture || widget.solved) return;
    if (_slotStatuses != null) return;
    final emptySlot = _slots.indexOf(null);
    if (emptySlot == -1) return;
    setState(() => _slots[emptySlot] = digit);
    if (!_slots.contains(null)) {
      final guess = _slots.join();
      final correct = guess == widget.correctAnswer;
      setState(() => _slotStatuses = _digitStatuses(guess, widget.correctAnswer));
      if (correct) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) widget.onSolved();
        });
      } else {
        Future.delayed(const Duration(milliseconds: 1100), () {
          if (mounted) setState(_reset);
        });
      }
    }
  }

  void _clearSlot(int i) {
    if (!widget.isActive || widget.isFuture || widget.solved) return;
    if (_slotStatuses != null) return;
    setState(() => _slots[i] = null);
  }

  Color _borderColorFor(int i) {
    final status = _slotStatuses?[i];
    switch (status) {
      case _DigitStatus.green:
        return AmaniColors.success;
      case _DigitStatus.yellow:
        return AmaniColors.warning;
      case _DigitStatus.red:
        return AmaniColors.error;
      case null:
        return AmaniColors.textPrimary.withValues(alpha: 0.15);
    }
  }

  Color? _fillColorFor(int i) {
    final status = _slotStatuses?[i];
    switch (status) {
      case _DigitStatus.green:
        return AmaniColors.success.withValues(alpha: 0.15);
      case _DigitStatus.yellow:
        return AmaniColors.warning.withValues(alpha: 0.2);
      case _DigitStatus.red:
        return AmaniColors.error.withValues(alpha: 0.12);
      case null:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < _slots.length; i++)
                GestureDetector(
                  onTap: _slots[i] != null ? () => _clearSlot(i) : null,
                  child: Container(
                    width: 48,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _fillColorFor(i) ??
                          (_slots[i] == null ? AmaniColors.surface : Colors.white),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _borderColorFor(i), width: 2.5),
                    ),
                    child: Text(
                      _slots[i] ?? '',
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        color: AmaniColors.textPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (widget.isActive && !widget.isFuture && !widget.solved) ...[
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var d = 0; d <= 9; d++)
                  GestureDetector(
                    onTap: () => _tapDigit('$d'),
                    child: Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0x1F8B5FBF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF8B5FBF),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        '$d',
                        style: TextStyle(
                          fontFamily: kBalooFontFamily,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          color: const Color(0xFF6B3F94),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
