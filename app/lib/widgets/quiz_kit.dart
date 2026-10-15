import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/amani_theme.dart';
import 'unbroken_text.dart';
import 'amani_mascot.dart';

/// Kit visuel commun aux mini-jeux "Vrai ou Faux ?" et aux quiz (figures,
/// objets, calculs) : barre de progression par question, gros boutons
/// Vrai/Faux en relief, carte de fin de partie avec étoiles. Chaque écran
/// garde sa couleur de palier via [accent] (terracotta pour les figures,
/// violet pour les calculs).

/// État d'une question dans la barre de progression.
enum QuizDot { pending, current, correct, wrong }

/// Barre de progression segmentée : un segment par question, vert si
/// réussie, rouge si ratée, couleur du palier pour la question en cours.
class QuizProgressBar extends StatelessWidget {
  final List<QuizDot> dots;
  final Color accent;

  const QuizProgressBar({super.key, required this.dots, required this.accent});

  @override
  Widget build(BuildContext context) {
    if (dots.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
      child: Row(
        children: [
          for (var i = 0; i < dots.length; i++) ...[
            if (i > 0) const SizedBox(width: 5),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: dots[i] == QuizDot.current ? 10 : 8,
                decoration: BoxDecoration(
                  color: switch (dots[i]) {
                    QuizDot.correct => AmaniColors.success,
                    QuizDot.wrong => AmaniColors.error,
                    QuizDot.current => accent,
                    QuizDot.pending => AmaniColors.textPrimary.withValues(
                      alpha: 0.10,
                    ),
                  },
                  borderRadius: BorderRadius.circular(99),
                  boxShadow: dots[i] == QuizDot.current
                      ? [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.35),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Petite vibration horizontale réutilisable (mauvaise réponse).
class QuizShake extends StatefulWidget {
  /// Change de valeur (ex. un compteur) à chaque fois qu'il faut secouer.
  final int trigger;
  final Widget child;

  const QuizShake({super.key, required this.trigger, required this.child});

  @override
  State<QuizShake> createState() => _QuizShakeState();
}

class _QuizShakeState extends State<QuizShake>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  @override
  void didUpdateWidget(covariant QuizShake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trigger != widget.trigger && widget.trigger > 0) {
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final dx = math.sin(_c.value * math.pi * 6) * 9 * (1 - _c.value);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: widget.child,
    );
  }
}

/// Les deux gros boutons "Vrai" / "Faux" en relief. [picked] = la réponse
/// choisie (null tant que l'enfant n'a pas répondu), [pickedCorrect] = si
/// ce choix était le bon.
class TrueFalseChoices extends StatefulWidget {
  final String trueLabel;
  final String falseLabel;
  final bool? picked;
  final bool? pickedCorrect;
  final ValueChanged<bool> onAnswer;

  const TrueFalseChoices({
    super.key,
    required this.trueLabel,
    required this.falseLabel,
    required this.picked,
    required this.pickedCorrect,
    required this.onAnswer,
  });

  @override
  State<TrueFalseChoices> createState() => _TrueFalseChoicesState();
}

class _TrueFalseChoicesState extends State<TrueFalseChoices> {
  int _shakeCount = 0;

  @override
  void didUpdateWidget(covariant TrueFalseChoices oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pickedCorrect != widget.pickedCorrect &&
        widget.pickedCorrect == false) {
      _shakeCount++;
    }
  }

  Widget _tile(bool value) {
    final answered = widget.picked != null;
    final isPicked = widget.picked == value;
    // Au repos, "Vrai" est vert et "Faux" rouge ; une fois choisie, la
    // tuile prend la couleur du résultat (vert = bonne réponse, même si
    // c'était "Faux"), pour que le rouge signifie toujours "raté".
    final color = isPicked && widget.pickedCorrect != null
        ? (widget.pickedCorrect! ? AmaniColors.success : AmaniColors.error)
        : (value ? AmaniColors.success : AmaniColors.error);
    return Expanded(
      child: QuizShake(
        trigger: isPicked ? _shakeCount : 0,
        child: _RaisedTile(
          color: color,
          filled: isPicked,
          dimmed: answered && !isPicked,
          onTap: answered ? null : () => widget.onAnswer(value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPicked ? Colors.white : color,
                ),
                child: Icon(
                  value ? LucideIcons.check : LucideIcons.x,
                  color: isPicked ? color : Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value ? widget.trueLabel : widget.falseLabel,
                style: TextStyle(
                  fontFamily: kBalooFontFamily,
                  fontWeight: FontWeight.w800,
                  fontSize: 19,
                  color: isPicked ? Colors.white : AmaniColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 380),
      child: Row(
        children: [_tile(true), const SizedBox(width: 16), _tile(false)],
      ),
    );
  }
}

/// Tuile blanche en relief (bord inférieur coloré façon touche de jeu), qui
/// s'enfonce au toucher et se remplit de sa couleur une fois choisie.
class _RaisedTile extends StatefulWidget {
  final Color color;
  final bool filled;
  final bool dimmed;
  final VoidCallback? onTap;
  final Widget child;

  const _RaisedTile({
    required this.color,
    required this.filled,
    required this.dimmed,
    required this.onTap,
    required this.child,
  });

  @override
  State<_RaisedTile> createState() => _RaisedTileState();
}

class _RaisedTileState extends State<_RaisedTile> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final edge = Color.lerp(widget.color, Colors.black, 0.18)!;
    final lift = _down ? 1.0 : 6.0;
    return GestureDetector(
      onTapDown: widget.onTap == null
          ? null
          : (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: widget.onTap == null
          ? null
          : (_) {
              setState(() => _down = false);
              HapticFeedback.selectionClick();
              widget.onTap!();
            },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: widget.dimmed ? 0.4 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          margin: EdgeInsets.only(top: 6 - lift),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: widget.filled ? widget.color : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.filled
                  ? widget.color
                  : widget.color.withValues(alpha: 0.35),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(color: edge, offset: Offset(0, lift)),
              BoxShadow(
                color: widget.color.withValues(alpha: 0.18),
                blurRadius: 14,
                offset: Offset(0, lift + 4),
              ),
            ],
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}

/// Carte de fin de partie : mascotte qui fête, étoiles selon le score,
/// score en grand et bouton "Rejouer".
class QuizDoneCard extends StatelessWidget {
  final String title;
  final String body;
  final int score;
  final int total;
  final String replayLabel;
  final VoidCallback onReplay;
  final Color accent;

  const QuizDoneCard({
    super.key,
    required this.title,
    required this.body,
    required this.score,
    required this.total,
    required this.replayLabel,
    required this.onReplay,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : score / total;
    final stars = ratio >= 1
        ? 3
        : ratio >= 0.6
        ? 2
        : ratio > 0
        ? 1
        : 0;
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
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
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < 3; i++)
                Padding(
                  padding: EdgeInsets.fromLTRB(4, i == 1 ? 0 : 10, 4, 0),
                  child: Icon(
                    Icons.star_rounded,
                    size: i == 1 ? 50 : 40,
                    color: i < stars
                        ? AmaniColors.warning
                        : AmaniColors.textPrimary.withValues(alpha: 0.12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          UnbrokenText(
            title,
            textAlign: TextAlign.center,
            style: AmaniTheme.titleStyle.copyWith(fontSize: 22),
          ),
          if (total > 0) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                '$score / $total',
                style: TextStyle(
                  fontFamily: kBalooFontFamily,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: accent,
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            body,
            textAlign: TextAlign.center,
            style: AmaniTheme.bodyStyle.copyWith(
              fontSize: 14,
              color: AmaniColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: onReplay,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Color.lerp(accent, Colors.black, 0.2)!,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.rotateCcw,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    replayLabel,
                    style: TextStyle(
                      fontFamily: kBalooFontFamily,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
