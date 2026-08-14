import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import '../i18n/translations.dart';
import '../services/profile_auth.dart';
import '../services/backend_sync_service.dart';
import '../theme/amani_theme.dart';
import '../utils/pick_profile_photo.dart';

class ProfileCreateScreen extends StatefulWidget {
  const ProfileCreateScreen({super.key});

  @override
  State<ProfileCreateScreen> createState() => _ProfileCreateScreenState();
}

class _ProfileCreateScreenState extends State<ProfileCreateScreen> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isLangDropdownOpen = false;
  String? _photoBase64;

  @override
  void initState() {
    super.initState();
    _loadPhoto();
  }

  Future<void> _loadPhoto() async {
    final photo = await getStoredPhoto();
    if (mounted) setState(() => _photoBase64 = photo);
  }

  Future<void> _choosePhoto() async {
    final encoded = await pickAndEncodeProfilePhoto();
    if (encoded == null) return;
    await setStoredPhoto(encoded);
    if (mounted) setState(() => _photoBase64 = encoded);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get canContinue {
    return _nameController.text.trim().length >= 2 &&
        _passwordController.text.length >= 4;
  }

  void _handleStart() async {
    if (!canContinue) return;
    final backend = context.read<BackendSyncService>();
    await setStoredName(_nameController.text.trim());
    await setStoredPassword(_passwordController.text);
    // Best-effort, ne bloque jamais la navigation : voir BackendSyncService.
    unawaited(backend.ensureLinked());
    if (!mounted) return;
    context.go('/accueil');
  }

  @override
  Widget build(BuildContext context) {
    final langProv = context.watch<LanguageProvider>();
    final t = langProv.t;

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
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 40.0,
                    left: 24.0,
                    right: 24.0,
                    bottom: 0,
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.eco, color: AmaniColors.secondary, size: 36),
                      const SizedBox(height: 8),
                      Text(
                        t['onboarding']['title'],
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: AmaniColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t['onboarding']['subtitle'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AmaniColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Mascotte (ou photo choisie) superposée
                      Transform.translate(
                        offset: const Offset(
                          0,
                          56,
                        ), // Pour superposer sur la carte
                        child: SizedBox(
                          width: 140,
                          height: 140,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x2E4A3B2A),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                  image: DecorationImage(
                                    image: _photoBase64 != null
                                        ? MemoryImage(
                                            base64Decode(_photoBase64!),
                                          )
                                        : const AssetImage(
                                                'assets/images/amani-inscription.jpeg',
                                              )
                                              as ImageProvider,
                                    fit: BoxFit.cover,
                                    alignment: _photoBase64 != null
                                        ? Alignment.center
                                        : Alignment.topCenter,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: GestureDetector(
                                  onTap: _choosePhoto,
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AmaniColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.camera_fill,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.fromLTRB(24, 80, 24, 32),
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
                      // Champ Nom
                      _buildTextField(
                        controller: _nameController,
                        hint: t['onboarding']['namePlaceholder'],
                        icon: '😊',
                        iconBg: AmaniColors.secondary,
                        isActive: _nameController.text.isNotEmpty,
                      ),
                      const SizedBox(height: 20),
                      // Champ Mot de passe
                      _buildPasswordField(t),
                      const SizedBox(height: 20),
                      // Champ Langue
                      _buildLangDropdown(langProv, t),
                      const SizedBox(height: 24),
                      // Bouton Commencer
                      _buildStartButton(t),
                    ],
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String icon,
    required Color iconBg,
    required bool isActive,
  }) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29),
        border: Border.all(
          color: isActive ? AmaniColors.secondary : AmaniColors.disabled,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(
                fontSize: 16,
                color: AmaniColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Color(0xFFB8A88A)),
                border: InputBorder.none,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(Map<String, dynamic> t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 58,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(29),
            border: Border.all(
              color: _passwordController.text.isNotEmpty
                  ? AmaniColors.secondary
                  : AmaniColors.disabled,
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
                  CupertinoIcons.lock_fill,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AmaniColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: t['onboarding']['passwordPlaceholder'],
                    hintStyle: const TextStyle(color: Color(0xFFB8A88A)),
                    border: InputBorder.none,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              IconButton(
                icon: Icon(
                  _showPassword
                      ? CupertinoIcons.eye_slash_fill
                      : CupertinoIcons.eye_fill,
                  color: AmaniColors.textSecondary,
                ),
                onPressed: () => setState(() => _showPassword = !_showPassword),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            t['onboarding']['passwordHint'],
            style: const TextStyle(
              fontSize: 12,
              color: AmaniColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLangDropdown(LanguageProvider langProv, Map<String, dynamic> t) {
    return Column(
      children: [
        GestureDetector(
          onTap: () =>
              setState(() => _isLangDropdownOpen = !_isLangDropdownOpen),
          child: Container(
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(29),
              border: Border.all(color: AmaniColors.disabled, width: 2),
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
                    CupertinoIcons.globe,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    switch (langProv.lang) {
                      Lang.fr => 'Français',
                      Lang.en => 'English',
                      Lang.es => 'Español',
                      Lang.ar => 'العربية',
                    },
                    style: const TextStyle(
                      fontSize: 16,
                      color: AmaniColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  _isLangDropdownOpen
                      ? CupertinoIcons.chevron_up
                      : CupertinoIcons.chevron_down,
                  color: AmaniColors.textSecondary,
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
        if (_isLangDropdownOpen)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: AmaniColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AmaniColors.disabled, width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x284A3B2A),
                  blurRadius: 20,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildLangOption('Français', Lang.fr, langProv),
                const Divider(height: 1, color: AmaniColors.disabled),
                _buildLangOption('English', Lang.en, langProv),
                const Divider(height: 1, color: AmaniColors.disabled),
                _buildLangOption('Español', Lang.es, langProv),
                const Divider(height: 1, color: AmaniColors.disabled),
                _buildLangOption('العربية', Lang.ar, langProv),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildLangOption(String label, Lang value, LanguageProvider langProv) {
    final isSelected = langProv.lang == value;
    return InkWell(
      onTap: () {
        langProv.setLang(value);
        setState(() => _isLangDropdownOpen = false);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AmaniColors.secondary : AmaniColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton(Map<String, dynamic> t) {
    return GestureDetector(
      onTap: canContinue ? _handleStart : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 58,
        width: double.infinity,
        decoration: BoxDecoration(
          color: canContinue ? AmaniColors.secondary : AmaniColors.disabled,
          borderRadius: BorderRadius.circular(29),
          boxShadow: [
            if (canContinue)
              const BoxShadow(
                color: AmaniColors.secondaryDark,
                offset: Offset(0, 5),
              ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          t['onboarding']['start'],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: canContinue ? AmaniColors.surface : const Color(0xFFA89880),
          ),
        ),
      ),
    );
  }
}
