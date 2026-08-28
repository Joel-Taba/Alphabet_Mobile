import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../data/tangram_catalog.dart';
import '../theme/amani_theme.dart';

/// Plateau de tangram interactif : affiche la silhouette cible (chaque case
/// délimitée par le contour de la pièce qui doit s'y trouver) et un bac de
/// pièces à glisser-déposer au bon endroit. Après [kMaxMissesBeforeHint]
/// essais ratés, la case de la DERNIÈRE pièce choisie se met à clignoter
/// pour guider l'enfant.
class TangramBoard extends StatefulWidget {
  final TangramPuzzle puzzle;
  final VoidCallback? onSolved;
  final double unitSize;

  /// Affiche le puzzle déjà résolu (toutes les pièces en place, bac vide),
  /// sans jeu possible — pour l'aperçu non interactif du Cours.
  final bool startSolved;

  const TangramBoard({
    super.key,
    required this.puzzle,
    this.onSolved,
    this.unitSize = 52,
    this.startSolved = false,
  });

  @override
  State<TangramBoard> createState() => TangramBoardState();
}

const int kMaxMissesBeforeHint = 3;

/// Marge interne (en unités) tout autour de la silhouette — sans elle, une
/// pièce dont un sommet touche exactement le bord du plateau se retrouve
/// avec son contour rogné par le `clipBehavior` du conteneur (le trait de
/// 2px déborde légèrement du polygone rempli). Le plateau est donc toujours
/// rendu un peu plus grand que `boardWidth`×`boardHeight`, avec tout le
/// contenu décalé de cette marge.
const double _kBoardMargin = 0.25;

class TangramBoardState extends State<TangramBoard> {
  final Set<String> _placed = {};
  late List<String> _trayOrder;
  String? _lastAttemptedPieceId;
  int _missCount = 0;
  final GlobalKey _boardKey = GlobalKey();

  bool get isSolved => _placed.length == widget.puzzle.placements.length;

  @override
  void initState() {
    super.initState();
    _resetState();
  }

