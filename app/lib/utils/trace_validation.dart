/// Validation partagée du tracé (cours & exercices) : échantillonnage d'un
/// chemin SVG de référence et comparaison avec le tracé de l'utilisateur selon
/// 5 critères (couverture, respect du couloir, ordre, départ, arrivée).
/// Port fidèle de `src/lib/traceValidation.ts`.
library;

import 'dart:math' as math;
import 'dart:ui' show Offset;
import 'package:path_drawing/path_drawing.dart';

class ValidationResult {
  final bool valid;
  final double coverage;
  final String? failReason;
  const ValidationResult(this.valid, this.coverage, [this.failReason]);
}

/// Point de départ réel d'un chemin SVG — dérivé du tracé lui-même plutôt que
/// d'un champ `startXY` saisi séparément dans un catalogue, pour qu'un repère
/// de départ (pastille verte) tombe toujours exactement sur l'origine du
/// tracé qu'il annote, même si ce champ a été mal renseigné ou si le tracé a
/// été retouché depuis sans mettre à jour ce champ.
Offset pathStartPoint(String pathD) {
  final pts = sampleSvgPath(pathD, 2);
  return pts.isNotEmpty ? pts.first : Offset.zero;
}

/// Point d'arrivée réel d'un chemin SVG — voir [pathStartPoint].
Offset pathEndPoint(String pathD) {
  final pts = sampleSvgPath(pathD, 2);
  return pts.length > 1 ? pts.last : Offset.zero;
}

/// Échantillonne un chemin SVG en N points régulièrement espacés.
List<Offset> sampleSvgPath(String pathD, [int numPoints = 40]) {
  try {
    final path = parseSvgPathData(pathD);
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return [];
    final total = metrics.fold<double>(0, (sum, m) => sum + m.length);
    if (total <= 0) return [];

    final pts = <Offset>[];
    for (var i = 0; i < numPoints; i++) {
      var target = (i / (numPoints - 1)) * total;
      for (final m in metrics) {
        if (target <= m.length) {
          final tangent = m.getTangentForOffset(target);
          if (tangent != null) pts.add(tangent.position);
          break;
        }
        target -= m.length;
      }
    }
    return pts;
  } catch (_) {
    return [];
  }
}

const double _coverageMin = 0.85;
const double _offPathMultiplier = 1.3;
const double _offPathMaxRatio = 0.15;
const int _orderBackwardTolerance = 2;
const double _orderScoreMin = 0.8;
const double _startEndMultiplier = 1.6;
const int _minUserPoints = 6;

