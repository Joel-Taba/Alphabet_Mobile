import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../data/letter_style_resolver.dart';
import '../hooks/use_writing_style.dart';
import '../services/sign_speech.dart';
import '../utils/crossword_generator.dart';
import 'amani_mascot.dart';
import 'letter_trace_cell.dart';

class _GridCell {
  final int row;
  final int col;
  final String char;
  final int? number;
  final bool mystery;
  const _GridCell(this.row, this.col, this.char, this.number, this.mystery);
}

/// Clés de toutes les cases occupées par un mot placé.
List<String> _wordCellKeys(PlacedWord entry) {
  final chars = entry.word.fr.split('');
  return [
    for (var i = 0; i < chars.length; i++)
      '${entry.direction == CrosswordDirection.across ? entry.row : entry.row + i},'
          '${entry.direction == CrosswordDirection.across ? entry.col + i : entry.col}',
  ];
}

/// Palette cyclique pour les pastilles d'indices, façon jeu coloré.
const List<({Color bg, Color text, Color badge})> _cluePalette = [
  (bg: Color(0xFFEAF1FB), text: Color(0xFF2D6BBF), badge: Color(0xFF4A90E2)),
  (bg: Color(0xFFEFF6E9), text: Color(0xFF5E8E3E), badge: Color(0xFF8FBF6F)),
  (bg: Color(0xFFFBF1DE), text: Color(0xFF8A6800), badge: Color(0xFFD9A84A)),
];

/// Grille de mots croisés jouable : chaque mot est toujours numéroté et
/// doté d'un bouton d'écoute (aucun indice caché pendant la résolution) ; le
/// mot mystère n'est mis en avant qu'en fin de partie, à titre de
/// célébration. Port fidèle de `src/components/amani/CrosswordPlay.tsx`.
class CrosswordPlay extends StatefulWidget {
  final GeneratedCrossword crossword;
  const CrosswordPlay({super.key, required this.crossword});

  @override
  State<CrosswordPlay> createState() => _CrosswordPlayState();
}

class _CrosswordPlayState extends State<CrosswordPlay> {
  final Set<String> _solved = {};
  bool _justFinished = false;

  late Map<String, _GridCell> _cellByPos;
  late List<_GridCell> _sequence;
  late List<({int number, String wordId})> _clues;
  PlacedWord? _mysteryWord;

  @override
  void initState() {
    super.initState();
    _build();
  }

