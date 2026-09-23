import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../hooks/use_exercise_settings.dart';
import '../hooks/use_tracing_scroll_lock.dart';
import '../data/letter_formation_catalog.dart';
import '../data/letter_style_resolver.dart';
import '../hooks/use_writing_style.dart';
import '../data/palier2_groups.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/repetition_row.dart';
import '../utils/trace_validation.dart';
import '../widgets/letter_repetition_row.dart';
import '../widgets/exercise_complete_popup.dart';
import '../widgets/free_writing_sheet.dart';
import '../widgets/evaluation_timer.dart';
import '../services/evaluation_session.dart';
import '../services/progress_service.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../utils/navigation_helpers.dart';

/// Exercice complet d'écriture d'une lettre/chiffre : Phase A (chaque signe
/// exercé séparément) puis Phase B (la lettre entière, répétée autant de
/// fois que le nombre de répétitions réglé) — les deux phases partagent une
/// unique feuille de cahier, comme au Palier 1 (voir
/// `exercice_liste_screen.dart`).
class ExerciceLettreScreen extends StatefulWidget {
  final String char;
  final String? pg;
  final String? amaniEval;
  const ExerciceLettreScreen({
    super.key,
    required this.char,
    this.pg,
    this.amaniEval,
  });

  @override
  State<ExerciceLettreScreen> createState() => _ExerciceLettreScreenState();
}

/// Identifiant fixe de cette évaluation (Palier "Combinatoire") — voir
/// `EvaluationSessionController.ensureContext`.
const String _kEvalId = 'combinatoire';

class _ExerciceLettreScreenState extends State<ExerciceLettreScreen> {
  late ExerciseSettings _settings;
  late final EvaluationSessionController _session;
  final Set<int> _doneSteps = {};
  bool _showFirstSubjectAnnouncement = false;
  Map<String, dynamic>? _resumeOffer;

  /// Lettres du groupe courant déjà réussies, en évaluation — voir
  /// `_buildEvaluationBody` : toutes les lettres du sujet apparaissent sur
  /// UNE seule page, réalisées successivement (chacune débloque la
  /// suivante), au lieu de naviguer lettre par lettre.
  final Set<String> _doneGroupLetters = {};

  bool _letterSuccess = false;

  /// `true` uniquement lorsque `_letterSuccess` vient de passer à `true`
  /// PENDANT cette visite (dans `_handleLetterRepetitionsDone`) -- jamais
  /// lors de la restauration depuis une réussite déjà acquise (`initState`).
  /// Sans cette distinction, rouvrir un exercice déjà réussi lors d'une
  /// visite précédente faisait immédiatement réapparaître la pop-up de
  /// félicitations (avec ses confettis), alors qu'aucun tracé n'avait
  /// encore eu lieu lors de CETTE visite.
  bool _justCompletedThisVisit = false;
  // Incrémenté à chaque "Recommencer" pour forcer le remontage des
  // RepetitionRow de la Phase A (elles gèrent leur propre état interne).
  int _restartKey = 0;
  // Vrai entre le clic sur "Recommencer" et la prochaine réussite complète :
  // le bonus n'est attribué qu'à ce moment-là, jamais au clic lui-même.
  bool _awaitingRepeatCompletion = false;

  /// `true` après "Continuer en mode libre" (voir [ExerciseCompletePopup]) :
  /// masque la pop-up de fin sans jamais toucher à `_letterSuccess`/aux
  /// signes déjà validés -- seule la feuille d'écriture libre en bas de page
  /// reste praticable ensuite.
  bool _freeModeOnly = false;

  bool get _isEvaluation => widget.amaniEval == '1';

