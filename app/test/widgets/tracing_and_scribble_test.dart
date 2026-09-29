import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/hooks/use_tracing_scroll_lock.dart';
import 'package:gentle_paths_academy/widgets/scribble_canvas.dart';
import 'package:provider/provider.dart';

import '../helpers/app_harness.dart';

Widget host(TracingScrollLock lock, Widget child) =>
    ChangeNotifierProvider.value(
      value: lock,
      child: MaterialApp(
        home: Scaffold(
          body: Center(child: SizedBox(width: 300, height: 300, child: child)),
        ),
      ),
    );

void main() {
  testWidgets('le verrou de défilement se libère seul quand plus rien ne '
      'touche l\'écran, même si un tracé a oublié de le relâcher', (
    tester,
  ) async {
    final lock = TracingScrollLock();
    await tester.pumpWidget(host(lock, const SizedBox.expand()));
    final gesture = await tester.startGesture(const Offset(400, 300));
    lock.start(); // un tracé démarre... et "oublie" son stop()
    expect(lock.isLocked, isTrue);
    await gesture.up();
    await tester.pump();
    expect(lock.isLocked, isFalse);
  }, variant: mobile);

  testWidgets('espace libre : 300 traits enchaînés, sans blocage', (
    tester,
  ) async {
    final lock = TracingScrollLock();
    await tester.pumpWidget(
      host(lock, const ScribbleCanvas(penColor: Colors.black)),
    );
    final center = tester.getCenter(find.byType(ScribbleCanvas));
    for (var i = 0; i < 300; i++) {
      final g = await tester.startGesture(
        center + Offset(-100, -100.0 + i % 200),
      );
      expect(
        lock.isLocked,
        isTrue,
        reason: 'la page ne défile pas pendant le tracé',
      );
      for (var k = 0; k < 8; k++) {
        await g.moveBy(const Offset(25, 3));
      }
      await g.up();
    }
    await tester.pump();
    expect(lock.isLocked, isFalse);
    expect(tester.takeException(), isNull);
  }, variant: mobile);

  testWidgets('espace libre : deux doigts dessinent en même temps', (
    tester,
  ) async {
    final lock = TracingScrollLock();
    await tester.pumpWidget(
      host(lock, const ScribbleCanvas(penColor: Colors.black)),
    );
    final c = tester.getCenter(find.byType(ScribbleCanvas));
    final f1 = await tester.startGesture(c - const Offset(80, 0), pointer: 1);
    final f2 = await tester.startGesture(c + const Offset(80, 0), pointer: 2);
    for (var k = 0; k < 10; k++) {
      await f1.moveBy(const Offset(0, 8));
      await f2.moveBy(const Offset(0, -8));
    }
    await f1.up();
    expect(lock.isLocked, isTrue, reason: 'le 2e doigt dessine encore');
    await f2.up();
    await tester.pump();
    expect(lock.isLocked, isFalse);
    expect(tester.takeException(), isNull);
  }, variant: mobile);

  testWidgets('quitter la page en plein tracé ne bloque pas le défilement', (
    tester,
  ) async {
    final lock = TracingScrollLock();
    await tester.pumpWidget(
      host(lock, const ScribbleCanvas(penColor: Colors.black)),
    );
    final g = await tester.startGesture(
      tester.getCenter(find.byType(ScribbleCanvas)),
    );
    await g.moveBy(const Offset(20, 20));
    expect(lock.isLocked, isTrue);
    await tester.pumpWidget(host(lock, const SizedBox.expand()));
    expect(lock.isLocked, isFalse);
    expect(tester.takeException(), isNull);
    await g.up();
  }, variant: mobile);

  testWidgets('souris relâchée hors de la fenêtre : le trait suivant '
      'n\'est pas bloqué', (tester) async {
    final lock = TracingScrollLock();
    await tester.pumpWidget(
      host(lock, const ScribbleCanvas(penColor: Colors.black)),
    );
    final c = tester.getCenter(find.byType(ScribbleCanvas));
    // Un premier appui dont le relâchement est "perdu".
    final lost = await tester.startGesture(c, kind: PointerDeviceKind.mouse);
    await lost.moveBy(const Offset(10, 10));
    // Nouvel appui souris : doit être accepté.
    final next = await tester.startGesture(
      c + const Offset(30, 30),
      kind: PointerDeviceKind.mouse,
      pointer: 7,
    );
    await next.moveBy(const Offset(20, 0));
    await next.up();
    await lost.up();
    await tester.pump();
    expect(lock.isLocked, isFalse);
    expect(tester.takeException(), isNull);
  }, variant: mobile);
}
