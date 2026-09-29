import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/data/calcul_catalog.dart';
import 'package:gentle_paths_academy/data/palier2_groups.dart';
import 'package:gentle_paths_academy/data/shape_catalog.dart';
import 'package:gentle_paths_academy/data/sign_exercise_catalog.dart';
import 'package:gentle_paths_academy/data/solid3d_catalog.dart';
import 'package:gentle_paths_academy/data/syllable_catalog.dart';
import 'package:gentle_paths_academy/data/word_catalog.dart';

import '../helpers/app_harness.dart';
import '../helpers/test_env.dart';

/// "Robot visiteur" : ouvre chaque page de l'app (tous les cours, tous les
/// exercices, tous les mini-jeux), sur plusieurs tailles d'écran, et
/// échoue à la moindre erreur Flutter -- y compris un débordement d'écran
/// (bandes jaunes et noires), une exception pendant la construction, ou un
/// minuteur qui plante.
void main() {
  setUp(resetTestEnv);

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
  );

  kScreens.forEach((screenName, size) {
    testWidgets('toutes les pages s\'ouvrent sans erreur ($screenName)', (
      tester,
    ) async {
      final family = await launchApp(tester, size: size);
      await tester.runAsync(() => family.createChild('Awa'));
      final failures = <String>[];
      var current = 'lancement';
      final original = FlutterError.onError;
      FlutterError.onError = (details) {
        final first = details.exceptionAsString().split('\n').first;
        // Fichier et ligne du widget en cause, pour aller droit au but.
        final where = RegExp(
          r'lib/[\w/]+\.dart:\d+',
        ).firstMatch(details.toString())?.group(0);
        failures.add('$current → $first${where == null ? '' : ' ($where)'}');
      };
      try {
        for (final route in routes) {
          current = route;
          await goTo(tester, route);
        }
        // Revenir à l'accueil démonte proprement toutes les pages.
        current = 'retour à l\'accueil';
        await goTo(tester, '/accueil');
      } finally {
        FlutterError.onError = original;
      }
      final unique = failures.toSet().toList();
      expect(
        unique,
        isEmpty,
        reason: '${unique.length} erreur(s) :\n${unique.join('\n')}',
      );
      await tester.pumpWidget(const SizedBox());
      await advance(tester, frames: 3);
    }, variant: mobile);
  });
}