  @override
  void didUpdateWidget(covariant TangramBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.puzzle.id != widget.puzzle.id) _resetState();
  }

  void _resetState() {
    _placed.clear();
    _missCount = 0;
    _lastAttemptedPieceId = null;
    if (widget.startSolved) {
      _placed.addAll(widget.puzzle.placements.map((p) => p.pieceId));
      _trayOrder = [];
      return;
    }
    _trayOrder = widget.puzzle.placements.map((p) => p.pieceId).toList()
      ..shuffle(math.Random(widget.puzzle.id.hashCode));
  }

  /// Remet le puzzle à zéro (bouton "Relancer" de l'écran appelant).
  void restart() => setState(_resetState);

  TangramPlacement _placementFor(String id) =>
      widget.puzzle.placements.firstWhere((p) => p.pieceId == id);

  /// Placer une pièce exactement dans son contour (point du relâchement
  /// strictement à l'intérieur du polygone) est bien trop exigeant pour de
  /// jeunes enfants au doigt/curseur peu précis — surtout sur les pointes
  /// fines des triangles. On accepte donc plutôt toute dépose "assez
  /// proche" du centre de LA bonne case pour cette pièce (peu importe où
  /// exactement dans la case, et peu importe les autres cases sous le
  /// doigt) — un rayon de tolérance généreux, proportionné à la taille de
  /// la pièce elle-même.
  bool _isCloseEnough(TangramPlacement placement, Offset unitPos) {
    final centroid = _centroid(placement.targetPoints);
    final radius = _boundingRadius(placement.targetPoints);
    // Au moins ~1.1 unité de tolérance même pour les toutes petites pièces,
    // et jusqu'à 100% du rayon de la pièce pour les plus grandes — généreux
    // à dessein pour de jeunes enfants au doigt peu précis.
    final tolerance = math.max(1.1, radius);
    return (unitPos - centroid).distance <= tolerance;
  }

  void _handleDrop(String pieceId, Offset globalOffset, double unitSize) {
    final box = _boardKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(globalOffset);
    // `globalOffset` est le coin haut-gauche du widget-pièce glissé (repère
    // local à la pièce, où (0,0) = coin haut-gauche de SA propre boîte
    // englobante — voir `_TrayPiece._localShape`), pas son centre. Comparer
    // ce point directement au centre (`centroid`) de la case cible dans
    // `_isCloseEnough` sous-estimait fortement la tolérance réelle pour les
    // grandes pièces asymétriques (l'écart coin/centre pouvait à lui seul
    // dépasser la tolérance). On recentre donc `unitPos` sur le centre réel
    // de LA pièce avant de comparer. `unitSize` est la taille EFFECTIVE
    // (potentiellement réduite pour tenir dans l'espace disponible — voir
    // `build`), pas `widget.unitSize` : sinon la conversion pixels→unités
    // ne correspondrait plus à ce qui est réellement affiché.
    final correctSlot = _placementFor(pieceId);
    final pts = correctSlot.targetPoints;
    final minX = pts.map((p) => p.dx).reduce(math.min);
    final minY = pts.map((p) => p.dy).reduce(math.min);
    final pieceCentroidOffset = _centroid(pts) - Offset(minX, minY);
    final unitPos =
        Offset(
          local.dx / unitSize - _kBoardMargin,
          local.dy / unitSize - _kBoardMargin,
        ) +
        pieceCentroidOffset;
    if (!_placed.contains(pieceId) && _isCloseEnough(correctSlot, unitPos)) {
      setState(() {
        _placed.add(pieceId);
        _trayOrder.remove(pieceId);
        _missCount = 0;
        _lastAttemptedPieceId = null;
      });
      if (isSolved) widget.onSolved?.call();
    } else {
      setState(() {
        _missCount++;
        _lastAttemptedPieceId = pieceId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final showHint =
        _missCount >= kMaxMissesBeforeHint && _lastAttemptedPieceId != null;

    // `unitSize` est un MAXIMUM, pas une taille fixe : sur les silhouettes
    // les plus sophistiquées (larges, tenant sur beaucoup d'unités), on
    // réduit plutôt la taille de chaque unité pour occuper toute la largeur
    // disponible sans jamais déborder — au lieu de forcer un unitSize
    // constant qui aurait soit gâché l'espace sur les petites silhouettes,
    // soit fait déborder les plus grandes hors de l'écran.
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalUnitsWidth = widget.puzzle.boardWidth + 2 * _kBoardMargin;
        final maxUnitSizeForWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth / totalUnitsWidth
            : widget.unitSize;
        final effectiveUnitSize = math.min(
          widget.unitSize,
          maxUnitSizeForWidth,
        );
        final boardWidthPx = totalUnitsWidth * effectiveUnitSize;
        final boardHeightPx =
            (widget.puzzle.boardHeight + 2 * _kBoardMargin) * effectiveUnitSize;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DragTarget<String>(
              onWillAcceptWithDetails: (_) => true,
              onAcceptWithDetails: (details) =>
                  _handleDrop(details.data, details.offset, effectiveUnitSize),
              builder: (context, candidate, rejected) {
                return Container(
                  key: _boardKey,
                  width: boardWidthPx,
                  height: boardHeightPx,
                  decoration: BoxDecoration(
                    color: AmaniColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      for (final p in widget.puzzle.placements)
                        _SlotView(
                          placement: p,
                          unitSize: effectiveUnitSize,
                          placed: _placed.contains(p.pieceId),
                          hinted:
                              showHint && p.pieceId == _lastAttemptedPieceId,
                        ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 18),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final id in _trayOrder)
                  _TrayPiece(
                    placement: _placementFor(id),
                    unitSize: effectiveUnitSize,
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

Offset _centroid(List<Offset> poly) {
  var sx = 0.0, sy = 0.0;
  for (final p in poly) {
    sx += p.dx;
    sy += p.dy;
  }
  return Offset(sx / poly.length, sy / poly.length);
}

/// Distance du centre au sommet le plus éloigné — sert de rayon "hitbox"
/// généreux pour la tolérance de dépose (voir `_isCloseEnough`).
double _boundingRadius(List<Offset> poly) {
  final center = _centroid(poly);
  var maxDist = 0.0;
  for (final p in poly) {
    final d = (p - center).distance;
    if (d > maxDist) maxDist = d;
  }
  return maxDist;
}

List<Offset> _localPolygon(TangramPlacement p, double unitSize) => p
    .targetPoints
    .map(
      (o) => Offset(
        (o.dx + _kBoardMargin) * unitSize,
        (o.dy + _kBoardMargin) * unitSize,
      ),
    )
    .toList();

/// Case de la silhouette : contour + léger remplissage tant que la pièce
/// n'est pas posée, remplissage plein une fois posée, halo clignotant en
/// cas d'indice (3 essais ratés sur cette pièce).
class _SlotView extends StatefulWidget {
  final TangramPlacement placement;
  final double unitSize;
  final bool placed;
  final bool hinted;

  const _SlotView({
    required this.placement,
    required this.unitSize,
    required this.placed,
    required this.hinted,
  });

  @override
  State<_SlotView> createState() => _SlotViewState();
}

class _SlotViewState extends State<_SlotView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 550),
  );

  @override
  void initState() {
    super.initState();
    if (widget.hinted) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _SlotView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hinted && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.hinted && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final points = _localPolygon(widget.placement, widget.unitSize);
    final color = Color(widget.placement.colorValue);
    if (!widget.hinted) {
      return CustomPaint(
        size: Size.infinite,
        painter: _SlotPainter(
          points: points,
          color: color,
          placed: widget.placed,
          glow: 0,
        ),
      );
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _SlotPainter(
            points: points,
            color: color,
            placed: widget.placed,
            glow: _controller.value,
          ),
        );
      },
    );
  }
}

class _SlotPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final bool placed;
  final double glow;

  const _SlotPainter({
    required this.points,
    required this.color,
    required this.placed,
    required this.glow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..addPolygon(points, true);

    if (placed) {
      canvas.drawPath(path, Paint()..color = color);
      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
      return;
    }

    canvas.drawPath(path, Paint()..color = color.withValues(alpha: 0.08));
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    if (glow > 0) {
      canvas.drawPath(
        path,
        Paint()
          ..color = AmaniColors.secondary.withValues(alpha: 0.25 + glow * 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4 + glow * 3,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SlotPainter old) =>
      old.placed != placed || old.glow != glow || old.color != color;
}

/// Pièce du bac, glissable — dessinée dans SA propre orientation cible
/// (celle de sa case), pour que l'enfant n'ait qu'à la déplacer, jamais à
/// la faire pivoter.
class _TrayPiece extends StatelessWidget {
  final TangramPlacement placement;
  final double unitSize;

  const _TrayPiece({required this.placement, required this.unitSize});

  ({List<Offset> points, Size size}) _localShape() {
    final pts = placement.targetPoints;
    final minX = pts.map((p) => p.dx).reduce(math.min);
    final maxX = pts.map((p) => p.dx).reduce(math.max);
    final minY = pts.map((p) => p.dy).reduce(math.min);
    final maxY = pts.map((p) => p.dy).reduce(math.max);
    final local = pts
        .map((p) => Offset((p.dx - minX) * unitSize, (p.dy - minY) * unitSize))
        .toList();
    return (
      points: local,
      size: Size((maxX - minX) * unitSize, (maxY - minY) * unitSize),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shape = _localShape();
    final color = Color(placement.colorValue);
    final piece = CustomPaint(
      size: shape.size,
      painter: _PiecePainter(points: shape.points, color: color),
    );

    return Draggable<String>(
      data: placement.pieceId,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Opacity(opacity: 0.85, child: piece),
      childWhenDragging: Opacity(opacity: 0.25, child: piece),
      child: piece,
    );
  }
}

class _PiecePainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  const _PiecePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant _PiecePainter old) => false;
}
