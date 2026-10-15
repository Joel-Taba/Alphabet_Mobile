import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/data/sign_exercise_catalog.dart';
import 'package:gentle_paths_academy/i18n/translations.dart';
import 'package:gentle_paths_academy/widgets/trace_controls_toolbar.dart';

import '../helpers/app_harness.dart';
import '../helpers/test_env.dart';

void main() {
  setUp(resetTestEnv);

  test('chaque signe du Palier 1 a son titre-consigne, dans les 4 langues', () {
    for (final dict in [fr, en, es, ar]) {
      final titles =
          (dict['exerciceListe'] as Map<String, dynamic>)['signTitles']
              as Map<String, dynamic>;
      for (final e in EXERCISE_CATALOG) {
        expect(titles[e['id']], isNotNull, reason: '${e['id']}');
      }
    }
  });

  test('version longue et petite version sont nommées distinctement', () {
    final ids = {for (final e in EXERCISE_CATALOG) e['id'] as String};
    for (final e in EXERCISE_CATALOG) {
      final id = e['id'] as String;
      if (!id.endsWith('-full') ||
          !ids.contains(id.replaceFirst('-full', '-reduced'))) {
        continue;
      }
      expect(
        (e['label']['fr'] as String).toLowerCase(),
        startsWith('long'),
        reason: id,
      );
    }
  });

  testWidgets('la consigne lue est exactement le titre de l\'exercice', (
    tester,
  ) async {
    final family = await launchApp(tester);
    await tester.runAsync(() => family.createChild('Awa'));
    final spoken = <String>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter_tts'), (
          call,
        ) async {
          if (call.method == 'speak') spoken.add(call.arguments as String);
          return 1;
        });
    await goTo(tester, '/cours/trait');
    await advance(tester, frames: 12);
    spoken.clear();
    await tester.tap(
      find.descendant(
        of: find.byType(TraceControlsToolbar),
        matching: find.bySemanticsLabel('Consigne'),
      ),
    );
    await advance(tester, frames: 6);
    expect(
      spoken.join(' '),
      contains('Le long trait vertical se trace sur 2 interlignes'),
    );
  });
}
