import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/data/sign_exercise_catalog.dart';
import 'package:gentle_paths_academy/hooks/use_accessibility_settings.dart';
import 'package:gentle_paths_academy/i18n/translations.dart';
import 'package:gentle_paths_academy/services/progress_service.dart';
import 'package:gentle_paths_academy/utils/trace_validation.dart';
import 'package:provider/provider.dart';

import '../helpers/app_harness.dart';
import '../helpers/test_env.dart';

/// Un "doigt" simulé suit exactement le signe tel qu'il est DESSINÉ à
/// l'écran : si le point de contact et le tracé étaient décalés (échelle,
/// centrage, mise en page droite-à-gauche...), la validation échouerait.
Future<void> _traceOccurrence(
  WidgetTester tester,
  Finder occurrence,
  String pathD, {
  Offset shift = Offset.zero,
}) async {
  await tester.ensureVisible(occurrence);
  await tester.pump();
  final w = (tester.widget(occurrence) as dynamic).w as double;
  final h = (tester.widget(occurrence) as dynamic).h as double;
  final scale = (w < h ? w : h) / 200;
  final origin = Offset((w - 200 * scale) / 2, (h - 200 * scale) / 2);
  final topLeft = tester.getTopLeft(occurrence);
  final pts = [
    for (final p in sampleSvgPath(pathD, 60))
      topLeft + origin + p * scale + shift,
  ];
  final g = await tester.startGesture(pts.first);
  for (final p in pts.skip(1)) {
    await g.moveTo(p);
    await tester.pump(const Duration(milliseconds: 8));
  }
  await g.up();
  await tester.pump(const Duration(milliseconds: 900));
  await tester.pump(const Duration(milliseconds: 900));
}

void main() {
  setUp(resetTestEnv);

  final configs = <(String, Lang, double, Size)>[
    ('français, taille par défaut, téléphone', Lang.fr, kDefaultUiScale,
        const Size(412, 915)),
    ('arabe (droite à gauche), taille max, petit téléphone', Lang.ar,
        kMaxUiScale, const Size(360, 640)),
    ('français, taille min, petit téléphone', Lang.fr, kMinUiScale,
        const Size(360, 640)),
    ('anglais, taille max, tablette', Lang.en, kMaxUiScale,
        const Size(800, 1280)),
  ];

  for (final (name, lang, uiScale, size) in configs) {
    testWidgets('un tracé au doigt exactement sur le signe est validé ($name)',
        (tester) async {
      final family = await launchApp(tester, size: size);
      await tester.runAsync(() => family.createChild('Awa'));
      final ctx = tester.element(find.byType(Navigator).first);
      await tester.runAsync(() async {
        await Provider.of<LanguageProvider>(ctx, listen: false).setLang(lang);
        await Provider.of<AccessibilitySettings>(ctx, listen: false)
            .setUiScale(uiScale);
      });
      final progress = Provider.of<ProgressProvider>(ctx, listen: false);
      await tester.runAsync(progress.rechargerPourEnfantActif);
      await goTo(tester, '/exercice-liste?family=trait');

      final entry = EXERCISE_CATALOG.firstWhere((e) => e['family'] == 'trait');
      final row = find.byKey(ValueKey('${entry['id']}-r0'));
      final occurrences = find.descendant(
        of: row,
        matching: find.byWidgetPredicate(
          (w) => w.runtimeType.toString() == '_OccurrenceCanvas',
        ),
      );
      final n = tester.widgetList(occurrences).length;
      expect(n, greaterThan(0));

      // Un tracé décalé d'un tiers de case ne doit PAS être accepté.
      final w0 = (tester.widget(occurrences.first) as dynamic).w as double;
      await _traceOccurrence(
        tester,
        occurrences.first,
        entry['pathD'] as String,
        shift: Offset(w0 / 3, w0 / 3),
      );
      await tester.pump(const Duration(seconds: 3));
      expect(
        progress.isCompleted(
          typeEtape: 'SIGNE',
          modalite: 'EXERCICE',
          etapeCode: entry['id'] as String,
        ),
        isFalse,
      );

      for (var i = 0; i < n; i++) {
        await _traceOccurrence(
          tester,
          occurrences.at(i),
          entry['pathD'] as String,
        );
      }
      expect(
        progress.isCompleted(
          typeEtape: 'SIGNE',
          modalite: 'EXERCICE',
          etapeCode: entry['id'] as String,
        ),
        isTrue,
        reason: 'les $n tracés exacts auraient dû valider le signe',
      );
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpWidget(const SizedBox());
      await advance(tester, frames: 3);
    }, variant: mobile);
  }
}
