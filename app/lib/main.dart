import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'services/family_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Résout l'enfant actif (et migre l'éventuel profil unique pré-existant)
  // AVANT toute autre chose : les autres services par enfant (progression,
  // mot de passe, réglages pédagogiques...) doivent voir le bon
  // espace de nommage dès leur toute première lecture — voir
  // FamilyService.ready.
  final familyService = FamilyService();
  await familyService.ready;

  // Forcer l'orientation portrait (recommandé pour cette appli éducative)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Barre de statut transparente
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(AmaniApp(familyService: familyService));
}
