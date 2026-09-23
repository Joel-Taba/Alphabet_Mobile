import 'package:shared_preferences/shared_preferences.dart';
import 'family_service.dart';

const _nameKey = 'amani_profile_name';
const _passwordKey = 'amani_profile_password';
const _photoKey = 'amani_profile_photo';

/// Vérifie si un mot de passe de profil est défini.
Future<bool> isProfileProtected() async {
  final prefs = await SharedPreferences.getInstance();
  final pwd = prefs.getString(scopeKey(_passwordKey));
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

/// Récupère le mot de passe stocké (de l'enfant actif — voir [scopeKey]).
Future<String?> getStoredPassword() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(scopeKey(_passwordKey));
}

/// Enregistre le mot de passe (de l'enfant actif).
Future<void> setStoredPassword(String password) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(scopeKey(_passwordKey), password);
}

/// Récupère le nom stocké (de l'enfant actif).
Future<String?> getStoredName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(scopeKey(_nameKey));
}

/// Enregistre le nom (de l'enfant actif).
Future<void> setStoredName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(scopeKey(_nameKey), name);
}

/// Photo de profil choisie sur l'appareil, stockée en base64 (déjà
/// redimensionnée/compressée par `pickAndEncodeProfilePhoto`). Isolée par
/// enfant, comme le reste de cette classe.
Future<String?> getStoredPhoto() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(scopeKey(_photoKey));
}

Future<void> setStoredPhoto(String base64) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(scopeKey(_photoKey), base64);
}

Future<void> removeStoredPhoto() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(scopeKey(_photoKey));
}

/// Photo d'un enfant précis, quel que soit l'enfant actuellement actif —
/// contourne volontairement [scopeKey] (qui ne connaît que l'enfant actif)
/// pour permettre d'afficher la vraie photo de chaque profil dans le
/// sélecteur de fratrie (`child_switcher_sheet.dart`), plutôt que ses seules
/// initiales.
Future<String?> getStoredPhotoFor(String childId) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('${_photoKey}__$childId');
}
