import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../hooks/use_tracing_scroll_lock.dart';

/// Un seul trait dessiné : ses points, sa couleur au moment du tracé (pour
/// que changer de couleur de crayon n'affecte jamais les traits déjà
/// dessinés), et si c'est un trait de gomme (effacement ciblé) plutôt que
/// d'encre.
class _Stroke {
  final List<Offset> points = [];
  final Color color;
  final bool isEraser;
  _Stroke({required this.color, required this.isEraser});
}

const double _kPenWidth = 6;
const double _kEraserWidth = 28;

/// Page blanche de dessin **totalement libre** : aucune cible, aucune
/// validation, aucune limite -- ni de nombre de traits, ni de doigts (chaque
/// doigt posé trace son propre trait, en même temps que les autres), ni de
/// durée. Port de la partie "griffonnage" de
/// `src/routes/_app.bibliotheque.tsx`, avec une vraie gomme à effacement
/// ciblé.
///
/// Performances : les traits terminés sont "cuits" dans une image
/// ([_baked]) au lâcher du doigt ; à chaque mouvement, seuls cette image et
/// les traits EN COURS sont repeints (via un simple `Listenable`, sans
/// reconstruire le widget). Auparavant, chaque mouvement de doigt
/// reconstruisait le widget et repeignait TOUS les traits depuis le début :
/// plus l'enfant gribouillait, plus chaque image coûtait cher, jusqu'à
/// faire ramer puis bloquer le tracé.
class ScribbleCanvas extends StatefulWidget {
  final Color penColor;
  const ScribbleCanvas({super.key, required this.penColor});

  @override
  State<ScribbleCanvas> createState() => ScribbleCanvasState();
}

class ScribbleCanvasState extends State<ScribbleCanvas> {
  /// Traits terminés, source de vérité (pour re-cuire l'image si la taille
  /// du canevas change, ex. rotation de l'écran).
  final List<_Stroke> _strokes = [];

  /// Traits en cours, un par doigt/pointeur posé.
  final Map<int, _Stroke> _live = {};

  ui.Image? _baked;
  Size _bakedSize = Size.zero;
  double _bakedRatio = 1;
  Size _size = Size.zero;

  bool _eraserMode = false;
  Offset? _hoverPos;

  /// Notifie le peintre sans reconstruire le widget.
  final ValueNotifier<int> _repaint = ValueNotifier(0);

  /// Référence au verrou de défilement, capturée tant que le contexte est
  /// valide : la relire via `context` dans `dispose()` est interdit par
  /// Flutter (ancêtre d'un élément déjà désactivé).
  TracingScrollLock? _lock;
  bool _lockHeld = false;

  bool get isEraserMode => _eraserMode;

  /// Bascule entre le crayon et la gomme (outil actif), comme dans un
  /// logiciel de dessin classique — appelé depuis le bouton gomme.
  void toggleEraser() {
    setState(() => _eraserMode = !_eraserMode);
    _repaint.value++;
  }

  /// Efface tout le dessin.
  void clear() {
    _strokes.clear();
    _live.clear();
    _baked?.dispose();
    _baked = null;
    _updateLock();
    _repaint.value++;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _lock = context.read<TracingScrollLock>();
  }

  /// Verrouille le défilement de la page tant qu'au moins un doigt dessine,
  /// et le relâche dès qu'il n'y en a plus -- un seul `start()`/`stop()` par
  /// canevas, quel que soit le nombre de doigts, pour que le compteur
  /// partagé ne puisse jamais rester bloqué.
  void _updateLock() {
    final want = _live.isNotEmpty;
    if (want == _lockHeld) return;
    _lockHeld = want;
    if (want) {
      _lock?.start();
    } else {
      _lock?.stop();
    }
  }

  void _onPointerDown(PointerDownEvent event) {
    // Un doigt peut encore bouger ou se relever après que la page a été
    // quittée : le canevas est alors déjà détruit.
    if (!mounted) return;
    // Souris, stylet, pavé tactile : un seul pointeur physique. Un trait
    // encore "en cours" pour ce type d'appareil est forcément orphelin (son
    // relâchement a été perdu, ex. bouton relâché hors de la fenêtre) : on
    // le termine au lieu de bloquer le nouveau trait.
    if (event.kind != PointerDeviceKind.touch) {
      for (final id in _live.keys.toList()) {
        _finish(id);
      }
    }
    _live[event.pointer] = _Stroke(
      color: widget.penColor,
      isEraser: _eraserMode,
    )..points.add(event.localPosition);
    _hoverPos = event.localPosition;
    _updateLock();
    _repaint.value++;
  }

