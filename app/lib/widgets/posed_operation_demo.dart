import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/amani_theme.dart';

/// Poser une opération colonne par colonne (addition, soustraction,
/// multiplication) ou en potence (division), avec retenues/emprunts animés
/// — voir le Cours du Palier "Les Calculs" pour les 4 sujets "posés"
/// (`CalculTopic.posedOperation`). Reprend le code couleur unités/dizaines/
/// centaines de la fiche de référence fournie par l'utilisateur, et le même
/// principe d'animation qu'ailleurs dans l'app (`MiniLetterFrame`) : un seul
/// `AnimationController` dont la valeur pilote combien d'étapes sont déjà
/// révélées, rejoué à chaque "Relancer".
const Color kUnitsColor = Color(0xFF2D6BBF);
const Color kTensColor = Color(0xFFD0524A);
const Color kHundredsColor = Color(0xFF5E8E3E);

Color _placeColor(int placeIndex) {
  const palette = [kUnitsColor, kTensColor, kHundredsColor];
  return palette[placeIndex < palette.length ? placeIndex : palette.length - 1];
}

List<int> _digitsLsb(int n) =>
    n.toString().split('').reversed.map(int.parse).toList();

/// Carré à fond blanc et chiffre en noir gras — cette combinaison à fort
/// contraste (plutôt qu'un fond teinté par la couleur de colonne) sert
/// volontairement à bien distinguer le chiffre lui-même ; la couleur de
/// colonne/rôle reste portée par la bordure.
class _ColumnCell extends StatelessWidget {
  final int? value;
  final Color color;
  final double size;
  const _ColumnCell({this.value, required this.color, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 2),
      ),
      child: Text(
        value != null ? '$value' : '',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: size * 0.45,
          color: Colors.black,
        ),
      ),
    );
  }
}

/// Une rangée de cases-chiffres alignées à droite sur [width] positions
/// (complétée de cases invisibles à gauche pour les nombres plus courts) —
/// pour que les chiffres de même rang (unités sous unités, dizaines sous
/// dizaines...) restent alignés d'une ligne à l'autre dans le déroulé de la
/// division posée.
class _AlignedDigitRow extends StatelessWidget {
  static const double _size = 32;
  final int number;
  final int width;
  final Color color;
  const _AlignedDigitRow({
    required this.number,
    required this.width,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final digits = '$number'.padLeft(width).split('');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final ch in digits)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: ch == ' '
                ? const SizedBox(width: _size, height: _size)
                : _ColumnCell(value: int.parse(ch), color: color, size: _size),
          ),
      ],
    );
  }
}

