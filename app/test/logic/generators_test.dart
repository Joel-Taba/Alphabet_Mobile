import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/data/calcul_catalog.dart';
import 'package:gentle_paths_academy/data/mental_calc_generator.dart';
import 'package:gentle_paths_academy/data/shape_calc_problem.dart';
import 'package:gentle_paths_academy/data/shape_catalog.dart';
import 'package:gentle_paths_academy/data/solid3d_catalog.dart';
import 'package:gentle_paths_academy/data/solid_calc_problem.dart';
import 'package:gentle_paths_academy/data/word_catalog.dart';
import 'package:gentle_paths_academy/utils/word_search_generator.dart';

/// Nombre de tirages par générateur : assez pour croiser les cas rares.
const int kSeeds = 3000;
const List<String> kLangs = ['fr', 'en', 'es', 'ar'];

// ─── Petit calculateur indépendant, en fractions exactes ────────────────
class Q {
  final int n, d;
  Q(int n, int d) : n = (d < 0 ? -n : n) ~/ _g(n, d), d = d.abs() ~/ _g(n, d);
  static int _g(int a, int b) {
    a = a.abs();
    b = b.abs();
    while (b != 0) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a == 0 ? 1 : a;
  }

  Q operator +(Q o) => Q(n * o.d + o.n * d, d * o.d);
  Q operator -(Q o) => Q(n * o.d - o.n * d, d * o.d);
  Q operator *(Q o) => Q(n * o.n, d * o.d);
  Q operator /(Q o) => Q(n * o.d, d * o.n);
  @override
  bool operator ==(Object o) => o is Q && o.n == n && o.d == d;
  @override
  int get hashCode => Object.hash(n, d);
  @override
  String toString() => d == 1 ? '$n' : '$n/$d';
}

/// "12", "3,7", "3/4" → nombre exact.
Q parseNumber(String s) {
  s = s.trim();
  if (s.contains('/')) {
    final p = s.split('/');
    return Q(int.parse(p[0]), int.parse(p[1]));
  }
  if (s.contains(',')) {
    final p = s.split(',');
    final dec = p[1];
    var scale = 1;
    for (var i = 0; i < dec.length; i++) {
      scale *= 10;
    }
    return Q(int.parse(p[0]) * scale + int.parse(dec), scale);
  }
  return Q(int.parse(s), 1);
}

/// Évalue "a op b" (op parmi + - × ÷) ou "p % de n".
Q evaluate(String expr) {
  // Le calcul mental écrit le "moins" typographique (−) et parfois ×/x.
  expr = expr
      .replaceAll('−', '-')
      .replaceAll(' x ', ' × ')
      .replaceAll(' : ', ' ÷ ');
  final pct = RegExp(r'^(\d+) % de (\d+)$').firstMatch(expr.trim());
  if (pct != null) {
    return Q(int.parse(pct.group(1)!) * int.parse(pct.group(2)!), 100);
  }
  final m = RegExp(r'^(\S+) ([+\-×÷]) (\S+)$').firstMatch(expr.trim());
  if (m == null) throw FormatException('énoncé non reconnu : "$expr"');
  final a = parseNumber(m.group(1)!), b = parseNumber(m.group(3)!);
  switch (m.group(2)) {
    case '+':
      return a + b;
    case '-':
      return a - b;
    case '×':
      return a * b;
    default:
      return a / b;
  }
}

