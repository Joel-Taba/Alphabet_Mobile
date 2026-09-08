import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/amani_theme.dart';
import 'sign_glyph.dart';

/// Découpe une carte en forme de pièce de puzzle : un onglet (bosse) au
/// milieu du bord droit et une encoche (creux) au milieu du bord gauche, de
/// même rayon, pour que deux pièces posées côte à côte s'emboîtent
/// visuellement l'une dans l'autre — coins légèrement arrondis pour rester
/// dans le langage visuel du reste de l'app.
class PuzzlePieceClipper extends CustomClipper<Path> {
  final double tabRadius;
  final double cornerRadius;

  const PuzzlePieceClipper({this.tabRadius = 11, this.cornerRadius = 10});

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final r = cornerRadius.clamp(0.0, math.min(w, h) / 2);
    final tabR = tabRadius.clamp(0.0, h / 2 - r - 1);
    final midY = h / 2;

    return Path()
      ..moveTo(r, 0)
      ..lineTo(w - r, 0)
      ..arcToPoint(Offset(w, r), radius: Radius.circular(r))
      ..lineTo(w, midY - tabR)
      ..arcToPoint(
        Offset(w, midY + tabR),
        radius: Radius.circular(tabR),
        clockwise: true,
      )
      ..lineTo(w, h - r)
      ..arcToPoint(Offset(w - r, h), radius: Radius.circular(r))
      ..lineTo(r, h)
      ..arcToPoint(Offset(0, h - r), radius: Radius.circular(r))
      ..lineTo(0, midY + tabR)
      ..arcToPoint(
        Offset(0, midY - tabR),
        radius: Radius.circular(tabR),
        clockwise: true,
      )
      ..lineTo(0, r)
      ..arcToPoint(Offset(r, 0), radius: Radius.circular(r))
      ..close();
  }

  @override
  bool shouldReclip(covariant PuzzlePieceClipper oldClipper) =>
      oldClipper.tabRadius != tabRadius ||
      oldClipper.cornerRadius != cornerRadius;
}

enum PuzzlePieceState { idle, placed, locked }

/// Une carte-pièce de puzzle portant un signe (icône générique + libellé),
/// pour le Palier 2 — jeu "Formule en puzzle" (voir
/// `exercice_puzzle_formule_screen.dart`) : l'enfant doit choisir, dans le
/// bon ordre, les pièces correspondant aux signes qui composent une lettre
/// ou un chiffre, parmi des pièces supplémentaires n'en faisant pas partie.
class PuzzlePieceCard extends StatefulWidget {
  final String family;
  final String variant;
  final String label;
  final Color accentColor;
  final PuzzlePieceState state;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const PuzzlePieceCard({
    super.key,
    required this.family,
    required this.variant,
    required this.label,
    required this.accentColor,
    this.state = PuzzlePieceState.idle,
    this.onTap,
    this.width = 88,
    this.height = 92,
  });

  @override
  State<PuzzlePieceCard> createState() => PuzzlePieceCardState();
}

class PuzzlePieceCardState extends State<PuzzlePieceCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeCtrl;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  /// Petite secousse horizontale — retour visuel sur une pièce tapée au
  /// mauvais moment (pièce piège, ou bonne pièce hors ordre), sans jamais
  /// la retirer du plateau : l'enfant peut retenter immédiatement.
  void shake() => _shakeCtrl.forward(from: 0);

  @override
  Widget build(BuildContext context) {
    final locked = widget.state == PuzzlePieceState.locked;
    final placed = widget.state == PuzzlePieceState.placed;
    final family = signFamilyFromKey(widget.family) ?? SignFamily.trait;

    return AnimatedBuilder(
      animation: _shakeCtrl,
      builder: (context, child) {
        final t = _shakeCtrl.value;
        final dx = math.sin(t * math.pi * 6) * (1 - t) * 7;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Opacity(
        opacity: locked ? 0.4 : 1,
        child: GestureDetector(
          onTap: locked ? null : widget.onTap,
          child: ClipPath(
            clipper: const PuzzlePieceClipper(),
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: placed
                    ? widget.accentColor.withValues(alpha: 0.14)
                    : Colors.white,
                border: Border.all(
                  color: placed
                      ? AmaniColors.secondary.withValues(alpha: 0.7)
                      : widget.accentColor.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              alignment: Alignment.center,
              // Icône et texte mis à l'échelle de la hauteur réellement
              // allouée (plutôt que des tailles fixes) : `PuzzlePieceCard`
              // est utilisée à deux tailles différentes (pioche et
              // séquence assemblée) — un contenu de taille fixe déborderait
              // dans la plus petite des deux.
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final iconSize = (constraints.maxHeight * 0.36).clamp(
                    20.0,
                    36.0,
                  );
                  final fontSize = (constraints.maxHeight * 0.1).clamp(
                    8.0,
                    10.0,
                  );
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SignGlyph(
                        family: family,
                        variant: widget.variant,
                        stroke: widget.accentColor,
                        size: iconSize,
                      ),
                      const SizedBox(height: 3),
                      Flexible(
                        child: Text(
                          widget.label,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w700,
                            fontSize: fontSize,
                            height: 1.1,
                            color: AmaniColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