/// Petit badge rond (retenue, ou "+10"/"-1" d'un emprunt) au-dessus d'une
/// colonne — vide tant que l'étape correspondante n'est pas révélée.
class _CarryBadge extends StatelessWidget {
  final String label;
  final Color color;
  final bool visible;
  const _CarryBadge({
    required this.label,
    required this.color,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: Center(
        child: AnimatedScale(
          scale: visible ? 1 : 0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: color, width: 1.5),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 11,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Case du signe opératoire (+, −, ×) — carré à fond blanc et contour NOIR
/// (délibérément distinct des cases-chiffres, dont le contour suit la
/// couleur du rang), en gros pour rester le repère le plus visible de toute
/// l'opération posée. La hauteur qui précède le carré est ajustée pour que
/// son bord inférieur reste aligné avec celui du 2ᵉ opérande (`digitB`),
/// exactement comme avant l'agrandissement (hauteur totale de la colonne
/// inchangée : 26 + 24 + 4 + 56 = 110, comme 26 + 40 + 4 + 40 auparavant).
class _OpSignCell extends StatelessWidget {
  final String label;
  const _OpSignCell({required this.label});

  static const double _boxSize = 56;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 26),
        const SizedBox(height: 24),
        const SizedBox(height: 4),
        Container(
          width: _boxSize,
          height: _boxSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 3),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: kBalooFontFamily,
              fontWeight: FontWeight.w900,
              fontSize: 32,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

/// Légende courte expliquant la signification de chaque couleur utilisée
/// dans la démonstration — courte et simple à dessein (voir demande
/// utilisateur : "doit participer à l'apprentissage" plutôt que d'ajouter du
/// bruit visuel).
class _ColorLegend extends StatelessWidget {
  final List<(Color, String)> items;
  const _ColorLegend({required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 14,
      runSpacing: 6,
      children: [
        for (final item in items)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 11,
                height: 11,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  color: item.$1,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                item.$2,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AmaniColors.textSecondary,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _AddSubStep {
  final int? digitA;
  final int? digitB;
  final String? topBadge; // carry-in ("+n") shown above this column
  final String? lentBadge; // "-1" badge (soustraction : a prêté au voisin)
  final int resultDigit;
  const _AddSubStep({
    this.digitA,
    this.digitB,
    this.topBadge,
    this.lentBadge,
    required this.resultDigit,
  });
}

List<_AddSubStep> _additionSteps(int a, int b) {
  final da = _digitsLsb(a);
  final db = _digitsLsb(b);
  final maxLen = da.length > db.length ? da.length : db.length;
  final steps = <_AddSubStep>[];
  var carry = 0;
  for (var i = 0; i < maxLen; i++) {
    final x = i < da.length ? da[i] : null;
    final y = i < db.length ? db[i] : null;
    final sum = (x ?? 0) + (y ?? 0) + carry;
    steps.add(
      _AddSubStep(
        digitA: x,
        digitB: y,
        topBadge: carry > 0 ? '+$carry' : null,
        resultDigit: sum % 10,
      ),
    );
    carry = sum ~/ 10;
  }
  if (carry > 0) {
    steps.add(_AddSubStep(topBadge: null, resultDigit: carry));
    // La dernière colonne (retenue seule) affiche son propre badge en tant
    // que retenue ENTRANTE de la colonne fictive suivante : on le pose
    // directement comme chiffre de résultat, pas comme badge, pour rester
    // lisible (pas de colonne vide juste pour porter un badge).
  }
  return steps;
}

List<_AddSubStep> _subtractionSteps(int a, int b) {
  final da = _digitsLsb(a);
  final db = _digitsLsb(b);
  final raw = <Map<String, int>>[];
  var borrow = 0;
  for (var i = 0; i < da.length; i++) {
    final top = da[i] - borrow;
    final bottom = i < db.length ? db[i] : 0;
    var effectiveTop = top;
    var borrowedFromNext = 0;
    if (effectiveTop < bottom) {
      effectiveTop += 10;
      borrowedFromNext = 1;
    }
    raw.add({
      'digitA': da[i],
      'digitB': bottom,
      'hasB': i < db.length ? 1 : 0,
      'result': effectiveTop - bottom,
      'borrowedFromNext': borrowedFromNext,
    });
    borrow = borrowedFromNext;
  }
  final steps = <_AddSubStep>[];
  for (var i = 0; i < raw.length; i++) {
    final r = raw[i];
    final lentToRight = i > 0 && raw[i - 1]['borrowedFromNext'] == 1;
    steps.add(
      _AddSubStep(
        digitA: r['digitA'],
        digitB: r['hasB'] == 1 ? r['digitB'] : null,
        topBadge: r['borrowedFromNext'] == 1 ? '+10' : null,
        lentBadge: lentToRight ? '-1' : null,
        resultDigit: r['result']!,
      ),
    );
  }
  return steps;
}

enum _PosedKind { addition, soustraction }

class _ColumnOperationDemo extends StatefulWidget {
  final int a;
  final int b;
  final _PosedKind kind;
  const _ColumnOperationDemo({
    required this.a,
    required this.b,
    required this.kind,
  });

  @override
  State<_ColumnOperationDemo> createState() => _ColumnOperationDemoState();
}

class _ColumnOperationDemoState extends State<_ColumnOperationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_AddSubStep> _steps;

  List<_AddSubStep> _computeSteps() {
    switch (widget.kind) {
      case _PosedKind.addition:
        return _additionSteps(widget.a, widget.b);
      case _PosedKind.soustraction:
        return _subtractionSteps(widget.a, widget.b);
    }
  }

  @override
  void initState() {
    super.initState();
    _steps = _computeSteps();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _steps.length * 850 + 500),
    );
    _play();
  }

  void _play() {
    _controller.reset();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(covariant _ColumnOperationDemo old) {
    super.didUpdateWidget(old);
    if (old.a != widget.a || old.b != widget.b || old.kind != widget.kind) {
      _steps = _computeSteps();
      _controller.duration = Duration(milliseconds: _steps.length * 850 + 500);
      _play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const List<(Color, String)> _additionLegend = [
    (kUnitsColor, 'Unités'),
    (kTensColor, 'Dizaines'),
    (kHundredsColor, 'Centaines'),
  ];
  static const List<(Color, String)> _soustractionLegend = [
    (kUnitsColor, 'Unités'),
    (kTensColor, 'Dizaines'),
    (kHundredsColor, 'Centaines'),
    (kUnitsColor, '+10 = dizaine empruntée'),
    (AmaniColors.error, '-1 = dizaine prêtée'),
  ];

  @override
  Widget build(BuildContext context) {
    final display = _steps.reversed.toList();
    final sign = widget.kind == _PosedKind.addition ? '+' : '-';
    final legend = widget.kind == _PosedKind.addition
        ? _additionLegend
        : _soustractionLegend;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final revealed = (_controller.value * _steps.length).floor().clamp(
              0,
              _steps.length,
            );
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _OpSignCell(label: sign),
                for (var col = 0; col < display.length; col++)
                  _buildColumn(display, col, revealed),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        _ColorLegend(items: legend),
      ],
    );
  }

  Widget _buildColumn(List<_AddSubStep> display, int col, int revealed) {
    final originalIndex = display.length - 1 - col;
    final step = display[col];
    final isRevealed = originalIndex < revealed;
    final color = _placeColor(originalIndex);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 26,
            width: 48,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                if (step.topBadge != null)
                  _CarryBadge(
                    label: step.topBadge!,
                    color: color,
                    visible: isRevealed,
                  ),
                if (step.lentBadge != null)
                  Positioned(
                    right: -4,
                    top: 0,
                    child: _CarryBadge(
                      label: step.lentBadge!,
                      color: AmaniColors.error,
                      visible: isRevealed,
                    ),
                  ),
              ],
            ),
          ),
          _ColumnCell(value: step.digitA, color: color),
          const SizedBox(height: 4),
          _ColumnCell(value: step.digitB, color: color),
          const SizedBox(height: 6),
          Container(height: 2, width: 40, color: AmaniColors.textPrimary),
          const SizedBox(height: 6),
          AnimatedOpacity(
            opacity: isRevealed ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: _ColumnCell(value: step.resultDigit, color: color),
          ),
        ],
      ),
    );
  }
}

