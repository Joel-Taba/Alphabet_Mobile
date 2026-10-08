import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/hooks/use_accessibility_settings.dart';
import 'package:gentle_paths_academy/hooks/use_writing_style.dart';
import 'package:gentle_paths_academy/i18n/translations.dart';
import 'package:gentle_paths_academy/utils/trace_validation.dart';
import 'package:gentle_paths_academy/widgets/letter_trace_cell.dart';
import 'package:provider/provider.dart';

import '../helpers/app_harness.dart';
import '../helpers/test_env.dart';

final _active = find.byWidgetPredicate(
  (w) => w is LetterTraceCell && w.isActive && !w.given,
);

/// Trace au doigt, dans la case de lettre active, chaque signe de la lettre
/// tel qu'il est dessiné à l'écran (repère 200×200 mis à l'échelle de la
/// case).
Future<String> _traceActiveLetter(WidgetTester tester) async {
  final cell = _active.first;
  await tester.ensureVisible(cell);
  await tester.pump();
  final widget = tester.widget<LetterTraceCell>(cell);
  final topLeft = tester.getTopLeft(cell);
  final scale = widget.size / 200;
  for (final step in widget.letter['steps'] as List) {
    final pts = [
      for (final p in sampleSvgPath(step['pathD'] as String, 50))
        topLeft + p * scale,
    ];
    final g = await tester.startGesture(pts.first);
    for (final p in pts.skip(1)) {
      await g.moveTo(p);
      await tester.pump(const Duration(milliseconds: 8));
    }
    await g.up();
    await tester.pump(const Duration(milliseconds: 500));
  }
  // En cursive, la case suivante ne s'active qu'après l'animation de
  // rapprochement des lettres liées.
  await advance(tester, frames: 12);
  return widget.letter['char'] as String;
}

void main() {
  setUp(resetTestEnv);

  final configs = <(String, Lang, double, WritingStyle)>[
    ('français, script, taille par défaut', Lang.fr, kDefaultUiScale,
        WritingStyle.script),
    ('arabe, cursive, taille max', Lang.ar, kMaxUiScale, WritingStyle.cursive),
    ('anglais, script, taille min', Lang.en, kMinUiScale, WritingStyle.script),
  ];

  for (final (name, lang, uiScale, style) in configs) {
    testWidgets('les lettres d\'une syllabe tracées au doigt sont validées '
        '($name)', (tester) async {
      final family = await launchApp(tester, size: const Size(360, 640));
      await tester.runAsync(() => family.createChild('Awa'));
      final ctx = tester.element(find.byType(Navigator).first);
      await tester.runAsync(() async {
        await Provider.of<LanguageProvider>(ctx, listen: false).setLang(lang);
        await Provider.of<AccessibilitySettings>(
          ctx,
          listen: false,
        ).setUiScale(uiScale);
        await Provider.of<WritingStyleProvider>(
          ctx,
          listen: false,
        ).setStyle(style);
      });
      await goTo(tester, '/exercice/syllabes/b');

      expect(_active, findsWidgets, reason: 'aucune case de lettre active');
      // La case active ne passe à la lettre suivante que si la précédente a
      // été validée : "b" puis "a" (syllabe "ba"), puis le "b" de la
      // répétition suivante.
      final traced = [
        for (var i = 0; i < 3; i++) await _traceActiveLetter(tester),
      ];
      expect(traced, ['b', 'a', 'b']);
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpWidget(const SizedBox());
      await advance(tester, frames: 5);
    }, variant: mobile);
  }

  testWidgets('changer de style d\'écriture pendant que la page est ouverte : '
      'la lettre affichée (nouveau style) est bien celle attendue', (
    tester,
  ) async {
    final family = await launchApp(tester, size: const Size(360, 640));
    await tester.runAsync(() => family.createChild('Awa'));
    await goTo(tester, '/accueil');
    await goTo(tester, '/exercice/syllabes/b');
    final ctx = tester.element(find.byType(Navigator).first);
    for (final style in [WritingStyle.cursive, WritingStyle.script]) {
      await tester.runAsync(
        () => Provider.of<WritingStyleProvider>(
          ctx,
          listen: false,
        ).setStyle(style),
      );
      await advance(tester, frames: 4);
    }
    // Revenu en script puis repassé en cursive : la case doit valider le
    // tracé de la lettre telle qu'elle est maintenant dessinée.
    await tester.runAsync(
      () => Provider.of<WritingStyleProvider>(
        ctx,
        listen: false,
      ).setStyle(WritingStyle.cursive),
    );
    await advance(tester, frames: 4);
    final traced = [
      for (var i = 0; i < 2; i++) await _traceActiveLetter(tester),
    ];
    expect(traced, ['b', 'a'], reason: 'le "b" cursif tracé n\'a pas été validé');
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpWidget(const SizedBox());
    await advance(tester, frames: 5);
  }, variant: mobile);
}
