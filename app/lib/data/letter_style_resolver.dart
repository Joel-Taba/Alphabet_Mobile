/// Résolution du style d'écriture actif ("script" | "cursive").
/// Port fidèle de `src/data/letter-style-resolver.ts`.
///
/// Règle pédagogique : les lettres/chiffres non encore disponibles dans le
/// style choisi retombent sur le style "script" (déjà complet), pour que le
/// parcours reste toujours praticable pendant que le catalogue cursif se complète.
library;

import 'letter_formation_catalog.dart';
import 'cursive_formation_catalog.dart';

/// Résout la forme à afficher/tracer pour un caractère donné, selon le style actif.
Map<String, dynamic>? getLetterFormation(String char, String style) {
  if (style == 'cursive') {
    return (CURSIVE_MAP[char] ?? LETTER_MAP[char]) as Map<String, dynamic>?;
  }
  return LETTER_MAP[char] as Map<String, dynamic>?;
}

/// Vrai si ce caractère dispose déjà d'un tracé cursif dédié (sinon : repli script).
bool hasCursiveFormation(String char) => CURSIVE_MAP.containsKey(char);
