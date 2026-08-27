import 'package:flutter/foundation.dart';

/// Signale à l'écran Mode Libre qu'il vient de devenir inactif (l'utilisateur
/// a changé d'onglet dans la barre de navigation) : toute activité en cours
/// (dessin, sélection en cours, mini-jeux) doit être remise à zéro, pour que
/// revenir dans Mode Libre retrouve toujours une page vierge — voir
/// `AppShell` (déclenche l'appel) et `BibliothequeScreen` (l'écoute).
class ModeLibreController extends ChangeNotifier {
  void notifyLeftModeLibre() {
    notifyListeners();
  }
}
