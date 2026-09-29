// Test de démarrage : l'application complète se lance sans erreur et
// affiche l'écran de bienvenue.
//
// Deux pièges évités ici, qui faisaient tourner ce test à l'infini :
// - le stockage local doit être simulé, sinon `FamilyService.ready` attend
//   une réponse native qui ne vient jamais ;
// - l'app contient des animations infinies (mascotte, étincelles...) :
//   `pumpAndSettle` n'aboutit donc jamais, on avance le temps à la main.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gentle_paths_academy/app.dart';
import 'package:gentle_paths_academy/screens/welcome_screen.dart';
import 'package:gentle_paths_academy/services/family_service.dart';

import 'helpers/app_harness.dart';
import 'helpers/test_env.dart';

void main() {
  setUp(resetTestEnv);

  testWidgets('AmaniApp démarre et affiche l\'écran de bienvenue', (
    tester,
  ) async {
    late FamilyService familyService;
    await tester.runAsync(() async {
      familyService = FamilyService();
      await familyService.ready;
    });
    await tester.pumpWidget(AmaniApp(familyService: familyService));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(WelcomeScreen), findsOneWidget);
  }, variant: mobile);
}
