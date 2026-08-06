import 'package:shared_preferences/shared_preferences.dart';

const _nameKey = 'amani_profile_name';
const _passwordKey = 'amani_profile_password';
const _photoKey = 'amani_profile_photo';

/// Vérifie si un mot de passe de profil est défini.
Future<bool> isProfileProtected() async {
  final prefs = await SharedPreferences.getInstance();
  final pwd = prefs.getString(_passwordKey);
  return pwd != null && pwd.isNotEmpty;
}

/// Vérifie si le profil a été déverrouillé dans cette session.
bool _sessionUnlockedFlag = false;

bool isProfileUnlockedThisSession() => _sessionUnlockedFlag;

void markProfileUnlocked() {
  _sessionUnlockedFlag = true;
}

void lockProfile() {
  _sessionUnlockedFlag = false;
}

/// Récupère le mot de passe stocké.
Future<String?> getStoredPassword() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_passwordKey);
}

/// Enregistre le mot de passe.
Future<void> setStoredPassword(String password) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_passwordKey, password);
}

/// Récupère le nom stocké.
Future<String?> getStoredName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_nameKey);
}

/// Enregistre le nom.
Future<void> setStoredName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_nameKey, name);
}

/// Photo de profil choisie sur l'appareil, stockée en base64 (déjà
/// redimensionnée/compressée par `pickAndEncodeProfilePhoto`). Utilisée dans
/// la page des classements ("Clairière") pour représenter l'explorateur.
Future<String?> getStoredPhoto() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_photoKey);
}

Future<void> setStoredPhoto(String base64) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_photoKey, base64);
}

Future<void> removeStoredPhoto() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_photoKey);
}
