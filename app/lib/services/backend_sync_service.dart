import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';
import 'profile_auth.dart';

const _tokenKey = 'amani_backend_token';
const _langStorageKey = 'amani_setting_lang';

/// Entrée du classement telle que renvoyée par
/// `GET /api/v1/communaute/classement` (public, sans authentification).
class ClassementEntryDto {
  final int rang;
  final String nom;
  final int score;

  const ClassementEntryDto({
    required this.rang,
    required this.nom,
    required this.score,
  });

  factory ClassementEntryDto.fromJson(Map<String, dynamic> json) =>
      ClassementEntryDto(
        rang: json['rang'] as int,
        nom: json['nom'] as String,
        score: json['score'] as int,
      );
}

/// Synchronisation "local-first" avec `back-end/` : les réglages, le mot de
/// passe et la progression restent lus/écrits localement (SharedPreferences,
/// voir `profile_auth.dart` et `progress_service.dart`) comme source de
/// vérité pour l'expérience hors-ligne ; ce service se contente de pousser
/// ces mêmes données vers l'API en best-effort, sans jamais bloquer l'UI ni
/// faire remonter d'erreur réseau à l'écran. Si le back-end est injoignable,
/// l'app continue de fonctionner exactement comme avant cette intégration.
///
/// L'authentification se "auto-répare" à chaque appel via [ensureLinked] :
/// pas besoin d'un flux d'inscription/connexion explicite ailleurs dans
/// l'app — si aucun jeton n'est en mémoire, on tente une connexion avec le
/// nom/mot de passe stockés localement, et si le compte n'existe pas encore
/// côté serveur (première synchronisation, ou création hors-ligne), on le
/// crée avant de réessayer de se connecter.
class BackendSyncService extends ChangeNotifier {
  final ApiClient _api = ApiClient();
  String? _token;
  bool _loaded = false;

  BackendSyncService() {
    _restore();
  }

