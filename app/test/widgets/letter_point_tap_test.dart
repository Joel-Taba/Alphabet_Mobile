import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/data/letter_style_resolver.dart';
import 'package:gentle_paths_academy/hooks/use_writing_style.dart';
import 'package:gentle_paths_academy/services/progress_service.dart';
import 'package:gentle_paths_academy/utils/trace_validation.dart';
import 'package:gentle_paths_academy/widgets/letter_trace_cell.dart';
import 'package:gentle_paths_academy/widgets/repetition_row.dart';
import 'package:provider/provider.dart';

import '../helpers/app_harness.dart';
import '../helpers/test_env.dart';

Offset _centroid(String pathD) {
  final pts = sampleSvgPath(pathD, 12);
  return pts.reduce((a, b) => a + b) / pts.length.toDouble();
}

/// Suit un tracé au doigt, point par point.
Future<void> _trace(WidgetTester tester, List<Offset> pts) async {
  final g = await tester.startGesture(pts.first);
  for (final p in pts.skip(1)) {
    await g.moveTo(p);
    await tester.pump(const Duration(milliseconds: 8));
  }
  await g.up();
  await tester.pump(const Duration(milliseconds: 700));
}

/// Réalise un signe dans un repère 200×200 posé en [origin] à l'échelle
/// [scale] : un toucher pour un point, un tracé sinon.
Future<void> _doStep(
  WidgetTester tester,
  dynamic step,
  Offset origin,
  double scale,
) async {
  final pathD = step['pathD'] as String;
  if (step['family'] == 'point') {
    await tester.tapAt(origin + _centroid(pathD) * scale);
    await tester.pump(const Duration(milliseconds: 700));
  } else {
    await _trace(tester, [
      for (final p in sampleSvgPath(pathD, 50)) origin + p * scale,
    ]);
  }
}

final _activeCell = find.byWidgetPredicate(
  (w) => w is LetterTraceCell && w.isActive && !w.given,
);

void main() {
  setUp(resetTestEnv);

  for (final style in WritingStyle.values) {
    for (final char in ['i', 'j']) {
      testWidgets('le point du « $char » (${style.name}) se fait d\'un simple '
          'toucher, dans la ligne du signe et dans la lettre complète', (
        tester,
      ) async {
        final family = await launchApp(tester, size: const Size(412, 4200));
        await tester.runAsync(() => family.createChild('Awa'));
        final ctx = tester.element(find.byType(Navigator).first);
        await tester.runAsync(
          () => Provider.of<WritingStyleProvider>(
            ctx,
            listen: false,
          ).setStyle(style),
        );
        final progress = Provider.of<ProgressProvider>(ctx, listen: false);
        await tester.runAsync(progress.rechargerPourEnfantActif);
        await goTo(tester, '/accueil');
        await goTo(tester, '/exercice/lettre/$char');

        final steps = getLetterFormation(char, style.name)!['steps'] as List;
        expect(steps.last['family'], 'point');
        bool done() => progress.isCompleted(
          typeEtape: 'LETTRE',
          modalite: 'EXERCICE',
          etapeCode: char,
        );

        // ---- Phase 1 : une ligne par signe, 3 répétitions chacune -------
        final rows = find.byType(RepetitionRow);
        expect(rows, findsNWidgets(steps.length));
        for (var s = 0; s < steps.length; s++) {
          final row = tester.widget<RepetitionRow>(rows.at(s));
          expect(
            row.entry.tapOnly,
            steps[s]['family'] == 'point',
            reason: 'seul le point se fait au toucher',
          );
          final cells = find.descendant(
            of: rows.at(s),
            matching: find.byWidgetPredicate(
              (w) => w.runtimeType.toString() == '_OccurrenceCanvas',
            ),
          );
          final n = tester.widgetList(cells).length;
          for (var k = 0; k < n; k++) {
            await tester.ensureVisible(cells.at(k));
            await tester.pump();
            final w = (tester.widget(cells.at(k)) as dynamic).w as double;
            final h = (tester.widget(cells.at(k)) as dynamic).h as double;
            final scale = (w < h ? w : h) / 200;
            final origin =
                tester.getTopLeft(cells.at(k)) +
                Offset((w - 200 * scale) / 2, (h - 200 * scale) / 2);
            await _doStep(tester, steps[s], origin, scale);
          }
          await advance(tester, frames: 4);
        }
        expect(done(), isFalse, reason: 'il reste la lettre complète');

        // ---- Phase 2 : la lettre complète, 3 fois ------------------------
        await advance(tester, frames: 6);
        expect(_activeCell, findsWidgets, reason: 'lettre complète débloquée');
        for (var rep = 0; rep < 3; rep++) {
          await tester.ensureVisible(_activeCell.first);
          await tester.pump();
          final cell = tester.widget<LetterTraceCell>(_activeCell.first);
          final scale = cell.size / 200;
          Offset origin() => tester.getTopLeft(_activeCell.first);
          for (final st in steps) {
            if (st['family'] == 'point' && rep == 2) {
              // Toucher en bas de la case, loin du point : refusé, la lettre
              // n'est pas validée.
              await tester.tapAt(
                origin() + Offset(cell.size / 2, cell.size - 6),
              );
              await tester.pump(const Duration(milliseconds: 1400));
              expect(done(), isFalse, reason: 'toucher hors du point refusé');
            }
            await _doStep(tester, st, origin(), scale);
          }
          await advance(tester, frames: 4);
        }
        expect(done(), isTrue, reason: 'la lettre « $char » est réalisée');
        expect(tester.takeException(), isNull);
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpWidget(const SizedBox());
        await advance(tester, frames: 5);
      }, variant: mobile);
    }
  }
}