  void _onPointerMove(PointerMoveEvent event) {
    // Un doigt peut encore bouger ou se relever après que la page a été
    // quittée : le canevas est alors déjà détruit.
    if (!mounted) return;
    final stroke = _live[event.pointer];
    if (stroke == null) return;
    final last = stroke.points.last;
    if ((event.localPosition - last).distanceSquared < 0.25) return;
    stroke.points.add(event.localPosition);
    _hoverPos = event.localPosition;
    _repaint.value++;
  }

  void _onPointerUp(PointerUpEvent event) {
    // Un doigt peut encore bouger ou se relever après que la page a été
    // quittée : le canevas est alors déjà détruit.
    if (!mounted) return;
    _finish(event.pointer);
    if (event.kind == PointerDeviceKind.touch) _hoverPos = null;
    _repaint.value++;
  }

  void _onPointerCancel(PointerCancelEvent event) {
    // Un doigt peut encore bouger ou se relever après que la page a été
    // quittée : le canevas est alors déjà détruit.
    if (!mounted) return;
    _finish(event.pointer);
    _hoverPos = null;
    _repaint.value++;
  }

  /// Termine le trait du pointeur [id] et le cuit dans l'image.
  void _finish(int id) {
    final stroke = _live.remove(id);
    _updateLock();
    if (stroke == null) return;
    _strokes.add(stroke);
    _bake([stroke], onTopOfExisting: true);
  }

  /// Dessine [strokes] dans l'image cuite (par-dessus l'existante, ou en
  /// repartant de zéro), à la résolution réelle de l'écran.
  void _bake(List<_Stroke> strokes, {required bool onTopOfExisting}) {
    if (_size.isEmpty) return;
    final ratio = View.maybeOf(context)?.devicePixelRatio ?? 1.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.scale(ratio);
    canvas.saveLayer(Offset.zero & _size, Paint());
    final previous = _baked;
    if (onTopOfExisting && previous != null) {
      canvas.drawImageRect(
        previous,
        Offset.zero &
            Size(previous.width.toDouble(), previous.height.toDouble()),
        Offset.zero & _bakedSize,
        Paint()..filterQuality = FilterQuality.medium,
      );
    }
    for (final s in strokes) {
      _paintStroke(canvas, s);
    }
    canvas.restore();
    final picture = recorder.endRecording();
    _baked = picture.toImageSync(
      math.max(1, (_size.width * ratio).ceil()),
      math.max(1, (_size.height * ratio).ceil()),
    );
    picture.dispose();
    previous?.dispose();
    _bakedSize = _size;
    _bakedRatio = ratio;
  }

  /// La taille du canevas a changé (ou première mise en page) : on re-cuit
  /// tout le dessin à la nouvelle taille.
  void _onSize(Size size) {
    if (size == _size) return;
    _size = size;
    _baked?.dispose();
    _baked = null;
    if (_strokes.isNotEmpty) _bake(_strokes, onTopOfExisting: false);
  }

  @override
  void dispose() {
    // Filet de sécurité : si le widget disparaît en plein tracé (par ex.
    // navigation), le verrou ne doit jamais rester bloqué.
    _live.clear();
    _updateLock();
    _baked?.dispose();
    _repaint.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _onSize(constraints.biggest);
        return MouseRegion(
          onHover: (e) {
            _hoverPos = e.localPosition;
            _repaint.value++;
          },
          onExit: (_) {
            if (_live.isEmpty) {
              _hoverPos = null;
              _repaint.value++;
            }
          },
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: _onPointerDown,
            onPointerMove: _onPointerMove,
            onPointerUp: _onPointerUp,
            onPointerCancel: _onPointerCancel,
            child: CustomPaint(
              size: constraints.biggest,
              painter: _ScribblePainter(this),
            ),
          ),
        );
      },
    );
  }
}

void _paintStroke(Canvas canvas, _Stroke stroke) {
  final paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  if (stroke.isEraser) {
    paint
      ..blendMode = BlendMode.clear
      ..strokeWidth = _kEraserWidth;
  } else {
    paint
      ..color = stroke.color
      ..strokeWidth = _kPenWidth;
  }
  if (stroke.points.length < 2) {
    // Un simple toucher dessine un point.
    canvas.drawCircle(
      stroke.points.first,
      (stroke.isEraser ? _kEraserWidth : _kPenWidth) / 2,
      paint..style = PaintingStyle.fill,
    );
    return;
  }
  final path = Path()..moveTo(stroke.points.first.dx, stroke.points.first.dy);
  for (final p in stroke.points.skip(1)) {
    path.lineTo(p.dx, p.dy);
  }
  canvas.drawPath(path, paint);
}

class _ScribblePainter extends CustomPainter {
  final ScribbleCanvasState state;
  _ScribblePainter(this.state) : super(repaint: state._repaint);

