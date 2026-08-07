import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'backend_sync_service.dart';

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

  _EtapeReussie({
    required this.typeEtape,
    required this.modalite,
    required this.etapeCode,
    required this.palier,
    required this.points,
    required this.dateReussite,
  });

  Map<String, dynamic> toJson() => {
    'typeEtape': typeEtape,
    'modalite': modalite,
    'etapeCode': etapeCode,
    'palier': palier,
    'points': points,
    'dateReussite': dateReussite,
  };

  factory _EtapeReussie.fromJson(Map<String, dynamic> json) => _EtapeReussie(
    typeEtape: json['typeEtape'] as String,
    modalite: json['modalite'] as String,
    etapeCode: json['etapeCode'] as String,
    palier: json['palier'] as int,
    points: json['points'] as int,
    dateReussite: json['dateReussite'] as String,
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

  /// Dernier nombre de points gagnés, pour un éventuel popup "+N" côté UI —
  /// incrémenté à chaque appel pour que les widgets à l'écoute détectent un
  /// nouvel évènement même si la valeur des points est identique à la précédente.
  int lastPointsAwarded = 0;
  int _awardSequence = 0;
  int get awardSequence => _awardSequence;

  ProgressProvider(this._backend) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_progressStorageKey);
    if (raw != null) {
      try {
        final parsed = jsonDecode(raw) as List<dynamic>;
        _log = parsed
            .map((e) => _EtapeReussie.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        _log = [];
      }
    }
    _bonusTotal = prefs.getInt(_bonusStorageKey) ?? 0;
    _loaded = true;
    notifyListeners();
  }

  Future<void> _writeLog() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _progressStorageKey,
      jsonEncode(_log.map((e) => e.toJson()).toList()),
    );
    notifyListeners();
  }

  Future<void> _writeBonus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bonusStorageKey, _bonusTotal);
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
    _log.add(
      _EtapeReussie(
        typeEtape: typeEtape,
        modalite: modalite,
        etapeCode: etapeCode,
        palier: palier,
        points: points,
        dateReussite: DateTime.now().toIso8601String(),
      ),
    );
    await _writeLog();
    _signalPointsAwarded(points);
    unawaited(
      _backend.pushProgression(
        typeEtape: typeEtape,
        modalite: modalite,
        etapeCode: etapeCode,
        palier: palier,
      ),
    );
    return AwardResult(pointsAwarded: points, alreadyCompleted: false);
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
      '$_viewedStoragePrefix${typeEtape}_$groupCode';

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

  ProgressStats get stats {
    final signesMaitrises = _log
        .where((e) => e.typeEtape == 'SIGNE' && e.modalite == 'EXERCICE')
        .map((e) => e.etapeCode)
        .toSet()
        .length;
    final coursTermines = _log.where((e) => e.modalite == 'COURS').length;
    final exercicesReussis = _log.where((e) => e.modalite == 'EXERCICE').length;
    final joursAventure = _log
        .map((e) => e.dateReussite.substring(0, 10))
        .toSet()
        .length;
    final totalPoints =
        _log.fold<int>(0, (sum, e) => sum + e.points) + _bonusTotal;

    return ProgressStats(
      totalPoints: totalPoints,
      signesMaitrises: signesMaitrises,
      coursTermines: coursTermines,
      exercicesReussis: exercicesReussis,
      joursAventure: joursAventure,
    );
  }
}
