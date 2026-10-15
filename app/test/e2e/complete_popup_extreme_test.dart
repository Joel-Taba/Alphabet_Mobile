import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/data/shape_calc_problem.dart';
import 'package:gentle_paths_academy/data/shape_catalog.dart';
import 'package:gentle_paths_academy/hooks/use_accessibility_settings.dart';
import 'package:gentle_paths_academy/i18n/translations.dart';
import 'package:gentle_paths_academy/widgets/exercise_complete_popup.dart';
import 'package:gentle_paths_academy/widgets/shape_answer_keypad.dart';
import 'package:provider/provider.dart';

import '../helpers/app_harness.dart';
import '../helpers/test_env.dart';

Finder _mainScrollable(WidgetTester tester) {
  final all = find.byType(Scrollable);
  var best = 0;
  var bestH = 0.0;
  for (var i = 0; i < all.evaluate().length; i++) {
    final s = tester.state<ScrollableState>(all.at(i));
    if (axisDirectionToAxis(s.axisDirection) != Axis.vertical) continue;
    final h = tester.getSize(all.at(i)).height;
    if (h > bestH) {
      bestH = h;
      best = i;
    }
  }
  return all.at(best);
}

Future<void> _answer(WidgetTester tester, String label, int answer) async {
  if (tester.widgetList(find.byType(ShapeAnswerKeypad)).isEmpty) {
    // Défilement programmatique : un glissé au centre tomberait sur la
    // feuille d'écriture libre, qui dessine au lieu de défiler.
    final pos = tester.state<ScrollableState>(_mainScrollable(tester)).position;
    pos.jumpTo(0);
    await tester.pump();
    while (find.text(label).evaluate().isEmpty &&
        pos.pixels < pos.maxScrollExtent) {
      pos.jumpTo(pos.pixels + 150);
      await tester.pump();
    }
    await tester.ensureVisible(find.text(label).last);
    await tester.pump();
    await tester.tap(find.text(label).last);
    await advance(tester, frames: 3);
  }
  final keypad = find.byType(ShapeAnswerKeypad);
  for (final d in '$answer'.split('')) {
    final key = find.descendant(of: keypad, matching: find.text(d)).last;
    await tester.ensureVisible(key);
    await tester.tap(key);
    await tester.pump(const Duration(milliseconds: 120));
  }
  final ok = find.descendant(
    of: keypad,
    matching: find.byIcon(Icons.check_rounded),
  );
  await tester.ensureVisible(ok);
  await tester.tap(ok);
  await advance(tester, frames: 10);
}

void main() {
  setUp(resetTestEnv);

  final configs = <(String, Lang, bool)>[
    ('anglais, police dyslexie', Lang.en, true),
    ('arabe', Lang.ar, false),
  ];
  for (final (name, lang, dys) in configs) {
    testWidgets('fin d\'exercice en très grand texte : fenêtre lisible et '
        'boutons atteignables ($name)', (tester) async {
      final family = await launchApp(tester, size: const Size(360, 640));
      await tester.runAsync(() => family.createChild('Awa'));
      final ctx = tester.element(find.byType(Navigator).first);
      await tester.runAsync(() async {
        await Provider.of<LanguageProvider>(ctx, listen: false).setLang(lang);
        final a = Provider.of<AccessibilitySettings>(ctx, listen: false);
        await a.setUiScale(kMaxUiScale);
        await a.setDyslexiaFont(dys);
      });
      final t = Provider.of<LanguageProvider>(ctx, listen: false).t;
      final ef = t['coursFigure'] as Map<String, dynamic>;

      final errors = <String>[];
      final original = FlutterError.onError;
      FlutterError.onError = (d) {
        final where = RegExp(
          r'lib/[\w/]+\.dart:\d+',
        ).firstMatch(d.toString())?.group(0);
        errors.add('${d.exceptionAsString().split('\n').first} ($where)');
      };
      try {
        await goTo(tester, '/exercice/figure/carre');
        final topic = findShapeTopic('carre')!;
        final p = generateShapeCombinedProblem(topic, topic.id.hashCode ^ 0);
        await _answer(
          tester,
          ef['perimeterLabel'] as String,
          p.perimeterAnswer,
        );
        await _answer(tester, ef['areaLabel'] as String, p.areaAnswer);
        expect(find.byType(ExerciseCompletePopup), findsOneWidget);

        // Le bouton "Accueil" (dernier de la fenêtre) doit pouvoir être
        // amené à l'écran et touché.
        final home = find.descendant(
          of: find.byType(ExerciseCompletePopup),
          matching: find.text(
            (t['common'] as Map)['backToHome'] as String? ?? 'Accueil',
          ),
        );
        await tester.ensureVisible(home);
        await tester.pump();
        final center = tester.getCenter(home);
        expect(
          center.dy >= 0 && center.dy <= 640,
          isTrue,
          reason: 'bouton hors de l\'écran ($center)',
        );
      } finally {
        FlutterError.onError = original;
      }
      expect(errors.toSet(), isEmpty, reason: errors.toSet().join('\n'));
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpWidget(const SizedBox());
      await advance(tester, frames: 10);
    }, variant: mobile);
  }
}
