/// Génération de grilles de mots croisés : place autant de mots que possible
/// (jusqu'à `targetCount`) en les faisant s'entrecroiser sur des lettres
/// communes, désigne un mot mystère (mis en avant à la fin), et numérote
/// chaque case de départ comme dans une vraie grille. Port fidèle de
/// `src/lib/crosswordGenerator.ts`.
library;

import '../data/word_catalog.dart';

enum CrosswordDirection { across, down }

class PlacedWord {
  final WordEntry word;
  final int row;
  final int col;
  final CrosswordDirection direction;
  final int number;
  final bool mystery;

  const PlacedWord(
    this.word,
    this.row,
    this.col,
    this.direction,
    this.number,
    this.mystery,
  );

  PlacedWord copyWith({int? row, int? col, int? number, bool? mystery}) =>
      PlacedWord(
        word,
        row ?? this.row,
        col ?? this.col,
        direction,
        number ?? this.number,
        mystery ?? this.mystery,
      );
}

class GeneratedCrossword {
  final int rows;
  final int cols;
  final List<PlacedWord> placed;
  const GeneratedCrossword(this.rows, this.cols, this.placed);
}

double Function() seededRandom(int seed) {
  var s = seed % 2147483647;
  if (s <= 0) s += 2147483646;
  return () {
    s = (s * 16807) % 2147483647;
    return s / 2147483647;
  };
}

List<T> _shuffle<T>(List<T> arr, double Function() rand) {
  final a = List<T>.from(arr);
  for (var i = a.length - 1; i > 0; i--) {
    final j = (rand() * (i + 1)).floor();
    final tmp = a[i];
    a[i] = a[j];
    a[j] = tmp;
  }
  return a;
}

class _WorkingPlacement {
  final WordEntry word;
  final int row;
  final int col;
  final CrosswordDirection direction;
  const _WorkingPlacement(this.word, this.row, this.col, this.direction);
}

class _AttemptResult {
  final List<_WorkingPlacement> placements;
  final int minRow, maxRow, minCol, maxCol;
  const _AttemptResult(
    this.placements,
    this.minRow,
    this.maxRow,
    this.minCol,
    this.maxCol,
  );
}

_AttemptResult? _attemptPlacement(
  List<WordEntry> candidates,
  int targetCount,
  double Function() rand,
) {
  final grid = <String, String>{};
  final placements = <_WorkingPlacement>[];
  var minRow = 0, maxRow = 0, minCol = 0, maxCol = 0;

  bool canPlace(List<String> chars, int row, int col, CrosswordDirection dir) {
    for (var i = 0; i < chars.length; i++) {
      final r = dir == CrosswordDirection.down ? row + i : row;
      final c = dir == CrosswordDirection.across ? col + i : col;
      final key = '$r,$c';
      final existing = grid[key];
      if (existing != null) {
        if (existing != chars[i]) return false;
      } else {
        final n1 = dir == CrosswordDirection.across
            ? '${r - 1},$c'
            : '$r,${c - 1}';
        final n2 = dir == CrosswordDirection.across
            ? '${r + 1},$c'
            : '$r,${c + 1}';
        if (grid.containsKey(n1) || grid.containsKey(n2)) return false;
      }
    }
    final beforeKey = dir == CrosswordDirection.across
        ? '$row,${col - 1}'
        : '${row - 1},$col';
    final afterKey = dir == CrosswordDirection.across
        ? '$row,${col + chars.length}'
        : '${row + chars.length},$col';
    if (grid.containsKey(beforeKey) || grid.containsKey(afterKey)) return false;
    return true;
  }

  void place(WordEntry word, int row, int col, CrosswordDirection dir) {
    final chars = word.fr.split('');
    for (var i = 0; i < chars.length; i++) {
      final r = dir == CrosswordDirection.down ? row + i : row;
      final c = dir == CrosswordDirection.across ? col + i : col;
      grid['$r,$c'] = chars[i];
      if (r < minRow) minRow = r;
      if (r > maxRow) maxRow = r;
      if (c < minCol) minCol = c;
      if (c > maxCol) maxCol = c;
    }
    placements.add(_WorkingPlacement(word, row, col, dir));
  }

  if (candidates.isEmpty) return null;
  final first = candidates.first;
  place(first, 0, 0, CrosswordDirection.across);
  final used = <String>{first.id};

  for (final word in candidates.skip(1)) {
    if (placements.length >= targetCount) break;
    if (used.contains(word.id)) continue;
    final chars = word.fr.split('');
    final options = <(int, int, CrosswordDirection)>[];

    for (final entry in grid.entries) {
      final parts = entry.key.split(',');
      final gr = int.parse(parts[0]);
      final gc = int.parse(parts[1]);
      final letter = entry.value;
      for (var i = 0; i < chars.length; i++) {
        if (chars[i] != letter) continue;
        final acrossRow = gr, acrossCol = gc - i;
        if (canPlace(chars, acrossRow, acrossCol, CrosswordDirection.across)) {
          options.add((acrossRow, acrossCol, CrosswordDirection.across));
        }
        final downRow = gr - i, downCol = gc;
        if (canPlace(chars, downRow, downCol, CrosswordDirection.down)) {
          options.add((downRow, downCol, CrosswordDirection.down));
        }
      }
    }

    if (options.isEmpty) continue;
    final choice = options[(rand() * options.length).floor()];
    place(word, choice.$1, choice.$2, choice.$3);
    used.add(word.id);
  }

  if (placements.length < 2) return null;
  return _AttemptResult(placements, minRow, maxRow, minCol, maxCol);
}

GeneratedCrossword? generateCrossword(
  List<WordEntry> pool,
  int targetCount,
  int seed, [
  int attempts = 60,
]) {
  final rand = seededRandom(seed);
  final usable = pool
      .where((w) => w.fr.length >= 2 && w.fr.length <= 9)
      .toList();
  if (usable.length < 2) return null;

  _AttemptResult? best;

  for (var attempt = 0; attempt < attempts; attempt++) {
    var shuffled = _shuffle(usable, rand);
    shuffled.sort((a, b) => b.fr.length.compareTo(a.fr.length));
    final seeded = attempt % 3 == 0 ? shuffled : _shuffle(shuffled, rand);
    final result = _attemptPlacement(seeded, targetCount, rand);
    if (result != null &&
        result.placements.length > (best?.placements.length ?? 0)) {
      best = result;
    }
    if (best != null && best.placements.length >= targetCount) break;
  }

  if (best == null) return null;

  final offsetRow = -best.minRow;
  final offsetCol = -best.minCol;
  final normalized =
      best.placements
          .map(
            (p) => _WorkingPlacement(
              p.word,
              p.row + offsetRow,
              p.col + offsetCol,
              p.direction,
            ),
          )
          .toList()
        ..sort(
          (a, b) =>
              a.row != b.row ? a.row.compareTo(b.row) : a.col.compareTo(b.col),
        );

  final startNumbers = <String, int>{};
  var nextNumber = 1;
  final numbered = normalized.map((p) {
    final key = '${p.row},${p.col}';
    if (!startNumbers.containsKey(key)) startNumbers[key] = nextNumber++;
    return PlacedWord(
      p.word,
      p.row,
      p.col,
      p.direction,
      startNumbers[key]!,
      false,
    );
  }).toList();

  final mysteryIdx = (rand() * numbered.length).floor();
  numbered[mysteryIdx] = numbered[mysteryIdx].copyWith(mystery: true);

  return GeneratedCrossword(
    best.maxRow - best.minRow + 1,
    best.maxCol - best.minCol + 1,
    numbered,
  );
}
