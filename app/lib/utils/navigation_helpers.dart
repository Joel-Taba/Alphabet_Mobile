import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Revient à l'écran d'accueil (Parcours), et uniquement à celui-ci, quel que
/// soit l'écran depuis lequel ce bouton est actionné. On dépile d'abord toute
/// la pile de navigation poussée par-dessus le shell (cours -> exercice ->
/// sous-exercice, etc.) plutôt que de re-naviguer avec `context.go` : `go`
/// reconstruit l'écran depuis zéro et perd sa position de défilement (l'enfant
/// revenait toujours en haut du palier courant), alors que dépiler garde
/// l'instance déjà montée, donc exactement là où l'enfant l'avait laissée --
/// mais seulement quand l'onglet actif sous cette pile était déjà
/// \enquote{Accueil}. Si l'enfant avait rejoint l'exercice/cours depuis un
/// autre onglet (Mode libre, Profil), dépiler seul y ramènerait au lieu de
/// l'accueil~: on force alors explicitement `/accueil` en dernier recours.
void goHome(BuildContext context) {
  final router = GoRouter.of(context);
  while (router.canPop()) {
    router.pop();
  }
  if (router.state.uri.path != '/accueil') {
    router.go('/accueil');
  }
}
