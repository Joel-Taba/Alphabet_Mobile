import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'services/family_service.dart';
import 'hooks/use_exercise_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Résout l'enfant actif (et migre l'éventuel profil unique pré-existant)
  // AVANT toute autre chose : les autres services par enfant (progression,
  // mot de passe, réglages pédagogiques...) doivent voir le bon
  // espace de nommage dès leur toute première lecture — voir
  // FamilyService.ready.
  final familyService = FamilyService();
  await familyService.ready;
  // Niveau de souplesse du tracé, lu par les cases des cours (syllabes,
  // mots) qui n'ouvrent pas elles-mêmes les réglages d'exercice.
  await ExerciseSettings().load();

  // Barre de statut transparente
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(AmaniApp(familyService: familyService));
}