  @override
  void initState() {
    super.initState();
    _session = context.read<EvaluationSessionController>();
    _settings = ExerciseSettings()..addListener(_onSettingsChanged);
    _settings.load();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakStart());
    if (_isEvaluation) {
      _initEvaluation();
    } else if (context.read<ProgressProvider>().isCompleted(
      typeEtape: 'LETTRE',
      modalite: 'EXERCICE',
      etapeCode: widget.char,
    )) {
      // Cette lettre/ce chiffre a déjà été tracé(e) avec succès lors d'une
      // précédente visite de cet écran (voir `_handleLetterRepetitionsDone`) :
      // le retrouver acquis plutôt que redemander un tracé déjà réussi.
      _letterSuccess = true;
      // Aucun `etapeCode` propre à chaque étape de la Phase A (un seul
      // `awardCompletion` global pour toute la lettre) : si la lettre entière
      // est déjà acquise, toutes ses étapes le sont nécessairement aussi.
      final letter = getLetterFormation(
        widget.char,
        context.read<WritingStyleProvider>().style.name,
      );
      final stepCount = (letter?['steps'] as List?)?.length ?? 0;
      _doneSteps.addAll(List.generate(stepCount, (i) => i));
    }
  }

  Future<void> _initEvaluation() async {
    if (!mounted) return;
    final lang = context.read<LanguageProvider>().lang;
    final continuing = _session.ensureContext(_kEvalId);
    // "Sujet" = un groupe de lettres (voir `palier2Groups`) — chaque lettre
    // individuelle a déjà son propre écran de succès (`_LetterSuccessOverlay`),
    // donc ici on ne fait qu'alimenter le compteur "X/Y groupes" du bandeau,
    // sans ajouter de pop-up supplémentaire par lettre.
    _session.configureSubjects(getPalier2Groups(lang.name).length);
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
    final lang = context.read<LanguageProvider>().lang;
    final palier2Groups = getPalier2Groups(lang.name);
    _session.resumeFrom(saved);
    setState(() {
      _resumeOffer = null;
      // Retrouve exactement les lettres déjà réussies avant la sortie de la
      // page (voir `EvaluationSessionController.recordItemDone`) — les
      // identifiants d'autres sujets/paliers présents dans cet ensemble ne
      // correspondent à aucun caractère du groupe affiché ici, donc restent
      // sans effet.
      _doneGroupLetters
        ..clear()
        ..addAll(_session.completedItems);
    });
    final savedIdx = saved['currentSubjectIndex'] as int? ?? 0;
    if (savedIdx >= 0 && savedIdx < palier2Groups.length) {
      final savedGroup = palier2Groups[savedIdx];
      if (savedGroup.id != widget.pg && savedGroup.chars.isNotEmpty) {
        context.replace(
          '/exercice/lettre/${savedGroup.chars.first}?pg=${savedGroup.id}&amaniEval=1',
        );
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

  void _onSettingsChanged() {
    if (mounted) setState(_resetAll);
  }

  void _speakStart() {
    final style = context.read<WritingStyleProvider>().style.name;
    final letter = getLetterFormation(widget.char, style);
    if (letter == null || !mounted) return;
    final lang = context.read<LanguageProvider>().lang;
    final t = context.read<LanguageProvider>().t;
    final el = t['exerciceLettre'] as Map<String, dynamic>? ?? {};
    final isDigit = letter['category'] == 'chiffre';
    context.read<SignSpeechService>().speak(
      tFormat((isDigit ? el['speakStartDigit'] : el['speakStart']) ?? '', {
        'name': letter['name'][lang.name] ?? '',
      }),
      lang,
    );
  }

  void _resetAll() {
    _doneSteps.clear();
    _letterSuccess = false;
    _justCompletedThisVisit = false;
    _doneGroupLetters.clear();
  }

  @override
  void dispose() {
    if (_isEvaluation) unawaited(_session.persistProgress());
    _settings.removeListener(_onSettingsChanged);
    _settings.dispose();
    super.dispose();
  }

  /// Toutes les répétitions de la Phase B (lettre entière, voir
  /// `LetterRepetitionRow`) sont réussies.
  void _handleLetterRepetitionsDone() {
    final t = context.read<LanguageProvider>().t;
    final lang = context.read<LanguageProvider>().lang;
    final el = t['exerciceLettre'] as Map<String, dynamic>? ?? {};
    final style = context.read<WritingStyleProvider>().style.name;
    final letter = getLetterFormation(widget.char, style)!;
    final isDigit = letter['category'] == 'chiffre';

    context.read<SignSpeechService>().speak(
      tFormat(
        (isDigit ? el['speakLetterDoneDigit'] : el['speakLetterDone']) ?? '',
        {'name': letter['name'][lang.name] ?? ''},
      ),
      lang,
    );
    context.read<ProgressProvider>().awardCompletion(
      typeEtape: 'LETTRE',
      modalite: 'EXERCICE',
      etapeCode: widget.char,
      palier: 2,
    );
    setState(() {
      _letterSuccess = true;
      _justCompletedThisVisit = true;
    });
    if (_awaitingRepeatCompletion) {
      context.read<ProgressProvider>().awardRestartBonus();
      setState(() => _awaitingRepeatCompletion = false);
    }
  }

  /// Toutes les répétitions d'UNE lettre du groupe (voir
  /// `_buildEvaluationBody`) sont réussies — l'attribution de points reste
  /// par lettre (comme en pratique), seul l'affichage les regroupe.
  void _handleGroupLetterDone(dynamic letter, int totalGroupLetters) {
    final t = context.read<LanguageProvider>().t;
    final lang = context.read<LanguageProvider>().lang;
    final el = t['exerciceLettre'] as Map<String, dynamic>? ?? {};
    final char = letter['char'] as String;
    final isDigit = letter['category'] == 'chiffre';

    context.read<SignSpeechService>().speak(
      tFormat(
        (isDigit ? el['speakLetterDoneDigit'] : el['speakLetterDone']) ?? '',
        {'name': letter['name'][lang.name] ?? ''},
      ),
      lang,
    );
    context.read<ProgressProvider>().awardCompletion(
      typeEtape: 'LETTRE',
      modalite: 'EXERCICE',
      etapeCode: char,
      palier: 2,
    );
    setState(() => _doneGroupLetters.add(char));
    _session.recordItemDone(char);
    if (_doneGroupLetters.length >= totalGroupLetters &&
        _awaitingRepeatCompletion) {
      context.read<ProgressProvider>().awardRestartBonus();
      setState(() => _awaitingRepeatCompletion = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final lang = context.watch<LanguageProvider>().lang;
    final speech = context.read<SignSpeechService>();
    final style = context.watch<WritingStyleProvider>().style.name;
    final el = t['exerciceLettre'] as Map<String, dynamic>? ?? {};
    final elL = t['exerciceListe'] as Map<String, dynamic>? ?? {};
    final ev = t['evaluation'] as Map<String, dynamic>? ?? {};
    final session = context.watch<EvaluationSessionController>();
    final letter = getLetterFormation(widget.char, style);
    final isDigit = letter?['category'] == 'chiffre';

    final progressionGroup =
        (widget.pg != null ? getPalier2GroupMap(lang.name)[widget.pg] : null) ??
        findGroupForChar(widget.char, lang.name);
    final groupId = progressionGroup?.id ?? 'l1';

    // En évaluation, tout le sujet (5 lettres du groupe) tient sur une
    // seule page, réalisées successivement — voir `_buildEvaluationBody`.
    if (_isEvaluation && progressionGroup != null) {
      return _buildEvaluationBody(
        context,
        t,
        lang,
        style,
        el,
        elL,
        ev,
        session,
        progressionGroup,
      );
    }

    if (letter == null) {
      return Scaffold(
        backgroundColor: AmaniColors.background,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '"${widget.char}" ${el['notFound'] ?? ''}',
                  style: AmaniTheme.titleStyle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => context.replace('/exercice-liste?group=l1'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AmaniColors.secondary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      el['backToNotebook'] ?? '',
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final steps = letter['steps'] as List;
    final allLetters = progressionGroup != null
        ? progressionGroup.chars
              .map((c) => getLetterFormation(c, style))
              .whereType<dynamic>()
              .toList()
        : VOWELS;
    final currentIdx = allLetters.indexWhere((l) => l['char'] == widget.char);
    final nextLetter = currentIdx >= 0 && currentIdx < allLetters.length - 1
        ? allLetters[currentIdx + 1]
        : null;
    // Une lettre/chiffre composé d'un seul signe (ex. "c", "l", "o", "0")
    // n'a pas de Phase A distincte à part entière : ce signe unique EST déjà
    // la lettre complète, la répéter séparément puis la lettre entière
    // reviendrait à demander deux fois le même geste. On saute directement
    // à la Phase B (voir aussi la garde équivalente ci-dessous, qui masque
    // la Phase A dans ce cas).
    final allStepsDone = steps.length == 1 || _doneSteps.length == steps.length;

    // Cible du bouton "Suivant" du pop-up de fin d'exercice : la lettre
    // suivante du même groupe, sinon la première lettre du groupe suivant —
    // sans boucler à la fin du dernier groupe.
    final palier2Groups = getPalier2Groups(lang.name);
    final groupIdx = progressionGroup != null
        ? palier2Groups.indexWhere((g) => g.id == progressionGroup.id)
        : -1;
    final nextGroupForCours =
        groupIdx >= 0 && groupIdx < palier2Groups.length - 1
        ? palier2Groups[groupIdx + 1]
        : null;
    final nextCoursChar =
        nextLetter?['char'] as String? ??
        (nextGroupForCours != null && nextGroupForCours.chars.isNotEmpty
            ? nextGroupForCours.chars.first
            : null);
    final nextCoursPg = nextLetter != null ? groupId : nextGroupForCours?.id;

    return Scaffold(
      backgroundColor: AmaniColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
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
                        // Revient à l'écran d'où l'utilisateur vient
                        // réellement (cours, liste d'exercices, ou parcours
                        // en évaluation — toujours atteint via `push`),
                        // plutôt que de forcer systématiquement la liste
                        // d'exercices du groupe.
                        onTap: () => goHome(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AmaniColors.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x1F000000),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: DirectionalIcon(
                            LucideIcons.house,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${el['title'] ?? 'Tracer'} "${letter['char']}"',
                              style: AmaniTheme.titleStyle.copyWith(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              steps.length == 1
                                  ? (letter['name'][lang.name] ?? '')
                                  : '${tFormat(el['signsReady'] ?? '', {'done': _doneSteps.length, 'total': steps.length})} · ${letter['name'][lang.name] ?? ''}',
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
                ),
                // Bandeau d'état — hors de la feuille de cahier, comme le
                // `_HintBar` du Palier 1 (`exercice_liste_screen.dart`).
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AmaniColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        AmaniMascot(
                          pose: _letterSuccess
                              ? AmaniPose.celebration
                              : allStepsDone
                              ? AmaniPose.demonstration
                              : AmaniPose.encouragement,
                          size: AmaniSize.small,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _letterSuccess
                                    ? (isDigit
                                          ? el['successAllDigit']
                                          : el['successAll']) ??
                                          ''
                                    : allStepsDone
                                    ? (isDigit
                                          ? el['finalTitleDigit']
                                          : el['finalTitle']) ??
                                          ''
                                    : (el['practiceStepsTitle'] ?? ''),
                                style: AmaniTheme.titleStyle.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _letterSuccess
                                    ? (el['successAllSub'] ?? '')
                                    : allStepsDone
                                    ? (isDigit
                                          ? el['finalHintDigit']
                                          : el['finalHint']) ??
                                          ''
                                    : tFormat(
                                        (isDigit
                                                ? el['practiceStepsHintDigit']
                                                : el['practiceStepsHint']) ??
                                            '',
                                        {'reps': _settings.repetitions},
                                      ),
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
                  ),
                ),
                Expanded(
                  child: CustomScrollView(
                    physics: tracingAwareScrollPhysics(context),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(12, 16, 12, 48),
                        // Une seule feuille de cahier pour toute la page,
                        // Phase A et Phase B comprises — même traitement
                        // qu'au Palier 1 (voir `exercice_liste_screen.dart`).
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
                                    // Phase A — un signe débloque le suivant
                                    // une fois réussi. Absente en évaluation,
                                    // et absente aussi pour une lettre/chiffre
                                    // à signe unique (voir `allStepsDone`
                                    // ci-dessus) : seule la lettre entière
                                    // (Phase B) y compte alors.
                                    if (!_isEvaluation && steps.length > 1)
                                      for (
                                        int i = 0;
                                        i < steps.length;
                                        i++
                                      ) ...[
                                      RepetitionRow(
                                        key: ValueKey(
                                          '${letter['char']}-step-$i-r$_restartKey',
                                        ),
                                        locked:
                                            i > 0 &&
                                            !_doneSteps.contains(i - 1),
                                        entry: TraceableEntry(
                                          id: '${letter['char']}-step-$i',
                                          pathD: steps[i]['pathD'] as String,
                                          // Dérivé du tracé lui-même — voir
                                          // `pathStartPoint` — plutôt que du
                                          // champ startXY du catalogue.
                                          startXY: pathStartPoint(
                                            steps[i]['pathD'] as String,
                                          ),
                                          strokeColor: Color(
                                            int.parse(
                                              (steps[i]['strokeColor']
                                                      as String)
                                                  .replaceFirst('#', '0xFF'),
                                            ),
                                          ),
                                        ),
                                        label:
                                            steps[i]['description'][lang
                                                .name] ??
                                            '',
                                        repetitions: _settings.repetitions,
                                        tolerance: _settings.tolerance,
                                        doneLabel: elL['done'] ?? 'Terminé !',
                                        initiallyDone: _doneSteps.contains(i),
                                        onSpeak: () => speech.speak(
                                          steps[i]['description'][lang.name] ??
                                              '',
                                          lang,
                                        ),
                                        onAllDone: () =>
                                            setState(() => _doneSteps.add(i)),
                                        badge: Container(
                                          width: 26,
                                          height: 26,
                                          decoration: const BoxDecoration(
                                            color: AmaniColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${i + 1}',
                                            textHeightBehavior:
                                                const TextHeightBehavior(
                                                  applyHeightToFirstAscent:
                                                      false,
                                                  applyHeightToLastDescent:
                                                      false,
                                                ),
                                            style: TextStyle(
                                              fontFamily: kBalooFontFamily,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14,
                                              color: Colors.white,
                                              height: 1,
                                            ),
                                          ),
                                        ),
                                        showCard: false,
                                      ),
                                      const SizedBox(height: 12),
                                    ],

                                    // Phase B — la lettre entière, répétée
                                    // autant de fois que le nombre de
                                    // répétitions réglé.
                                    if (!allStepsDone)
                                      Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: AmaniColors.surface
                                              .withValues(alpha: 0.6),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: AmaniColors.textPrimary
                                                .withValues(alpha: 0.2),
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(
                                              LucideIcons.lock,
                                              size: 22,
                                              color: AmaniColors.textPrimary
                                                  .withValues(alpha: 0.4),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              el['finalLocked'] ?? '',
                                              textAlign: TextAlign.center,
                                              style: AmaniTheme.bodyStyle
                                                  .copyWith(
                                                    fontSize: 12.5,
                                                    color: AmaniColors
                                                        .textSecondary,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      )
                                    else ...[
                                      LetterRepetitionRow(
                                        key: ValueKey(
                                          '${letter['char']}-letter-r$_restartKey',
                                        ),
                                        letter: letter,
                                        label:
                                            '${(isDigit ? el['finalTitleDigit'] : el['finalTitle']) ?? ''} "${letter['char']}"',
                                        repetitions: _settings.repetitions,
                                        doneLabel: elL['done'] ?? 'Terminé !',
                                        initiallyDone: _letterSuccess,
                                        onSpeak: () => speech.speak(
                                          tFormat(
                                            (isDigit
                                                    ? el['speakStartDigit']
                                                    : el['speakStart']) ??
                                                '',
                                            {
                                              'name':
                                                  letter['name'][lang.name] ??
                                                  '',
                                            },
                                          ),
                                          lang,
                                        ),
                                        onAllDone: _letterSuccess
                                            ? null
                                            : _handleLetterRepetitionsDone,
                                        showCard: false,
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: AmaniColors.surface,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: AmaniColors.textPrimary
                                                .withValues(alpha: 0.1),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${el['formulaTitle'] ?? ''} "${letter['char']}"',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        kBalooFontFamily,
                                                    fontWeight:
                                                        FontWeight.w800,
                                                    fontSize: 13,
                                                    color: AmaniColors
                                                        .textPrimary,
                                                  ),
                                                ),
                                                Text(
                                                  '${steps.length} / ${steps.length} ${el['validated'] ?? ''}',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        kBalooFontFamily,
                                                    fontWeight:
                                                        FontWeight.w800,
                                                    fontSize: 12,
                                                    color:
                                                        AmaniColors.secondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                for (
                                                  int i = 0;
                                                  i < steps.length;
                                                  i++
                                                )
                                                  _FormulaBadge(
                                                    label:
                                                        ((steps[i]['description'][lang
                                                                    .name] ??
                                                                '')
                                                            as String)
                                                            .split(' ')
                                                            .first,
                                                    index: i,
                                                    isDone: true,
                                                    isCurrent: false,
                                                  ),
                                                Text(
                                                  '=  ${letter['char']}',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        kBalooFontFamily,
                                                    fontWeight:
                                                        FontWeight.w800,
                                                    fontSize: 18,
                                                    color: AmaniColors.primary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    // Feuille d'écriture libre : jamais sur
                                    // une page d'évaluation chronométrée
                                    // (voir `_isEvaluation`) -- le temps
                                    // imparti ne doit servir qu'au sujet
                                    // évalué, ce garde-fou reste défensif ici
                                    // puisque `_buildEvaluationBody` couvre
                                    // déjà le cas normal de l'évaluation.
                                    if (!_isEvaluation)
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

            if (_letterSuccess && _justCompletedThisVisit && !_freeModeOnly)
              ExerciseCompletePopup(
                onBackHome: () => goHome(context),
                onNext: nextCoursChar != null
                    ? () => context.replace(
                        '/cours/lettres/formation/$nextCoursChar${nextCoursPg != null ? '?pg=$nextCoursPg' : ''}',
                      )
                    : null,
                onRestart: () {
                  setState(() {
                    _resetAll();
                    _restartKey++;
                    _awaitingRepeatCompletion = true;
                    _freeModeOnly = false;
                  });
                },
                onFreeMode: () => setState(() => _freeModeOnly = true),
              ),
          ],
        ),
      ),
    );
  }

  /// Vue d'évaluation du Palier 2 : toutes les lettres du sujet (groupe,
  /// voir `palier2Groups`) sur UNE seule page, réalisées successivement —
  /// chacune débloque la suivante, exactement dans l'ordre de progression
  /// des cours de ce palier. Plus besoin de naviguer lettre par lettre :
  /// le sujet suivant (5 lettres suivantes) n'apparaît qu'une fois toutes
  /// réussies, via `EvaluationSubjectAnnouncement` — même mécanisme que les
  /// Paliers "Syllabes"/"Mots"/"Calculs".
  Widget _buildEvaluationBody(
    BuildContext context,
    Map<String, dynamic> t,
    Lang lang,
    String style,
    Map<String, dynamic> el,
    Map<String, dynamic> elL,
    Map<String, dynamic> ev,
    EvaluationSessionController session,
    ProgressionGroup progressionGroup,
  ) {
    final speech = context.read<SignSpeechService>();
    final isGroupDigits =
        progressionGroup.kind == ProgressionGroupKind.chiffres;
    final groupLetters = progressionGroup.chars
        .map((c) => getLetterFormation(c, style))
        .whereType<dynamic>()
        .toList();
    final allGroupDone =
        groupLetters.isNotEmpty &&
        _doneGroupLetters.length == groupLetters.length;

    final palier2Groups = getPalier2Groups(lang.name);
    final groupIdx = palier2Groups.indexWhere(
      (g) => g.id == progressionGroup.id,
    );
    // Une fois la dernière lettre du dernier groupe atteinte, on reboucle
    // sur le premier — seul le chronomètre décide de la fin de la session.
    final evalNextGroup = groupIdx >= 0
        ? palier2Groups[(groupIdx + 1) % palier2Groups.length]
        : null;

    return Scaffold(
      backgroundColor: AmaniColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                if (session.isRunning)
                  EvaluationTimerBadge(
                    remaining: session.remainingSeconds,
                    subjectsDone: session.subjectsDone,
                    subjectTotal: session.subjectTotal,
                  ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
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
                        onTap: () => goHome(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AmaniColors.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x1F000000),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: DirectionalIcon(
                            LucideIcons.house,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              progressionGroup.title[lang.name] ?? '',
                              style: AmaniTheme.titleStyle.copyWith(
                                fontSize: 20,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              tFormat(
                                (isGroupDigits
                                        ? el['lettersReadyDigit']
                                        : el['lettersReady']) ??
                                    '',
                                {
                                  'done': _doneGroupLetters.length,
                                  'total': groupLetters.length,
                                },
                              ),
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
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AmaniColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        AmaniMascot(
                          pose: allGroupDone
                              ? AmaniPose.celebration
                              : AmaniPose.demonstration,
                          size: AmaniSize.small,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                allGroupDone
                                    ? (isGroupDigits
                                          ? el['successAllDigit']
                                          : el['successAll']) ??
                                          ''
                                    : (isGroupDigits
                                          ? el['finalTitleDigit']
                                          : el['finalTitle']) ??
                                          '',
                                style: AmaniTheme.titleStyle.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                allGroupDone
                                    ? (el['successAllSub'] ?? '')
                                    : (isGroupDigits
                                          ? el['finalHintDigit']
                                          : el['finalHint']) ??
                                          '',
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
                  ),
                ),
                Expanded(
                  child: CustomScrollView(
                    physics: tracingAwareScrollPhysics(context),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(12, 16, 12, 48),
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
                                    for (
                                      var li = 0;
                                      li < groupLetters.length;
                                      li++
                                    ) ...[
                                      if (li > 0)
                                        Divider(
                                          height: 1,
                                          color: AmaniColors.textPrimary
                                              .withValues(alpha: 0.1),
                                        ),
                                      _buildEvaluationLetterBlock(
                                        groupLetters,
                                        li,
                                        lang,
                                        el,
                                        elL,
                                        speech,
                                      ),
                                    ],
                                  ]),
                                ),
                              ),
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
            if (session.expired)
              EvaluationCompleteOverlay(
                onBack: () => goHome(context),
              ),
            if (_resumeOffer != null && !session.expired)
              EvaluationResumeOffer(
                onResume: () => _handleResume(_resumeOffer!),
                onRestart: _handleRestart,
              ),
            if (_showFirstSubjectAnnouncement && !session.expired)
              EvaluationSubjectAnnouncement(
                title: tFormat(ev['firstSubjectTitle'] ?? '', {
                  'title':
                      progressionGroup.title[lang.name] ?? progressionGroup.id,
                }),
                subtitle: ev['firstSubjectBody'] ?? '',
                continueLabel: ev['startFirstSubject'],
                onContinue: _handleStartFirstSubject,
              ),
            if (allGroupDone && evalNextGroup != null && !session.expired)
              EvaluationSubjectAnnouncement(
                title: ev['nextSubjectTitle'] ?? '',
                subtitle: tFormat(ev['nextSubjectBody'] ?? '', {
                  'title': evalNextGroup.title[lang.name] ?? '',
                }),
                onContinue: () {
                  session.advanceSubject(
                    (groupIdx + 1) % palier2Groups.length,
                  );
                  context.replace(
                    '/exercice/lettre/${evalNextGroup.chars.first}?pg=${evalNextGroup.id}&amaniEval=1',
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvaluationLetterBlock(
    List groupLetters,
    int li,
    Lang lang,
    Map<String, dynamic> el,
    Map<String, dynamic> elL,
    SignSpeechService speech,
  ) {
    final letter = groupLetters[li];
    final char = letter['char'] as String;
    final steps = letter['steps'] as List;
    final isDigit = letter['category'] == 'chiffre';
    final locked =
        li > 0 && !_doneGroupLetters.contains(groupLetters[li - 1]['char']);
    final done = _doneGroupLetters.contains(char);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LetterRepetitionRow(
            key: ValueKey('$char-eval-letter'),
            letter: letter,
            label:
                '${(isDigit ? el['finalTitleDigit'] : el['finalTitle']) ?? ''} "$char"',
            repetitions: _settings.repetitions,
            doneLabel: elL['done'] ?? 'Terminé !',
            locked: locked,
            onSpeak: () => speech.speak(
              tFormat((isDigit ? el['speakStartDigit'] : el['speakStart']) ?? '', {
                'name': letter['name'][lang.name] ?? '',
              }),
              lang,
            ),
            onAllDone: done
                ? null
                : () => _handleGroupLetterDone(letter, groupLetters.length),
            showCard: false,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AmaniColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AmaniColors.textPrimary.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${el['formulaTitle'] ?? ''} "$char"',
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: AmaniColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${steps.length} / ${steps.length} ${el['validated'] ?? ''}',
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: AmaniColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (int i = 0; i < steps.length; i++)
                      _FormulaBadge(
                        label:
                            ((steps[i]['description'][lang.name] ?? '')
                                    as String)
                                .split(' ')
                                .first,
                        index: i,
                        isDone: true,
                        isCurrent: false,
                      ),
                    Text(
                      '=  $char',
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: AmaniColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _FormulaBadge extends StatelessWidget {
  final String label;
  final int index;
  final bool isDone;
  final bool isCurrent;

  const _FormulaBadge({
    required this.label,
    required this.index,
    required this.isDone,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDone
        ? const Color(0x268FBF6F)
        : isCurrent
        ? const Color(0x26A9784F)
        : const Color(0xFFF2F2F2);
    final fg = isDone
        ? const Color(0xFF5E8E3E)
        : isCurrent
        ? AmaniColors.primary
        : AmaniColors.disabled;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: isDone
                ? const Icon(
                    LucideIcons.check,
                    size: 10,
                    color: Color(0xFF5E8E3E),
                  )
                : Text(
                    '${index + 1}',
                    textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: false,
                    ),
                    style: TextStyle(
                      fontFamily: kBalooFontFamily,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                      color: fg,
                      height: 1,
                    ),
                  ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: kBalooFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}


/// Prolonge visuellement la feuille de cahier partagée jusqu'en bas de la
/// page quand le contenu ne suffit pas à la remplir — copie de
/// `_TrailingCahierLinesPainter` (`exercice_liste_screen.dart`, Palier 1).
class _TrailingCahierLinesPainter extends CustomPainter {
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