/// Addition posée, colonnes unités/dizaines/centaines, retenues animées.
class AdditionPoseeDemo extends StatelessWidget {
  final int a;
  final int b;
  const AdditionPoseeDemo({super.key, required this.a, required this.b});

  @override
  Widget build(BuildContext context) =>
      _ColumnOperationDemo(a: a, b: b, kind: _PosedKind.addition);
}

/// Soustraction posée, emprunts animés (badge "+10" / "-1").
class SoustractionPoseeDemo extends StatelessWidget {
  final int a;
  final int b;
  const SoustractionPoseeDemo({super.key, required this.a, required this.b});

  @override
  Widget build(BuildContext context) =>
      _ColumnOperationDemo(a: a, b: b, kind: _PosedKind.soustraction);
}

// ─── Multiplication posée ──────────────────────────────────────────────
//
// Design distinct de l'addition/soustraction (palette dédiée, multiplicateur
// dans sa propre case, narration textuelle des étapes façon "8 × 7 = 56,
// j'écris 6 et je retiens 5") — inspiré de l'image de référence fournie par
// l'utilisateur. Widget autonome plutôt que branché sur
// `_ColumnOperationDemo` : la présentation diverge trop pour rester un cas
// particulier de l'addition/soustraction sans complexifier ce code partagé.

