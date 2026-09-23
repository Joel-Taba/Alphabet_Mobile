import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../i18n/translations.dart';
import '../theme/amani_theme.dart';
import '../widgets/amani_mascot.dart';
import '../services/progress_service.dart';
import '../data/palier2_groups.dart';
import '../data/word_catalog.dart';
import '../data/syllable_catalog.dart';
import '../data/calcul_catalog.dart';
import '../data/shape_catalog.dart';
import '../data/tangram_catalog.dart';
import '../data/sign_exercise_catalog.dart' show FAMILY_ORDER, EXERCISE_CATALOG;
import '../utils/text_case.dart';
import '../widgets/sign_glyph.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Famille de signe (voir `SignGlyph`) associée à une étape "Cours" du
/// Palier 1 — `null` pour toute autre étape "Cours" (livre générique).
SignFamily? _signFamilyFromKey(String? key) => switch (key) {
  'trait' => SignFamily.trait,
  'courbe' => SignFamily.courbe,
  'crochet' => SignFamily.crochet,
  'point' => SignFamily.point,
  _ => null,
};

/// Teinte grisée d'une couleur de palier (ex. vert → vert-gris, marron →
/// marron-gris...), utilisée pour distinguer une étape déjà réalisée de la
/// véritable étape courante (voir `Step.isDone`) -- un simple mélange avec
/// du gris fonctionne pour n'importe quelle couleur de palier, sans avoir à
/// définir une variante grisée dédiée pour chacune.
Color _mutedColor(Color c) => Color.lerp(c, const Color(0xFF9C9690), 0.55)!;

const String _bonusRibbonSvg = 'M6 16 H34 L30 34 H10 Z M10 22 H30 M12 28 H28';
const String _bonusArcSvg = 'M12 16 C14 8 26 8 28 16';

/// Ordre des niveaux du Palier "Les Calculs" — sert à retrouver l'index de
/// niveau (0=CP … 4=CM2) d'un [CalculTopic] sans dépendre d'un nombre fixe
/// de sujets par niveau (variable depuis l'ajout des tables de
/// multiplication, une par une, en CE1).
const List<String> _calculNiveaux = ['CP', 'CE1', 'CE2', 'CM1', 'CM2'];

enum StepKind {
  active,
  locked,
  bonus,
  wordsearch,
  vraiFaux,
  composeNombre,
  figureQuiz,
  figureVraiFaux,
  figureObjet,
  puzzleFormule,
  medal,
  header,
}

class Step {
  final StepKind kind;
  final String? iconType; // "feuille" | "branche"
  final String? title;
  final String? subtitle;
  final String? tagline;
  final int? palierNum;
  final Color? bannerBg;
  final Color? bannerBorder;
  final IconData? bannerIcon;

  /// Chemin d'une image SVG à utiliser à la place de [bannerIcon] (icône de
  /// police) -- teintée en blanc via `ColorFilter` exactement comme les
  /// `Icon(bannerIcon)` environnants, pour rester cohérente avec les autres
  /// paliers tout en permettant une illustration propre à ce palier (ex.
  /// Palier Mots : `abc-svgrepo-com.svg` plutôt que l'icône livre générique).
  final String? bannerIconAsset;

  /// Non `null` uniquement pour les étapes "Cours" (`iconType: 'feuille'`)
  /// du Palier 1 ('trait' | 'crochet' | 'courbe' | 'point') : remplace alors
  /// l'icône livre générique par le signe réellement enseigné dans ce cours
  /// (voir `SignGlyph`), et le libellé "Cours" par le titre exact de la
  /// leçon (`coursFamily.titles`, la même source que l'écran du cours
  /// lui-même — toujours synchronisé, dans les 4 langues).
  final String? signFamily;

  /// Non `null` pour remplacer le libellé générique "Cours" d'une étape
  /// `iconType: 'feuille'` par un titre court et illustratif du contenu réel
  /// de ce cours (même principe que [signFamily] pour le Palier 1, étendu
  /// aux Paliers 2-6 : titre du groupe de lettres/chiffres, thème de mots,
  /// consonne de syllabes, sujet de calcul, figure ou puzzle tangram) — déjà
  /// résolu dans la langue active par l'appelant, pas une clé de traduction.
  final String? stepTitle;

  /// `true` pour une étape "Cours"/"Exercice" (`kind: active`) dont le
  /// groupe entier (cours ET exercice) a déjà été réalisé -- distingue
  /// visuellement (voir la boucle de coloration dans `_buildSteps`, qui
  /// teinte alors [Step.bannerBg]/[Step.bannerBorder] hérités d'un gris) une
  /// étape déjà acquise de la véritable étape courante, qui garde elle la
  /// couleur pleine du palier.
  final bool isDone;

  const Step({
    required this.kind,
    this.iconType,
    this.title,
    this.subtitle,
    this.tagline,
    this.palierNum,
    this.bannerBg,
    this.bannerBorder,
    this.bannerIcon,
    this.bannerIconAsset,
    this.signFamily,
    this.stepTitle,
    this.isDone = false,
  });
}

class StepEntry {
  final Step step;
  final int side; // -1, 0, 1
  final String? to;
  Color? color;
  Color? borderColor;
  int? number;

  StepEntry(this.step, this.side, {this.to});
}

class ParcoursScreen extends StatefulWidget {
  const ParcoursScreen({super.key});

  @override
  State<ParcoursScreen> createState() => _ParcoursScreenState();
}

