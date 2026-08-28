import 'dart:io' show Platform;

/// `10.0.2.2` est l'adresse conventionnelle, côté émulateur Android
/// uniquement, pour joindre `localhost` de la machine hôte — tout autre run
/// natif (iOS, desktop) peut directement utiliser `localhost`.
String get defaultNativeApiBaseUrl =>
    Platform.isAndroid ? 'http://10.0.2.2:8080' : 'http://localhost:8080';