const Color _multUnitsColor = Color(0xFFD9A441);
const Color _multTensColor = Color(0xFF5E8E3E);
const Color _multHundredsColor = Color(0xFF2D6BBF);
const Color _multOverflowColor = Color(0xFFD0524A);

Color _multColumnColor(int originalIndex, int operandDigitCount) {
  if (originalIndex >= operandDigitCount) return _multOverflowColor;
  const palette = [_multUnitsColor, _multTensColor, _multHundredsColor];
  return palette[originalIndex < palette.length
      ? originalIndex
      : palette.length - 1];
}

class _MultStep {
  final int digitA;
  final int carryIn;
  final int rawProduct;
  final int resultDigit;
  final int carryOut;
  final bool isOverflowOnly;
  const _MultStep({
    required this.digitA,
    required this.carryIn,
    required this.rawProduct,
    required this.resultDigit,
    required this.carryOut,
    this.isOverflowOnly = false,
  });
}

List<_MultStep> _multSteps(int a, int b) {
  final digits = _digitsLsb(a);
  final steps = <_MultStep>[];
  var carry = 0;
  for (final d in digits) {
    final raw = d * b;
    final sum = raw + carry;
    steps.add(
      _MultStep(
        digitA: d,
        carryIn: carry,
        rawProduct: raw,
        resultDigit: sum % 10,
        carryOut: sum ~/ 10,
      ),
    );
    carry = sum ~/ 10;
  }
  if (carry > 0) {
    steps.add(
      _MultStep(
        digitA: 0,
        carryIn: 0,
        rawProduct: 0,
        resultDigit: carry,
        carryOut: 0,
        isOverflowOnly: true,
      ),
    );
  }
  return steps;
}

/// Multiplication posée par un chiffre : colonnes colorées (unités/dizaines/
/// centaines) avec le multiplicateur dans sa propre case, retenues animées,
/// et une phrase par étape en dessous pour rendre chaque calcul explicite.
class MultiplicationPoseeDemo extends StatefulWidget {
  final int a;
  final int b;
  const MultiplicationPoseeDemo({super.key, required this.a, required this.b});

  @override
  State<MultiplicationPoseeDemo> createState() =>
      _MultiplicationPoseeDemoState();
}

