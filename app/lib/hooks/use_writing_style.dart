import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/amani_theme.dart';

/// Réglage partagé du style d'écriture (Profil > Réglages > "Format
/// d'écriture"). Même clé SharedPreferences que l'ancien état local de
/// `profil_hub_screen.dart`, pour rester compatible avec ce qui est déjà
/// enregistré sur l'appareil.
enum WritingStyle { script, cursive }

const _storageKey = 'amani_setting_format';

class WritingStyleProvider extends ChangeNotifier {
  WritingStyle _style = WritingStyle.script;
  WritingStyle get style => _style;

  WritingStyleProvider() {
    setActiveFont(_style);
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_storageKey);
    for (final s in WritingStyle.values) {
      if (s.name == saved) {
        _style = s;
        setActiveFont(s);
        notifyListeners();
        break;
      }
    }
  }

  Future<void> setStyle(WritingStyle next) async {
    _style = next;
    setActiveFont(next);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, next.name);
  }
}
