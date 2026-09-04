import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../services/app_lock_service.dart';
import '../theme/amani_theme.dart';
import '../widgets/amani_button.dart';
import '../widgets/amani_mascot.dart';

/// Écran affiché avant même la page de bienvenue, tant que
/// [isAppUnlocked] n'a jamais renvoyé vrai sur cet appareil — voir
/// [AppLockGate] dans `main.dart`. Volontairement indépendant de
/// `LanguageProvider`/`translations.dart` (affiché avant que le reste de
/// l'app, et ses providers, n'existent) : texte fixe en français, seule
/// langue de l'audience visée par cette protection.
class AppLockScreen extends StatefulWidget {
  final VoidCallback onUnlocked;

  const AppLockScreen({super.key, required this.onUnlocked});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _hasError = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_passwordController.text.isEmpty || _isSubmitting) return;
    setState(() {
      _isSubmitting = true;
      _hasError = false;
    });
    if (_passwordController.text == kAppAccessPassword) {
      await markAppUnlocked();
      if (!mounted) return;
      widget.onUnlocked();
    } else {
      setState(() {
        _isSubmitting = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF5EDE0), Color(0xFFEEDFC8)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AmaniMascot(
                    pose: AmaniPose.reflexion,
                    size: AmaniSize.medium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Accès protégé',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: kBalooFontFamily,
                      fontWeight: FontWeight.w800,
                      fontSize: 26,
                      color: AmaniColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Cette application est protégée. Demande le mot de "
                    "passe à la personne qui te l'a partagée.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AmaniColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AmaniColors.surface,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x234A3B2A),
                          blurRadius: 28,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 58,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(29),
                            border: Border.all(
                              color: _hasError
                                  ? AmaniColors.error
                                  : (_passwordController.text.isNotEmpty
                                        ? AmaniColors.secondary
                                        : AmaniColors.disabled),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: AmaniColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  LucideIcons.lock,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: !_showPassword,
                                  autofocus: true,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (_) => _submit(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AmaniColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Mot de passe',
                                    hintStyle: TextStyle(
                                      color: Color(0xFFB8A88A),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (_) => setState(
                                    () => _hasError = false,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _showPassword
                                      ? LucideIcons.eyeOff
                                      : LucideIcons.eye,
                                  color: AmaniColors.textSecondary,
                                ),
                                onPressed: () => setState(
                                  () => _showPassword = !_showPassword,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Mot de passe incorrect, réessaie.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AmaniColors.error,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        AmaniButton(
                          label: _isSubmitting ? 'Vérification...' : 'Valider',
                          variant: AmaniButtonVariant.secondary,
                          fullWidth: true,
                          disabled:
                              _passwordController.text.isEmpty ||
                              _isSubmitting,
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
