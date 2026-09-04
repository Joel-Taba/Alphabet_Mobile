import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../hooks/use_animation_speed.dart';
import '../i18n/translations.dart';

const String _volumeStorageKey = 'amani_setting_volume';
const String _soundStorageKey = 'amani_setting_sound';
const String _voiceGenderStorageKey = 'amani_setting_voice_gender';

enum VoiceGender { homme, femme }

Future<VoiceGender> getStoredVoiceGender() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_voiceGenderStorageKey);
  return raw == 'homme' ? VoiceGender.homme : VoiceGender.femme;
}

Future<void> setStoredVoiceGender(VoiceGender gender) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_voiceGenderStorageKey, gender.name);
}

/// Indices de genre/qualité dans le nom des voix système (Android/iOS n'ont
/// pas de convention commune) — même principe que la version web
/// (`src/hooks/useSignSpeech.ts`), qui doit elle aussi deviner via le nom.
const List<String> _femaleNameHints = [
  'amélie',
  'amelie',
  'audrey',
  'aurélie',
  'aurelie',
  'céline',
  'celine',
  'chantal',
  'charlotte',
  'danielle',
  'denise',
  'eloise',
  'éloise',
  'hortense',
  'julie',
  'léa',
  'lea',
  'marie',
  'virginie',
  'vivienne',
  'severine',
  'séverine',
  'samantha',
  'karen',
  'victoria',
  'zira',
  'susan',
  'aria',
  'jenny',
  'michelle',
  'joanna',
  'salli',
  'kimberly',
  'ivy',
  'kendra',
  'moira',
  'tessa',
  'female',
  'femme',
  'mónica',
  'monica',
  'paulina',
  'helena',
  'elvira',
  'lucía',
  'lucia',
];
const List<String> _maleNameHints = [
  'thomas',
  'nicolas',
  'paul',
  'henri',
  'remy',
  'rémy',
  'guillaume',
  'bruno',
  'male',
  'homme',
  'daniel',
  'alex',
  'fred',
  'david',
  'mark',
  'guy',
  'tony',
  'matthew',
  'joey',
  'justin',
  'jorge',
  'diego',
  'juan',
  'pablo',
  'álvaro',
  'alvaro',
];
const List<String> _qualityNameHints = [
  'enhanced',
  'premium',
  'neural',
  'wavenet',
  'siri',
  'natural',
];
const List<String> _lowQualityNameHints = ['compact', 'espeak'];

List<String> _tokenize(String name) {
  return name
      .toLowerCase()
      .split(RegExp(r'[^a-zà-ÿ]+'))
      .where((s) => s.isNotEmpty)
      .toList();
}

bool _nameHasAny(String name, List<String> hints) {
  final tokens = _tokenize(name);
  return hints.any(
    (h) => h.contains(' ') ? name.contains(h) : tokens.contains(h),
  );
}

