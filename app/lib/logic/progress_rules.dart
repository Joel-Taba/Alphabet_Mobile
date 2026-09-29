import '../data/sign_exercise_catalog.dart';

/// Ce que les règles du parcours ont besoin de savoir de la progression :
/// `ProgressProvider` l'implémente, et les tests peuvent en fournir une
/// version simulée.
abstract interface class ProgressQuery {
  bool isCompleted({
    required String typeEtape,
    required String modalite,
    required String etapeCode,
  });

  bool isTopicExercised(String typeEtape, String topicId);
}

/// Règles "étape terminée" du parcours (`parcours_screen.dart`), sorties de
/// l'écran pour être testables et partagées. Une étape n'est terminée que
/// si son COURS **et** tous ses EXERCICES sont réussis.
class ProgressRules {
  const ProgressRules._();

  /// Index de l'étape "courante" (première non terminée) parmi [doneFlags]
  /// -- si tout est terminé, retombe sur la dernière : il reste toujours
  /// une étape courante, même une fois le palier entièrement acquis.
  static int currentGroupIndex(List<bool> doneFlags) {
    final firstNotDone = doneFlags.indexWhere((d) => !d);
    return firstNotDone == -1 ? doneFlags.length - 1 : firstNotDone;
  }

  static bool signFamilyDone(ProgressQuery p, String family) {
    final items = EXERCISE_CATALOG.where((e) => e['family'] == family);
    if (items.isEmpty) return false;
    return p.isCompleted(
          typeEtape: 'SIGNE',
          modalite: 'COURS',
          etapeCode: family,
        ) &&
        items.every(
          (e) => p.isCompleted(
            typeEtape: 'SIGNE',
            modalite: 'EXERCICE',
            etapeCode: e['id'] as String,
          ),
        );
  }

  /// Cours [groupId] réussi, et chaque élément de [itemCodes] réussi en
  /// exercice -- règle commune aux lettres, syllabes et mots.
  static bool groupDone(
    ProgressQuery p,
    String typeEtape,
    String groupId,
    Iterable<String> itemCodes,
  ) {
    return p.isCompleted(
          typeEtape: typeEtape,
          modalite: 'COURS',
          etapeCode: groupId,
        ) &&
        itemCodes.every(
          (c) => p.isCompleted(
            typeEtape: typeEtape,
            modalite: 'EXERCICE',
            etapeCode: c,
          ),
        );
  }

  /// Sujets dont les exercices sont journalisés par tentative
  /// (`'sujetId-i'` : CALCUL, FIGURE, SOLIDE) : cours réussi, et au moins
  /// un exercice de CE sujet réussi.
  static bool topicDone(ProgressQuery p, String typeEtape, String topicId) {
    return p.isCompleted(
          typeEtape: typeEtape,
          modalite: 'COURS',
          etapeCode: topicId,
        ) &&
        p.isTopicExercised(typeEtape, topicId);
  }
}
