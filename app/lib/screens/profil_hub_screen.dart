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
import '../hooks/use_accessibility_settings.dart';
import '../widgets/amani_mascot.dart';
import '../hooks/use_writing_style.dart';
import '../services/family_service.dart';
import '../utils/pick_profile_photo.dart';
import '../data/sign_exercise_catalog.dart';
import '../data/palier2_groups.dart';
import '../data/syllable_catalog.dart';
import '../data/word_catalog.dart';
import '../data/calcul_catalog.dart';
import '../data/shape_catalog.dart';
import '../data/tangram_catalog.dart';
import 'child_switcher_sheet.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
                        LucideIcons.lock,
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
                          _showPassword ? LucideIcons.eyeOff : LucideIcons.eye,
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

enum _PasswordFeedback { wrongOld, mismatch, tooShort, success }

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
  int _mentalCalcDuration = kDefaultMentalCalcDuration;
  VoiceGender _voiceGender = VoiceGender.femme;
  String? _photoBase64;
  String? _storedName;

  final _oldPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _showNewPassword = false;
  _PasswordFeedback? _passwordFeedback;

  bool _editingName = false;
  final _nameEditCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
    // Rattrapage de toute progression pas encore synchronisée, PUIS lecture
    // des statistiques serveur (sinon la lecture pourrait arriver avant que
    // le rattrapage n'ait mis le serveur à jour) — best-effort dans les deux
    // cas, voir `ProgressProvider.syncPendingProgression`/`refreshFromBackend`.
    final progress = context.read<ProgressProvider>();
    unawaited(
      progress.syncPendingProgression().then(
        (_) => progress.refreshFromBackend(),
      ),
    );
  }

  @override
  void dispose() {
    _oldPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _nameEditCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final gender = await getStoredVoiceGender();
    final photo = await getStoredPhoto();
    final name = await getStoredName();
    setState(() {
      _soundEnabled = prefs.getBool('amani_setting_sound') ?? true;
      _volume = prefs.getDouble('amani_setting_volume') ?? 0.85;
      _repetitions =
          prefs.getInt(scopeKey(kRepetitionsStorageKey)) ?? kDefaultRepetitions;
      _tolerance =
          prefs.getInt(scopeKey(kToleranceStorageKey)) ?? kDefaultTolerance;
      _evaluationDuration =
          prefs.getInt(scopeKey(kEvaluationDurationStorageKey)) ??
          kDefaultEvaluationDuration;
      _mentalCalcDuration =
          prefs.getInt(scopeKey(kMentalCalcDurationStorageKey)) ??
          kDefaultMentalCalcDuration;
      _voiceGender = gender;
      _photoBase64 = photo;
      _storedName = name;
    });
  }

  /// "Ma progression dans la forêt" : une entrée par grand palier du
  /// parcours, avec une progression réelle calculée depuis le journal de
  /// [ProgressProvider] — plus de chiffres figés. Réutilise les libellés
  /// déjà traduits des bannières de `parcours_screen.dart` (mêmes clés
  /// `t['parcours']['paliers']`/`figuresPalier`) plutôt que d'en dupliquer.
  /// Syllabes et Calculs n'apparaissent qu'en français, comme dans le
  /// parcours lui-même (nomenclature scolaire française).
  List<({IconData icon, Color color, String name, int done, int total})>
  _buildForestBranches(
    ProgressProvider progress,
    Map<String, dynamic> t,
    Lang lang,
  ) {
    final paliers = (t['parcours']?['paliers'] as List?) ?? [];
    String palName(int i) =>
        (paliers.length > i ? paliers[i]['title'] : null) ?? '';
    final figuresPalier =
        t['parcours']?['figuresPalier'] as Map<String, dynamic>?;

    final letterGroups = getPalier2Groups(lang.name);
    final letterItems = letterGroups.fold<int>(0, (s, g) => s + g.chars.length);
    final syllableGroups = SYLLABLE_GROUPS;
    final syllableItems = syllableGroups.fold<int>(
      0,
      (s, g) => s + (g['syllables'] as List).length,
    );
    final tangramCount = tangramPuzzlesByDifficulty(
      TangramDifficulty.simple,
    ).length;

    return [
      (
        icon: LucideIcons.sparkles,
        color: const Color(0xFF8FBF6F),
        name: palName(0),
        done: progress.completedCountForType('SIGNE'),
        total: FAMILY_ORDER.length + EXERCISE_CATALOG.length,
      ),
      (
        icon: LucideIcons.pencilLine,
        color: const Color(0xFFA9784F),
        name: palName(1),
        done: progress.completedCountForType('LETTRE'),
        total: letterGroups.length + letterItems,
      ),
      if (lang == Lang.fr)
        (
          icon: LucideIcons.messageCircle,
          color: const Color(0xFFD07A04),
          name: palName(2),
          done: progress.completedCountForType('SYLLABE'),
          total: syllableGroups.length + syllableItems,
        ),
      (
        icon: LucideIcons.bookOpen,
        color: const Color(0xFF4A90E2),
        name: palName(lang == Lang.fr ? 3 : 2),
        done: progress.completedCountForType('MOT'),
        total: PALIER3_GROUPS.length + WORD_CATALOG.length,
      ),
      if (lang == Lang.fr)
        (
          icon: LucideIcons.calculator,
          color: const Color(0xFF8B5FBF),
          name: palName(4),
          done: progress.completedTopicsForType('CALCUL'),
          total: CALCUL_TOPICS.length * 2,
        ),
      (
        icon: LucideIcons.shapes,
        color: const Color(0xFFB85454),
        name: figuresPalier?['title'] ?? '',
        done:
            progress.completedTopicsForType('FIGURE') +
            progress.completedCountForType('TANGRAM'),
        total: SHAPE_TOPICS.length * 2 + tangramCount * 2,
      ),
    ];
  }

  /// Nom affiché à côté de la photo de profil : `FamilyService.activeChild`
  /// est réactif (écouté via `context.watch` ailleurs dans ce widget) et se
  /// met à jour immédiatement après l'inscription, contrairement à
  /// `_storedName` (lu une seule fois dans `_loadSettings`, potentiellement
  /// périmé) — ne sert donc plus que de repli si aucun profil actif.
  String? _displayName(FamilyService family) {
    final childNom = family.activeChild?.nom.trim();
    if (childNom != null && childNom.isNotEmpty) return childNom;
    if (_storedName != null && _storedName!.trim().isNotEmpty) {
      return _storedName!.trim();
    }
    return null;
  }

  void _startEditingName(String currentName) {
    _nameEditCtrl.text = currentName;
    setState(() => _editingName = true);
  }

  /// Renomme le profil actif : passe par `FamilyService.renameChild` (source
  /// réactive de `_displayName`, écoutée partout où le nom apparaît — voir
  /// `communaute_screen.dart`) ET `setStoredName` (repli local), pour que le
  /// changement se propage immédiatement dans toute l'application sans
  /// attendre un redémarrage.
  Future<void> _saveNameEdit() async {
    final newName = _nameEditCtrl.text.trim();
    setState(() => _editingName = false);
    if (newName.isEmpty) return;
    final family = context.read<FamilyService>();
    final childId = family.activeChild?.id;
    if (childId != null) {
      await family.renameChild(childId, newName);
    }
    await setStoredName(newName);
    if (mounted) setState(() => _storedName = newName);
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
    await prefs.setInt(scopeKey(kRepetitionsStorageKey), clamped);
    setState(() => _repetitions = clamped);
    unawaited(backend.pushReglages(repetitions: clamped));
  }

  Future<void> _updateEvaluationDuration(int value) async {
    final clamped = value.clamp(kMinEvaluationDuration, kMaxEvaluationDuration);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(scopeKey(kEvaluationDurationStorageKey), clamped);
    setState(() => _evaluationDuration = clamped);
  }

  Future<void> _updateMentalCalcDuration(int value) async {
    final clamped = value.clamp(kMinMentalCalcDuration, kMaxMentalCalcDuration);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(scopeKey(kMentalCalcDurationStorageKey), clamped);
    setState(() => _mentalCalcDuration = clamped);
  }

  Future<void> _updateTolerance(int value) async {
    final backend = context.read<BackendSyncService>();
    final clamped = value.clamp(kMinTolerance, kMaxTolerance);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(scopeKey(kToleranceStorageKey), clamped);
    setState(() => _tolerance = clamped);
    // Le back-end attend une fraction (0.05-0.30), pas un pourcentage brut.
    unawaited(backend.pushReglages(tolerance: clamped / 100.0));
  }

  Future<void> _handleSavePassword() async {
    final backend = context.read<BackendSyncService>();
    final ancien = await getStoredPassword();
    if (_oldPasswordCtrl.text != ancien) {
      setState(() => _passwordFeedback = _PasswordFeedback.wrongOld);
      return;
    }
    if (_newPasswordCtrl.text.length < 4) {
      setState(() => _passwordFeedback = _PasswordFeedback.tooShort);
      return;
    }
    if (_newPasswordCtrl.text != _confirmPasswordCtrl.text) {
      setState(() => _passwordFeedback = _PasswordFeedback.mismatch);
      return;
    }
    final nouveau = _newPasswordCtrl.text;
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
    _oldPasswordCtrl.clear();
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
    final speech = context.read<SignSpeechService>();
    final writingStyle = context.watch<WritingStyleProvider>();
    final animSpeed = context.watch<AnimationSpeedProvider>();
    final progress = context.watch<ProgressProvider>();
    final stats = progress.stats;
    final streak = progress.currentStreak;
    final streakAtRisk = progress.isStreakAtRiskToday;
    final family = context.watch<FamilyService>();
    final accessibility = context.watch<AccessibilitySettings>();
    final forestBranches = _buildForestBranches(progress, t, langProvider.lang);

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
                                LucideIcons.settings,
                                color: AmaniColors.textPrimary,
                              )
                            : null,
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
                        family.activeChild != null
                            ? family.activeChild!.nom
                            : (hub['subtitle'] ?? ''),
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
                if (family.children.length > 1 || family.hasAnyChild)
                  IconButton(
                    tooltip: hub['familySwitch'] ?? "Changer d'enfant",
                    icon: const Icon(
                      LucideIcons.users,
                      color: AmaniColors.textSecondary,
                    ),
                    onPressed: () => showChildSwitcherSheet(context),
                  ),
                IconButton(
                  tooltip: hub['lockAction'] ?? 'Verrouiller',
                  icon: const Icon(
                    LucideIcons.lockKeyholeOpen,
                    color: AmaniColors.textSecondary,
                  ),
                  onPressed: widget.onLock,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Image plein cadre — bannière décorative inspirée de
            // `_app.mon-profil.tsx` (amani-profil.png), agrandie par
            // rapport au web pour que l'image reste bien visible sur
            // mobile plutôt que d'être largement rognée par BoxFit.cover.
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AmaniColors.textPrimary.withValues(alpha: 0.1),
                  ),
                  boxShadow: const [
                    BoxShadow(color: Color(0x24000000), blurRadius: 8),
                  ],
                ),
                child: Image.asset(
                  'assets/images/amani-profil.png',
                  fit: BoxFit.cover,
                ),
              ),
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
                                  LucideIcons.user,
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
                                LucideIcons.camera,
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
                    child: _editingName
                        ? Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _nameEditCtrl,
                                  autofocus: true,
                                  maxLength: 24,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    counterText: '',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                  ),
                                  style: AmaniTheme.titleStyle.copyWith(
                                    fontSize: 16,
                                  ),
                                  onSubmitted: (_) => _saveNameEdit(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _RoundIconButton(
                                icon: LucideIcons.check,
                                onTap: _saveNameEdit,
                                tooltip: hub['nameSave'] ?? 'Valider',
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      _displayName(family) ??
                                          (hub['photoTitle'] ??
                                              'Photo de profil'),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AmaniTheme.titleStyle.copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _RoundIconButton(
                                    icon: LucideIcons.pencil,
                                    small: true,
                                    onTap: () => _startEditingName(
                                      _displayName(family) ?? '',
                                    ),
                                    tooltip: hub['nameEdit'] ?? 'Modifier',
                                  ),
                                ],
                              ),
                              Text(
                                hub['photoHint'] ?? '',
                                textAlign: TextAlign.center,
                                style: AmaniTheme.bodyStyle.copyWith(
                                  fontSize: 12,
                                  color: AmaniColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                  ),
                  if (!_editingName && _photoBase64 != null)
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
                      LucideIcons.award,
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

            // Série de jours consécutifs — badge flamme mis en valeur, avec
            // un rappel visuel si l'enfant n'a pas encore joué aujourd'hui
            // alors qu'une série est en cours.
            if (streak > 0)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: streakAtRisk
                        ? const [Color(0xFFFBEFE0), Color(0xFFF7DCC0)]
                        : const [Color(0xFFFFF6E9), Color(0xFFFFE9C7)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: streakAtRisk
                        ? AmaniColors.warning
                        : const Color(0xFFF3D07A),
                    width: streakAtRisk ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFFB74D), Color(0xFFF3703A)],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x66F3703A),
                            blurRadius: 14,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        LucideIcons.flame,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            streak == 1
                                ? (hub['streakDaySingular'] ??
                                      '1 jour de suite !')
                                : tFormat(
                                    hub['streakDayPlural'] ??
                                        '{count} jours de suite !',
                                    {'count': streak},
                                  ),
                            style: AmaniTheme.titleStyle.copyWith(
                              fontSize: 16,
                              color: const Color(0xFFB85C1E),
                            ),
                          ),
                          if (streakAtRisk) ...[
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Icon(
                                  LucideIcons.alertCircle,
                                  size: 14,
                                  color: AmaniColors.warning,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    hub['streakAtRisk'] ??
                                        "Joue aujourd'hui pour continuer ta série !",
                                    style: AmaniTheme.bodyStyle.copyWith(
                                      fontSize: 12,
                                      color: AmaniColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (streak > 0) const SizedBox(height: 16),

            // Statistiques
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    icon: LucideIcons.bookOpen,
                    value: '${stats.signesMaitrises}',
                    label: hub['statsSignes'] ?? '',
                    color: AmaniColors.secondary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatTile(
                    icon: LucideIcons.award,
                    value: '${stats.exercicesReussis}',
                    label: hub['statsExercices'] ?? '',
                    color: AmaniColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatTile(
                    icon: LucideIcons.calendar,
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
            for (final branch in forestBranches) ...[
              _PalierProgressCard(
                icon: branch.icon,
                color: branch.color,
                name: branch.name,
                done: branch.done,
                total: branch.total,
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
                    icon: LucideIcons.globe,
                    title: hub['languageCardTitle'] ?? 'Langue',
                    trailing: SegmentedControl<Lang>(
                      value: langProvider.lang,
                      items: const {
                        Lang.fr: 'FR',
                        Lang.en: 'EN',
                        Lang.es: 'ES',
                        Lang.ar: 'AR',
                      },
                      onChanged: (lang) {
                        langProvider.setLang(lang);
                        // Le back-end ne connaît pas encore l'espagnol ni
                        // l'arabe (voir Langue.java) : dans ce cas on ne
                        // pousse rien plutôt que d'envoyer une valeur qu'il
                        // rejetterait.
                        final backendLangue = switch (lang) {
                          Lang.fr => 'FR',
                          Lang.en => 'EN',
                          Lang.es => null,
                          Lang.ar => null,
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
                    icon: LucideIcons.type,
                    title: hub['formatCardTitle'] ?? "Format d'écriture",
                    trailing: SegmentedControl<WritingStyle>(
                      value: writingStyle.style,
                      items: {
                        WritingStyle.script:
                            formatOptionLabel(hub, 0) ?? 'Script',
                        WritingStyle.cursive:
                            formatOptionLabel(hub, 1) ?? 'Cursive',
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
                        ? LucideIcons.volume2
                        : LucideIcons.volumeX,
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
                          LucideIcons.volume2,
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
                          LucideIcons.volume2,
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
                          Icons.play_arrow_rounded,
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
                          Icons.play_arrow_rounded,
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
                    hub['mentalCalcDurationLabel'] ?? 'Temps par calcul mental',
                    style: AmaniTheme.titleStyle.copyWith(fontSize: 16),
                  ),
                  Text(
                    hub['mentalCalcDurationHint'] ?? '',
                    style: AmaniTheme.bodyStyle.copyWith(
                      fontSize: 12,
                      color: AmaniColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _Stepper(
                    value: '${_mentalCalcDuration}s',
                    onDecrement: () =>
                        _updateMentalCalcDuration(_mentalCalcDuration - 5),
                    onIncrement: () =>
                        _updateMentalCalcDuration(_mentalCalcDuration + 5),
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
              hub['accessibilityCardTitle'] ?? 'Accessibilité',
              style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 16),

            _buildCard(
              child: Column(
                children: [
                  _buildSettingRow(
                    icon: LucideIcons.type,
                    title:
                        hub['dyslexiaFontLabel'] ?? 'Police adaptée dyslexie',
                    trailing: CupertinoSwitch(
                      value: accessibility.dyslexiaFont,
                      activeTrackColor: AmaniColors.primary,
                      onChanged: (v) => context
                          .read<AccessibilitySettings>()
                          .setDyslexiaFont(v),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      hub['dyslexiaFontHint'] ??
                          'Utilise une police conçue pour faciliter la lecture.',
                      style: AmaniTheme.bodyStyle.copyWith(
                        fontSize: 12,
                        color: AmaniColors.textSecondary,
                      ),
                    ),
                  ),
                  const Divider(color: AmaniColors.disabled, height: 32),
                  Text(
                    hub['uiScaleLabel'] ?? "Taille de l'interface",
                    style: AmaniTheme.titleStyle.copyWith(fontSize: 16),
                  ),
                  Text(
                    hub['uiScaleHint'] ?? '',
                    style: AmaniTheme.bodyStyle.copyWith(
                      fontSize: 12,
                      color: AmaniColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.type,
                        size: 16,
                        color: AmaniColors.textSecondary,
                      ),
                      Expanded(
                        child: CupertinoSlider(
                          value: accessibility.uiScale,
                          min: kMinUiScale,
                          max: kMaxUiScale,
                          divisions: 11,
                          activeColor: AmaniColors.primary,
                          onChanged: (v) => context
                              .read<AccessibilitySettings>()
                              .setUiScale(v),
                        ),
                      ),
                      const Icon(
                        LucideIcons.type,
                        size: 26,
                        color: AmaniColors.textSecondary,
                      ),
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
                    controller: _oldPasswordCtrl,
                    obscure: true,
                    placeholder:
                        hub['oldPasswordPlaceholder'] ?? 'Ancien mot de passe',
                    onChanged: () => setState(() => _passwordFeedback = null),
                  ),
                  const SizedBox(height: 10),
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
                  if (_passwordFeedback == _PasswordFeedback.wrongOld) ...[
                    const SizedBox(height: 8),
                    Text(
                      hub['passwordWrongOld'] ?? '',
                      style: TextStyle(
                        fontFamily: kBalooFontFamily,
                        fontWeight: FontWeight.w700,
                        color: AmaniColors.error,
                        fontSize: 13,
                      ),
                    ),
                  ],
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
                          (_oldPasswordCtrl.text.isNotEmpty &&
                              _newPasswordCtrl.text.isNotEmpty &&
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

/// Petit bouton rond et plein (fond coloré + icône blanche), pour qu'une
/// action comme "modifier"/"valider" se reconnaisse immédiatement comme un
/// bouton tapable — plutôt qu'une simple icône nue, facile à manquer.
class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final bool small;

  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = small ? 26.0 : 34.0;
    final button = GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AmaniColors.secondary,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Color(0x338FBF6F),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: small ? 13 : 17, color: Colors.white),
      ),
    );
    return tooltip != null ? Tooltip(message: tooltip!, child: button) : button;
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
        _StepperButton(icon: LucideIcons.minus, onTap: onDecrement),
        Expanded(
          child: Center(
            child: Text(
              value,
              style: AmaniTheme.titleStyle.copyWith(fontSize: 20),
            ),
          ),
        ),
        _StepperButton(icon: LucideIcons.plus, onTap: onIncrement),
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
            LucideIcons.lock,
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
                obscure ? LucideIcons.eye : LucideIcons.eyeOff,
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
/// Libellé traduit d'une option de `profileHub.formatOptions` (0 = script,
/// 1 = cursive) — évite de figer "Script"/"Cursive" en dur, sans traduction,
/// dans les écrans qui affichent le réglage de format d'écriture.
String? formatOptionLabel(Map<String, dynamic> hub, int index) {
  final options = hub['formatOptions'];
  if (options is! List || index >= options.length) return null;
  final option = options[index];
  if (option is! Map) return null;
  return option['label'] as String?;
}

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
