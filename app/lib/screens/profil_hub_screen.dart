import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/profile_auth.dart';
import '../services/sign_speech.dart';
import '../widgets/amani_mascot.dart';

class ProfilHubScreen extends StatefulWidget {
  const ProfilHubScreen({super.key});

  @override
  State<ProfilHubScreen> createState() => _ProfilHubScreenState();
}

class _ProfilHubScreenState extends State<ProfilHubScreen> {
  bool _isUnlocked = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLockStatus();
  }

  Future<void> _checkLockStatus() async {
    final hasPassword = await isProfileProtected();
    final unlockedThisSession = isProfileUnlockedThisSession();
    
    setState(() {
      _isUnlocked = !hasPassword || unlockedThisSession;
      _isLoading = false;
    });
  }

  void _unlock() {
    setState(() {
      _isUnlocked = true;
    });
  }

  void _lock() {
    lockProfile();
    setState(() {
      _isUnlocked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AmaniColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isUnlocked) {
      return _LockScreen(onUnlock: _unlock);
    }

    return _UnlockedProfile(onLock: _lock);
  }
}

class _LockScreen extends StatefulWidget {
  final VoidCallback onUnlock;
  
  const _LockScreen({required this.onUnlock});

  @override
  State<_LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<_LockScreen> {
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _hasError = false;

  Future<void> _submit() async {
    final storedPassword = await getStoredPassword();
    if (_passwordController.text == storedPassword) {
      markProfileUnlocked();
      widget.onUnlock();
    } else {
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;

    return Scaffold(
      backgroundColor: AmaniColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 120,
                  child: AmaniMascot(pose: AmaniPose.reflexion, size: AmaniSize.medium),
                ),
                const SizedBox(height: 24),
                Text(
                  t['profileLock']?['title'] ?? 'Zone Protégée',
                  style: AmaniTheme.titleStyle.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  t['profileLock']?['subtitle'] ?? 'Entrez le mot de passe',
                  style: AmaniTheme.bodyStyle.copyWith(color: AmaniColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Password Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _hasError ? AmaniColors.error : (_passwordController.text.isNotEmpty ? AmaniColors.primary : AmaniColors.disabled),
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.lock_fill, color: AmaniColors.textSecondary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _passwordController,
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: t['profileLock']?['passwordPlaceholder'] ?? 'Mot de passe',
                            hintStyle: TextStyle(color: AmaniColors.disabled),
                          ),
                          onChanged: (_) => setState(() => _hasError = false),
                          style: AmaniTheme.titleStyle.copyWith(fontSize: 18),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _showPassword ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_solid,
                          color: AmaniColors.textSecondary,
                        ),
                        onPressed: () => setState(() => _showPassword = !_showPassword),
                      ),
                    ],
                  ),
                ),
                
                if (_hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      t['profileLock']?['wrongPassword'] ?? 'Mot de passe incorrect',
                      style: AmaniTheme.bodyStyle.copyWith(color: AmaniColors.error, fontWeight: FontWeight.bold),
                    ),
                  ),
                  
                const SizedBox(height: 24),
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _passwordController.text.isNotEmpty ? _submit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AmaniColors.primary,
                      disabledBackgroundColor: AmaniColors.disabled,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      elevation: 0,
                    ),
                    child: Text(
                      t['profileLock']?['unlockButton'] ?? 'Déverrouiller',
                      style: AmaniTheme.titleStyle.copyWith(
                        color: _passwordController.text.isNotEmpty ? AmaniColors.background : AmaniColors.textSecondary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _PasswordFeedback { mismatch, tooShort, success }

class _UnlockedProfile extends StatefulWidget {
  final VoidCallback onLock;

  const _UnlockedProfile({required this.onLock});

  @override
  State<_UnlockedProfile> createState() => _UnlockedProfileState();
}

class _UnlockedProfileState extends State<_UnlockedProfile> {
  String _format = 'script';
  bool _soundEnabled = true;
  double _volume = 0.85;
  int _repetitions = 3;
  double _tolerance = 0.10;

  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _showNewPassword = false;
  _PasswordFeedback? _passwordFeedback;

  static const List<Map<String, Object>> _branchMeta = [
    {'icon': Icons.eco_rounded, 'color': 0xFF8FBF6F, 'done': 4, 'total': 4},
    {'icon': Icons.park_rounded, 'color': 0xFFA9784F, 'done': 3, 'total': 4},
    {'icon': Icons.auto_awesome_rounded, 'color': 0xFF4A90E2, 'done': 1, 'total': 6},
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _format = prefs.getString('amani_setting_format') ?? 'script';
      _soundEnabled = prefs.getBool('amani_setting_sound') ?? true;
      _volume = prefs.getDouble('amani_setting_volume') ?? 0.85;
      _repetitions = prefs.getInt('amani_setting_repetitions') ?? 3;
      _tolerance = prefs.getDouble('amani_setting_tolerance') ?? 0.10;
    });
  }

  Future<void> _updateFormat(String newFormat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('amani_setting_format', newFormat);
    setState(() => _format = newFormat);
  }

  Future<void> _updateSound(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('amani_setting_sound', enabled);
    setState(() => _soundEnabled = enabled);
  }

  Future<void> _updateVolume(double vol) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('amani_setting_volume', vol);
    setState(() => _volume = vol);
  }

  Future<void> _updateRepetitions(int value) async {
    final clamped = value.clamp(1, 5);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('amani_setting_repetitions', clamped);
    setState(() => _repetitions = clamped);
  }

  Future<void> _updateTolerance(double value) async {
    final clamped = value.clamp(0.05, 0.30);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('amani_setting_tolerance', clamped);
    setState(() => _tolerance = clamped);
  }

  Future<void> _handleSavePassword() async {
    if (_newPasswordCtrl.text.length < 4) {
      setState(() => _passwordFeedback = _PasswordFeedback.tooShort);
      return;
    }
    if (_newPasswordCtrl.text != _confirmPasswordCtrl.text) {
      setState(() => _passwordFeedback = _PasswordFeedback.mismatch);
      return;
    }
    await setStoredPassword(_newPasswordCtrl.text);
    markProfileUnlocked();
    _newPasswordCtrl.clear();
    _confirmPasswordCtrl.clear();
    setState(() => _passwordFeedback = _PasswordFeedback.success);
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final t = langProvider.t;
    final hub = t['profileHub'] as Map<String, dynamic>? ?? {};
    final branches = (hub['branches'] as List?) ?? [];
    final speech = context.read<SignSpeechService>();

    return Scaffold(
      backgroundColor: AmaniColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(CupertinoIcons.settings, color: AmaniColors.textPrimary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(hub['title'] ?? 'Mon Carnet', style: AmaniTheme.titleStyle.copyWith(fontSize: 21)),
                      Text(
                        hub['subtitle'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AmaniTheme.bodyStyle.copyWith(fontSize: 12, color: AmaniColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: hub['lockAction'] ?? 'Verrouiller',
                  icon: const Icon(CupertinoIcons.lock_open_fill, color: AmaniColors.textSecondary),
                  onPressed: widget.onLock,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Statistiques
            Row(
              children: [
                Expanded(child: _StatTile(icon: CupertinoIcons.book_fill, value: '7', label: hub['statsSignes'] ?? '', color: AmaniColors.secondary)),
                const SizedBox(width: 10),
                Expanded(child: _StatTile(icon: CupertinoIcons.rosette, value: '15', label: hub['statsExercices'] ?? '', color: AmaniColors.primary)),
                const SizedBox(width: 10),
                Expanded(child: _StatTile(icon: CupertinoIcons.calendar, value: '4', label: hub['statsDays'] ?? '', color: const Color(0xFF4A90E2))),
              ],
            ),
            const SizedBox(height: 28),

            // Progression par palier
            Text(hub['progressionTitle'] ?? '', style: AmaniTheme.titleStyle.copyWith(fontSize: 18)),
            const SizedBox(height: 14),
            for (int i = 0; i < _branchMeta.length; i++) ...[
              _PalierProgressCard(
                icon: _branchMeta[i]['icon'] as IconData,
                color: Color(_branchMeta[i]['color'] as int),
                name: branches.length > i ? (branches[i]['name'] ?? '') : '',
                done: _branchMeta[i]['done'] as int,
                total: _branchMeta[i]['total'] as int,
                stepsTemplate: hub['stepsValidated'] ?? 'sur {total} étapes validées',
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 12),

            // Section Réglages
            Text(hub['settingsTitle'] ?? 'Mes Réglages', style: AmaniTheme.titleStyle.copyWith(fontSize: 20)),
            const SizedBox(height: 16),

            _buildCard(
              child: Column(
                children: [
                  _buildSettingRow(
                    icon: CupertinoIcons.globe,
                    title: hub['languageCardTitle'] ?? 'Langue',
                    trailing: SegmentedControl<Lang>(
                      value: langProvider.lang,
                      items: const {Lang.fr: 'FR', Lang.en: 'EN'},
                      onChanged: (lang) => langProvider.setLang(lang),
                    ),
                  ),
                  const Divider(color: AmaniColors.disabled, height: 32),
                  _buildSettingRow(
                    icon: CupertinoIcons.textformat_abc,
                    title: hub['formatCardTitle'] ?? "Format d'écriture",
                    trailing: SegmentedControl<String>(
                      value: _format,
                      items: const {'script': 'Script', 'cursive': 'Cursive'},
                      onChanged: _updateFormat,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(hub['soundCardTitle'] ?? 'Audio', style: AmaniTheme.titleStyle.copyWith(fontSize: 20)),
            const SizedBox(height: 16),

            _buildCard(
              child: Column(
                children: [
                  _buildSettingRow(
                    icon: _soundEnabled ? CupertinoIcons.speaker_2_fill : CupertinoIcons.speaker_slash_fill,
                    title: hub['voiceLabel'] ?? 'Voix & Sons',
                    trailing: CupertinoSwitch(
                      value: _soundEnabled,
                      activeTrackColor: AmaniColors.primary,
                      onChanged: _updateSound,
                    ),
                  ),
                  if (_soundEnabled) ...[
                    const Divider(color: AmaniColors.disabled, height: 32),
                    Text(hub['volumeLabel'] ?? 'Volume', style: AmaniTheme.bodyStyle.copyWith(fontSize: 14, color: AmaniColors.textSecondary)),
                    Row(
                      children: [
                        const Icon(CupertinoIcons.volume_down, color: AmaniColors.textSecondary),
                        Expanded(
                          child: CupertinoSlider(
                            value: _volume,
                            activeColor: AmaniColors.primary,
                            onChanged: _updateVolume,
                          ),
                        ),
                        const Icon(CupertinoIcons.volume_up, color: AmaniColors.textSecondary),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => speech.speak(hub['volumeTestPhrase'] ?? '', langProvider.lang),
                        icon: const Icon(CupertinoIcons.play_fill, size: 16, color: AmaniColors.primary),
                        label: Text(hub['volumeTest'] ?? 'Tester le volume', style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w700, color: AmaniColors.primary)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AmaniColors.disabled),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(hub['exercisesCardTitle'] ?? "Exercices d'écriture", style: AmaniTheme.titleStyle.copyWith(fontSize: 20)),
            const SizedBox(height: 16),

            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hub['repetitionsLabel'] ?? 'Répétitions par signe', style: AmaniTheme.titleStyle.copyWith(fontSize: 16)),
                  Text(hub['repetitionsHint'] ?? '', style: AmaniTheme.bodyStyle.copyWith(fontSize: 12, color: AmaniColors.textSecondary)),
                  const SizedBox(height: 10),
                  _Stepper(
                    value: '$_repetitions',
                    onDecrement: () => _updateRepetitions(_repetitions - 1),
                    onIncrement: () => _updateRepetitions(_repetitions + 1),
                  ),
                  const Divider(color: AmaniColors.disabled, height: 32),
                  Text(hub['toleranceLabel'] ?? 'Tolérance de validation', style: AmaniTheme.titleStyle.copyWith(fontSize: 16)),
                  Text(hub['toleranceHint'] ?? '', style: AmaniTheme.bodyStyle.copyWith(fontSize: 12, color: AmaniColors.textSecondary)),
                  const SizedBox(height: 10),
                  _Stepper(
                    value: '${(_tolerance * 100).round()}%',
                    onDecrement: () => _updateTolerance(_tolerance - 0.05),
                    onIncrement: () => _updateTolerance(_tolerance + 0.05),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(hub['passwordCardTitle'] ?? 'Mot de passe', style: AmaniTheme.titleStyle.copyWith(fontSize: 20)),
            const SizedBox(height: 16),

            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PasswordField(
                    controller: _newPasswordCtrl,
                    obscure: !_showNewPassword,
                    placeholder: hub['newPasswordPlaceholder'] ?? 'Nouveau mot de passe',
                    onToggleVisibility: () => setState(() => _showNewPassword = !_showNewPassword),
                    onChanged: () => setState(() => _passwordFeedback = null),
                  ),
                  const SizedBox(height: 10),
                  _PasswordField(
                    controller: _confirmPasswordCtrl,
                    obscure: !_showNewPassword,
                    placeholder: hub['confirmPasswordPlaceholder'] ?? 'Confirmer le mot de passe',
                    onChanged: () => setState(() => _passwordFeedback = null),
                  ),
                  if (_passwordFeedback == _PasswordFeedback.mismatch) ...[
                    const SizedBox(height: 8),
                    Text(hub['passwordMismatch'] ?? '', style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w700, color: AmaniColors.error, fontSize: 13)),
                  ],
                  if (_passwordFeedback == _PasswordFeedback.tooShort) ...[
                    const SizedBox(height: 8),
                    Text(
                      tFormat(hub['passwordTooShort'] ?? '', {'count': 4}),
                      style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w700, color: AmaniColors.error, fontSize: 13),
                    ),
                  ],
                  if (_passwordFeedback == _PasswordFeedback.success) ...[
                    const SizedBox(height: 8),
                    Text(hub['passwordSaved'] ?? '', style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w700, color: AmaniColors.success, fontSize: 13)),
                  ],
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: (_newPasswordCtrl.text.isNotEmpty && _confirmPasswordCtrl.text.isNotEmpty)
                          ? _handleSavePassword
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AmaniColors.textPrimary,
                        disabledBackgroundColor: AmaniColors.disabled,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Text(
                        hub['savePassword'] ?? 'Enregistrer le mot de passe',
                        style: const TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w800, color: AmaniColors.surface),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), offset: Offset(0, 4), blurRadius: 12)],
      ),
      child: child,
    );
  }

  Widget _buildSettingRow({required IconData icon, required String title, required Widget trailing}) {
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
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatTile({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), offset: Offset(0, 3), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.16), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(value, style: AmaniTheme.titleStyle.copyWith(fontSize: 20)),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AmaniTheme.bodyStyle.copyWith(fontSize: 10.5, color: AmaniColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _PalierProgressCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String name;
  final int done;
  final int total;
  final String stepsTemplate;

  const _PalierProgressCard({
    required this.icon,
    required this.color,
    required this.name,
    required this.done,
    required this.total,
    required this.stepsTemplate,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (done / total * 100).round() : 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), offset: Offset(0, 3), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(14)),
                alignment: Alignment.center,
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AmaniTheme.titleStyle.copyWith(fontSize: 14.5), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(
                      '$done ${tFormat(stepsTemplate, {'total': total})}',
                      style: AmaniTheme.bodyStyle.copyWith(fontSize: 12.5, color: AmaniColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(999)),
                child: Text('$pct%', style: TextStyle(fontFamily: kBalooFontFamily, fontWeight: FontWeight.w800, fontSize: 14, color: color)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: total > 0 ? done / total : 0,
              minHeight: 9,
              backgroundColor: AmaniColors.disabled.withValues(alpha: 0.5),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final String value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _Stepper({required this.value, required this.onDecrement, required this.onIncrement});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepperButton(icon: CupertinoIcons.minus, onTap: onDecrement),
        Expanded(
          child: Center(
            child: Text(value, style: AmaniTheme.titleStyle.copyWith(fontSize: 20)),
          ),
        ),
        _StepperButton(icon: CupertinoIcons.plus, onTap: onIncrement),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: AmaniColors.background, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: AmaniColors.textPrimary),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final String placeholder;
  final VoidCallback? onToggleVisibility;
  final VoidCallback? onChanged;

  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.placeholder,
    this.onToggleVisibility,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AmaniColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AmaniColors.disabled, width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Icon(CupertinoIcons.lock_fill, size: 18, color: AmaniColors.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              onChanged: (_) => onChanged?.call(),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                hintText: placeholder,
                hintStyle: const TextStyle(color: AmaniColors.disabled),
              ),
              style: AmaniTheme.titleStyle.copyWith(fontSize: 15),
            ),
          ),
          if (onToggleVisibility != null)
            IconButton(
              icon: Icon(obscure ? CupertinoIcons.eye_solid : CupertinoIcons.eye_slash_fill, size: 18, color: AmaniColors.textSecondary),
              onPressed: onToggleVisibility,
            ),
        ],
      ),
    );
  }
}

// Simple custom segmented control for standardizing UI
class SegmentedControl<T> extends StatelessWidget {
  final T value;
  final Map<T, String> items;
  final ValueChanged<T> onChanged;

  const SegmentedControl({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AmaniColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.entries.map((entry) {
          final isSelected = entry.key == value;
          return GestureDetector(
            onTap: () => onChanged(entry.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected ? const [BoxShadow(color: Color(0x1A000000), blurRadius: 4)] : [],
              ),
              child: Text(
                entry.value,
                style: AmaniTheme.titleStyle.copyWith(
                  fontSize: 16,
                  color: isSelected ? AmaniColors.textPrimary : AmaniColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
