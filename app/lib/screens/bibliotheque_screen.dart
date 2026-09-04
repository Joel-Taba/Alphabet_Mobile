import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_drawing/path_drawing.dart' as pd;
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../widgets/cahier_frame.dart';
import '../widgets/scribble_canvas.dart';
import '../widgets/free_word_search_section.dart';
import '../widgets/free_tangram_section.dart';
import '../widgets/free_mental_calc_section.dart';
import '../widgets/sign_glyph.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/scroll_handle.dart';
import '../data/sign_exercise_catalog.dart';
import '../data/letter_formation_catalog.dart';
import '../data/letter_style_resolver.dart';
import '../hooks/use_tracing_scroll_lock.dart';
import '../hooks/use_writing_style.dart';
import '../services/mode_libre_controller.dart';
import '../utils/text_case.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum ModeLibreTab {
  scribble,
  signe,
  lettre,
  chiffre,
  wordsearch,
  tangram,
  calcul,
}

const List<SignFamily> _signFamilies = [
  SignFamily.trait,
  SignFamily.courbe,
  SignFamily.point,
  SignFamily.crochet,
];

const List<Color> _penColors = [
  Color(0xFF4A3B2A),
  Color(0xFFA9784F),
  Color(0xFF8FBF6F),
  Color(0xFF4A90E2),
  Color(0xFFE05252),
];

class BibliothequeScreen extends StatefulWidget {
  const BibliothequeScreen({super.key});

  @override
  State<BibliothequeScreen> createState() => _BibliothequeScreenState();
}

class _BibliothequeScreenState extends State<BibliothequeScreen> {
  ModeLibreTab _currentTab = ModeLibreTab.scribble;

  SignFamily _selectedFamily = SignFamily.trait;
  int _selectedSignIndex = 0;
  int _selectedLetterIndex = 0;
  int _selectedDigitIndex = 0;

  Color _penColor = _penColors.first;
  final GlobalKey<ScribbleCanvasState> _scribbleKey =
      GlobalKey<ScribbleCanvasState>();

  /// Incrémenté à chaque remise à zéro (voir `_onLeftModeLibre`) pour forcer
  /// la reconstruction complète des mini-jeux (mots mêlés, tangram, calcul),
  /// dont l'état interne (grille en cours) n'est pas autrement accessible
  /// d'ici.
  int _resetGeneration = 0;

  late List<dynamic> _allLetters;
  late final ModeLibreController _modeLibreController;

  @override
  void initState() {
    super.initState();
    // a→z puis A→Z (le catalogue UPPERCASE couvre déjà tout le style script).
    final lowercase = [...VOWELS, ...CONSONANTS]
      ..sort((a, b) => (a['char'] as String).compareTo(b['char'] as String));
    final uppercase = [...UPPERCASE]
      ..sort((a, b) => (a['char'] as String).compareTo(b['char'] as String));
    _allLetters = [...lowercase, ...uppercase];

    // Toute activité de Mode Libre (dessin, sélection en cours, mini-jeux)
    // doit repartir de zéro dès qu'on quitte cet onglet — voir `AppShell`,
    // qui prévient ce contrôleur au changement d'onglet de navigation.
    _modeLibreController = context.read<ModeLibreController>();
    _modeLibreController.addListener(_onLeftModeLibre);
  }

  void _onLeftModeLibre() {
    if (!mounted) return;
    _scribbleKey.currentState?.clear();
    if (_scribbleKey.currentState?.isEraserMode ?? false) {
      _scribbleKey.currentState?.toggleEraser();
    }
    setState(() {
      _currentTab = ModeLibreTab.scribble;
      _selectedFamily = SignFamily.trait;
      _selectedSignIndex = 0;
      _selectedLetterIndex = 0;
      _selectedDigitIndex = 0;
      _penColor = _penColors.first;
      _resetGeneration++;
    });
  }

  @override
  void dispose() {
    _modeLibreController.removeListener(_onLeftModeLibre);
    super.dispose();
  }

  /// En Mode Libre, une seule variante par forme (pas de doublon "réduit" à
  /// côté du signe normal) pour les traits et les courbes — contrairement au
  /// parcours du Palier 1, où les deux tailles ("hampe"/"corps") font partie
  /// du programme. Points et crochets n'ont pas ce doublon dans le
  /// catalogue : inchangés.
  List<dynamic> _signsForFamily(SignFamily family) {
    switch (family) {
      case SignFamily.trait:
        return TRAITS
            .where((s) => !(s['id'] as String).endsWith('-reduced'))
            .toList();
      case SignFamily.courbe:
        return COURBES
            .where((s) => !(s['id'] as String).endsWith('-reduced'))
            .toList();
      case SignFamily.point:
        return POINTS;
      case SignFamily.crochet:
        return CROCHETS;
    }
  }

