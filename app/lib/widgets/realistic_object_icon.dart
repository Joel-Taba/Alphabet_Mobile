import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Illustration détaillée et ombrée d'un objet du quotidien, pour le
/// mini-jeu "Quel objet a cette forme ?" — remplace un simple emoji par un
/// dessin vectoriel avec dégradés/reliefs pour un rendu plus réaliste, sans
/// dépendre d'assets photo externes. [objectKey] vient de
/// `SHAPE_OBJECT_KEY` (shape_catalog.dart) : 'window' | 'door' | 'pizza' |
/// 'ball'.
class RealisticObjectIcon extends StatelessWidget {
  final String objectKey;
  final double size;

  const RealisticObjectIcon({
    super.key,
    required this.objectKey,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _painterFor(objectKey)),
    );
  }

  CustomPainter _painterFor(String key) {
    switch (key) {
      case 'door':
        return _DoorPainter();
      case 'pizza':
        return _PizzaPainter();
      case 'ball':
        return _BallPainter();
      case 'window':
      default:
        return _WindowPainter();
    }
  }
}

/// Fenêtre : cadre bois, 4 carreaux de verre bleuté avec reflet, appui.
class _WindowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100;
    void scaled(void Function(Canvas c) draw) {
      canvas.save();
      canvas.scale(s);
      draw(canvas);
      canvas.restore();
    }

    scaled((c) {
      // Appui de fenêtre.
      final sill = Paint()..color = const Color(0xFF8A5A34);
      c.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(6, 86, 88, 8),
          const Radius.circular(2),
        ),
        sill,
      );

      // Cadre extérieur bois.
      final frameRect = const Rect.fromLTWH(10, 8, 80, 80);
      final framePaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFB07A45), Color(0xFF8A5A2E)],
        ).createShader(frameRect);
      c.drawRRect(
        RRect.fromRectAndRadius(frameRect, const Radius.circular(6)),
        framePaint,
      );

      // Verre (fond bleu ciel dégradé).
      final glassRect = const Rect.fromLTWH(16, 14, 68, 68);
      final glassPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFCDEBF7), Color(0xFF8FCBE0)],
        ).createShader(glassRect);
      c.drawRect(glassRect, glassPaint);

      // Croisillon (4 carreaux).
      final mullion = Paint()
        ..color = const Color(0xFF8A5A2E)
        ..strokeWidth = 4;
      c.drawLine(
        Offset(glassRect.left, glassRect.center.dy),
        Offset(glassRect.right, glassRect.center.dy),
        mullion,
      );
      c.drawLine(
        Offset(glassRect.center.dx, glassRect.top),
        Offset(glassRect.center.dx, glassRect.bottom),
        mullion,
      );

      // Reflets diagonaux sur chaque carreau.
      final glint = Paint()
        ..color = Colors.white.withValues(alpha: 0.55)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      c.drawLine(const Offset(22, 34), const Offset(34, 22), glint);
      c.drawLine(const Offset(58, 68), const Offset(70, 56), glint);

      // Contour cadre.
      final outline = Paint()
        ..color = const Color(0xFF5E3B1C)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      c.drawRRect(
        RRect.fromRectAndRadius(frameRect, const Radius.circular(6)),
        outline,
      );
    });
  }

  @override
  bool shouldRepaint(covariant _WindowPainter oldDelegate) => false;
}

/// Porte en bois avec panneaux, poignée ronde et charnières.
class _DoorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100;
    canvas.save();
    canvas.scale(s);

    final doorRect = const Rect.fromLTWH(22, 4, 56, 92);

    // Ombre portée douce.
    final shadow = Paint()..color = Colors.black.withValues(alpha: 0.12);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        doorRect.translate(2, 3),
        const Radius.circular(4),
      ),
      shadow,
    );

    // Battant bois avec dégradé (relief).
    final doorPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFA9744A), Color(0xFF7A4E2B)],
      ).createShader(doorRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(doorRect, const Radius.circular(4)),
      doorPaint,
    );

    // Panneaux en relief (2 rectangles biseautés).
    final panelStroke = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final panelHighlight = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (final rect in [
      const Rect.fromLTWH(30, 14, 40, 32),
      const Rect.fromLTWH(30, 54, 40, 32),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(3)),
        panelStroke,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect.deflate(2),
          const Radius.circular(2),
        ),
        panelHighlight,
      );
    }

    // Poignée dorée ronde + ombre.
    final knobShadow = Paint()..color = Colors.black.withValues(alpha: 0.2);
    canvas.drawCircle(const Offset(69, 51), 4.5, knobShadow);
    final knobPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFF3D48A), Color(0xFFB8862E)],
      ).createShader(const Rect.fromLTWH(63, 44, 12, 12));
    canvas.drawCircle(const Offset(67, 49), 4.5, knobPaint);

    // Contour de la porte.
    final outline = Paint()
      ..color = const Color(0xFF4A2E17)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawRRect(
      RRect.fromRectAndRadius(doorRect, const Radius.circular(4)),
      outline,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DoorPainter oldDelegate) => false;
}

