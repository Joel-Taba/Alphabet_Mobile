import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'family_service.dart';

const String _kProgressStorageKeyPrefix = 'amani_eval_progress_';

/// Chrono d'une évaluation de fin de palier — un seul contrôleur partagé
/// (via `Provider`, un seul par app) mais dont l'état est scopé à
/// [evalId] : chaque palier a son propre identifiant fixe (voir la
/// constante `_kEvalId` de chaque écran d'évaluation), de sorte que deux
/// évaluations de paliers différents ne se marchent jamais dessus, même si
/// l'enfant quitte l'une sans la terminer puis en ouvre une autre.
///
/// Chaque écran d'évaluation appelle [ensureContext] dans son `initState` :
/// si c'est la même évaluation déjà en cours (navigation vers le sujet
/// suivant du même palier), tout l'état est conservé tel quel. Sinon
/// (toute première visite, ou une AUTRE évaluation était en cours sans
/// avoir été proprement close), l'état en mémoire est réinitialisé et
/// l'écran doit alors consulter [readSavedProgress] pour proposer une
/// reprise le cas échéant, avant de lancer le chrono via [start] — jamais
/// automatiquement à l'ouverture de l'écran, mais seulement quand l'enfant
/// appuie sur "Continuer"/"Reprendre", pour que le temps annoncé dans les
/// réglages soit toujours celui réellement accordé.
class EvaluationSessionController extends ChangeNotifier {
  String? _evalId;
  DateTime? _endTime;
  Timer? _timer;
  bool _expired = false;

  // Sujets de l'évaluation en cours — pour le badge "X/Y sujets" (coin
  // supérieur droit des écrans d'évaluation) et pour retrouver le sujet
  // exact où reprendre après une sortie prématurée.
  int _subjectTotal = 0;
  int _subjectsDone = 0;
  int _currentSubjectIndex = 0;

  String? get evalId => _evalId;
  bool get isRunning => _endTime != null && !_expired;
  bool get expired => _expired;
  int get subjectTotal => _subjectTotal;
  int get subjectsDone => _subjectsDone;
  int get currentSubjectIndex => _currentSubjectIndex;

  int get remainingSeconds {
    if (_endTime == null) return 0;
    final left = _endTime!.difference(DateTime.now()).inSeconds;
    return left < 0 ? 0 : left;
  }

  /// À appeler en tout premier, dans l'`initState` de chaque écran
  /// d'évaluation. Renvoie `true` si [evalId] est déjà l'évaluation en
  /// cours (l'écran n'a rien de plus à faire : chrono et sujets faits
  /// continuent tels quels). Renvoie `false` sinon — l'état en mémoire est
  /// alors réinitialisé (au cas où une AUTRE évaluation, jamais close
  /// proprement, y était encore attachée) et l'écran doit décider quoi
  /// afficher (reprise ou annonce du premier sujet) avant d'appeler
  /// [start].
  ///
  /// Si une AUTRE évaluation était encore active (jamais close proprement),
  /// sa progression est sauvegardée ici même, avant d'écraser l'état —
  /// on ne peut pas compter sur le `dispose()` de son écran pour le faire :
  /// lors d'une navigation directe d'une évaluation à une autre, Flutter
  /// construit généralement le nouvel écran (donc appelle CET
  /// `ensureContext`) AVANT de démonter l'ancien (donc avant son
  /// `dispose()`), ce qui rendrait sinon son `persistProgress()` inopérant
  /// (il trouverait déjà ce nouvel `evalId`, ce nouveau chrono à zéro).
  bool ensureContext(String evalId) {
    if (_evalId == evalId && isRunning) return true;
    if (_evalId != null && _evalId != evalId && _endTime != null && !_expired) {
      unawaited(_persistSnapshot(_evalId!));
    }
    _timer?.cancel();
    _timer = null;
    _evalId = evalId;
    _endTime = null;
    _expired = false;
    _subjectTotal = 0;
    _subjectsDone = 0;
    _currentSubjectIndex = 0;
    return false;
  }

  /// Déclare le nombre total de sujets de cette évaluation — sans effet si
  /// déjà configuré pour l'évaluation en cours (navigation entre sujets).
  void configureSubjects(int total) {
    if (_subjectTotal != 0) return;
    _subjectTotal = total;
    notifyListeners();
  }