class _MultiplicationPoseeDemoState extends State<MultiplicationPoseeDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_MultStep> _steps;
  late int _operandDigitCount;

  void _recompute() {
    _steps = _multSteps(widget.a, widget.b);
    _operandDigitCount = _digitsLsb(widget.a).length;
  }

  @override
  void initState() {
    super.initState();
    _recompute();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _steps.length * 1300 + 500),
    );
    _play();
  }

  void _play() {
    _controller.reset();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(covariant MultiplicationPoseeDemo old) {
    super.didUpdateWidget(old);
    if (old.a != widget.a || old.b != widget.b) {
      _recompute();
      _controller.duration = Duration(milliseconds: _steps.length * 1300 + 500);
      _play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _narrationFor(_MultStep step) {
    if (step.isOverflowOnly) {
      return 'Il reste ${step.resultDigit}, on l\'écrit directement.';
    }
    final base = '${step.digitA} × ${widget.b} = ${step.rawProduct}';
    final withCarry = step.carryIn > 0
        ? '$base  →  ${step.rawProduct} + ${step.carryIn} = ${step.rawProduct + step.carryIn}'
        : base;
    if (step.carryOut > 0) {
      return '$withCarry\nJ\'écris ${step.resultDigit} et je retiens ${step.carryOut}.';
    }
    return '$withCarry\nJ\'écris ${step.resultDigit}.';
  }

  @override
  Widget build(BuildContext context) {
    final display = _steps.reversed.toList();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final revealed = (_controller.value * _steps.length).floor().clamp(
          0,
          _steps.length,
        );
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const _OpSignCell(label: '×'),
                for (var col = 0; col < display.length; col++)
                  _buildColumn(display, col, revealed),
              ],
            ),
            const SizedBox(height: 14),
            for (var i = 0; i < revealed; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  _narrationFor(_steps[i]),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _multColumnColor(i, _operandDigitCount),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            const _ColorLegend(
              items: [
                (_multUnitsColor, 'Unités'),
                (_multTensColor, 'Dizaines'),
                (_multHundredsColor, 'Centaines'),
                (_multOverflowColor, 'Chiffre en plus (retenue finale)'),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildColumn(List<_MultStep> display, int col, int revealed) {
    final originalIndex = display.length - 1 - col;
    final step = display[col];
    final isRevealed = originalIndex < revealed;
    final color = _multColumnColor(originalIndex, _operandDigitCount);
    final isUnitsColumn = originalIndex == 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 26,
            width: 48,
            child: Center(
              child: step.carryIn > 0
                  ? _CarryBadge(
                      label: '+${step.carryIn}',
                      color: color,
                      visible: isRevealed,
                    )
                  : null,
            ),
          ),
          _ColumnCell(
            value: step.isOverflowOnly ? null : step.digitA,
            color: color,
          ),
          const SizedBox(height: 4),
          // Le multiplicateur n'a qu'un chiffre et s'applique à toutes les
          // colonnes : il n'apparaît que sous les unités, dans une case au
          // bord neutre pour bien le distinguer du multiplicande.
          isUnitsColumn
              ? _ColumnCell(value: widget.b, color: AmaniColors.textPrimary)
              : const SizedBox(width: 40, height: 40),
          const SizedBox(height: 6),
          Container(height: 2, width: 40, color: AmaniColors.textPrimary),
          const SizedBox(height: 6),
          AnimatedOpacity(
            opacity: isRevealed ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: _ColumnCell(value: step.resultDigit, color: color),
          ),
        ],
      ),
    );
  }
}

class _DivisionStep {
  final int current;
  final int quotientDigit;
  final int product;
  final int remainder;
  const _DivisionStep({
    required this.current,
    required this.quotientDigit,
    required this.product,
    required this.remainder,
  });
}

List<_DivisionStep> _longDivisionSteps(int dividend, int divisor) {
  final digits = dividend.toString().split('').map(int.parse).toList();
  final steps = <_DivisionStep>[];
  var remainder = 0;
  for (var i = 0; i < digits.length; i++) {
    final current = remainder * 10 + digits[i];
    final isLast = i == digits.length - 1;
    if (current < divisor && !isLast && steps.isEmpty) {
      remainder = current;
      continue;
    }
    final q = current ~/ divisor;
    final r = current % divisor;
    steps.add(
      _DivisionStep(
        current: current,
        quotientDigit: q,
        product: q * divisor,
        remainder: r,
      ),
    );
    remainder = r;
  }
  return steps;
}

/// Division posée en potence : dividende | diviseur, quotient qui se
/// construit au-dessus de la barre, déroulé (valeur courante, produit
/// soustrait, reste) en registre vertical, et un petit rappel de la table
/// du diviseur avec le fait utilisé mis en évidence à l'étape courante.
class DivisionPoseeDemo extends StatefulWidget {
  final int dividend;
  final int divisor;
  const DivisionPoseeDemo({
    super.key,
    required this.dividend,
    required this.divisor,
  });

