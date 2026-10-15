import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/hooks/use_accessibility_settings.dart';
import 'package:gentle_paths_academy/i18n/translations.dart';
import 'package:gentle_paths_academy/services/progress_service.dart';
import 'package:provider/provider.dart';

import '../helpers/app_harness.dart';
import '../helpers/test_env.dart';

const _pointId = 'point-center-full';

final _cells = find.byWidgetPredicate(
  (w) => w.runtimeType.toString() == '_OccurrenceCanvas',
);

/// Position à l'écran du point vert de la case n°[i] (centre du point dans
/// le repère 200×200, mis à l'échelle et centré comme le fait la case).
Future<Offset> _dot(WidgetTester tester, int i) async {
  final cell = _cells.at(i);
  await tester.ensureVisible(cell);
  await tester.pump();
  final w = (tester.widget(cell) as dynamic).w as double;
  final h = (tester.widget(cell) as dynamic).h as double;
  final scale = (w < h ? w : h) / 200;
  final origin = Offset((w - 200 * scale) / 2, (h - 200 * scale) / 2);
  return tester.getTopLeft(cell) + origin + const Offset(100, 100) * scale;
}

/// Nombre de cases réussies (reconnaissables à leur voile vert).
int _successCount(WidgetTester tester) => tester
    .widgetList<ColoredBox>(
      find.descendant(of: _cells, matching: find.byType(ColoredBox)),
    )
    .where((b) => b.color == const Color(0x1A8FBF6F))
    .length;

bool _done(ProgressProvider p) => p.isCompleted(
  typeEtape: 'SIGNE',
  modalite: 'EXERCICE',
  etapeCode: _pointId,
);

void main() {
  setUp(resetTestEnv);

  final configs = <(String, Lang, double, Size)>[
    (
      'français, taille par défaut, téléphone',
      Lang.fr,
      kDefaultUiScale,
      const Size(412, 915),
    ),
    (
      'arabe, taille max, petit téléphone',
      Lang.ar,
      kMaxUiScale,
      const Size(360, 640),
    ),
    (
      'français, taille min, tablette',
      Lang.fr,
      kMinUiScale,
      const Size(800, 1280),
    ),
  ];

  for (final (name, lang, uiScale, size) in configs) {
    testWidgets('le point se fait d\'un simple toucher sur le point vert '
        '($name)', (tester) async {
      final family = await launchApp(tester, size: size);
      await tester.runAsync(() => family.createChild('Awa'));
      final ctx = tester.element(find.byType(Navigator).first);
      await tester.runAsync(() async {
        await Provider.of<LanguageProvider>(ctx, listen: false).setLang(lang);
        await Provider.of<AccessibilitySettings>(
          ctx,
          listen: false,
        ).setUiScale(uiScale);
      });
      final progress = Provider.of<ProgressProvider>(ctx, listen: false);
      await tester.runAsync(progress.rechargerPourEnfantActif);
      await goTo(tester, '/exercice-liste?family=point');
      expect(_cells, findsNWidgets(3), reason: '3 répétitions par défaut');

      Future<void> wait(int ms) => tester.pump(Duration(milliseconds: ms));

      // ---- Case 1 -----------------------------------------------------
      // Un glissement parti du point (défilement de la page) n'est ni une
      // réussite ni une erreur : le toucher suivant doit marcher aussitôt.
      var p = await _dot(tester, 0);
      final g = await tester.startGesture(p);
      await g.moveBy(const Offset(0, -40));
      await wait(50);
      await g.moveBy(const Offset(0, 40));
      await g.up();
      await wait(700);
      expect(
        _successCount(tester),
        0,
        reason: 'un glissement n\'est pas un toucher',
      );

      // Toucher à 20 px du centre : dans la cible, donc réussi...
      p = await _dot(tester, 0);
      await tester.tapAt(p + const Offset(20, 0));
      await wait(700);
      expect(
        _successCount(tester),
        1,
        reason: 'toucher à 20 px : dans la cible',
      );
      // ... et la case 2 devient active : la toucher loin du point (dans
      // un coin de la case) est une erreur.
      final cell2 = tester.getTopLeft(_cells.at(1));
      await tester.tapAt(cell2 + const Offset(6, 6));
      await wait(100);
      // Pendant l'affichage du "réessaie", même un toucher exact est ignoré.
      p = await _dot(tester, 1);
      await tester.tapAt(p);
      await wait(700);
      expect(_successCount(tester), 1, reason: 'erreur, puis toucher ignoré');
      expect(_done(progress), isFalse);
      await wait(900);

      // ---- Case 2 -----------------------------------------------------
      // Une case qui n'est pas encore la case active ne réagit pas.
      p = await _dot(tester, 2);
      await tester.tapAt(p);
      await wait(700);
      expect(_successCount(tester), 1, reason: 'case 3 pas encore active');
      p = await _dot(tester, 1);
      await tester.tapAt(p);
      await wait(700);
      expect(_successCount(tester), 2);
      expect(_done(progress), isFalse, reason: 'il reste la troisième case');

      // ---- Case 3 -----------------------------------------------------
      // À 40 px du centre : hors de la cible, donc refusé.
      p = await _dot(tester, 2);
      await tester.tapAt(p + const Offset(0, 40));
      await wait(1400);
      expect(_successCount(tester), 2, reason: 'toucher hors de la cible');
      expect(_done(progress), isFalse);
      // Toucher exact : la ligne est terminée et enregistrée.
      p = await _dot(tester, 2);
      await tester.tapAt(p);
      await wait(700);
      await advance(tester, frames: 3);
      expect(_successCount(tester), 3);
      expect(_done(progress), isTrue, reason: 'les 3 points ont été touchés');
      expect(tester.takeException(), isNull);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpWidget(const SizedBox());
      await advance(tester, frames: 5);
    }, variant: mobile);
  }
}
