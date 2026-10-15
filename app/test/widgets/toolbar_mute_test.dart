import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/i18n/translations.dart';
import 'package:gentle_paths_academy/services/sign_speech.dart';
import 'package:gentle_paths_academy/widgets/trace_controls_toolbar.dart';
import 'package:provider/provider.dart';

import '../helpers/app_harness.dart';
import '../helpers/test_env.dart';

const _shot = String.fromEnvironment('SHOT');

void main() {
  setUp(resetTestEnv);

  testWidgets('menu du cours toujours déroulé, bouton muet persistant', (
    tester,
  ) async {
    final family = await launchApp(tester);
    await tester.runAsync(() => family.createChild('Awa'));
    var spoken = 0;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter_tts'), (
          call,
        ) async {
          if (call.method == 'speak') spoken++;
          return 1;
        });
    await goTo(tester, '/cours/trait');
    await advance(tester, frames: 12);

    // Toutes les actions sont visibles sans rien toucher, sans flèche.
    final toolbar = find.byType(TraceControlsToolbar);
    expect(toolbar, findsOneWidget);
    expect(
      find.descendant(of: toolbar, matching: find.bySemanticsLabel('Consigne')),
      findsOneWidget,
    );
    final mute = find.descendant(
      of: toolbar,
      matching: find.byType(SvgPicture),
    );
    expect(mute, findsOneWidget);

    final ctx = tester.element(toolbar);
    final speech = Provider.of<SignSpeechService>(ctx, listen: false);
    expect(speech.muted, isFalse);
    await tester.runAsync(() => speech.speak('bonjour', Lang.fr));
    expect(spoken, greaterThan(0), reason: 'la voix marche avant le muet');

    await tester.tap(mute);
    await advance(tester, frames: 3);
    expect(speech.muted, isTrue);
    spoken = 0;
    await tester.runAsync(() => speech.speak('bonjour', Lang.fr));
    await tester.tap(
      find.descendant(of: toolbar, matching: find.bySemanticsLabel('Consigne')),
    );
    await advance(tester, frames: 3);
    expect(spoken, 0, reason: 'aucune voix tant que le muet est actif');

    // Reste actif sur une autre page...
    await goTo(tester, '/cours/lettres/formation/a');
    await advance(tester, frames: 12);
    expect(spoken, 0);
    expect(find.byType(TraceControlsToolbar), findsOneWidget);
    if (_shot.isNotEmpty) {
      final ro =
          tester.renderObject(find.byType(RepaintBoundary).first)
              as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final img = await ro.toImage(pixelRatio: 1);
        final d = await img.toByteData(format: ui.ImageByteFormat.png);
        File(_shot).writeAsBytesSync(d!.buffer.asUint8List());
      });
    }
    // ... et après fermeture/réouverture de l'app.
    late SignSpeechService reopened;
    await tester.runAsync(() async {
      reopened = SignSpeechService();
      await settle();
    });
    expect(reopened.muted, isTrue);

    // L'utilisateur le désactive lui-même : la voix revient.
    await tester.tap(
      find.descendant(
        of: find.byType(TraceControlsToolbar),
        matching: find.byType(SvgPicture),
      ),
    );
    await advance(tester, frames: 3);
    expect(speech.muted, isFalse);
    await tester.runAsync(() => speech.speak('bonjour', Lang.fr));
    expect(spoken, greaterThan(0));
    reopened.dispose();
    await tester.pumpWidget(const SizedBox());
    await advance(tester, frames: 20);
  }, variant: mobile);
}
