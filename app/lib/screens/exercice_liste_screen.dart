import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../hooks/use_exercise_settings.dart';
import '../hooks/use_tracing_scroll_lock.dart';
import '../data/sign_exercise_catalog.dart';
import '../data/palier2_groups.dart';
import '../data/letter_style_resolver.dart';
import '../hooks/use_writing_style.dart';
import '../services/progress_service.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/repetition_row.dart';
import '../widgets/exercise_complete_popup.dart';
import '../widgets/free_writing_sheet.dart';
import '../widgets/evaluation_timer.dart';
import '../services/evaluation_session.dart';
import '../widgets/directional_icon.dart';
import '../utils/text_case.dart';
import '../utils/trace_validation.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../utils/navigation_helpers.dart';

/// "Cahier d'Écriture" : exerce chaque signe d'une famille (répétitions sur
/// grille Seyès), ou liste les caractères d'un groupe de progression (Palier
/// 2) menant chacun vers `/exercice/lettre/:char`. Port fidèle de
/// `src/routes/exercice-liste.tsx`.
class ExerciceListeScreen extends StatefulWidget {
  final String? family;
  final String? group;
  final String? amaniEval;

  /// Non `null` quand cette page est ouverte depuis le bouton "S'entrainer"
  /// du cours (Palier 1) pour un seul signe : filtre la liste à ce signe
  /// unique et bascule vers le petit circuit "pratique rapide" (1 point,
  /// bouton "Revenir à la leçon", pop-up puis retour au cours) plutôt que le
  /// circuit normal d'exercice de la famille entière.
  final String? sign;

  const ExerciceListeScreen({
    super.key,
    this.family,
    this.group,
    this.amaniEval,
    this.sign,
  });

  @override
  State<ExerciceListeScreen> createState() => _ExerciceListeScreenState();
}

/// Identifiant fixe de cette évaluation (Palier "Les Signes de base") —
/// voir `EvaluationSessionController.ensureContext`. Seule la variante
/// `?family=...&amaniEval=1` de cet écran déclenche jamais une évaluation
/// (la variante `?group=...`, Palier 2, n'ajoute jamais `amaniEval=1`).
const String _kEvalId = 'signes';

class _ExerciceListeScreenState extends State<ExerciceListeScreen> {
  late ExerciseSettings _settings;
  late final EvaluationSessionController _session;
  final Set<String> _doneSigns = {};
  int _restartKey = 0;
  bool _awaitingRepeatCompletion = false;

  /// `true` après la toute première restauration de `_doneSigns` depuis
  /// `ProgressProvider` (voir `build`) -- pour qu'un signe déjà tracé avec
  /// succès reste visuellement acquis en quittant puis en revenant sur cet
  /// exercice, au lieu de redemander un tracé déjà réussi. Fait une seule
  /// fois : sans ce garde-fou, la restauration se referait à CHAQUE
  /// reconstruction et annulerait aussitôt le "Recommencer" explicite de
  /// `ExerciseCompletePopup` (qui vide `_doneSigns` sans jamais toucher à la
  /// progression déjà acquise dans `ProgressProvider`, exprès, pour la
  /// reprise bonus).
  bool _restoredFromProgress = false;

  /// `true` uniquement lorsque le dernier signe manquant de la famille vient
  /// d'être réussi PENDANT cette visite (voir `_onEntryDone`) -- jamais lors
  /// de la restauration ci-dessus. Sans cette distinction, rouvrir une
  /// famille déjà entièrement réussie lors d'une visite précédente faisait
  /// immédiatement réapparaître la pop-up de félicitations (confettis
  /// compris), alors qu'aucun signe n'avait encore été tracé lors de CETTE
  /// visite.
  bool _justCompletedThisVisit = false;

  /// `true` après "Continuer en mode libre" (voir [ExerciseCompletePopup]) :
  /// masque la pop-up de fin (déjà déclenchée) sans jamais toucher à
  /// `_doneSigns`, pour que tous les signes restent acquis -- seule la
  /// feuille d'écriture libre en bas de page reste praticable ensuite.
  bool _freeModeOnly = false;

