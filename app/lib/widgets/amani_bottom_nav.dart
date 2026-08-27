import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../i18n/translations.dart';
import '../theme/amani_theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class _NavItem {
  final String path;
  final String key;
  final IconData icon;
  final bool isCenter;
  const _NavItem(this.path, this.key, this.icon, {this.isCenter = false});
}

const List<_NavItem> _items = [
  _NavItem('/accueil', 'accueil', LucideIcons.leaf, isCenter: true),
  _NavItem('/bibliotheque', 'bibliotheque', LucideIcons.palette),
  _NavItem('/communaute', 'communaute', LucideIcons.users),
  _NavItem('/mon-profil', 'profil', LucideIcons.user),
];

/// Barre de navigation flottante en pilule, avec un bouton circulaire
/// surélevé qui glisse vers l'onglet actif et une encoche dynamique dans le
/// fond de la barre — port fidèle de `src/components/amani/BottomNav.tsx`.
class AmaniBottomNav extends StatelessWidget {
  final int currentIndex;

  const AmaniBottomNav({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    context.go(_items[index].path);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final nav = t['nav'] as Map<String, dynamic>? ?? {};

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final tabWidth = width / _items.length;
          final activeCenterX = tabWidth * (currentIndex + 0.5);

          return SizedBox(
            height: 88,
            // La position de l'encoche et celle du bouton flottant doivent
            // être animées à partir de la MÊME valeur interpolée : les avoir
            // animées séparément (encoche peinte instantanément vs bouton
            // glissant sur 300ms) les désynchronisait visuellement à chaque
            // changement d'onglet.
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(end: activeCenterX),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              builder: (context, animatedX, child) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Barre en pilule avec encoche
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: CustomPaint(
                        size: Size(width, 64),
                        painter: _NotchBarPainter(notchCenterX: animatedX),
                        child: SizedBox(
                          width: width,
                          height: 64,
                          child: Row(
                            children: [
                              for (int i = 0; i < _items.length; i++)
                                Expanded(
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 150),
                                    opacity: i == currentIndex ? 0 : 1,
                                    child: IgnorePointer(
                                      ignoring: i == currentIndex,
                                      child: _NavIcon(
                                        icon: _items[i].icon,
                                        label: nav[_items[i].key] ?? '',
                                        onTap: () => _onTap(context, i),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Bouton circulaire surélevé qui suit l'onglet actif
                    Positioned(
                      left: animatedX - 32,
                      top: 0,
                      child: GestureDetector(
                        onTap: () => _onTap(context, currentIndex),
                        child: Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: AmaniColors.secondary,
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x4D8FBF6F),
                                    blurRadius: 20,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                _items[currentIndex].icon,
                                color: AmaniColors.surface,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              (nav[_items[currentIndex].key] ?? '')
                                  .toUpperCase(),
                              style: TextStyle(
                                fontFamily: kBalooFontFamily,
                                fontWeight: FontWeight.w800,
                                fontSize: 9,
                                letterSpacing: 0.4,
                                color: AmaniColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Rail de navigation verticale utilisé à la place de [AmaniBottomNav] sur
/// grand écran (tablette) — même liste d'onglets et mêmes libellés, mais
/// disposés le long du bord gauche pour ne pas gâcher la largeur disponible
/// avec une barre pensée pour un pouce de téléphone.
class AmaniSideNav extends StatelessWidget {
  final int currentIndex;

  const AmaniSideNav({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    context.go(_items[index].path);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final nav = t['nav'] as Map<String, dynamic>? ?? {};

    return Container(
      width: 96,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AmaniColors.surface,
        border: Border(
          right: BorderSide(
            color: AmaniColors.textPrimary.withValues(alpha: 0.08),
          ),
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < _items.length; i++) ...[
            _SideNavIcon(
              icon: _items[i].icon,
              label: nav[_items[i].key] ?? '',
              active: i == currentIndex,
              onTap: () => _onTap(context, i),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _SideNavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SideNavIcon({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: active ? AmaniColors.secondary : Colors.transparent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: active ? AmaniColors.surface : AmaniColors.disabled,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: kBalooFontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color: active ? AmaniColors.primary : AmaniColors.disabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AmaniColors.disabled, size: 22),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontFamily: kBalooFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 9,
              color: AmaniColors.disabled,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dessine la pilule de fond avec une encoche arrondie centrée sur
/// [notchCenterX], correspondant au tracé SVG dynamique de la version React.
class _NotchBarPainter extends CustomPainter {
  final double notchCenterX;
  _NotchBarPainter({required this.notchCenterX});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    const h = 64.0;
    const r = 32.0;
    final nx = notchCenterX.clamp(r + 35, w - r - 35);

    final path = Path()
      ..moveTo(r, 0)
      ..lineTo(nx - 35, 0)
      ..quadraticBezierTo(nx - 25, 0, nx - 20, 15)
      ..quadraticBezierTo(nx - 10, 25, nx, 25)
      ..quadraticBezierTo(nx + 10, 25, nx + 20, 15)
      ..quadraticBezierTo(nx + 25, 0, nx + 35, 0)
      ..lineTo(w - r, 0)
      ..quadraticBezierTo(w, 0, w, r)
      ..quadraticBezierTo(w, h, w - r, h)
      ..lineTo(r, h)
      ..quadraticBezierTo(0, h, 0, r)
      ..quadraticBezierTo(0, 0, r, 0)
      ..close();

    canvas.drawShadow(path, const Color(0xFF4A3B2A), 8, false);
    final paint = Paint()..color = AmaniColors.surface;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NotchBarPainter oldDelegate) =>
      oldDelegate.notchCenterX != notchCenterX;
}
