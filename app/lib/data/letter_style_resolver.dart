/// Résolution du style d'écriture actif ("script" | "cursive" | "digitale").
/// Port fidèle de `src/data/letter-style-resolver.ts`.
///
/// Règle pédagogique : les lettres/chiffres non encore disponibles dans le
/// style choisi retombent sur le style "script" (déjà complet), pour que le
/// parcours reste toujours praticable pendant que les catalogues
/// cursif/digital se complètent.
library;

import 'letter_formation_catalog.dart';
import 'cursive_formation_catalog.dart';
import 'digital_formation_catalog.dart';

/// Résout la forme à afficher/tracer pour un caractère donné, selon le style actif.
Map<String, dynamic>? getLetterFormation(String char, String style) {
  if (style == 'cursive') {
    return (CURSIVE_MAP[char] ?? LETTER_MAP[char]) as Map<String, dynamic>?;
  }
  if (style == 'digitale') {
    return (DIGITAL_MAP[char] ?? LETTER_MAP[char]) as Map<String, dynamic>?;
  }
  return LETTER_MAP[char] as Map<String, dynamic>?;
}

/// Vrai si ce caractère dispose déjà d'un tracé cursif dédié (sinon : repli script).
bool hasCursiveFormation(String char) => CURSIVE_MAP.containsKey(char);

/// Vrai si ce caractère dispose déjà d'un tracé digital dédié (sinon : repli script).
bool hasDigitalFormation(String char) => DIGITAL_MAP.containsKey(char);
