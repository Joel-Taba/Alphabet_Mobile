import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/hooks/use_exercise_settings.dart';
import 'package:gentle_paths_academy/utils/trace_validation.dart';

/// Tracé d'enfant le long du long trait vertical, décalé de [dx] unités SVG.
List<Offset> _shifted(List<Offset> ref, double dx) => [
  for (final p in ref) p + Offset(dx, 0),
];

void main() {
  final ref = sampleSvgPath('M 100 13.5 L 100 126.5');
  double px(int level) => tolerancePctForLevel(level) / 100 * 200;

  test('niveaux de 1 à 10, défaut 5, plus souple que l\'ancien 10 %', () {
    expect(tolerancePctForLevel(1), 10);
    expect(tolerancePctForLevel(kDefaultTolerance), greaterThan(10));
    expect(tolerancePctForLevel(10), greaterThan(tolerancePctForLevel(9)));
  });

  test('un tracé décalé est accepté au niveau 10, refusé au niveau 1', () {
    final user = _shifted(ref, 30);
    expect(
      validateTrace(user, ref, px(1), anchorTolerancePx: 20).valid,
      isFalse,
    );
    // Un décalage de 30 reste dans le rayon de départ (20 × 1.6 = 32).
    expect(
      validateTrace(user, ref, px(10), anchorTolerancePx: 20).valid,
      isTrue,
    );
  });

  test('la souplesse ne rend jamais le sens ni le départ facultatifs', () {
    final reversed = ref.reversed.toList();
    expect(
      validateTrace(reversed, ref, px(10), anchorTolerancePx: 20).valid,
      isFalse,
      reason: 'tracé à l\'envers',
    );
    // Commencé au milieu du trait : couloir large, mais départ refusé.
    final lateStart = ref.sublist(ref.length ~/ 2);
    expect(
      validateTrace(lateStart, ref, px(10), anchorTolerancePx: 20).valid,
      isFalse,
      reason: 'départ au milieu',
    );
  });
}
