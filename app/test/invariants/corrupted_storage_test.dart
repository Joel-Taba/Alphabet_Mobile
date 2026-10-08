import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/app.dart';
import 'package:gentle_paths_academy/services/family_service.dart';

import '../helpers/app_harness.dart';
import '../helpers/test_env.dart';

/// Données locales abîmées (ancienne version de l'app, écriture
/// interrompue...) : l'app doit démarrer et rester utilisable, jamais
/// planter à chaque ouverture.
Map<String, Object> _corrupted(String child) {
  String k(String base) => '${base}__$child';
  return {
    'amani_setting_lang': 'klingon',
    'amani_setting_ui_scale': 'énorme',
    'amani_setting_dyslexia_font': 'oui',
    'amani_setting_anim_speed': 42,
    'amani_setting_voice_gender': 7,
    'amani_setting_volume': 'fort',
    'amani_setting_sound': 'peut-être',
    k('amani_progress_log'): '[{"typeEtape": 3, "modalite": null}, "x", {',
    k('amani_progress_bonus_points'): 'beaucoup',
    k('amani_setting_repetitions'): 'trois',
    k('amani_setting_tolerance'): 2.5,
    k('amani_setting_evaluation_duration'): '5min',
    k('amani_setting_format'): 'gothique',
    k('amani_cours_viewed_LETTRE_l1'): '{pas une liste}',
    k('amani_eval_progress_eval-palier1'): '[1,2',
    k('amani_backend_token'): 12,
    k('amani_profile_name'): 99,
    k('amani_profile_password'): true,
    k('amani_profile_photo'): 'pas-du-base64-%%%',
  };
}

Future<List<String>> _visit(WidgetTester tester, List<String> routes) async {
  final failures = <String>[];
  var current = 'démarrage';
  final original = FlutterError.onError;
  FlutterError.onError = (d) =>
      failures.add('$current → ${d.exceptionAsString().split('\n').first}');
  try {
    await advance(tester, frames: 6);
    for (final r in routes) {
      current = r;
      await goTo(tester, r);
      final e = tester.takeException();
      if (e != null) failures.add('$r → $e');
    }
  } finally {
    FlutterError.onError = original;
  }
  return failures;
}

const _routes = [
  '/accueil',
  '/mon-profil',
  '/bibliotheque',
  '/cours/trait',
  '/exercice-liste?family=trait',
  '/cours/lettres/formation/a?pg=l1',
  '/exercice/lettre/a?pg=l1',
  '/exercice/mots/an1',
  '/exercice/figure/carre',
  '/exercice/calcul/ce1-addition-posee?amaniEval=1',
  '/accueil',
];

Future<void> _launch(WidgetTester tester) async {
  mockNativePlugins();
  tester.view.physicalSize = const Size(412, 915);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  late FamilyService family;
  await tester.runAsync(() async {
    await loadAppFonts();
    family = FamilyService();
    await family.ready;
  });
  await tester.pumpWidget(AmaniApp(familyService: family));
}

void main() {
  testWidgets('données de l\'enfant actif illisibles : l\'app reste '
      'utilisable', (tester) async {
    await resetTestEnv({
      'amani_children': '[{"id":"c1","nom":"Awa"}]',
      'amani_active_child_id': 'c1',
      ..._corrupted('c1'),
    });
    await _launch(tester);
    final failures = await _visit(tester, _routes);
    expect(failures.toSet(), isEmpty, reason: failures.toSet().join('\n'));
    await tester.pumpWidget(const SizedBox());
    await advance(tester, frames: 20);
  }, variant: mobile);

  testWidgets('liste d\'enfants illisible et enfant actif inexistant', (
    tester,
  ) async {
    await resetTestEnv({
      'amani_children': '[{"id": 5}, "rien", {',
      'amani_active_child_id': 'fantome',
      ..._corrupted('fantome'),
    });
    await _launch(tester);
    final failures = await _visit(tester, ['/', ..._routes]);
    expect(failures.toSet(), isEmpty, reason: failures.toSet().join('\n'));
    await tester.pumpWidget(const SizedBox());
    await advance(tester, frames: 20);
  }, variant: mobile);

  testWidgets('enfant actif supprimé de la liste (identifiant orphelin)', (
    tester,
  ) async {
    await resetTestEnv({
      'amani_children': '[{"id":"c1","nom":"Awa"}]',
      'amani_active_child_id': 'c2',
    });
    await _launch(tester);
    final failures = await _visit(tester, ['/', ..._routes]);
    expect(failures.toSet(), isEmpty, reason: failures.toSet().join('\n'));
    await tester.pumpWidget(const SizedBox());
    await advance(tester, frames: 20);
  }, variant: mobile);

  testWidgets('réglages numériques hors limites', (tester) async {
    await resetTestEnv({
      'amani_children': '[{"id":"c1","nom":"Awa"}]',
      'amani_active_child_id': 'c1',
      'amani_setting_ui_scale': 99.0,
      'amani_setting_volume': 7.5,
      'amani_setting_repetitions__c1': 100000,
      'amani_setting_tolerance__c1': -5,
      'amani_setting_evaluation_duration__c1': 0,
      'amani_progress_bonus_points__c1': -999999,
      'accueil_current_step_idx': 99999,
    });
    await _launch(tester);
    final failures = await _visit(tester, ['/', ..._routes]);
    expect(failures.toSet(), isEmpty, reason: failures.toSet().join('\n'));
    await tester.pumpWidget(const SizedBox());
    await advance(tester, frames: 20);
  }, variant: mobile);
}
