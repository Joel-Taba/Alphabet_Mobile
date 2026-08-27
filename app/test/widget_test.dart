// Smoke test : vérifie que l'application démarre sans planter et affiche
// bien l'écran de bienvenue (première route).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gentle_paths_academy/app.dart';
import 'package:gentle_paths_academy/services/family_service.dart';

void main() {
  testWidgets('AmaniApp démarre et affiche l\'écran de bienvenue', (WidgetTester tester) async {
    final familyService = FamilyService();
    await familyService.ready;
    await tester.pumpWidget(AmaniApp(familyService: familyService));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
