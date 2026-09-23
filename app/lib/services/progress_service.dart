import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'backend_sync_service.dart';
import 'family_service.dart';
import 'sound_effect_service.dart';

/// Système de points local — port fidèle de `src/lib/progress.ts`. Les noms
/// et la forme des données (typeEtape, modalite, palier, etapeCode) sont
/// volontairement calqués sur `com.methode.progression` (back-end Spring)
/// pour que le remplacement de ce service par de vrais appels API, plus
/// tard, soit une substitution mécanique plutôt qu'une réécriture.
///
/// Barème : un cours (découverte guidée) rapporte moins qu'un exercice
/// (pratique active), pour valoriser l'effort. Ces points alimentent les
/// statistiques de "Mon Profil" — aucun classement n'en est tiré.
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
class ProgressProvider extends ChangeNotifier with WidgetsBindingObserver {
  final BackendSyncService _backend;
  List<_EtapeReussie> _log = [];
  int _bonusTotal = 0;
  bool _loaded = false;
  final Random _random = Random();

  // --- Agrégats incrémentaux ----------------------------------------------
  // `stats`, `currentStreak`, `completedCountForType`, `completedTopicsForType`
  // et la déduplication d'`awardCompletion` étaient auparavant recalculés en
  // repassant sur tout `_log` (un ou plusieurs O(n), avec `DateTime.parse`
  // et `toSet()` par entrée) -- et ces getters sont lus à CHAQUE
  // `notifyListeners()`, donc à chaque point gagné, y compris pendant une
  // série rapide d'exercices de calcul (CALCUL/FIGURE journalisent une
  // entrée par tentative, pas par sujet -- la source de croissance la plus
  // rapide de `_log`). Une fois l'historique assez grand (usage réel
  // prolongé), ce recalcul synchrone sur le thread UI devenait lui-même la
  // source d'un gel, indépendamment de la vitesse d'écriture disque (déjà
  // traitée séparément, voir `_logWriteDebounce`). Les champs ci-dessous
  // sont donc maintenus à jour en O(1) à chaque ajout dans `_log` (voir
  // `_applyToAggregates`), reconstruits en un seul passage O(n) uniquement
  // au chargement (`_rebuildAggregates`, appelé une fois par
  // démarrage/changement d'enfant actif -- jamais par point gagné).
  final Set<String> _dedupKeys = {};
  final Map<String, int> _countByType = {};
  final Map<String, int> _coursCountByType = {};
  final Map<String, Set<String>> _exerciceTopicsByType = {};
  final Set<String> _signesMaitrisesCodes = {};
  final Set<String> _joursActifsKeys = {};
  int _coursTerminesTotal = 0;
  int _exercicesReussisTotal = 0;
  int _totalPointsFromLog = 0;

  static String _dedupKey(
    String typeEtape,
    String modalite,
    String etapeCode,
  ) => '$typeEtape|$modalite|$etapeCode';

  static String _topicIdFromEtapeCode(String etapeCode) {
    final idx = etapeCode.lastIndexOf('-');
    return idx == -1 ? etapeCode : etapeCode.substring(0, idx);
  }

  /// Clé "yyyy-mm-dd" (UTC) d'une date -- utilisée à la fois pour peupler
  /// [_joursActifsKeys] et pour tester l'appartenance d'un jour donné
  /// (`currentStreak`/`isStreakAtRiskToday`), afin de rester cohérente avec
  /// le format déjà utilisé côté back-end (`ProgressionServiceImpl`).
  static String _dayKey(DateTime d) =>
      DateTime.utc(d.year, d.month, d.day).toIso8601String().substring(0, 10);

  void _resetAggregates() {
    _dedupKeys.clear();
    _countByType.clear();
    _coursCountByType.clear();
    _exerciceTopicsByType.clear();
    _signesMaitrisesCodes.clear();
    _joursActifsKeys.clear();
    _coursTerminesTotal = 0;
    _exercicesReussisTotal = 0;
    _totalPointsFromLog = 0;
  }

  void _rebuildAggregates() {
    _resetAggregates();
    for (final e in _log) {
      _applyToAggregates(e);
    }
  }