  /// Lance réellement le chrono, pour [durationSeconds] — à appeler
  /// uniquement quand l'enfant appuie sur "Continuer" (premier sujet) ou
  /// "Reprendre" (voir [resumeFrom]), jamais automatiquement à l'ouverture
  /// de l'écran, pour que ce soit toujours le temps actuellement réglé
  /// (relu à cet instant précis) qui s'applique.
  void start(int durationSeconds) {
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

  /// Un sujet vient d'être complété — incrémente le compteur "réalisés"
  /// (plafonné au total) et retient l'index du nouveau sujet actif, pour
  /// qu'une sauvegarde de progression ([persistProgress]) sache où reprendre.
  void advanceSubject(int newSubjectIndex) {
    if (_subjectsDone < _subjectTotal) _subjectsDone++;
    _currentSubjectIndex = newSubjectIndex;
    notifyListeners();
  }

  /// Sauvegarde immédiate de l'état actuel, pour permettre une reprise
  /// exacte plus tard — à appeler depuis le `dispose()` de chaque écran
  /// d'évaluation. Sans effet si aucune évaluation n'est active ou si elle
  /// est déjà terminée (rien à reprendre dans ce cas).
  Future<void> persistProgress() async {
    if (_evalId == null || _endTime == null || _expired) return;
    await _persistSnapshot(_evalId!);
  }

  /// Écrit l'instantané de l'évaluation [evalId] (l'état ACTUEL de ce
  /// contrôleur, supposé être encore celui de cette évaluation au moment de
  /// l'appel). Capture tout l'état nécessaire de façon synchrone AVANT le
  /// premier point d'attente : sans ça, un `ensureContext` d'un tout autre
  /// écran pourrait s'intercaler pendant l'attente de
  /// `SharedPreferences.getInstance()` et réécrire les champs de cette
  /// instance PARTAGÉE entre-temps (nouvel `evalId`, chrono remis à
  /// zéro...), ce qui persisterait alors un instantané erroné.
  Future<void> _persistSnapshot(String evalId) async {
    final key = scopeKey('$_kProgressStorageKeyPrefix$evalId');
    final snapshot = jsonEncode({
      'remainingSeconds': remainingSeconds,
      'subjectTotal': _subjectTotal,
      'subjectsDone': _subjectsDone,
      'currentSubjectIndex': _currentSubjectIndex,
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, snapshot);
  }

  /// Progression sauvegardée pour [evalId] (enfant actif), s'il y en a une
  /// — à consulter par l'écran juste après un [ensureContext] qui renvoie
  /// `false`, pour proposer une reprise plutôt que de repartir de zéro.
  Future<Map<String, dynamic>?> readSavedProgress(String evalId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(scopeKey('$_kProgressStorageKeyPrefix$evalId'));
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Efface la progression sauvegardée pour [evalId] (enfant actif) — sur
  /// choix "Recommencer", ou une fois l'évaluation menée à son terme (voir
  /// [reset]).
  Future<void> clearSavedProgress(String evalId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(scopeKey('$_kProgressStorageKeyPrefix$evalId'));
  }

  /// Restaure un état précédemment sauvegardé (voir [readSavedProgress]) et
  /// relance le chrono pour le temps qu'il restait — [saved] doit venir de
  /// [readSavedProgress], appelé juste avant sur ce même [evalId].
  void resumeFrom(Map<String, dynamic> saved) {
    _expired = false;
    _subjectTotal = saved['subjectTotal'] as int? ?? _subjectTotal;
    _subjectsDone = saved['subjectsDone'] as int? ?? 0;
    _currentSubjectIndex = saved['currentSubjectIndex'] as int? ?? 0;
    final remaining = saved['remainingSeconds'] as int? ?? 0;
    _endTime = DateTime.now().add(Duration(seconds: remaining));
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 250), (_) => _tick());
    notifyListeners();
  }

  /// À appeler quand l'enfant termine l'évaluation en cours (temps écoulé,
  /// overlay de fin) : efface aussi toute progression sauvegardée pour
  /// cette évaluation (rien à reprendre, elle est bel et bien finie), pour
  /// qu'une prochaine visite de ce même palier reparte avec un chrono neuf.
  void reset() {
    final finishedEvalId = _evalId;
    if (finishedEvalId != null) {
      unawaited(clearSavedProgress(finishedEvalId));
    }
    _timer?.cancel();
    _timer = null;
    _endTime = null;
    _expired = false;
    _subjectTotal = 0;
    _subjectsDone = 0;
    _currentSubjectIndex = 0;
    _evalId = null;
    notifyListeners();
  }

  /// Changement d'enfant actif (voir `FamilyService.switchTo`) : une
  /// évaluation en mémoire ne doit jamais "fuir" vers un autre enfant du
  /// même appareil — n'efface rien de sauvegardé (déjà isolé par enfant via
  /// `scopeKey`), coupe seulement le lien en mémoire, pour qu'un prochain
  /// [ensureContext] reparte à neuf quel que soit l'`evalId` demandé.
  void rechargerPourEnfantActif() {
    _timer?.cancel();
    _timer = null;
    _endTime = null;
    _expired = false;
    _subjectTotal = 0;
    _subjectsDone = 0;
    _currentSubjectIndex = 0;
    _evalId = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