  bool get _isEvaluation => widget.amaniEval == '1';
  bool _showFirstSubjectAnnouncement = false;
  bool _showPracticeSuccess = false;
  Map<String, dynamic>? _resumeOffer;

  /// Pratique rapide d'un seul signe (bouton "S'entrainer" du cours) : 1
  /// point, pas de marquage de progression normale (l'utilisateur l'a
  /// explicitement demandé "juste un point, et c'est tout") — puis une
  /// pop-up de félicitation avant de revenir au cours.
  void _onPracticeEntryDone() {
    context.read<ProgressProvider>().awardSignPracticePoint();
    setState(() => _showPracticeSuccess = true);
  }

  @override
  void initState() {
    super.initState();
    _session = context.read<EvaluationSessionController>();
    _settings = ExerciseSettings()..addListener(_onSettingsChanged);
    _settings.load();
    if (_isEvaluation) _initEvaluation();
  }

  Future<void> _initEvaluation() async {
    if (!mounted) return;
    final continuing = _session.ensureContext(_kEvalId);
    _session.configureSubjects(FAMILY_ORDER.length);
    if (continuing) return;
    final saved = await _session.readSavedProgress(_kEvalId);
    if (!mounted) return;
    if (saved != null) {
      setState(() => _resumeOffer = saved);
    } else {
      setState(() => _showFirstSubjectAnnouncement = true);
    }
  }

  Future<void> _handleStartFirstSubject() async {
    final minutes = await readEvaluationDurationMinutes();
    if (!mounted) return;
    _session.start(minutes * 60);
    setState(() => _showFirstSubjectAnnouncement = false);
  }

  void _handleResume(Map<String, dynamic> saved) {
    _session.resumeFrom(saved);
    setState(() {
      _resumeOffer = null;
      _doneSigns
        ..clear()
        ..addAll(_session.completedItems);
    });
    final savedIdx = saved['currentSubjectIndex'] as int? ?? 0;
    if (savedIdx >= 0 && savedIdx < FAMILY_ORDER.length) {
      final savedFamily = FAMILY_ORDER[savedIdx];
      if (savedFamily != widget.family) {
        context.replace('/exercice-liste?family=$savedFamily&amaniEval=1');
      }
    }
  }

  void _handleRestart() {
    unawaited(_session.clearSavedProgress(_kEvalId));
    setState(() {
      _resumeOffer = null;
      _showFirstSubjectAnnouncement = true;
    });
  }

  void _onEntryDone(String id, int totalEntries) {
    setState(() {
      _doneSigns.add(id);
      if (_doneSigns.length >= totalEntries) {
        _justCompletedThisVisit = true;
      }
    });
    if (_isEvaluation) _session.recordItemDone(id);
    if (_doneSigns.length >= totalEntries && _awaitingRepeatCompletion) {
      context.read<ProgressProvider>().awardRestartBonus();
      setState(() => _awaitingRepeatCompletion = false);
    }
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    if (_isEvaluation) unawaited(_session.persistProgress());
    _settings.removeListener(_onSettingsChanged);
    _settings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final lang = context.watch<LanguageProvider>().lang;
    final speech = context.read<SignSpeechService>();
    final el = t['exerciceListe'] as Map<String, dynamic>? ?? {};

    final progressionGroup = widget.group != null
        ? getPalier2GroupMap(lang.name)[widget.group]
        : null;

    if (progressionGroup != null) {
      return _buildGroupMode(context, t, lang, speech, el, progressionGroup);
    }
    return _buildFamilyMode(context, t, lang, speech, el);
  }

