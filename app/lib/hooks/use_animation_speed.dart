import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Réglage partagé de la vitesse de l'animation de démonstration des signes
/// (Profil > Réglages > "Exercices d'écriture"), lu par les écrans qui
/// animent le tracé d'un signe/lettre/chiffre à titre de modèle
/// (cours_family_screen, cours_lettres_formation_screen) — reflète
/// `src/hooks/useAnimationSpeed.ts`.
enum AnimationSpeed { lent, normal, rapide }

const _storageKey = 'amani_setting_anim_speed';

/// Multiplicateur appliqué à la durée de base d'une animation : plus il est
/// grand, plus l'animation est rapide (durée = base / multiplicateur).
const Map<AnimationSpeed, double> _speedMultiplier = {
  AnimationSpeed.lent: 0.6,
  AnimationSpeed.normal: 1.0,
  AnimationSpeed.rapide: 2.5,
};

class AnimationSpeedProvider extends ChangeNotifier {
  AnimationSpeed _speed = AnimationSpeed.normal;
  AnimationSpeed get speed => _speed;

  AnimationSpeedProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_storageKey);
    for (final s in AnimationSpeed.values) {
      if (s.name == saved) {
        _speed = s;
        notifyListeners();
        break;
      }
    }
  }

  Future<void> setSpeed(AnimationSpeed next) async {
    _speed = next;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, next.name);
  }
}

/// Convertit une durée de base (ms) en durée effective selon la vitesse choisie.
int scaleDuration(int baseDurationMs, AnimationSpeed speed) {
  return (baseDurationMs / _speedMultiplier[speed]!).round();
}