  bool get isLoaded => _loaded;
  bool get isLinked => _token != null;

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    _loaded = true;
    notifyListeners();
  }

  Future<void> _saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    notifyListeners();
  }

  Future<void> _clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    notifyListeners();
  }

  /// S'assure qu'un jeton valide est disponible, en tentant de se
  /// (re)connecter avec les identifiants locaux si besoin. Ne lève jamais
  /// d'exception — retourne simplement `false` en cas d'échec (hors-ligne,
  /// backend injoignable, ou mot de passe local désynchronisé du serveur).
  Future<bool> ensureLinked() async {
    if (_token != null) return true;

    final nom = await getStoredName();
    final motDePasse = await getStoredPassword();
    if (nom == null || nom.isEmpty || motDePasse == null) return false;

    if (await _tryLogin(nom, motDePasse)) return true;
    if (!await _trySignup(nom, motDePasse)) return false;
    return _tryLogin(nom, motDePasse);
  }

  Future<bool> _tryLogin(String nom, String motDePasse) async {
    try {
      final res = await _api.post(
        '/api/v1/profils/connexion',
        body: {'nom': nom, 'motDePasse': motDePasse},
      );
      await _saveToken(res['jeton'] as String);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _trySignup(String nom, String motDePasse) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final langue = prefs.getString(_langStorageKey) == 'en' ? 'EN' : 'FR';
      await _api.post(
        '/api/v1/profils',
        body: {'nom': nom, 'motDePasse': motDePasse, 'langue': langue},
      );
      return true;
    } on ApiException catch (e) {
      // NOM_DEJA_UTILISE : le compte existe déjà côté serveur mais le mot de
      // passe local ne correspond pas (ou le jeton a simplement expiré et la
      // connexion a échoué pour une autre raison passagère) — inutile de
      // réessayer, ce n'est pas la responsabilité de ce service de résoudre
      // ce conflit, l'app reste en mode local uniquement.
      return e.code == 'NOM_DEJA_UTILISE';
    } catch (_) {
      return false;
    }
  }

  /// Journalise côté serveur la réussite d'une étape (voir
  /// `ProgressProvider.awardCompletion`), en best-effort. Le bonus de
  /// redémarrage (`awardRestartBonus`) n'a pas d'équivalent côté back-end
  /// (aucune étape associée) et n'est donc jamais synchronisé.
  ///
  /// Retourne `true` si l'étape a bien été journalisée côté serveur (ou
  /// l'était déjà) : [ProgressProvider] s'en sert pour savoir quelles
  /// entrées peuvent être marquées "synchronisées" plutôt que ré-essayées
  /// plus tard par [syncPendingProgression]. Ne lève jamais d'exception.
  Future<bool> pushProgression({
    required String typeEtape,
    required String modalite,
    required String etapeCode,
    required int palier,
  }) async {
    if (!await ensureLinked()) return false;
    try {
      await _api.post(
        '/api/v1/progressions',
        token: _token,
        body: {
          'palier': palier,
          'typeEtape': typeEtape,
          'modalite': modalite,
          'etapeCode': etapeCode,
        },
      );
      return true;
    } on ApiException catch (e) {
      if (e.status == 401) await _clearToken();
      return false;
    } catch (_) {
      // Hors-ligne ou backend injoignable : la progression reste locale, en
      // attente d'un futur appel à `syncPendingProgression`.
      return false;
    }
  }

  /// Pousse un sous-ensemble des réglages (seuls les champs non-nuls sont
  /// envoyés, comme attendu par `ReglagesRequestDto` côté serveur).
  Future<void> pushReglages({
    String? langue,
    String? formatEcriture,
    bool? sonActif,
    double? volume,
    int? repetitions,
    double? tolerance,
  }) async {
    if (!await ensureLinked()) return;
    try {
      await _api.patch(
        '/api/v1/profils/moi/reglages',
        token: _token,
        body: {
          'langue': ?langue,
          'formatEcriture': ?formatEcriture,
          'sonActif': ?sonActif,
          'volume': ?volume,
          'repetitions': ?repetitions,
          'tolerance': ?tolerance,
        },
      );
    } on ApiException catch (e) {
      if (e.status == 401) await _clearToken();
    } catch (_) {
      // Réglage resté local uniquement, resynchronisé au prochain appel.
    }
  }

  /// Répercute côté serveur un changement de mot de passe déjà appliqué
  /// localement (voir `profil_hub_screen.dart`). Purement best-effort : le
  /// mot de passe local reste la source de vérité pour le déverrouillage de
  /// l'app, que cette synchronisation réussisse ou non.
  Future<void> pushMotDePasse({
    required String ancien,
    required String nouveau,
  }) async {
    if (!await ensureLinked()) return;
    try {
      await _api.patch(
        '/api/v1/profils/moi/mot-de-passe',
        token: _token,
        body: {'ancienMotDePasse': ancien, 'nouveauMotDePasse': nouveau},
      );
    } on ApiException catch (e) {
      if (e.status == 401) await _clearToken();
    } catch (_) {
      // Le nouveau mot de passe reste valide localement dans tous les cas.
    }
  }

  /// Statistiques globales du profil (signes maîtrisés, cours terminés,
  /// exercices réussis, jours d'aventure), calculées côté serveur à partir
  /// de TOUTES les étapes journalisées pour ce profil — voir
  /// `ProgressionServiceImpl.getProgression` côté back-end. Retourne `null`
  /// en best-effort (hors-ligne, pas encore lié, jeton expiré...) : c'est à
  /// l'appelant ([ProgressProvider.refreshFromBackend]) de conserver les
  /// statistiques locales comme repli dans ce cas.
  Future<Map<String, dynamic>?> fetchProgressionStats() async {
    if (!await ensureLinked()) return null;
    try {
      final res = await _api.get('/api/v1/progressions/moi', token: _token);
      return res['stats'] as Map<String, dynamic>?;
    } on ApiException catch (e) {
      if (e.status == 401) await _clearToken();
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Classement public (aucune authentification requise). Retourne une
  /// liste vide en cas d'échec réseau plutôt que de faire planter l'écran
  /// "La Clairière", qui garde ses profils de remplissage dans ce cas.
  Future<List<ClassementEntryDto>> fetchClassement() async {
    try {
      final res = await _api.get('/api/v1/communaute/classement');
      final list = res['classement'] as List<dynamic>? ?? [];
      return list
          .map((e) => ClassementEntryDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
