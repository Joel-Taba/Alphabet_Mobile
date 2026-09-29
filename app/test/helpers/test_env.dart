import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gentle_paths_academy/services/backend_sync_service.dart';
import 'package:gentle_paths_academy/services/family_service.dart';
import 'package:gentle_paths_academy/services/progress_service.dart';
import 'package:gentle_paths_academy/services/sound_effect_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Faux serveur : aucune requête réseau. [online] décide si les envois
/// réussissent ; [pushed] garde la trace de ce qui a été envoyé.
class FakeBackend extends BackendSyncService {
  bool online;
  final List<String> pushed = [];

  FakeBackend({this.online = false});

  @override
  Future<bool> pushProgression({
    required String typeEtape,
    required String modalite,
    required String etapeCode,
    required int palier,
  }) async {
    if (!online) return false;
    pushed.add('$typeEtape|$modalite|$etapeCode');
    return true;
  }

  @override
  Future<Map<String, dynamic>?> fetchProgressionStats() async => null;
}

/// Services créés pendant le test en cours, fermés par [disposeCreated].
final List<ProgressProvider> _created = [];

/// Ferme tous les services de progression encore ouverts : sans ça, leurs
/// écritures différées (600 ms) atterrissaient dans le stockage du test
/// SUIVANT et le faussaient.
Future<void> disposeCreated() async {
  for (final p in _created) {
    if (!_disposedSet.contains(p)) {
      p.flushPendingWritesForTest();
      p.dispose();
    }
  }
  _created.clear();
  _disposedSet.clear();
  // Laisse aux écritures déjà lancées le temps d'aboutir AVANT que le
  // test suivant ne réinitialise le stockage simulé.
  await settle();
  await Future<void>.delayed(const Duration(milliseconds: 30));
  await settle();
}

final Set<ProgressProvider> _disposedSet = {};

/// Prépare un environnement de test vierge : stockage local simulé (vide
/// ou pré-rempli), sons coupés.
Future<void> resetTestEnv([Map<String, Object> prefs = const {}]) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  addTearDown(disposeCreated);
  SharedPreferences.setMockInitialValues(Map.of(prefs));
  SoundEffectService.muted = true;
  // L'enfant actif est mémorisé dans une variable globale de l'app
  // (`scopeKey`) : sans cette remise à zéro, l'enfant créé par un test
  // précédent restait "actif" et le test suivant lisait la progression
  // sous la mauvaise clé.
  await FamilyService().ready;
}

/// Laisse s'exécuter les tâches asynchrones en attente (chargement,
/// écritures du stockage simulé...).
Future<void> settle() async {
  for (var i = 0; i < 20; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

/// Crée un [ProgressProvider] branché sur un faux serveur et un faux flux
/// de connectivité, et attend la fin de son chargement initial.
Future<
  ({
    ProgressProvider progress,
    FakeBackend backend,
    StreamController<List<ConnectivityResult>> network,
  })
>
createProgress({bool online = false, bool waitLoad = true}) async {
  final backend = FakeBackend(online: online);
  final network = StreamController<List<ConnectivityResult>>.broadcast();
  final progress = ProgressProvider(
    backend,
    connectivityChanges: network.stream,
  );
  _created.add(progress);
  if (waitLoad) await settle();
  return (progress: progress, backend: backend, network: network);
}

/// Écrit immédiatement sur le stockage tout ce qui attend encore, puis
/// recrée un provider neuf qui relit ce stockage (= fermer et rouvrir
/// l'app).
Future<ProgressProvider> reopen(ProgressProvider old) async {
  old.flushPendingWritesForTest();
  await settle();
  old.dispose();
  _disposedSet.add(old);
  final fresh = await createProgress();
  return fresh.progress;
}
