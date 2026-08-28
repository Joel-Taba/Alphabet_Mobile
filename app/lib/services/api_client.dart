import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'platform_default_api_base_url.dart'
    if (dart.library.io) 'platform_default_api_base_url_io.dart';

/// URL de base du backend Spring (`back-end/`). Configurable au lancement
/// sans recompiler : `flutter run --dart-define=API_BASE_URL=http://192.168.1.23:8080`
/// — indispensable dès que le backend ne tourne pas sur la même machine que
/// l'appareil qui exécute l'app (téléphone physique, backend déployé
/// ailleurs...), sans quoi AUCUNE synchronisation ne peut jamais réussir.
///
/// À défaut de cette variable, la valeur choisie dépend de la plateforme :
/// `10.0.2.2` est l'adresse conventionnelle de l'hôte depuis un émulateur
/// Android, alors que le web (le run le plus courant en développement) et
/// tout run natif desktop/iOS peuvent directement joindre `localhost`.
const String _kApiBaseUrlOverride = String.fromEnvironment('API_BASE_URL');

String get kApiBaseUrl => _kApiBaseUrlOverride.isNotEmpty
    ? _kApiBaseUrlOverride
    : (kIsWeb ? 'http://localhost:8080' : defaultNativeApiBaseUrl);

/// Erreur renvoyée par l'API, au format `ApiErrorResponse` du back-end
/// (`code` correspond aux constantes comme `NOM_DEJA_UTILISE`,
/// `MOT_DE_PASSE_INCORRECT`...).
class ApiException implements Exception {
  final int status;
  final String code;
  final String message;

  const ApiException(this.status, this.code, this.message);

  @override
  String toString() => 'ApiException($status, $code, $message)';
}

/// Client HTTP minimal pour `back-end/` : encodage/décodage JSON, en-tête
/// d'authentification, et traduction des réponses d'erreur en
/// [ApiException]. Ne connaît rien du contenu métier des requêtes — c'est le
/// rôle de `BackendSyncService`.
class ApiClient {
  static const _timeout = Duration(seconds: 8);

  Future<Map<String, dynamic>> get(String path, {String? token}) async {
    final res = await http
        .get(Uri.parse('$kApiBaseUrl$path'), headers: _headers(token))
        .timeout(_timeout);
    return _decode(res);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final res = await http
        .post(
          Uri.parse('$kApiBaseUrl$path'),
          headers: _headers(token),
          body: jsonEncode(body ?? const {}),
        )
        .timeout(_timeout);
    return _decode(res);
  }

  Future<void> patch(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final res = await http
        .patch(
          Uri.parse('$kApiBaseUrl$path'),
          headers: _headers(token),
          body: jsonEncode(body ?? const {}),
        )
        .timeout(_timeout);
    if (res.statusCode >= 400) _throwFor(res);
  }

  Map<String, String> _headers(String? token) => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  Map<String, dynamic> _decode(http.Response res) {
    if (res.statusCode >= 400) _throwFor(res);
    if (res.body.isEmpty) return const {};
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Never _throwFor(http.Response res) {
    try {
      final parsed = jsonDecode(res.body) as Map<String, dynamic>;
      throw ApiException(
        res.statusCode,
        parsed['code'] as String? ?? 'ERREUR_INCONNUE',
        parsed['message'] as String? ?? 'Erreur ${res.statusCode}',
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException(
        res.statusCode,
        'ERREUR_INCONNUE',
        'Erreur ${res.statusCode}',
      );
    }
  }
}