  Widget _buildGroupMode(
    BuildContext context,
    Map<String, dynamic> t,
    Lang lang,
    SignSpeechService speech,
    Map<String, dynamic> el,
    ProgressionGroup group,
  ) {
    final style = context.watch<WritingStyleProvider>().style.name;
    final letters = group.chars
        .map((c) => getLetterFormation(c, style))
        .whereType<dynamic>()
        .toList();
    final isDigits = group.kind == ProgressionGroupKind.chiffres;
    final itemPrefix = isDigits
        ? el['digitPrefix'] ?? ''
        : el['letterPrefix'] ?? '';
    final subtitle = isDigits
        ? el['subtitleGroupDigits'] ?? ''
        : el['subtitleGroupLettres'] ?? '';

    return Scaffold(
      backgroundColor: AmaniColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              title: tFormat(el['titleGroup'] ?? '', {
                'titre': group.title[lang.name] ?? '',
              }),
              subtitle: subtitle,
              onBack: () =>
                  goHome(context),
            ),
            _HintBar(
              text: el['groupHint'] ?? '',
              bg: const Color(0xCCEAF1FB),
              fg: const Color(0xFF2D5E8A),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 48),
                itemCount: letters.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (context, i) {
                  final letter = letters[i];
                  final steps = letter['steps'] as List;
                  return GestureDetector(
                    onTap: () => context.push(
                      '/exercice/lettre/${letter['char']}?pg=${group.id}',
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AmaniColors.textPrimary.withValues(
                            alpha: 0.12,
                          ),
                        ),
                        boxShadow: const [
                          BoxShadow(color: Color(0x0D000000), blurRadius: 4),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AmaniColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AmaniColors.textPrimary.withValues(
                                  alpha: 0.12,
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              letter['char'],
                              style: TextStyle(
                                fontFamily: kBalooFontFamily,
                                fontWeight: FontWeight.w800,
                                fontSize: 26,
                                color: AmaniColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$itemPrefix "${letter['char']}"',
                                  style: AmaniTheme.titleStyle.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${letter['name'][lang.name] ?? ''} · ${tFormat(el['gestureCount'] ?? '', {'count': steps.length})}',
                                  style: AmaniTheme.bodyStyle.copyWith(
                                    fontSize: 12.5,
                                    color: AmaniColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    for (final st in steps)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AmaniColors.background,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          border: Border.all(
                                            color: AmaniColors.textPrimary
                                                .withValues(alpha: 0.08),
                                          ),
                                        ),
                                        child: Text(
                                          ((st['description'][lang.name] ?? '')
                                                  as String)
                                              .split(' ')
                                              .first,
                                          style: TextStyle(
                                            fontFamily: kBalooFontFamily,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11,
                                            color: AmaniColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AmaniColors.secondary.withValues(
                                alpha: 0.15,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: DirectionalIcon(
                              LucideIcons.chevronRight,
                              size: 18,
                              color: AmaniColors.secondaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyMode(
    BuildContext context,
    Map<String, dynamic> t,
    Lang lang,
    SignSpeechService speech,
    Map<String, dynamic> el,
  ) {
    final session = context.watch<EvaluationSessionController>();
    final familyNames = el['familyNames'] as Map<String, dynamic>? ?? {};
    final allGrouped = [
      (
        'point',
        familyNames['point'] ?? 'Points',
        EXERCISE_CATALOG.where((e) => e['family'] == 'point').toList(),
      ),
      (
        'courbe',
        familyNames['courbe'] ?? 'Courbes',
        EXERCISE_CATALOG.where((e) => e['family'] == 'courbe').toList(),
      ),
      (
        'crochet',
        familyNames['crochet'] ?? 'Crochets',
        EXERCISE_CATALOG.where((e) => e['family'] == 'crochet').toList(),
      ),
      (
        'trait',
        familyNames['trait'] ?? 'Traits',
        EXERCISE_CATALOG.where((e) => e['family'] == 'trait').toList(),
      ),
    ];

    final practiceMode = widget.sign != null;
    final grouped = widget.family != null
        ? allGrouped.where((g) => g.$1 == widget.family).toList()
        : allGrouped;
    // Pratique rapide (bouton "S'entrainer" du cours) : ne montrer QUE le
    // signe demandé, pas toute la famille.
    final displayedGroups = practiceMode
        ? grouped
              .map(
                (g) => (
                  g.$1,
                  g.$2,
                  g.$3.where((e) => e['id'] == widget.sign).toList(),
                ),
              )
              .where((g) => g.$3.isNotEmpty)
              .toList()
        : grouped;
    final headerTitle = widget.family != null && grouped.isNotEmpty
        ? tFormat(el['titleFamily'] ?? '', {'titre': grouped.first.$2})
        : (el['title'] ?? "Cahier d'Écriture");

    // Pop-up de fin d'exercice : uniquement pour une famille précise (une
    // vraie étape du parcours), pas pour la vue "toutes familles".
    final familyEntries = widget.family != null && grouped.isNotEmpty
        ? grouped.first.$3
        : const <dynamic>[];
    if (!_restoredFromProgress && !_isEvaluation && familyEntries.isNotEmpty) {
      _restoredFromProgress = true;
      final progress = context.read<ProgressProvider>();
      for (final entry in familyEntries) {
        final id = entry['id'] as String;
        if (progress.isCompleted(
          typeEtape: 'SIGNE',
          modalite: 'EXERCICE',
          etapeCode: id,
        )) {
          _doneSigns.add(id);
        }
      }
    }
    final allFamilyDone =
        widget.family != null &&
        familyEntries.isNotEmpty &&
        _doneSigns.length >= familyEntries.length;
    final familyIdx = widget.family != null
        ? FAMILY_ORDER.indexOf(widget.family!)
        : -1;
    final nextFamily = familyIdx >= 0 && familyIdx < FAMILY_ORDER.length - 1
        ? FAMILY_ORDER[familyIdx + 1]
        : null;
    // En évaluation, une fois la dernière famille atteinte on reboucle sur
    // la première — seul le chronomètre décide de la fin de la session.
    final evaluationNextFamily = _isEvaluation && familyIdx >= 0
        ? FAMILY_ORDER[(familyIdx + 1) % FAMILY_ORDER.length]
        : null;
    String familyDisplayName(String id) => (familyNames[id] ?? id).toString();
    final ev = t['evaluation'] as Map<String, dynamic>? ?? {};

    return Scaffold(
      backgroundColor: AmaniColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                if (_isEvaluation && session.isRunning)
                  EvaluationTimerBadge(
                    remaining: session.remainingSeconds,
                    subjectsDone: session.subjectsDone,
                    subjectTotal: session.subjectTotal,
                  ),
                _Header(
                  title: headerTitle,
                  subtitle: el['subtitle'] ?? '',
                  onBack: () =>
                      goHome(context),
                ),
                _HintBar(
                  text: el['startHint'] ?? '',
                  bg: const Color(0xCCEAF1FB),
                  fg: const Color(0xFF2D5E8A),
                  tip: true,
                ),
                if (practiceMode)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: AmaniColors.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Color(0x1F000000), blurRadius: 6),
                            ],
                          ),
                          child: DirectionalIcon(LucideIcons.arrowLeft, size: 18),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: CustomScrollView(
                    physics: tracingAwareScrollPhysics(context),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(12, 16, 12, 48),
                        // Une seule feuille de cahier pour toute la page —
                        // signes et lignes d'écriture décoratives de fin de
                        // page (voir plus bas) partagent le même fond blanc/
                        // bordure/ombre, peints derrière les deux slivers
                        // groupés plutôt que par carte individuelle : le
                        // `DecoratedSliver` habille leur étendue combinée
                        // sans se soucier de où elle se termine réellement.
                        sliver: DecoratedSliver(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AmaniColors.textPrimary.withValues(
                                alpha: 0.1,
                              ),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x144A3B2A),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          sliver: SliverMainAxisGroup(
                            slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.all(4),
                                sliver: SliverList(
                                  delegate: SliverChildListDelegate([
                                    for (final (_, titre, entries)
                                        in displayedGroups)
                                      if (entries.isNotEmpty) ...[
                                        if (widget.family == null)
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              12,
                                              14,
                                              12,
                                              6,
                                            ),
                                            child: Text(
                                              titre,
                                              style: AmaniTheme.titleStyle
                                                  .copyWith(fontSize: 16),
                                            ),
                                          ),
                                        for (final entry in entries)
                                          _SignExerciseRow(
                                            key: ValueKey(
                                              '${entry['id']}-r$_restartKey',
                                            ),
                                            entry: entry,
                                            done: _doneSigns.contains(
                                              entry['id'] as String,
                                            ),
                                            repetitions: _settings.repetitions,
                                            tolerance: _settings.tolerance,
                                            hideFamilyBadge:
                                                widget.family != null,
                                            el: el,
                                            lang: lang,
                                            speech: speech,
                                            awardsProgress: !practiceMode,
                                            onEntryDone: practiceMode
                                                ? (_) => _onPracticeEntryDone()
                                                : (id) => _onEntryDone(
                                                    id,
                                                    familyEntries.length,
                                                  ),
                                          ),
                                      ],
                                    // Jamais de feuille d'écriture libre sur
                                    // une page d'évaluation chronométrée
                                    // (voir `_isEvaluation`) -- le temps
                                    // imparti ne doit servir qu'au sujet
                                    // évalué.
                                    if (widget.family != null &&
                                        !practiceMode &&
                                        !_isEvaluation)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          12,
                                          20,
                                          12,
                                          8,
                                        ),
                                        child: FreeWritingSheet(),
                                      ),
                                  ]),
                                ),
                              ),
                              // Si les signes ne remplissent pas toute la
                              // page (peu de signes et/ou peu de
                              // répétitions), le reste de la même feuille
                              // est rempli de lignes d'écriture décoratives
                              // plutôt que de laisser un vide en bas — taille
                              // nulle si le contenu déborde déjà du viewport.
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: CustomPaint(
                                  painter: _TrailingCahierLinesPainter(),
                                  size: Size.infinite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (allFamilyDone &&
                _justCompletedThisVisit &&
                !_isEvaluation &&
                !_freeModeOnly)
              ExerciseCompletePopup(
                onBackHome: () => goHome(context),
                onNext: nextFamily != null
                    ? () => context.replace('/cours/$nextFamily')
                    : null,
                onRestart: () {
                  setState(() {
                    _doneSigns.clear();
                    _justCompletedThisVisit = false;
                    _restartKey++;
                    _awaitingRepeatCompletion = true;
                    _freeModeOnly = false;
                  });
                },
                onFreeMode: () => setState(() => _freeModeOnly = true),
              ),
            if (_isEvaluation && session.expired)
              EvaluationCompleteOverlay(
                onBack: () => goHome(context),
              ),
            if (_isEvaluation && _resumeOffer != null && !session.expired)
              EvaluationResumeOffer(
                onResume: () => _handleResume(_resumeOffer!),
                onRestart: _handleRestart,
              ),
            if (_isEvaluation &&
                _showFirstSubjectAnnouncement &&
                !session.expired)
              EvaluationSubjectAnnouncement(
                title: tFormat(ev['firstSubjectTitle'] ?? '', {
                  'title': familyDisplayName(widget.family ?? FAMILY_ORDER[0]),
                }),
                subtitle: ev['firstSubjectBody'] ?? '',
                continueLabel: ev['startFirstSubject'],
                onContinue: _handleStartFirstSubject,
              ),
            if (allFamilyDone &&
                _isEvaluation &&
                evaluationNextFamily != null &&
                !session.expired)
              EvaluationSubjectAnnouncement(
                title: ev['nextSubjectTitle'] ?? '',
                subtitle: tFormat(ev['nextSubjectBody'] ?? '', {
                  'title': familyDisplayName(evaluationNextFamily),
                }),
                onContinue: () {
                  session.advanceSubject((familyIdx + 1) % FAMILY_ORDER.length);
                  context.replace(
                    '/exercice-liste?family=$evaluationNextFamily&amaniEval=1',
                  );
                },
              ),
            if (_showPracticeSuccess)
              Positioned.fill(
                child: Container(
                  color: const Color(0x73000000),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 320),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 24,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AmaniMascot(
                          pose: AmaniPose.celebration,
                          size: AmaniSize.medium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          el['practiceSuccessTitle'] ?? 'Bravo !',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: AmaniColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          el['practiceSuccessBody'] ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontSize: 14,
                            color: AmaniColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: AmaniColors.primary,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              el['practiceSuccessContinue'] ??
                                  'Continuer la leçon',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: kBalooFontFamily,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SignExerciseRow extends StatelessWidget {
  final dynamic entry;
  final int repetitions;
  final num tolerance;
  final bool hideFamilyBadge;
  final Map<String, dynamic> el;
  final Lang lang;
  final SignSpeechService speech;
  final ValueChanged<String>? onEntryDone;

  /// `false` en pratique rapide depuis le cours (voir [ExerciceListeScreen.sign])
  /// : cette réussite ne doit pas marquer le signe comme "exercice réussi"
  /// dans la progression normale — seul un petit point à part est donné
  /// (voir `_onPracticeEntryDone`).
  final bool awardsProgress;

  /// `true` si cette rangée a déjà été marquée terminée lors d'une session
  /// précédente (voir `ProgressProvider.isCompleted`) -- la rangée s'affiche
  /// alors directement verrouillée en "déjà réussie", sans repasser par les
  /// répétitions.
  final bool done;

  const _SignExerciseRow({
    super.key,
    required this.entry,
    required this.repetitions,
    required this.tolerance,
    required this.hideFamilyBadge,
    required this.el,
    required this.lang,
    required this.speech,
    this.onEntryDone,
    this.awardsProgress = true,
    this.done = false,
  });

  @override
  Widget build(BuildContext context) {
    final familyNames = el['familyNames'] as Map<String, dynamic>? ?? {};
    final showBadge = !hideFamilyBadge || entry['scale'] == 'reduced';
    final badgeBg = Color(
      int.parse((entry['badgeBg'] as String).replaceFirst('#', '0xFF')),
    );
    final badgeText = Color(
      int.parse((entry['badgeText'] as String).replaceFirst('#', '0xFF')),
    );

    return RepetitionRow(
      entry: TraceableEntry(
        id: entry['id'] as String,
        pathD: entry['pathD'] as String,
        // Dérivés du tracé lui-même (et non du champ startXY/endXY du
        // catalogue, parfois désaligné) pour que les pastilles de
        // départ/arrivée tombent toujours exactement sur l'origine et
        // l'extrémité réelles du signe — voir `pathStartPoint`/`pathEndPoint`.
        startXY: pathStartPoint(entry['pathD'] as String),
        endXY: entry['endXY'] != null
            ? pathEndPoint(entry['pathD'] as String)
            : null,
        strokeColor: Color(
          int.parse((entry['strokeColor'] as String).replaceFirst('#', '0xFF')),
        ),
        family: entry['family'] as String? ?? '',
      ),
      label: entry['label'][lang.name] ?? '',
      repetitions: repetitions,
      tolerance: tolerance,
      doneLabel: el['done'] ?? 'Terminé !',
      initiallyDone: done,
      onSpeak: () => speech.speak(
        spokenSignInstruction(
          lang,
          entry['label'][lang.name] ?? '',
          entry['consigne'][lang.name] ?? '',
        ),
        lang,
      ),
      onAllDone: () {
        speech.speak(el['rowComplete'] ?? '', lang);
        if (awardsProgress) {
          context.read<ProgressProvider>().awardCompletion(
            typeEtape: 'SIGNE',
            modalite: 'EXERCICE',
            etapeCode: entry['id'] as String,
            palier: 1,
          );
        }
        onEntryDone?.call(entry['id'] as String);
      },
      badge: showBadge
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(999),
                border:
                    badgeBg == const Color(0xFFF5EDE0) ||
                        badgeBg == AmaniColors.surface
                    ? Border.all(color: badgeText)
                    : null,
              ),
              child: Text(
                capitalizeFirst(
                  entry['scale'] == 'reduced'
                      ? (el['reducedLabel'] ?? 'réduit')
                      : (familyNames[entry['family']] ?? ''),
                ),
                style: TextStyle(
                  fontFamily: kBalooFontFamily,
                  fontWeight: FontWeight.w800,
                  fontSize: 10.5,
                  letterSpacing: 0.4,
                  color: badgeText,
                ),
              ),
            )
          : null,
      // Toutes les pages d'exercice du Palier 1 partagent UNE seule feuille
      // de cahier (voir `_buildFamilyMode`) plutôt que chaque signe dans sa
      // propre carte — cette rangée s'y intègre donc sans bordure/ombre/fond
      // propres.
      showCard: false,
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;

  const _Header({
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: BoxDecoration(
        color: AmaniColors.background,
        border: Border(
          bottom: BorderSide(
            color: AmaniColors.textPrimary.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AmaniColors.surface,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Color(0x1F000000), blurRadius: 6)],
              ),
              child: DirectionalIcon(LucideIcons.house, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: AmaniTheme.bodyStyle.copyWith(
                    fontSize: 12,
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
}

class _HintBar extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;

  /// `true` pour l'astuce d'apprentissage (point de départ/arrivée du
  /// tracé) : remplace le mascotte par une icône d'ampoule allumée, plus
  /// parlante pour signaler qu'il s'agit d'un conseil plutôt que d'une
  /// simple indication de progression.
  final bool tip;
  const _HintBar({
    required this.text,
    required this.bg,
    required this.fg,
    this.tip = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: bg,
      child: Row(
        children: [
          if (tip)
            Container(
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(right: 10),
              decoration: const BoxDecoration(
                color: Color(0xFFE3B873),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                LucideIcons.lightbulb,
                size: 13,
                color: Colors.white,
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: AmaniMascot(
                pose: AmaniPose.demonstration,
                size: AmaniSize.small,
              ),
            ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: kBalooFontFamily,
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: fg,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Prolonge visuellement la feuille de cahier partagée (voir
/// `_buildFamilyMode`) jusqu'en bas de la page quand les signes ne
/// suffisent pas à la remplir (peu de signes affichés et/ou peu de
/// répétitions réglées) : mêmes lignes Seyès que dans chaque rangée de
/// signe (voir `_SeyesLinesPainter` dans `repetition_row.dart`), répétées
/// jusqu'en bas de l'espace disponible plutôt que de laisser un vide non
/// ligné. Purement décoratif (aucune case de tracé) — dimensionné à zéro
/// par le `SliverFillRemaining` englobant dès que le contenu déborde déjà
/// du viewport ; fond/bordure/ombre déjà fournis par le `DecoratedSliver`
/// qui l'englobe avec la liste des signes, pas de décor propre ici.
class _TrailingCahierLinesPainter extends CustomPainter {
  // Mêmes 4 lignes équidistantes (intervalle 60 dans l'espace 0-200) que
  // `_SeyesLinesPainter` (`repetition_row.dart`) et `CahierFrame.dart, mais
  // à une échelle fixe : purement décoratif, sans case de tracé à aligner
  // dessus.
  static const List<double> _positions = [10, 70, 130, 190];
  static const double _rowHeight = 120;
  static const double _rowSpacing = 10;

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
  bool shouldRepaint(covariant _TrailingCahierLinesPainter oldDelegate) =>
      false;
}
