import 'package:shared_preferences/shared_preferences.dart';

/// Mot de passe d'accès à l'application **entière**, défini par l'éditeur de
/// l'app (toi), pas par l'utilisateur — à communiquer au préalable à toute
/// personne à qui tu donnes l'APK. Indépendant du mot de passe "Mon Profil"
/// de [profile_auth.dart] (qui protège seulement les réglages d'un enfant
/// déjà inscrit) : celui-ci verrouille toute l'app, avant même l'écran de
/// bienvenue.
///
/// Modifiable sans toucher au code, au moment de la compilation :
/// `flutter build apk --release --dart-define=APP_ACCESS_PASSWORD=<ton-mot-de-passe>`
/// (sinon, la valeur par défaut ci-dessous s'applique).
const String kAppAccessPassword = String.fromEnvironment(
  'APP_ACCESS_PASSWORD',
  defaultValue: 'amani2026',
);

const _unlockedKey = 'amani_app_unlocked';

/// Vrai si cet appareil a déjà saisi le bon mot de passe une fois — dans ce
/// cas, l'app ne le redemande plus jamais sur cet appareil.
Future<bool> isAppUnlocked() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_unlockedKey) ?? false;
}

Future<void> markAppUnlocked() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_unlockedKey, true);
}