  @override
  State<DivisionPoseeDemo> createState() => _DivisionPoseeDemoState();
}

class _DivisionPoseeDemoState extends State<DivisionPoseeDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_DivisionStep> _steps;

  @override
  void initState() {
    super.initState();
    _steps = _longDivisionSteps(widget.dividend, widget.divisor);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _steps.length * 1100 + 500),
    );
    _play();
  }

  void _play() {
    _controller.reset();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(covariant DivisionPoseeDemo old) {
    super.didUpdateWidget(old);
    if (old.dividend != widget.dividend || old.divisor != widget.divisor) {
      _steps = _longDivisionSteps(widget.dividend, widget.divisor);
      _controller.duration = Duration(milliseconds: _steps.length * 1100 + 500);
      _play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const Color _dividedColor =
      kTensColor; // rouge : le nombre qu'on partage
  static const Color _subtractedColor =
      kHundredsColor; // vert : ce qu'on enlève
  static const Color _remainderColor = kUnitsColor; // bleu : ce qui reste

  String _stepNarration(int index) {
    final s = _steps[index];
    return 'Étape ${index + 1} : en ${s.current}, combien de fois ${widget.divisor} ?\n'
        'Le plus proche, c\'est ${widget.divisor} × ${s.quotientDigit} = ${s.product}. '
        '${s.current} - ${s.product} = ${s.remainder}.';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final revealed = (_controller.value * _steps.length).floor().clamp(
          0,
          _steps.length,
        );
        final quotient = _steps
            .take(revealed)
            .map((s) => '${s.quotientDigit}')
            .join();
        final currentFact = revealed > 0 && revealed <= _steps.length
            ? _steps[revealed - 1].quotientDigit
            : null;
        final allRevealed = revealed == _steps.length;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.dividend}',
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w800,
                            fontSize: 26,
                            color: AmaniColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 2,
                          height: 32,
                          color: AmaniColors.textPrimary,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.divisor}',
                              style: TextStyle(
                                fontFamily: kBalooFontFamily,
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                                color: kUnitsColor,
                              ),
                            ),
                            Container(
                              height: 2,
                              width: 56,
                              color: AmaniColors.textPrimary,
                            ),
                            SizedBox(
                              height: 30,
                              child: Text(
                                quotient,
                                style: TextStyle(
                                  fontFamily: kBalooFontFamily,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 22,
                                  color: const Color(0xFF8B5FBF),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    for (var i = 0; i < _steps.length; i++)
                      AnimatedOpacity(
                        opacity: i < revealed ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Builder(
                            builder: (context) {
                              final step = _steps[i];
                              // Même largeur pour les 3 nombres de l'étape
                              // (dividende partiel, produit soustrait,
                              // reste) : les chiffres de même rang restent
                              // alignés à la verticale d'une ligne à
                              // l'autre.
                              final width = [
                                '${step.current}'.length,
                                '${step.product}'.length,
                                '${step.remainder}'.length,
                              ].reduce((a, b) => a > b ? a : b);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _AlignedDigitRow(
                                    number: step.current,
                                    width: width,
                                    color: _dividedColor,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 2.5,
                                          ),
                                        ),
                                        child: const Text(
                                          '−',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      _AlignedDigitRow(
                                        number: step.product,
                                        width: width,
                                        color: _subtractedColor,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 1.5,
                                    width: width * 36.0 + 20,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    color: AmaniColors.textPrimary.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                  _AlignedDigitRow(
                                    number: step.remainder,
                                    width: width,
                                    color: _remainderColor,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 20),
                _DivisorTableCard(
                  divisor: widget.divisor,
                  highlight: currentFact,
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < revealed; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  _stepNarration(i),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AmaniColors.textSecondary,
                  ),
                ),
              ),
            if (allRevealed) ...[
              const SizedBox(height: 4),
              Text(
                'Le quotient est $quotient.'
                '${_steps.last.remainder > 0 ? ' Le reste est ${_steps.last.remainder}.' : ''}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: kBalooFontFamily,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: const Color(0xFF6B3F94),
                ),
              ),
            ],
            const SizedBox(height: 10),
            const _ColorLegend(
              items: [
                (_dividedColor, 'Le nombre qu\'on partage'),
                (_subtractedColor, 'Ce qu\'on enlève'),
                (_remainderColor, 'Ce qui reste'),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _DivisorTableCard extends StatelessWidget {
  final int divisor;
  final int? highlight;
  const _DivisorTableCard({required this.divisor, this.highlight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AmaniColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AmaniColors.textPrimary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var n = 1; n <= 10; n++)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 1),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: highlight == n
                    ? const Color(0x268B5FBF)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: highlight == n
                    ? Border.all(color: const Color(0xFF8B5FBF), width: 1.5)
                    : null,
              ),
              child: Text(
                '$divisor × $n = ${divisor * n}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: highlight == n
                      ? FontWeight.w800
                      : FontWeight.w600,
                  color: highlight == n
                      ? const Color(0xFF6B3F94)
                      : AmaniColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Fractions posées à dénominateurs différents ──────────────────────
//
// Illustré par des parts de cercle colorées (pizza) pour chaque fraction,
// puis animation "flèche + facteur" montrant le passage au dénominateur
// commun (simple produit des deux dénominateurs, jamais le PPCM minimal —
// reste simple à expliquer au primaire, la simplification du résultat est
// hors périmètre) avant l'addition finale des numérateurs.

const Color _fractionAColor = kUnitsColor;
const Color _fractionBColor = kTensColor;
const Color _fractionResultColor = Color(0xFF8B5FBF);

class _FractionPiePainter extends CustomPainter {
  final int numerator;
  final int denominator;
  final Color color;
  const _FractionPiePainter({
    required this.numerator,
    required this.denominator,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 2;
    final anglePerSlice = 2 * math.pi / denominator;
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final outlinePaint = Paint()
      ..color = AmaniColors.textPrimary.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (var i = 0; i < denominator; i++) {
      final start = -math.pi / 2 + i * anglePerSlice;
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          start,
          anglePerSlice,
          false,
        )
        ..close();
      if (i < numerator) canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, outlinePaint);
    }
    canvas.drawCircle(center, radius, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant _FractionPiePainter old) =>
      old.numerator != numerator ||
      old.denominator != denominator ||
      old.color != color;
}

class _FractionPie extends StatelessWidget {
  static const double _defaultSize = 64;
  final int numerator;
  final int denominator;
  final Color color;
  final double size;
  const _FractionPie({
    required this.numerator,
    required this.denominator,
    required this.color,
    this.size = _defaultSize,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _FractionPiePainter(
        numerator: numerator,
        denominator: denominator,
        color: color,
      ),
    );
  }
}

/// Camembert + fraction chiffrée empilés — pour que chaque fraction
/// (opérande d'origine, opérande convertie, résultat) soit systématiquement
/// accompagnée de son découpage visuel en parts de cercle, plutôt que du
/// seul chiffrage.
class _FractionCard extends StatelessWidget {
  final int numerator;
  final int denominator;
  final Color color;
  final double pieSize;
  const _FractionCard({
    required this.numerator,
    required this.denominator,
    required this.color,
    this.pieSize = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _FractionPie(
          numerator: numerator,
          denominator: denominator,
          color: color,
          size: pieSize,
        ),
        const SizedBox(height: 6),
        _FractionText(
          numerator: numerator,
          denominator: denominator,
          color: color,
        ),
      ],
    );
  }
}

class _FractionText extends StatelessWidget {
  final int numerator;
  final int denominator;
  final Color color;
  const _FractionText({
    required this.numerator,
    required this.denominator,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$numerator',
          style: TextStyle(
            fontFamily: kBalooFontFamily,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: color,
          ),
        ),
        Container(
          width: 28,
          height: 2.5,
          color: color,
          margin: const EdgeInsets.symmetric(vertical: 2),
        ),
        Text(
          '$denominator',
          style: TextStyle(
            fontFamily: kBalooFontFamily,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ConversionArrow extends StatelessWidget {
  final int factor;
  final Color color;
  const _ConversionArrow({required this.factor, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '× $factor',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: color,
            ),
          ),
          Icon(Icons.arrow_forward_rounded, size: 20, color: color),
        ],
      ),
    );
  }
}

/// Deux fractions à dénominateurs différents, illustrées en parts de
/// cercle, converties au même dénominateur (flèche + facteur animés) puis
/// additionnées.
class FractionPoseeDemo extends StatefulWidget {
  final int numA;
  final int denomA;
  final int numB;
  final int denomB;
  const FractionPoseeDemo({
    super.key,
    required this.numA,
    required this.denomA,
    required this.numB,
    required this.denomB,
  });

  @override
  State<FractionPoseeDemo> createState() => _FractionPoseeDemoState();
}

class _FractionPoseeDemoState extends State<FractionPoseeDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  int get _commonDenom => widget.denomA * widget.denomB;
  int get _convNumA => widget.numA * widget.denomB;
  int get _convNumB => widget.numB * widget.denomA;
  int get _resultNum => _convNumA + _convNumB;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    _play();
  }

  void _play() {
    _controller.reset();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(covariant FractionPoseeDemo old) {
    super.didUpdateWidget(old);
    if (old.numA != widget.numA ||
        old.denomA != widget.denomA ||
        old.numB != widget.numB ||
        old.denomB != widget.denomB) {
      _play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final showConversion = t > 0.25;
        final showResult = t > 0.6;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedOpacity(
              opacity: showConversion ? 1 : 0,
              duration: const Duration(milliseconds: 400),
              child: AnimatedSlide(
                offset: showConversion ? Offset.zero : const Offset(0, 0.3),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _FractionCard(
                          numerator: widget.numA,
                          denominator: widget.denomA,
                          color: _fractionAColor,
                        ),
                        _ConversionArrow(
                          factor: widget.denomB,
                          color: _fractionAColor,
                        ),
                        _FractionCard(
                          numerator: _convNumA,
                          denominator: _commonDenom,
                          color: _fractionAColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _FractionCard(
                          numerator: widget.numB,
                          denominator: widget.denomB,
                          color: _fractionBColor,
                        ),
                        _ConversionArrow(
                          factor: widget.denomA,
                          color: _fractionBColor,
                        ),
                        _FractionCard(
                          numerator: _convNumB,
                          denominator: _commonDenom,
                          color: _fractionBColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: showResult ? 1 : 0,
              duration: const Duration(milliseconds: 400),
              child: AnimatedScale(
                scale: showResult ? 1 : 0.6,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _FractionText(
                      numerator: _convNumA,
                      denominator: _commonDenom,
                      color: _fractionAColor,
                    ),
                    Text(
                      ' + ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AmaniColors.textSecondary,
                      ),
                    ),
                    _FractionText(
                      numerator: _convNumB,
                      denominator: _commonDenom,
                      color: _fractionBColor,
                    ),
                    Text(
                      ' = ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AmaniColors.textSecondary,
                      ),
                    ),
                    _FractionCard(
                      numerator: _resultNum,
                      denominator: _commonDenom,
                      color: _fractionResultColor,
                      pieSize: 64,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            const _ColorLegend(
              items: [
                (_fractionAColor, 'Première fraction'),
                (_fractionBColor, 'Deuxième fraction'),
                (_fractionResultColor, 'Résultat'),
              ],
            ),
          ],
        );
      },
    );
  }
}
