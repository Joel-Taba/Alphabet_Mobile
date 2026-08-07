import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/sign_speech.dart';
import '../services/backend_sync_service.dart';
import '../hooks/use_writing_style.dart';
import 'profil_hub_screen.dart' show SegmentedControl;

const _volumeStorageKey = 'amani_setting_volume';

/// Onglet "Plus" de la barre de navigation — réglages complémentaires
/// (langue, volume, format d'écriture), accessibles sans passer par Mon
/// Profil. Port de `src/routes/_app.plus.tsx`.
class PlusScreen extends StatefulWidget {
  const PlusScreen({super.key});

  @override
  State<PlusScreen> createState() => _PlusScreenState();
}

class _PlusScreenState extends State<PlusScreen> {
  double _volume = 0.85;

  @override
  void initState() {
    super.initState();
    _loadVolume();
  }

  Future<void> _loadVolume() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _volume = prefs.getDouble(_volumeStorageKey) ?? 0.85;
    });
  }

  Future<void> _updateVolume(double vol) async {
    final backend = context.read<BackendSyncService>();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_volumeStorageKey, vol);
    setState(() => _volume = vol);
    unawaited(backend.pushReglages(volume: vol));
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Row(
      children: [
        Icon(icon, color: AmaniColors.textSecondary, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: AmaniTheme.titleStyle.copyWith(fontSize: 18),
          ),
        ),
        trailing,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final t = langProvider.t;
    final plus = t['plusScreen'] as Map<String, dynamic>? ?? {};
    final hub = t['profileHub'] as Map<String, dynamic>? ?? {};
    final speech = context.read<SignSpeechService>();
    final writingStyle = context.watch<WritingStyleProvider>();

    return Scaffold(
      backgroundColor: AmaniColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              plus['title'] ?? "Plus d'options",
              style: AmaniTheme.titleStyle.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              plus['subtitle'] ?? '',
              style: AmaniTheme.bodyStyle.copyWith(
                fontSize: 13,
                color: AmaniColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            _buildCard(
              child: _buildSettingRow(
                icon: CupertinoIcons.globe,
                title: hub['languageCardTitle'] ?? 'Langue',
                trailing: SegmentedControl<Lang>(
                  value: langProvider.lang,
                  items: const {Lang.fr: 'FR', Lang.en: 'EN', Lang.es: 'ES'},
                  onChanged: (lang) {
                    langProvider.setLang(lang);
                    final backendLangue = switch (lang) {
                      Lang.fr => 'FR',
                      Lang.en => 'EN',
                      Lang.es => null,
                    };
                    if (backendLangue != null) {
                      unawaited(
                        context.read<BackendSyncService>().pushReglages(
                          langue: backendLangue,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.volume_up,
                        color: AmaniColors.textSecondary,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          hub['volumeLabel'] ?? 'Volume',
                          style: AmaniTheme.titleStyle.copyWith(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.volume_down,
                        color: AmaniColors.textSecondary,
                      ),
                      Expanded(
                        child: CupertinoSlider(
                          value: _volume,
                          activeColor: AmaniColors.primary,
                          onChanged: _updateVolume,
                        ),
                      ),
                      const Icon(
                        CupertinoIcons.volume_up,
                        color: AmaniColors.textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => speech.speak(
                        hub['volumeTestPhrase'] ?? '',
                        langProvider.lang,
                      ),
                      icon: const Icon(CupertinoIcons.play_fill, size: 16),
                      label: Text(hub['volumeTest'] ?? 'Tester le volume'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AmaniColors.primary,
                        side: const BorderSide(color: AmaniColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildCard(
              child: _buildSettingRow(
                icon: CupertinoIcons.textformat_abc,
                title: hub['formatCardTitle'] ?? "Format d'écriture",
                trailing: SegmentedControl<WritingStyle>(
                  value: writingStyle.style,
                  items: const {
                    WritingStyle.script: 'Script',
                    WritingStyle.cursive: 'Cursive',
                  },
                  onChanged: (style) {
                    writingStyle.setStyle(style);
                    unawaited(
                      context.read<BackendSyncService>().pushReglages(
                        formatEcriture: style.name.toUpperCase(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
