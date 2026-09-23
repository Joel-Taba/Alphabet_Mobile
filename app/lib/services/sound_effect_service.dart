import 'package:audioplayers/audioplayers.dart';

/// Effets sonores courts (quelques secondes), distincts de la synthèse
/// vocale (voir `SignSpeechService`) -- pas de ChangeNotifier ni
/// d'inscription Provider nécessaire, appelé aussi bien depuis des widgets
/// que depuis `ProgressProvider.awardCompletion` (qui n'a pas de
/// `BuildContext`).
///
/// Un `AudioPlayer` neuf est créé à chaque appel, puis libéré dès la fin de
/// la lecture : deux réussites rapprochées (ex. deux mots d'une même grille)
/// jouent alors chacune leur propre son sans se couper l'une l'autre,
/// plutôt que de partager un unique lecteur qui interromprait le premier son
/// pour démarrer le second.
class SoundEffectService {
  SoundEffectService._();

  static void _play(String asset) {
    final player = AudioPlayer();
    player.onPlayerComplete.listen((_) => player.dispose());
    player.play(AssetSource(asset)).catchError((_) {
      // Lecture best-effort : une erreur (ex. focus audio refusé par le
      // système) ne doit jamais interrompre l'exercice en cours.
      player.dispose();
    });
  }

  /// Joué à chaque rangée d'exercice terminée (un mot, une lettre, un
  /// calcul...) -- voir `ProgressProvider.awardCompletion`.
  static void playRowComplete() => _play('sounds/row-complete.mp3');

  /// Joué au moment où la pop-up de félicitations (confettis) apparaît, en
  /// fin d'exercice ou d'évaluation.
  static void playCelebration() => _play('sounds/celebration.mp3');
}
