/// Génération de grilles de mots mêlés : place jusqu'à `targetCount` mots en
/// ligne droite (horizontale, verticale ou diagonale descendante — jamais à
/// l'envers, pour rester lisible par de jeunes lecteurs), puis remplit les
/// cases restantes avec des lettres aléatoires. Port fidèle de
/// `src/lib/wordSearchGenerator.ts`.
library;

import '../data/word_catalog.dart';

enum SearchDirection { across, down, diagDownRight, diagDownLeft }

const Map<SearchDirection, (int, int)> _directionVectors = {
  SearchDirection.across: (0, 1),
  SearchDirection.down: (1, 0),
  SearchDirection.diagDownRight: (1, 1),
  SearchDirection.diagDownLeft: (1, -1),
};
const _directions = SearchDirection.values;

const _fillerLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

class GridPos {
  final int row;
  final int col;
  const GridPos(this.row, this.col);
}

class PlacedSearchWord {
  final WordEntry word;
  final int row;
  final int col;
  final SearchDirection direction;
  const PlacedSearchWord(this.word, this.row, this.col, this.direction);
}

class GeneratedWordSearch {
  /// Grille carrée size×size.
  final int size;

  /// Lettres résolues (mots placés + remplissage aléatoire), en MAJUSCULES.
  final List<List<String>> cells;
  final List<PlacedSearchWord> placed;
  const GeneratedWordSearch(this.size, this.cells, this.placed);
}

/// Liste ordonnée des cases occupées par un mot placé (sens de lecture normal).
List<GridPos> placedWordCells(PlacedSearchWord p) {
  final (dRow, dCol) = _directionVectors[p.direction]!;
  return List.generate(
    p.word.fr.length,
    (i) => GridPos(p.row + dRow * i, p.col + dCol * i),
  );
}

double Function() _seededRandom(int seed) {
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
  final SearchDirection direction;
  final List<String> chars;
  const _WorkingPlacement(
    this.word,
    this.row,
    this.col,
    this.direction,
    this.chars,
  );
}

bool _canPlace(
  Map<String, String> grid,
  List<String> chars,
  int row,
  int col,
  SearchDirection dir,
  int size,
) {
  final (dRow, dCol) = _directionVectors[dir]!;
  for (var i = 0; i < chars.length; i++) {
    final r = row + dRow * i;
    final c = col + dCol * i;
    if (r < 0 || r >= size || c < 0 || c >= size) return false;
    final existing = grid['$r,$c'];
    if (existing != null && existing != chars[i]) return false;
  }
  return true;
}

void _place(
  Map<String, String> grid,
  List<String> chars,
  int row,
  int col,
  SearchDirection dir,
) {
  final (dRow, dCol) = _directionVectors[dir]!;
  for (var i = 0; i < chars.length; i++) {
    grid['${row + dRow * i},${col + dCol * i}'] = chars[i];
  }
}

List<_WorkingPlacement> _attemptPlacement(
  List<WordEntry> candidates,
  int targetCount,
  int size,
  double Function() rand, {
  int attemptsPerWord = 250,
}) {
  final grid = <String, String>{};
  final placements = <_WorkingPlacement>[];

  for (final word in candidates) {
    if (placements.length >= targetCount) break;
    final chars = word.fr.toUpperCase().split('');
    for (var attempt = 0; attempt < attemptsPerWord; attempt++) {
      final dir = _directions[(rand() * _directions.length).floor()];
      final row = (rand() * size).floor();
      final col = (rand() * size).floor();
      if (!_canPlace(grid, chars, row, col, dir, size)) continue;
      _place(grid, chars, row, col, dir);
      placements.add(_WorkingPlacement(word, row, col, dir, chars));
      break;
    }
  }

  return placements;
}

GeneratedWordSearch? generateWordSearch(
  List<WordEntry> pool,
  int targetCount,
  int seed, [
  int attempts = 40,
]) {
  final rand = _seededRandom(seed);
  final usable = pool
      .where((w) => w.fr.length >= 3 && w.fr.length <= 9)
      .toList();
  if (usable.length < 2) return null;

  final longest = usable
      .map((w) => w.fr.length)
      .reduce((a, b) => a > b ? a : b);
  final size = (longest + 2).clamp(8, 12);

  var best = <_WorkingPlacement>[];
  for (var attempt = 0; attempt < attempts; attempt++) {
    var shuffled = _shuffle(usable, rand);
    shuffled.sort((a, b) => b.fr.length.compareTo(a.fr.length));
    final seeded = attempt % 3 == 0 ? shuffled : _shuffle(shuffled, rand);
    final result = _attemptPlacement(seeded, targetCount, size, rand);
    if (result.length > best.length) best = result;
    if (best.length >= targetCount) break;
  }

  if (best.length < 2) return null;

  final grid = <String, String>{};
  for (final p in best) {
    _place(grid, p.chars, p.row, p.col, p.direction);
  }

  final cells = List.generate(
    size,
    (r) => List.generate(size, (c) {
      final existing = grid['$r,$c'];
      if (existing != null) return existing;
      return _fillerLetters[(rand() * _fillerLetters.length).floor()];
    }),
  );

  return GeneratedWordSearch(
    size,
    cells,
    best
        .map((p) => PlacedSearchWord(p.word, p.row, p.col, p.direction))
        .toList(),
  );
}
