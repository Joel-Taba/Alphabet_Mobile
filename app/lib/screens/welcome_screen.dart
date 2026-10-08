import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../i18n/translations.dart';
import '../utils/text_case.dart';
import '../widgets/amani_mascot.dart';
import '../widgets/amani_button.dart';
import '../theme/amani_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;

    return Scaffold(
      body: SafeArea(
        // Défilable seulement si le contenu dépasse (grande police, longue
        // traduction) ; sinon la colonne remplit exactement l'écran.
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      capitalizeFirst(t['welcome']['title'].toString()),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        color: AmaniColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      t['welcome']['heading'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        color: AmaniColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      t['welcome']['subheading'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                        color: AmaniColors.textSecondary,
                      ),
                    ),
                    // La mascotte prend la place restante, et rapetisse sur les
                    // écrans peu hauts (paysage, petite tablette) au lieu de faire
                    // déborder la page : avec une taille fixe entre deux `Spacer`,
                    // l'écran débordait de 200 px en 800×600 (détecté par
                    // `test/widget_test.dart`).
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: AmaniMascot(
                              pose: AmaniPose.accueil,
                              size: AmaniSize.heroLg,
                            ),
                          ),
                        ),
                      ),
                    ),
                    AmaniButton(
                      label: t['welcome']['start'],
                      fullWidth: true,
                      onPressed: () => context.go('/profil'),
                    ),
                    const SizedBox(height: 16),
                    AmaniButton(
                      label: t['welcome']['imBack'],
                      variant: AmaniButtonVariant.secondary,
                      size: AmaniButtonSize.small,
                      icon: LucideIcons.userCheck,
                      onPressed: () => context.go('/connexion'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
