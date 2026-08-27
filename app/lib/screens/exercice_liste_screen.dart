import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../hooks/use_exercise_settings.dart';
import '../data/sign_exercise_catalog.dart';
import '../data/palier2_groups.dart';
import '../data/letter_style_resolver.dart';
import '../hooks/use_writing_style.dart';
import '../services/progress_service.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/repetition_row.dart';
import '../widgets/exercise_complete_popup.dart';
import '../widgets/evaluation_timer.dart';
import '../hooks/use_countdown.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// "Cahier d'Écriture" : exerce chaque signe d'une famille (répétitions sur
/// grille Seyès), ou liste les caractères d'un groupe de progression (Palier
/// 2) menant chacun vers `/exercice/lettre/:char`. Port fidèle de
/// `src/routes/exercice-liste.tsx`.
class ExerciceListeScreen extends StatefulWidget {
  final String? family;
  final String? group;
  final String? amaniEval;
  const ExerciceListeScreen({
    super.key,
    this.family,
    this.group,
    this.amaniEval,
  });

  @override
  State<ExerciceListeScreen> createState() => _ExerciceListeScreenState();
}

class _ExerciceListeScreenState extends State<ExerciceListeScreen> {
  late ExerciseSettings _settings;
  final Set<String> _doneSigns = {};
  int _restartKey = 0;
  bool _awaitingRepeatCompletion = false;

  bool get _isEvaluation => widget.amaniEval == '1';
  CountdownController? _countdown;
  bool _evaluationExpired = false;

  @override
  void initState() {
    super.initState();
    _settings = ExerciseSettings()..addListener(_onSettingsChanged);
    _settings.load();
    if (_isEvaluation) _initEvaluation();
  }

  Future<void> _initEvaluation() async {
    final minutes = await readEvaluationDurationMinutes();
    if (!mounted) return;
    setState(() {
      _countdown = CountdownController(
        durationSeconds: minutes * 60,
        onExpire: () {
          if (mounted) setState(() => _evaluationExpired = true);
        },
      )..addListener(_onSettingsChanged);
    });
  }

  void _onEntryDone(String id, int totalEntries) {
    setState(() => _doneSigns.add(id));
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
    _settings.removeListener(_onSettingsChanged);
    _settings.dispose();
    _countdown?.dispose();
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
              onBack: () => context.go('/accueil'),
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
                            child: DirectionalIcon(LucideIcons.chevronRight,
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

    final grouped = widget.family != null
        ? allGrouped.where((g) => g.$1 == widget.family).toList()
        : allGrouped;
    final headerTitle = widget.family != null && grouped.isNotEmpty
        ? tFormat(el['titleFamily'] ?? '', {'titre': grouped.first.$2})
        : (el['title'] ?? "Cahier d'Écriture");

    // Pop-up de fin d'exercice : uniquement pour une famille précise (une
    // vraie étape du parcours), pas pour la vue "toutes familles".
    final familyEntries = widget.family != null && grouped.isNotEmpty
        ? grouped.first.$3
        : const <dynamic>[];
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

    return Scaffold(
      backgroundColor: AmaniColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                if (_isEvaluation && !_evaluationExpired && _countdown != null)
                  EvaluationTimerBadge(remaining: _countdown!.remaining),
                _Header(
                  title: headerTitle,
                  subtitle: el['subtitle'] ?? '',
                  onBack: () => context.go('/accueil'),
                ),
                _HintBar(
                  text: el['startHint'] ?? '',
                  bg: const Color(0xCCEAF1FB),
                  fg: const Color(0xFF2D5E8A),
                  dot: true,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 48),
                    children: [
                      for (final (_, titre, entries) in grouped)
                        if (entries.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.family == null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 4,
                                      bottom: 10,
                                    ),
                                    child: Text(
                                      titre,
                                      style: AmaniTheme.titleStyle.copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                for (final entry in entries) ...[
                                  _SignExerciseRow(
                                    key: ValueKey(
                                      '${entry['id']}-r$_restartKey',
                                    ),
                                    entry: entry,
                                    repetitions: _settings.repetitions,
                                    tolerance: _settings.tolerance,
                                    hideFamilyBadge: widget.family != null,
                                    el: el,
                                    lang: lang,
                                    speech: speech,
                                    onEntryDone: (id) =>
                                        _onEntryDone(id, familyEntries.length),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
            if (allFamilyDone && !_isEvaluation)
              ExerciseCompletePopup(
                onBackHome: () => context.go('/accueil'),
                onNext: nextFamily != null
                    ? () => context.go('/cours/$nextFamily')
                    : null,
                onRestart: () {
                  setState(() {
                    _doneSigns.clear();
                    _restartKey++;
                    _awaitingRepeatCompletion = true;
                  });
                },
              ),
            if (_isEvaluation && _evaluationExpired)
              EvaluationCompleteOverlay(onBack: () => context.go('/accueil')),
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
        startXY: Offset(
          (entry['startXY'] as List)[0].toDouble(),
          (entry['startXY'] as List)[1].toDouble(),
        ),
        endXY: entry['endXY'] != null
            ? Offset(
                (entry['endXY'] as List)[0].toDouble(),
                (entry['endXY'] as List)[1].toDouble(),
              )
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
        context.read<ProgressProvider>().awardCompletion(
          typeEtape: 'SIGNE',
          modalite: 'EXERCICE',
          etapeCode: entry['id'] as String,
          palier: 1,
        );
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
                (entry['scale'] == 'reduced'
                        ? (el['reducedLabel'] ?? 'réduit')
                        : (familyNames[entry['family']] ?? ''))
                    .toUpperCase(),
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
              child: DirectionalIcon(LucideIcons.arrowLeft, size: 18),
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
  final bool dot;
  const _HintBar({
    required this.text,
    required this.bg,
    required this.fg,
    this.dot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: bg,
      child: Row(
        children: [
          if (dot)
            Container(
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(right: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF5BAA6A),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
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
                fontSize: 12.5,
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
