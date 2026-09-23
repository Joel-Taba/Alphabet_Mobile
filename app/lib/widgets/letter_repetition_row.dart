import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../hooks/use_accessibility_settings.dart';
import '../hooks/use_tracing_scroll_lock.dart';
import '../theme/amani_theme.dart';
import 'letter_trace_cell.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Répète le tracé d'une lettre/chiffre entière (tous ses signes, un geste
/// après l'autre, comme [LetterTraceCell]) autant de fois que le nombre de
/// répétitions réglé — pendant de [RepetitionRow] (`repetition_row.dart`)
/// pour un tracé composite plutôt qu'un unique `pathD`.
class LetterRepetitionRow extends StatefulWidget {
  final dynamic letter;
  final String label;
  final VoidCallback onSpeak;
  final Widget? badge;
  final int repetitions;
  final String doneLabel;
  final VoidCallback? onAllDone;

  /// Étape verrouillée tant que la précédente n'est pas réussie (voir
  /// [RepetitionRow.locked]).
  final bool locked;

  /// `false` pour s'intégrer sans bordure/ombre/fond propres dans une
  /// feuille de cahier partagée (voir [RepetitionRow.showCard]).
  final bool showCard;

  /// `true` si cette rangée a déjà été marquée terminée lors d'une session
  /// précédente (voir [RepetitionRow.initiallyDone]).
  final bool initiallyDone;

  const LetterRepetitionRow({
    super.key,
    required this.letter,
    required this.label,
    required this.onSpeak,
    this.badge,
    required this.repetitions,
    required this.doneLabel,
    this.onAllDone,
    this.locked = false,
    this.showCard = true,
    this.initiallyDone = false,
  });

  @override
  State<LetterRepetitionRow> createState() => _LetterRepetitionRowState();
}

class _LetterRepetitionRowState extends State<LetterRepetitionRow> {
  int _activeIndex = 0;
  bool _allDone = false;

  static const double _occSize = 110;

  /// Cases agrandies selon le réglage "Taille de l'interface" (Profil >
  /// Réglages), comme [RepetitionRow._effOccW]/[RepetitionRow._effOccH].
  double get _effOccSize =>
      _occSize * context.read<AccessibilitySettings>().uiScale;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  @override
  void didUpdateWidget(LetterRepetitionRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.repetitions != widget.repetitions ||
        oldWidget.letter['char'] != widget.letter['char']) {
      setState(_reset);
    }
  }

  void _reset() {
    if (widget.initiallyDone) {
      _activeIndex = widget.repetitions;
      _allDone = true;
      return;
    }
    _activeIndex = 0;
    _allDone = false;
  }

  void _handleSolved(int idx) {
    if (idx != _activeIndex || _allDone) return;
    setState(() {
      if (idx + 1 < widget.repetitions) {
        _activeIndex = idx + 1;
      } else {
        _allDone = true;
        widget.onAllDone?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.locked ? 0.5 : 1,
      child: Container(
        clipBehavior: widget.showCard ? Clip.antiAlias : Clip.none,
        decoration: widget.showCard
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _allDone
                      ? AmaniColors.secondary.withValues(alpha: 0.6)
                      : AmaniColors.textPrimary.withValues(alpha: 0.1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: _allDone
                        ? const Color(0x2E8FBF6F)
                        : const Color(0x144A3B2A),
                    blurRadius: _allDone ? 16 : 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              )
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: widget.showCard ? AmaniColors.surface : null,
                border: Border(
                  bottom: BorderSide(
                    color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (widget.badge != null) ...[
                    widget.badge!,
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AmaniColors.textPrimary,
                      ),
                    ),
                  ),
                  if (_allDone)
                    Text(
                      '✓ ${widget.doneLabel}',
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AmaniColors.secondary,
                      ),
                    ),
                  const SizedBox(width: 8),
                  if (widget.locked)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.lock,
                        size: 15,
                        color: AmaniColors.textSecondary,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: widget.onSpeak,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AmaniColors.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.volume2,
                          size: 16,
                          color: AmaniColors.textPrimary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              constraints: widget.showCard
                  ? const BoxConstraints(maxHeight: 330)
                  : null,
              child: SingleChildScrollView(
                physics: tracingAwareScrollPhysics(context),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const spacing = 10.0;
                    final occSize = _effOccSize;
                    final perRow =
                        ((constraints.maxWidth + spacing) / (occSize + spacing))
                            .floor()
                            .clamp(1, widget.repetitions == 0 ? 1 : widget.repetitions);
                    final rows = (widget.repetitions / perRow).ceil();

                    return SizedBox(
                      width: constraints.maxWidth,
                      child: CustomPaint(
                        painter: _LetterCahierLinesPainter(
                          rows: rows,
                          rowHeight: occSize,
                          rowSpacing: spacing,
                          lineScale: occSize / 200,
                        ),
                        child: Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: [
                            for (int i = 0; i < widget.repetitions; i++)
                              LetterTraceCell(
                                key: ValueKey('letter-rep-$i'),
                                letter: widget.letter,
                                size: occSize,
                                isActive:
                                    i == _activeIndex &&
                                    !_allDone &&
                                    !widget.locked,
                                // Fond transparent, comme les cases de
                                // signe (`_OccurrenceCanvas`, sans couleur
                                // de fond propre) : sans ça, le blanc opaque
                                // de `LetterTraceCell` masquerait le
                                // quadrillage Seyès peint juste en dessous
                                // (`_LetterCahierLinesPainter`).
                                transparent: true,
                                onSolved: () => _handleSolved(i),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quadrillage Seyès décoratif derrière les cases — copie de
/// `_SeyesLinesPainter` (`repetition_row.dart`) adaptée à des cases carrées
/// (voir `_WordSeyesLinesPainter` dans `word_trace_attempt.dart` pour le
/// même choix de duplication plutôt que de partager un widget privé entre
/// fichiers).
class _LetterCahierLinesPainter extends CustomPainter {
  static const List<double> _positions = [10, 70, 130, 190];

  final int rows;
  final double rowHeight;
  final double rowSpacing;
  final double lineScale;

  _LetterCahierLinesPainter({
    required this.rows,
    required this.rowHeight,
    required this.rowSpacing,
    required this.lineScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final originDy = (rowHeight - 200 * lineScale) / 2;
    for (int r = 0; r < rows; r++) {
      final rowTop = r * (rowHeight + rowSpacing);
      for (int i = 0; i < _positions.length; i++) {
        final y = rowTop + originDy + _positions[i] * lineScale;
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
  bool shouldRepaint(covariant _LetterCahierLinesPainter oldDelegate) =>
      oldDelegate.rows != rows ||
      oldDelegate.rowHeight != rowHeight ||
      oldDelegate.rowSpacing != rowSpacing ||
      oldDelegate.lineScale != lineScale;
}
