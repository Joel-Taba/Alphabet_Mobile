import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../i18n/translations.dart';
import '../services/progress_service.dart';
import '../theme/amani_theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
                key: ValueKey(toast.id),
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
                      const _TwinklingStar(),
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

/// Étoile scintillante façon "luciole" : la pointe principale respire
/// (échelle + halo lumineux pulsés) pendant que deux minuscules étoiles
/// compagnes clignotent en décalé tout autour, comme un vol de lucioles.
class _TwinklingStar extends StatefulWidget {
  const _TwinklingStar();

  @override
  State<_TwinklingStar> createState() => _TwinklingStarState();
}

class _TwinklingStarState extends State<_TwinklingStar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final pulse = (math.sin(2 * math.pi * t) + 1) / 2;
        final scale = 0.88 + pulse * 0.28;
        final glow = 0.35 + pulse * 0.65;
        return SizedBox(
          width: 26,
          height: 26,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              _firefly(t, phase: 0.15, dx: 9, dy: -8, size: 5),
              _firefly(t, phase: 0.65, dx: -9, dy: 7, size: 4),
              Transform.scale(
                scale: scale,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: glow * 0.9),
                        blurRadius: 10 * glow,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    LucideIcons.star,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _firefly(
    double t, {
    required double phase,
    required double dx,
    required double dy,
    required double size,
  }) {
    final blink = math.max(0.0, math.sin(2 * math.pi * (t + phase) * 1.3));
    return Positioned(
      left: 13 + dx - size / 2,
      top: 13 + dy - size / 2,
      child: Opacity(
        opacity: blink,
        child: Icon(LucideIcons.star, color: Colors.white, size: size),
      ),
    );
  }
}