  void _clearCanvas() {
    _scribbleKey.currentState?.clear();
  }

  /// Bascule l'outil actif entre crayon et gomme (effacement ciblé, comme un
  /// logiciel de dessin classique) — un appui long efface tout d'un coup.
  void _toggleEraser() {
    _scribbleKey.currentState?.toggleEraser();
    setState(() {});
  }

  /// Résout la forme (script/cursive/digitale) du caractère actuellement
  /// sélectionné, selon le style d'écriture actif — avec repli sur le style
  /// script déjà présent dans `_allLetters`/`DIGITS` si aucune forme dédiée
  /// n'existe encore pour ce style.
  dynamic _currentLetterFormation() {
    final style = context.read<WritingStyleProvider>().style.name;
    final fallback = _allLetters[_selectedLetterIndex];
    return getLetterFormation(fallback['char'] as String, style) ?? fallback;
  }

  dynamic _currentDigitFormation() {
    final style = context.read<WritingStyleProvider>().style.name;
    final fallback = DIGITS[_selectedDigitIndex];
    return getLetterFormation(fallback['char'] as String, style) ?? fallback;
  }

  static const List<ModeLibreTab> _drawingTabs = [
    ModeLibreTab.scribble,
    ModeLibreTab.signe,
    ModeLibreTab.lettre,
    ModeLibreTab.chiffre,
  ];

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    // Le format d'écriture n'est lu qu'avec context.read() dans les helpers
    // ci-dessus ; ce watch() force ce widget à se reconstruire quand il
    // change, pour que l'aperçu de lettre/chiffre suive le style choisi.
    context.watch<WritingStyleProvider>();
    final modeLibre = t['modeLibre'] as Map<String, dynamic>;
    final tabs = modeLibre['tabs'] as Map<String, dynamic>? ?? {};

