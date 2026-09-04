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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
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
              const Spacer(),
              const AmaniMascot(
                pose: AmaniPose.accueil,
                size: AmaniSize.heroLg,
              ),
              const Spacer(),
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
    );
  }
}
