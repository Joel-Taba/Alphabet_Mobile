import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import 'amani_mascot.dart';

/// Pop-up de correction affiché dans les mini-jeux "Vrai ou Faux ?" lorsque
/// l'enfant se trompe : rappelle la bonne réponse et une brève explication,
/// avant de laisser l'enfant enchaîner sur la question suivante -- plutôt
/// que de passer directement à la suite sans qu'il sache pourquoi il s'est
/// trompé. Reprend le style visuel d'[ExerciseCompletePopup] (recouvrement
/// sombre + carte blanche centrée).
class WrongAnswerPopup extends StatelessWidget {
  /// La bonne réponse à afficher en évidence (ex. "Vrai", "12 + 5 = 17").
  final String correctAnswer;

  /// Explication brève de pourquoi c'est la bonne réponse.
  final String explanation;
  final VoidCallback onContinue;

  const WrongAnswerPopup({
    super.key,
    required this.correctAnswer,
    required this.explanation,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final wa = t['wrongAnswerPopup'] as Map<String, dynamic>? ?? {};
    final common = t['common'] as Map<String, dynamic>? ?? {};

    return Positioned.fill(
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
                pose: AmaniPose.reconfort,
                size: AmaniSize.medium,
              ),
              const SizedBox(height: 16),
              Text(
                (wa['title'] ?? 'Pas tout à fait !').toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: kBalooFontFamily,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: AmaniColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AmaniColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AmaniColors.success.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      (wa['correctAnswerLabel'] ?? 'La bonne réponse')
                          .toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: AmaniColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      correctAnswer,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: AmaniColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                explanation,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: kBalooFontFamily,
                  fontSize: 14,
                  color: AmaniColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: onContinue,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AmaniColors.secondary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x338FBF6F),
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      (common['continue'] ?? 'Continuer').toString(),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
