import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/data/calcul_catalog.dart';
import 'package:gentle_paths_academy/data/palier2_groups.dart';
import 'package:gentle_paths_academy/data/shape_catalog.dart';
import 'package:gentle_paths_academy/data/sign_exercise_catalog.dart';
import 'package:gentle_paths_academy/data/solid3d_catalog.dart';
import 'package:gentle_paths_academy/data/syllable_catalog.dart';
import 'package:gentle_paths_academy/data/word_catalog.dart';
import 'package:gentle_paths_academy/hooks/use_accessibility_settings.dart';
import 'package:gentle_paths_academy/hooks/use_exercise_settings.dart';
import 'package:gentle_paths_academy/hooks/use_writing_style.dart';
import 'package:gentle_paths_academy/i18n/translations.dart';
import 'package:gentle_paths_academy/services/family_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/app_harness.dart';
import '../helpers/test_env.dart';

/// Même "robot visiteur" que `crawl_all_pages_test.dart`, mais avec les
/// réglages poussés à l'extrême, tels qu'un parent peut les choisir :
/// autre langue (dont l'arabe, écrit de droite à gauche), police dyslexie,
/// interface agrandie au maximum, écriture cursive, 20 répétitions.
const _only = String.fromEnvironment('ONLY');

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

  final configs = <(String, Lang, Size)>[
    ('arabe, petit téléphone', Lang.ar, const Size(360, 640)),
    ('anglais, petit téléphone', Lang.en, const Size(360, 640)),
    ('espagnol, tablette', Lang.es, const Size(800, 1280)),
  ];

  for (final (name, lang, size) in configs) {
    testWidgets('pages sans erreur avec réglages extrêmes ($name)', (
      tester,
    ) async {
      final family = await launchApp(tester, size: size);
      await tester.runAsync(() async {
        await family.createChild('Awa');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(scopeKey(kRepetitionsStorageKey), kMaxRepetitions);
      });
      final ctx = tester.element(find.byType(Navigator).first);
      await tester.runAsync(() async {
        bool on(String k) => _only.isEmpty || _only == k;
        if (on('lang')) {
          await Provider.of<LanguageProvider>(ctx, listen: false).setLang(lang);
        }
        final a11y = Provider.of<AccessibilitySettings>(ctx, listen: false);
        if (on('scale')) await a11y.setUiScale(kMaxUiScale);
        if (on('dys')) await a11y.setDyslexiaFont(true);
        if (on('cursive')) {
          await Provider.of<WritingStyleProvider>(
            ctx,
            listen: false,
          ).setStyle(WritingStyle.cursive);
        }
      });
      await advance(tester, frames: 3);

      final failures = <String>[];
      var current = 'lancement';
      final original = FlutterError.onError;
      FlutterError.onError = (details) {
        final first = details.exceptionAsString().split('\n').first;
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
  }
}
