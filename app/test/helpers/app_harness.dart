import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/app.dart';
import 'package:gentle_paths_academy/services/family_service.dart';
import 'package:go_router/go_router.dart';

import 'test_env.dart';

/// L'application est destinée aux terminaux mobiles : tous les tests
/// d'écran tournent comme sur un appareil Android tactile, aux tailles
/// d'écran réelles de ces terminaux. (Tailles en points logiques.)
const Map<String, Size> kScreens = {
  'petit téléphone': Size(360, 640),
  'téléphone': Size(412, 915),
  'tablette': Size(800, 1280),
};

/// Simule les modules natifs absents des tests (synthèse vocale, état du
/// réseau) : ils répondent "OK" sans rien faire.
void mockNativePlugins() {
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(
    const MethodChannel('flutter_tts'),
    (call) async => 1,
  );
  messenger.setMockMethodCallHandler(
    const MethodChannel('dev.fluttercommunity.plus/connectivity'),
    (call) async => ['none'],
  );
  messenger.setMockStreamHandler(
    const EventChannel('dev.fluttercommunity.plus/connectivity_status'),
    MockStreamHandler.inline(onListen: (args, sink) {}),
  );
}

bool _fontsLoaded = false;

/// Charge les vraies polices de l'app. Sans ça, Flutter teste avec une
/// police où chaque lettre est un carré très large, ce qui provoque de faux
/// débordements de texte.
Future<void> loadAppFonts() async {
  if (_fontsLoaded) return;
  const fonts = {
    'Baloo 2': ['assets/fonts/Baloo2-Variable.ttf'],
    'Comic Neue': ['assets/fonts/ComicNeue-Light.ttf'],
    'Cursive Standard': ['assets/fonts/CursiveStandard.ttf'],
    'OpenDyslexic': ['assets/fonts/OpenDyslexic-Regular.otf'],
  };
  for (final entry in fonts.entries) {
    final loader = FontLoader(entry.key);
    for (final asset in entry.value) {
      loader.addFont(rootBundle.load(asset));
    }
    await loader.load();
  }
  // Police par défaut (textes sans famille précise) : Baloo aussi.
  final fallback = FontLoader('Roboto')
    ..addFont(rootBundle.load('assets/fonts/Baloo2-Variable.ttf'));
  await fallback.load();
  _fontsLoaded = true;
}

/// Lance l'application complète, comme `main.dart`, sur un écran [size].
Future<FamilyService> launchApp(
  WidgetTester tester, {
  Size size = const Size(412, 915),
}) async {
  mockNativePlugins();
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  late FamilyService family;
  await tester.runAsync(() async {
    await loadAppFonts();
    family = FamilyService();
    await family.ready;
  });
  await tester.pumpWidget(AmaniApp(familyService: family));
  await advance(tester);
  return family;
}

/// Fait avancer le temps (animations, minuteurs, chargements du stockage
/// simulé) sans attendre la fin des animations infinies de l'app.
Future<void> advance(WidgetTester tester, {int frames = 12}) async {
  for (var i = 0; i < frames; i++) {
    await tester.runAsync(settle);
    await tester.pump(const Duration(milliseconds: 150));
  }
}

/// Navigue vers [location] comme le ferait un lien de l'app.
Future<void> goTo(
  WidgetTester tester,
  String location, {
  bool push = false,
}) async {
  final context = tester.element(find.byType(Navigator).first);
  if (push) {
    GoRouter.of(context).push(location);
  } else {
    GoRouter.of(context).go(location);
  }
  await advance(tester);
}

/// Toutes les pages de l'application, avec des paramètres réels tirés des
/// catalogues.
List<String> allRoutes({
  required Iterable<String> signFamilies,
  required Iterable<String> letterGroupFirstChars,
  required Iterable<String> letterGroupIds,
  required Iterable<String> consonants,
  required Iterable<String> calculTopics,
  required Iterable<String> wordGroups,
  required Iterable<String> shapes,
  required Iterable<String> solids,
  required int vraiFauxLevels,
  required int composeLevels,
}) => [
  '/',
  '/profil',
  '/connexion',
  '/accueil',
  '/bibliotheque',
  '/mon-profil',
  '/cours-signes-intro',
  for (final f in signFamilies) ...['/cours/$f', '/exercice-liste?family=$f'],
  '/exercice-liste?family=${signFamilies.first}&amaniEval=1',
  for (final c in letterGroupFirstChars) ...[
    '/cours/lettres/formation/$c',
    '/exercice/lettre/$c',
    '/exercice/puzzle-formule/$c',
  ],
  for (final g in letterGroupIds) '/exercice-liste?group=$g',
  for (final c in consonants) ...[
    '/cours/syllabes/$c',
    '/exercice/syllabes/$c',
  ],
  for (final t in calculTopics) ...['/cours/calcul/$t', '/exercice/calcul/$t'],
  '/exercice/calcul/${calculTopics.first}?amaniEval=1',
  for (final g in wordGroups) ...['/cours/mots/$g', '/exercice/mots/$g'],
  for (final lvl in [2, 6, 10]) '/exercice/mots-meles/lvl$lvl',
  for (var i = 0; i < vraiFauxLevels; i++) '/exercice/calcul-vrai-faux/$i',
  for (var i = 0; i < composeLevels; i++) '/exercice/calcul-compose/$i',
  for (final s in shapes) ...['/cours/figure/$s', '/exercice/figure/$s'],
  '/exercice/figure-quiz',
  '/exercice/figure-objet',
  '/exercice/figure-vrai-faux',
  for (final s in solids) ...['/cours/solide/$s', '/exercice/solide/$s'],
  '/exercice/solide/${solids.first}?amaniEval=1',
];

/// À passer à chaque `testWidgets` d'écran : exécute le test comme sur un
/// terminal mobile Android.
final mobile = TargetPlatformVariant.only(TargetPlatform.android);
