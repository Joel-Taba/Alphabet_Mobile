import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
import '../widgets/amani_mascot.dart';
import '../widgets/repetition_row.dart';

/// "Cahier d'Écriture" : exerce chaque signe d'une famille (répétitions sur
/// grille Seyès), ou liste les caractères d'un groupe de progression (Palier
/// 2) menant chacun vers `/exercice/lettre/:char`. Port fidèle de
/// `src/routes/exercice-liste.tsx`.
class ExerciceListeScreen extends StatefulWidget {
  final String? family;
  final String? group;
  const ExerciceListeScreen({super.key, this.family, this.group});

  @override
  State<ExerciceListeScreen> createState() => _ExerciceListeScreenState();
}

class _ExerciceListeScreenState extends State<ExerciceListeScreen> {
  late ExerciseSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = ExerciseSettings()..addListener(_onSettingsChanged);
    _settings.load();
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
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
        ? PALIER2_GROUP_MAP[widget.group]
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
              onSpeak: () => speech.speak(
                tFormat(el['introGroup'] ?? '', {
                  'titre': group.title[lang.name] ?? '',
                }),
                lang,
              ),
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
                            child: const Icon(
                              CupertinoIcons.chevron_right,
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

    return Scaffold(
      backgroundColor: AmaniColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              title: headerTitle,
              subtitle: el['subtitle'] ?? '',
              onSpeak: () => speech.speak(el['introGeneral'] ?? '', lang),
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
                                entry: entry,
                                repetitions: _settings.repetitions,
                                tolerance: _settings.tolerance,
                                hideFamilyBadge: widget.family != null,
                                el: el,
                                lang: lang,
                                speech: speech,
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
      ),
    );
  }
}

class _SignExerciseRow extends StatelessWidget {
  final dynamic entry;
  final int repetitions;
  final double tolerance;
  final bool hideFamilyBadge;
  final Map<String, dynamic> el;
  final Lang lang;
  final SignSpeechService speech;

  const _SignExerciseRow({
    required this.entry,
    required this.repetitions,
    required this.tolerance,
    required this.hideFamilyBadge,
    required this.el,
    required this.lang,
    required this.speech,
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
        strokeColor: Color(
          int.parse((entry['strokeColor'] as String).replaceFirst('#', '0xFF')),
        ),
        family: entry['family'] as String? ?? '',
      ),
      label: entry['label'][lang.name] ?? '',
      repetitions: repetitions,
      tolerance: tolerance,
      doneLabel: el['done'] ?? 'Terminé !',
      onSpeak: () => speech.speak(entry['consigne'][lang.name] ?? '', lang),
      onAllDone: () => speech.speak(el['rowComplete'] ?? '', lang),
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
                entry['scale'] == 'reduced'
                    ? (el['reducedLabel'] ?? 'réduit')
                    : (familyNames[entry['family']] ?? ''),
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
  final VoidCallback onSpeak;
  final VoidCallback onBack;

  const _Header({
    required this.title,
    required this.subtitle,
    required this.onSpeak,
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
              child: const Icon(CupertinoIcons.arrow_left, size: 18),
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
          GestureDetector(
            onTap: onSpeak,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AmaniColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.speaker_2_fill,
                size: 16,
                color: Colors.white,
              ),
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
