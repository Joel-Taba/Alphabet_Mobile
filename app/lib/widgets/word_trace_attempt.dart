import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:provider/provider.dart';
import '../hooks/use_accessibility_settings.dart';
import 'letter_trace_cell.dart';

/// Boîte englobante (dans l'espace virtuel 0-200 du catalogue) de l'encre
/// réellement tracée par une lettre, tous signes confondus — sert à calculer
/// un espacement resserré et réaliste une fois le mot/la syllabe terminé(e),
/// par opposition à la case carrée fixe (avec ses marges internes) utilisée
/// pendant le tracé.
Rect _letterInkBounds(dynamic letter) {
  final steps = letter['steps'] as List;
  Rect? bounds;
  for (final step in steps) {
    final path = parseSvgPathData(step['pathD'] as String);
    final b = path.getBounds();
    bounds = bounds == null ? b : bounds.expandToInclude(b);
  }
  return bounds ?? const Rect.fromLTWH(70, 0, 60, 200);
}

/// Une tentative d'écriture complète d'un mot ou d'une syllabe (toutes ses
/// lettres, dans l'ordre), réutilisée par le Palier "Les Mots" et le Palier
/// "Les Syllabes" : les lettres démarrent espacées façon cahier d'exercice,
/// puis — une fois TOUTES tracées avec succès — se resserrent avec une
/// petite animation pour former un mot bien compact. L'espacement final est
/// calculé à partir de l'encre réellement tracée par chaque lettre (voir
/// `_letterInkBounds`), pas de la case carrée fixe, pour un rendu proche
/// d'un vrai mot plutôt qu'une simple réduction uniforme de l'espacement.
class WordTraceAttempt extends StatefulWidget {
  final List<dynamic> letters;
  final Set<int> solved;
  final bool isActive;
  final bool isFuture;
  final ValueChanged<int> onLetterSolved;
  final double cellSize;

  const WordTraceAttempt({
    super.key,
    required this.letters,
    required this.solved,
    required this.isActive,
    required this.isFuture,
    required this.onLetterSolved,
    this.cellSize = 64,
  });

  @override
  State<WordTraceAttempt> createState() => _WordTraceAttemptState();
}

