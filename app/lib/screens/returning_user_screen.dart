import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../i18n/translations.dart';
import '../services/backend_sync_service.dart';
import '../services/family_service.dart';
import '../services/profile_auth.dart';
import '../services/progress_service.dart';
import '../hooks/use_writing_style.dart';
import '../theme/amani_theme.dart';
import '../widgets/amani_button.dart';
import '../widgets/directional_icon.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum _CheckError { notFound, network }

/// Écran ouvert par "C'est encore moi !" (voir `welcome_screen.dart`) :
/// reconnaît un enfant déjà inscrit par son seul nom, vérifié contre la
/// base de données du back-end (`GET /api/v1/profils/existe`) — aucun mot
/// de passe dans ce flux, volontairement, pour rester simple pour un
/// enfant. Une fois passé une première fois sur cet appareil, le routeur
/// (`app.dart`, `redirect`) saute directement cet écran (et l'accueil) aux
/// ouvertures suivantes tant qu'un enfant existe localement.
class ReturningUserScreen extends StatefulWidget {
  const ReturningUserScreen({super.key});

  @override
  State<ReturningUserScreen> createState() => _ReturningUserScreenState();
}

class _ReturningUserScreenState extends State<ReturningUserScreen> {
  final _nameController = TextEditingController();
  bool _isSubmitting = false;
  _CheckError? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      !_isSubmitting && _nameController.text.trim().length >= 2;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    final nom = _nameController.text.trim();
    final backend = context.read<BackendSyncService>();

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    final existe = await backend.profilExiste(nom);
    if (!mounted) return;

    if (existe == null) {
      setState(() {
        _isSubmitting = false;
        _error = _CheckError.network;
      });
      return;
    }
    if (!existe) {
      setState(() {
        _isSubmitting = false;
        _error = _CheckError.notFound;
      });
      return;
    }

    final family = context.read<FamilyService>();
    final progress = context.read<ProgressProvider>();
    final writingStyle = context.read<WritingStyleProvider>();

    final existing = family.children.where((c) => c.nom == nom);
    if (existing.isNotEmpty) {
      await family.switchTo(existing.first.id);
    } else {
      await family.createChild(nom);
      await setStoredName(nom);
    }

    await backend.rechargerPourEnfantActif();
    await progress.rechargerPourEnfantActif();
    await writingStyle.rechargerPourEnfantActif();
    markProfileUnlocked();
    unawaited(backend.ensureLinked());

    if (!mounted) return;
    context.go('/accueil');
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;
    final ru = t['returningUser'] as Map<String, dynamic>? ?? {};

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
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.userRound,
                        color: AmaniColors.secondary,
                        size: 44,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        ru['title'] ?? "C'est encore moi !",
                        textAlign: TextAlign.center,
                        style: AmaniTheme.titleStyle.copyWith(fontSize: 26),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ru['subtitle'] ??
                            "Dis-nous comment tu t'appelles pour continuer l'aventure.",
                        textAlign: TextAlign.center,
                        style: AmaniTheme.bodyStyle.copyWith(
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
                                  color: _error != null
                                      ? AmaniColors.error
                                      : (_nameController.text.isNotEmpty
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
                                      color: AmaniColors.secondary,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      '😊',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: _nameController,
                                      autofocus: true,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (_) => _submit(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: AmaniColors.textPrimary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: InputDecoration(
                                        hintText:
                                            ru['namePlaceholder'] ??
                                            "Comment tu t'appelles ?",
                                        hintStyle: const TextStyle(
                                          color: Color(0xFFB8A88A),
                                        ),
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (_) => setState(
                                        () => _error = null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_error != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  _error == _CheckError.notFound
                                      ? (ru['errorNotFound'] ??
                                            "Ce nom n'existe pas encore. Tu peux commencer l'aventure !")
                                      : (ru['errorNetwork'] ??
                                            'Connexion impossible, réessaie.'),
                                  textAlign: TextAlign.center,
                                  style: AmaniTheme.bodyStyle.copyWith(
                                    color: AmaniColors.error,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),
                            AmaniButton(
                              label: _isSubmitting
                                  ? (ru['checking'] ?? 'Vérification...')
                                  : (ru['submit'] ?? 'Continuer'),
                              variant: AmaniButtonVariant.secondary,
                              fullWidth: true,
                              disabled: !_canSubmit,
                              onPressed: _submit,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Retour à l'écran d'accueil (`WelcomeScreen`, route `/`) :
              // cet écran est toujours atteint via `context.go` (jamais
              // `push`), donc `canPop()` est systématiquement faux — direct
              // vers `/` plutôt qu'une tentative de pop qui ne ferait jamais
              // rien.
              Positioned(
                top: 8,
                left: 8,
                child: GestureDetector(
                  onTap: () =>
                      context.canPop() ? context.pop() : context.go('/'),
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
            ],
          ),
        ),
      ),
    );
  }
}