    return Scaffold(
      backgroundColor: AmaniColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          // Verrouillé pendant qu'un tracé est en cours (voir
          // `TracingScrollLock`) : le canevas de dessin capte alors tout le
          // geste sans jamais le laisser aussi faire défiler la page.
          // Le reste du temps, cette page défile normalement -- avec, juste
          // au-dessus du canevas, une petite poignée dédiée (voir
          // `_buildScrollHandle`) toujours facile à saisir pour défiler
          // sans risquer de commencer un tracé par erreur.
          physics: tracingAwareScrollPhysics(context),
          children: [
            // En-tête
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        modeLibre['title'] ?? 'Mode Libre',
                        style: AmaniTheme.titleStyle.copyWith(fontSize: 28),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        modeLibre['subtitle'] ?? '',
                        style: AmaniTheme.bodyStyle.copyWith(
                          color: AmaniColors.textSecondary,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const AmaniMascot(
                  pose: AmaniPose.encouragement,
                  size: AmaniSize.small,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Image plein cadre — bannière décorative inspirée de
            // `_app.bibliotheque.tsx` (amani-gribouillage.png).
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                  ),
                  boxShadow: const [
                    BoxShadow(color: Color(0x24000000), blurRadius: 8),
                  ],
                ),
                child: Image.asset(
                  'assets/images/amani-gribouillage.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Onglets de modèle -- hauteur non figée (contrairement à un
            // `SizedBox(height: 44)` calé sur la taille de police d'origine)
            // : avec le réglage "Taille de l'interface" (Profil > Réglages),
            // les libellés grandissent et un cadre figé les aurait rognés.
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTab(
                    ModeLibreTab.scribble,
                    tabs['scribble'] ?? 'Gribouillage',
                  ),
                  const SizedBox(width: 8),
                  _buildTab(ModeLibreTab.signe, tabs['sign'] ?? 'Signe'),
                  const SizedBox(width: 8),
                  _buildTab(ModeLibreTab.lettre, tabs['letter'] ?? 'Lettre'),
                  const SizedBox(width: 8),
                  _buildTab(ModeLibreTab.chiffre, tabs['digit'] ?? 'Chiffre'),
                  const SizedBox(width: 8),
                  _buildTab(
                    ModeLibreTab.wordsearch,
                    tabs['wordsearch'] ?? 'Mots mêlés',
                  ),
                  const SizedBox(width: 8),
                  _buildTab(ModeLibreTab.tangram, tabs['tangram'] ?? 'Tangram'),
                  const SizedBox(width: 8),
                  _buildTab(ModeLibreTab.calcul, tabs['calcul'] ?? 'Calcul'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (_drawingTabs.contains(_currentTab))
              _buildDrawingBody(modeLibre)
            else if (_currentTab == ModeLibreTab.wordsearch)
              FreeWordSearchSection(
                key: ValueKey('wordsearch-$_resetGeneration'),
              )
            else if (_currentTab == ModeLibreTab.tangram)
              FreeTangramSection(key: ValueKey('tangram-$_resetGeneration'))
            else
              FreeMentalCalcSection(key: ValueKey('calcul-$_resetGeneration')),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawingBody(Map<String, dynamic> modeLibre) {
    return Column(
      children: [
        // Sélecteur de famille (uniquement pour l'onglet Signe)
        if (_currentTab == ModeLibreTab.signe) ...[
          _buildFamilySelector(modeLibre),
          const SizedBox(height: 12),
        ],

        // Carte "modèle de référence"
        _buildModelCard(modeLibre),
        const SizedBox(height: 8),

        const ScrollHandle(),
        const SizedBox(height: 8),

        // Canvas — page de dessin libre — uniquement des lignes d'écriture façon
        // cahier, sans aucun tracé-guide superposé : c'est l'enfant qui
        // dessine seul, quel que soit l'onglet. Port fidèle du canevas
        // unique partagé par les 4 onglets dans `_app.bibliotheque.tsx`
        // (`<CahierFrame ... /><canvas .../>`, sans `targetSvgPath`).
        AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AmaniColors.disabled, width: 2),
            ),
            child: CahierFrame(
              rounded: 22,
              child: ScribbleCanvas(key: _scribbleKey, penColor: _penColor),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Barre d'outils : couleurs + effacer, commune à tous les
        // onglets (même barre que sur le web).
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
            _buildEraserMenu(),
          ],
        ),
        const SizedBox(height: 20),

        // Sélecteur du modèle courant (carousel horizontal)
        if (_currentTab != ModeLibreTab.scribble)
          SizedBox(height: 74, child: _buildSelector()),
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

  Widget _buildFamilySelector(Map<String, dynamic> modeLibre) {
    final signNames = modeLibre['signNames'] as Map<String, dynamic>? ?? {};
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _signFamilies.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final family = _signFamilies[index];
          final colors = glyphColorByFamily[family]!;
          final isSel = _selectedFamily == family;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFamily = family;
                _selectedSignIndex = 0;
                _clearCanvas();
              });
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSel ? colors.bg : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSel
                      ? AmaniColors.textPrimary.withValues(alpha: 0.19)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: Semantics(
                label:
                    signNames[signFamilyKey(family)] as String? ?? family.name,
                child: SignGlyph(
                  family: family,
                  stroke: isSel
                      ? colors.stroke
                      : (family == SignFamily.trait ||
                                family == SignFamily.point
                            ? AmaniColors.textPrimary
                            : colors.bg),
                  size: 32,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModelCard(Map<String, dynamic> modeLibre) {
    final signNames = modeLibre['signNames'] as Map<String, dynamic>? ?? {};

    if (_currentTab == ModeLibreTab.scribble) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AmaniColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A4A3B2A),
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Color(0x1A4A3B2A), blurRadius: 6),
                ],
              ),
              alignment: Alignment.center,
              child: const Text('✏️', style: TextStyle(fontSize: 32)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    modeLibre['noModelTitle'] ?? '',
                    style: AmaniTheme.titleStyle.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    modeLibre['noModelBody'] ?? '',
                    style: AmaniTheme.bodyStyle.copyWith(
                      fontSize: 13,
                      color: AmaniColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    String label;
    Widget preview;

    if (_currentTab == ModeLibreTab.signe) {
      final colors = glyphColorByFamily[_selectedFamily]!;
      final lang = context.watch<LanguageProvider>().lang;
      final signs = _signsForFamily(_selectedFamily);
      final selected = _selectedSignIndex < signs.length
          ? signs[_selectedSignIndex]
          : null;
      final variantLabel = selected != null
          ? (selected['label']?[lang.name] as String? ??
                selected['label']?['fr'] as String?)
          : null;
      label =
          variantLabel ??
          signNames[signFamilyKey(_selectedFamily)] as String? ??
          '';
      preview = SignGlyph(
        family: _selectedFamily,
        variant: selected?['variant'] ?? 'vertical',
        stroke:
            _selectedFamily == SignFamily.trait ||
                _selectedFamily == SignFamily.point
            ? AmaniColors.textPrimary
            : colors.bg,
        size: 48,
      );
    } else if (_currentTab == ModeLibreTab.lettre) {
      final letter = _currentLetterFormation();
      label = letter['char'];
      preview = _LetterPreview(steps: letter['steps'] as List, size: 56);
    } else {
      final digit = _currentDigitFormation();
      label = digit['char'];
      preview = _LetterPreview(steps: digit['steps'] as List, size: 56);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AmaniColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A4A3B2A),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Color(0x1A4A3B2A), blurRadius: 6),
              ],
            ),
            alignment: Alignment.center,
            child: preview,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  capitalizeFirst(
                    (modeLibre['modelLabel'] ?? 'Modèle').toString(),
                  ),
                  style: TextStyle(
                    fontFamily: kBalooFontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    letterSpacing: 0.6,
                    color: AmaniColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: AmaniTheme.titleStyle.copyWith(fontSize: 22),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(ModeLibreTab tab, String label) {
    final isSelected = _currentTab == tab;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTab = tab;
          _clearCanvas();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        decoration: BoxDecoration(
          color: isSelected ? AmaniColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (isSelected)
              const BoxShadow(
                color: Color(0x338FBF6F),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: kBalooFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: isSelected ? Colors.white : AmaniColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  /// Bouton gomme : au lieu de basculer directement un mode, ouvre un petit
  /// menu déroulant à deux icônes (sans texte) — effacement complet ou
  /// effacement ciblé — pour laisser le choix explicite à chaque appui,
  /// plutôt qu'un mode caché derrière un appui long.
  Widget _buildEraserMenu() {
    final active = _scribbleKey.currentState?.isEraserMode ?? false;
    final modeLibre =
        context.watch<LanguageProvider>().t['modeLibre']
            as Map<String, dynamic>? ??
        {};
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

  Widget _buildSelector() {
    List<dynamic> items;
    int selectedIndex;

    if (_currentTab == ModeLibreTab.signe) {
      items = _signsForFamily(_selectedFamily);
      selectedIndex = _selectedSignIndex;
    } else if (_currentTab == ModeLibreTab.lettre) {
      items = _allLetters;
      selectedIndex = _selectedLetterIndex;
    } else {
      items = DIGITS;
      selectedIndex = _selectedDigitIndex;
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(width: 8),
      itemBuilder: (context, index) {
        final isSelected = index == selectedIndex;
        Widget child;

        if (_currentTab == ModeLibreTab.signe) {
          final colors = glyphColorByFamily[_selectedFamily]!;
          child = SignGlyph(
            family: _selectedFamily,
            variant: items[index]['variant'] ?? 'vertical',
            stroke: isSelected
                ? Colors.white
                : (_selectedFamily == SignFamily.trait ||
                          _selectedFamily == SignFamily.point
                      ? AmaniColors.textPrimary
                      : colors.bg),
            size: 30,
          );
        } else {
          child = Text(
            items[index]['char'],
            style: TextStyle(
              fontFamily: kBalooFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 26,
              color: isSelected ? Colors.white : AmaniColors.textPrimary,
            ),
          );
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              if (_currentTab == ModeLibreTab.signe) {
                _selectedSignIndex = index;
              } else if (_currentTab == ModeLibreTab.lettre) {
                _selectedLetterIndex = index;
              } else {
                _selectedDigitIndex = index;
              }
              _clearCanvas();
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: isSelected ? AmaniColors.primaryDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
    );
  }
}

/// Aperçu statique d'une lettre/chiffre : superpose toutes les étapes.
class _LetterPreview extends StatelessWidget {
  final List steps;
  final double size;

  const _LetterPreview({required this.steps, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _LetterPreviewPainter(steps: steps)),
    );
  }
}

class _LetterPreviewPainter extends CustomPainter {
  final List steps;
  _LetterPreviewPainter({required this.steps});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 200.0;
    canvas.save();
    canvas.scale(scale, scale);
    final zOrderedSteps = List.from(steps)
      ..sort(
        (a, b) => letterFamilyZIndex(
          a['family'] as String,
        ).compareTo(letterFamilyZIndex(b['family'] as String)),
      );
    for (final step in zOrderedSteps) {
      final paint = Paint()
        ..color = Color(
          int.parse((step['strokeColor'] as String).replaceFirst('#', '0xFF')),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(_parsePath(step['pathD'] as String), paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LetterPreviewPainter oldDelegate) =>
      oldDelegate.steps != steps;
}

Path _parsePath(String d) => pd.parseSvgPathData(d);
