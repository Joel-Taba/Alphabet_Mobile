import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _checkpointKey = 'amani_resume_checkpoint';

/// Préfixes de route considérés comme une "session" (cours, exercice ou
/// évaluation) reprenable — tout le reste (accueil, mode libre, communauté,
/// profil, plus) n'a pas de notion de progression à reprendre.
bool _isResumableLocation(String location) {
  return location.startsWith('/cours/') ||
      location.startsWith('/exercice-liste') ||
      location.startsWith('/exercice/');
}

/// Mémorise la dernière session (cours, exercice ou évaluation) en cours au
/// moment où l'app a été quittée, pour proposer de la reprendre exactement
/// là où elle a été laissée en cas de fermeture brusque — même mécanisme
/// que côté Web (localStorage).
///
/// Alimenté automatiquement par le `redirect` de GoRouter (voir `app.dart`)
/// via [onNavigate] à chaque navigation : aucun écran individuel n'a besoin
/// d'appeler ce service directement. Le point de reprise est effacé dès que
/// l'utilisateur revient volontairement à l'accueil — mais seulement après
/// que l'écran d'accueil ait eu l'occasion de proposer la reprise au tout
/// premier lancement (voir [markBootCheckDone]), pour ne pas effacer le
/// point de reprise avant même d'avoir pu le lire.
class ResumeCheckpointService extends ChangeNotifier {
  Map<String, dynamic>? _checkpoint;
  bool _bootCheckDone = false;
  late final Future<void> ready;

  ResumeCheckpointService() {
    ready = _load();
  }

  /// Route complète (chemin + paramètres de requête) de la session non
  /// terminée à proposer de reprendre, ou `null` s'il n'y en a pas.
  String? get pendingRoute => _checkpoint?['route'] as String?;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_checkpointKey);
    if (raw != null) {
      try {
        _checkpoint = jsonDecode(raw) as Map<String, dynamic>;
      } catch (_) {
        _checkpoint = null;
      }
    }
    notifyListeners();
  }

  Future<void> _save(String route) async {
    _checkpoint = {'route': route};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_checkpointKey, jsonEncode(_checkpoint));
  }

  /// Efface le point de reprise — appelé explicitement quand l'utilisateur
  /// décline la proposition de reprise, ou automatiquement quand il revient
  /// à l'accueil de son plein gré (voir [onNavigate]).
  Future<void> clear() async {
    if (_checkpoint == null) return;
    _checkpoint = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_checkpointKey);
  }

  /// À appeler une seule fois, une fois que l'écran d'accueil a fini de
  /// proposer (ou non) la reprise — sans quoi le tout premier passage par
  /// `/accueil` au lancement de l'app effacerait le point de reprise avant
  /// même d'avoir pu le lire.
  void markBootCheckDone() => _bootCheckDone = true;

  /// Point d'entrée appelé par le `redirect` global du routeur (voir
  /// `app.dart`) à chaque navigation.
  void onNavigate(String location) {
    if (location == '/accueil') {
      if (_bootCheckDone) unawaited(clear());
    } else if (_isResumableLocation(location)) {
      unawaited(_save(location));
    }
  }
}
