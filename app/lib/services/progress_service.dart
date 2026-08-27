import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'backend_sync_service.dart';
import 'family_service.dart';

/// Système de points local — port fidèle de `src/lib/progress.ts`. Les noms
/// et la forme des données (typeEtape, modalite, palier, etapeCode) sont
/// volontairement calqués sur `com.methode.progression` (back-end Spring)
/// pour que le remplacement de ce service par de vrais appels API, plus
/// tard, soit une substitution mécanique plutôt qu'une réécriture.
///
/// Barème : un cours (découverte guidée) rapporte moins qu'un exercice
/// (pratique active), pour valoriser l'effort. Ces points alimentent aussi
/// bien "Mon Profil" (statistiques) que "La Clairière" (classement).
const Map<String, int> pointsParModalite = {'COURS': 5, 'EXERCICE': 10};

const _progressStorageKey = 'amani_progress_log';
const _bonusStorageKey = 'amani_progress_bonus_points';
const _viewedStoragePrefix = 'amani_cours_viewed_';
const _restartBonusMin = 1;
const _restartBonusMax = 2;

class ProgressStats {
  final int totalPoints;
  final int signesMaitrises;
  final int coursTermines;
  final int exercicesReussis;
  final int joursAventure;

  const ProgressStats({
    this.totalPoints = 0,
    this.signesMaitrises = 0,
    this.coursTermines = 0,
    this.exercicesReussis = 0,
    this.joursAventure = 0,
  });
}

class AwardResult {
  final int pointsAwarded;
  final bool alreadyCompleted;
  const AwardResult({
    required this.pointsAwarded,
    required this.alreadyCompleted,
  });
}

/// Journalise la réussite d'une étape (typeEtape, modalite, etapeCode,
/// palier, points, dateReussite ISO8601).
class _EtapeReussie {
  final String typeEtape;
  final String modalite;
  final String etapeCode;
  final int palier;
  final int points;
  final String dateReussite;
  /// `true` une fois que [BackendSyncService.pushProgression] a confirmé la
  /// journalisation côté serveur — voir [ProgressProvider.syncPendingProgression],
  /// qui ré-essaie toutes les entrées encore à `false` (ex. journalisées
  /// hors-ligne) à chaque lancement de l'app et à chaque visite de "Mon Profil".
  bool synced;

  _EtapeReussie({
    required this.typeEtape,
    required this.modalite,
    required this.etapeCode,
    required this.palier,
    required this.points,
    required this.dateReussite,
    this.synced = false,
  });

  Map<String, dynamic> toJson() => {
    'typeEtape': typeEtape,
    'modalite': modalite,
    'etapeCode': etapeCode,
    'palier': palier,
    'points': points,
    'dateReussite': dateReussite,
    'synced': synced,
  };

  // `synced` est absent des journaux écrits avant l'introduction de ce champ :
  // on suppose alors `false` (non synchronisé) plutôt que de perdre ces
  // entrées — un ré-envoi d'une étape déjà connue du serveur est sans danger
  // (contrainte d'unicité côté back-end, voir `ProgressionServiceImpl`).
  factory _EtapeReussie.fromJson(Map<String, dynamic> json) => _EtapeReussie(
    typeEtape: json['typeEtape'] as String,
    modalite: json['modalite'] as String,
    etapeCode: json['etapeCode'] as String,
    palier: json['palier'] as int,
    points: json['points'] as int,
    dateReussite: json['dateReussite'] as String,
    synced: json['synced'] as bool? ?? false,
  );
}

/// Fournit le système de points à toute l'application (voir MultiProvider
/// dans app.dart). Persisté via SharedPreferences, rechargé au démarrage.
class ProgressProvider extends ChangeNotifier {
  final BackendSyncService _backend;
  List<_EtapeReussie> _log = [];
  int _bonusTotal = 0;
  bool _loaded = false;
  final Random _random = Random();

