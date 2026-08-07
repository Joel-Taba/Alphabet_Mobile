import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/amani_bottom_nav.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    // Calcul de l'index courant pour la barre de navigation
    // 0: /accueil, 1: /bibliotheque, 2: /communaute, 3: /mon-profil, 4: /plus
    final index = navigationShell.currentIndex;

    return Scaffold(
      body: SafeArea(child: navigationShell),
      extendBody:
          true, // Pour que la page passe sous la bottom nav transparente/flottante
      bottomNavigationBar: SafeArea(child: AmaniBottomNav(currentIndex: index)),
    );
  }
}