class _WordTraceAttemptState extends State<WordTraceAttempt>
    with SingleTickerProviderStateMixin {
  // Espacement pendant le tracé (cases encore bien séparées, pour rester
  // lisible pendant l'exercice) — resserré par rapport à l'ancien espacement
  // fixe de 8px.
  static const double _spacingApart = 5;

  // Écart visé entre l'encre de deux lettres consécutives une fois le mot
  // complet, façon interlettrage réel plutôt que des cases collées.
  static const double _desiredInkGap = 3;

  late final AnimationController _closeCtrl;
  late final Animation<double> _closeAnim;

  bool _isComplete(WordTraceAttempt w) =>
      w.letters.isNotEmpty && w.solved.length == w.letters.length;

  @override
  void initState() {
    super.initState();
    _closeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _closeAnim = CurvedAnimation(parent: _closeCtrl, curve: Curves.easeOut);
    if (_isComplete(widget)) _closeCtrl.value = 1;
  }

  @override
  void didUpdateWidget(covariant WordTraceAttempt oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isComplete(oldWidget) && _isComplete(widget)) {
      _closeCtrl.forward();
    } else if (!_isComplete(widget)) {
      _closeCtrl.value = 0;
    }
  }

  @override
  void dispose() {
    _closeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var activeIdx = -1;
    if (widget.isActive) {
      for (var i = 0; i < widget.letters.length; i++) {
        if (!widget.solved.contains(i)) {
          activeIdx = i;
          break;
        }
      }
    }

    // Case de tracé agrandie selon le réglage "Taille de l'interface"
    // (Profil > Réglages) : composant ciblé, le `LayoutBuilder` ci-dessous
    // recalcule `perRow` à partir de cette taille, donc la ligne reflue
    // normalement (moins de lettres par ligne) sans jamais déborder.
    final cellSize =
        widget.cellSize * context.read<AccessibilitySettings>().uiScale;
    final scale = cellSize / 200;
    final n = widget.letters.length;

    return Opacity(
      opacity: widget.isFuture ? 0.4 : 1,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final perRow = n == 0
                ? 1
                : ((constraints.maxWidth + _spacingApart) /
                          (cellSize + _spacingApart))
                      .floor()
                      .clamp(1, n);
            final rows = n == 0 ? 1 : (n / perRow).ceil();

            // Positions "espacées" (pendant le tracé) et "resserrées" (mot
            // complet) de chaque lettre — calculées une fois par build,
            // l'attribution des lettres aux lignes restant identique dans
            // les deux cas pour que l'animation ne fasse que rapprocher les
            // lettres horizontalement, sans jamais les faire changer de
            // ligne.
            final spacedX = List<double>.filled(n, 0);
            final tightX = List<double>.filled(n, 0);
            final rowOf = List<int>.filled(n, 0);
            for (var r = 0; r < rows; r++) {
              final start = r * perRow;
              final end = (start + perRow).clamp(0, n);
              double sx = 0;
              double tx = 0;
              for (var i = start; i < end; i++) {
                rowOf[i] = r;
                spacedX[i] = sx;
                tightX[i] = tx;
                sx += cellSize + _spacingApart;
                if (i + 1 < end) {
                  final rightMargin =
                      200 - _letterInkBounds(widget.letters[i]).right;
                  final leftMarginNext = _letterInkBounds(
                    widget.letters[i + 1],
                  ).left;
                  final overlap =
                      ((rightMargin + leftMarginNext) * scale - _desiredInkGap)
                          .clamp(0.0, cellSize * 0.65);
                  tx += cellSize - overlap;
                }
              }
            }

            final rowHeight = cellSize;
            const rowSpacing = _spacingApart;
            final totalHeight = rows * rowHeight + (rows - 1) * rowSpacing;

            return AnimatedBuilder(
              animation: _closeAnim,
              builder: (context, _) {
                final t = _closeAnim.value;
                return SizedBox(
                  width: constraints.maxWidth,
                  height: totalHeight < cellSize ? cellSize : totalHeight,
                  child: CustomPaint(
                    painter: _WordSeyesLinesPainter(
                      rows: rows,
                      rowHeight: rowHeight,
                      rowSpacing: rowSpacing,
                    ),
                    child: Stack(
                      children: [
                        for (var i = 0; i < n; i++)
                          Positioned(
                            left: spacedX[i] + (tightX[i] - spacedX[i]) * t,
                            top: rowOf[i] * (rowHeight + rowSpacing),
                            child: LetterTraceCell(
                              letter: widget.letters[i],
                              size: cellSize,
                              isActive: i == activeIdx,
                              transparent: true,
                              onSolved: () => widget.onLetterSolved(i),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Lignes Seyès de référence — mêmes 4 lignes équidistantes (intervalle 60
/// dans l'espace lettre 0-200) que CahierFrame.dart, répétées une fois par
/// ligne de lettres et couvrant toute la largeur disponible.
class _WordSeyesLinesPainter extends CustomPainter {
  static const List<double> _positions = [10, 70, 130, 190];

  final int rows;
  final double rowHeight;
  final double rowSpacing;

  const _WordSeyesLinesPainter({
    required this.rows,
    required this.rowHeight,
    required this.rowSpacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = rowHeight / 200;
    for (var r = 0; r < rows; r++) {
      final rowTop = r * (rowHeight + rowSpacing);
      for (int i = 0; i < _positions.length; i++) {
        final y = rowTop + _positions[i] * scale;
        final isBaseline = i == 2;
        final paint = Paint()
          ..color =
              (isBaseline ? const Color(0xFFE05252) : const Color(0xFF4A90E2))
                  .withValues(alpha: 0.5)
          ..strokeWidth = isBaseline ? 1.5 : 1;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WordSeyesLinesPainter oldDelegate) =>
      rows != oldDelegate.rows ||
      rowHeight != oldDelegate.rowHeight ||
      rowSpacing != oldDelegate.rowSpacing;
}
