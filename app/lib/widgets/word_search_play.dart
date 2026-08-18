import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../services/progress_service.dart';
import '../utils/word_search_generator.dart';
import '../data/word_catalog.dart';
import 'amani_mascot.dart';
import 'exercise_complete_popup.dart';

/// Palette cyclique — un mot trouvé = une couleur, réutilisée dans la grille
/// et la liste.
const List<Color> _wordPalette = [
  Color(0xFF4A90E2),
  Color(0xFF8FBF6F),
  Color(0xFFD9A84A),
  Color(0xFFE0715A),
  Color(0xFFB07CC6),
  Color(0xFF4BB3A5),
];

String _key(GridPos p) => '${p.row},${p.col}';

/// Cases traversées entre deux points, uniquement si l'axe est droit
/// (horizontal, vertical ou diagonal à 45°) — une sélection "en biais"
/// quelconque est ignorée (retourne null).
List<GridPos>? _straightLineBetween(GridPos start, GridPos end) {
  final dr = end.row - start.row;
  final dc = end.col - start.col;
  if (dr == 0 && dc == 0) return [start];
  final absR = dr.abs();
  final absC = dc.abs();
  if (dr != 0 && dc != 0 && absR != absC) return null;
  final steps = absR > absC ? absR : absC;
  final stepR = dr == 0 ? 0 : dr ~/ absR;
  final stepC = dc == 0 ? 0 : dc ~/ absC;
  return [
    for (var i = 0; i <= steps; i++)
      GridPos(start.row + stepR * i, start.col + stepC * i),
  ];
}

bool _sameCells(List<GridPos> a, List<GridPos> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i].row != b[i].row || a[i].col != b[i].col) return false;
  }
  return true;
}

/// Grille de mots mêlés jouable : lettres imprimées statiques (pas de
/// traçage manuscrit, à la différence des mots croisés), un mot se trouve en
/// glissant le doigt du début à la fin, dans n'importe quel sens (horizontal,
/// vertical, diagonal) et dans n'importe quel ordre (l'enfant peut partir de
/// n'importe quelle extrémité du mot repéré). Port fidèle de
/// `src/components/amani/WordSearchPlay.tsx`.
///
/// [puzzleId]/[level] ne sont fournis que par l'étape du parcours (voir
/// exercice_mots_meles_screen.dart) : c'est ce qui déclenche l'attribution de
/// points et le pop-up de fin d'exercice. Le mode libre de la bibliothèque
/// (grilles régénérées à la demande) omet ces props et ne déclenche donc ni
/// l'un ni l'autre, volontairement — même convention que `CrosswordPlay`.
class WordSearchPlay extends StatefulWidget {
  final GeneratedWordSearch wordSearch;
  final String? puzzleId;
  final int? level;
  const WordSearchPlay({
    super.key,
    required this.wordSearch,
    this.puzzleId,
    this.level,
  });

  @override
  State<WordSearchPlay> createState() => _WordSearchPlayState();
}

class _WordSearchPlayState extends State<WordSearchPlay> {
  final Set<String> _found = {};
  GridPos? _dragStart;
  GridPos? _dragCurrent;
  bool _showCompletePopup = false;
  bool _pointsAwarded = false;
  bool _awaitingRepeatCompletion = false;

