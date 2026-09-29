import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/app.dart';
import 'package:gentle_paths_academy/data/shape_calc_problem.dart';
import 'package:gentle_paths_academy/data/shape_catalog.dart';
import 'package:gentle_paths_academy/screens/parcours_screen.dart';
import 'package:gentle_paths_academy/screens/welcome_screen.dart';
import 'package:gentle_paths_academy/services/family_service.dart';
import 'package:gentle_paths_academy/services/progress_service.dart';
import 'package:gentle_paths_academy/widgets/exercise_complete_popup.dart';
import 'package:gentle_paths_academy/widgets/shape_answer_keypad.dart';
import 'package:provider/provider.dart';

import '../helpers/app_harness.dart';
import '../helpers/test_env.dart';

ProgressProvider progressOf(WidgetTester tester) =>
    Provider.of<ProgressProvider>(
      tester.element(find.byType(Navigator).first),
      listen: false,
    );

/// Tape [answer] sur le clavier de la calculette puis valide.
Future<void> typeAnswer(WidgetTester tester, int answer) async {
  final keypad = find.byType(ShapeAnswerKeypad);
  await tester.ensureVisible(keypad);
  await advance(tester, frames: 2);
  for (final digit in '$answer'.split('')) {
    await tester.tap(
      // La touche (et non l'écran de la calculette, qui affiche aussi des
      // chiffres) : les touches viennent après l'écran.
      find.descendant(of: keypad, matching: find.text(digit)).last,
    );
    await tester.pump(const Duration(milliseconds: 120));
  }
  await tester.tap(
    find.descendant(of: keypad, matching: find.byIcon(Icons.check_rounded)),
  );
  await advance(tester, frames: 10);
}

/// Réponse du problème généré à l'ouverture de l'exercice de la figure
/// [shapeId] (même graine que l'écran).
int expectedAnswer(String shapeId) {
  final topic = findShapeTopic(shapeId)!;
  return generateShapeCalcProblem(topic, topic.id.hashCode ^ 0).answer;
}

void main() {
  setUp(resetTestEnv);

  testWidgets('inscription : de l\'écran de bienvenue au parcours', (
    tester,
  ) async {
    final family = await launchApp(tester);
    expect(find.byType(WelcomeScreen), findsOneWidget);

    await tester.tap(find.text('Commencer l\'aventure'));
    await advance(tester);
    await tester.enterText(find.byType(TextField).at(0), 'Awa');
    await tester.enterText(find.byType(TextField).at(1), '1234');
    await advance(tester, frames: 2);
    await tester.tap(find.text('Commencer l\'aventure').last);
    await advance(tester, frames: 20);

    expect(family.hasAnyChild, isTrue);
    expect(family.activeChild?.nom, 'Awa');
    expect(find.byType(ParcoursScreen), findsOneWidget);
    expect(
      progressOf(tester).stats.totalPoints,
      0,
      reason: 'un nouvel enfant n\'a encore rien réalisé',
    );
  }, variant: mobile);

  testWidgets('cours puis exercice du carré : l\'étape est validée, et la '
      'page ne se "débloque" pas toute seule ensuite', (tester) async {
    final family = await launchApp(tester);
    await tester.runAsync(() => family.createChild('Awa'));
    await goTo(tester, '/accueil');
    final progress = progressOf(tester);
    await tester.runAsync(progress.rechargerPourEnfantActif);

    await goTo(tester, '/cours/figure/carre');
    expect(
      progress.isCompleted(
        typeEtape: 'FIGURE',
        modalite: 'COURS',
        etapeCode: 'carre',
      ),
      isTrue,
    );
    expect(
      progress.isTopicExercised('FIGURE', 'carre'),
      isFalse,
      reason: 'le cours seul ne valide pas l\'exercice',
    );

    await goTo(tester, '/exercice/figure/carre', push: true);
    // Une mauvaise réponse ne valide rien.
    await typeAnswer(tester, expectedAnswer('carre') + 1);
    expect(progress.isTopicExercised('FIGURE', 'carre'), isFalse);
    await advance(tester, frames: 12);
    // La bonne réponse valide l'exercice.
    await typeAnswer(tester, expectedAnswer('carre'));
    expect(progress.isTopicExercised('FIGURE', 'carre'), isTrue);
    expect(find.byType(ExerciseCompletePopup), findsOneWidget);

    // On reste sur la page plusieurs secondes : rien ne doit se remettre à
    // zéro ni se "débloquer" tout seul.
    await advance(tester, frames: 40);
    expect(find.byType(ExerciseCompletePopup), findsOneWidget);
    expect(
      find.byType(ShapeAnswerKeypad),
      findsNothing,
      reason: 'l\'exercice réussi ne doit pas redevenir "à faire"',
    );
    expect(tester.takeException(), isNull);
  }, variant: mobile);

  testWidgets('une évaluation ne coche aucune étape du parcours', (
    tester,
  ) async {
    final family = await launchApp(tester);
    await tester.runAsync(() => family.createChild('Awa'));
    await goTo(tester, '/accueil');
    final progress = progressOf(tester);
    await tester.runAsync(progress.rechargerPourEnfantActif);

    await goTo(tester, '/exercice/figure/carre?amaniEval=1');
    // Annonce du premier sujet de l'évaluation.
    await tester.tap(find.text('Commencer').last);
    await advance(tester);
    await typeAnswer(tester, expectedAnswer('carre'));
    expect(progress.isTopicExercised('FIGURE', 'carre'), isFalse);
    expect(progress.stats.totalPoints, 0);
  }, variant: mobile);

  testWidgets('fermer puis rouvrir l\'app : on revient directement au '
      'parcours, avec sa progression', (tester) async {
    final family = await launchApp(tester);
    await tester.runAsync(() => family.createChild('Awa'));
    await goTo(tester, '/accueil');
    final progress = progressOf(tester);
    await tester.runAsync(progress.rechargerPourEnfantActif);
    await goTo(tester, '/cours/figure/carre');
    await goTo(tester, '/exercice/figure/carre', push: true);
    await typeAnswer(tester, expectedAnswer('carre'));
    final points = progress.stats.totalPoints;
    expect(points, greaterThan(0));
    // L'app passe en arrière-plan puis est fermée.
    progress.flushPendingWritesForTest();
    await tester.runAsync(settle);
    await tester.pumpWidget(const SizedBox());
    await advance(tester, frames: 3);

    // Réouverture : nouvelle instance complète de l'app, même stockage.
    late FamilyService reopened;
    await tester.runAsync(() async {
      reopened = FamilyService();
      await reopened.ready;
    });
    await tester.pumpWidget(AmaniApp(familyService: reopened));
    // Une vraie relance repart de la page de départ "/" (le routeur de test,
    // lui, est partagé par tout le processus et garde la dernière page).
    await goTo(tester, '/');
    await advance(tester, frames: 15);
    expect(
      find.byType(WelcomeScreen),
      findsNothing,
      reason: 'un enfant existe déjà : pas de retour à l\'accueil',
    );
    expect(find.byType(ParcoursScreen), findsOneWidget);
    final after = progressOf(tester);
    expect(after.stats.totalPoints, points);
    expect(after.isTopicExercised('FIGURE', 'carre'), isTrue);
  }, variant: mobile);
}
