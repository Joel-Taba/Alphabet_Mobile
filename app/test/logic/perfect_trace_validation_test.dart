import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/data/cursive_formation_catalog.dart';
import 'package:gentle_paths_academy/data/letter_formation_catalog.dart';
import 'package:gentle_paths_academy/data/sign_exercise_catalog.dart';
import 'package:gentle_paths_academy/utils/trace_validation.dart';

/// Un enfant qui suit PARFAITEMENT le modèle doit toujours être validé,
/// quelle que soit la lettre, le style d'écriture ou la vitesse du doigt
/// (nombre de points captés). Sinon la lettre est impossible à réussir.
List<String> _rejected(String label, String pathD, double tolerance) {
  final ref = sampleSvgPath(pathD, 40);
  final out = <String>[];
  for (final n in [15, 30, 60, 120]) {
    final user = sampleSvgPath(pathD, n);
    final r = validateTrace(user, ref, tolerance);
    if (!r.valid) {
      out.add('$label (${user.length} pts) → ${r.failReason} '
          '(couverture ${(r.coverage * 100).round()} %)');
    }
  }
  return out;
}

void main() {
  // Tolérance la plus stricte d'une case de lettre (grande case).
  const letterTolerance = 27.0;

  test('tracé parfait validé : toutes les lettres script', () {
    final bad = [
      for (final l in LETTER_CATALOG)
        for (var i = 0; i < (l['steps'] as List).length; i++)
          ..._rejected(
            'script "${l['char']}" signe ${i + 1}',
            l['steps'][i]['pathD'] as String,
            letterTolerance,
          ),
    ];
    expect(bad, isEmpty, reason: bad.join('\n'));
  });

  test('tracé parfait validé : toutes les lettres cursives', () {
    final bad = [
      for (final l in CURSIVE_LETTERS)
        for (var i = 0; i < (l['steps'] as List).length; i++)
          ..._rejected(
            'cursive "${l['char']}" signe ${i + 1}',
            l['steps'][i]['pathD'] as String,
            letterTolerance,
          ),
    ];
    expect(bad, isEmpty, reason: bad.join('\n'));
  });

  test('tracé parfait validé : tous les signes du Palier 1 (tolérance min)',
      () {
    // Réglage "Tolérance" minimal (1 %) : 2 unités du repère 200×200.
    final bad = [
      for (final e in EXERCISE_CATALOG)
        ..._rejected('signe ${e['id']}', e['pathD'] as String, 2),
    ];
    expect(bad, isEmpty, reason: bad.join('\n'));
  });

  test('les mauvais tracés restent refusés (décalé, à l\'envers, à moitié, '
      'gribouillage)', () {
    final accepted = <String>[];
    final rnd = math.Random(7);
    void check(String label, List<Offset> user, List<Offset> ref, double tol) {
      if (validateTrace(user, ref, tol).valid) accepted.add(label);
    }

    final all = <(String, String, double)>[
      for (final e in EXERCISE_CATALOG) ('signe ${e['id']}', e['pathD'], 20),
      for (final l in [...LETTER_CATALOG, ...CURSIVE_LETTERS])
        for (final st in l['steps'] as List)
          ('lettre "${l['char']}"', st['pathD'] as String, 27),
    ];
    for (final (label, pathD, tol) in all) {
      final ref = sampleSvgPath(pathD, 40);
      final user = sampleSvgPath(pathD, 60);
      // Trop court pour un vrai geste : déjà refusé, rien à vérifier.
      final length = [
        for (var i = 1; i < ref.length; i++) (ref[i] - ref[i - 1]).distance,
      ].fold<double>(0, (a, b) => a + b);
      if (length < tol * 3) continue;
      check('$label décalé', [for (final p in user) p + Offset(tol * 3, 0)],
          ref, tol);
      // Sens indiscernable : un point n'a pas de sens, et les boucles très
      // étroites du "0"/"8" ont leurs deux côtés à moins d'une tolérance
      // l'un de l'autre.
      final ambiguous = label.contains('point-') ||
          label == 'lettre "0"' ||
          label == 'lettre "8"';
      if (!ambiguous) {
        check('$label à l\'envers', user.reversed.toList(), ref, tol);
      }
      check('$label à moitié', user.sublist(0, user.length ~/ 2), ref, tol);
      check(
        '$label gribouillage',
        [
          for (var i = 0; i < 60; i++)
            Offset(rnd.nextDouble() * 200, rnd.nextDouble() * 200),
        ],
        ref,
        tol,
      );
    }
    expect(accepted, isEmpty, reason: accepted.join('\n'));
  });

  test('un tracé tremblé mais dans la tolérance reste validé', () {
    final rejected = <String>[];
    final rnd = math.Random(42);
    final all = <(String, String, double)>[
      for (final e in EXERCISE_CATALOG) ('signe ${e['id']}', e['pathD'], 20),
      for (final l in [...LETTER_CATALOG, ...CURSIVE_LETTERS])
        for (final st in l['steps'] as List)
          ('lettre "${l['char']}"', st['pathD'] as String, 27),
    ];
    for (final (label, pathD, tol) in all) {
      final ref = sampleSvgPath(pathD, 40);
      for (final n in [20, 45, 90]) {
        for (var trial = 0; trial < 5; trial++) {
          // Tremblement jusqu'à la moitié de la tolérance, à chaque point.
          final user = [
            for (final p in sampleSvgPath(pathD, n))
              p +
                  Offset.fromDirection(
                    rnd.nextDouble() * 2 * math.pi,
                    rnd.nextDouble() * tol * 0.5,
                  ),
          ];
          final r = validateTrace(user, ref, tol);
          if (!r.valid) rejected.add('$label ($n pts) → ${r.failReason}');
        }
      }
    }
    expect(rejected, isEmpty, reason: rejected.toSet().join('\n'));
  });
}