  @override
  void didUpdateWidget(WordSearchPlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.wordSearch != widget.wordSearch) {
      _found.clear();
      _showCompletePopup = false;
      _pointsAwarded = false;
      _dragStart = null;
      _dragCurrent = null;
    }
  }

  GridPos? _cellFromLocal(Offset local, double cellSize) {
    final size = widget.wordSearch.size;
    final col = (local.dx / cellSize).floor();
    final row = (local.dy / cellSize).floor();
    if (row < 0 || row >= size || col < 0 || col >= size) return null;
    return GridPos(row, col);
  }

  void _finishSelection(GridPos start, GridPos end) {
    final cells = _straightLineBetween(start, end);
    if (cells == null || cells.length < 2) return;
    final speech = context.read<SignSpeechService>();
    final lang = context.read<LanguageProvider>().lang;
    for (final p in widget.wordSearch.placed) {
      if (_found.contains(p.word.id)) continue;
      final wordCells = placedWordCells(p);
      final reversed = cells.reversed.toList();
      if (_sameCells(wordCells, cells) || _sameCells(wordCells, reversed)) {
        setState(() => _found.add(p.word.id));
        speech.speak(p.word.fr, lang);
        if (_found.length == widget.wordSearch.placed.length) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (!mounted) return;
            _onFullySolved();
          });
        }
        break;
      }
    }
  }

  /// Attribue les points (une seule fois) et affiche le pop-up de fin
  /// d'exercice — seulement pour une grille du parcours ([puzzleId]/[level]
  /// fournis).
  void _onFullySolved() {
    if (!mounted) return;
    final lang = context.read<LanguageProvider>().lang;
    if (widget.puzzleId != null && !_pointsAwarded) {
      _pointsAwarded = true;
      context.read<ProgressProvider>().awardCompletion(
        typeEtape: 'MOTS_MELES',
        modalite: 'EXERCICE',
        etapeCode: widget.puzzleId!,
        palier: lang == Lang.fr ? 4 : 3,
      );
    }
    if (widget.level == null) return;
    if (_awaitingRepeatCompletion) {
      context.read<ProgressProvider>().awardRestartBonus();
      _awaitingRepeatCompletion = false;
    }
    setState(() => _showCompletePopup = true);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final lang = context.watch<LanguageProvider>().lang;
    final speech = context.read<SignSpeechService>();
    final mm = t['motsMeles'] as Map<String, dynamic>? ?? {};

    final totalWords = widget.wordSearch.placed.length;
    final allFound = _found.length == totalWords && totalWords > 0;

    final wordColor = <String, Color>{};
    for (var i = 0; i < widget.wordSearch.placed.length; i++) {
      wordColor[widget.wordSearch.placed[i].word.id] =
          _wordPalette[i % _wordPalette.length];
    }

    final foundCellColor = <String, Color>{};
    for (final p in widget.wordSearch.placed) {
      if (!_found.contains(p.word.id)) continue;
      final color = wordColor[p.word.id]!;
      for (final c in placedWordCells(p)) {
        foundCellColor[_key(c)] = color;
      }
    }

    final liveSelection = (_dragStart != null && _dragCurrent != null)
        ? _straightLineBetween(_dragStart!, _dragCurrent!)
        : null;
    final liveSelectionKeys = {
      for (final c in liveSelection ?? const <GridPos>[]) _key(c),
    };

    final cellSize = widget.wordSearch.size >= 11
        ? 28.0
        : widget.wordSearch.size >= 9
        ? 32.0
        : 38.0;
    final gridPixels = widget.wordSearch.size * cellSize;
    final nextWordGroup = widget.level != null
        ? nextWordGroupAfterCrossword(widget.level!)
        : null;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4A90E2), Color(0xFF2D6BBF)],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AmaniMascot(
                    pose: allFound
                        ? AmaniPose.celebration
                        : AmaniPose.curiosite,
                    size: AmaniSize.small,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          allFound
                              ? (mm['doneTitle'] ?? '')
                              : (mm['hintTitle'] ?? ''),
                          style: AmaniTheme.titleStyle.copyWith(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          allFound
                              ? (mm['doneBody'] ?? '')
                              : (mm['hintBody'] ?? ''),
                          style: AmaniTheme.bodyStyle.copyWith(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: LinearProgressIndicator(
                                  value: totalWords == 0
                                      ? 0
                                      : _found.length / totalWords,
                                  minHeight: 8,
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.25,
                                  ),
                                  valueColor: const AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_found.length}/$totalWords',
                              style: TextStyle(
                                fontFamily: kBalooFontFamily,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AmaniColors.textPrimary.withValues(alpha: 0.08),
                ),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFBF6EC), Color(0xFFF0E4CC)],
                ),
              ),
              alignment: Alignment.center,
              child: GestureDetector(
                onPanStart: (details) {
                  final cell = _cellFromLocal(details.localPosition, cellSize);
                  if (cell == null) return;
                  setState(() {
                    _dragStart = cell;
                    _dragCurrent = cell;
                  });
                },
                onPanUpdate: (details) {
                  if (_dragStart == null) return;
                  final cell = _cellFromLocal(details.localPosition, cellSize);
                  if (cell != null) setState(() => _dragCurrent = cell);
                },
                onPanEnd: (_) {
                  if (_dragStart != null && _dragCurrent != null) {
                    _finishSelection(_dragStart!, _dragCurrent!);
                  }
                  setState(() {
                    _dragStart = null;
                    _dragCurrent = null;
                  });
                },
                child: SizedBox(
                  width: gridPixels,
                  height: gridPixels,
                  child: Column(
                    children: [
                      for (var row = 0; row < widget.wordSearch.size; row++)
                        Row(
                          children: [
                            for (
                              var col = 0;
                              col < widget.wordSearch.size;
                              col++
                            )
                              _buildCell(
                                row,
                                col,
                                cellSize,
                                foundCellColor,
                                liveSelectionKeys,
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            for (final p in widget.wordSearch.placed)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Builder(
                  builder: (context) {
                    final isFound = _found.contains(p.word.id);
                    final color = wordColor[p.word.id]!;
                    return GestureDetector(
                      onTap: () => speech.speak(p.word.fr, lang),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isFound
                              ? color.withValues(alpha: 0.12)
                              : const Color(0xFFFBF6EC),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(color: Color(0x0D000000), blurRadius: 4),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: isFound
                                  ? const Icon(
                                      Icons.check_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.volume_up_rounded,
                              size: 16,
                              color: color,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              p.word.fr.toUpperCase(),
                              style: TextStyle(
                                fontFamily: kBalooFontFamily,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: isFound
                                    ? color
                                    : const Color(0xFF4A3B2A),
                                decoration: isFound
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
        if (_showCompletePopup)
          ExerciseCompletePopup(
            onBackHome: () => context.go('/accueil'),
            onNext: nextWordGroup != null
                ? () => context.go('/cours/mots/${nextWordGroup.id}')
                : null,
            onRestart: () {
              setState(() {
                _found.clear();
                _showCompletePopup = false;
                _pointsAwarded = false;
                _awaitingRepeatCompletion = true;
              });
            },
          ),
      ],
    );
  }

  Widget _buildCell(
    int row,
    int col,
    double cellSize,
    Map<String, Color> foundCellColor,
    Set<String> liveSelectionKeys,
  ) {
    final key = '$row,$col';
    final letter = widget.wordSearch.cells[row][col];
    final foundColor = foundCellColor[key];
    final isLiveSelected = liveSelectionKeys.contains(key);

    return SizedBox(
      width: cellSize,
      height: cellSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (foundColor != null)
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: foundColor.withValues(alpha: 0.33),
                ),
              ),
            )
          else if (isLiveSelected)
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AmaniColors.textPrimary.withValues(alpha: 0.15),
                ),
              ),
            ),
          Text(
            letter,
            style: TextStyle(
              fontFamily: kBalooFontFamily,
              fontWeight: FontWeight.w800,
              fontSize: cellSize * 0.42,
              color: const Color(0xFF4A3B2A),
            ),
          ),
        ],
      ),
    );
  }
}
