import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/data/calcul_catalog.dart';
import 'package:gentle_paths_academy/data/palier2_groups.dart';
import 'package:gentle_paths_academy/data/shape_catalog.dart';
import 'package:gentle_paths_academy/data/sign_exercise_catalog.dart';
import 'package:gentle_paths_academy/data/solid3d_catalog.dart';
import 'package:gentle_paths_academy/data/syllable_catalog.dart';
import 'package:gentle_paths_academy/data/word_catalog.dart';
import 'package:gentle_paths_academy/widgets/repetition_row.dart';

import '../helpers/app_harness.dart';
import '../helpers/test_env.dart';

/// Le défilement principal de la page : le plus grand défilement vertical.
ScrollableState? _mainScroll(WidgetTester tester) {
  ScrollableState? best;
  var bestH = 0.0;
  for (final s in tester.stateList<ScrollableState>(find.byType(Scrollable))) {
    if (axisDirectionToAxis(s.axisDirection) != Axis.vertical) continue;
    final box = s.context.findRenderObject() as RenderBox?;
    final h = box?.size.height ?? 0;
    if (h > bestH) {
      bestH = h;
      best = s;
    }
  }
  return best;
}

/// Noms des widgets à état déclarés dans l'application (pas ceux de
/// Flutter, qui ne portent aucune donnée d'exercice).
Set<String> _appStatefulWidgets() {
  final re = RegExp(r'class (\w+) extends StatefulWidget');
  return {
    for (final f in Directory('lib').listSync(recursive: true))
      if (f is File && f.path.endsWith('.dart'))
        for (final m in re.allMatches(f.readAsStringSync())) m.group(1)!,
  };
}

void main() {
  setUp(resetTestEnv);

  testWidgets('une ligne de tracé garde son état après un aller-retour de '
      'défilement', (tester) async {
    final family = await launchApp(tester, size: const Size(360, 640));
    await tester.runAsync(() => family.createChild('Awa'));
    await goTo(tester, '/exercice-liste?family=trait');

    final firstId =
        EXERCISE_CATALOG.firstWhere((e) => e['family'] == 'trait')['id'];
    final row = find.descendant(
      of: find.byKey(ValueKey('$firstId-r0')),
      matching: find.byType(RepetitionRow),
    );
    expect(row, findsOneWidget);
    final before = tester.state(row);

    final scroll = find.byType(Scrollable).first;
    for (var i = 0; i < 8; i++) {
      await tester.drag(scroll, const Offset(0, -600));
      await advance(tester, frames: 2);
    }
    for (var i = 0; i < 12; i++) {
      await tester.drag(scroll, const Offset(0, 600));
      await advance(tester, frames: 2);
    }
    expect(row, findsOneWidget);
    expect(
      identical(tester.state(row), before),
      isTrue,
      reason: 'la ligne a été détruite puis recréée : tracés en cours perdus',
    );
  }, variant: mobile);

  testWidgets('aucune page d\'exercice ne perd l\'état de ses éléments au '
      'défilement', (tester) async {
    final family = await launchApp(tester, size: const Size(360, 640));
    await tester.runAsync(() => family.createChild('Awa'));
    final groups = getPalier2Groups('fr');
    final routes = allRoutes(
      signFamilies: FAMILY_ORDER,
      letterGroupFirstChars: groups.map((g) => g.chars.first),
      letterGroupIds: groups.map((g) => g.id),
      consonants: SYLLABLE_GROUPS.map((g) => g['consonant'] as String),
      calculTopics: CALCUL_TOPICS.map((t) => t.id),
      wordGroups: PALIER3_GROUPS.map((g) => g.id),
      shapes: SHAPE_TOPICS.map((t) => t.id),
      solids: SOLID3D_TOPICS.map((t) => t.id),
      vraiFauxLevels: VRAI_FAUX_LEVELS.length,
      composeLevels: COMPOSE_NOMBRE_LEVELS.length,
    ).where((r) => r.startsWith('/exercice'));

    final appWidgets = _appStatefulWidgets();
    final failures = <String>[];
    for (final route in routes) {
      await goTo(tester, route);
      final main = _mainScroll(tester);
      if (main == null || main.position.maxScrollExtent <= 0) continue;
      final before = tester
          .stateList(
            find.descendant(
              of: find.byWidget(main.widget),
              matching: find.byWidgetPredicate((w) => w is StatefulWidget),
            ),
          )
          .toList();
      // Saut programmatique : un glissé sur une case de tracé tracerait.
      final max = main.position.maxScrollExtent;
      for (var y = 0.0; y < max; y += 500) {
        main.position.jumpTo(y);
        await tester.pump();
      }
      main.position.jumpTo(max);
      await tester.pump();
      main.position.jumpTo(0);
      await advance(tester, frames: 2);
      final lost = before
          .where((s) => !s.mounted)
          .map((s) => s.widget.runtimeType.toString())
          .where(appWidgets.contains)
          // État purement visuel (secousse, appui) : la réponse choisie est
          // gardée par l'écran du quiz lui-même.
          .where((n) => n != 'LetteredChoiceButton' && n != 'QuizShake')
          .toSet();
      if (lost.isNotEmpty) failures.add('$route → ${lost.join(', ')}');
    }
    expect(failures, isEmpty, reason: failures.join('\n'));
  }, variant: mobile);
}
