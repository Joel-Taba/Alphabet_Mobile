import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/utils/trace_validation.dart';
import 'package:gentle_paths_academy/widgets/letter_trace_cell.dart';

import '../helpers/app_harness.dart';
import '../helpers/test_env.dart';

final _active = find.byWidgetPredicate(
  (w) => w is LetterTraceCell && w.isActive && !w.given,
);

/// Trace un signe de la case active. [pauseAfterMs] : temps laissé après le
/// lever du doigt, avant le geste suivant.
Future<void> _stroke(
  WidgetTester tester,
  String pathD, {
  required int pauseAfterMs,
}) async {
  final cell = _active.first;
  final widget = tester.widget<LetterTraceCell>(cell);
  final topLeft = tester.getTopLeft(cell);
  final scale = widget.size / 200;
  final pts = [for (final p in sampleSvgPath(pathD, 50)) topLeft + p * scale];
  final g = await tester.startGesture(pts.first);
  for (final p in pts.skip(1)) {
    await g.moveTo(p);
    await tester.pump(const Duration(milliseconds: 10));
  }
  await g.up();
  await tester.pump(Duration(milliseconds: pauseAfterMs));
}

void main() {
  setUp(resetTestEnv);

  // Un enfant qui enchaîne vite les traits d'une lettre repose le doigt
  // quelques dizaines de millisecondes après l'avoir levé. La case ne doit
  // jamais se bloquer, quel que soit ce délai.
  for (final pause in [0, 40, 120, 250, 340, 360, 600]) {
    testWidgets('enchaîner les signes du « W » avec $pause ms entre deux '
        'traits ne bloque jamais le tracé', (tester) async {
      final family = await launchApp(tester, size: const Size(412, 915));
      await tester.runAsync(() => family.createChild('Awa'));
      await goTo(tester, '/exercice/mots/an1');
      await goTo(tester, '/exercice/syllabes/w');
      expect(_active, findsWidgets);

      // Syllabe « wa » : le « w » (4 traits) puis le « a ».
      var w = tester.widget<LetterTraceCell>(_active.first);
      expect(w.letter['char'], 'w');
      final steps = [for (final s in w.letter['steps'] as List) s['pathD']];
      expect(steps.length, greaterThan(2));
      await tester.ensureVisible(_active.first);
      await tester.pump();
      for (final d in steps) {
        await _stroke(tester, d as String, pauseAfterMs: pause);
      }
      await advance(tester, frames: 12);
      w = tester.widget<LetterTraceCell>(_active.first);
      expect(
        w.letter['char'],
        'a',
        reason: 'le « w » aurait dû être validé et la lettre suivante activée',
      );

      // La case suivante doit répondre elle aussi.
      for (final s in w.letter['steps'] as List) {
        await _stroke(tester, s['pathD'] as String, pauseAfterMs: pause);
      }
      await advance(tester, frames: 12);
      expect(tester.widget<LetterTraceCell>(_active.first).letter['char'], 'w');
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpWidget(const SizedBox());
      await advance(tester, frames: 5);
    }, variant: mobile);
  }
}
