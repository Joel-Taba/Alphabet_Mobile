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

/// Page blanche de dessin libre, sans aucune cible ni validation — juste un
/// trait qui suit le doigt. Port fidèle de la partie "griffonnage" de
/// `src/routes/_app.bibliotheque.tsx`, avec en plus une véritable gomme à
/// effacement ciblé (comme un logiciel de dessin classique) plutôt qu'un
/// simple "tout effacer".
class ScribbleCanvas extends StatefulWidget {
  final Color penColor;
  const ScribbleCanvas({super.key, required this.penColor});

  @override
  State<ScribbleCanvas> createState() => ScribbleCanvasState();
}

class ScribbleCanvasState extends State<ScribbleCanvas> {
  final List<_Stroke> _strokes = [];
  bool _eraserMode = false;
  Offset? _pointerPos;

  bool get isEraserMode => _eraserMode;

  /// Bascule entre le crayon et la gomme (outil actif), comme dans un
  /// logiciel de dessin classique — appelé depuis le bouton gomme.
  void toggleEraser() => setState(() => _eraserMode = !_eraserMode);

  /// Efface tout le dessin (conservé pour un effacement complet rapide,
  /// déclenché par un appui long sur le bouton gomme).
  void clear() => setState(_strokes.clear);

  static const double _eraserWidth = 28;
  bool _drawing = false;

  /// Identifiant du doigt qui a démarré le trait en cours — voir
  /// `LetterTraceCell._activePointer` pour le raisonnement complet : sans ce
  /// suivi, un second doigt posé pendant qu'on dessine déjà (paume, doigt
  /// curieux d'un enfant...) redéclencherait `TracingScrollLock.start()` une
  /// deuxième fois alors qu'un seul `stop()` suivrait, bloquant le verrou
  /// pour le reste de la session.
  int? _activePointer;

  void _onPointerDown(PointerDownEvent event) {
    // Verrouille le défilement de la page pendant tout le tracé -- voir
    // `LetterTraceCell` pour l'explication complète du choix d'un
    // `Listener` (événements pointeur bruts) plutôt qu'un `GestureDetector`
    // à base de pan.
    if (_drawing || _activePointer != null) return;
    _activePointer = event.pointer;
    context.read<TracingScrollLock>().start();
    setState(() {
      _drawing = true;
      _pointerPos = event.localPosition;
      _strokes.add(
        _Stroke(color: widget.penColor, isEraser: _eraserMode)
          ..points.add(event.localPosition),
      );
    });
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_drawing || event.pointer != _activePointer) return;
    setState(() {
      _pointerPos = event.localPosition;
      _strokes.last.points.add(event.localPosition);
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    if (!_drawing || event.pointer != _activePointer) return;
    _activePointer = null;
    context.read<TracingScrollLock>().stop();
    setState(() {
      _drawing = false;
      _pointerPos = null;
    });
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (!_drawing || event.pointer != _activePointer) return;
    _activePointer = null;
    context.read<TracingScrollLock>().stop();
    setState(() {
      _drawing = false;
      _pointerPos = null;
    });
  }

  @override
  void dispose() {
    // Filet de sécurité : si le widget disparaît en plein tracé (par ex.
    // navigation), le verrou ne doit jamais rester bloqué.
    if (_drawing) {
      context.read<TracingScrollLock>().stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (e) => setState(() => _pointerPos = e.localPosition),
      onExit: (_) => setState(() => _pointerPos = null),
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,
        onPointerCancel: _onPointerCancel,
        child: CustomPaint(
          painter: _ScribblePainter(
            strokes: _strokes,
            eraserWidth: _eraserWidth,
            eraserPreview: _eraserMode ? _pointerPos : null,
            pencilTip: _eraserMode ? null : _pointerPos,
            penColor: widget.penColor,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _ScribblePainter extends CustomPainter {
  final List<_Stroke> strokes;
  final double eraserWidth;
  final Offset? eraserPreview;
  final Offset? pencilTip;
  final Color penColor;

  _ScribblePainter({
    required this.strokes,
    required this.eraserWidth,
    required this.eraserPreview,
    required this.pencilTip,
    required this.penColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Un calque intermédiaire est nécessaire pour que les traits de gomme
    // (BlendMode.clear) découpent réellement l'encre déjà posée en dessous,
    // plutôt que de simplement peindre par-dessus en blanc.
    canvas.saveLayer(Offset.zero & size, Paint());
    for (final stroke in strokes) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      if (stroke.isEraser) {
        paint
          ..blendMode = BlendMode.clear
          ..strokeWidth = eraserWidth;
      } else {
        paint
          ..color = stroke.color
          ..strokeWidth = 6;
      }
      if (stroke.points.length < 2) {
        if (stroke.points.isNotEmpty) {
          canvas.drawCircle(
            stroke.points.first,
            stroke.isEraser ? eraserWidth / 2 : 3,
            paint..style = PaintingStyle.fill,
          );
        }
        continue;
      }
      final path = Path()
        ..moveTo(stroke.points.first.dx, stroke.points.first.dy);
      for (final p in stroke.points.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, paint);
    }
    canvas.restore();

    // Aperçu de la zone d'effacement sous le doigt/curseur, pour voir
    // précisément ce qui va être effacé avant de tracer.
    if (eraserPreview != null) {
      canvas.drawCircle(
        eraserPreview!,
        eraserWidth / 2,
        Paint()
          ..color = const Color(0xFF4A3B2A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }

    // Petit crayon (pointe teintée de l'encre choisie) qui suit le doigt
    // pendant le tracé, en écho fidèle au curseur en forme de stylo de la
    // version Web (`getPenCursor` dans `_app.bibliotheque.tsx`) — la pointe
    // de la mine touche exactement le point dessiné.
    if (pencilTip != null) {
      _drawPencil(canvas, pencilTip!);
    }
  }

  void _drawPencil(Canvas canvas, Offset tip) {
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
