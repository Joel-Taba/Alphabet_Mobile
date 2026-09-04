import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Verrou partagé, actif tant qu'un tracé est en cours quelque part dans
/// l'app (n'importe quelle case de lettre/signe/figure, mot mêlé, ou le
/// canevas de gribouillage) : les zones défilantes qui l'observent (voir
/// [tracingAwareScrollPhysics]) désactivent leur propre défilement tant
/// qu'il est actif, pour qu'un geste de tracé -- un trait vertical, en
/// particulier, visuellement identique à un geste de défilement -- ne soit
/// jamais interprété comme un scroll de la page plutôt qu'un tracé.
///
/// Compteur plutôt qu'un simple booléen : protège contre un
/// démarrage/arrêt qui se chevaucherait (deux cases tracées presque en même
/// temps, multi-touch...).
class TracingScrollLock extends ChangeNotifier {
  int _activeTraces = 0;

  bool get isLocked => _activeTraces > 0;

  void start() {
    _activeTraces++;
    if (_activeTraces == 1) notifyListeners();
  }

  void stop() {
    if (_activeTraces == 0) return;
    _activeTraces--;
    if (_activeTraces == 0) notifyListeners();
  }
}

/// À passer au `physics:` de tout `ListView`/`SingleChildScrollView`
/// entourant une zone de tracé : défilement normal de la plateforme tant
/// qu'aucun tracé n'est en cours (`null`), verrouillé
/// (`NeverScrollableScrollPhysics`) dès qu'un tracé démarre quelque part
/// dans l'écran.
ScrollPhysics? tracingAwareScrollPhysics(BuildContext context) {
  final locked = context.watch<TracingScrollLock>().isLocked;
  return locked ? const NeverScrollableScrollPhysics() : null;
}
