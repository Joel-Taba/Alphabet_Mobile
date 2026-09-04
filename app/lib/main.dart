import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'screens/app_lock_screen.dart';
import 'services/app_lock_service.dart';
import 'services/family_service.dart';
import 'theme/amani_theme.dart';

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

  runApp(AppLockGate(familyService: familyService));
}

/// Verrou d'accès à toute l'application (voir `app_lock_service.dart`) :
/// affiché avant même l'écran de bienvenue tant que cet appareil n'a jamais
/// saisi le bon mot de passe. Volontairement en dehors de [AmaniApp] (donc
/// de son arbre de providers) pour rester un simple `MaterialApp` minimal
/// tant que verrouillé — la vraie application, avec tous ses services, n'est
/// construite qu'une fois déverrouillé.
class AppLockGate extends StatefulWidget {
  final FamilyService familyService;

  const AppLockGate({super.key, required this.familyService});

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate> {
  bool? _unlocked;

  @override
  void initState() {
    super.initState();
    isAppUnlocked().then((unlocked) {
      if (mounted) setState(() => _unlocked = unlocked);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_unlocked == true) {
      return AmaniApp(familyService: widget.familyService);
    }
    return MaterialApp(
      title: 'Gentle Paths Academy',
      theme: AmaniTheme.light,
      debugShowCheckedModeBanner: false,
      home: _unlocked == null
          ? const Scaffold(
              backgroundColor: AmaniColors.background,
              body: SizedBox.shrink(),
            )
          : AppLockScreen(
              onUnlocked: () => setState(() => _unlocked = true),
            ),
    );
  }
}
