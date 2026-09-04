/// Convention française : seule la toute première lettre d'un texte affiché
/// est en majuscule, tout le reste en minuscule — jamais de texte
/// entièrement en majuscules dans l'interface (lisibilité, en particulier
/// pour de jeunes lecteurs). À utiliser à la place de `.toUpperCase()` pour
/// tout libellé/badge affiché à l'écran, quelle que soit la casse d'origine
/// de la chaîne source.
String capitalizeFirst(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}
