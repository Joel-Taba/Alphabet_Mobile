import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/family_service.dart';
import '../utils/safe_prefs.dart';

const String kRepetitionsStorageKey = 'amani_setting_repetitions';

/// Niveau de souplesse du tracé (1 à 10). Nouvelle clé : l'ancienne
/// (`amani_setting_tolerance`) stockait un pourcentage (1-25), qu'il ne faut
/// pas relire comme un niveau.
const String kToleranceStorageKey = 'amani_setting_tolerance_level';
const String kEvaluationDurationStorageKey =
    'amani_setting_evaluation_duration';

const int kDefaultRepetitions = 3;

/// Souplesse du tracé, affichée comme un simple chiffre de 1 (exigeant) à 10
/// (très souple). Elle n'élargit que le couloir autour du modèle : le sens du
/// tracé, le point de départ et le point d'arrivée restent aussi exigeants à
/// tous les niveaux (voir `anchorTolerancePx` dans `validateTrace`).
const int kDefaultTolerance = 5;
const int kDefaultEvaluationDuration = 5;

const int kMinRepetitions = 1;
const int kMaxRepetitions = 20;
const int kMinTolerance = 1;
const int kMaxTolerance = 10;

/// Largeur du couloir pour un niveau, en % du repère SVG 200×200 (consommée
/// par `RepetitionRow` via `/100`) : niveau 1 = 10 % (l'ancien réglage par
/// défaut), niveau 5 = 18 %, niveau 10 = 28 %.
int tolerancePctForLevel(int level) =>
    8 + 2 * level.clamp(kMinTolerance, kMaxTolerance);

/// Dernier niveau lu ou choisi, pour les cases de tracé qui n'ont pas accès
/// aux réglages de leur écran (syllabes, mots — voir `LetterTraceCell`).
final ValueNotifier<int> toleranceLevelNotifier = ValueNotifier(
  kDefaultTolerance,
);
const int kMinEvaluationDuration = 2;
const int kMaxEvaluationDuration = 30;

/// Réglages d'exercice partagés (Nombre de répétitions , tolérance de
/// validation, durée d'évaluation chronométrée), persistés en local —
/// reflète `src/hooks/useExerciseSettings.ts`.
class ExerciseSettings extends ChangeNotifier {
  int repetitions = kDefaultRepetitions;
  int tolerance = kDefaultTolerance;
  int evaluationDuration = kDefaultEvaluationDuration;

  int get tolerancePct => tolerancePctForLevel(tolerance);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    // Bornés : une valeur hors plage (stockage abîmé) donnerait sinon un
    // exercice vide (0 répétition) ou des milliers de cases.
    repetitions =
        (prefs.readInt(scopeKey(kRepetitionsStorageKey)) ?? kDefaultRepetitions)
            .clamp(kMinRepetitions, kMaxRepetitions);
    tolerance =
        (prefs.readInt(scopeKey(kToleranceStorageKey)) ?? kDefaultTolerance)
            .clamp(kMinTolerance, kMaxTolerance);
    toleranceLevelNotifier.value = tolerance;
    evaluationDuration =
        (prefs.readInt(scopeKey(kEvaluationDurationStorageKey)) ??
                kDefaultEvaluationDuration)
            .clamp(kMinEvaluationDuration, kMaxEvaluationDuration);
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
    toleranceLevelNotifier.value = tolerance;
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
    await prefs.setInt(
      scopeKey(kEvaluationDurationStorageKey),
      evaluationDuration,
    );
  }
}

/// Lecture seule de la durée d'évaluation configurée (en minutes), pour les
/// écrans qui n'ont besoin que de la consommer sans l'éditer — reflète
/// `readEvaluationDurationMinutes` côté web.
Future<int> readEvaluationDurationMinutes() async {
  final prefs = await SharedPreferences.getInstance();
  final v =
      prefs.readInt(scopeKey(kEvaluationDurationStorageKey)) ??
      kDefaultEvaluationDuration;
  return v.clamp(kMinEvaluationDuration, kMaxEvaluationDuration);
}