class SignSpeechService extends ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  List<dynamic>? _voicesCache;

  /// Suit le réglage "Vitesse de formation" (Profil > Réglages), tenu à jour
  /// par le `ChangeNotifierProxyProvider` dans `app.dart` : le débit de la
  /// voix (voir [speak]) doit s'accorder avec cette même vitesse, plutôt que
  /// de rester figé pendant que les animations et le tracé accélèrent ou
  /// ralentissent.
  AnimationSpeed _animationSpeed = AnimationSpeed.normal;

  bool get isSpeaking => _isSpeaking;

  void updateAnimationSpeed(AnimationSpeed speed) {
    _animationSpeed = speed;
  }

  SignSpeechService() {
    _initTts();
    // Précharge la liste des voix dès le démarrage : sur mobile, le moteur
    // TTS natif s'initialise de façon asynchrone, et un premier appel à
    // `speak()` trop précoce (juste après le lancement de l'app) pouvait
    // tomber pendant cette fenêtre et ne jamais retrouver de voix de
    // qualité ensuite (voir `_availableVoices`, qui ne mémorise plus
    // désormais une liste vide comme définitive).
    unawaited(_availableVoices());
  }

  void _initTts() {
    _flutterTts.setStartHandler(() {
      _isSpeaking = true;
      notifyListeners();
    });

    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      notifyListeners();
    });

    _flutterTts.setErrorHandler((msg) {
      _isSpeaking = false;
      notifyListeners();
    });

    // Configuration de la session audio iOS (sans effet sur les autres
    // plateformes, voir `setIosAudioCategory`) : lecture au haut-parleur,
    // mélangée avec le reste (musique de fond éventuelle), plutôt que la
    // catégorie par défaut qui peut router vers l'écouteur interne ou
    // couper le son selon l'état du commutateur silencieux. Ni l'une ni
    // l'autre de ces deux méthodes n'est implémentée côté Web (le plugin y
    // lève une exception pour toute méthode non gérée) : à réserver aux
    // plateformes natives.
    if (!kIsWeb) {
      unawaited(_flutterTts.setSharedInstance(true));
      unawaited(
        _flutterTts.setIosAudioCategory(IosTextToSpeechAudioCategory.ambient, [
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
        ]),
      );
    }
  }

  Future<double> _getStoredVolume() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getDouble(_volumeStorageKey);
    if (raw == null) return 0.85;
    return raw.clamp(0.0, 1.0);
  }

  Future<bool> _isSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getBool(_soundStorageKey);
    return raw ?? true;
  }

  Future<List<dynamic>> _availableVoices() async {
    if (_voicesCache != null) return _voicesCache!;
    try {
      final raw = await _flutterTts.getVoices;
      final list = (raw is List) ? raw : <dynamic>[];
      // Une liste vide n'est jamais mémorisée : sur mobile, le moteur TTS
      // natif peut ne pas encore avoir fini de charger ses voix au tout
      // premier appel (juste après le lancement de l'app) — mémoriser ce
      // résultat vide condamnerait la sélection de voix à rester dégradée
      // (voix par défaut du système) pour toute la session.
      if (list.isNotEmpty) _voicesCache = list;
      return list;
    } catch (_) {
      return <dynamic>[];
    }
  }

  /// Choisit la meilleure voix disponible pour une locale et un genre donnés,
  /// selon le même principe de score que la version web : genre déclaré ou
  /// deviné par le nom, puis indices de qualité, la locale exacte départageant.
  Future<Map<String, String>?> _pickVoice(
    String locale,
    VoiceGender gender,
  ) async {
    final voices = await _availableVoices();
    final base = locale.split('-').first.toLowerCase();
    final candidates = voices.where((v) {
      final voiceLocale = (v is Map ? v['locale'] : null)?.toString() ?? '';
      return voiceLocale.toLowerCase().startsWith(base);
    }).toList();
    if (candidates.isEmpty) return null;

    final genderHints = gender == VoiceGender.femme
        ? _femaleNameHints
        : _maleNameHints;
    final oppositeHints = gender == VoiceGender.femme
        ? _maleNameHints
        : _femaleNameHints;

    Map<String, String>? best;
    var bestScore = -1000000;
    for (final v in candidates) {
      if (v is! Map) continue;
      final name = (v['name'] ?? '').toString();
      final voiceLocale = (v['locale'] ?? '').toString();
      final declaredGender = (v['gender'] ?? '').toString().toLowerCase();
      var score = 0;

      if (declaredGender.contains(gender.name == 'femme' ? 'female' : 'male')) {
        score += 6;
      } else if (declaredGender.contains(
        gender.name == 'femme' ? 'male' : 'female',
      )) {
        score -= 5;
      } else if (_nameHasAny(name, genderHints)) {
        score += 4;
      } else if (_nameHasAny(name, oppositeHints)) {
        score -= 3;
      }
      if (_nameHasAny(name, _qualityNameHints)) score += 3;
      if (_nameHasAny(name, _lowQualityNameHints)) score -= 2;
      if (voiceLocale.toLowerCase() == locale.toLowerCase()) score += 1;

      if (score > bestScore) {
        bestScore = score;
        best = {'name': name, 'locale': voiceLocale};
      }
    }
    return best;
  }

  Future<void> speak(
    String text,
    Lang lang, {
    double rate = 0.45,
    double? pitch,
  }) async {
    await stop();

    final soundEnabled = await _isSoundEnabled();
    if (!soundEnabled) return;

    final volume = await _getStoredVolume();
    // Certains moteurs TTS natifs (notamment sur Android, selon le
    // fabricant/l'engin installé) n'appliquent pas fidèlement un volume à
    // 0.0 et laissent filtrer un filet de voix au lieu de couper le son :
    // en dessous de ce seuil, on considère le volume comme "muet" et on
    // n'émet même pas la commande de lecture plutôt que de compter sur le
    // moteur pour le faire correctement.
    if (volume <= 0.01) return;
    final locale = speechLocale[lang] ?? 'fr-FR';
    final gender = await getStoredVoiceGender();
    // Tonalité proche du naturel : les écarts trop marqués sont ce qui fait
    // sonner une voix "robotisée".
    final resolvedPitch = pitch ?? (gender == VoiceGender.femme ? 1.05 : 0.95);

    // Le débit suit le réglage "Vitesse de formation" (Profil > Réglages),
    // borné pour ne jamais rendre la voix inintelligible aux extrêmes.
    final effectiveRate = (rate * speechRateMultiplier[_animationSpeed]!).clamp(
      0.1,
      1.0,
    );

    await _flutterTts.setLanguage(locale);
    await _flutterTts.setSpeechRate(
      effectiveRate,
    ); // Le rate FlutterTts diffère du Web API (0.5 est normal)
    await _flutterTts.setPitch(resolvedPitch);
    await _flutterTts.setVolume(volume);

    final voice = await _pickVoice(locale, gender);
    if (voice != null) {
      try {
        await _flutterTts.setVoice(voice);
      } catch (_) {
        // Certains appareils n'exposent pas setVoice — on garde la voix par
        // défaut du système plutôt que de bloquer la lecture.
      }
    }

    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _isSpeaking = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
}