  void _applyToAggregates(_EtapeReussie e) {
    _dedupKeys.add(_dedupKey(e.typeEtape, e.modalite, e.etapeCode));
    _countByType.update(e.typeEtape, (v) => v + 1, ifAbsent: () => 1);
    _totalPointsFromLog += e.points;
    if (e.modalite == 'COURS') {
      _coursTerminesTotal++;
      _coursCountByType.update(e.typeEtape, (v) => v + 1, ifAbsent: () => 1);
    } else if (e.modalite == 'EXERCICE') {
      _exercicesReussisTotal++;
      _exerciceTopicsByType
          .putIfAbsent(e.typeEtape, () => {})
          .add(_topicIdFromEtapeCode(e.etapeCode));
    }
    if (e.typeEtape == 'SIGNE') _signesMaitrisesCodes.add(e.etapeCode);
    _joursActifsKeys.add(_dayKey(DateTime.parse(e.dateReussite).toUtc()));
  }

  // `_log`/`_bonusTotal` grandissent avec l'usage réel (chaque cours/exercice
  // réussi, sur toute la durée de vie de l'app -- voir `awardCompletion`) :
  // ré-encoder tout `_log` en JSON et ré-écrire la clé SharedPreferences
  // correspondante en entier à CHAQUE point gagné (potentiellement plusieurs
  // fois par minute pendant un exercice de calcul) devenait de plus en plus
  // coûteux à mesure que l'historique grossissait -- un aller-retour par
  // canal de plateforme et une écriture disque native à chaque point, plus
  // la cascade de `notifyListeners()` qui force `ProfilHubScreen` (maintenu
  // vivant dans l'`IndexedStack`, voir `app.dart`) et `PointsToastHost`
  // (monté en permanence à la racine) à se reconstruire et à re-parcourir
  // tout l'historique. Les deux écritures ci-dessous sont donc désormais
  // "debounced" : la mise à jour en mémoire et la notification restent
  // immédiates (l'UI réagit toujours à l'instant), seule l'écriture disque
  // est repoussée de quelques centaines de ms et fusionne les appels
  // rapprochés en une seule écriture -- avec un filet de sécurité qui la
  // déclenche immédiatement dès que l'app passe en arrière-plan
  // (`didChangeAppLifecycleState`), pour ne jamais perdre un gain de points
  // si l'app est fermée juste après.
  Timer? _logWriteDebounce;
  Timer? _bonusWriteDebounce;
  // Capturées au moment de la PLANIFICATION de l'écriture (voir [_writeLog]/
  // [_writeBonus]), jamais recalculées à l'exécution du `Timer` : la clé
  // SharedPreferences visée (dépendante de l'enfant actif au moment de
  // l'appel) et le contenu à y écrire restent donc corrects même si l'enfant
  // actif change entre-temps (voir [_flushPendingWrites]/[_load]).
  void Function()? _pendingLogWrite;
  void Function()? _pendingBonusWrite;
  static const _writeDebounceDelay = Duration(milliseconds: 600);

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
    WidgetsBinding.instance.addObserver(this);
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
    WidgetsBinding.instance.removeObserver(this);
    _flushPendingWrites();
    _connectivitySub?.cancel();
    super.dispose();
  }

  /// Déclenche immédiatement toute écriture disque encore "debounced" (voir
  /// [_writeLog]/[_writeBonus]) — appelé quand l'app passe en arrière-plan
  /// (l'OS peut la tuer à tout moment une fois hors du premier plan, sans
  /// garantir qu'un `Timer` en attente ait le temps de se déclencher) et à
  /// chaque changement d'enfant actif, pour ne jamais laisser une écriture
  /// traîner plus longtemps que nécessaire.
  void _flushPendingWrites() {
    _logWriteDebounce?.cancel();
    _logWriteDebounce = null;
    _pendingLogWrite?.call();
    _pendingLogWrite = null;
    _bonusWriteDebounce?.cancel();
    _bonusWriteDebounce = null;
    _pendingBonusWrite?.call();
    _pendingBonusWrite = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _flushPendingWrites();
  }

  Future<void> _load() async {
    // Toute écriture encore en attente concerne l'enfant PRÉCÉDEMMENT actif
    // (voir `rechargerPourEnfantActif`, appelé après que `FamilyService` a
    // déjà basculé son espace de nommage) : la déclencher maintenant, avant
    // de recharger, évite qu'elle traîne inutilement -- sans risque de
    // l'écrire sous la mauvaise clé, puisque [_writeLog]/[_writeBonus]
    // capturent déjà la clé et le contenu au moment de la planification, pas
    // au moment de l'écriture effective.
    _flushPendingWrites();
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
    _rebuildAggregates();
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

  /// Met à jour l'UI immédiatement (l'enfant voit son "+N" sans délai), mais
  /// ne reporte l'écriture disque proprement dite -- coûteuse dès que
  /// l'historique grossit, voir la note sur `_logWriteDebounce` -- que de
  /// quelques centaines de ms, fusionnant les appels rapprochés (ex. une
  /// série de problèmes de calcul résolus coup sur coup) en une seule
  /// écriture plutôt qu'une par point gagné.
  void _writeLog() {
    notifyListeners();
    final key = scopeKey(_progressStorageKey);
    // Seule la RÉFÉRENCE à `_log` est capturée ici, pas son JSON : `_load()`
    // réassigne toujours `_log` à une toute nouvelle liste au changement
    // d'enfant actif (jamais de mutation en place), donc cette référence
    // reste bien celle du bon enfant même si l'enfant actif change avant que
    // le minuteur ne se déclenche -- alors que ré-encoder tout `_log` en
    // JSON ICI, à CHAQUE point gagné, restait un O(n) synchrone sur le
    // thread UI (donc un O(n²) sur une série rapide d'exercices), même une
    // fois l'écriture disque elle-même repoussée. L'encodage est donc lui
    // aussi désormais repoussé à l'exécution du minuteur, où il ne
    // s'exécute qu'une fois par rafale d'appels rapprochés plutôt qu'une
    // fois par point.
    final logSnapshot = _log;
    _pendingLogWrite = () async {
      final payload = jsonEncode(logSnapshot.map((e) => e.toJson()).toList());
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, payload);
    };
    _logWriteDebounce?.cancel();
    _logWriteDebounce = Timer(_writeDebounceDelay, () {
      _logWriteDebounce = null;
      final write = _pendingLogWrite;
      _pendingLogWrite = null;
      write?.call();
    });
  }

  /// Même principe "debounced" que [_writeLog], voir la note sur
  /// `_logWriteDebounce`.
  void _writeBonus() {
    notifyListeners();
    final key = scopeKey(_bonusStorageKey);
    final total = _bonusTotal;
    _pendingBonusWrite = () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(key, total);
    };
    _bonusWriteDebounce?.cancel();
    _bonusWriteDebounce = Timer(_writeDebounceDelay, () {
      _bonusWriteDebounce = null;
      final write = _pendingBonusWrite;
      _pendingBonusWrite = null;
      write?.call();
    });
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
    if (_dedupKeys.contains(_dedupKey(typeEtape, modalite, etapeCode))) {
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
    _applyToAggregates(etape);
    _writeLog();
    _signalPointsAwarded(points);
    // Retour sonore d'euphorie sur chaque rangée d'exercice réussie -- pas
    // sur un simple cours consulté, pour rester spécifique à la page
    // d'exercice comme demandé.
    if (modalite == 'EXERCICE') SoundEffectService.playRowComplete();
    unawaited(_pushAndMarkSynced(etape));
    return AwardResult(pointsAwarded: points, alreadyCompleted: false);
  }

  /// Nombre d'étapes distinctes validées (COURS + EXERCICE) pour un
  /// [typeEtape] donné — utilisé par "Ma progression dans la forêt" pour
  /// afficher une progression réelle par grande étape du parcours. Fiable
  /// tant que chaque étape du catalogue a un `etapeCode` unique et stable
  /// (SIGNE, LETTRE, SYLLABE, MOT, TANGRAM).
  int completedCountForType(String typeEtape) => _countByType[typeEtape] ?? 0;

  /// Variante pour les types dont les exercices sont journalisés par
  /// tentative plutôt que par sujet du catalogue (`etapeCode` de la forme
  /// `'sujetId-i'`, ex. CALCUL/FIGURE) : compte les COURS validés, puis le
  /// nombre de SUJETS distincts ayant au moins un exercice réussi — pas le
  /// nombre brut d'entrées, qui grandirait sans borne à chaque répétition.
  int completedTopicsForType(String typeEtape) {
    final coursCount = _coursCountByType[typeEtape] ?? 0;
    final exerciceTopics = _exerciceTopicsByType[typeEtape]?.length ?? 0;
    return coursCount + exerciceTopics;
  }

  /// `true` si au moins un exercice de ce sujet précis a déjà été réussi --
  /// même convention de sujet que [completedTopicsForType] (tout ce qui
  /// précède le dernier `-` de l'`etapeCode`), pour les types dont les
  /// exercices sont journalisés par tentative plutôt que par sujet entier du
  /// catalogue (CALCUL, FIGURE) : consulté par `parcours_screen.dart` pour
  /// savoir si le volet "Exercice" d'un sujet donné est acquis, sans exiger
  /// d'avoir réussi CHAQUE tentative possible de ce sujet.
  bool isTopicExercised(String typeEtape, String topicId) =>
      _exerciceTopicsByType[typeEtape]?.contains(topicId) ?? false;

  /// `true` si cette étape précise a déjà été réussie (par ex. un signe, une
  /// lettre, une syllabe ou un mot déjà tracé avec succès) — à consulter par
  /// les écrans d'exercice pour restaurer, à l'ouverture, l'état "déjà
  /// acquis" d'un item plutôt que de systématiquement repartir d'un tracé
  /// vierge : un enfant qui quitte puis revient sur un exercice déjà réussi
  /// doit le retrouver tel quel, sans avoir à le retracer, tant que
  /// l'application reste installée (cette information est la même que celle
  /// qui empêche `awardCompletion` de redonner des points pour cette étape).
  bool isCompleted({
    required String typeEtape,
    required String modalite,
    required String etapeCode,
  }) => _dedupKeys.contains(_dedupKey(typeEtape, modalite, etapeCode));

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
      _writeLog();
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
      if (anySynced) _writeLog();
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
    _writeBonus();
    _signalPointsAwarded(points);
    return points;
  }

  /// 1 point, à chaque fois, pour une pratique rapide d'un seul signe lancée
  /// depuis le bouton "S'entrainer" du cours (Palier 1) — sur le même
  /// principe que [awardRestartBonus] (s'ajoute au score, jamais dédupliqué,
  /// pas de nouvelle "étape réussie" journalisée), mais un montant fixe
  /// plutôt qu'aléatoire : l'utilisateur a explicitement demandé "juste un
  /// point, comme les autres", pas un bonus variable.
  Future<void> awardSignPracticePoint() async {
    _bonusTotal += 1;
    _writeBonus();
    _signalPointsAwarded(1);
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
    // resynchronisé. Lu directement depuis les agrégats incrémentaux (voir
    // plus haut) plutôt que recalculé sur tout `_log`.
    return ProgressStats(
      totalPoints: _totalPointsFromLog + _bonusTotal,
      signesMaitrises: _backendSignesMaitrises ?? _signesMaitrisesCodes.length,
      coursTermines: _backendCoursTermines ?? _coursTerminesTotal,
      exercicesReussis: _backendExercicesReussis ?? _exercicesReussisTotal,
      joursAventure: _backendJoursAventure ?? _joursActifsKeys.length,
    );
  }

  /// Nombre de jours consécutifs (UTC) avec au moins une étape réussie,
  /// en comptant à rebours depuis aujourd'hui. Si aucune étape n'a encore
  /// été réussie aujourd'hui, la série reste comptée tant qu'hier en avait
  /// une (délai de grâce d'un jour) — sans quoi elle retomberait à zéro
  /// dès minuit, avant même que l'enfant n'ait eu la chance de jouer.
  int get currentStreak {
    if (_joursActifsKeys.isEmpty) return 0;
    final maintenant = DateTime.now().toUtc();
    var curseur = DateTime.utc(
      maintenant.year,
      maintenant.month,
      maintenant.day,
    );
    if (!_joursActifsKeys.contains(_dayKey(curseur))) {
      curseur = curseur.subtract(const Duration(days: 1));
      if (!_joursActifsKeys.contains(_dayKey(curseur))) return 0;
    }
    var streak = 0;
    while (_joursActifsKeys.contains(_dayKey(curseur))) {
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
    return !_joursActifsKeys.contains(_dayKey(aujourdHui));
  }
}
