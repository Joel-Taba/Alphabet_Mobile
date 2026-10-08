import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/screens/exercice_liste_screen.dart';

import '../helpers/app_harness.dart';
import '../helpers/test_env.dart';

void main() {
  setUp(resetTestEnv);

  testWidgets('un double tap rapide n\'ouvre la page qu\'une seule fois', (
    tester,
  ) async {
    final family = await launchApp(tester);
    await tester.runAsync(() => family.createChild('Awa'));
    await goTo(tester, '/cours/trait');

    final button = find.text('Passer aux exercices');
    await tester.scrollUntilVisible(
      button,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    await tester.tap(button);
    await tester.pump(const Duration(milliseconds: 20));
    await tester.tap(button, warnIfMissed: false);
    await advance(tester, frames: 6);

    expect(
      find.byType(ExerciceListeScreen, skipOffstage: false),
      findsOneWidget,
      reason: 'deux taps ont empilé deux fois la même page',
    );
  }, variant: mobile);
}
