import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/family_service.dart';
import '../services/profile_auth.dart';
import '../services/progress_service.dart';
import '../services/backend_sync_service.dart';
import '../hooks/use_writing_style.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Ouvre la feuille de gestion de la fratrie (basculer d'enfant, en
/// ajouter un, renommer). Après un changement d'enfant actif, recharge
/// tous les services par enfant — sans ça, l'écran continuerait d'afficher
/// la progression de l'enfant précédent jusqu'au prochain redémarrage.
Future<void> showChildSwitcherSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _ChildSwitcherSheet(),
  );
}

class _ChildSwitcherSheet extends StatefulWidget {
  const _ChildSwitcherSheet();

  @override
  State<_ChildSwitcherSheet> createState() => _ChildSwitcherSheetState();
}

class _ChildSwitcherSheetState extends State<_ChildSwitcherSheet> {
  bool _creatingNew = false;
  final _nameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _switchTo(BuildContext context, String childId) async {
    final family = context.read<FamilyService>();
    if (childId == family.activeChildId) {
      Navigator.of(context).pop();
      return;
    }
    await family.switchTo(childId);
    if (!context.mounted) return;
    // Chaque service par enfant doit relire ses propres clés namespacées.
    await Future.wait([
      context.read<ProgressProvider>().rechargerPourEnfantActif(),
      context.read<BackendSyncService>().rechargerPourEnfantActif(),
      context.read<WritingStyleProvider>().rechargerPourEnfantActif(),
    ]);
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> _createChild(BuildContext context) async {
    final nom = _nameCtrl.text.trim();
    final motDePasse = _passwordCtrl.text;
    if (nom.length < 2 || motDePasse.length < 4) return;

    final family = context.read<FamilyService>();
    await family.createChild(nom);
    await setStoredName(nom);
    await setStoredPassword(motDePasse);
    if (!context.mounted) return;
    final backend = context.read<BackendSyncService>();
    await backend.rechargerPourEnfantActif();
    unawaited(backend.ensureLinked());
    if (!context.mounted) return;
    await Future.wait([
      context.read<ProgressProvider>().rechargerPourEnfantActif(),
      context.read<WritingStyleProvider>().rechargerPourEnfantActif(),
    ]);
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final family = context.watch<FamilyService>();
    final t = context.watch<LanguageProvider>().t;
    final hub = t['profileHub'] as Map<String, dynamic>? ?? {};

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AmaniColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AmaniColors.disabled,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              hub['familyTitle'] ?? 'Nos profils',
              style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 4),
            Text(
              hub['familySubtitle'] ?? 'Choisis qui joue en ce moment',
              style: AmaniTheme.bodyStyle.copyWith(
                fontSize: 13,
                color: AmaniColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            for (final child in family.children) ...[
              _ChildTile(
                child: child,
                isActive: child.id == family.activeChildId,
                onTap: () => _switchTo(context, child.id),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 8),
            if (!_creatingNew)
              OutlinedButton.icon(
                onPressed: () => setState(() => _creatingNew = true),
                icon: const Icon(
                  LucideIcons.userRoundPlus,
                  color: AmaniColors.secondary,
                ),
                label: Text(
                  hub['familyAddChild'] ?? 'Ajouter un enfant',
                  style: TextStyle(
                    fontFamily: kBalooFontFamily,
                    fontWeight: FontWeight.w700,
                    color: AmaniColors.secondary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(
                    color: AmaniColors.secondary,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AmaniColors.disabled),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _nameCtrl,
                      decoration: InputDecoration(
                        hintText:
                            hub['familyNewChildName'] ?? "Prénom de l'enfant",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _passwordCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText:
                            hub['familyNewChildPassword'] ??
                            'Mot de passe (4 caractères min.)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed:
                          _nameCtrl.text.trim().length >= 2 &&
                              _passwordCtrl.text.length >= 4
                          ? () => _createChild(context)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AmaniColors.secondary,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        hub['familyCreate'] ?? 'Créer ce profil',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
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

class _ChildTile extends StatelessWidget {
  final ChildProfile child;
  final bool isActive;
  final VoidCallback onTap;

  const _ChildTile({
    required this.child,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isActive
              ? AmaniColors.secondary.withValues(alpha: 0.14)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive ? AmaniColors.secondary : AmaniColors.disabled,
            width: isActive ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AmaniColors.primary.withValues(alpha: 0.15),
              child: Text(
                child.nom.isNotEmpty ? child.nom[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AmaniColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                child.nom,
                style: AmaniTheme.titleStyle.copyWith(fontSize: 16),
              ),
            ),
            if (isActive)
              const Icon(
                LucideIcons.checkCircle2,
                color: AmaniColors.secondary,
              ),
          ],
        ),
      ),
    );
  }
}