/// Validation rigoureuse du tracé en 5 critères, tous requis pour valider.
///
/// [tolerancePx] fixe la largeur du couloir (souplesse). [anchorTolerancePx]
/// fixe le rayon autour du départ et de l'arrivée (rigueur) : le fournir
/// permet d'élargir le couloir sans accepter un tracé commencé ou fini au
/// mauvais endroit. Par défaut, il vaut [tolerancePx].
ValidationResult validateTrace(
  List<Offset> userPts,
  List<Offset> refPts,
  double tolerancePx, {
  double? anchorTolerancePx,
}) {
  final anchorPx = anchorTolerancePx ?? tolerancePx;
  if (userPts.length < _minUserPoints || refPts.length < 2) {
    return const ValidationResult(false, 0, 'too_few_points');
  }

  // Distances mesurées à la LIGNE (segments entre points consécutifs), pas
  // aux seuls points échantillonnés : sinon un doigt parfaitement sur le
  // modèle, entre deux échantillons, paraissait "hors tracé", et un geste
  // rapide (peu d'événements de mouvement) laissait des trous de
  // couverture — à tolérance faible, même un tracé parfait était refusé.

  // ── Critère 1 : COUVERTURE ──
  // Le couloir élargi tolère un doigt qui tremble, pas un morceau du modèle
  // sauté : la couverture garde la portée du départ/arrivée au plus.
  final coverPx = math.min(tolerancePx, anchorPx * _startEndMultiplier);
  var coveredCount = 0;
  for (final rp in refPts) {
    if (_distToPolyline(rp, userPts) <= coverPx) coveredCount++;
  }
  final coverage = coveredCount / refPts.length;
  if (coverage < _coverageMin) {
    return ValidationResult(
      false,
      coverage,
      'coverage_${(coverage * 100).round()}%',
    );
  }

  // ── Critère 2 : PROXIMITÉ AU CHEMIN ──
  var offPath = 0;
  for (final up in userPts) {
    if (_distToPolyline(up, refPts) > tolerancePx * _offPathMultiplier) {
      offPath++;
    }
  }
  final offRatio = offPath / userPts.length;
  if (offRatio > _offPathMaxRatio) {
    return ValidationResult(
      false,
      coverage,
      'off_path_${(offRatio * 100).round()}%',
    );
  }

  // ── Critère 3 : ORDRE DE TRACÉ ──
  // Le doigt doit PROGRESSER le long du modèle, du début vers la fin : chaque
  // point est apparié au modèle dans une fenêtre qui ne peut qu'avancer (à un
  // léger tremblement près). Un tracé fait à l'envers, même parfaitement
  // superposé (boucle du "o", "c", "a"...), ne peut alors plus être apparié.
  // L'ancien critère (comparaison du point du modèle le plus proche d'un
  // point à l'autre) ne repérait que les sauts brusques en arrière, pas un
  // parcours entièrement inversé.
  final window = math.max(4, (refPts.length / 4).ceil());
  var cursor = 0;
  var inOrder = 0;
  for (final up in userPts) {
    final from = math.max(0, cursor - _orderBackwardTolerance);
    final to = math.min(refPts.length - 1, cursor + window);
    var best = cursor;
    var bestD = double.infinity;
    for (var i = from; i <= to; i++) {
      final d = (up - refPts[i]).distance;
      if (d < bestD) {
        bestD = d;
        best = i;
      }
    }
    final segD = _distToPolyline(up, refPts.sublist(from, to + 1));
    if (segD <= tolerancePx * _offPathMultiplier) {
      inOrder++;
      if (best > cursor) cursor = best;
    }
  }
  final orderScore = inOrder / userPts.length;
  final progressed = cursor >= (refPts.length - 1) * 0.75;
  if (orderScore < _orderScoreMin || !progressed) {
    return ValidationResult(
      false,
      coverage,
      'order_${(orderScore * 100).round()}%',
    );
  }

  // ── Critère 4 : DÉPART CORRECT ──
  final firstUser = userPts.first;
  final quarterIdx = (refPts.length / 4).floor();
  var nearStart = false;
  for (var i = 0; i <= quarterIdx; i++) {
    if ((firstUser - refPts[i]).distance <= anchorPx * _startEndMultiplier) {
      nearStart = true;
      break;
    }
  }
  if (!nearStart) return ValidationResult(false, coverage, 'wrong_start');

  // ── Critère 5 : ARRIVÉE CORRECTE ──
  final lastUser = userPts.last;
  final threeQuarterIdx = (refPts.length * 3 / 4).floor();
  var nearEnd = false;
  for (var i = threeQuarterIdx; i < refPts.length; i++) {
    if ((lastUser - refPts[i]).distance <= anchorPx * _startEndMultiplier) {
      nearEnd = true;
      break;
    }
  }
  if (!nearEnd) return ValidationResult(false, coverage, 'wrong_end');

  return ValidationResult(true, coverage);
}

double _distToPolyline(Offset p, List<Offset> line) {
  if (line.length == 1) return (p - line.first).distance;
  var best = double.infinity;
  for (var i = 1; i < line.length; i++) {
    final d = _distToSegment(p, line[i - 1], line[i]);
    if (d < best) best = d;
  }
  return best;
}

double _distToSegment(Offset p, Offset a, Offset b) {
  final ab = b - a;
  final len2 = ab.dx * ab.dx + ab.dy * ab.dy;
  if (len2 == 0) return (p - a).distance;
  final ap = p - a;
  final t = ((ap.dx * ab.dx + ap.dy * ab.dy) / len2).clamp(0.0, 1.0);
  return (p - (a + ab * t)).distance;
}
