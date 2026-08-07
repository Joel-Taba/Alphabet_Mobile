import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../i18n/translations.dart';
import '../services/progress_service.dart';
import '../theme/amani_theme.dart';

const _toastLifetime = Duration(milliseconds: 2200);

class _Toast {
  final int id;
  final int points;
  const _Toast({required this.id, required this.points});
}

/// Bulle "+N ⭐" affichée brièvement à chaque cours/exercice terminé. Montée
/// une seule fois à la racine de l'app (voir `app.dart`) via le `builder` de
/// `MaterialApp.router`, pour flotter au-dessus de tous les écrans — les
/// écrans n'ont qu'à appeler `ProgressProvider.awardCompletion(...)`, ce
/// widget s'occupe seul du retour visuel. Port fidèle de
/// `src/components/amani/PointsToastHost.tsx`.
class PointsToastHost extends StatefulWidget {
  const PointsToastHost({super.key});

  @override
  State<PointsToastHost> createState() => _PointsToastHostState();
}

class _PointsToastHostState extends State<PointsToastHost> {
  final List<_Toast> _toasts = [];
  int _lastSeenSequence = -1;

  void _scheduleToast(int id, int points) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final toast = _Toast(id: id, points: points);
      setState(() => _toasts.add(toast));
      Future.delayed(_toastLifetime, () {
        if (!mounted) return;
        setState(() => _toasts.removeWhere((t) => t.id == toast.id));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final t = context.watch<LanguageProvider>().t;

    if (progress.awardSequence > 0 &&
        progress.awardSequence != _lastSeenSequence) {
      _lastSeenSequence = progress.awardSequence;
      _scheduleToast(progress.awardSequence, progress.lastPointsAwarded);
    }

    if (_toasts.isEmpty) return const SizedBox.shrink();

    final pointsEarnedAria = t['common']?['pointsEarnedAria'] ?? '';

    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final toast in _toasts) ...[
              Semantics(
                liveRegion: true,
                label: '+${toast.points} $pointsEarnedAria',
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFF6C453), Color(0xFFD9A84A)],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x73D9A84A),
                        offset: Offset(0, 6),
                        blurRadius: 18,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '+${toast.points}',
                        style: TextStyle(
                          fontFamily: kBalooFontFamily,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