  @override
  void didUpdateWidget(CrosswordPlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.crossword != widget.crossword) {
      _solved.clear();
      _justFinished = false;
      _build();
    }
  }

  void _build() {
    final byKey = <String, _GridCell>{};
    final seq = <_GridCell>[];
    final clueList = <({int number, String wordId})>[];
    PlacedWord? mystery;

    for (final entry in widget.crossword.placed) {
      if (entry.mystery) mystery = entry;
      clueList.add((number: entry.number, wordId: entry.word.id));
      final chars = entry.word.fr.split('');
      for (var i = 0; i < chars.length; i++) {
        final row = entry.direction == CrosswordDirection.across
            ? entry.row
            : entry.row + i;
        final col = entry.direction == CrosswordDirection.across
            ? entry.col + i
            : entry.col;
        final key = '$row,$col';
        if (byKey.containsKey(key)) continue;
        final cell = _GridCell(
          row,
          col,
          chars[i],
          i == 0 ? entry.number : null,
          entry.mystery,
        );
        byKey[key] = cell;
        seq.add(cell);
      }
    }
    clueList.sort((a, b) => a.number.compareTo(b.number));

    _cellByPos = byKey;
    _sequence = seq;
    _clues = clueList;
    _mysteryWord = mystery;
  }

  void _handleCellSolved(String key) {
    setState(() {
      _solved.add(key);
      if (_solved.length == _sequence.length) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) setState(() => _justFinished = true);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final lang = context.watch<LanguageProvider>().lang;
    final speech = context.read<SignSpeechService>();
    final style = context.watch<WritingStyleProvider>().style.name;
    final mc = t['motsCroises'] as Map<String, dynamic>? ?? {};

    _GridCell? activeCell;
    for (final c in _sequence) {
      if (!_solved.contains('${c.row},${c.col}')) {
        activeCell = c;
        break;
      }
    }
    final allSolved =
        _solved.length == _sequence.length && _sequence.isNotEmpty;
    final cellSize = widget.crossword.cols >= 8
        ? 40.0
        : widget.crossword.cols >= 6
        ? 48.0
        : 60.0;

    // Progrès par MOT (pas par case) pour l'indicateur "X sur Y mots trouvés"
    // et le fond coloré qui met en valeur chaque mot complété dans la grille.
    var solvedWordsCount = 0;
    final solvedWordCellKeys = <String>{};
    for (final entry in widget.crossword.placed) {
      final keys = _wordCellKeys(entry);
      if (keys.every(_solved.contains)) {
        solvedWordsCount++;
        solvedWordCellKeys.addAll(keys);
      }
    }
    final totalWords = widget.crossword.placed.length;

    return Column(
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
                pose: allSolved ? AmaniPose.celebration : AmaniPose.curiosite,
                size: AmaniSize.small,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      allSolved
                          ? (mc['doneTitle'] ?? '')
                          : (mc['hintTitle'] ?? ''),
                      style: AmaniTheme.titleStyle.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      allSolved
                          ? (mc['doneBody'] ?? '')
                          : (mc['hintBody'] ?? ''),
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
                                  : solvedWordsCount / totalWords,
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
                          '$solvedWordsCount/$totalWords',
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

        Builder(
          builder: (context) {
            final gridWidth = widget.crossword.cols * cellSize + 16;
            final gridHeight = widget.crossword.rows * cellSize + 16;
            final viewportHeight = (MediaQuery.of(context).size.height * 0.5)
                .clamp(200.0, 520.0);

            return Container(
              width: double.infinity,
              height: gridHeight < viewportHeight ? gridHeight : viewportHeight,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AmaniColors.textPrimary.withValues(alpha: 0.08),
                ),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFBF6EC), Color(0xFFF0E4CC)],
                ),
              ),
              child: InteractiveViewer(
                constrained: false,
                boundaryMargin: const EdgeInsets.all(40),
                minScale: 0.4,
                maxScale: 2.5,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: gridWidth,
                    height: gridHeight,
                    child: Column(
                      children: [
                        for (var row = 0; row < widget.crossword.rows; row++)
                          Row(
                            children: [
                              for (
                                var col = 0;
                                col < widget.crossword.cols;
                                col++
                              )
                                _buildCell(
                                  row,
                                  col,
                                  cellSize,
                                  activeCell,
                                  solvedWordCellKeys,
                                  style,
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),

        for (var i = 0; i < _clues.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Builder(
              builder: (context) {
                final clue = _clues[i];
                final entry = widget.crossword.placed.firstWhere(
                  (p) => p.word.id == clue.wordId && p.number == clue.number,
                  orElse: () => widget.crossword.placed.first,
                );
                final isWordSolved = _wordCellKeys(
                  entry,
                ).every(_solved.contains);
                final palette = _cluePalette[i % _cluePalette.length];
                final badgeColor = isWordSolved
                    ? const Color(0xFF8FBF6F)
                    : palette.badge;
                final textColor = isWordSolved
                    ? const Color(0xFF4A7A30)
                    : palette.text;
                return GestureDetector(
                  onTap: () => speech.speak(entry.word.fr, lang),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isWordSolved
                          ? const Color(0x1F8FBF6F)
                          : palette.bg,
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
                            color: badgeColor,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: isWordSolved
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : Text(
                                  '${clue.number}',
                                  style: TextStyle(
                                    fontFamily: kBalooFontFamily,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.volume_up_rounded,
                          size: 16,
                          color: badgeColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          entry.direction == CrosswordDirection.across
                              ? (mc['across'] ?? '')
                              : (mc['down'] ?? ''),
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

        if (_justFinished && _mysteryWord != null)
          _buildCelebration(context, t, mc, lang, speech),
      ],
    );
  }

  Widget _buildCell(
    int row,
    int col,
    double cellSize,
    _GridCell? activeCell,
    Set<String> solvedWordCellKeys,
    String style,
  ) {
    final cell = _cellByPos['$row,$col'];
    if (cell == null) return SizedBox(width: cellSize, height: cellSize);
    final letter = getLetterFormation(cell.char, style);
    if (letter == null) return SizedBox(width: cellSize, height: cellSize);
    final key = '$row,$col';
    final isActive =
        activeCell != null && activeCell.row == row && activeCell.col == col;
    final isSolved = _solved.contains(key);
    final isWordFound = solvedWordCellKeys.contains(key);

    return Padding(
      padding: const EdgeInsets.all(1),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (isWordFound)
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.all(-2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color:
                      (cell.mystery
                              ? const Color(0xFFD9A84A)
                              : const Color(0xFF8FBF6F))
                          .withValues(alpha: 0.18),
                ),
              ),
            ),
          if (cell.number != null)
            Positioned(
              top: -2,
              left: -2,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Color(0x1A000000), blurRadius: 2),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '${cell.number}',
                  style: TextStyle(
                    fontFamily: kBalooFontFamily,
                    fontWeight: FontWeight.w800,
                    fontSize: 9,
                    color: const Color(0xFF4A90E2),
                  ),
                ),
              ),
            ),
          if (cell.mystery && isSolved)
            const Positioned(
              top: -6,
              right: -6,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 14,
                color: Color(0xFFD9A84A),
              ),
            ),
          LetterTraceCell(
            letter: letter,
            size: cellSize,
            isActive: isActive,
            onSolved: () => _handleCellSolved(key),
          ),
        ],
      ),
    );
  }

  Widget _buildCelebration(
    BuildContext context,
    Map<String, dynamic> t,
    Map<String, dynamic> mc,
    Lang lang,
    SignSpeechService speech,
  ) {
    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.4),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 320),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 30,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AmaniMascot(
                  pose: AmaniPose.victoirePalier,
                  size: AmaniSize.medium,
                ),
                const SizedBox(height: 12),
                Text(
                  mc['featuredTitle'] ?? '',
                  style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  mc['featuredBody'] ?? '',
                  style: AmaniTheme.bodyStyle.copyWith(
                    fontSize: 13,
                    color: AmaniColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final ch in _mysteryWord!.word.fr.split(''))
                      Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: const Color(0x26D9A84A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFD9A84A),
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          ch,
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: const Color(0xFF8A6800),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => speech.speak(_mysteryWord!.word.fr, lang),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x26D9A84A),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.volume_up_rounded,
                          size: 16,
                          color: Color(0xFF8A6800),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _mysteryWord!.word.fr,
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: const Color(0xFF8A6800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () => setState(() => _justFinished = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AmaniColors.secondary,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x338FBF6F),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        mc['continueLabel'] ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: kBalooFontFamily,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