class _ParcoursScreenState extends State<ParcoursScreen>
    with WidgetsBindingObserver {
  int _activeStepIdx = 1;
  final ScrollController _scrollController = ScrollController();

  /// État du menu déroulant de navigation rapide entre paliers (voir
  /// `_PalierQuickNav`) — replié par défaut pour rester discret, déplié au
  /// tap sur le bouton "signpost", et automatiquement replié après avoir
  /// choisi un palier.
  bool _quickNavOpen = false;

  /// Une ancre stable par numéro de palier (1-6), posée sur la bannière
  /// d'en-tête correspondante (`_PalierBanner`) — permet de défiler jusqu'à
  /// un palier précis via `Scrollable.ensureVisible` sans calcul d'offset
  /// manuel. Un palier absent pour la langue active (Syllabes/Calculs,
  /// français uniquement) n'est simplement jamais attaché : le défilement
  /// est alors silencieusement ignoré plutôt que de planter.
  final Map<int, GlobalKey> _palierKeys = {
    for (var i = 1; i <= 6; i++) i: GlobalKey(),
  };

  /// Ancre posée exactement sur le `Stack` qui superpose le sentier peint
  /// (`_FootpathPainter`) et la colonne des étapes — sert de référentiel de
  /// coordonnées pour convertir la position mesurée de chaque nœud
  /// (`_nodeKeys`) dans le même espace que celui utilisé par le `Canvas` du
  /// peintre (voir `_measureNodes`).
  final GlobalKey _pathAreaKey = GlobalKey();

  /// Une ancre stable par étape non-en-tête (cours, exercice, bonus,
  /// médaille...), dans l'ORDRE d'apparition — volontairement indexées par
  /// position (pas par identité de `StepEntry`, recréée à chaque `build()`)
  /// pour rester stables d'un rebuild à l'autre. Étendue paresseusement
  /// (jamais réduite) via [_nodeKeyFor] : la structure du parcours ne varie
  /// qu'au changement de langue (Syllabes/Calculs absents hors français),
  /// donc le nombre d'étapes peut légèrement varier, mais jamais en cours de
  /// frame.
  final List<GlobalKey> _nodeKeys = [];

  GlobalKey _nodeKeyFor(int i) {
    while (_nodeKeys.length <= i) {
      _nodeKeys.add(GlobalKey());
    }
    return _nodeKeys[i];
  }

  /// Rectangle englobant réel (voir `_measureNodes`) de chaque étape
  /// non-en-tête, dans l'ordre — `null` tant que la toute première mesure
  /// post-layout n'a pas encore eu lieu (le sentier n'est alors simplement
  /// pas encore dessiné, le temps d'un frame). Couvre TOUTE l'étape (icône
  /// + étiquette de titre, et la bulle "Commencer" le cas échéant, voir
  /// `_StepNode` où la clé est désormais posée sur la colonne entière plutôt
  /// que sur l'icône seule) : alimente `_FootpathPainter`, qui découpe
  /// chaque tronçon du sentier pour qu'il ne pénètre jamais dans aucun de
  /// ces rectangles, quels que soient la langue, la taille d'écran ou le
  /// réglage d'échelle de l'interface -- plutôt qu'une marge fixe le long du
  /// tracé, insuffisante dès qu'un tronçon est peu incliné (voir l'historique
  /// de ce fichier).
  List<Rect>? _nodeRects;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadActiveStep();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Une rotation d'écran (portrait ↔ paysage) sur un appareil réel déclenche
  /// PLUSIEURS passes de layout successives pendant que la fenêtre se
  /// redimensionne (contrairement à un simple redimensionnement de fenêtre
  /// desktop, en une seule passe) : une unique mesure programmée juste après
  /// le premier frame qui suit peut donc capter une géométrie encore
  /// transitoire, jamais rattrapée ensuite puisque `_measureNodes` ne se
  /// redéclenche plus une fois `_nodeRects` stabilisé sur cette valeur
  /// erronée. Sans ce filet de sécurité, le sentier d'empreintes restait
  /// figé sur les positions (verticales, façon portrait) mesurées avant la
  /// rotation, alors que les étapes elles-mêmes s'étaient déjà réorganisées
  /// selon le nouveau zigzag (plus large, façon paysage) -- d'où le
  /// décalage constaté. Trois mesures de rattrapage, espacées, suffisent à
  /// couvrir la fin de la transition quel que soit l'appareil.
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _scheduleNodeMeasurement();
    for (final delayMs in [100, 250, 500]) {
      Future.delayed(Duration(milliseconds: delayMs), () {
        if (mounted) _scheduleNodeMeasurement();
      });
    }
  }

  /// Programme une mesure des positions réelles des nœuds après le layout
  /// du frame en cours — appelé à chaque `build()` : la plupart du temps
  /// les positions mesurées seront identiques aux précédentes (aucun
  /// `setState` déclenché, voir [_measureNodes]), donc sans boucle de
  /// reconstruction ; elles ne changent réellement qu'au premier affichage,
  /// au redimensionnement de la fenêtre, ou si un changement de langue
  /// modifie la hauteur d'une étiquette.
  void _scheduleNodeMeasurement() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureNodes());
  }

  void _measureNodes() {
    if (!mounted) return;
    final areaBox =
        _pathAreaKey.currentContext?.findRenderObject() as RenderBox?;
    if (areaBox == null || !areaBox.hasSize) return;
    final rects = <Rect>[];
    for (final key in _nodeKeys) {
      final box = key.currentContext?.findRenderObject() as RenderBox?;
      // Un nœud pas encore monté (ex. clé réservée pour une étape qui
      // vient de disparaître après un changement de langue) : on
      // réessaiera au prochain frame plutôt que de dessiner un sentier
      // tronqué.
      if (box == null || !box.hasSize) return;
      final topLeft = box.localToGlobal(Offset.zero, ancestor: areaBox);
      rects.add(topLeft & box.size);
    }
    if (_nodeRects != null && _rectsMatch(_nodeRects!, rects)) {
      return;
    }
    setState(() => _nodeRects = rects);
  }

  bool _rectsMatch(List<Rect> a, List<Rect> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      final ra = a[i], rb = b[i];
      if ((ra.topLeft - rb.topLeft).distanceSquared > 0.25) return false;
      if ((ra.width - rb.width).abs() > 0.5) return false;
      if ((ra.height - rb.height).abs() > 0.5) return false;
    }
    return true;
  }

  /// Défile jusqu'à la bannière du palier [num]. Utilisée par le menu
  /// déroulant `_PalierQuickNav` pour sauter directement à n'importe quel
  /// palier choisi par l'enfant, sans devoir défiler manuellement tout le
  /// parcours — particulièrement fastidieux sur les paliers à beaucoup
  /// d'étapes (Calculs, Mots).
  void _scrollToPalier(int num) {
    final key = _palierKeys[num];
    final ctx = key?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }

  void _onQuickNavSelect(int palierNum) {
    setState(() => _quickNavOpen = false);
    // Laisse le menu se replier visuellement avant de lancer le défilement
    // (les deux animations en même temps rendraient le repli du menu peu
    // lisible, caché sous le mouvement de la page).
    Future.delayed(
      const Duration(milliseconds: 150),
      () => _scrollToPalier(palierNum),
    );
  }

  Future<void> _loadActiveStep() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt('accueil_current_step_idx');
    if (saved != null && mounted) {
      setState(() => _activeStepIdx = saved);
    }
  }

  Future<void> _activate(int index) async {
    setState(() => _activeStepIdx = index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accueil_current_step_idx', index);
  }

  void _onStepTap(int index, String? to, Map<String, dynamic> t) {
    _activate(index);
    if (to != null) {
      context.push(to);
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AmaniColors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 96),
        content: Text(
          t['parcours']?['comingSoon'] ?? 'Cette étape arrive bientôt !',
          style: TextStyle(
            fontFamily: kBalooFontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Index effectif de l'étape "courante" (première non terminée) parmi
  /// [doneFlags] -- si tout est terminé, retombe sur la dernière plutôt que
  /// de ne jamais désigner d'étape courante (il doit toujours en rester une,
  /// en couleur pleine, même une fois le palier entièrement acquis).
  int _currentGroupIndex(List<bool> doneFlags) {
    final firstNotDone = doneFlags.indexWhere((d) => !d);
    return firstNotDone == -1 ? doneFlags.length - 1 : firstNotDone;
  }

  bool _signFamilyDone(ProgressProvider progress, String family) {
    final items = EXERCISE_CATALOG.where((e) => e['family'] == family);
    if (items.isEmpty) return false;
    final coursDone = progress.isCompleted(
      typeEtape: 'SIGNE',
      modalite: 'COURS',
      etapeCode: family,
    );
    return coursDone &&
        items.every(
          (e) => progress.isCompleted(
            typeEtape: 'SIGNE',
            modalite: 'EXERCICE',
            etapeCode: e['id'] as String,
          ),
        );
  }

  bool _letterGroupDone(ProgressProvider progress, dynamic group) {
    final coursDone = progress.isCompleted(
      typeEtape: 'LETTRE',
      modalite: 'COURS',
      etapeCode: group.id as String,
    );
    final chars = group.chars as List;
    return coursDone &&
        chars.every(
          (c) => progress.isCompleted(
            typeEtape: 'LETTRE',
            modalite: 'EXERCICE',
            etapeCode: c as String,
          ),
        );
  }

  bool _syllableGroupDone(
    ProgressProvider progress,
    Map<String, dynamic> group,
  ) {
    final consonant = group['consonant'] as String;
    final coursDone = progress.isCompleted(
      typeEtape: 'SYLLABE',
      modalite: 'COURS',
      etapeCode: consonant,
    );
    final syllables = group['syllables'] as List;
    return coursDone &&
        syllables.every(
          (s) => progress.isCompleted(
            typeEtape: 'SYLLABE',
            modalite: 'EXERCICE',
            etapeCode: (s as Map)['syllable'] as String,
          ),
        );
  }

  bool _wordGroupDone(ProgressProvider progress, dynamic group) {
    final coursDone = progress.isCompleted(
      typeEtape: 'MOT',
      modalite: 'COURS',
      etapeCode: group.id as String,
    );
    final words = group.words as List;
    return coursDone &&
        words.every(
          (w) => progress.isCompleted(
            typeEtape: 'MOT',
            modalite: 'EXERCICE',
            etapeCode: w.id as String,
          ),
        );
  }

  bool _calculTopicDone(ProgressProvider progress, dynamic topic) {
    final id = topic.id as String;
    return progress.isCompleted(
          typeEtape: 'CALCUL',
          modalite: 'COURS',
          etapeCode: id,
        ) &&
        progress.isTopicExercised('CALCUL', id);
  }

  bool _shapeTopicDone(ProgressProvider progress, dynamic topic) {
    final id = topic.id as String;
    return progress.isCompleted(
          typeEtape: 'FIGURE',
          modalite: 'COURS',
          etapeCode: id,
        ) &&
        progress.isTopicExercised('FIGURE', id);
  }

  List<StepEntry> _buildSteps(
    Map<String, dynamic> t,
    Lang lang,
    ProgressProvider progress,
  ) {
    final paliers = (t['parcours']?['paliers'] as List?) ?? [];
    String pal(int i, String key) =>
        (paliers.length > i ? paliers[i][key] : null) ?? '';
    final palier2Groups = getPalier2Groups(lang.name);

    final steps = <StepEntry>[
      // ─── PALIER 1 : Les Signes de base ───
      StepEntry(
        Step(
          kind: StepKind.header,
          title: pal(0, 'title'),
          subtitle: pal(0, 'subtitle'),
          tagline: pal(0, 'tagline'),
          palierNum: 1,
          bannerBg: const Color(0xFF8FBF6F),
          bannerBorder: const Color(0xFF5E8E3E),
          bannerIcon: LucideIcons.leaf,
        ),
        0,
      ),
    ];

    // Leçon d'introduction aux 4 signes de base, avant le premier signe
    // (le trait) -- contenu institutionnel French-only (méthode Flores Gong
    // Nota, UNESCO/Francophonie), non traduite dans les autres langues
    // (voir `coursSignesIntro` dans translations.dart).
    final showSignesIntro = lang == Lang.fr;
    final signesIntroDone = progress.isCompleted(
      typeEtape: 'SIGNE_INTRO',
      modalite: 'COURS',
      etapeCode: 'intro',
    );
    final signDoneFlags = [
      if (showSignesIntro) signesIntroDone,
      for (final family in FAMILY_ORDER) _signFamilyDone(progress, family),
    ];
    final signCurrentIdx = _currentGroupIndex(signDoneFlags);
    final signIdxOffset = showSignesIntro ? 1 : 0;
    if (showSignesIntro) {
      steps.add(
        StepEntry(
          Step(
            kind: 0 <= signCurrentIdx ? StepKind.active : StepKind.locked,
            iconType: 'feuille',
            isDone: signesIntroDone,
            stepTitle: t['coursSignesIntro']?['stepLabel'] ?? 'Introduction',
          ),
          -1,
          to: '/cours-signes-intro',
        ),
      );
    }
    for (var idx = 0; idx < FAMILY_ORDER.length; idx++) {
      final family = FAMILY_ORDER[idx];
      final offsetIdx = idx + signIdxOffset;
      final kind = offsetIdx <= signCurrentIdx
          ? StepKind.active
          : StepKind.locked;
      final done = offsetIdx < signCurrentIdx;
      steps.add(
        StepEntry(
          Step(
            kind: kind,
            iconType: 'feuille',
            signFamily: family,
            isDone: done,
          ),
          -1,
          to: '/cours/$family',
        ),
      );
      steps.add(
        StepEntry(
          Step(kind: kind, iconType: 'branche', isDone: done),
          1,
          to: '/exercice-liste?family=$family',
        ),
      );
    }
    steps.add(
      StepEntry(
        const Step(kind: StepKind.medal),
        0,
        to: '/exercice-liste?family=${FAMILY_ORDER[0]}&amaniEval=1',
      ),
    );

    // ─── PALIER 2 : Combinatoire ───
    steps.add(
      StepEntry(
        Step(
          kind: StepKind.header,
          title: pal(1, 'title'),
          subtitle: pal(1, 'subtitle'),
          tagline: pal(1, 'tagline'),
          palierNum: 2,
          bannerBg: const Color(0xFFA9784F),
          bannerBorder: const Color(0xFF7A5332),
          bannerIcon: LucideIcons.penLine,
        ),
        0,
      ),
    );

    final letterDoneFlags = [
      for (final group in palier2Groups) _letterGroupDone(progress, group),
    ];
    final letterCurrentIdx = _currentGroupIndex(letterDoneFlags);
    for (var idx = 0; idx < palier2Groups.length; idx++) {
      final kind = idx <= letterCurrentIdx ? StepKind.active : StepKind.locked;
      final done = idx < letterCurrentIdx;
      final group = palier2Groups[idx];
      steps.add(
        StepEntry(
          Step(
            kind: kind,
            iconType: 'feuille',
            stepTitle: group.title[lang.name],
            isDone: done,
          ),
          -1,
          to: '/cours/lettres/formation/${group.chars.first}?pg=${group.id}',
        ),
      );
      steps.add(
        StepEntry(
          Step(kind: kind, iconType: 'branche', isDone: done),
          1,
          to: '/exercice-liste?group=${group.id}',
        ),
      );
      steps.add(
        StepEntry(
          const Step(kind: StepKind.puzzleFormule),
          0,
          to: '/exercice/puzzle-formule/${group.chars.first}?pg=${group.id}',
        ),
      );
    }
    steps.add(
      StepEntry(
        const Step(kind: StepKind.medal),
        0,
        to: '/exercice/lettre/${palier2Groups[0].chars.first}?pg=${palier2Groups[0].id}&amaniEval=1',
      ),
    );

    // ─── PALIER 3 : Les Syllabes (méthode consonne + voyelle) — disponible
    // dans les 4 langues ; les syllabes elles-mêmes restent en alphabet
    // latin (voir la doc de `syllable_catalog.dart`), seule la narration
    // change. ───
    steps.add(
      StepEntry(
        Step(
          kind: StepKind.header,
          title: pal(2, 'title'),
          subtitle: pal(2, 'subtitle'),
          tagline: pal(2, 'tagline'),
          palierNum: 3,
          bannerBg: const Color(0xFFD07A04),
          bannerBorder: const Color(0xFFA25F03),
          bannerIcon: LucideIcons.bookOpen,
        ),
        0,
      ),
    );

    final syllableDoneFlags = [
      for (final group in SYLLABLE_GROUPS)
        _syllableGroupDone(progress, group as Map<String, dynamic>),
    ];
    final syllableCurrentIdx = _currentGroupIndex(syllableDoneFlags);
    for (var idx = 0; idx < SYLLABLE_GROUPS.length; idx++) {
      final kind = idx <= syllableCurrentIdx
          ? StepKind.active
          : StepKind.locked;
      final done = idx < syllableCurrentIdx;
      final group = SYLLABLE_GROUPS[idx] as Map<String, dynamic>;
      steps.add(
        StepEntry(
          Step(
            kind: kind,
            iconType: 'feuille',
            stepTitle: tFormat(t['coursSyllabes']?['consonantTitle'] ?? '', {
              'consonant': group['consonant'],
            }),
            isDone: done,
          ),
          -1,
          to: '/cours/syllabes/${group['consonant']}',
        ),
      );
      steps.add(
        StepEntry(
          Step(kind: kind, iconType: 'branche', isDone: done),
          1,
          to: '/exercice/syllabes/${group['consonant']}',
        ),
      );
    }
    final firstConsonant =
        (SYLLABLE_GROUPS.first as Map<String, dynamic>)['consonant'];
    steps.add(
      StepEntry(
        const Step(kind: StepKind.medal),
        0,
        to: '/exercice/syllabes/$firstConsonant?amaniEval=1',
      ),
    );

    // ─── PALIER 4 : Les Mots ───
    steps.add(
      StepEntry(
        Step(
          kind: StepKind.header,
          title: pal(3, 'title'),
          subtitle: pal(3, 'subtitle'),
          tagline: pal(3, 'tagline'),
          palierNum: 4,
          bannerBg: const Color(0xFF4A90E2),
          bannerBorder: const Color(0xFF2D6BBF),
          bannerIconAsset: 'assets/images/abc-svgrepo-com.svg',
        ),
        0,
      ),
    );

    final wordDoneFlags = [
      for (final group in PALIER3_GROUPS) _wordGroupDone(progress, group),
    ];
    final wordCurrentIdx = _currentGroupIndex(wordDoneFlags);
    for (var idx = 0; idx < PALIER3_GROUPS.length; idx++) {
      final kind = idx <= wordCurrentIdx ? StepKind.active : StepKind.locked;
      final done = idx < wordCurrentIdx;
      final group = PALIER3_GROUPS[idx];
      steps.add(
        StepEntry(
          Step(
            kind: kind,
            iconType: 'feuille',
            stepTitle: group.title[lang.name],
            isDone: done,
          ),
          -1,
          to: '/cours/mots/${group.id}',
        ),
      );
      steps.add(
        StepEntry(
          Step(kind: kind, iconType: 'branche', isDone: done),
          1,
          to: '/exercice/mots/${group.id}',
        ),
      );
      if (idx % 2 == 1) {
        final levelIdx = (idx - 1) ~/ 2;
        if (levelIdx < PALIER3_WORD_PUZZLE_LEVELS.length) {
          final level = PALIER3_WORD_PUZZLE_LEVELS[levelIdx];
          steps.add(
            StepEntry(
              const Step(kind: StepKind.wordsearch),
              0,
              to: '/exercice/mots-meles/lvl$level',
            ),
          );
        }
      }
    }
    steps.add(
      StepEntry(
        const Step(kind: StepKind.medal),
        0,
        to: '/exercice/mots/${PALIER3_GROUPS[0].id}?amaniEval=1',
      ),
    );

    // ─── PALIER 5 : Les Calculs — disponible dans les 4 langues ; les
    // niveaux CP/CE1/CE2/CM1/CM2 restent des identifiants internes de
    // regroupement/tri mais s'affichent sous une étiquette générique
    // traduite ("Niveau 1".."Niveau 5", voir `calculNiveauLabel` dans
    // `calcul_catalog.dart`) plutôt que la nomenclature scolaire française.
    // ───
    steps.add(
      StepEntry(
        Step(
          kind: StepKind.header,
          title: pal(4, 'title'),
          subtitle: pal(4, 'subtitle'),
          tagline: pal(4, 'tagline'),
          palierNum: 5,
          bannerBg: const Color(0xFF8B5FBF),
          bannerBorder: const Color(0xFF6B3F94),
          bannerIcon: LucideIcons.calculator,
        ),
        0,
      ),
    );

    final calculDoneFlags = [
      for (final topic in CALCUL_TOPICS) _calculTopicDone(progress, topic),
    ];
    final calculCurrentIdx = _currentGroupIndex(calculDoneFlags);
    for (var idx = 0; idx < CALCUL_TOPICS.length; idx++) {
      final kind = idx <= calculCurrentIdx
          ? StepKind.active
          : StepKind.locked;
      final done = idx < calculCurrentIdx;
      final topic = CALCUL_TOPICS[idx];
      steps.add(
        StepEntry(
          Step(
            kind: kind,
            iconType: 'feuille',
            stepTitle: topic.title[lang.name] ?? topic.title['fr']!,
            isDone: done,
          ),
          -1,
          to: '/cours/calcul/${topic.id}',
        ),
      );
      steps.add(
        StepEntry(
          Step(kind: kind, iconType: 'branche', isDone: done),
          1,
          to: '/exercice/calcul/${topic.id}',
        ),
      );
      final isLastOfNiveau =
          idx == CALCUL_TOPICS.length - 1 ||
          CALCUL_TOPICS[idx + 1].niveau != topic.niveau;
      if (isLastOfNiveau) {
        final niveauIdx = _calculNiveaux.indexOf(topic.niveau);
        steps.add(
          StepEntry(
            const Step(kind: StepKind.vraiFaux),
            0,
            to: '/exercice/calcul-vrai-faux/$niveauIdx',
          ),
        );
        steps.add(
          StepEntry(
            const Step(kind: StepKind.composeNombre),
            0,
            to: '/exercice/calcul-compose/$niveauIdx',
          ),
        );
      }
    }
    steps.add(
      StepEntry(
        const Step(kind: StepKind.medal),
        0,
        to: '/exercice/calcul/${CALCUL_TOPICS[0].id}?amaniEval=1',
      ),
    );

    // ─── PALIER 6 : Les Figures géométriques (vocabulaire universel, pas
    // lié au système scolaire français — disponible dans les 4 langues) ───
    final figuresPalier =
        t['parcours']?['figuresPalier'] as Map<String, dynamic>?;
    steps.add(
      StepEntry(
        Step(
          kind: StepKind.header,
          title: figuresPalier?['title'] ?? '',
          subtitle: figuresPalier?['subtitle'] ?? '',
          tagline: figuresPalier?['tagline'] ?? '',
          palierNum: 6,
          bannerBg: const Color(0xFFE07A7A),
          bannerBorder: const Color(0xFFB85454),
          bannerIcon: LucideIcons.shapes,
        ),
        0,
      ),
    );

    final shapeDoneFlags = [
      for (final topic in SHAPE_TOPICS) _shapeTopicDone(progress, topic),
    ];
    final shapeCurrentIdx = _currentGroupIndex(shapeDoneFlags);
    for (var idx = 0; idx < SHAPE_TOPICS.length; idx++) {
      final kind = idx <= shapeCurrentIdx ? StepKind.active : StepKind.locked;
      final done = idx < shapeCurrentIdx;
      final topic = SHAPE_TOPICS[idx];
      steps.add(
        StepEntry(
          Step(
            kind: kind,
            iconType: 'feuille',
            stepTitle: topic.name[lang.name],
            isDone: done,
          ),
          -1,
          to: '/cours/figure/${topic.id}',
        ),
      );
      steps.add(
        StepEntry(
          Step(kind: kind, iconType: 'branche', isDone: done),
          1,
          to: '/exercice/figure/${topic.id}',
        ),
      );
    }
    final tangramSimple = tangramPuzzlesByDifficulty(TangramDifficulty.simple);
    for (var idx = 0; idx < tangramSimple.length; idx++) {
      const kind = StepKind.locked;
      final puzzle = tangramSimple[idx];
      steps.add(
        StepEntry(
          Step(
            kind: kind,
            iconType: 'feuille',
            stepTitle: puzzle.name[lang.name],
          ),
          -1,
          to: '/cours/tangram/${puzzle.id}',
        ),
      );
      steps.add(
        StepEntry(
          const Step(kind: kind, iconType: 'branche'),
          1,
          to: '/exercice/tangram/${puzzle.id}',
        ),
      );
    }
    steps.add(
      StepEntry(
        const Step(kind: StepKind.figureQuiz),
        0,
        to: '/exercice/figure-quiz',
      ),
    );
    steps.add(
      StepEntry(
        const Step(kind: StepKind.figureVraiFaux),
        0,
        to: '/exercice/figure-vrai-faux',
      ),
    );
    steps.add(
      StepEntry(
        const Step(kind: StepKind.figureObjet),
        0,
        to: '/exercice/figure-objet',
      ),
    );
    steps.add(
      StepEntry(
        const Step(kind: StepKind.medal),
        0,
        to: '/exercice/figure/${SHAPE_TOPICS[0].id}?amaniEval=1',
      ),
    );

    // Chaque étape hérite de la couleur du dernier en-tête de palier rencontré.
    // Numérotation continue de toutes les étapes (hors en-têtes de palier),
    // pour le petit badge rappelant la position dans le parcours. Les étapes
    // bonus/médaille n'affichent jamais ce badge (voir les branches
    // `StepKind.bonus`/`StepKind.medal` du switch de rendu plus bas) : on ne
    // leur attribue donc pas non plus de numéro, pour que la suite visible
    // de numéros reste toujours consécutive (sans ce saut, une étape bonus
    // ou médaille "consommait" un numéro jamais affiché, créant un trou
    // visible dans la séquence).
    Color currentColor = const Color(0xFF8FBF6F);
    Color currentBorder = const Color(0xFF5E8E3E);
    int stepNumber = 0;
    for (final entry in steps) {
      if (entry.step.kind == StepKind.header) {
        currentColor = entry.step.bannerBg ?? currentColor;
        currentBorder = entry.step.bannerBorder ?? currentBorder;
      } else {
        entry.color = entry.step.isDone
            ? _mutedColor(currentColor)
            : currentColor;
        entry.borderColor = entry.step.isDone
            ? _mutedColor(currentBorder)
            : currentBorder;
        if (entry.step.kind != StepKind.bonus &&
            entry.step.kind != StepKind.medal) {
          stepNumber += 1;
          entry.number = stepNumber;
        }
      }
    }

    return steps;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final lang = context.watch<LanguageProvider>().lang;
    final progress = context.watch<ProgressProvider>();
    final steps = _buildSteps(t, lang, progress);
    _scheduleNodeMeasurement();
    final palierHeaders = [
      for (final entry in steps)
        if (entry.step.kind == StepKind.header) entry.step,
    ];

    return Stack(
      children: [
        _buildPath(steps, t),
        Positioned(
          right: 12,
          top: 0,
          bottom: 0,
          child: Center(
            child: _PalierQuickNav(
              headers: palierHeaders,
              isOpen: _quickNavOpen,
              onToggle: () => setState(() => _quickNavOpen = !_quickNavOpen),
              onSelect: _onQuickNavSelect,
              openAria: t['parcours']?['quickNavOpenAria'] ?? '',
              closeAria: t['parcours']?['quickNavCloseAria'] ?? '',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPath(List<StepEntry> steps, Map<String, dynamic> t) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AmaniColors.background, AmaniColors.backgroundAlt],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête de page
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t['parcours']?['title'] ?? '',
                            style: AmaniTheme.titleStyle.copyWith(
                              fontSize: 24,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            t['parcours']?['subtitle'] ?? '',
                            style: AmaniTheme.bodyStyle.copyWith(
                              color: AmaniColors.textSecondary,
                              fontSize: 14,
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
              ),

              // Sentier de pas, calé sur la position réelle de chaque étape
              // (voir `_measureNodes`) plutôt qu'un zigzag générique.
              LayoutBuilder(
                builder: (context, constraints) {
                  // `maxWidth` n'est PAS garantie finie : selon le moment où
                  // la toute première passe de layout tombe par rapport à
                  // l'arrivée des vraies dimensions de fenêtre côté plateforme
                  // (course bien plus probable en AOT -- release/profile
                  // démarrent beaucoup plus vite qu'en debug/JIT), cette
                  // contrainte peut valoir `double.infinity`. La largeur
                  // servait ensuite au décalage latéral de chaque étape
                  // (`_StepRow`, `Transform.translate`) : un `Infinity`/`NaN`
                  // y corrompait la matrice de transformation de TOUTE la
                  // sous-arborescence, et faisait lever, en pleine phase de
                  // peinture, « Unsupported operation: Infinity or NaN toInt »
                  // au moment de peindre l'image du badge de palier
                  // (`StepKind.medal`). Comme l'exception survient dans
                  // `paint()` (hors du filet de sécurité de `build()`), la
                  // sous-arborescence restait définitivement non peinte --
                  // bannières de palier ET étapes invisibles, sans aucune
                  // erreur visible, alors que le sentier d'empreintes (peint
                  // juste avant dans le même `Stack`) s'affichait, lui,
                  // normalement. Diagnostiqué sur appareil réel (voir la trace
                  // complète en profile, 2026-09-10).
                  final maxWidth = constraints.maxWidth.isFinite
                      ? constraints.maxWidth
                      : MediaQuery.sizeOf(context).width;
                  final width = math.max(
                    0.0,
                    maxWidth - 48,
                  ); // padding horizontal 24+24
                  var nonHeaderIdx = 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Stack(
                      key: _pathAreaKey,
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _FootpathPainter(rects: _nodeRects),
                          ),
                        ),
                        Column(
                          children: [
                            for (int i = 0; i < steps.length; i++)
                              _StepRow(
                                entry: steps[i],
                                index: i,
                                width: width,
                                isCurrent: i == _activeStepIdx,
                                t: t,
                                onTap: () => _onStepTap(i, steps[i].to, t),
                                anchorKey: steps[i].step.kind == StepKind.header
                                    ? _palierKeys[steps[i].step.palierNum]
                                    : null,
                                nodeKey: steps[i].step.kind == StepKind.header
                                    ? null
                                    : _nodeKeyFor(nonHeaderIdx++),
                              ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Menu déroulant de navigation rapide entre paliers, ancré verticalement
/// centré sur le bord droit de l'écran. Replié, un simple bouton rond
/// ("signpost") reste discret par-dessus le sentier ; déplié, il révèle un
/// petit bouton rond par palier (couleur et icône reprises de sa bannière,
/// voir `Step.bannerBg`/`bannerBorder`/`bannerIcon`), qui fait défiler
/// directement jusqu'à ce palier (`_ParcoursScreenState._scrollToPalier`) —
/// pensé pour les paliers à beaucoup d'étapes (Calculs, Mots), où défiler
/// manuellement toute la liste est fastidieux.
class _PalierQuickNav extends StatelessWidget {
  final List<Step> headers;
  final bool isOpen;
  final VoidCallback onToggle;
  final ValueChanged<int> onSelect;
  final String openAria;
  final String closeAria;

  const _PalierQuickNav({
    required this.headers,
    required this.isOpen,
    required this.onToggle,
    required this.onSelect,
    required this.openAria,
    required this.closeAria,
  });

  static const double _buttonSize = 44;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AmaniColors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AmaniColors.textPrimary.withValues(alpha: 0.1),
        ),
        boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            alignment: Alignment.bottomCenter,
            child: !isOpen
                ? const SizedBox(width: _buttonSize)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final header in headers) ...[
                        _QuickNavButton(
                          color: header.bannerBg ?? AmaniColors.secondary,
                          borderColor:
                              header.bannerBorder ?? AmaniColors.secondaryDark,
                          icon: header.bannerIcon ?? LucideIcons.leaf,
                          iconAsset: header.bannerIconAsset,
                          label: header.title ?? '',
                          size: _buttonSize,
                          onTap: () => onSelect(header.palierNum!),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
          ),
          // Sépare visuellement les boutons d'accès aux paliers de la croix
          // de fermeture, pour éviter toute confusion entre les deux --
          // absent quand le menu est replié (rien à séparer).
          if (isOpen)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Container(
                width: _buttonSize,
                height: 1,
                color: AmaniColors.textPrimary.withValues(alpha: 0.15),
              ),
            ),
          Semantics(
            button: true,
            label: isOpen ? closeAria : openAria,
            child: GestureDetector(
              onTap: onToggle,
              child: Container(
                width: _buttonSize,
                height: _buttonSize,
                decoration: const BoxDecoration(
                  color: AmaniColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isOpen ? LucideIcons.x : LucideIcons.menu,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickNavButton extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final IconData icon;
  final String? iconAsset;
  final String label;
  final double size;
  final VoidCallback onTap;

  const _QuickNavButton({
    required this.color,
    required this.borderColor,
    required this.icon,
    this.iconAsset,
    required this.label,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
          ),
          child: iconAsset != null
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    iconAsset!,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                )
              : Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

/// Trace le chemin reliant les étapes non pas par un simple pointillé mais
/// par une piste de petites empreintes de pas alternées (gauche/droite),
/// façon sentier — un segment indépendant par tronçon (d'une étape à la
/// suivante, dans l'ordre), visant le centre du rectangle mesuré de chaque
/// étape (voir `_ParcoursScreenState._measureNodes` et `_StepNode.nodeKey`,
/// désormais posée sur la colonne ENTIÈRE de l'étape -- icône, bulle
/// "Commencer" éventuelle et étiquette de titre comprises -- plutôt que sur
/// la seule icône). Chaque tronçon est découpé (voir
/// `_clipSegmentOutsideRects`) pour ne JAMAIS pénétrer dans le rectangle
/// mesuré d'aucune des deux étapes qu'il relie, quels que soient la langue,
/// la longueur du titre (y compris sur 2 lignes) ou le réglage d'échelle de
/// l'interface -- plutôt qu'une simple marge fixe le long du tracé, qui
/// laissait passer les empreintes sur l'étiquette dès qu'un tronçon était
/// peu incliné (proche de l'horizontale). Les empreintes vont ainsi
/// explicitement, et de façon visuellement saccadée, d'un bouton d'étape à
/// l'autre — un groupe d'empreintes bien distinct par tronçon, jamais collé
/// aux icônes ni aux étiquettes, ni raccordé au groupe voisin.
class _FootpathPainter extends CustomPainter {
  final List<Rect>? rects;

  _FootpathPainter({required this.rects});

  /// Marge additionnelle, au-delà du rectangle mesuré lui-même, avant d'y
  /// semer des empreintes -- purement esthétique (un vide net et visible
  /// entre deux groupes d'empreintes consécutifs) une fois que le rectangle
  /// garantit déjà, à lui seul, l'absence totale de chevauchement.
  static const double _safetyGap = 12.0;

  /// Échelle de chaque empreinte (coussinet + orteils, voir
  /// `_drawFootprint`) — répercutée aussi sur l'écart entre deux empreintes
  /// et sur leur décalage latéral (démarche gauche/droite) pour que
  /// l'agrandissement reste cohérent plutôt que de faire chevaucher des
  /// empreintes devenues plus grosses mais toujours aussi rapprochées.
  static const double _footScale = 1.4;

  /// Portion du segment [a, b] (en paramètre `t`, 0=a, 1=b) qui se trouve à
  /// l'intérieur de `rect`, élargi de [_safetyGap] -- `null` si le segment ne
  /// traverse jamais ce rectangle élargi. Découpage de segment par droite
  /// (Liang-Barsky) : robuste quel que soit l'angle du segment, contrairement
  /// à une marge appliquée le long du tracé.
  (double, double)? _paramRangeInsideRect(Offset a, Offset b, Rect rect) {
    final r = rect.inflate(_safetyGap);
    var t0 = 0.0, t1 = 1.0;
    final dx = b.dx - a.dx;
    final dy = b.dy - a.dy;
    final edges = [
      (-dx, a.dx - r.left),
      (dx, r.right - a.dx),
      (-dy, a.dy - r.top),
      (dy, r.bottom - a.dy),
    ];
    for (final (p, q) in edges) {
      if (p == 0) {
        if (q < 0) return null; // Parallèle à ce bord, entièrement à l'écart.
        continue;
      }
      final t = q / p;
      if (p < 0) {
        if (t > t1) return null;
        if (t > t0) t0 = t;
      } else {
        if (t < t0) return null;
        if (t < t1) t1 = t;
      }
    }
    return (t0, t1);
  }

  /// Rallonge volontaire de la portion visible du segment, au-delà du point
  /// de sortie/entrée strict des rectangles des étapes -- pour qu'environ
  /// deux empreintes de plus apparaissent de chaque côté, au plus près du
  /// bouton qui sert d'extrémité (demande explicite : les empreintes
  /// s'arrêtaient trop tôt, laissant un vide visuel avant chaque étape).
  /// Exprimée en pixels le long du segment, convertie en fraction `t` selon
  /// la longueur réelle de CE segment (voir [_clipSegmentOutsideRects]) --
  /// une valeur fixe en `t` aurait rallongé les segments courts bien plus
  /// que les longs.
  static const double _extraReachPx = 2 * 22.0 * _footScale;

  /// Portion visible du segment [a, b] une fois retranchée toute
  /// intersection avec `rectA` (contenant `a`) et `rectB` (contenant `b`),
  /// puis rallongée de [_extraReachPx] de chaque côté (voir ci-dessus) --
  /// `null` si les deux rectangles se recouvrent le long du segment (étapes
  /// trop rapprochées pour laisser la moindre empreinte entre elles).
  (Offset, Offset)? _clipSegmentOutsideRects(
    Offset a,
    Offset b,
    Rect rectA,
    Rect rectB,
  ) {
    // `a` est au centre de `rectA` (donc à l'intérieur) : la sortie de
    // `rectA` en direction de `b` est le second point (`t1`) de
    // l'intersection. Symétriquement pour `rectB` côté `b`.
    final length = (b - a).distance;
    final deltaT = length > 0 ? _extraReachPx / length : 0.0;
    final exitA = ((_paramRangeInsideRect(a, b, rectA)?.$2 ?? 0.0) - deltaT)
        .clamp(0.0, 1.0);
    final entryB = ((_paramRangeInsideRect(a, b, rectB)?.$1 ?? 1.0) + deltaT)
        .clamp(0.0, 1.0);
    if (exitA >= entryB) return null;
    Offset lerp(double t) => Offset.lerp(a, b, t)!;
    return (lerp(exitA), lerp(entryB));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final r = rects;
    if (r == null || r.length < 2) return;

    final path = Path();
    for (var i = 0; i < r.length - 1; i++) {
      final rectA = r[i];
      final rectB = r[i + 1];
      final clipped = _clipSegmentOutsideRects(
        rectA.center,
        rectB.center,
        rectA,
        rectB,
      );
      if (clipped == null) continue;
      final (start, end) = clipped;
      path.moveTo(start.dx, start.dy);
      path.lineTo(end.dx, end.dy);
    }

    final footColor = const Color(0xFF000000).withValues(alpha: 0.32);
    // Écart entre deux empreintes le long du sentier, et décalage latéral
    // gauche/droite (démarche) — mis à l'échelle avec `_footScale`.
    const stepDistance = 22.0 * _footScale;
    const strideOffset = 4.5 * _footScale;

    var stepIndex = 0;
    for (final metric in path.computeMetrics()) {
      var distance = 6.0;
      while (distance < metric.length) {
        final tangent = metric.getTangentForOffset(distance);
        if (tangent != null) {
          final angle = tangent.vector.direction;
          _drawFootprint(
            canvas,
            tangent.position,
            angle,
            stepIndex.isEven,
            footColor,
            strideOffset,
          );
          stepIndex++;
        }
        distance += stepDistance;
      }
    }
  }

  /// Empreinte façon patte d'animal (un gros coussinet principal + 4
  /// coussinets d'orteils en éventail devant) — reprend le style de
  /// l'image de référence fournie par l'utilisateur, plutôt qu'une simple
  /// semelle de chaussure. L'axe local +X (après rotation par [angle])
  /// pointe dans le sens de la marche : le coussinet principal reste en
  /// arrière, les orteils en éventail devant.
  void _drawFootprint(
    Canvas canvas,
    Offset center,
    double angle,
    bool isLeft,
    Color color,
    double strideOffset,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.translate(0, (isLeft ? -1 : 1) * strideOffset);

    final pad = Paint()..color = color;

    // Coussinet principal : ovale légèrement aplati, en arrière.
    canvas.save();
    canvas.translate(-3.5 * _footScale, 0);
    canvas.rotate(0.05);
    canvas.scale(1.15, 0.9);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: 8.5 * _footScale,
        height: 7.5 * _footScale,
      ),
      pad,
    );
    canvas.restore();

    // 4 coussinets d'orteils en éventail devant, chacun légèrement pivoté
    // pour évoquer des doigts qui s'écartent.
    final toeOffsets = [
      Offset(4.6, -4.4) * _footScale,
      Offset(6.6, -1.6) * _footScale,
      Offset(6.6, 1.6) * _footScale,
      Offset(4.6, 4.4) * _footScale,
    ];
    const toeAngles = [-0.7, -0.25, 0.25, 0.7];
    for (var i = 0; i < 4; i++) {
      canvas.save();
      canvas.translate(toeOffsets[i].dx, toeOffsets[i].dy);
      canvas.rotate(toeAngles[i]);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: 4.2 * _footScale,
          height: 2.8 * _footScale,
        ),
        pad,
      );
      canvas.restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FootpathPainter oldDelegate) =>
      !identical(oldDelegate.rects, rects);
}

/// Largeur de référence (voir `_StepRow.build`) au-delà de laquelle
/// l'amplitude du zigzag entre deux étapes n'augmente plus -- proche de la
/// largeur d'une tablette en portrait, un rendu déjà considéré satisfaisant ;
/// ce plafond évite que le sentier ne s'étire au-delà sur un écran plus
/// large (tablette en paysage, grand écran), sans jamais réduire l'amplitude
/// des écrans plus étroits.
const double _kZigzagRefWidth = 620;

class _StepRow extends StatelessWidget {
  final StepEntry entry;
  final int index;
  final double width;
  final bool isCurrent;
  final Map<String, dynamic> t;
  final VoidCallback? onTap;

  /// Ancre stable posée sur la bannière (voir `_ParcoursScreenState._palierKeys`),
  /// non `null` uniquement pour une entrée d'en-tête de palier.
  final GlobalKey? anchorKey;

  /// Ancre posée sur le nœud lui-même (voir `_ParcoursScreenState._nodeKeys`
  /// / `_measureNodes`), pour que le sentier peint en arrière-plan
  /// (`_FootpathPainter`) puisse passer exactement sous sa position réelle
  /// — `null` uniquement pour une entrée d'en-tête de palier.
  final GlobalKey? nodeKey;

  const _StepRow({
    required this.entry,
    required this.index,
    required this.width,
    required this.isCurrent,
    required this.t,
    this.onTap,
    this.anchorKey,
    this.nodeKey,
  });

  @override
  Widget build(BuildContext context) {
    final step = entry.step;

    if (step.kind == StepKind.header) {
      return KeyedSubtree(
        key: anchorKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: _PalierBanner(step: step),
        ),
      );
    }

    // L'amplitude du zigzag est calée sur `width`, mais celle-ci varie
    // énormément d'un écran à l'autre -- pas seulement entre téléphone et
    // tablette, mais aussi entre portrait et paysage sur un MÊME appareil
    // (ex. tablette~: ~589px de large en portrait contre jusqu'à 900px en
    // paysage, une fois la largeur de contenu plafonnée par
    // `kTabletBreakpoint`/`ConstrainedBox` dans `app_shell.dart`). Sans
    // plafond, l'écart entre deux étapes consécutives passe alors de ~130px
    // à ~200px rien qu'en tournant l'appareil, alors que la taille des
    // icônes, elle, ne bouge pas -- d'où un sentier qui paraît nettement
    // plus "étiré"/moins compact en paysage. On calcule donc l'amplitude à
    // partir d'une largeur de référence plafonnée (`_kZigzagRefWidth`,
    // proche de la largeur d'une tablette en portrait -- le rendu déjà jugé
    // satisfaisant) plutôt que de la largeur réelle, pour un zigzag à
    // l'amplitude visuellement stable quel que soit l'écran ou son
    // orientation ; les écrans plus étroits qu'elle (téléphones) restent,
    // eux, inchangés, puisque `math.min` ne fait alors rien.
    //
    // Deuxième garde-fou, après celle sur `width` côté `LayoutBuilder` : une
    // valeur non finie transmise ici corromprait la matrice de transformation
    // de toute la sous-arborescence de l'étape, et ferait échouer sa peinture
    // (image du badge de palier comprise) sans aucune erreur visible -- voir
    // la note détaillée sur le calcul de `width`.
    final rawOffset = entry.side * (math.min(width, _kZigzagRefWidth) * 0.22);
    final offset = rawOffset.isFinite ? rawOffset : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Align(
        alignment: Alignment.topCenter,
        child: Transform.translate(
          offset: Offset(offset, 0),
          child: GestureDetector(
            onTap: onTap,
            child: _StepNode(
              nodeKey: nodeKey,
              step: step,
              isCurrent: isCurrent,
              color: entry.color ?? AmaniColors.secondary,
              borderColor: entry.borderColor ?? AmaniColors.secondaryDark,
              number: entry.number,
              t: t,
            ),
          ),
        ),
      ),
    );
  }
}

class _PalierBanner extends StatelessWidget {
  final Step step;
  const _PalierBanner({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            step.bannerBg ?? AmaniColors.secondary,
            step.bannerBorder ?? AmaniColors.secondaryDark,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: step.bannerBorder ?? AmaniColors.secondaryDark,
            offset: const Offset(0, 6),
          ),
          const BoxShadow(
            color: Color(0x384A3B2A),
            offset: Offset(0, 10),
            blurRadius: 24,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -16,
            top: -24,
            child: Opacity(
              opacity: 0.2,
              child: Transform.rotate(
                angle: 0.2,
                child: const Icon(
                  LucideIcons.leaf,
                  size: 96,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: step.bannerIconAsset != null
                    ? Padding(
                        padding: const EdgeInsets.all(11),
                        child: SvgPicture.asset(
                          step.bannerIconAsset!,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      )
                    : Icon(
                        step.bannerIcon ?? LucideIcons.leaf,
                        color: Colors.white,
                        size: 28,
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      capitalizeFirst(step.subtitle ?? ''),
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 1.4,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      step.title ?? '',
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w800,
                        fontSize: 19,
                        height: 1.15,
                        color: Colors.white,
                      ),
                    ),
                    if ((step.tagline ?? '').isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          step.tagline!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${step.palierNum ?? ''}',
                  style: TextStyle(
                    fontFamily: kBalooFontFamily,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepNode extends StatefulWidget {
  final Step step;
  final bool isCurrent;
  final Color color;
  final Color borderColor;
  final int? number;
  final Map<String, dynamic> t;

  /// Ancre posée sur la colonne entière de l'étape (voir
  /// `_ParcoursScreenState._nodeKeys` / `_measureNodes`) — icône, bulle
  /// "Commencer" éventuelle ET étiquette de titre en dessous (Cours,
  /// Exercice, Traits...) comprises, pour que le sentier peint en
  /// arrière-plan (`_FootpathPainter`) connaisse le rectangle RÉEL de
  /// l'étape et ne chevauche jamais le texte, quels que soient la langue ou
  /// la taille de police.
  final GlobalKey? nodeKey;

  const _StepNode({
    required this.step,
    required this.isCurrent,
    required this.color,
    required this.borderColor,
    this.number,
    required this.t,
    this.nodeKey,
  });

  @override
  State<_StepNode> createState() => _StepNodeState();
}

class _StepNodeState extends State<_StepNode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pingController;

  @override
  void initState() {
    super.initState();
    _pingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _pingController.dispose();
    super.dispose();
  }

  String get _stepLabel {
    final parcours = widget.t['parcours'] as Map<String, dynamic>? ?? {};
    if (widget.step.stepTitle != null) return widget.step.stepTitle!;
    if (widget.step.signFamily != null) {
      final titles =
          widget.t['coursFamily']?['titles'] as Map<String, dynamic>? ?? {};
      return (titles[widget.step.signFamily] as String?) ??
          parcours['coursStep'] ??
          '';
    }
    if (widget.step.kind == StepKind.wordsearch) {
      return parcours['wordSearchStep'] ?? '';
    }
    if (widget.step.kind == StepKind.vraiFaux) {
      return parcours['vraiFauxStep'] ?? '';
    }
    if (widget.step.kind == StepKind.composeNombre) {
      return parcours['composeStep'] ?? '';
    }
    if (widget.step.kind == StepKind.figureQuiz) {
      return parcours['figureQuizStep'] ?? '';
    }
    if (widget.step.kind == StepKind.figureVraiFaux) {
      return parcours['figureVraiFauxStep'] ?? '';
    }
    if (widget.step.kind == StepKind.figureObjet) {
      return parcours['figureObjetStep'] ?? '';
    }
    if (widget.step.kind == StepKind.puzzleFormule) {
      return parcours['puzzleFormuleStep'] ?? '';
    }
    if (widget.step.iconType == 'branche') {
      return parcours['exerciceStep'] ?? '';
    }
    return parcours['coursStep'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final parcours = widget.t['parcours'] as Map<String, dynamic>? ?? {};

    switch (widget.step.kind) {
      case StepKind.header:
        return const SizedBox.shrink();

      case StepKind.active:
      case StepKind.locked:
        final bool bigNode =
            widget.step.kind == StepKind.active || widget.isCurrent;
        final double dim = bigNode ? 96 : 64;
        return Column(
          key: widget.nodeKey,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isCurrent)
              _StartPill(
                borderColor: widget.borderColor,
                label: parcours['start'] ?? 'Commencer',
              ),
            if (widget.isCurrent) const SizedBox(height: 10),
            SizedBox(
              width: dim + 24,
              height: dim + 24,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  if (widget.isCurrent)
                    _PingRing(
                      controller: _pingController,
                      color: widget.color,
                      size: dim,
                    ),
                  if (widget.isCurrent)
                    _CurrentSparkles(color: widget.borderColor, size: dim + 24),
                  Container(
                    width: dim,
                    height: dim,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bigNode ? widget.color : AmaniColors.disabled,
                      border: Border.all(
                        color: bigNode
                            ? widget.borderColor
                            : AmaniColors.disabled,
                        width: 4,
                      ),
                      boxShadow: AmaniShadows.card,
                    ),
                    alignment: Alignment.center,
                    child: _signFamilyFromKey(widget.step.signFamily) != null
                        ? SignGlyph(
                            family: _signFamilyFromKey(widget.step.signFamily)!,
                            variant: widget.step.signFamily == 'courbe'
                                ? 'open-right'
                                : 'vertical',
                            stroke: bigNode
                                ? Colors.white
                                : AmaniColors.textSecondary.withValues(
                                    alpha: 0.7,
                                  ),
                            size: bigNode ? 56 : 36,
                          )
                        : Icon(
                            widget.step.iconType == 'branche'
                                ? LucideIcons.pen
                                : LucideIcons.bookOpen,
                            size: bigNode
                                ? (widget.step.iconType == 'branche' ? 38 : 40)
                                : (widget.step.iconType == 'branche' ? 24 : 26),
                            color: bigNode
                                ? Colors.white
                                : AmaniColors.textSecondary.withValues(
                                    alpha: 0.7,
                                  ),
                          ),
                  ),
                  if (widget.number != null)
                    Positioned(
                      // Le cercle est centré dans une boîte 24px plus grande
                      // (padding uniforme de 12px de chaque côté, pour la
                      // marge du ping-ring) : le badge se cale sur le coin
                      // haut-droit du cercle, décalé de 4px vers l'extérieur
                      // — mêmes proportions que "-top-1 -right-1" en React.
                      top: 8,
                      right: 8,
                      child: _NumberBadge(
                        number: widget.number!,
                        color: widget.borderColor,
                        muted: !widget.isCurrent,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              capitalizeFirst(_stepLabel),
              style: TextStyle(
                fontFamily: kBalooFontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 11,
                letterSpacing: 0.6,
                color: bigNode
                    ? Colors.black
                    : AmaniColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        );

      case StepKind.wordsearch:
        final bool bigWs = widget.isCurrent;
        return Column(
          key: widget.nodeKey,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isCurrent)
              _StartPill(
                borderColor: widget.borderColor,
                label: parcours['start'] ?? 'Commencer',
              ),
            if (widget.isCurrent) const SizedBox(height: 10),
            Stack(
              clipBehavior: Clip.none,
              children: [
                if (widget.isCurrent)
                  _CurrentSparkles(
                    color: widget.borderColor,
                    size: bigWs ? 80 : 56,
                  ),
                Container(
                  width: bigWs ? 80 : 56,
                  height: bigWs ? 80 : 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: bigWs ? widget.color : AmaniColors.disabled,
                    border: Border.all(
                      color: bigWs ? widget.borderColor : AmaniColors.disabled,
                      width: 4,
                    ),
                    boxShadow: AmaniShadows.card,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    LucideIcons.search,
                    size: bigWs ? 36 : 24,
                    color: bigWs
                        ? Colors.white
                        : AmaniColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
                if (widget.number != null)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: _NumberBadge(
                      number: widget.number!,
                      color: widget.borderColor,
                      muted: !widget.isCurrent,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              capitalizeFirst(_stepLabel),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: kBalooFontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 11,
                color: bigWs
                    ? widget.borderColor
                    : AmaniColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        );

      case StepKind.vraiFaux:
      case StepKind.composeNombre:
      case StepKind.figureQuiz:
      case StepKind.figureVraiFaux:
      case StepKind.figureObjet:
      case StepKind.puzzleFormule:
        final bool bigGame = widget.isCurrent;
        return Column(
          key: widget.nodeKey,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isCurrent)
              _StartPill(
                borderColor: widget.borderColor,
                label: parcours['start'] ?? 'Commencer',
              ),
            if (widget.isCurrent) const SizedBox(height: 10),
            Stack(
              clipBehavior: Clip.none,
              children: [
                if (widget.isCurrent)
                  _CurrentSparkles(
                    color: widget.borderColor,
                    size: bigGame ? 80 : 56,
                  ),
                Container(
                  width: bigGame ? 80 : 56,
                  height: bigGame ? 80 : 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: bigGame ? widget.color : AmaniColors.disabled,
                    border: Border.all(
                      color: bigGame
                          ? widget.borderColor
                          : AmaniColors.disabled,
                      width: 4,
                    ),
                    boxShadow: AmaniShadows.card,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    switch (widget.step.kind) {
                      StepKind.vraiFaux ||
                      StepKind.figureVraiFaux => LucideIcons.helpCircle,
                      StepKind.figureQuiz => LucideIcons.shapes,
                      StepKind.figureObjet => LucideIcons.smile,
                      _ => LucideIcons.puzzle,
                    },
                    size: bigGame ? 36 : 24,
                    color: bigGame
                        ? Colors.white
                        : AmaniColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
                if (widget.number != null)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: _NumberBadge(
                      number: widget.number!,
                      color: widget.borderColor,
                      muted: !widget.isCurrent,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              capitalizeFirst(_stepLabel),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: kBalooFontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 11,
                color: bigGame
                    ? widget.borderColor
                    : AmaniColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        );

      case StepKind.bonus:
        return Container(
          key: widget.nodeKey,
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AmaniColors.disabled,
            border: Border.all(color: AmaniColors.disabled, width: 4),
            boxShadow: AmaniShadows.card,
          ),
          alignment: Alignment.center,
          child: _SvgIcon(
            svg: '$_bonusRibbonSvg $_bonusArcSvg',
            viewBox: const Size(40, 40),
            size: 30,
            color: AmaniColors.textSecondary,
            fill: false,
          ),
        );

      case StepKind.medal:
        return Container(
          key: widget.nodeKey,
          width: 80,
          height: 80,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AmaniColors.disabled,
            border: Border.all(color: AmaniColors.disabled, width: 4),
            boxShadow: AmaniShadows.card,
          ),
          child: Image.asset(
            'assets/images/amani-victoire-palier-badge.png',
            fit: BoxFit.cover,
          ),
        );
    }
  }
}

class _StartPill extends StatelessWidget {
  final Color borderColor;
  final String label;
  const _StartPill({required this.borderColor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
          decoration: BoxDecoration(
            color: AmaniColors.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: AmaniShadows.card,
          ),
          child: Text(
            capitalizeFirst(label),
            style: TextStyle(
              fontFamily: kBalooFontFamily,
              fontWeight: FontWeight.w800,
              fontSize: 13,
              letterSpacing: 0.6,
              color: Colors.black,
            ),
          ),
        ),
        Positioned(
          bottom: -5,
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                color: AmaniColors.surface,
                border: Border(
                  bottom: BorderSide(color: borderColor, width: 2),
                  right: BorderSide(color: borderColor, width: 2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PingRing extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  final double size;

  const _PingRing({
    required this.controller,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = Curves.easeOut.transform(controller.value);
        return Opacity(
          opacity: (1 - t).clamp(0.0, 1.0),
          child: Transform.scale(
            scale: 1 + t * 0.6,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.3),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Petit badge numéroté qui rappelle la position de l'étape dans le
/// parcours — port fidèle de `NumberBadge` (`_app.accueil.tsx`).
class _NumberBadge extends StatelessWidget {
  final int number;
  final Color color;
  final bool muted;

  const _NumberBadge({
    required this.number,
    required this.color,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = muted ? const Color(0xFF9C8F79) : color;
    // Diamètre assez large pour qu'un nombre à 3 chiffres (l'étape 100 et
    // au-delà) reste toujours entièrement lisible à l'intérieur du cercle,
    // pas seulement les nombres à 1-2 chiffres.
    final digits = '$number'.length;
    final size = digits >= 3 ? 32.0 : (digits == 2 ? 26.0 : 24.0);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AmaniColors.surface,
        border: Border.all(
          color: muted ? const Color(0xFFD8CCB8) : color,
          width: 2,
        ),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 2)],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            '$number',
            maxLines: 1,
            style: TextStyle(
              fontFamily: kBalooFontFamily,
              fontWeight: FontWeight.w800,
              fontSize: 11,
              color: c,
            ),
          ),
        ),
      ),
    );
  }
}

/// Quelques étincelles discrètes autour de l'étape en cours, pour un léger
/// effet ludique — port fidèle de `CurrentSparkles` (`_app.accueil.tsx`).
class _CurrentSparkles extends StatelessWidget {
  final Color color;

  /// Côté (en px) de la zone décorée. OBLIGATOIRE : les trois étincelles
  /// ci-dessous sont toutes `Positioned`, or un `Stack` sans le moindre
  /// enfant non-positionné prend `constraints.biggest` (voir
  /// `RenderStack._computeSize`). Sans cette taille explicite, ce `Stack`
  /// héritait donc d'une hauteur INFINIE dès qu'il était placé dans une zone
  /// défilante verticale -- ce qui est le cas pour les étapes de type jeu
  /// (mots mêlés, calculs, figures), dont l'icône n'est pas enveloppée dans
  /// un `SizedBox` contrairement aux étapes des paliers 1 à 4. Conséquence
  /// observée en conditions réelles : l'étape courante devenait infiniment
  /// haute, toutes les étapes SUIVANTES se retrouvaient à un décalage
  /// vertical infini, et leur peinture échouait silencieusement (offset
  /// infini -> `rect.size.height` = Infinity - Infinity = NaN dans
  /// `paintImage`). Résultat : plus aucune étape ni bannière visible sur
  /// l'accueil, seul le sentier d'empreintes (peint par un frère du `Stack`)
  /// restait affiché.
  final double size;

  const _CurrentSparkles({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -12,
            left: -20,
            child: Transform.rotate(
              angle: -0.21,
              child: Icon(
                LucideIcons.sparkle,
                size: 14,
                color: color.withValues(alpha: 0.7),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: -24,
            child: Transform.rotate(
              angle: 0.31,
              child: Icon(
                LucideIcons.sparkle,
                size: 10,
                color: color.withValues(alpha: 0.5),
              ),
            ),
          ),
          Positioned(
            bottom: -4,
            left: -24,
            child: Transform.rotate(
              angle: 0.1,
              child: Icon(
                LucideIcons.sparkle,
                size: 8,
                color: color.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SvgIcon extends StatelessWidget {
  final String svg;
  final Size viewBox;
  final double size;
  final Color color;
  final bool fill;

  const _SvgIcon({
    required this.svg,
    required this.viewBox,
    required this.size,
    required this.color,
    this.fill = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SvgPathPainter(
          svg: svg,
          viewBox: viewBox,
          color: color,
          fill: fill,
        ),
      ),
    );
  }
}

class _SvgPathPainter extends CustomPainter {
  final String svg;
  final Size viewBox;
  final Color color;
  final bool fill;

  _SvgPathPainter({
    required this.svg,
    required this.viewBox,
    required this.color,
    required this.fill,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(
      size.width / viewBox.width,
      size.height / viewBox.height,
    );
    canvas.save();
    canvas.translate(
      (size.width - viewBox.width * scale) / 2,
      (size.height - viewBox.height * scale) / 2,
    );
    canvas.scale(scale, scale);
    final path = parseSvgPathData(svg);
    final paint = Paint()
      ..color = color
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SvgPathPainter oldDelegate) =>
      oldDelegate.svg != svg || oldDelegate.color != color;
}
