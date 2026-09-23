import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import 'scribble_canvas.dart';
import 'scroll_handle.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Feuille d'écriture libre, en bas de chaque page d'exercice des Paliers
/// 1 à 4 : un espace de pratique sans validation ni limite de répétitions,
/// avec la même barre d'outils (crayons de couleur + gomme, en effacement
/// complet ou ciblé) que le canevas de "Gribouillage" du Mode Libre (voir
/// `bibliotheque_screen.dart`). Widget autonome, sans dépendance à l'écran
/// qui l'embarque -- juste à poser en fin de page.
class FreeWritingSheet extends StatefulWidget {
  const FreeWritingSheet({super.key});

  @override
  State<FreeWritingSheet> createState() => _FreeWritingSheetState();
}

class _FreeWritingSheetState extends State<FreeWritingSheet> {
  static const List<Color> _penColors = [
    Color(0xFF4A3B2A),
    Color(0xFFA9784F),
    Color(0xFF8FBF6F),
    Color(0xFF4A90E2),
    Color(0xFFE05252),
  ];

  Color _penColor = _penColors.first;
  final GlobalKey<ScribbleCanvasState> _scribbleKey =
      GlobalKey<ScribbleCanvasState>();

  void _clearCanvas() => _scribbleKey.currentState?.clear();

  void _toggleEraser() {
    _scribbleKey.currentState?.toggleEraser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final freeWriting = t['freeWriting'] as Map<String, dynamic>? ?? {};
    final modeLibre = t['modeLibre'] as Map<String, dynamic>? ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          freeWriting['title'] ?? 'Écriture libre',
          style: AmaniTheme.titleStyle.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 4),
        Text(
          freeWriting['subtitle'] ?? '',
          style: AmaniTheme.bodyStyle.copyWith(
            fontSize: 13,
            color: AmaniColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        const ScrollHandle(),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AmaniColors.disabled, width: 2),
            ),
            child: CustomPaint(
              foregroundPainter: const FreeWritingLinesPainter(),
              child: ScribbleCanvas(key: _scribbleKey, penColor: _penColor),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                for (final c in _penColors) ...[
                  _buildColorSwatch(c),
                  const SizedBox(width: 10),
                ],
              ],
            ),
            _buildEraserMenu(modeLibre),
          ],
        ),
      ],
    );
  }

  Widget _buildColorSwatch(Color color) {
    final isSel = _penColor == color;
    return GestureDetector(
      onTap: () => setState(() {
        _penColor = color;
        if (_scribbleKey.currentState?.isEraserMode ?? false) {
          _scribbleKey.currentState?.toggleEraser();
        }
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSel ? AmaniColors.textPrimary : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSel
              ? [
                  BoxShadow(
                    color: AmaniColors.textPrimary.withValues(alpha: 0.25),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ]
              : const [BoxShadow(color: Color(0x33000000), blurRadius: 3)],
        ),
      ),
    );
  }

  /// Bouton gomme : menu à deux icônes (effacement complet ou ciblé), comme
  /// en Mode Libre -- voir `bibliotheque_screen.dart._buildEraserMenu`.
  Widget _buildEraserMenu(Map<String, dynamic> modeLibre) {
    final active = _scribbleKey.currentState?.isEraserMode ?? false;
    return PopupMenuButton<String>(
      tooltip: '',
      offset: const Offset(0, -110),
      color: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onSelected: (value) {
        if (value == 'full') {
          _clearCanvas();
        } else if (value == 'targeted' && !active) {
          _toggleEraser();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'full',
          child: Center(
            child: Semantics(
              label: modeLibre['eraseAllAria'] ?? 'Tout effacer',
              child: const Icon(
                LucideIcons.trash2,
                color: AmaniColors.textSecondary,
                size: 24,
              ),
            ),
          ),
        ),
        PopupMenuItem(
          value: 'targeted',
          child: Center(
            child: Semantics(
              label: modeLibre['eraseTargetedAria'] ?? 'Effacement ciblé',
              child: const Icon(
                LucideIcons.eraser,
                color: AmaniColors.textSecondary,
                size: 24,
              ),
            ),
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: active ? AmaniColors.primary : Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Icon(
          LucideIcons.eraser,
          color: active ? Colors.white : AmaniColors.textSecondary,
          size: 28,
        ),
      ),
    );
  }
}

/// Quadrillage façon cahier d'écriture, à hauteur de ligne FIXE et répétée
/// plusieurs fois sur toute la feuille -- plutôt qu'un unique groupe de 4
/// lignes étiré sur toute la hauteur disponible (voir `CahierFrame`, prévu
/// pour une case de tracé compacte, pas pour cette grande feuille libre où
/// l'étirement donnait une seule ligne d'écriture géante, peu pratique pour
/// enchaîner plusieurs répétitions d'un signe). Même espacement/couleurs que
/// `_TrailingCahierLinesPainter` (`exercice_liste_screen.dart`) pour rester
/// visuellement cohérent avec le reste de l'application. Publique et
/// réutilisée telle quelle par le canevas du Mode Libre
/// (`bibliotheque_screen.dart`) : même quadrillage, avec le même nombre de
/// groupes de lignes puisque les deux canevas partagent le même
/// `AspectRatio(1.0)`, donc la même hauteur à taille d'écran égale.
class FreeWritingLinesPainter extends CustomPainter {
  const FreeWritingLinesPainter();

  static const List<double> _positions = [10, 70, 130, 190];
  static const double _rowHeight = 120;
  static const double _rowSpacing = 14;

  @override
  void paint(Canvas canvas, Size size) {
    const scale = _rowHeight / 200;
    var rowTop = 0.0;
    while (rowTop < size.height) {
      for (var i = 0; i < _positions.length; i++) {
        final y = rowTop + _positions[i] * scale;
        if (y > size.height) break;
        final isBaseline = i == 2;
        final paint = Paint()
          ..color =
              (isBaseline ? const Color(0xFFE05252) : const Color(0xFF4A90E2))
                  .withValues(alpha: 0.5)
          ..strokeWidth = isBaseline ? 1.5 : 1;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }
      rowTop += _rowHeight + _rowSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant FreeWritingLinesPainter oldDelegate) => false;
}
