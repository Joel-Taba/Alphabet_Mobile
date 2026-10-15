import 'package:flutter/material.dart';

/// [Text] dont aucun mot n'est jamais coupé en deux (« proportionnalit / é »,
/// « Le cro / chet ») quand le texte est agrandi (Taille de l'interface,
/// police dyslexie) : si le mot le plus long ne tient pas sur la largeur
/// disponible, tout le texte est réduit juste assez pour qu'il y tienne. Le
/// reste du temps, il s'affiche exactement comme un [Text] normal.
class UnbrokenText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const UnbrokenText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final effective = DefaultTextStyle.of(context).style.merge(style);
    final direction = Directionality.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        var fitted = scaler;
        if (constraints.maxWidth.isFinite) {
          // Plus long bloc insécable, selon les règles de coupure du moteur de
          // texte lui-même (« commencer ? » ne se coupe pas avant le « ? »).
          final painter = TextPainter(
            text: TextSpan(text: data, style: effective),
            textDirection: direction,
            textScaler: scaler,
          )..layout();
          final longest = painter.minIntrinsicWidth;
          painter.dispose();
          // Petite marge : l'arrondi du moteur de texte suffit sinon à
          // renvoyer la dernière lettre à la ligne.
          final available = constraints.maxWidth - 1;
          if (available > 0 && longest > available) {
            final base = effective.fontSize ?? 14;
            final current = scaler.scale(base) / base;
            fitted = TextScaler.linear(current * available / longest);
          }
        }
        return Text(
          data,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          textScaler: fitted,
        );
      },
    );
  }
}