void main() {
  group('Calculs (palier 5)', () {
    for (final topic in CALCUL_TOPICS) {
      test('${topic.id} : réponses justes, traçables, sans doublon', () {
        for (var seed = 0; seed < kSeeds ~/ 10; seed++) {
          final problems = topic.generateProblems(seed, 5);
          expect(problems, isNotEmpty);
          final displays = <String>{};
          for (final p in problems) {
            final where = '${topic.id} (graine $seed) "${p.display}"';
            // Uniquement des chiffres à tracer ou à taper.
            expect(
              RegExp(r'^\d+$').hasMatch(p.answer),
              isTrue,
              reason: '$where : réponse "${p.answer}" non traçable',
            );
            if (p.answerSecondPart != null) {
              expect(
                RegExp(r'^\d+$').hasMatch(p.answerSecondPart!),
                isTrue,
                reason: '$where : 2e partie non traçable',
              );
            }
            if (p.choices != null) {
              expect(
                p.choices!.toSet().length,
                p.choices!.length,
                reason: '$where : QCM avec deux fois la même proposition',
              );
              final shown = p.answerSecondPart == null
                  ? p.answer
                  : '${p.answer}${p.secondPartSeparator}${p.answerSecondPart}';
              expect(
                p.choices,
                contains(shown),
                reason: '$where : la bonne réponse n\'est pas proposée',
              );
            }
            expect(
              displays.add(p.display),
              isTrue,
              reason: '$where : même problème posé deux fois dans la série',
            );

            // Vérification indépendante de la réponse.
            final fracQ = RegExp(
              r'^(\d+)/(\d+) \+ (\d+)/\2 = \?/\2$',
            ).firstMatch(p.display);
            if (fracQ != null) {
              final sum =
                  int.parse(fracQ.group(1)!) + int.parse(fracQ.group(3)!);
              expect(p.answer, '$sum', reason: where);
              continue;
            }
            final expected = evaluate(p.display);
            if (p.secondPartSeparator.trim() == 'R') {
              final m = RegExp(r'^(\d+) ÷ (\d+)$').firstMatch(p.display)!;
              final a = int.parse(m.group(1)!), b = int.parse(m.group(2)!);
              expect(p.answer, '${a ~/ b}', reason: where);
              expect(p.answerSecondPart, '${a % b}', reason: where);
              continue;
            }
            final given = p.answerSecondPart == null
                ? parseNumber(p.answer)
                : parseNumber(
                    '${p.answer}${p.secondPartSeparator.trim()}${p.answerSecondPart}',
                  );
            expect(
              given,
              expected,
              reason: '$where : réponse ${p.answer}${p.answerSecondPart ?? ''}',
            );
          }
        }
      });
    }
  });

  group('Vrai ou faux des calculs', () {
    for (final level in VRAI_FAUX_LEVELS) {
      test('niveau ${level.niveau} : "vrai" veut dire vraiment juste', () {
        for (var seed = 0; seed < kSeeds; seed++) {
          for (final item in level.generateItems(seed, 3)) {
            final parts = item.display.split(' = ');
            final correctParts = item.correctDisplay.split(' = ');
            expect(parts.length, 2, reason: item.display);
            expect(
              correctParts[0],
              parts[0],
              reason: 'la correction ne porte pas sur le même calcul',
            );
            final lhs = RegExp(r'^\d+/\d+ \+ \d+/\d+$').hasMatch(parts[0])
                ? (() {
                    final f = parts[0].split(' + ');
                    return parseNumber(f[0]) + parseNumber(f[1]);
                  })()
                : evaluate(parts[0]);
            expect(
              parseNumber(correctParts[1]),
              lhs,
              reason: 'correction fausse : ${item.correctDisplay}',
            );
            expect(
              parseNumber(parts[1]) == lhs,
              item.isTrue,
              reason: '"${item.display}" marqué ${item.isTrue}',
            );
          }
        }
      });
    }
  });

  group('Calcul mental (mode libre)', () {
    test('réponse juste et toujours proposée', () {
      final rand = Random(42);
      for (var i = 0; i < kSeeds; i++) {
        final p = generateMentalCalcProblem(rand);
        expect(p.choices, contains(p.answer), reason: p.display);
        expect(p.choices.toSet().length, p.choices.length, reason: p.display);
        final expr = p.display.replaceAll(RegExp(r'\s*=\s*\?\s*$'), '');
        expect(evaluate(expr), Q(p.answer, 1), reason: p.display);
      }
    });
  });

  group('Figures planes : périmètre et aire', () {
    int expectedAnswer(ShapeCalcProblem p) {
      final d = p.dimensions;
      final perimeter = p.kind == ShapeCalcKind.perimeter;
      switch (p.shapeId) {
        case 'carre':
          return perimeter ? d['side']! * 4 : d['side']! * d['side']!;
        case 'rectangle':
          return perimeter
              ? (d['length']! + d['width']!) * 2
              : d['length']! * d['width']!;
        case 'triangle':
          if (perimeter) return d['a']! + d['b']! + d['c']!;
          final twice = d['base']! * d['height']!;
          expect(
            twice.isEven,
            isTrue,
            reason:
                'aire du triangle non entière : ${d['base']} × ${d['height']} ÷ 2',
          );
          return twice ~/ 2;
        case 'cercle':
          final r = d['radius']!;
          final exact = perimeter ? 2 * kApproxPi * r : kApproxPi * r * r;
          final frac = exact - exact.floorToDouble();
          expect(
            (frac - 0.5).abs() > 1e-9,
            isTrue,
            reason: 'arrondi ambigu (,5) pour le cercle de rayon $r',
          );
          return exact.round();
        case 'parallelogramme':
          return perimeter
              ? (d['a']! + d['b']!) * 2
              : d['base']! * d['height']!;
        case 'losange':
          if (perimeter) return d['side']! * 4;
          final twice = d['bigDiagonal']! * d['smallDiagonal']!;
          expect(twice.isEven, isTrue, reason: 'aire du losange non entière');
          return twice ~/ 2;
      }
      fail('figure inconnue ${p.shapeId}');
    }

    for (final topic in SHAPE_TOPICS) {
      test('${topic.id} : réponse juste, tient au clavier, énoncé complet', () {
        for (var seed = 0; seed < kSeeds; seed++) {
          final p = generateShapeCalcProblem(topic, seed);
          expect(p.shapeId, topic.id);
          expect(p.dimensions.values.every((v) => v > 0), isTrue);
          expect(p.answer, expectedAnswer(p), reason: '${p.dimensions}');
          expect(
            p.answer,
            inInclusiveRange(1, 9999),
            reason: 'le clavier accepte 4 chiffres maximum',
          );
          if (p.shapeId == 'triangle' && p.kind == ShapeCalcKind.perimeter) {
            final a = p.dimensions['a']!,
                b = p.dimensions['b']!,
                c = p.dimensions['c']!;
            expect(
              a < b + c && b < a + c && c < a + b,
              isTrue,
              reason: 'triangle impossible : $a, $b, $c',
            );
          }
          for (final lang in kLangs) {
            final text = shapeCalcStatement(p, lang);
            expect(text.trim(), isNotEmpty, reason: '${topic.id} $lang');
            expect(
              text.contains('{'),
              isFalse,
              reason: 'mesure non remplacée ($lang) : $text',
            );
          }
        }
      });
    }
  });

  group('Solides 3D : volume', () {
    int expectedTimes300(SolidCalcProblem p) {
      final d = p.dimensions;
      switch (p.shapeId) {
        case 'cube':
          return 300 * d['side']! * d['side']! * d['side']!;
        case 'pave':
          return 300 * d['length']! * d['width']! * d['height']!;
        case 'pyramide':
          return 100 * d['side']! * d['side']! * d['height']!;
        case 'prisme':
          return 150 * d['base']! * d['height']! * d['length']!;
        case 'cylindre':
          return 3 * 314 * d['radius']! * d['radius']! * d['height']!;
        case 'cone':
          return 314 * d['radius']! * d['radius']! * d['height']!;
        case 'sphere':
          return 4 * 314 * d['radius']! * d['radius']! * d['radius']!;
      }
      fail('solide inconnu ${p.shapeId}');
    }

    for (final topic in SOLID3D_TOPICS) {
      test('${topic.id} : volume juste, jamais d\'arrondi ambigu', () {
        for (var seed = 0; seed < kSeeds; seed++) {
          final p = generateSolidCalcProblem(topic, seed);
          expect(p.shapeId, topic.id, reason: 'générateur par défaut utilisé');
          final x = expectedTimes300(p);
          if (!p.isApproximate) {
            expect(
              x % 300,
              0,
              reason: 'volume exact non entier ${p.dimensions}',
            );
          } else {
            expect(
              x % 300 == 150,
              isFalse,
              reason: 'arrondi ambigu ${p.dimensions}',
            );
          }
          expect(p.answer, (x + 150) ~/ 300, reason: '${p.dimensions}');
          expect(p.answer, inInclusiveRange(1, 9999));
          for (final lang in kLangs) {
            final text = solidCalcStatement(p, lang);
            expect(text.trim(), isNotEmpty, reason: '${topic.id} $lang');
            expect(text.contains('{'), isFalse, reason: text);
          }
        }
      });
    }
  });

  group('Mots mêlés', () {
    test('chaque mot placé se lit bien dans la grille', () {
      for (final count in [2, 4, 6, 8, 10]) {
        for (var seed = 0; seed < 150; seed++) {
          final g = generateWordSearch(WORD_CATALOG, count, seed);
          expect(g, isNotNull, reason: '$count mots, graine $seed');
          for (final placed in g!.placed) {
            final cells = placedWordCells(placed);
            final read = cells.map((c) {
              expect(c.row, inInclusiveRange(0, g.size - 1));
              expect(c.col, inInclusiveRange(0, g.size - 1));
              return g.cells[c.row][c.col];
            }).join();
            final expected = placed.word.fr
                .toUpperCase()
                .replaceAll(RegExp('[ÀÂÄ]'), 'A')
                .replaceAll(RegExp('[ÉÈÊË]'), 'E')
                .replaceAll(RegExp('[ÎÏ]'), 'I')
                .replaceAll(RegExp('[ÔÖ]'), 'O')
                .replaceAll(RegExp('[ÙÛÜ]'), 'U')
                .replaceAll('Ç', 'C');
            expect(
              read == expected || read == placed.word.fr.toUpperCase(),
              isTrue,
              reason: 'lu "$read" au lieu de "${placed.word.fr}"',
            );
          }
          final ids = g.placed.map((p) => p.word.id).toList();
          expect(ids.toSet().length, ids.length, reason: 'mot placé deux fois');
        }
      }
    });
  });
}
