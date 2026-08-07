import 'dart:convert';
import 'package:http/http.dart' as http;

/// URL de base du backend Spring (`back-end/`). Configurable au lancement
/// sans recompiler : `flutter run --dart-define=API_BASE_URL=http://192.168.1.23:8080`.
/// Par défaut, `10.0.2.2` est l'adresse conventionnelle de l'hôte depuis un
/// émulateur Android ; un simulateur iOS ou un run desktop utiliseraient
/// `localhost` à la place via ce même `--dart-define`.
const String kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8080',
);

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
