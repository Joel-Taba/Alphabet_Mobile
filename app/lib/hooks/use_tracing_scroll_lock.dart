import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
///
/// Filet de sécurité : le verrou observe aussi TOUS les pointeurs de l'app
/// (route globale du `GestureBinding`). Dès qu'il n'y a plus aucun doigt ni
/// bouton posé nulle part, il se libère de lui-même -- un `start()` sans
/// `stop()` (relâchement perdu, widget démonté en plein geste...) ne peut
/// donc plus jamais bloquer le défilement de toute l'app.
class TracingScrollLock extends ChangeNotifier {
  int _activeTraces = 0;
  final Set<int> _pointersDown = {};

  TracingScrollLock() {
    GestureBinding.instance.pointerRouter.addGlobalRoute(_onGlobalPointer);
  }

  void _onGlobalPointer(PointerEvent event) {
    if (event is PointerDownEvent) {
      _pointersDown.add(event.pointer);
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      _pointersDown.remove(event.pointer);
      if (_pointersDown.isEmpty && _activeTraces > 0) {
        // Laisse d'abord les zones de tracé traiter ce même relâchement
        // (elles appellent `stop()` normalement), puis purge ce qui reste.
        scheduleMicrotask(() {
          if (_pointersDown.isEmpty && _activeTraces > 0) {
            _activeTraces = 0;
            _notifySafely();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_onGlobalPointer);
    super.dispose();
  }

  bool get isLocked => _activeTraces > 0;

  void start() {
    _activeTraces++;
    if (_activeTraces == 1) _notifySafely();
  }

  void stop() {
    if (_activeTraces == 0) return;
    _activeTraces--;
    if (_activeTraces == 0) _notifySafely();
  }

  /// Un tracé peut être relâché depuis le `dispose()` de son widget (page
  /// quittée en plein geste), c'est-à-dire PENDANT que Flutter reconstruit
  /// l'arbre : prévenir les écouteurs à cet instant déclenchait l'erreur
  /// "setState() called when widget tree was locked" (détecté par
  /// `test/widgets/tracing_and_scribble_test.dart`). Dans ce cas, on les
  /// prévient juste après la fin de l'image en cours.
  void _notifySafely() {
    final binding = SchedulerBinding.instance;
    if (binding.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      binding.addPostFrameCallback((_) => notifyListeners());
    } else {
      notifyListeners();
    }
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
