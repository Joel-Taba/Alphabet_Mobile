// ignore_for_file: dangling_library_doc_comments
/// Listes réduites de sujets utilisées UNIQUEMENT pendant les évaluations
/// chronométrées (flag `amaniEval=1`). Chaque palier est limité à 10 sujets
/// clés couvrant un maximum de notions, conformément à la demande de
/// 2026-09-29 de ne jamais dépasser 10 étapes par évaluation.
///
/// Les listes complètes (getPalier2Groups, SYLLABLE_GROUPS, PALIER3_GROUPS,
/// CALCUL_TOPICS) restent inchangées dans le parcours normal — elles sont
/// uniquement remplacées par ces versions réduites pendant l'évaluation.
// ignore_for_file: constant_identifier_names

import 'palier2_groups.dart';
import 'syllable_catalog.dart';
import 'word_catalog.dart';
import 'calcul_catalog.dart';

// ─────────────────────────────────────────────────────────────
// PALIER 2 — Lettres & Chiffres (14 groupes → 10)
// Conserve TOUS les groupes minuscules (l1–l6 = a→z) et les deux groupes de
// chiffres (d1, d2 = 0→9), plus deux groupes de majuscules représentatifs
// (u1 A→E et u3 K→O). Supprime les 4 autres groupes majuscules.
// ─────────────────────────────────────────────────────────────

const List<String> kEvalPalier2GroupIds = [
  'l1', // a b c d e
  'd1', // 0 1 2 3 4
  'l2', // f g h i j
  'd2', // 5 6 7 8 9
  'l3', // k l m n o
  'l4', // p q r s t
  'l5', // u v w x y
  'l6', // z
  'u1', // A B C D E
  'u3', // K L M N O
];

List<ProgressionGroup> getEvalPalier2Groups() {
  final map = getPalier2GroupMap('fr');
  return kEvalPalier2GroupIds
      .map((id) => map[id])
      .whereType<ProgressionGroup>()
      .toList();
}

// ─────────────────────────────────────────────────────────────
// PALIER 3 — Syllabes (20 groupes → 10)
// Retient les 10 consonnes les plus fréquentes en français :
// b, c, d, l, m, n, p, r, s, t.
// Supprime : f, g, h, j, k, q, v, w, y, z.
// ─────────────────────────────────────────────────────────────

const List<String> kEvalSyllabeConsonants = [
  'b', 'c', 'd', 'l', 'm', 'n', 'p', 'r', 's', 't',
];

/// Retourne la liste réduite des groupes de syllabes pour l'évaluation,
/// dans l'ordre de [kEvalSyllabeConsonants].
List<dynamic> getEvalSyllabeGroups() {
  final result = <dynamic>[];
  for (final consonant in kEvalSyllabeConsonants) {
    final group = SYLLABLE_GROUPS.firstWhere(
      (g) => (g as Map<String, dynamic>)['consonant'] == consonant,
      orElse: () => null,
    );
    if (group != null) result.add(group);
  }
  return result;
}

// ─────────────────────────────────────────────────────────────
// PALIER 4 — Mots (19 groupes → 10)
// Un groupe par thème (8 thèmes) + 2 supplémentaires pour les thèmes les
// plus riches (animaux et maison ont 3 groupes, les autres 2) afin de
// couvrir davantage de vocabulaire sans dépasser 10.
// ─────────────────────────────────────────────────────────────

const List<String> kEvalWordGroupIds = [
  'an1', // Animaux 1 (chat, chien, lion, tigre, oiseau)
  'an2', // Animaux 2
  'no1', // Nourriture 1
  'ma1', // Maison 1
  'ma2', // Maison 2
  've1', // Vêtements 1
  'ec1', // École 1
  'na1', // Nature 1
  'co1', // Corps 1
  'di1', // Autour de nous 1
];

List<WordGroup> getEvalWordGroups() =>
    kEvalWordGroupIds
        .map((id) => PALIER3_GROUP_MAP[id])
        .whereType<WordGroup>()
        .toList();

// ─────────────────────────────────────────────────────────────
// PALIER 5 — Calcul (25 topics → 10)
// Sélection représentative couvrant tous les niveaux :
// CP (addition, soustraction), CE1 (posées, tables 2/5/10),
// CE2 (multiplication posée, division), CM1 (fractions).
// Supprime : calcul mental CP, tables 1/3/4/6/7/8/9, grands nombres,
// division posée CM1, décimaux, et tout le CM2.
// ─────────────────────────────────────────────────────────────

const List<String> kEvalCalculTopicIds = [
  'cp-addition',          // Addition simple (CP)
  'cp-soustraction',      // Soustraction simple (CP)
  'ce1-addition-posee',   // Addition posée (CE1)
  'ce1-soustraction-posee', // Soustraction posée (CE1)
  'ce1-table-2',          // Table de multiplication × 2 (CE1)
  'ce1-table-5',          // Table de multiplication × 5 (CE1)
  'ce1-table-10',         // Table de multiplication × 10 (CE1)
  'ce2-multiplication-posee', // Multiplication posée (CE2)
  'ce2-division',         // Division (CE2)
  'cm1-fractions',        // Fractions (CM1)
];

List<CalculTopic> getEvalCalculTopics() =>
    kEvalCalculTopicIds
        .map((id) => CALCUL_TOPICS.firstWhere(
              (t) => t.id == id,
              orElse: () => CALCUL_TOPICS.first,
            ))
        .toList();
