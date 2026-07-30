import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kRepetitionsStorageKey = 'amani_setting_repetitions';
const String kToleranceStorageKey = 'amani_setting_tolerance';

const int kDefaultRepetitions = 3;
const double kDefaultTolerance = 0.10;

/// Réglages d'exercice partagés (répétitions par signe, tolérance de
/// validation), persistés en local — reflète `src/hooks/useExerciseSettings.ts`.
class ExerciseSettings extends ChangeNotifier {
  int repetitions = kDefaultRepetitions;
  double tolerance = kDefaultTolerance;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    repetitions = prefs.getInt(kRepetitionsStorageKey) ?? kDefaultRepetitions;
    tolerance = prefs.getDouble(kToleranceStorageKey) ?? kDefaultTolerance;
    notifyListeners();
  }

  Future<void> setRepetitions(int value) async {
    repetitions = value.clamp(1, 5);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kRepetitionsStorageKey, repetitions);
  }

  Future<void> setTolerance(double value) async {
    tolerance = value.clamp(0.05, 0.30);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(kToleranceStorageKey, tolerance);
  }
}