  // Dernières statistiques renvoyées par `GET /api/v1/progressions/moi`
  // (voir `refreshFromBackend`) : source de vérité lorsqu'elles sont
  // disponibles, le calcul local ci-dessous ne servant plus alors que de
  // repli hors-ligne (voir `stats`).
  int? _backendSignesMaitrises;
  int? _backendCoursTermines;
  int? _backendExercicesReussis;
  int? _backendJoursAventure;

  /// Dernier nombre de points gagnés, pour un éventuel popup "+N" côté UI —
  /// incrémenté à chaque appel pour que les widgets à l'écoute détectent un
  /// nouvel évènement même si la valeur des points est identique à la précédente.
  int lastPointsAwarded = 0;
  int _awardSequence = 0;
  int get awardSequence => _awardSequence;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _syncing = false;

  ProgressProvider(this._backend) {
    _load();
    // Rattrapage "temps réel" : dès que la connexion revient en cours de
    // session (pas seulement au lancement de l'app ou à la visite de "Mon
    // Profil"), on retente aussitôt toute progression restée locale.
    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((r) => r != ConnectivityResult.none)) {
        unawaited(syncPendingProgression());
      }
    });
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(scopeKey(_progressStorageKey));
    if (raw != null) {
      try {
        final parsed = jsonDecode(raw) as List<dynamic>;
        _log = parsed
            .map((e) => _EtapeReussie.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        _log = [];
      }
    } else {
      _log = [];
    }
    _bonusTotal = prefs.getInt(scopeKey(_bonusStorageKey)) ?? 0;
    _backendSignesMaitrises = null;
    _backendCoursTermines = null;
    _backendExercicesReussis = null;
    _backendJoursAventure = null;
    _loaded = true;
    notifyListeners();
    // Rattrapage au lancement de l'app : toute progression réussie hors-ligne
    // lors d'une session précédente (jamais confirmée synchronisée) est
    // ré-essayée dès qu'une connexion est à nouveau disponible.
    unawaited(syncPendingProgression());
  }

  /// À appeler après [FamilyService.switchTo] : recharge entièrement l'état
  /// (journal, bonus, statistiques serveur mises en cache) depuis les clés
  /// namespacées du nouvel enfant actif — sans ça, l'écran afficherait
  /// encore la progression de l'enfant précédent jusqu'au prochain
  /// redémarrage de l'app.
  Future<void> rechargerPourEnfantActif() => _load();

  Future<void> _writeLog() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      scopeKey(_progressStorageKey),
      jsonEncode(_log.map((e) => e.toJson()).toList()),
    );
    notifyListeners();
  }

  Future<void> _writeBonus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(scopeKey(_bonusStorageKey), _bonusTotal);
    notifyListeners();
  }

  void _signalPointsAwarded(int points) {
    lastPointsAwarded = points;
    _awardSequence++;
  }

  /// Journalise la réussite d'une étape (cours ou exercice) et attribue ses
  /// points, une seule fois par (typeEtape, modalite, etapeCode) — rejouer
  /// la même étape ne rapporte rien de plus.
  Future<AwardResult> awardCompletion({
    required String typeEtape,
    required String modalite,
    required String etapeCode,
    required int palier,
  }) async {
    final dejaEnregistre = _log.any(
      (e) =>
          e.typeEtape == typeEtape &&
          e.modalite == modalite &&
          e.etapeCode == etapeCode,
    );
    if (dejaEnregistre) {
      return const AwardResult(pointsAwarded: 0, alreadyCompleted: true);
    }

    final points = pointsParModalite[modalite] ?? 0;
    final etape = _EtapeReussie(
      typeEtape: typeEtape,
      modalite: modalite,
      etapeCode: etapeCode,
      palier: palier,
      points: points,
      dateReussite: DateTime.now().toIso8601String(),
    );
    _log.add(etape);
    await _writeLog();
    _signalPointsAwarded(points);
    unawaited(_pushAndMarkSynced(etape));
    return AwardResult(pointsAwarded: points, alreadyCompleted: false);
  }

  /// Tente de synchroniser une étape tout juste journalisée et marque
  /// l'entrée correspondante comme `synced` en cas de succès. En cas
  /// d'échec (hors-ligne...), l'entrée reste `synced: false` et sera
  /// reprise par [syncPendingProgression].
  Future<void> _pushAndMarkSynced(_EtapeReussie etape) async {
    final ok = await _backend.pushProgression(
      typeEtape: etape.typeEtape,
      modalite: etape.modalite,
      etapeCode: etape.etapeCode,
      palier: etape.palier,
    );
    if (ok) {
      etape.synced = true;
      await _writeLog();
    }
  }

  /// Ré-essaie de pousser côté serveur toute étape journalisée localement
  /// mais jamais confirmée synchronisée (ex. réussie hors-ligne) — c'est le
  /// "rattrapage" qui garantit qu'aucune progression n'est perdue une fois la
  /// connexion retrouvée, même si l'app n'a pas été relancée entre-temps.
  /// Appelé au démarrage de l'app et à chaque ouverture de "Mon Profil" (voir
  /// `profil_hub_screen.dart`) ; best-effort, ne lève jamais d'exception.
  Future<void> syncPendingProgression() async {
    // Évite des passes concurrentes (ex. l'app démarre et le réseau revient
    // au même instant, déclenchant à la fois `_load` et le listener
    // connectivité) : sans danger en soi (dédoublonné côté serveur), mais
    // inutile de pousser deux fois la même entrée en parallèle.
    if (_syncing) return;
    _syncing = true;
    try {
      final pending = _log.where((e) => !e.synced).toList();
      if (pending.isEmpty) return;
      var anySynced = false;
      for (final etape in pending) {
        final ok = await _backend.pushProgression(
          typeEtape: etape.typeEtape,
          modalite: etape.modalite,
          etapeCode: etape.etapeCode,
          palier: etape.palier,
        );
        if (ok) {
          etape.synced = true;
          anySynced = true;
        }
      }
      if (anySynced) await _writeLog();
    } finally {
      _syncing = false;
    }
  }

  /// Petit bonus (1 ou 2 points, au hasard) attribué à chaque reprise
  /// volontaire d'un exercice déjà terminé — pour encourager à répéter, sans
  /// limite de nombre de fois. Contrairement à [awardCompletion], jamais
  /// dédupliqué : ce n'est pas une nouvelle "étape réussie" (ça ne change ni
  /// coursTermines ni exercicesReussis), seulement un bonus qui vient
  /// s'ajouter au score.
  Future<int> awardRestartBonus() async {
    final points = _random.nextBool() ? _restartBonusMin : _restartBonusMax;
    _bonusTotal += points;
    await _writeBonus();
    _signalPointsAwarded(points);
    return points;
  }

  String _viewedKey(String typeEtape, String groupCode) =>
      scopeKey('$_viewedStoragePrefix${typeEtape}_$groupCode');

  Future<Set<String>> _readViewed(String typeEtape, String groupCode) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_viewedKey(typeEtape, groupCode));
    if (raw == null) return {};
    try {
      final parsed = jsonDecode(raw) as List<dynamic>;
      return parsed.map((e) => e as String).toSet();
    } catch (_) {
      return {};
    }
  }

  Future<void> _writeViewed(
    String typeEtape,
    String groupCode,
    Set<String> viewed,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _viewedKey(typeEtape, groupCode),
      jsonEncode(viewed.toList()),
    );
  }

  /// Marque un élément d'un cours comme consulté, et n'attribue les points
  /// du cours que lorsque TOUS ses éléments ont été vus au moins une fois —
  /// jamais dès l'ouverture du cours, pour ne pas récompenser un enfant qui
  /// n'irait pas au bout.
  Future<void> markCoursItemViewed({
    required String typeEtape,
    required String groupCode,
    required String itemCode,
    required int totalItems,
    required int palier,
  }) async {
    final viewed = await _readViewed(typeEtape, groupCode);
    if (viewed.contains(itemCode)) return;

    viewed.add(itemCode);
    await _writeViewed(typeEtape, groupCode, viewed);

    if (viewed.length >= totalItems) {
      await awardCompletion(
        typeEtape: typeEtape,
        modalite: 'COURS',
        etapeCode: groupCode,
        palier: palier,
      );
    }
  }

  bool get isLoaded => _loaded;

  /// Récupère les statistiques calculées côté serveur (voir
  /// `BackendSyncService.fetchProgressionStats`) et les substitue au calcul
  /// local dans [stats] tant qu'elles sont disponibles. Best-effort : en cas
  /// d'échec (hors-ligne, pas encore lié...), les statistiques précédemment
  /// récupérées — ou à défaut le calcul local — restent affichées.
  Future<void> refreshFromBackend() async {
    final backendStats = await _backend.fetchProgressionStats();
    if (backendStats == null) return;
    _backendSignesMaitrises = (backendStats['signesMaitrises'] as num?)
        ?.toInt();
    _backendCoursTermines = (backendStats['coursTermines'] as num?)?.toInt();
    _backendExercicesReussis = (backendStats['exercicesReussis'] as num?)
        ?.toInt();
    _backendJoursAventure = (backendStats['joursAventure'] as num?)?.toInt();
    notifyListeners();
  }

  ProgressStats get stats {
    // Calcul local : repli hors-ligne, et seule source pour `totalPoints`
    // (système de points sans équivalent côté back-end). Le "jour
    // d'aventure" est compté en UTC pour rester cohérent avec
    // `ProgressionServiceImpl.getProgression` côté serveur, une fois
    // resynchronisé.
    final signesMaitrises = _log
        .where((e) => e.typeEtape == 'SIGNE')
        .map((e) => e.etapeCode)
        .toSet()
        .length;
    final coursTermines = _log.where((e) => e.modalite == 'COURS').length;
    final exercicesReussis = _log.where((e) => e.modalite == 'EXERCICE').length;
    final joursAventure = _log
        .map((e) => DateTime.parse(e.dateReussite).toUtc().toIso8601String().substring(0, 10))
        .toSet()
        .length;
    final totalPoints =
        _log.fold<int>(0, (sum, e) => sum + e.points) + _bonusTotal;

    return ProgressStats(
      totalPoints: totalPoints,
      signesMaitrises: _backendSignesMaitrises ?? signesMaitrises,
      coursTermines: _backendCoursTermines ?? coursTermines,
      exercicesReussis: _backendExercicesReussis ?? exercicesReussis,
      joursAventure: _backendJoursAventure ?? joursAventure,
    );
  }

  Set<DateTime> get _joursActifsUtc => _log
      .map((e) => DateTime.parse(e.dateReussite).toUtc())
      .map((d) => DateTime.utc(d.year, d.month, d.day))
      .toSet();

  /// Nombre de jours consécutifs (UTC) avec au moins une étape réussie,
  /// en comptant à rebours depuis aujourd'hui. Si aucune étape n'a encore
  /// été réussie aujourd'hui, la série reste comptée tant qu'hier en avait
  /// une (délai de grâce d'un jour) — sans quoi elle retomberait à zéro
  /// dès minuit, avant même que l'enfant n'ait eu la chance de jouer.
  int get currentStreak {
    if (_log.isEmpty) return 0;
    final joursActifs = _joursActifsUtc;
    final maintenant = DateTime.now().toUtc();
    var curseur = DateTime.utc(
      maintenant.year,
      maintenant.month,
      maintenant.day,
    );
    if (!joursActifs.contains(curseur)) {
      curseur = curseur.subtract(const Duration(days: 1));
      if (!joursActifs.contains(curseur)) return 0;
    }
    var streak = 0;
    while (joursActifs.contains(curseur)) {
      streak++;
      curseur = curseur.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// `true` si une série est en cours mais qu'aucune étape n'a encore été
  /// réussie aujourd'hui — sert de rappel visuel ("ne casse pas ta série !")
  /// côté UI, voir `profil_hub_screen.dart`.
  bool get isStreakAtRiskToday {
    if (currentStreak == 0) return false;
    final maintenant = DateTime.now().toUtc();
    final aujourdHui = DateTime.utc(
      maintenant.year,
      maintenant.month,
      maintenant.day,
    );
    return !_joursActifsUtc.contains(aujourdHui);
  }
}
