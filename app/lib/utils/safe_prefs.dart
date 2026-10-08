import 'package:shared_preferences/shared_preferences.dart';

/// Lectures du stockage local qui ne plantent jamais.
///
/// `getString`/`getInt`... lèvent une exception quand la valeur enregistrée
/// n'a pas le type attendu (ex. réglage stocké autrement par une ancienne
/// version de l'app) — au démarrage, l'app planterait alors à chaque
/// ouverture. Ici, un type inattendu donne simplement `null` : l'appelant
/// retombe sur sa valeur par défaut.
extension SafePrefs on SharedPreferences {
  String? readString(String key) {
    final v = get(key);
    return v is String ? v : null;
  }

  int? readInt(String key) {
    final v = get(key);
    if (v is int) return v;
    if (v is double && v.isFinite) return v.round();
    return null;
  }

  double? readDouble(String key) {
    final v = get(key);
    if (v is double) return v.isFinite ? v : null;
    if (v is int) return v.toDouble();
    return null;
  }

  bool? readBool(String key) {
    final v = get(key);
    return v is bool ? v : null;
  }
}
