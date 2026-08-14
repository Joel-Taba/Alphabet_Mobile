import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// Icône directionnelle (flèche retour, chevrons précédent/suivant) qui se
/// retourne automatiquement de 180° quand la mise en page est en RTL (arabe)
/// — équivalent de la classe Tailwind `rtl:rotate-180` côté web.
class DirectionalIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;

  const DirectionalIcon(this.icon, {super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    final icon0 = Icon(icon, size: size, color: color);
    if (Directionality.of(context) != TextDirection.rtl) return icon0;
    return Transform.rotate(angle: math.pi, child: icon0);
  }
}
