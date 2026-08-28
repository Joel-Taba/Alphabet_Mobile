import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/family_service.dart';

const String kRepetitionsStorageKey = 'amani_setting_repetitions';
const String kToleranceStorageKey = 'amani_setting_tolerance';
const String kEvaluationDurationStorageKey =
    'amani_setting_evaluation_duration';
const String kMentalCalcDurationStorageKey =
    'amani_setting_mental_calc_duration';

const int kDefaultRepetitions = 3;

/// Tolérance de validation, en points de pourcentage (pas une fraction) —
/// reflète `src/hooks/useExerciseSettings.ts`, qui stocke la même valeur
/// brute (ex. 10 pour "10%"), consommée par `RepetitionRow` via `/100`.
const int kDefaultTolerance = 10;
const int kDefaultEvaluationDuration = 5;

/// Temps accordé par problème de calcul mental en évaluation, en secondes.
const int kDefaultMentalCalcDuration = 15;

const int kMinRepetitions = 1;
const int kMaxRepetitions = 6;
const int kMinTolerance = 1;
const int kMaxTolerance = 25;
const int kMinEvaluationDuration = 2;
const int kMaxEvaluationDuration = 30;
const int kMinMentalCalcDuration = 10;
const int kMaxMentalCalcDuration = 60;

/// Réglages d'exercice partagés (Nombre de répétitions , tolérance de
/// validation, durée d'évaluation chronométrée), persistés en local —
/// reflète `src/hooks/useExerciseSettings.ts`.
class ExerciseSettings extends ChangeNotifier {
  int repetitions = kDefaultRepetitions;
  int tolerance = kDefaultTolerance;
  int evaluationDuration = kDefaultEvaluationDuration;
  int mentalCalcDuration = kDefaultMentalCalcDuration;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    repetitions =
        prefs.getInt(scopeKey(kRepetitionsStorageKey)) ?? kDefaultRepetitions;
    tolerance = prefs.getInt(scopeKey(kToleranceStorageKey)) ?? kDefaultTolerance;
    evaluationDuration =
        prefs.getInt(scopeKey(kEvaluationDurationStorageKey)) ??
        kDefaultEvaluationDuration;
    mentalCalcDuration =
        prefs.getInt(scopeKey(kMentalCalcDurationStorageKey)) ??
        kDefaultMentalCalcDuration;
    notifyListeners();
  }

  Future<void> setRepetitions(int value) async {
    repetitions = value.clamp(kMinRepetitions, kMaxRepetitions);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(scopeKey(kRepetitionsStorageKey), repetitions);
  }

  Future<void> setTolerance(int value) async {
    tolerance = value.clamp(kMinTolerance, kMaxTolerance);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(scopeKey(kToleranceStorageKey), tolerance);
  }

  Future<void> setEvaluationDuration(int value) async {
    evaluationDuration = value.clamp(
      kMinEvaluationDuration,
      kMaxEvaluationDuration,
    );
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(scopeKey(kEvaluationDurationStorageKey), evaluationDuration);
  }

  Future<void> setMentalCalcDuration(int value) async {
    mentalCalcDuration = value.clamp(
      kMinMentalCalcDuration,
      kMaxMentalCalcDuration,
    );
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      scopeKey(kMentalCalcDurationStorageKey),
      mentalCalcDuration,
    );
  }
}

/// Lecture seule de la durée d'évaluation configurée (en minutes), pour les
/// écrans qui n'ont besoin que de la consommer sans l'éditer — reflète
/// `readEvaluationDurationMinutes` côté web.
Future<int> readEvaluationDurationMinutes() async {
  final prefs = await SharedPreferences.getInstance();
  final v =
      prefs.getInt(scopeKey(kEvaluationDurationStorageKey)) ??
      kDefaultEvaluationDuration;
  return v.clamp(kMinEvaluationDuration, kMaxEvaluationDuration);
}

/// Lecture seule du temps accordé par problème de calcul mental en
/// évaluation (en secondes), pour les écrans qui n'ont besoin que de le
/// consommer sans l'éditer.
Future<int> readMentalCalcDurationSeconds() async {
  final prefs = await SharedPreferences.getInstance();
  final v =
      prefs.getInt(scopeKey(kMentalCalcDurationStorageKey)) ??
      kDefaultMentalCalcDuration;
  return v.clamp(kMinMentalCalcDuration, kMaxMentalCalcDuration);
}
