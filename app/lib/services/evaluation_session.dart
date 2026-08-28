import 'dart:async';
import 'package:flutter/foundation.dart';

/// Chrono unique pour toute une évaluation de fin de palier — partagé (via
/// `Provider`, un seul par app, pas recréé par écran) car une évaluation
/// enchaîne plusieurs écrans d'exercice (un par sujet du palier, chacun
/// naviguant vers le suivant avec `?amaniEval=1`), et le temps imparti doit
/// courir pour l'évaluation entière, pas se réinitialiser à chaque nouveau
/// sujet. Chaque écran appelle [startIfNeeded] dans son `initState` : le
/// premier sujet lance le chrono, les suivants le retrouvent déjà en cours
/// et n'en relancent pas un nouveau.
class EvaluationSessionController extends ChangeNotifier {
  DateTime? _endTime;
  Timer? _timer;
  bool _expired = false;

  // Sujets de l'évaluation en cours — pour le badge "X/Y sujets" (coin
  // supérieur droit des écrans d'évaluation) et pour ne montrer l'annonce
  // "Premier sujet" qu'une seule fois par session (voir `configureSubjects`).
  int _subjectTotal = 0;
  int _subjectsDone = 0;

  bool get isRunning => _endTime != null && !_expired;
  bool get expired => _expired;
  int get subjectTotal => _subjectTotal;
  int get subjectsDone => _subjectsDone;

  /// Déclare le nombre total de sujets de cette évaluation — appelé par
  /// chaque écran de sujet en mode évaluation, mais sans effet après le
  /// premier appel de la session (même principe que [startIfNeeded]) :
  /// c'est ce qui permet de distinguer "on vient d'entrer dans
  /// l'évaluation" (premier sujet, à annoncer) de "on est déjà en cours".
  bool configureSubjects(int total) {
    if (_subjectTotal != 0) return false;
    _subjectTotal = total;
    notifyListeners();
    return true;
  }

  /// Un sujet vient d'être complété — incrémente le compteur "réalisés",
  /// plafonné au total (une évaluation qui boucle au-delà du dernier sujet,
  /// le temps n'étant pas encore écoulé, n'affiche jamais plus que le
  /// total).
  void advanceSubject() {
    if (_subjectsDone < _subjectTotal) _subjectsDone++;
    notifyListeners();
  }

  int get remainingSeconds {
    if (_endTime == null) return 0;
    final left = _endTime!.difference(DateTime.now()).inSeconds;
    return left < 0 ? 0 : left;
  }

  void startIfNeeded(int durationSeconds) {
    if (_endTime != null) return;
    _expired = false;
    _endTime = DateTime.now().add(Duration(seconds: durationSeconds));
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 250), (_) => _tick());
    notifyListeners();
  }

  void _tick() {
    if (_endTime == null) return;
    final left = _endTime!.difference(DateTime.now()).inSeconds;
    if (left <= 0 && !_expired) {
      _expired = true;
      _timer?.cancel();
    }
    notifyListeners();
  }

  /// À appeler quand l'enfant quitte l'évaluation (overlay de fin, bouton ou
  /// délai automatique) pour qu'une prochaine évaluation reparte avec un
  /// chrono neuf plutôt que de retrouver celui-ci déjà expiré.
  void reset() {
    _timer?.cancel();
    _timer = null;
    _endTime = null;
    _expired = false;
    _subjectTotal = 0;
    _subjectsDone = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
