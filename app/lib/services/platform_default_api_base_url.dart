/// Stub compilé uniquement sur le web (voir l'import conditionnel dans
/// `api_client.dart`) — jamais réellement lu, `kApiBaseUrl` court-circuite
/// sur `kIsWeb` avant d'y toucher, mais `dart:io` n'existe pas sur le web
/// donc la variante `_io.dart` ne peut pas non plus y être compilée.
const String defaultNativeApiBaseUrl = 'http://localhost:8080';
