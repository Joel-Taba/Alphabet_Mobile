import 'package:flutter/widgets.dart';

/// Liste de sliver dont aucun élément n'est détruit quand il sort de l'écran.
///
/// Par défaut, `SliverList` détruit les éléments hors écran puis les recrée
/// au retour : un tracé en cours, une réponse tapée ou un dessin de feuille
/// libre seraient alors perdus après un simple aller-retour de défilement.
/// Les pages d'exercice sont courtes : les garder toutes en mémoire est sans
/// coût notable.
SliverChildListDelegate keepAliveListDelegate(List<Widget> children) =>
    SliverChildListDelegate([
      for (final child in children)
        _KeepAliveItem(
          // Conserve la correspondance par clé de `SliverChildListDelegate`
          // (sinon un élément inséré/retiré décalerait les états voisins).
          key: child.key == null ? null : ValueKey(child.key),
          child: child,
        ),
    ]);

class _KeepAliveItem extends StatefulWidget {
  final Widget child;

  const _KeepAliveItem({super.key, required this.child});

  @override
  State<_KeepAliveItem> createState() => _KeepAliveItemState();
}

class _KeepAliveItemState extends State<_KeepAliveItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
