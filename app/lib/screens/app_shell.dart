import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/amani_bottom_nav.dart';
import '../services/mode_libre_controller.dart';

/// Largeur à partir de laquelle on considère l'appareil comme une tablette :
/// reprend le seuil "medium" du Material 3 breakpoint system (600dp), déjà
/// la référence pour basculer d'une navigation pensée pour le pouce vers une
/// disposition grand écran.
const double kTabletBreakpoint = 600;

/// Index de branche du Mode Libre dans le `StatefulNavigationShell`
/// (0: /accueil, 1: /bibliotheque, 2: /communaute, 3: /mon-profil).
const int _modeLibreBranchIndex = 1;

class AppShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _previousIndex = widget.navigationShell.currentIndex;

  @override
  void didUpdateWidget(covariant AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    final index = widget.navigationShell.currentIndex;
    // Toute activité en cours dans Mode Libre (dessin, sélection, mini-jeux)
    // doit repartir de zéro dès qu'on le quitte pour un autre onglet — voir
    // `BibliothequeScreen._onLeftModeLibre`, qui écoute ce signal.
    if (_previousIndex == _modeLibreBranchIndex && index != _previousIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.read<ModeLibreController>().notifyLeftModeLibre();
      });
    }
    _previousIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    final navigationShell = widget.navigationShell;
    // Calcul de l'index courant pour la barre de navigation
    // 0: /accueil, 1: /bibliotheque, 2: /communaute, 3: /mon-profil
    final index = navigationShell.currentIndex;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= kTabletBreakpoint;

        // Sur téléphone : la barre flottante en pilule occupe toute la
        // largeur en bas, comme avant. Sur tablette, elle laisserait un
        // vide immense au centre — on la remplace par un rail vertical
        // fixe le long du bord gauche, et le contenu est recentré avec
        // une largeur maximale pour ne pas s'étirer d'un bord à l'autre.
        if (!isTablet) {
          return Scaffold(
            body: SafeArea(child: navigationShell),
            extendBody: true,
            bottomNavigationBar: SafeArea(
              child: AmaniBottomNav(currentIndex: index),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                AmaniSideNav(currentIndex: index),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: navigationShell,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