/// Part de pizza : croûte dorée, fromage fondu, pepperoni et basilic.
class _PizzaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100;
    canvas.save();
    canvas.scale(s);

    final path = Path()
      ..moveTo(50, 8)
      ..lineTo(88, 88)
      ..lineTo(12, 88)
      ..close();

    // Ombre douce.
    canvas.drawShadow(path.shift(const Offset(0, 2)), Colors.black, 3, false);

    // Fromage (dégradé jaune/orangé, plus clair au centre).
    final cheesePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0, -0.3),
        radius: 0.9,
        colors: [Color(0xFFFFE28A), Color(0xFFF6B93B)],
      ).createShader(const Rect.fromLTWH(12, 8, 76, 80));
    canvas.drawPath(path, cheesePaint);

    // Croûte (arc doré en bas).
    final crustPaint = Paint()
      ..color = const Color(0xFFE0A458)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(14, 86), const Offset(86, 86), crustPaint);
    final crustHighlight = Paint()
      ..color = const Color(0xFFF3CE8E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      const Offset(18, 83),
      const Offset(82, 83),
      crustHighlight,
    );

    // Pepperoni (cercles rouge-brun avec reflet).
    for (final c in [
      const Offset(50, 34),
      const Offset(36, 56),
      const Offset(62, 58),
      const Offset(48, 74),
    ]) {
      canvas.drawCircle(c, 7, Paint()..color = const Color(0xFFB6402C));
      canvas.drawCircle(c, 7, Paint()
        ..color = const Color(0xFF7C2415)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1);
      canvas.drawCircle(
        c.translate(-2, -2),
        2,
        Paint()..color = Colors.white.withValues(alpha: 0.35),
      );
    }

    // Basilic (petites touches vertes).
    final basil = Paint()..color = const Color(0xFF4C7A3E);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(30, 40), width: 7, height: 4),
      basil,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(68, 42), width: 7, height: 4),
      basil,
    );

    // Contour.
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFC97B2E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PizzaPainter oldDelegate) => false;
}

/// Ballon de foot : sphère blanche ombrée + pentagones noirs, reflet.
class _BallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100;
    canvas.save();
    canvas.scale(s);

    const center = Offset(50, 50);
    const radius = 42.0;

    // Ombre portée au sol.
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(50, 90), width: 50, height: 8),
      Paint()..color = Colors.black.withValues(alpha: 0.15),
    );

    // Sphère blanche avec ombrage radial (volume).
    final spherePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.35, -0.4),
        radius: 1.1,
        colors: [Colors.white, Color(0xFFD8D8D8)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, spherePaint);

    // Pentagones noirs (motif ballon simplifié).
    final black = Paint()..color = const Color(0xFF232323);
    void pentagon(Offset c, double r, double rotation) {
      final path = Path();
      for (var i = 0; i < 5; i++) {
        final angle = rotation + i * 2 * 3.14159265 / 5 - 3.14159265 / 2;
        final p = Offset(c.dx + r * math.cos(angle), c.dy + r * math.sin(angle));
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      canvas.drawPath(path, black);
    }

    pentagon(const Offset(50, 42), 13, 0);
    pentagon(const Offset(28, 60), 10, 0.5);
    pentagon(const Offset(72, 60), 10, -0.5);
    pentagon(const Offset(50, 82), 9, 0.2);

    // Reflet lumineux.
    canvas.drawCircle(
      const Offset(35, 32),
      7,
      Paint()..color = Colors.white.withValues(alpha: 0.55),
    );

    // Contour de la sphère.
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFFB0B0B0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BallPainter oldDelegate) => false;
}
