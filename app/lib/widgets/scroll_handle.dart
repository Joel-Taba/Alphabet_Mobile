import 'package:flutter/material.dart';
import '../theme/amani_theme.dart';

/// Petite poignée visuelle (3 points), posée juste au-dessus d'une zone
/// interactive (tracé, grille de jeu...) : n'appartient pas à cette zone
/// (pas de `Listener`), donc fait naturellement partie de la page qui
/// défile -- un endroit dédié, toujours facile à saisir pour défiler, qui
/// ne risque jamais d'être confondu avec un geste de tracé/jeu. Utilisée
/// dans tous les onglets du Mode Libre pour bien encadrer le scroll.
class ScrollHandle extends StatelessWidget {
  const ScrollHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 44,
        height: 22,
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: AmaniColors.textPrimary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) const SizedBox(width: 4),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AmaniColors.textPrimary.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
