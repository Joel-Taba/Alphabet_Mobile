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

const double _coverageMin = 0.88;
const double _offPathMultiplier = 1.3;
const double _offPathMaxRatio = 0.12;
const int _orderBackwardTolerance = 2;
const double _orderScoreMin = 0.8;
const double _startEndMultiplier = 1.6;
const int _minUserPoints = 6;

/// Validation rigoureuse du tracé en 5 critères, tous requis pour valider.
ValidationResult validateTrace(
  List<Offset> userPts,
  List<Offset> refPts,
  double tolerancePx,
) {
  if (userPts.length < _minUserPoints || refPts.length < 2) {
    return const ValidationResult(false, 0, 'too_few_points');
  }

  // ── Critère 1 : COUVERTURE ──
  var coveredCount = 0;
  for (final rp in refPts) {
    for (final up in userPts) {
      if ((up - rp).distance <= tolerancePx) {
        coveredCount++;
        break;
      }
    }
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
    var minDist = double.infinity;
    for (final rp in refPts) {
      final d = (up - rp).distance;
      if (d < minDist) minDist = d;
    }
    if (minDist > tolerancePx * _offPathMultiplier) offPath++;
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
  final refIndices = userPts.map((up) {
    var minD = double.infinity;
    var best = 0;
    for (var i = 0; i < refPts.length; i++) {
      final d = (up - refPts[i]).distance;
      if (d < minD) {
        minD = d;
        best = i;
      }
    }
    return best;
  }).toList();
  var backwardSteps = 0;
  for (var i = 1; i < refIndices.length; i++) {
    if (refIndices[i] < refIndices[i - 1] - _orderBackwardTolerance) {
      backwardSteps++;
    }
  }
  final orderScore = 1 - backwardSteps / math.max(1, refIndices.length - 1);
  if (orderScore < _orderScoreMin) {
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
    if ((firstUser - refPts[i]).distance <= tolerancePx * _startEndMultiplier) {
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
    if ((lastUser - refPts[i]).distance <= tolerancePx * _startEndMultiplier) {
      nearEnd = true;
      break;
    }
  }
  if (!nearEnd) return ValidationResult(false, coverage, 'wrong_end');

  return ValidationResult(true, coverage);
}
