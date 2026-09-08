import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../services/progress_service.dart';
import '../data/letter_style_resolver.dart';
import '../data/flores_gong_nota.dart' show STROKE_FAMILLE;
import '../data/sign_exercise_catalog.dart';
import '../data/palier2_groups.dart';
import '../hooks/use_writing_style.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/puzzle_piece.dart';
import '../widgets/exercise_complete_popup.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Jeu "Formule en puzzle" du Palier 2 : pour chaque lettre/chiffre du
/// groupe, l'enfant choisit — dans le bon ordre — les pièces portant les
/// signes qui la composent, parmi quelques pièces supplémentaires qui n'en
/// font pas partie. Toutes les lettres du groupe tiennent sur une seule
/// page, réalisées successivement (chacune débloque la suivante), comme les
/// autres exercices du Palier 2 (voir `exercice_lettre_screen.dart`).
class ExercicePuzzleFormuleScreen extends StatefulWidget {
  final String char;
  final String? pg;

  const ExercicePuzzleFormuleScreen({super.key, required this.char, this.pg});

  @override
  State<ExercicePuzzleFormuleScreen> createState() =>
      _ExercicePuzzleFormuleScreenState();
}

class _ExercicePuzzleFormuleScreenState
    extends State<ExercicePuzzleFormuleScreen> {
  final Set<String> _doneChars = {};
  int _restartKey = 0;
  bool _awaitingRepeatCompletion = false;

  void _handleCharSolved(dynamic letter, int totalLetters) {
    final t = context.read<LanguageProvider>().t;
    final lang = context.read<LanguageProvider>().lang;
    final ep = t['exercicePuzzle'] as Map<String, dynamic>? ?? {};
    final char = letter['char'] as String;

    context.read<SignSpeechService>().speak(
      tFormat(ep['speakSolved'] ?? '', {'name': letter['name'][lang.name] ?? ''}),
      lang,
    );
    context.read<ProgressProvider>().awardCompletion(
      typeEtape: 'LETTRE',
      modalite: 'EXERCICE',
      etapeCode: '$char-puzzle',
      palier: 2,
    );
    setState(() => _doneChars.add(char));
    if (_doneChars.length >= totalLetters && _awaitingRepeatCompletion) {
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
    final ep = t['exercicePuzzle'] as Map<String, dynamic>? ?? {};
    final el = t['exerciceLettre'] as Map<String, dynamic>? ?? {};

    final progressionGroup =
        (widget.pg != null ? getPalier2GroupMap(lang.name)[widget.pg] : null) ??
        findGroupForChar(widget.char, lang.name);

    if (progressionGroup == null) {
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
                  onTap: () => context.go('/exercice-liste?group=l1'),
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

    final groupLetters = progressionGroup.chars
        .map((c) => getLetterFormation(c, style))
        .whereType<dynamic>()
        .toList();
    final allDone =
        groupLetters.isNotEmpty && _doneChars.length == groupLetters.length;

    final palier2Groups = getPalier2Groups(lang.name);
    final groupIdx = palier2Groups.indexWhere(
      (g) => g.id == progressionGroup.id,
    );
    final nextGroup = groupIdx >= 0 && groupIdx < palier2Groups.length - 1
        ? palier2Groups[groupIdx + 1]
        : null;

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
                        onTap: () => context.canPop()
                            ? context.pop()
                            : context.go('/accueil'),
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
                            LucideIcons.arrowLeft,
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
                              tFormat(ep['piecesReady'] ?? '', {
                                'done': _doneChars.length,
                                'total': groupLetters.length,
                              }),
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
                          pose: allDone
                              ? AmaniPose.celebration
                              : AmaniPose.encouragement,
                          size: AmaniSize.small,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                allDone
                                    ? (ep['allDoneTitle'] ?? '')
                                    : (ep['introTitle'] ?? ''),
                                style: AmaniTheme.titleStyle.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                allDone
                                    ? (ep['allDoneBody'] ?? '')
                                    : (ep['introBody'] ?? ''),
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
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(12, 16, 12, 48),
                        // Une seule feuille pour toute la page, comme les
                        // autres exercices du Palier 2 — mais sans
                        // quadrillage Seyès : ce jeu ne trace rien, il n'y a
                        // pas de ligne d'écriture à fournir.
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
                          sliver: SliverPadding(
                            padding: const EdgeInsets.all(4),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate([
                                for (
                                  int li = 0;
                                  li < groupLetters.length;
                                  li++
                                ) ...[
                                  if (li > 0)
                                    Divider(
                                      height: 1,
                                      color: AmaniColors.textPrimary
                                          .withValues(alpha: 0.1),
                                    ),
                                  _LetterPuzzleRound(
                                    key: ValueKey(
                                      '${groupLetters[li]['char']}-r$_restartKey',
                                    ),
                                    letter: groupLetters[li],
                                    locked:
                                        li > 0 &&
                                        !_doneChars.contains(
                                          groupLetters[li - 1]['char'],
                                        ),
                                    done: _doneChars.contains(
                                      groupLetters[li]['char'],
                                    ),
                                    lang: lang,
                                    onSpeak: () => speech.speak(
                                      groupLetters[li]['name'][lang.name] ??
                                          '',
                                      lang,
                                    ),
                                    doneLabel: el['done'] ?? 'Terminé !',
                                    onSolved: () => _handleCharSolved(
                                      groupLetters[li],
                                      groupLetters.length,
                                    ),
                                  ),
                                ],
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (allDone)
              ExerciseCompletePopup(
                onBackHome: () => context.go('/accueil'),
                onNext: nextGroup != null
                    ? () => context.go(
                        '/exercice/puzzle-formule/${nextGroup.chars.first}?pg=${nextGroup.id}',
                      )
                    : null,
                onRestart: () {
                  setState(() {
                    _doneChars.clear();
                    _restartKey++;
                    _awaitingRepeatCompletion = true;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Un signe candidat pour une pièce de puzzle : signes corrects de la
/// lettre (dans l'ordre) et pièces-pièges supplémentaires n'en faisant pas
/// partie.
class _PieceData {
  final int id;
  final String family;
  final String variant;
  final String label;
  bool placed = false;

  _PieceData({
    required this.id,
    required this.family,
    required this.variant,
    required this.label,
  });
}

/// Cherche dans le catalogue générique des signes (`sign_exercise_catalog.dart`,
/// Palier 1) le libellé correspondant à une paire (family, variant) — pour
/// nommer une pièce par le nom GÉNÉRIQUE du signe plutôt que par la
/// description propre à une lettre précise (ex. "Trait vertical" plutôt que
/// "Trait vertical droit"), puisque le jeu porte sur la reconnaissance de la
/// catégorie de signe. Préfère l'échelle "full" (nom non qualifié) quand
/// plusieurs échelles existent pour la même paire.
String? _genericSignLabel(String family, String variant, String langName) {
  Map<String, dynamic>? fullMatch;
  Map<String, dynamic>? anyMatch;
  for (final e in EXERCISE_CATALOG) {
    final entry = e as Map<String, dynamic>;
    if (entry['family'] == family && entry['variant'] == variant) {
      anyMatch ??= entry;
      if (entry['scale'] == 'full') {
        fullMatch = entry;
        break;
      }
    }
  }
  final match = fullMatch ?? anyMatch;
  final label = match?['label'] as Map<String, dynamic>?;
  return label?[langName] as String?;
}

/// Bassin de pièces-pièges possibles : toutes les paires (family, variant)
/// du catalogue générique des signes qui NE font PAS partie des signes
/// réels de la lettre — jamais une paire déjà utilisée, pour qu'une pièce
/// piège reste sans ambiguïté une pièce en trop plutôt qu'un doublon valide.
List<Map<String, dynamic>> _distractorPool(List steps) {
  final usedKeys = steps
      .map((s) => '${s['family']}|${s['variant'] ?? 'vertical'}')
      .toSet();
  final seenKeys = <String>{};
  final pool = <Map<String, dynamic>>[];
  for (final e in EXERCISE_CATALOG) {
    final entry = e as Map<String, dynamic>;
    if (entry['scale'] != 'full') continue;
    final key = '${entry['family']}|${entry['variant']}';
    if (usedKeys.contains(key) || seenKeys.contains(key)) continue;
    seenKeys.add(key);
    pool.add(entry);
  }
  return pool;
}

class _LetterPuzzleRound extends StatefulWidget {
  final dynamic letter;
  final bool locked;
  final bool done;
  final Lang lang;
  final VoidCallback onSpeak;
  final String doneLabel;
  final VoidCallback onSolved;

  const _LetterPuzzleRound({
    super.key,
    required this.letter,
    required this.locked,
    required this.done,
    required this.lang,
    required this.onSpeak,
    required this.doneLabel,
    required this.onSolved,
  });

  @override
  State<_LetterPuzzleRound> createState() => _LetterPuzzleRoundState();
}

/// Résultat d'un dépôt refusé sur un emplacement — voir `_PuzzleSlot` : même
/// code couleur que le mini-jeu "Compose le nombre !" du Palier "Les
/// Calculs" (vert = bien placé, jaune = fait partie de la lettre mais pas à
/// cet emplacement, rouge = ne fait pas du tout partie de sa formule).
enum _SlotFeedback { misplaced, wrong }

class _LetterPuzzleRoundState extends State<_LetterPuzzleRound> {
  late List<_PieceData> _correctSequence;
  late List<_PieceData> _tray;
  late List<_PieceData?> _placed;
  final Map<int, GlobalKey<PuzzlePieceCardState>> _pieceKeys = {};
  final Map<int, _SlotFeedback> _slotFeedback = {};
  final Map<int, Timer> _feedbackTimers = {};

  /// Nombre total de pièces proposées dans la pioche (signes corrects +
  /// pièges) — fixe quel que soit le nombre de signes de la lettre, pour que
  /// le jeu propose toujours le même nombre de choix.
  static const int _targetTotalPieces = 6;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  void didUpdateWidget(covariant _LetterPuzzleRound oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.letter['char'] != widget.letter['char']) {
      setState(_setup);
    }
  }

  @override
  void dispose() {
    for (final timer in _feedbackTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }

  void _setup() {
    final steps = widget.letter['steps'] as List;
    final langName = widget.lang.name;
    var nextId = 0;

    _correctSequence = [
      for (final s in steps)
        _PieceData(
          id: nextId++,
          family: s['family'] as String,
          variant: s['variant'] as String? ?? 'vertical',
          label:
              _genericSignLabel(
                s['family'] as String,
                s['variant'] as String? ?? 'vertical',
                langName,
              ) ??
              ((s['description'][langName] ?? '') as String).split(' ').first,
        ),
    ];

    final rng = math.Random((widget.letter['char'] as String).hashCode);
    final pool = _distractorPool(steps)..shuffle(rng);
    final distractorCount = math.max(
      0,
      _targetTotalPieces - _correctSequence.length,
    );
    final distractors = [
      for (final e in pool.take(distractorCount))
        _PieceData(
          id: nextId++,
          family: e['family'] as String,
          variant: e['variant'] as String,
          label: (e['label'] as Map<String, dynamic>)[langName] as String? ?? '',
        ),
    ];

    _tray = [..._correctSequence, ...distractors]..shuffle(rng);
    _placed = List<_PieceData?>.filled(_correctSequence.length, null);
    for (final timer in _feedbackTimers.values) {
      timer.cancel();
    }
    _feedbackTimers.clear();
    _slotFeedback.clear();
    _pieceKeys
      ..clear()
      ..addEntries(
        _tray.map((p) => MapEntry(p.id, GlobalKey<PuzzlePieceCardState>())),
      );
  }

  bool get _solved => widget.done || _placed.every((p) => p != null);

  /// Ce signe fait-il partie de la formule de la lettre, à N'IMPORTE quel
  /// emplacement — sert à distinguer un dépôt "mal placé" (jaune) d'un
  /// véritable piège qui n'en fait pas partie du tout (rouge).
  bool _belongsToLetter(_PieceData piece) => _correctSequence.any(
    (c) => c.family == piece.family && c.variant == piece.variant,
  );

  void _handleDrop(int slotIndex, _PieceData piece) {
    if (widget.locked || _solved || piece.placed || _placed[slotIndex] != null) {
      return;
    }
    final expected = _correctSequence[slotIndex];
    if (piece.family == expected.family && piece.variant == expected.variant) {
      _feedbackTimers.remove(slotIndex)?.cancel();
      setState(() {
        piece.placed = true;
        _placed[slotIndex] = piece;
        _slotFeedback.remove(slotIndex);
      });
      if (_placed.every((p) => p != null)) {
        widget.onSolved();
      }
      return;
    }
    // Mauvais dépôt : jaune si ce signe appartient bien à la lettre (mais
    // pas à CET emplacement), rouge s'il n'en fait pas partie du tout —
    // jamais consommé, la pièce revient dans la pioche pour être retentée.
    final feedback = _belongsToLetter(piece)
        ? _SlotFeedback.misplaced
        : _SlotFeedback.wrong;
    setState(() => _slotFeedback[slotIndex] = feedback);
    _pieceKeys[piece.id]?.currentState?.shake();
    _feedbackTimers[slotIndex]?.cancel();
    _feedbackTimers[slotIndex] = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _slotFeedback.remove(slotIndex));
    });
  }

  @override
  Widget build(BuildContext context) {
    final char = widget.letter['char'] as String;
    final remainingTray = _tray.where((p) => !p.placed).toList();

    return Opacity(
      opacity: widget.locked ? 0.5 : 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '"$char" · ${widget.letter['name'][widget.lang.name] ?? ''}',
                    style: TextStyle(
                      fontFamily: kBalooFontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AmaniColors.textPrimary,
                    ),
                  ),
                ),
                if (_solved)
                  Text(
                    '✓ ${widget.doneLabel}',
                    style: TextStyle(
                      fontFamily: kBalooFontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AmaniColors.secondary,
                    ),
                  ),
                const SizedBox(width: 8),
                if (widget.locked)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.lock,
                      size: 15,
                      color: AmaniColors.textSecondary,
                    ),
                  )
                else
                  GestureDetector(
                    onTap: widget.onSpeak,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AmaniColors.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.volume2,
                        size: 16,
                        color: AmaniColors.textPrimary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Séquence à assembler : une pièce posée par signe déjà
                // trouvé, un emplacement vide (silhouette) pour le reste.
                Wrap(
                  spacing: 6,
                  runSpacing: 8,
                  children: [
                    for (int i = 0; i < _correctSequence.length; i++)
                      if (_placed[i] != null)
                        PuzzlePieceCard(
                          family: _placed[i]!.family,
                          variant: _placed[i]!.variant,
                          label: _placed[i]!.label,
                          accentColor:
                              STROKE_FAMILLE[_placed[i]!.family] ??
                              AmaniColors.textPrimary,
                          state: PuzzlePieceState.placed,
                          width: 72,
                          height: 76,
                        )
                      else
                        _PuzzleSlot(
                          index: i,
                          feedback: _slotFeedback[i],
                          enabled: !widget.locked && !_solved,
                          onAccept: (piece) => _handleDrop(i, piece),
                          width: 72,
                          height: 76,
                        ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        '= "$char"',
                        style: TextStyle(
                          fontFamily: kBalooFontFamily,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: AmaniColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!_solved) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final piece in remainingTray)
                        widget.locked
                            ? PuzzlePieceCard(
                                key: _pieceKeys[piece.id],
                                family: piece.family,
                                variant: piece.variant,
                                label: piece.label,
                                accentColor:
                                    STROKE_FAMILLE[piece.family] ??
                                    AmaniColors.textPrimary,
                                state: PuzzlePieceState.locked,
                              )
                            : Draggable<_PieceData>(
                                data: piece,
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: PuzzlePieceCard(
                                    family: piece.family,
                                    variant: piece.variant,
                                    label: piece.label,
                                    accentColor:
                                        STROKE_FAMILLE[piece.family] ??
                                        AmaniColors.textPrimary,
                                    state: PuzzlePieceState.idle,
                                  ),
                                ),
                                childWhenDragging: Opacity(
                                  opacity: 0.25,
                                  child: PuzzlePieceCard(
                                    family: piece.family,
                                    variant: piece.variant,
                                    label: piece.label,
                                    accentColor:
                                        STROKE_FAMILLE[piece.family] ??
                                        AmaniColors.textPrimary,
                                    state: PuzzlePieceState.idle,
                                  ),
                                ),
                                child: PuzzlePieceCard(
                                  key: _pieceKeys[piece.id],
                                  family: piece.family,
                                  variant: piece.variant,
                                  label: piece.label,
                                  accentColor:
                                      STROKE_FAMILLE[piece.family] ??
                                      AmaniColors.textPrimary,
                                  state: PuzzlePieceState.idle,
                                ),
                              ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Emplacement vide de la formule — cible de glisser-déposer : vert quand un
/// signe s'y pose (voir le rendu "placed" du bloc appelant une fois accepté,
/// cet état n'a donc pas besoin d'être représenté ICI), jaune quand un signe
/// qui appartient bien à la lettre y est déposé au mauvais endroit, rouge
/// quand la pièce déposée n'en fait pas partie du tout — même code couleur
/// que le mini-jeu "Compose le nombre !" du Palier "Les Calculs".
class _PuzzleSlot extends StatelessWidget {
  final int index;
  final _SlotFeedback? feedback;
  final bool enabled;
  final ValueChanged<_PieceData> onAccept;
  final double width;
  final double height;

  const _PuzzleSlot({
    required this.index,
    required this.feedback,
    required this.enabled,
    required this.onAccept,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<_PieceData>(
      onWillAcceptWithDetails: (_) => enabled,
      onAcceptWithDetails: (details) => onAccept(details.data),
      builder: (context, candidateData, rejectedData) {
        final hovering = enabled && candidateData.isNotEmpty;
        final Color borderColor = switch (feedback) {
          _SlotFeedback.misplaced => AmaniColors.warning,
          _SlotFeedback.wrong => AmaniColors.error,
          null => hovering
              ? AmaniColors.primary.withValues(alpha: 0.6)
              : AmaniColors.textPrimary.withValues(alpha: 0.15),
        };
        final Color fillColor = switch (feedback) {
          _SlotFeedback.misplaced => AmaniColors.warning.withValues(
            alpha: 0.18,
          ),
          _SlotFeedback.wrong => AmaniColors.error.withValues(alpha: 0.14),
          null => hovering
              ? AmaniColors.primary.withValues(alpha: 0.08)
              : AmaniColors.background,
        };
        return ClipPath(
          clipper: const PuzzlePieceClipper(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: fillColor,
              border: Border.all(color: borderColor, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontFamily: kBalooFontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: feedback == null
                    ? AmaniColors.textPrimary.withValues(alpha: 0.3)
                    : borderColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
