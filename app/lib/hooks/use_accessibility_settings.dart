import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Réglages d'accessibilité (Profil > Réglages) — volontairement au niveau
/// de l'appareil, pas par enfant (contrairement à `WritingStyleProvider`
/// ou `ExerciseSettings`) : ce sont des besoins de lecture/vision propres
/// à qui tient l'appareil au moment donné, pas une progression pédagogique.
const _dyslexiaFontKey = 'amani_setting_dyslexia_font';
const _uiScaleKey = 'amani_setting_ui_scale';

const double kMinUiScale = 0.85;
const double kMaxUiScale = 1.4;
const double kDefaultUiScale = 1.0;

class AccessibilitySettings extends ChangeNotifier {
  bool _dyslexiaFont = false;
  double _uiScale = kDefaultUiScale;
  bool _loaded = false;

  bool get isLoaded => _loaded;
  bool get dyslexiaFont => _dyslexiaFont;
  double get uiScale => _uiScale;

  AccessibilitySettings() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _dyslexiaFont = prefs.getBool(_dyslexiaFontKey) ?? false;
    _uiScale = prefs.getDouble(_uiScaleKey) ?? kDefaultUiScale;
    _loaded = true;
    notifyListeners();
  }

  Future<void> setDyslexiaFont(bool enabled) async {
    _dyslexiaFont = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dyslexiaFontKey, enabled);
  }

  Future<void> setUiScale(double scale) async {
    _uiScale = scale.clamp(kMinUiScale, kMaxUiScale);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_uiScaleKey, _uiScale);
  }
}
