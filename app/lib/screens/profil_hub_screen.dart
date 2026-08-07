import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/amani_theme.dart';
import '../i18n/translations.dart';
import '../services/profile_auth.dart';
import '../services/progress_service.dart';
import '../services/backend_sync_service.dart';
import '../services/sign_speech.dart';
import '../hooks/use_exercise_settings.dart';
import '../hooks/use_animation_speed.dart';
import '../widgets/amani_mascot.dart';
import '../hooks/use_writing_style.dart';
import '../utils/pick_profile_photo.dart';

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
                  child: AmaniMascot(
                    pose: AmaniPose.reflexion,
                    size: AmaniSize.medium,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  t['profileLock']?['title'] ?? 'Zone Protégée',
                  style: AmaniTheme.titleStyle.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  t['profileLock']?['subtitle'] ?? 'Entrez le mot de passe',
                  style: AmaniTheme.bodyStyle.copyWith(
                    color: AmaniColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Password Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _hasError
                          ? AmaniColors.error
                          : (_passwordController.text.isNotEmpty
                                ? AmaniColors.primary
                                : AmaniColors.disabled),
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.lock_fill,
                        color: AmaniColors.textSecondary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _passwordController,
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                t['profileLock']?['passwordPlaceholder'] ??
                                'Mot de passe',
                            hintStyle: TextStyle(color: AmaniColors.disabled),
                          ),
                          onChanged: (_) => setState(() => _hasError = false),
                          style: AmaniTheme.titleStyle.copyWith(fontSize: 18),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _showPassword
                              ? CupertinoIcons.eye_slash_fill
                              : CupertinoIcons.eye_solid,
                          color: AmaniColors.textSecondary,
                        ),
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                      ),
                    ],
                  ),
                ),

                if (_hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      t['profileLock']?['wrongPassword'] ??
                          'Mot de passe incorrect',
                      style: AmaniTheme.bodyStyle.copyWith(
                        color: AmaniColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _passwordController.text.isNotEmpty
                        ? _submit
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AmaniColors.primary,
                      disabledBackgroundColor: AmaniColors.disabled,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      t['profileLock']?['unlockButton'] ?? 'Déverrouiller',
                      style: AmaniTheme.titleStyle.copyWith(
                        color: _passwordController.text.isNotEmpty
                            ? AmaniColors.background
                            : AmaniColors.textSecondary,
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
  bool _soundEnabled = true;
  double _volume = 0.85;
  int _repetitions = kDefaultRepetitions;
  int _tolerance = kDefaultTolerance;
  int _evaluationDuration = kDefaultEvaluationDuration;
  VoiceGender _voiceGender = VoiceGender.femme;
  String? _photoBase64;

  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _showNewPassword = false;
  _PasswordFeedback? _passwordFeedback;

  static const List<Map<String, Object>> _branchMeta = [
    {'icon': Icons.eco_rounded, 'color': 0xFF8FBF6F, 'done': 4, 'total': 4},
    {'icon': Icons.park_rounded, 'color': 0xFFA9784F, 'done': 3, 'total': 4},
    {
      'icon': Icons.auto_awesome_rounded,
      'color': 0xFF4A90E2,
      'done': 1,
      'total': 6,
    },
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
    final gender = await getStoredVoiceGender();
    final photo = await getStoredPhoto();
    setState(() {
      _soundEnabled = prefs.getBool('amani_setting_sound') ?? true;
      _volume = prefs.getDouble('amani_setting_volume') ?? 0.85;
      _repetitions =
          prefs.getInt(kRepetitionsStorageKey) ?? kDefaultRepetitions;
      _tolerance = prefs.getInt(kToleranceStorageKey) ?? kDefaultTolerance;
      _evaluationDuration =
          prefs.getInt(kEvaluationDurationStorageKey) ??
          kDefaultEvaluationDuration;
      _voiceGender = gender;
      _photoBase64 = photo;
    });
  }

  Future<void> _choosePhoto() async {
    final encoded = await pickAndEncodeProfilePhoto();
    if (encoded == null) return;
    await setStoredPhoto(encoded);
    if (mounted) setState(() => _photoBase64 = encoded);
  }

  Future<void> _removePhoto() async {
    await removeStoredPhoto();
    setState(() => _photoBase64 = null);
  }

  Future<void> _updateSound(bool enabled) async {
    final backend = context.read<BackendSyncService>();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('amani_setting_sound', enabled);
    setState(() => _soundEnabled = enabled);
    unawaited(backend.pushReglages(sonActif: enabled));
  }

  Future<void> _updateVoiceGender(VoiceGender gender) async {
    // Pas d'équivalent côté back-end (aucun champ "voix" sur le profil) :
    // réglage volontairement local uniquement.
    await setStoredVoiceGender(gender);
    setState(() => _voiceGender = gender);
  }

  Future<void> _updateVolume(double vol) async {
    final backend = context.read<BackendSyncService>();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('amani_setting_volume', vol);
    setState(() => _volume = vol);
    unawaited(backend.pushReglages(volume: vol));
  }

  Future<void> _updateRepetitions(int value) async {
    final backend = context.read<BackendSyncService>();
    final clamped = value.clamp(kMinRepetitions, kMaxRepetitions);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kRepetitionsStorageKey, clamped);
    setState(() => _repetitions = clamped);
    unawaited(backend.pushReglages(repetitions: clamped));
  }

  Future<void> _updateEvaluationDuration(int value) async {
    final clamped = value.clamp(kMinEvaluationDuration, kMaxEvaluationDuration);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kEvaluationDurationStorageKey, clamped);
    setState(() => _evaluationDuration = clamped);
  }

  Future<void> _updateTolerance(int value) async {
    final backend = context.read<BackendSyncService>();
    final clamped = value.clamp(kMinTolerance, kMaxTolerance);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kToleranceStorageKey, clamped);
    setState(() => _tolerance = clamped);
    // Le back-end attend une fraction (0.05-0.30), pas un pourcentage brut.
    unawaited(backend.pushReglages(tolerance: clamped / 100.0));
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
    final backend = context.read<BackendSyncService>();
    final nouveau = _newPasswordCtrl.text;
    final ancien = await getStoredPassword();
    // S'assure d'un jeton valide AVANT d'écraser l'ancien mot de passe local
    // (ensureLinked() se connecte avec le mot de passe encore en storage) —
    // sinon toute tentative de reconnexion ultérieure utiliserait le nouveau
    // mot de passe alors que le serveur ne connaît encore que l'ancien.
    await backend.ensureLinked();
    await setStoredPassword(nouveau);
    markProfileUnlocked();
    if (ancien != null) {
      unawaited(backend.pushMotDePasse(ancien: ancien, nouveau: nouveau));
    }
    _newPasswordCtrl.clear();
    _confirmPasswordCtrl.clear();
    setState(() => _passwordFeedback = _PasswordFeedback.success);
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final t = langProvider.t;
    final hub = t['profileHub'] as Map<String, dynamic>? ?? {};
    final el = t['exerciceListe'] as Map<String, dynamic>? ?? {};
    final branches = (hub['branches'] as List?) ?? [];
    final speech = context.read<SignSpeechService>();
    final writingStyle = context.watch<WritingStyleProvider>();
    final animSpeed = context.watch<AnimationSpeedProvider>();
    final stats = context.watch<ProgressProvider>().stats;

    return Scaffold(
      backgroundColor: AmaniColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header
            Row(
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: _photoBase64 != null
                              ? DecorationImage(
                                  image: MemoryImage(
                                    base64Decode(_photoBase64!),
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: _photoBase64 == null
                            ? const Icon(
                                CupertinoIcons.settings,
                                color: AmaniColors.textPrimary,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: GestureDetector(
                          onTap: _choosePhoto,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: AmaniColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AmaniColors.background,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              CupertinoIcons.camera_fill,
                              size: 11,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hub['title'] ?? 'Mon Carnet',
                        style: AmaniTheme.titleStyle.copyWith(fontSize: 21),
                      ),
                      Text(
                        hub['subtitle'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AmaniTheme.bodyStyle.copyWith(
                          fontSize: 12,
                          color: AmaniColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: hub['lockAction'] ?? 'Verrouiller',
                  icon: const Icon(
                    CupertinoIcons.lock_open_fill,
                    color: AmaniColors.textSecondary,
                  ),
                  onPressed: widget.onLock,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Photo de profil — utilisée dans le classement de la Clairière
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AmaniColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAE2D2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            image: _photoBase64 != null
                                ? DecorationImage(
                                    image: MemoryImage(
                                      base64Decode(_photoBase64!),
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: _photoBase64 == null
                              ? const Icon(
                                  CupertinoIcons.person_fill,
                                  color: AmaniColors.secondary,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: GestureDetector(
                            onTap: _choosePhoto,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AmaniColors.secondary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                CupertinoIcons.camera_fill,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hub['photoTitle'] ?? 'Photo de profil',
                          style: AmaniTheme.titleStyle.copyWith(fontSize: 14),
                        ),
                        Text(
                          hub['photoHint'] ?? '',
                          style: AmaniTheme.bodyStyle.copyWith(
                            fontSize: 12,
                            color: AmaniColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_photoBase64 != null)
                    GestureDetector(
                      onTap: _removePhoto,
                      child: Text(
                        hub['photoRemove'] ?? 'Supprimer',
                        style: TextStyle(
                          fontFamily: kBalooFontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: AmaniColors.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Points totaux — mise en avant du système de notation
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF6C453), Color(0xFFD9A84A)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x59D9A84A),
                    offset: Offset(0, 6),
                    blurRadius: 18,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      CupertinoIcons.rosette,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${stats.totalPoints}',
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w800,
                            fontSize: 28,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          hub['totalPointsLabel'] ?? 'Points totaux',
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          hub['totalPointsHint'] ?? '',
                          style: AmaniTheme.bodyStyle.copyWith(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Statistiques
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    icon: CupertinoIcons.book_fill,
                    value: '${stats.signesMaitrises}',
                    label: hub['statsSignes'] ?? '',
                    color: AmaniColors.secondary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatTile(
                    icon: CupertinoIcons.rosette,
                    value: '${stats.exercicesReussis}',
                    label: hub['statsExercices'] ?? '',
                    color: AmaniColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatTile(
                    icon: CupertinoIcons.calendar,
                    value: '${stats.joursAventure}',
                    label: hub['statsDays'] ?? '',
                    color: const Color(0xFF4A90E2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Progression par palier
            Text(
              hub['progressionTitle'] ?? '',
              style: AmaniTheme.titleStyle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 14),
            for (int i = 0; i < _branchMeta.length; i++) ...[
              _PalierProgressCard(
                icon: _branchMeta[i]['icon'] as IconData,
                color: Color(_branchMeta[i]['color'] as int),
                name: branches.length > i ? (branches[i]['name'] ?? '') : '',
                done: _branchMeta[i]['done'] as int,
                total: _branchMeta[i]['total'] as int,
                stepsTemplate:
                    hub['stepsValidated'] ?? 'sur {total} étapes validées',
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 12),

            // Section Réglages
            Text(
              hub['settingsTitle'] ?? 'Mes Réglages',
              style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 16),

            _buildCard(
              child: Column(
                children: [
                  _buildSettingRow(
                    icon: CupertinoIcons.globe,
                    title: hub['languageCardTitle'] ?? 'Langue',
                    trailing: SegmentedControl<Lang>(
                      value: langProvider.lang,
                      items: const {
                        Lang.fr: 'FR',
                        Lang.en: 'EN',
                        Lang.es: 'ES',
                      },
                      onChanged: (lang) {
                        langProvider.setLang(lang);
                        // Le back-end ne connaît pas encore l'espagnol (voir
                        // Langue.java) : dans ce cas on ne pousse rien plutôt
                        // que d'envoyer une valeur qu'il rejetterait.
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
                  const Divider(color: AmaniColors.disabled, height: 32),
                  _buildSettingRow(
                    icon: CupertinoIcons.textformat_abc,
                    title: hub['formatCardTitle'] ?? "Format d'écriture",
                    trailing: SegmentedControl<WritingStyle>(
                      value: writingStyle.style,
                      items: {
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
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              hub['soundCardTitle'] ?? 'Audio',
              style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 16),

            _buildCard(
              child: Column(
                children: [
                  _buildSettingRow(
                    icon: _soundEnabled
                        ? CupertinoIcons.speaker_2_fill
                        : CupertinoIcons.speaker_slash_fill,
                    title: hub['voiceLabel'] ?? 'Voix & Sons',
                    trailing: CupertinoSwitch(
                      value: _soundEnabled,
                      activeTrackColor: AmaniColors.primary,
                      onChanged: _updateSound,
                    ),
                  ),
                  if (_soundEnabled) ...[
                    const Divider(color: AmaniColors.disabled, height: 32),
                    Text(
                      hub['volumeLabel'] ?? 'Volume',
                      style: AmaniTheme.bodyStyle.copyWith(
                        fontSize: 14,
                        color: AmaniColors.textSecondary,
                      ),
                    ),
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
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => speech.speak(
                          hub['volumeTestPhrase'] ?? '',
                          langProvider.lang,
                        ),
                        icon: const Icon(
                          CupertinoIcons.play_fill,
                          size: 16,
                          color: AmaniColors.primary,
                        ),
                        label: Text(
                          hub['volumeTest'] ?? 'Tester le volume',
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w700,
                            color: AmaniColors.primary,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AmaniColors.disabled),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const Divider(color: AmaniColors.disabled, height: 32),
                    Text(
                      hub['voiceGenderLabel'] ?? 'Style de voix',
                      style: AmaniTheme.bodyStyle.copyWith(
                        fontSize: 14,
                        color: AmaniColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        for (final gender in VoiceGender.values) ...[
                          if (gender != VoiceGender.values.first)
                            const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _updateVoiceGender(gender),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: _voiceGender == gender
                                      ? AmaniColors.primary.withValues(
                                          alpha: 0.15,
                                        )
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: _voiceGender == gender
                                        ? AmaniColors.primary
                                        : AmaniColors.disabled,
                                    width: 2,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  ((hub['voiceGenderOptions']
                                              as List?)?[gender.index]
                                          as Map?)?['label'] ??
                                      (gender == VoiceGender.homme
                                          ? 'Voix Homme'
                                          : 'Voix Femme'),
                                  style: TextStyle(
                                    fontFamily: kBalooFontFamily,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    color: _voiceGender == gender
                                        ? AmaniColors.primaryDark
                                        : AmaniColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => speech.speak(
                          hub['voiceGenderTestPhrase'] ?? '',
                          langProvider.lang,
                        ),
                        icon: const Icon(
                          CupertinoIcons.play_fill,
                          size: 16,
                          color: AmaniColors.primary,
                        ),
                        label: Text(
                          hub['voiceGenderTest'] ?? 'Écouter un exemple',
                          style: TextStyle(
                            fontFamily: kBalooFontFamily,
                            fontWeight: FontWeight.w700,
                            color: AmaniColors.primary,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AmaniColors.disabled),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              hub['exercisesCardTitle'] ?? "Exercices d'écriture",
              style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 16),

            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    el['repetitionsLabel'] ?? 'Répétitions par signe',
                    style: AmaniTheme.titleStyle.copyWith(fontSize: 16),
                  ),
                  Text(
                    el['repetitionsHint'] ?? '',
                    style: AmaniTheme.bodyStyle.copyWith(
                      fontSize: 12,
                      color: AmaniColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _Stepper(
                    value: '$_repetitions',
                    onDecrement: () => _updateRepetitions(_repetitions - 1),
                    onIncrement: () => _updateRepetitions(_repetitions + 1),
                  ),
                  const Divider(color: AmaniColors.disabled, height: 32),
                  Text(
                    el['toleranceLabel'] ?? 'Tolérance de validation',
                    style: AmaniTheme.titleStyle.copyWith(fontSize: 16),
                  ),
                  Text(
                    el['toleranceHint'] ?? '',
                    style: AmaniTheme.bodyStyle.copyWith(
                      fontSize: 12,
                      color: AmaniColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _Stepper(
                    value: '$_tolerance%',
                    onDecrement: () => _updateTolerance(_tolerance - 3),
                    onIncrement: () => _updateTolerance(_tolerance + 3),
                  ),
                  const Divider(color: AmaniColors.disabled, height: 32),
                  Text(
                    hub['evaluationDurationLabel'] ?? "Durée d'évaluation",
                    style: AmaniTheme.titleStyle.copyWith(fontSize: 16),
                  ),
                  Text(
                    hub['evaluationDurationHint'] ?? '',
                    style: AmaniTheme.bodyStyle.copyWith(
                      fontSize: 12,
                      color: AmaniColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _Stepper(
                    value: '$_evaluationDuration min',
                    onDecrement: () =>
                        _updateEvaluationDuration(_evaluationDuration - 1),
                    onIncrement: () =>
                        _updateEvaluationDuration(_evaluationDuration + 1),
                  ),
                  const Divider(color: AmaniColors.disabled, height: 32),
                  Text(
                    hub['speedLabel'] ?? "Vitesse d'animation",
                    style: AmaniTheme.titleStyle.copyWith(fontSize: 16),
                  ),
                  Text(
                    hub['speedHint'] ?? '',
                    style: AmaniTheme.bodyStyle.copyWith(
                      fontSize: 12,
                      color: AmaniColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      for (final speed in AnimationSpeed.values) ...[
                        if (speed != AnimationSpeed.values.first)
                          const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context
                                .read<AnimationSpeedProvider>()
                                .setSpeed(speed),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: animSpeed.speed == speed
                                    ? AmaniColors.error.withValues(alpha: 0.15)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: animSpeed.speed == speed
                                      ? AmaniColors.error
                                      : AmaniColors.disabled,
                                  width: 2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                ((hub['speedOptions'] as List?)?[speed.index]
                                        as Map?)?['label'] ??
                                    speed.name,
                                style: TextStyle(
                                  fontFamily: kBalooFontFamily,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  color: animSpeed.speed == speed
                                      ? AmaniColors.error
                                      : AmaniColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              hub['passwordCardTitle'] ?? 'Mot de passe',
              style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 16),

            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PasswordField(
                    controller: _newPasswordCtrl,
                    obscure: !_showNewPassword,
                    placeholder:
                        hub['newPasswordPlaceholder'] ?? 'Nouveau mot de passe',
                    onToggleVisibility: () =>
                        setState(() => _showNewPassword = !_showNewPassword),
                    onChanged: () => setState(() => _passwordFeedback = null),
                  ),
                  const SizedBox(height: 10),
                  _PasswordField(
                    controller: _confirmPasswordCtrl,
                    obscure: !_showNewPassword,
                    placeholder:
                        hub['confirmPasswordPlaceholder'] ??
                        'Confirmer le mot de passe',
                    onChanged: () => setState(() => _passwordFeedback = null),
                  ),
                  if (_passwordFeedback == _PasswordFeedback.mismatch) ...[
                    const SizedBox(height: 8),
                    Text(
                      hub['passwordMismatch'] ?? '',
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w700,
                        color: AmaniColors.error,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  if (_passwordFeedback == _PasswordFeedback.tooShort) ...[
                    const SizedBox(height: 8),
                    Text(
                      tFormat(hub['passwordTooShort'] ?? '', {'count': 4}),
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w700,
                        color: AmaniColors.error,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  if (_passwordFeedback == _PasswordFeedback.success) ...[
                    const SizedBox(height: 8),
                    Text(
                      hub['passwordSaved'] ?? '',
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w700,
                        color: AmaniColors.success,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed:
                          (_newPasswordCtrl.text.isNotEmpty &&
                              _confirmPasswordCtrl.text.isNotEmpty)
                          ? _handleSavePassword
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AmaniColors.textPrimary,
                        disabledBackgroundColor: AmaniColors.disabled,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        hub['savePassword'] ?? 'Enregistrer le mot de passe',
                        style: TextStyle(
                          fontFamily: kBalooFontFamily,
                          fontWeight: FontWeight.w800,
                          color: AmaniColors.surface,
                        ),
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
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
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
            style: AmaniTheme.bodyStyle.copyWith(
              fontSize: 10.5,
              color: AmaniColors.textSecondary,
            ),
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
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AmaniTheme.titleStyle.copyWith(fontSize: 14.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '$done ${tFormat(stepsTemplate, {'total': total})}',
                      style: AmaniTheme.bodyStyle.copyWith(
                        fontSize: 12.5,
                        color: AmaniColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$pct%',
                  style: TextStyle(
                    fontFamily: kBalooFontFamily,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: color,
                  ),
                ),
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

  const _Stepper({
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepperButton(icon: CupertinoIcons.minus, onTap: onDecrement),
        Expanded(
          child: Center(
            child: Text(
              value,
              style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
            ),
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
        decoration: BoxDecoration(
          color: AmaniColors.background,
          shape: BoxShape.circle,
        ),
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
          const Icon(
            CupertinoIcons.lock_fill,
            size: 18,
            color: AmaniColors.textSecondary,
          ),
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
              icon: Icon(
                obscure
                    ? CupertinoIcons.eye_solid
                    : CupertinoIcons.eye_slash_fill,
                size: 18,
                color: AmaniColors.textSecondary,
              ),
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
                boxShadow: isSelected
                    ? const [BoxShadow(color: Color(0x1A000000), blurRadius: 4)]
                    : [],
              ),
              child: Text(
                entry.value,
                style: AmaniTheme.titleStyle.copyWith(
                  fontSize: 16,
                  color: isSelected
                      ? AmaniColors.textPrimary
                      : AmaniColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
