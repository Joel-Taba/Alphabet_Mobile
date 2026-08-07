import 'dart:async';
import 'package:flutter/foundation.dart';

/// Compte à rebours en secondes, basé sur le temps réel écoulé (résistant à
/// l'app mise en arrière-plan) plutôt que sur un simple décompte par tick.
/// Appelle [onExpire] une seule fois lorsque le temps est écoulé — reflète
/// `src/hooks/useCountdown.ts`.
class CountdownController extends ChangeNotifier {
  final int durationSeconds;
  final VoidCallback onExpire;

  int remaining;
  Timer? _timer;
  bool _expired = false;
  final DateTime _start = DateTime.now();

  CountdownController({required this.durationSeconds, required this.onExpire})
    : remaining = durationSeconds {
    if (durationSeconds <= 0) return;
    _timer = Timer.periodic(const Duration(milliseconds: 250), (_) => _tick());
  }

  void _tick() {
    final elapsed = DateTime.now().difference(_start).inMilliseconds ~/ 1000;
    final left = (durationSeconds - elapsed).clamp(0, durationSeconds);
    remaining = left;
    notifyListeners();
    if (left <= 0 && !_expired) {
      _expired = true;
      _timer?.cancel();
      onExpire();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Formate un nombre de secondes en "m:ss".
String formatCountdown(int totalSeconds) {
  final m = totalSeconds ~/ 60;
  final s = totalSeconds % 60;
  return '$m:${s.toString().padLeft(2, '0')}';
}
