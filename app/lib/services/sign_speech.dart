import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../i18n/translations.dart';

const String _volumeStorageKey = 'amani_setting_volume';
const String _soundStorageKey = 'amani_setting_sound';

class SignSpeechService extends ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  
  bool get isSpeaking => _isSpeaking;

  SignSpeechService() {
    _initTts();
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

  Future<void> speak(String text, Lang lang, {double rate = 0.45, double pitch = 1.05}) async {
    await stop();

    final soundEnabled = await _isSoundEnabled();
    if (!soundEnabled) return;

    final volume = await _getStoredVolume();
    final locale = speechLocale[lang] ?? 'fr-FR';

    await _flutterTts.setLanguage(locale);
    await _flutterTts.setSpeechRate(rate); // Le rate FlutterTts diffère du Web API (0.5 est normal)
    await _flutterTts.setPitch(pitch);
    await _flutterTts.setVolume(volume);

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
