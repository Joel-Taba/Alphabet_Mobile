import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Réglages d'accessibilité (Profil > Réglages) — volontairement au niveau
/// de l'appareil, pas par enfant (contrairement à `WritingStyleProvider`
/// ou `ExerciseSettings`) : ce sont des besoins de lecture/vision propres
/// à qui tient l'appareil au moment donné, pas une progression pédagogique.
const _dyslexiaFontKey = 'amani_setting_dyslexia_font';
const _uiScaleKey = 'amani_setting_ui_scale';

const double kMinUiScale = 0.85;

/// Chaque écran d'exercice qui lit ce réglage (voir [LetterTraceCell],
/// [RepetitionRow], `WordTraceAttempt`, `_LetterDrawingCanvas`, la grille de
/// `CrosswordPlay`...) borne lui-même sa taille finale à la largeur
/// réellement disponible (`LayoutBuilder`/`Wrap`) ou vit dans un
/// `InteractiveViewer` pannable (mots croisés) : on peut donc viser une
/// plage large sans risque de débordement, y compris sur tablette où l'on
/// veut des espaces de tracé aussi grands que possible.
const double kMaxUiScale = 1.8;

/// Grand par défaut (au lieu de 1.0) : l'utilisateur veut des espaces de
/// tracé bien visibles dès l'installation, tout en gardant de la marge pour
/// aggrandir encore (`kMaxUiScale`) ou réduire (`kMinUiScale`) au besoin.
const double kDefaultUiScale = 1.4;

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
    // `.clamp(...)` : une valeur enregistrée avant un ajustement de
    // `kMaxUiScale` (ex. réduit après coup) pourrait sinon dépasser les
    // bornes actuelles et casser l'assertion `value <= max` du slider.
    _uiScale = (prefs.getDouble(_uiScaleKey) ?? kDefaultUiScale).clamp(
      kMinUiScale,
      kMaxUiScale,
    );
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