  @override
  void paint(Canvas canvas, Size size) {
    // Un calque intermédiaire est nécessaire pour que les traits de gomme
    // (BlendMode.clear) découpent réellement l'encre déjà posée en dessous,
    // plutôt que de simplement peindre par-dessus en blanc.
    canvas.saveLayer(Offset.zero & size, Paint());
    final baked = state._baked;
    if (baked != null) {
      canvas.drawImageRect(
        baked,
        Offset.zero & Size(baked.width.toDouble(), baked.height.toDouble()),
        Offset.zero &
            Size(
              baked.width / state._bakedRatio,
              baked.height / state._bakedRatio,
            ),
        Paint()..filterQuality = FilterQuality.medium,
      );
    }
    for (final s in state._live.values) {
      _paintStroke(canvas, s);
    }
    canvas.restore();

    final pos = state._hoverPos;
    if (pos == null) return;
    if (state._eraserMode) {
      // Aperçu de la zone d'effacement sous le doigt/curseur.
      canvas.drawCircle(
        pos,
        _kEraserWidth / 2,
        Paint()
          ..color = const Color(0xFF4A3B2A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    } else {
      // Petit crayon (pointe teintée de l'encre choisie) qui suit le doigt,
      // en écho au curseur en forme de stylo de la version Web.
      _drawPencil(canvas, pos, state.widget.penColor);
    }
  }

  void _drawPencil(Canvas canvas, Offset tip, Color penColor) {
    // Le curseur Web est un SVG 26×26 dont le point d'ancrage (la mine)
    // se trouve en (21, 21) ; on translate donc toute la forme pour que ce
    // point coïncide exactement avec le point de contact réel.
    final offset = tip - const Offset(21, 21);
    Offset p(double x, double y) => Offset(x, y) + offset;
    final outline = Paint()
      ..color = const Color(0xFF4A3B2A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeJoin = StrokeJoin.round;

    // Gomme du crayon (petit rectangle gris à l'extrémité opposée à la mine).
    canvas.drawPath(
      Path()
        ..moveTo(p(2, 6.5).dx, p(2, 6.5).dy)
        ..lineTo(p(6.5, 2).dx, p(6.5, 2).dy)
        ..lineTo(p(8.6, 4.1).dx, p(8.6, 4.1).dy)
        ..lineTo(p(4.1, 8.6).dx, p(4.1, 8.6).dy)
        ..close(),
      Paint()..color = const Color(0xFF9C8F79),
    );
    canvas.drawPath(
      Path()
        ..moveTo(p(2, 6.5).dx, p(2, 6.5).dy)
        ..lineTo(p(6.5, 2).dx, p(6.5, 2).dy)
        ..lineTo(p(8.6, 4.1).dx, p(8.6, 4.1).dy)
        ..lineTo(p(4.1, 8.6).dx, p(4.1, 8.6).dy)
        ..close(),
      outline,
    );

    // Corps doré du crayon.
    canvas.drawPath(
      Path()
        ..moveTo(p(4.1, 8.6).dx, p(4.1, 8.6).dy)
        ..lineTo(p(8.6, 4.1).dx, p(8.6, 4.1).dy)
        ..lineTo(p(19.3, 14.7).dx, p(19.3, 14.7).dy)
        ..lineTo(p(14.7, 19.3).dx, p(14.7, 19.3).dy)
        ..close(),
      Paint()..color = const Color(0xFFE8B84D),
    );
    canvas.drawPath(
      Path()
        ..moveTo(p(4.1, 8.6).dx, p(4.1, 8.6).dy)
        ..lineTo(p(8.6, 4.1).dx, p(8.6, 4.1).dy)
        ..lineTo(p(19.3, 14.7).dx, p(19.3, 14.7).dy)
        ..lineTo(p(14.7, 19.3).dx, p(14.7, 19.3).dy)
        ..close(),
      outline,
    );

    // Pointe de la mine, teintée de la couleur d'encre choisie.
    canvas.drawPath(
      Path()
        ..moveTo(p(14.7, 19.3).dx, p(14.7, 19.3).dy)
        ..lineTo(p(19.3, 14.7).dx, p(19.3, 14.7).dy)
        ..lineTo(p(21.2, 21.2).dx, p(21.2, 21.2).dy)
        ..close(),
      Paint()..color = penColor,
    );
    canvas.drawPath(
      Path()
        ..moveTo(p(14.7, 19.3).dx, p(14.7, 19.3).dy)
        ..lineTo(p(19.3, 14.7).dx, p(19.3, 14.7).dy)
        ..lineTo(p(21.2, 21.2).dx, p(21.2, 21.2).dy)
        ..close(),
      outline,
    );
  }

  @override
  bool shouldRepaint(covariant _ScribblePainter oldDelegate) => true;
}
