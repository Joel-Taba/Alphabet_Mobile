// Nommage SCREAMING_SNAKE_CASE volontaire pour les catalogues de données
// (CALCUL_TOPICS...), en miroir direct des modules TypeScript source
// (`src/data/*.ts`) plutôt qu'une convention Dart classique — renommer en
// lowerCamelCase entrerait en collision avec des dizaines d'identifiants
// sans rapport ailleurs dans l'app (ex. `points`, `digits`) et casserait la
// correspondance 1:1 avec le Web.
// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:math';

/// PALIER 5 — Les Calculs
///
/// Arithmétique de base, organisée en 5 niveaux de difficulté croissante
/// (identifiants internes hérités du programme scolaire français CP/CE1/
/// CE2/CM1/CM2, utilisés uniquement pour le regroupement/tri -- voir
/// `_NIVEAU_NUMBERS`/`calculNiveauLabel` plus bas). Disponible dans les 4
/// langues de l'app : chaque sujet (`title`/`subtitle`/`mnemonicTitle`/
/// `mnemonicBody`) est traduit, l'étiquette de niveau affichée reste
/// générique ("Niveau 1".."Niveau 5") plutôt que la nomenclature française.
///
/// Chaque sujet correspond à une paire Cours + Exercice sur le chemin en
/// zigzag. Les problèmes eux-mêmes sont soit une liste fixe (quand l'espace
/// à mémoriser est pédagogiquement fermé — doubles, amis de 10, tables),
/// soit générés par une fonction seedée (même principe que
/// `generateWordSearch` dans `lib/utils/`) pour les sujets à grand espace
/// numérique.
class CalculProblem {
  /// Énoncé affiché (ex. "7 + 3", "3/4 + 1/4").
  final String display;

  /// Réponse à tracer, chiffre par chiffre (ex. "10"). Pas d'espace ni de
  /// signe : uniquement des caractères présents dans le catalogue `DIGITS`.
  final String answer;

  /// Seconde partie de la réponse à tracer séparément — la partie décimale
  /// d'un nombre à virgule, ou le reste d'une division — quand la réponse ne
  /// peut pas être un simple nombre entier. `null` sinon (cas le plus
  /// courant). Aucun signe (virgule, "reste") n'est jamais tracé : ces
  /// séparateurs restent du texte statique entre les deux groupes de
  /// chiffres (voir [secondPartSeparator], et `_ProblemRow` dans
  /// `exercice_calcul_screen.dart`).
  final String? answerSecondPart;

  /// Texte statique affiché entre [answer] et [answerSecondPart] (ex. ","
  /// pour un nombre décimal, " R " pour le reste d'une division). Ignoré si
  /// [answerSecondPart] est `null`.
  final String secondPartSeparator;

  /// Nombre d'objets à illustrer pour chaque opérande (uniquement pour les
  /// tout premiers problèmes de CP, où le sens du symbole prime sur le
  /// calcul lui-même) — `null` si le problème doit rester purement numérique.
  final int? illustrateA;
  final int? illustrateB;

  /// Réponses proposées en QCM (la bonne réponse, mélangée avec des
  /// distracteurs plausibles) — quand non `null`, l'exercice affiche des
  /// boutons à choisir plutôt que le traçage habituel (voir `_ProblemRow`
  /// dans `exercice_calcul_screen.dart`). `answer` reste la référence pour
  /// savoir quel choix est correct.
  final List<String>? choices;

  /// Réponse à composer en tapant sur un clavier numérique 0-9 réutilisable
  /// (plutôt qu'en traçant ou en choisissant parmi des propositions) — voir
  /// `DigitKeypadAnswer` dans `exercice_calcul_screen.dart`. Utilisé pour les
  /// tables de multiplication : l'enfant compose chiffre par chiffre.
  final bool keypadAnswer;

  const CalculProblem({
    required this.display,
    required this.answer,
    this.answerSecondPart,
    this.secondPartSeparator = '',
    this.illustrateA,
    this.illustrateB,
    this.choices,
    this.keypadAnswer = false,
  });
}

class CalculTopic {
  final String id;
  final String niveau; // 'CP' | 'CE1' | 'CE2' | 'CM1' | 'CM2'
  final Map<String, String> title;
  final Map<String, String> subtitle;
  final Map<String, String> mnemonicTitle;
  final Map<String, String> mnemonicBody;

  /// Non `null` pour un sujet "table de multiplication" (1 à 10) : le Cours
  /// affiche alors la table complète (× 0 à × 10), style fiche de référence,
  /// plutôt que la carte de démonstration générique à une seule équation —
  /// voir `cours_calcul_screen.dart`.
  final int? tableNumber;

  /// Non `null` pour un sujet "opération posée" ('addition' | 'soustraction'
  /// | 'multiplication' | 'division') : le Cours affiche alors l'opération
  /// posée colonne par colonne (retenues/emprunts animés, potence pour la
  /// division) plutôt que la carte de démonstration générique — voir
  /// `cours_calcul_screen.dart` et `widgets/posed_operation_demo.dart`.
  final String? posedOperation;

  /// Non `null` pour le sujet "calcul mental" : en mode évaluation, chaque
  /// problème est alors soumis à son propre petit chronomètre de cette
  /// durée (en secondes) plutôt que de laisser l'enfant prendre tout son
  /// temps — l'automatisme se mesure aussi à la vitesse de réponse, pas
  /// seulement à sa justesse. Sans effet hors évaluation. Fixé par sujet
  /// plutôt que réglable, pour rester cohérent avec le niveau scolaire visé
  /// par chaque sujet.
  final int? mentalCalcSeconds;

  /// [seed] varie à chaque "Relancer"/nouvelle tentative pour varier les
  /// problèmes ; [count] vient du réglage "Répétitions" (Profil > Réglages),
  /// réutilisé ici comme "nombre de problèmes par session d'exercice" (ignoré
  /// pour les tables de multiplication, qui posent toujours les 11 faits
  /// appris en entier).
  final List<CalculProblem> Function(int seed, int count) generateProblems;

  const CalculTopic({
    required this.id,
    required this.niveau,
    required this.title,
    required this.subtitle,
    required this.mnemonicTitle,
    required this.mnemonicBody,
    this.tableNumber,
    this.posedOperation,
    this.mentalCalcSeconds,
    required this.generateProblems,
  });
}

List<CalculProblem> _generateAdditionCp(int seed, int count) {
  final rand = Random(seed);
  final problems = <CalculProblem>[];
  for (var i = 0; i < count; i++) {
    // Les tout premiers problèmes restent petits et illustrés, pour ancrer
    // le sens du symbole "+" avant les calculs plus abstraits.
    if (i < 2) {
      final a = 1 + rand.nextInt(4);
      final b = 1 + rand.nextInt(4);
      problems.add(
        CalculProblem(
          display: '$a + $b',
          answer: '${a + b}',
          illustrateA: a,
          illustrateB: b,
          choices: _mcqChoices(rand, a + b),
        ),
      );
    } else {
      final a = 1 + rand.nextInt(50);
      final b = 1 + rand.nextInt(100 - a);
      problems.add(
        CalculProblem(
          display: '$a + $b',
          answer: '${a + b}',
          choices: _mcqChoices(rand, a + b),
        ),
      );
    }
  }
  return problems;
}

List<CalculProblem> _generateSoustractionCp(int seed, int count) {
  final rand = Random(seed);
  final problems = <CalculProblem>[];
  for (var i = 0; i < count; i++) {
    // Les tout premiers problèmes restent petits et illustrés (histoire des
    // bonbons qu'on mange) pour ancrer le sens du symbole "−" avant les
    // calculs plus abstraits.
    if (i < 2) {
      final a = 3 + rand.nextInt(4); // 3..6
      final b = 1 + rand.nextInt(a - 1); // 1..a-1 (reste toujours ≥ 1)
      problems.add(
        CalculProblem(
          display: '$a - $b',
          answer: '${a - b}',
          illustrateA: a,
          illustrateB: b,
          choices: _mcqChoices(rand, a - b),
        ),
      );
    } else {
      final a = 5 + rand.nextInt(16); // 5..20
      final b = rand.nextInt(a + 1); // 0..a (jamais de résultat négatif)
      problems.add(
        CalculProblem(
          display: '$a - $b',
          answer: '${a - b}',
          choices: _mcqChoices(rand, a - b),
        ),
      );
    }
  }
  return problems;
}

/// Doubles (1+1 à 9+9) et "amis de 10" — un espace de réponses fermé,
/// pédagogiquement destiné à être mémorisé par cœur plutôt que recalculé :
/// les problèmes sont donc puisés dans une liste fixe (mélangée par [seed]
/// pour varier les sessions), jamais générés aléatoirement.
List<CalculProblem> _generateCalculMentalCp(int seed, int count) {
  final rand = Random(seed);
  final pool = <CalculProblem>[
    for (var d = 1; d <= 9; d++)
      CalculProblem(
        display: '$d + $d',
        answer: '${d + d}',
        choices: _mcqChoices(rand, d + d),
      ),
    for (final pair in const [
      [1, 9],
      [2, 8],
      [3, 7],
      [4, 6],
      [5, 5],
    ])
      CalculProblem(
        display: '${pair[0]} + ${pair[1]}',
        answer: '10',
        choices: _mcqChoices(rand, 10),
      ),
  ];
  pool.shuffle(rand);
  return pool.take(count).toList();
}

List<CalculProblem> _generateAdditionPoseeCe1(int seed, int count) {
  final rand = Random(seed);
  final problems = <CalculProblem>[];
  for (var i = 0; i < count; i++) {
    // Une retenue garantie un problème sur deux, pour vraiment pratiquer la
    // technique — sinon deux nombres à deux chiffres tout à fait ordinaires.
    final tensA = 1 + rand.nextInt(8);
    final tensB = 1 + rand.nextInt(8);
    int unitsA, unitsB;
    if (i.isEven) {
      unitsA = 5 + rand.nextInt(5); // 5..9
      unitsB =
          (10 - unitsA) + rand.nextInt(unitsA); // garantit unitsA+unitsB ≥ 10
    } else {
      unitsA = rand.nextInt(5); // 0..4
      unitsB = rand.nextInt(10 - unitsA); // garantit unitsA+unitsB ≤ 9
    }
    final a = tensA * 10 + unitsA;
    final b = tensB * 10 + unitsB;
    problems.add(
      CalculProblem(
        display: '$a + $b',
        answer: '${a + b}',
        choices: _mcqChoices(rand, a + b),
      ),
    );
  }
  return problems;
}

List<CalculProblem> _generateSoustractionPoseeCe1(int seed, int count) {
  final rand = Random(seed);
  final problems = <CalculProblem>[];
  for (var i = 0; i < count; i++) {
    final tensA = 2 + rand.nextInt(7); // 2..8
    final tensB = 1 + rand.nextInt(tensA - 1); // < tensA, garantit a > b
    int unitsA, unitsB;
    if (i.isEven) {
      // Avec emprunt : le chiffre des unités de a est plus petit.
      unitsA = rand.nextInt(5); // 0..4
      unitsB = unitsA + 1 + rand.nextInt(9 - unitsA);
    } else {
      unitsA = 4 + rand.nextInt(6); // 4..9
      unitsB = rand.nextInt(unitsA + 1);
    }
    final a = tensA * 10 + unitsA;
    final b = tensB * 10 + unitsB;
    problems.add(
      CalculProblem(
        display: '$a - $b',
        answer: '${a - b}',
        choices: _mcqChoices(rand, a - b),
      ),
    );
  }
  return problems;
}

/// Une table de multiplication complète, × 0 à × 10 (11 faits), dans l'ordre
/// — comme une fiche de référence à réciter, pas un tirage aléatoire. [seed]
/// et [count] sont ignorés à dessein : "on pose toutes les multiplications
/// apprises", pas un sous-ensemble variable selon le réglage Répétitions.
List<CalculProblem> _tableFacts(int table) => [
  for (var n = 0; n <= 10; n++)
    CalculProblem(
      display: '$table × $n',
      answer: '${table * n}',
      keypadAnswer: true,
    ),
];

List<CalculProblem> _generateTable1(int seed, int count) => _tableFacts(1);
List<CalculProblem> _generateTable2(int seed, int count) => _tableFacts(2);
List<CalculProblem> _generateTable3(int seed, int count) => _tableFacts(3);
List<CalculProblem> _generateTable4(int seed, int count) => _tableFacts(4);
List<CalculProblem> _generateTable5(int seed, int count) => _tableFacts(5);
List<CalculProblem> _generateTable6(int seed, int count) => _tableFacts(6);
List<CalculProblem> _generateTable7(int seed, int count) => _tableFacts(7);
List<CalculProblem> _generateTable8(int seed, int count) => _tableFacts(8);
List<CalculProblem> _generateTable9(int seed, int count) => _tableFacts(9);
List<CalculProblem> _generateTable10(int seed, int count) => _tableFacts(10);

List<CalculProblem> _generateMultiplicationPoseeCe2(int seed, int count) {
  final rand = Random(seed);
  final problems = <CalculProblem>[];
  for (var i = 0; i < count; i++) {
    final a = 10 + rand.nextInt(90); // 10..99
    final b = 2 + rand.nextInt(8); // 2..9
    problems.add(
      CalculProblem(
        display: '$a × $b',
        answer: '${a * b}',
        choices: _mcqChoices(rand, a * b),
      ),
    );
  }
  return problems;
}

List<CalculProblem> _generateDivisionCe2(int seed, int count) {
  final rand = Random(seed);
  final problems = <CalculProblem>[];
  for (var i = 0; i < count; i++) {
    final diviseur = 2 + rand.nextInt(4); // 2..5
    if (i.isEven) {
      // Partage exact : "ça tombe juste", pas de reste.
      final quotient = 2 + rand.nextInt(10);
      final dividende = quotient * diviseur;
      problems.add(
        CalculProblem(
          display: '$dividende ÷ $diviseur',
          answer: '$quotient',
          choices: _mcqChoices(rand, quotient, min: 1),
        ),
      );
    } else {
      final quotient = 2 + rand.nextInt(9);
      final reste = 1 + rand.nextInt(diviseur - 1);
      final dividende = quotient * diviseur + reste;
      problems.add(
        CalculProblem(
          display: '$dividende ÷ $diviseur',
          answer: '$quotient',
          answerSecondPart: '$reste',
          secondPartSeparator: ' R ',
          choices: _mcqChoicesCombined(rand, quotient, '$reste', ' R ', min: 1),
        ),
      );
    }
  }
  return problems;
}

List<CalculProblem> _generateGrandsNombresCe2(int seed, int count) {
  final rand = Random(seed);
  final problems = <CalculProblem>[];
  for (var i = 0; i < count; i++) {
    if (i.isEven) {
      final a = 1000 + rand.nextInt(6000); // 1000..6999
      final b = 1 + rand.nextInt((9999 - a).clamp(1, 3000));
      problems.add(
        CalculProblem(
          display: '$a + $b',
          answer: '${a + b}',
          choices: _mcqChoices(rand, a + b),
        ),
      );
    } else {
      final a = 5000 + rand.nextInt(5000); // 5000..9999
      final b = 100 + rand.nextInt(a - 100);
      problems.add(
        CalculProblem(
          display: '$a - $b',
          answer: '${a - b}',
          choices: _mcqChoices(rand, a - b),
        ),
      );
    }
  }
  return problems;
}

List<CalculProblem> _generateDivisionPoseeCm1(int seed, int count) {
  final rand = Random(seed);
  final problems = <CalculProblem>[];
  for (var i = 0; i < count; i++) {
    final diviseur = 2 + rand.nextInt(11); // 2..12
    final quotient = 10 + rand.nextInt(40); // 10..49
    if (i.isEven) {
      final dividende = quotient * diviseur;
      problems.add(
        CalculProblem(
          display: '$dividende ÷ $diviseur',
          answer: '$quotient',
          choices: _mcqChoices(rand, quotient, min: 1),
        ),
      );
    } else {
      final reste = 1 + rand.nextInt(diviseur - 1);
      final dividende = quotient * diviseur + reste;
      problems.add(
        CalculProblem(
          display: '$dividende ÷ $diviseur',
          answer: '$quotient',
          answerSecondPart: '$reste',
          secondPartSeparator: ' R ',
          choices: _mcqChoicesCombined(rand, quotient, '$reste', ' R ', min: 1),
        ),
      );
    }
  }
  return problems;
}

/// Le dénominateur reste identique et n'est jamais tracé (affiché en clair
/// dans l'énoncé) : seul le numérateur du résultat est à tracer, pour ne pas
/// avoir à faire écrire le signe "/" à l'enfant.
List<CalculProblem> _generateFractionsCm1(int seed, int count) {
  final rand = Random(seed);
  const denominateurs = [2, 3, 4, 5, 6, 8, 10];
  final problems = <CalculProblem>[];
  for (var i = 0; i < count; i++) {
    final denom = denominateurs[rand.nextInt(denominateurs.length)];
    final numA = 1 + rand.nextInt(denom - 1);
    final numB = 1 + rand.nextInt((denom - numA).clamp(1, denom - 1));
    problems.add(
      CalculProblem(
        display: '$numA/$denom + $numB/$denom = ?/$denom',
        answer: '${numA + numB}',
        choices: _mcqChoices(rand, numA + numB, min: 1),
      ),
    );
  }
  return problems;
}

/// Dénominateurs différents : il faut les mettre au même dénominateur avant
/// d'additionner. Dénominateur commun = simple produit des deux (pas le PPCM
/// minimal — reste bien plus simple à expliquer au primaire), donc le
/// résultat n'est jamais simplifié (hors périmètre : la simplification de
/// fraction est une compétence à part). `display` reste au format "a/b +
/// c/d" (sans "=?", contrairement au sujet même-dénominateur ci-dessus) pour
/// que l'écran d'exercice générique ajoute lui-même " = ?" proprement.
List<CalculProblem> _generateFractionsDenomDiffCm2(int seed, int count) {
  final rand = Random(seed);
  const denominateurs = [2, 3, 4, 5];
  final problems = <CalculProblem>[];
  for (var i = 0; i < count; i++) {
    var denomA = denominateurs[rand.nextInt(denominateurs.length)];
    var denomB = denominateurs[rand.nextInt(denominateurs.length)];
    while (denomB == denomA) {
      denomB = denominateurs[rand.nextInt(denominateurs.length)];
    }
    final numA = 1 + rand.nextInt(denomA - 1);
    final numB = 1 + rand.nextInt(denomB - 1);
    final commonDenom = denomA * denomB;
    final resultNum = numA * denomB + numB * denomA;
    problems.add(
      CalculProblem(
        display: '$numA/$denomA + $numB/$denomB',
        answer: '$resultNum',
        answerSecondPart: '$commonDenom',
        secondPartSeparator: '/',
        choices: _mcqChoicesCombined(
          rand,
          resultNum,
          '$commonDenom',
          '/',
          min: 1,
        ),
      ),
    );
  }
  return problems;
}

String _formatDixiemes(int tenths) => '${tenths ~/ 10},${tenths % 10}';

List<CalculProblem> _generateDecimauxCm1(int seed, int count) {
  final rand = Random(seed);
  final problems = <CalculProblem>[];
  for (var i = 0; i < count; i++) {
    final aTenths = 10 + rand.nextInt(190); // 1,0 .. 19,9
    late int bTenths;
    late int resultTenths;
    final op = i.isEven ? '+' : '-';
    if (i.isEven) {
      bTenths = 10 + rand.nextInt(190);
      resultTenths = aTenths + bTenths;
    } else {
      bTenths = 1 + rand.nextInt(aTenths); // garantit a ≥ b
      resultTenths = aTenths - bTenths;
    }
    problems.add(
      CalculProblem(
        display: '${_formatDixiemes(aTenths)} $op ${_formatDixiemes(bTenths)}',
        answer: '${resultTenths ~/ 10}',
        answerSecondPart: '${resultTenths % 10}',
        secondPartSeparator: ',',
        choices: _mcqChoicesCombined(
          rand,
          resultTenths ~/ 10,
          '${resultTenths % 10}',
          ',',
        ),
      ),
    );
  }
  return problems;
}

List<CalculProblem> _generateMultiplicationDecimaleCm2(int seed, int count) {
  final rand = Random(seed);
  final problems = <CalculProblem>[];
  for (var i = 0; i < count; i++) {
    final aTenths = 11 + rand.nextInt(89); // 1,1 .. 9,9
    final b = 2 + rand.nextInt(4); // 2..5
    final resultTenths = aTenths * b;
    problems.add(
      CalculProblem(
        display: '${_formatDixiemes(aTenths)} × $b',
        answer: '${resultTenths ~/ 10}',
        answerSecondPart: '${resultTenths % 10}',
        secondPartSeparator: ',',
        choices: _mcqChoicesCombined(
          rand,
          resultTenths ~/ 10,
          '${resultTenths % 10}',
          ',',
        ),
      ),
    );
  }
  return problems;
}

List<CalculProblem> _generateDivisionDecimaleCm2(int seed, int count) {
  final rand = Random(seed);
  final problems = <CalculProblem>[];
  for (var i = 0; i < count; i++) {
    final b = 2 + rand.nextInt(4); // 2..5
    final resultTenths = 10 + rand.nextInt(90); // 1,0 .. 9,9
    final aTenths = resultTenths * b; // garantit une division exacte
    problems.add(
      CalculProblem(
        display: '${_formatDixiemes(aTenths)} ÷ $b',
        answer: '${resultTenths ~/ 10}',
        answerSecondPart: '${resultTenths % 10}',
        secondPartSeparator: ',',
        choices: _mcqChoicesCombined(
          rand,
          resultTenths ~/ 10,
          '${resultTenths % 10}',
          ',',
        ),
      ),
    );
  }
  return problems;
}

List<CalculProblem> _generateProportionnaliteCm2(int seed, int count) {
  final rand = Random(seed);
  const pourcentages = [10, 20, 25, 50];
  final problems = <CalculProblem>[];
  for (var i = 0; i < count; i++) {
    final pct = pourcentages[rand.nextInt(pourcentages.length)];
    final diviseur = 100 ~/ pct; // 10, 5, 4, 2
    final k = 1 + rand.nextInt(20);
    final base = diviseur * k;
    final resultat = base ~/ diviseur;
    problems.add(
      CalculProblem(
        display: '$pct % de $base',
        answer: '$resultat',
        choices: _mcqChoices(rand, resultat, min: 1),
      ),
    );
  }
  return problems;
}

const List<CalculTopic> CALCUL_TOPICS = [
  CalculTopic(
    id: 'cp-addition',
    niveau: 'CP',
    title: {
      'fr': "L'addition",
      'en': 'Addition',
      'es': 'La suma',
      'ar': 'الجمع',
    },
    subtitle: {
      'fr': 'Comprendre le signe + et additionner jusqu\'à 100',
      'en': 'Understand the + sign and add up to 100',
      'es': 'Comprender el signo + y sumar hasta 100',
      'ar': 'فهم إشارة + والجمع حتى 100',
    },
    mnemonicTitle: {
      'fr': 'Le signe + réunit !',
      'en': 'The + sign brings together!',
      'es': '¡El signo + une!',
      'ar': 'إشارة + تجمع!',
    },
    mnemonicBody: {
      'fr':
          'Le signe "+" veut dire qu\'on rassemble deux groupes en un seul, '
          'comme quand on met tous ses jouets dans le même panier.',
      'en':
          'The "+" sign means we put two groups together into one, just '
          'like when you put all your toys in the same basket.',
      'es':
          'El signo "+" significa que juntamos dos grupos en uno solo, '
          'como cuando guardas todos tus juguetes en la misma cesta.',
      'ar':
          'إشارة "+" تعني أننا نجمع مجموعتين في مجموعة واحدة، تمامًا كما '
          'تضع كل ألعابك في نفس السلة.',
    },
    generateProblems: _generateAdditionCp,
  ),
  CalculTopic(
    id: 'cp-soustraction',
    niveau: 'CP',
    title: {
      'fr': 'La soustraction',
      'en': 'Subtraction',
      'es': 'La resta',
      'ar': 'الطرح',
    },
    subtitle: {
      'fr': 'Comprendre le reste et calculer de petites différences',
      'en': "Understand what's left and work out small differences",
      'es': 'Comprender lo que queda y calcular pequeñas diferencias',
      'ar': 'فهم الباقي وحساب الفروق الصغيرة',
    },
    mnemonicTitle: {
      'fr': 'Le signe − enlève !',
      'en': 'The − sign takes away!',
      'es': '¡El signo − quita!',
      'ar': 'إشارة − تُنقص!',
    },
    mnemonicBody: {
      'fr':
          'Le signe "−" veut dire qu\'on enlève : comme quand on mange des '
          'bonbons dans un sachet, il en reste toujours un peu moins '
          'qu\'avant.',
      'en':
          'The "−" sign means we take away: just like eating candy from a '
          'bag, there\'s always a little less left than before.',
      'es':
          'El signo "−" significa que quitamos: como cuando te comes '
          'caramelos de una bolsa, siempre queda un poco menos que antes.',
      'ar':
          'إشارة "−" تعني أننا ننقص: تمامًا كما عندما تأكل حلوى من كيس، '
          'يبقى دائمًا أقل مما كان من قبل.',
    },
    generateProblems: _generateSoustractionCp,
  ),
  CalculTopic(
    id: 'cp-calcul-mental',
    niveau: 'CP',
    title: {
      'fr': 'Le calcul mental',
      'en': 'Mental math',
      'es': 'El cálculo mental',
      'ar': 'الحساب الذهني',
    },
    subtitle: {
      'fr': 'Automatiser les doubles et les compléments à 10',
      'en': 'Master doubles and number pairs that make 10',
      'es': 'Automatizar los dobles y los complementos a 10',
      'ar': 'إتقان الأضعاف والأعداد المكمّلة لـ10',
    },
    mnemonicTitle: {
      'fr': 'Les doubles et les amis de 10 !',
      'en': 'Doubles and friends of 10!',
      'es': '¡Los dobles y los amigos del 10!',
      'ar': 'الأضعاف وأصدقاء العدد 10!',
    },
    mnemonicBody: {
      'fr':
          'Pour les doubles, pense à la comptine : 1+1 les jumeaux, 2+2 la '
          'porte, 3+3 les dés, 4+4 la pieuvre (elle a 8 pattes !), 5+5 les '
          'doigts de tes deux mains. Pour arriver à 10, cherche ton "ami de '
          '10" : 1 et 9, 2 et 8, 3 et 7, 4 et 6, 5 et 5 !',
      'en':
          'For doubles, picture this: 1+1 is like twins, 2+2 is a '
          'four-legged table, 3+3 is a pair of dice, 4+4 is an octopus (it '
          'has 8 legs!), 5+5 is all the fingers on both your hands. To make '
          '10, find its "friend": 1 and 9, 2 and 8, 3 and 7, 4 and 6, 5 and '
          '5!',
      'es':
          'Para los dobles, imagina esto: 1+1 son gemelos, 2+2 son las '
          'patas de una silla, 3+3 son un par de dados, 4+4 es un pulpo '
          '(¡tiene 8 patas!), 5+5 son los dedos de tus dos manos. Para '
          'llegar a 10, busca su "amigo": 1 y 9, 2 y 8, 3 y 7, 4 y 6, ¡5 y '
          '5!',
      'ar':
          'للأضعاف، تخيّل: 1+1 مثل توأم، 2+2 مثل أرجل كرسي، 3+3 مثل زوج من '
          'النرد، 4+4 مثل أخطبوط (له 8 أرجل!)، 5+5 مثل أصابع يديك الاثنتين. '
          'للوصول إلى 10، ابحث عن "صديقه": 1 و9، 2 و8، 3 و7، 4 و6، و5 و5!',
    },
    // Niveau CP, doubles/compléments à 10 à un chiffre : un calcul très
    // rapide à mémoriser, la réponse se choisissant ensuite parmi des
    // propositions (QCM, voir `_generateCalculMentalCp`) plutôt que d'être
    // tracée -- 20 s laisse malgré tout un temps de lecture confortable
    // avant que le chronomètre ne presse l'enfant.
    mentalCalcSeconds: 20,
    generateProblems: _generateCalculMentalCp,
  ),
  CalculTopic(
    id: 'ce1-addition-posee',
    niveau: 'CE1',
    title: {
      'fr': "L'addition posée",
      'en': 'Column addition',
      'es': 'La suma en columna',
      'ar': 'الجمع بالعمود',
    },
    subtitle: {
      'fr': 'Maîtriser la technique avec des retenues',
      'en': 'Master the technique, including carrying',
      'es': 'Dominar la técnica con llevadas',
      'ar': 'إتقان الطريقة مع الاحتفاظ بالعشرات',
    },
    mnemonicTitle: {
      'fr': 'La retenue qui grimpe !',
      'en': 'The carry that climbs!',
      'es': '¡La llevada que sube!',
      'ar': 'العشرة المحمولة التي تصعد!',
    },
    mnemonicBody: {
      'fr':
          'Quand les unités dépassent 9, on ne peut en garder que le '
          'chiffre des unités : la dizaine en trop "grimpe" tout en haut de '
          'la colonne suivante pour s\'ajouter aux dizaines. Elle voyage, '
          'elle ne disparaît jamais !',
      'en':
          'When the ones add up to more than 9, we can only keep the ones '
          'digit: the extra ten "climbs" to the top of the next column to '
          'join the tens. It travels along — it never disappears!',
      'es':
          'Cuando las unidades superan 9, solo podemos quedarnos con la '
          'cifra de las unidades: la decena sobrante "sube" hasta arriba de '
          'la columna siguiente para sumarse a las decenas. ¡Viaja, pero '
          'nunca desaparece!',
      'ar':
          'عندما يتجاوز مجموع الآحاد 9، لا نحتفظ إلا برقم الآحاد: العشرة '
          'الزائدة "تصعد" إلى أعلى العمود التالي لتُضاف إلى العشرات. إنها '
          'تنتقل ولا تختفي أبدًا!',
    },
    posedOperation: 'addition',
    generateProblems: _generateAdditionPoseeCe1,
  ),
  CalculTopic(
    id: 'ce1-soustraction-posee',
    niveau: 'CE1',
    title: {
      'fr': 'La soustraction posée',
      'en': 'Column subtraction',
      'es': 'La resta en columna',
      'ar': 'الطرح بالعمود',
    },
    subtitle: {
      'fr': 'Calcul écrit sans puis avec retenue',
      'en': 'Written calculation, first without then with borrowing',
      'es': 'Cálculo escrito, primero sin y luego con préstamo',
      'ar': 'الحساب الكتابي، أولًا بدون ثم مع الاستلاف',
    },
    mnemonicTitle: {
      'fr': "On emprunte une dizaine !",
      'en': 'Borrow a ten!',
      'es': '¡Pedimos prestada una decena!',
      'ar': 'نستلف عشرة!',
    },
    mnemonicBody: {
      'fr':
          'Si le chiffre du haut est plus petit que celui du bas, on '
          'emprunte une dizaine à la colonne voisine : elle revient sous '
          'forme de 10 unités supplémentaires. Un emprunt, ça se rend '
          'toujours, alors on n\'oublie pas de l\'enlever à la colonne '
          'd\'à côté !',
      'en':
          'If the top digit is smaller than the bottom one, borrow a ten '
          'from the next column: it comes back as 10 extra ones. A loan '
          'always has to be paid back, so don\'t forget to take it away '
          'from the column next door!',
      'es':
          'Si la cifra de arriba es más pequeña que la de abajo, pedimos '
          'prestada una decena a la columna vecina: vuelve convertida en 10 '
          'unidades extra. Un préstamo siempre se devuelve, ¡así que no '
          'olvides restarlo en la columna de al lado!',
      'ar':
          'إذا كان الرقم العلوي أصغر من الرقم السفلي، نستلف عشرة من العمود '
          'المجاور: تعود على شكل 10 آحاد إضافية. القرض يُرَدّ دائمًا، فلا '
          'تنسَ أن تطرحه من العمود المجاور!',
    },
    posedOperation: 'soustraction',
    generateProblems: _generateSoustractionPoseeCe1,
  ),
  CalculTopic(
    id: 'ce1-table-1',
    niveau: 'CE1',
    title: {
      'fr': 'Table de 1',
      'en': 'Times table of 1',
      'es': 'Tabla del 1',
      'ar': 'جدول الضرب في 1',
    },
    subtitle: {
      'fr': 'Apprends et récite la table de 1',
      'en': 'Learn and recite the times table of 1',
      'es': 'Aprende y recita la tabla del 1',
      'ar': 'تعلّم واحفظ جدول الضرب في 1',
    },
    mnemonicTitle: {
      'fr': 'Multiplier par 1, ça ne change rien !',
      'en': 'Multiplying by 1 changes nothing!',
      'es': '¡Multiplicar por 1 no cambia nada!',
      'ar': 'الضرب في 1 لا يغيّر شيئًا!',
    },
    mnemonicBody: {
      'fr':
          'Un nombre multiplié par 1 reste toujours lui-même : 1 × 7, '
          'c\'est juste 7 ! C\'est la table la plus facile de toutes.',
      'en':
          'A number multiplied by 1 always stays itself: 1 × 7 is just 7! '
          'It\'s the easiest table of all.',
      'es':
          'Un número multiplicado por 1 siempre sigue siendo él mismo: '
          '1 × 7 es simplemente 7. ¡Es la tabla más fácil de todas!',
      'ar':
          'أي عدد مضروب في 1 يبقى كما هو: 1 × 7 يساوي 7 فقط! إنه أسهل جدول '
          'ضرب على الإطلاق.',
    },
    tableNumber: 1,
    generateProblems: _generateTable1,
  ),
  CalculTopic(
    id: 'ce1-table-2',
    niveau: 'CE1',
    title: {
      'fr': 'Table de 2',
      'en': 'Times table of 2',
      'es': 'Tabla del 2',
      'ar': 'جدول الضرب في 2',
    },
    subtitle: {
      'fr': 'Apprends et récite la table de 2',
      'en': 'Learn and recite the times table of 2',
      'es': 'Aprende y recita la tabla del 2',
      'ar': 'تعلّم واحفظ جدول الضرب في 2',
    },
    mnemonicTitle: {
      'fr': 'Ce sont les doubles !',
      'en': 'These are the doubles!',
      'es': '¡Son los dobles!',
      'ar': 'إنها الأضعاف!',
    },
    mnemonicBody: {
      'fr':
          'Multiplier par 2, c\'est additionner le nombre à lui-même : '
          '2 × 6, c\'est 6 + 6 = 12. Tu connais déjà tous les doubles !',
      'en':
          'Multiplying by 2 means adding the number to itself: 2 × 6 is '
          '6 + 6 = 12. You already know all your doubles!',
      'es':
          'Multiplicar por 2 es sumar el número consigo mismo: 2 × 6 es '
          '6 + 6 = 12. ¡Ya conoces todos los dobles!',
      'ar':
          'الضرب في 2 يعني جمع العدد مع نفسه: 2 × 6 يساوي 6 + 6 = 12. أنت '
          'تعرف كل الأضعاف بالفعل!',
    },
    tableNumber: 2,
    generateProblems: _generateTable2,
  ),
  CalculTopic(
    id: 'ce1-table-3',
    niveau: 'CE1',
    title: {
      'fr': 'Table de 3',
      'en': 'Times table of 3',
      'es': 'Tabla del 3',
      'ar': 'جدول الضرب في 3',
    },
    subtitle: {
      'fr': 'Apprends et récite la table de 3',
      'en': 'Learn and recite the times table of 3',
      'es': 'Aprende y recita la tabla del 3',
      'ar': 'تعلّم واحفظ جدول الضرب في 3',
    },
    mnemonicTitle: {
      'fr': 'Le double, plus une fois de plus !',
      'en': 'The double, plus one more time!',
      'es': '¡El doble, más una vez más!',
      'ar': 'الضعف، زائد مرة أخرى!',
    },
    mnemonicBody: {
      'fr':
          '3 × n, c\'est le double de n, plus n encore une fois : '
          '3 × 4 = (2 × 4) + 4 = 8 + 4 = 12.',
      'en':
          '3 × n is the double of n, plus n one more time: '
          '3 × 4 = (2 × 4) + 4 = 8 + 4 = 12.',
      'es':
          '3 × n es el doble de n, más n una vez más: '
          '3 × 4 = (2 × 4) + 4 = 8 + 4 = 12.',
      'ar':
          '3 × ن هو ضعف ن، زائد ن مرة أخرى: 3 × 4 = (2 × 4) + 4 = 8 + 4 = '
          '12.',
    },
    tableNumber: 3,
    generateProblems: _generateTable3,
  ),
  CalculTopic(
    id: 'ce1-table-4',
    niveau: 'CE1',
    title: {
      'fr': 'Table de 4',
      'en': 'Times table of 4',
      'es': 'Tabla del 4',
      'ar': 'جدول الضرب في 4',
    },
    subtitle: {
      'fr': 'Apprends et récite la table de 4',
      'en': 'Learn and recite the times table of 4',
      'es': 'Aprende y recita la tabla del 4',
      'ar': 'تعلّم واحفظ جدول الضرب في 4',
    },
    mnemonicTitle: {
      'fr': 'Le double du double !',
      'en': 'The double of the double!',
      'es': '¡El doble del doble!',
      'ar': 'ضعف الضعف!',
    },
    mnemonicBody: {
      'fr':
          'Multiplier par 4, c\'est doubler deux fois de suite : pour '
          '4 × 3, double de 3 = 6, puis double de 6 = 12.',
      'en':
          'Multiplying by 4 means doubling twice in a row: for 4 × 3, '
          'double 3 = 6, then double 6 = 12.',
      'es':
          'Multiplicar por 4 es duplicar dos veces seguidas: para 4 × 3, '
          'el doble de 3 = 6, y luego el doble de 6 = 12.',
      'ar':
          'الضرب في 4 يعني مضاعفة العدد مرتين متتاليتين: لحساب 4 × 3، ضعف '
          '3 يساوي 6، ثم ضعف 6 يساوي 12.',
    },
    tableNumber: 4,
    generateProblems: _generateTable4,
  ),
  CalculTopic(
    id: 'ce1-table-5',
    niveau: 'CE1',
    title: {
      'fr': 'Table de 5',
      'en': 'Times table of 5',
      'es': 'Tabla del 5',
      'ar': 'جدول الضرب في 5',
    },
    subtitle: {
      'fr': 'Apprends et récite la table de 5',
      'en': 'Learn and recite the times table of 5',
      'es': 'Aprende y recita la tabla del 5',
      'ar': 'تعلّم واحفظ جدول الضرب في 5',
    },
    mnemonicTitle: {
      'fr': 'Compte par bonds de 5, comme les doigts d\'une main !',
      'en': 'Count in hops of 5, like the fingers on a hand!',
      'es': '¡Cuenta de 5 en 5, como los dedos de una mano!',
      'ar': 'عُدّ بالقفز 5، 5، مثل أصابع اليد!',
    },
    mnemonicBody: {
      'fr':
          '5, 10, 15, 20... Chaque main a 5 doigts : 5 × 3, c\'est 3 mains '
          'de 5 doigts, donc 15. Le résultat finit toujours par 0 ou par 5.',
      'en':
          '5, 10, 15, 20... Each hand has 5 fingers: 5 × 3 is 3 hands of 5 '
          'fingers, so 15. The result always ends in 0 or 5.',
      'es':
          '5, 10, 15, 20... Cada mano tiene 5 dedos: 5 × 3 son 3 manos de '
          '5 dedos, o sea 15. El resultado siempre termina en 0 o en 5.',
      'ar':
          '5، 10، 15، 20... كل يد بها 5 أصابع: 5 × 3 يعني 3 أيدٍ من 5 '
          'أصابع، أي 15. تنتهي النتيجة دائمًا بـ 0 أو 5.',
    },
    tableNumber: 5,
    generateProblems: _generateTable5,
  ),
  CalculTopic(
    id: 'ce1-table-6',
    niveau: 'CE1',
    title: {
      'fr': 'Table de 6',
      'en': 'Times table of 6',
      'es': 'Tabla del 6',
      'ar': 'جدول الضرب في 6',
    },
    subtitle: {
      'fr': 'Apprends et récite la table de 6',
      'en': 'Learn and recite the times table of 6',
      'es': 'Aprende y recita la tabla del 6',
      'ar': 'تعلّم واحفظ جدول الضرب في 6',
    },
    mnemonicTitle: {
      'fr': 'Le double de la table de 3 !',
      'en': 'Double the table of 3!',
      'es': '¡El doble de la tabla del 3!',
      'ar': 'ضعف جدول الضرب في 3!',
    },
    mnemonicBody: {
      'fr':
          '6 × n, c\'est le double de 3 × n : pour 6 × 4, calcule d\'abord '
          '3 × 4 = 12, puis double = 24.',
      'en':
          '6 × n is double of 3 × n: for 6 × 4, first work out 3 × 4 = 12, '
          'then double it = 24.',
      'es':
          '6 × n es el doble de 3 × n: para 6 × 4, calcula primero '
          '3 × 4 = 12, y luego duplica = 24.',
      'ar':
          '6 × ن هو ضعف 3 × ن: لحساب 6 × 4، احسب أولًا 3 × 4 = 12، ثم '
          'ضاعفه = 24.',
    },
    tableNumber: 6,
    generateProblems: _generateTable6,
  ),
  CalculTopic(
    id: 'ce1-table-7',
    niveau: 'CE1',
    title: {
      'fr': 'Table de 7',
      'en': 'Times table of 7',
      'es': 'Tabla del 7',
      'ar': 'جدول الضرب في 7',
    },
    subtitle: {
      'fr': 'Apprends et récite la table de 7',
      'en': 'Learn and recite the times table of 7',
      'es': 'Aprende y recita la tabla del 7',
      'ar': 'تعلّم واحفظ جدول الضرب في 7',
    },
    mnemonicTitle: {
      'fr':
          'Pas d\'astuce magique : on la récite comme une comptine !',
      'en': 'No magic trick here: recite it like a song!',
      'es': '¡Sin truco mágico: recítala como una canción!',
      'ar': 'لا حيلة سحرية: احفظه كأنه أغنية!',
    },
    mnemonicBody: {
      'fr':
          'La table de 7 est la plus difficile à retenir. Récite-la à voix '
          'haute plusieurs fois, dans l\'ordre, comme une chanson : 7, 14, '
          '21, 28... jusqu\'à la connaître par cœur.',
      'en':
          'The table of 7 is the hardest to remember. Say it out loud '
          'several times, in order, like a song: 7, 14, 21, 28... until '
          'you know it by heart.',
      'es':
          'La tabla del 7 es la más difícil de recordar. Recítala en voz '
          'alta varias veces, en orden, como una canción: 7, 14, 21, 28... '
          'hasta sabértela de memoria.',
      'ar':
          'جدول الضرب في 7 هو الأصعب حفظًا. رَدّده بصوت مرتفع عدة مرات، '
          'بالترتيب، كأنه أغنية: 7، 14، 21، 28... حتى تحفظه عن ظهر قلب.',
    },
    tableNumber: 7,
    generateProblems: _generateTable7,
  ),
  CalculTopic(
    id: 'ce1-table-8',
    niveau: 'CE1',
    title: {
      'fr': 'Table de 8',
      'en': 'Times table of 8',
      'es': 'Tabla del 8',
      'ar': 'جدول الضرب في 8',
    },
    subtitle: {
      'fr': 'Apprends et récite la table de 8',
      'en': 'Learn and recite the times table of 8',
      'es': 'Aprende y recita la tabla del 8',
      'ar': 'تعلّم واحفظ جدول الضرب في 8',
    },
    mnemonicTitle: {
      'fr': 'Le double du double du double !',
      'en': 'The double of the double of the double!',
      'es': '¡El doble del doble del doble!',
      'ar': 'ضعف ضعف الضعف!',
    },
    mnemonicBody: {
      'fr':
          'Multiplier par 8, c\'est doubler trois fois de suite : pour '
          '8 × 3, double de 3 = 6, double de 6 = 12, double de 12 = 24.',
      'en':
          'Multiplying by 8 means doubling three times in a row: for '
          '8 × 3, double 3 = 6, double 6 = 12, double 12 = 24.',
      'es':
          'Multiplicar por 8 es duplicar tres veces seguidas: para 8 × 3, '
          'el doble de 3 = 6, el doble de 6 = 12, el doble de 12 = 24.',
      'ar':
          'الضرب في 8 يعني مضاعفة العدد ثلاث مرات متتالية: لحساب 8 × 3، '
          'ضعف 3 يساوي 6، وضعف 6 يساوي 12، وضعف 12 يساوي 24.',
    },
    tableNumber: 8,
    generateProblems: _generateTable8,
  ),
  CalculTopic(
    id: 'ce1-table-9',
    niveau: 'CE1',
    title: {
      'fr': 'Table de 9',
      'en': 'Times table of 9',
      'es': 'Tabla del 9',
      'ar': 'جدول الضرب في 9',
    },
    subtitle: {
      'fr': 'Apprends et récite la table de 9',
      'en': 'Learn and recite the times table of 9',
      'es': 'Aprende y recita la tabla del 9',
      'ar': 'تعلّم واحفظ جدول الضرب في 9',
    },
    mnemonicTitle: {
      'fr': 'L\'astuce des 10 doigts !',
      'en': 'The 10-finger trick!',
      'es': '¡El truco de los 10 dedos!',
      'ar': 'خدعة الأصابع العشرة!',
    },
    mnemonicBody: {
      'fr':
          'Lève tes 10 doigts. Pour 9 × n, replie le n-ième doigt : les '
          'doigts avant comptent les dizaines, ceux d\'après les unités. '
          'Pour 9 × 4 : replie le 4e doigt → 3 doigts avant (30) et 6 '
          'doigts après (6) → 36 !',
      'en':
          'Hold up your 10 fingers. For 9 × n, fold down the n-th finger: '
          'the fingers before it count the tens, the ones after count the '
          'units. For 9 × 4: fold down the 4th finger → 3 fingers before '
          '(30) and 6 fingers after (6) → 36!',
      'es':
          'Levanta tus 10 dedos. Para 9 × n, dobla el dedo número n: los '
          'dedos de antes cuentan las decenas, los de después las '
          'unidades. Para 9 × 4: dobla el 4.º dedo → 3 dedos antes (30) y '
          '6 dedos después (6) → ¡36!',
      'ar':
          'ارفع أصابعك العشرة. لحساب 9 × ن، اطوِ الإصبع رقم ن: الأصابع '
          'التي قبله تمثّل العشرات، والتي بعده تمثّل الآحاد. لحساب 9 × 4: '
          'اطوِ الإصبع الرابع ← 3 أصابع قبله (30) و6 أصابع بعده (6) ← 36!',
    },
    tableNumber: 9,
    generateProblems: _generateTable9,
  ),
  CalculTopic(
    id: 'ce1-table-10',
    niveau: 'CE1',
    title: {
      'fr': 'Table de 10',
      'en': 'Times table of 10',
      'es': 'Tabla del 10',
      'ar': 'جدول الضرب في 10',
    },
    subtitle: {
      'fr': 'Apprends et récite la table de 10',
      'en': 'Learn and recite the times table of 10',
      'es': 'Aprende y recita la tabla del 10',
      'ar': 'تعلّم واحفظ جدول الضرب في 10',
    },
    mnemonicTitle: {
      'fr': 'On ajoute juste un zéro !',
      'en': 'Just add a zero!',
      'es': '¡Solo añadimos un cero!',
      'ar': 'فقط أضف صفرًا!',
    },
    mnemonicBody: {
      'fr':
          'Multiplier par 10, c\'est décaler chaque chiffre d\'un rang : '
          '10 × 7 = 70. Il suffit d\'écrire un 0 après le nombre.',
      'en':
          'Multiplying by 10 shifts every digit one place over: '
          '10 × 7 = 70. Just write a 0 after the number.',
      'es':
          'Multiplicar por 10 desplaza cada cifra un lugar: 10 × 7 = 70. '
          'Basta con escribir un 0 después del número.',
      'ar':
          'الضرب في 10 يعني إزاحة كل رقم مرتبة واحدة: 10 × 7 = 70. يكفي '
          'أن تكتب 0 بعد العدد.',
    },
    tableNumber: 10,
    generateProblems: _generateTable10,
  ),
  CalculTopic(
    id: 'ce2-multiplication-posee',
    niveau: 'CE2',
    title: {
      'fr': 'La multiplication posée',
      'en': 'Column multiplication',
      'es': 'La multiplicación en columna',
      'ar': 'الضرب بالعمود',
    },
    subtitle: {
      'fr': 'Multiplier un nombre à plusieurs chiffres par un chiffre',
      'en': 'Multiply a multi-digit number by a single digit',
      'es': 'Multiplicar un número de varias cifras por una cifra',
      'ar': 'ضرب عدد من عدة أرقام في رقم واحد',
    },
    mnemonicTitle: {
      'fr': 'La pluie de chiffres !',
      'en': 'A rain of digits!',
      'es': '¡La lluvia de cifras!',
      'ar': 'مطر الأرقام!',
    },
    mnemonicBody: {
      'fr':
          'On multiplie chaque chiffre en partant de la droite, comme une '
          'pluie qui tombe colonne par colonne, et on n\'oublie jamais les '
          'retenues au passage — elles suivent le même chemin que dans une '
          'addition posée.',
      'en':
          'We multiply each digit starting from the right, like rain '
          'falling column by column, and we never forget the carries '
          'along the way — they travel the same path as in column '
          'addition.',
      'es':
          'Multiplicamos cada cifra empezando por la derecha, como una '
          'lluvia que cae columna por columna, y nunca olvidamos las '
          'llevadas por el camino: siguen el mismo recorrido que en una '
          'suma en columna.',
      'ar':
          'نضرب كل رقم بدءًا من اليمين، كأنه مطر يتساقط عمودًا بعد عمود، '
          'ولا ننسى أبدًا العشرات المحمولة في الطريق — فهي تسلك نفس مسار '
          'الجمع بالعمود.',
    },
    posedOperation: 'multiplication',
    generateProblems: _generateMultiplicationPoseeCe2,
  ),
  CalculTopic(
    id: 'ce2-division',
    niveau: 'CE2',
    title: {
      'fr': 'La division',
      'en': 'Division',
      'es': 'La división',
      'ar': 'القسمة',
    },
    subtitle: {
      'fr': 'Le partage égal et le calcul du reste',
      'en': 'Sharing equally and working out the remainder',
      'es': 'El reparto equitativo y el cálculo del resto',
      'ar': 'التوزيع بالتساوي وحساب الباقي',
    },
    mnemonicTitle: {
      'fr': 'Le partage entre copains !',
      'en': 'Sharing with friends!',
      'es': '¡El reparto entre amigos!',
      'ar': 'التوزيع بين الأصدقاء!',
    },
    mnemonicBody: {
      'fr':
          'Diviser, c\'est partager équitablement entre plusieurs copains. '
          'Parfois, ça tombe juste ! Parfois, il reste quelques objets '
          'qu\'on ne peut plus partager en entier — c\'est le reste, '
          'toujours plus petit que le nombre de copains.',
      'en':
          'Dividing means sharing equally among several friends. '
          'Sometimes it comes out exactly! Sometimes a few things are '
          'left over that can\'t be shared whole — that\'s the remainder, '
          'always smaller than the number of friends.',
      'es':
          'Dividir es repartir de manera equitativa entre varios amigos. '
          '¡A veces sale justo! A veces quedan algunas cosas que ya no se '
          'pueden repartir enteras: es el resto, siempre más pequeño que '
          'el número de amigos.',
      'ar':
          'القسمة تعني التوزيع بالتساوي بين عدة أصدقاء. أحيانًا يكون '
          'التوزيع تامًا! وأحيانًا يتبقى القليل مما لا يمكن توزيعه '
          'كاملًا — وهذا هو الباقي، وهو دائمًا أصغر من عدد الأصدقاء.',
    },
    generateProblems: _generateDivisionCe2,
  ),
  CalculTopic(
    id: 'ce2-grands-nombres',
    niveau: 'CE2',
    title: {
      'fr': 'Les grands nombres',
      'en': 'Big numbers',
      'es': 'Los números grandes',
      'ar': 'الأعداد الكبيرة',
    },
    subtitle: {
      'fr': "Calculer avec des nombres jusqu'à 10 000",
      'en': 'Calculate with numbers up to 10,000',
      'es': 'Calcular con números hasta 10.000',
      'ar': 'الحساب بأعداد تصل إلى 10000',
    },
    mnemonicTitle: {
      'fr': 'La maison des nombres !',
      'en': 'The house of numbers!',
      'es': '¡La casa de los números!',
      'ar': 'بيت الأعداد!',
    },
    mnemonicBody: {
      'fr':
          'Chaque nombre habite une maison à plusieurs étages : les '
          'unités au rez-de-chaussée, puis les dizaines, les centaines et '
          'les milliers. Pour additionner ou soustraire de grands '
          'nombres, on garde chaque étage bien à sa place.',
      'en':
          'Every number lives in a house with several floors: the units '
          'on the ground floor, then the tens, the hundreds and the '
          'thousands. To add or subtract big numbers, keep each floor in '
          'its own place.',
      'es':
          'Cada número vive en una casa de varios pisos: las unidades en '
          'la planta baja, luego las decenas, las centenas y los '
          'millares. Para sumar o restar números grandes, mantenemos '
          'cada piso en su lugar.',
      'ar':
          'كل عدد يسكن في بيت من عدة طوابق: الآحاد في الطابق الأرضي، ثم '
          'العشرات، فالمئات، فالآلاف. لجمع أو طرح الأعداد الكبيرة، نُبقي '
          'كل طابق في مكانه.',
    },
    generateProblems: _generateGrandsNombresCe2,
  ),
  CalculTopic(
    id: 'cm1-division-posee',
    niveau: 'CM1',
    title: {
      'fr': 'La division posée',
      'en': 'Long division',
      'es': 'La división en columna',
      'ar': 'القسمة المطولة',
    },
    subtitle: {
      'fr': 'Diviser par un nombre à un ou deux chiffres',
      'en': 'Divide by a one- or two-digit number',
      'es': 'Dividir entre un número de una o dos cifras',
      'ar': 'القسمة على عدد من رقم أو رقمين',
    },
    mnemonicTitle: {
      'fr': 'Le grand partage, étage par étage !',
      'en': 'The big share-out, floor by floor!',
      'es': '¡El gran reparto, piso por piso!',
      'ar': 'التوزيع الكبير، طابقًا بعد طابق!',
    },
    mnemonicBody: {
      'fr':
          'On partage la maison des nombres étage par étage, en '
          'commençant par le plus grand : à chaque étape, ce qui ne peut '
          'pas être partagé "descend" rejoindre le chiffre suivant, comme '
          'un petit reste qui continue le voyage.',
      'en':
          'We share the house of numbers floor by floor, starting with '
          'the biggest: at each step, whatever can\'t be shared "comes '
          'down" to join the next digit, like a small remainder '
          'continuing its journey.',
      'es':
          'Repartimos la casa de los números piso por piso, empezando '
          'por el más grande: en cada paso, lo que no se puede repartir '
          '"baja" para unirse a la siguiente cifra, como un pequeño resto '
          'que sigue su viaje.',
      'ar':
          'نوزّع بيت الأعداد طابقًا بعد طابق، بدءًا من الأكبر: في كل '
          'خطوة، ما لا يمكن توزيعه "ينزل" لينضم إلى الرقم التالي، كأنه '
          'باقٍ صغير يواصل رحلته.',
    },
    posedOperation: 'division',
    generateProblems: _generateDivisionPoseeCm1,
  ),
  CalculTopic(
    id: 'cm1-fractions',
    niveau: 'CM1',
    title: {
      'fr': 'Les fractions',
      'en': 'Fractions',
      'es': 'Las fracciones',
      'ar': 'الكسور',
    },
    subtitle: {
      'fr': 'Additionner des fractions de même dénominateur',
      'en': 'Add fractions with the same denominator',
      'es': 'Sumar fracciones con el mismo denominador',
      'ar': 'جمع الكسور ذات المقام نفسه',
    },
    mnemonicTitle: {
      'fr': 'La pizza en parts égales !',
      'en': 'Pizza cut into equal slices!',
      'es': '¡La pizza en partes iguales!',
      'ar': 'بيتزا مقسّمة إلى أجزاء متساوية!',
    },
    mnemonicBody: {
      'fr':
          'Une fraction, ce sont des parts égales d\'une même pizza. '
          'Quand le nombre du bas (le dénominateur) est le même, il ne '
          'bouge jamais : on additionne juste les parts qu\'on a déjà, le '
          'nombre du haut (le numérateur).',
      'en':
          'A fraction is equal slices of the same pizza. When the bottom '
          'number (the denominator) is the same, it never moves: we just '
          'add up the slices we already have, the top number (the '
          'numerator).',
      'es':
          'Una fracción son partes iguales de una misma pizza. Cuando el '
          'número de abajo (el denominador) es el mismo, nunca cambia: '
          'solo sumamos las partes que ya tenemos, el número de arriba '
          '(el numerador).',
      'ar':
          'الكسر هو أجزاء متساوية من نفس البيتزا. عندما يكون الرقم '
          'السفلي (المقام) هو نفسه، فإنه لا يتغيّر أبدًا: نجمع فقط '
          'الأجزاء التي لدينا، أي الرقم العلوي (البسط).',
    },
    generateProblems: _generateFractionsCm1,
  ),
  CalculTopic(
    id: 'cm1-decimaux',
    niveau: 'CM1',
    title: {
      'fr': 'Les nombres décimaux',
      'en': 'Decimal numbers',
      'es': 'Los números decimales',
      'ar': 'الأعداد العشرية',
    },
    subtitle: {
      'fr': 'Additionner et soustraire des nombres à virgule',
      'en': 'Add and subtract numbers with a decimal point',
      'es': 'Sumar y restar números con coma decimal',
      'ar': 'جمع وطرح الأعداد ذات الفاصلة العشرية',
    },
    mnemonicTitle: {
      'fr': 'La virgule, comme un portefeuille !',
      'en': 'The decimal point, like a wallet!',
      'es': '¡La coma, como una cartera!',
      'ar': 'الفاصلة العشرية، مثل محفظة النقود!',
    },
    mnemonicBody: {
      'fr':
          'Imagine ton portefeuille : les euros entiers d\'un côté, les '
          'pièces de l\'autre. La virgule sépare toujours ces deux poches '
          '— on additionne ou on soustrait chaque poche avec celle d\'en '
          'face, jamais les deux mélangées.',
      'en':
          'Picture your wallet: whole dollars on one side, coins on the '
          'other. The decimal point always separates these two pockets — '
          'we add or subtract each pocket with its match, never mixing '
          'the two.',
      'es':
          'Imagina tu cartera: los euros enteros de un lado, las monedas '
          'del otro. La coma siempre separa estos dos bolsillos: sumamos '
          'o restamos cada bolsillo con el de enfrente, nunca mezclando '
          'los dos.',
      'ar':
          'تخيّل محفظتك: الأوراق النقدية الكاملة في جهة، والقطع المعدنية '
          'في الأخرى. الفاصلة العشرية تفصل دائمًا بين هذين الجيبين — '
          'نجمع أو نطرح كل جيب مع نظيره، دون أن نخلط بينهما أبدًا.',
    },
    generateProblems: _generateDecimauxCm1,
  ),
  CalculTopic(
    id: 'cm2-multiplication-decimale',
    niveau: 'CM2',
    title: {
      'fr': 'La multiplication décimale',
      'en': 'Decimal multiplication',
      'es': 'La multiplicación decimal',
      'ar': 'الضرب في الأعداد العشرية',
    },
    subtitle: {
      'fr': 'Multiplier des nombres à virgule',
      'en': 'Multiply numbers with a decimal point',
      'es': 'Multiplicar números con coma decimal',
      'ar': 'ضرب أعداد ذات فاصلة عشرية',
    },
    mnemonicTitle: {
      'fr': 'Compte les chiffres après la virgule !',
      'en': 'Count the digits after the point!',
      'es': '¡Cuenta las cifras después de la coma!',
      'ar': 'عُدّ الأرقام بعد الفاصلة!',
    },
    mnemonicBody: {
      'fr':
          'Calcule d\'abord comme si les virgules n\'existaient pas, puis '
          'recompte : ton résultat doit avoir le même nombre de chiffres '
          'après la virgule que dans les nombres de départ, réunis.',
      'en':
          'First calculate as if the decimal points didn\'t exist, then '
          'count again: your result must have the same total number of '
          'digits after the point as the starting numbers combined.',
      'es':
          'Primero calcula como si las comas no existieran, y luego '
          'vuelve a contar: tu resultado debe tener el mismo número de '
          'cifras después de la coma que los números de partida juntos.',
      'ar':
          'احسب أولًا وكأن الفواصل العشرية غير موجودة، ثم أعد العدّ: يجب '
          'أن تحتوي نتيجتك على نفس عدد الأرقام بعد الفاصلة الموجودة في '
          'العددين الأصليين مجتمعين.',
    },
    generateProblems: _generateMultiplicationDecimaleCm2,
  ),
  CalculTopic(
    id: 'cm2-division-decimale',
    niveau: 'CM2',
    title: {
      'fr': 'La division décimale',
      'en': 'Decimal division',
      'es': 'La división decimal',
      'ar': 'القسمة على أعداد عشرية',
    },
    subtitle: {
      'fr': 'Diviser avec des nombres à virgule',
      'en': 'Divide with numbers that have a decimal point',
      'es': 'Dividir con números con coma decimal',
      'ar': 'القسمة بأعداد ذات فاصلة عشرية',
    },
    mnemonicTitle: {
      'fr': 'On continue après la virgule !',
      'en': 'We keep going after the point!',
      'es': '¡Seguimos después de la coma!',
      'ar': 'نُكمل بعد الفاصلة!',
    },
    mnemonicBody: {
      'fr':
          'La division décimale se pose exactement comme une division '
          'normale — on descend juste la virgule dans le résultat au bon '
          'moment, et on continue de partager après elle.',
      'en':
          'Decimal division is set up exactly like a regular division — '
          'we just bring the decimal point down into the result at the '
          'right moment, and keep sharing after it.',
      'es':
          'La división decimal se plantea exactamente como una división '
          'normal: solo bajamos la coma al resultado en el momento '
          'adecuado, y seguimos repartiendo después de ella.',
      'ar':
          'القسمة العشرية تُنجز تمامًا مثل القسمة العادية — ننزل فقط '
          'بالفاصلة العشرية إلى النتيجة في اللحظة المناسبة، ونواصل '
          'التوزيع بعدها.',
    },
    generateProblems: _generateDivisionDecimaleCm2,
  ),
  CalculTopic(
    id: 'cm2-proportionnalite',
    niveau: 'CM2',
    title: {
      'fr': 'La proportionnalité',
      'en': 'Proportionality',
      'es': 'La proporcionalidad',
      'ar': 'التناسب',
    },
    subtitle: {
      'fr': 'Pourcentages, échelles et règle de trois',
      'en': 'Percentages, scales and cross-multiplication',
      'es': 'Porcentajes, escalas y regla de tres',
      'ar': 'النسب المئوية والمقاييس وقاعدة الضرب التبادلي',
    },
    mnemonicTitle: {
      'fr': 'La grille de 100 cases !',
      'en': 'The 100-square grid!',
      'es': '¡La cuadrícula de 100 casillas!',
      'ar': 'شبكة الـ100 مربع!',
    },
    mnemonicBody: {
      'fr':
          'Imagine un pourcentage comme une grille de 100 cases : '
          '"10 %", c\'est colorier 10 cases sur 100. Pour la règle de '
          'trois, les flèches se croisent en X entre ce que tu connais et '
          'ce que tu cherches : "produit en croix" !',
      'en':
          'Picture a percentage as a grid of 100 squares: "10%" means '
          'coloring in 10 squares out of 100. For cross-multiplication, '
          'the arrows cross in an X between what you know and what '
          'you\'re looking for — "cross products"!',
      'es':
          'Imagina un porcentaje como una cuadrícula de 100 casillas: '
          '"10 %" es colorear 10 casillas de 100. Para la regla de tres, '
          'las flechas se cruzan en X entre lo que conoces y lo que '
          'buscas: ¡"producto cruzado"!',
      'ar':
          'تخيّل النسبة المئوية كشبكة من 100 مربع: "10%" يعني تلوين 10 '
          'مربعات من أصل 100. أما قاعدة الضرب التبادلي، فتتقاطع فيها '
          'الأسهم على شكل X بين ما تعرفه وما تبحث عنه: "الضرب التبادلي"!',
    },
    generateProblems: _generateProportionnaliteCm2,
  ),
  CalculTopic(
    id: 'cm2-fractions-denominateurs-differents',
    niveau: 'CM2',
    title: {
      'fr': 'Fractions à dénominateurs différents',
      'en': 'Fractions with different denominators',
      'es': 'Fracciones con denominadores diferentes',
      'ar': 'كسور بمقامات مختلفة',
    },
    subtitle: {
      'fr': 'Mettre au même dénominateur avant d\'additionner',
      'en': 'Find a common denominator before adding',
      'es': 'Poner el mismo denominador antes de sumar',
      'ar': 'توحيد المقام قبل الجمع',
    },
    mnemonicTitle: {
      'fr': 'On coupe les pizzas en plus petites parts !',
      'en': 'We cut the pizzas into smaller slices!',
      'es': '¡Cortamos las pizzas en trozos más pequeños!',
      'ar': 'نقطّع البيتزا إلى أجزاء أصغر!',
    },
    mnemonicBody: {
      'fr':
          'Deux pizzas coupées différemment ne se comparent pas '
          'directement. On recoupe chaque pizza pour qu\'elles aient le '
          'même nombre de parts (on multiplie chaque fraction par le '
          'dénominateur de l\'autre), et seulement après, on additionne '
          'les parts.',
      'en':
          'Two pizzas cut differently can\'t be compared directly. We '
          'recut each pizza so they have the same number of slices (we '
          'multiply each fraction by the other\'s denominator), and only '
          'then do we add the slices.',
      'es':
          'Dos pizzas cortadas de forma distinta no se pueden comparar '
          'directamente. Volvemos a cortar cada pizza para que tengan el '
          'mismo número de trozos (multiplicamos cada fracción por el '
          'denominador de la otra), y solo entonces sumamos los trozos.',
      'ar':
          'بيتزاتان مقطّعتان بشكل مختلف لا يمكن مقارنتهما مباشرة. نعيد '
          'تقطيع كل بيتزا ليصبح لهما نفس عدد الأجزاء (نضرب كل كسر في '
          'مقام الكسر الآخر)، وبعد ذلك فقط نجمع الأجزاء.',
    },
    posedOperation: 'fraction',
    generateProblems: _generateFractionsDenomDiffCm2,
  ),
];

/// Numéro générique affiché pour un niveau interne ('CP'/'CE1'/'CE2'/'CM1'/
/// 'CM2') -- 1 à 5, plutôt que la nomenclature scolaire française
/// elle-même, pour rester compréhensible dans les 4 langues de l'app. Les
/// identifiants internes ne changent pas (utilisés pour le regroupement/tri
/// ailleurs, ex. `parcours_screen.dart`). Ne contient QUE le chiffre : le
/// mot "Niveau"/"Level"/"Nivel"/"المستوى" vient séparément de la clé i18n
/// `levelLabel`, combinée à l'appel (ex. `'${levelLabel}: '
/// '${calculNiveauLabel(...)}'`) -- ne pas dupliquer le mot ici.
const Map<String, String> _NIVEAU_NUMBERS = {
  'CP': '1',
  'CE1': '2',
  'CE2': '3',
  'CM1': '4',
  'CM2': '5',
};

String calculNiveauLabel(String niveau, String lang) =>
    _NIVEAU_NUMBERS[niveau] ?? niveau;

CalculTopic? findCalculTopic(String id) {
  for (final topic in CALCUL_TOPICS) {
    if (topic.id == id) return topic;
  }
  return null;
}

// ─── Mini-jeux bonus (5 niveaux chacun) ────────────────────────────────
//
// "Vrai ou Faux ?" et "Compose le nombre !" — intercalés dans le zigzag du
// Palier "Les Calculs" au même titre que les mots mêlés du Palier "Les
// Mots" : purement ludiques, sans points ni progression (voir
// parcours_screen.dart, aucun de ces écrans n'appelle awardCompletion).

/// Un "Vrai ou Faux ?" : l'énoncé est-il juste ?
class TrueFalseEquation {
  final String display;
  final bool isTrue;

  /// Le même calcul avec le résultat réellement exact substitué à
  /// [display] -- identique à [display] quand [isTrue] est vrai, sert
  /// d'explication affichée dans le pop-up de correction sinon.
  final String correctDisplay;

  const TrueFalseEquation({
    required this.display,
    required this.isTrue,
    required this.correctDisplay,
  });
}

class VraiFauxLevel {
  final String niveau;
  final Map<String, String> title;
  final List<TrueFalseEquation> Function(int seed, int count) generateItems;

  const VraiFauxLevel({
    required this.niveau,
    required this.title,
    required this.generateItems,
  });
}

/// Un résultat "proche mais faux" — jamais absurde, pour rester un vrai
/// exercice de vigilance plutôt qu'un choix évident.
int _nearMiss(Random rand, int correct, {int min = 0}) {
  var wrong = correct;
  while (wrong == correct || wrong < min) {
    final offset = 1 + rand.nextInt(3);
    wrong = correct + (rand.nextBool() ? offset : -offset);
  }
  return wrong;
}

/// Quatre réponses plausibles pour un exercice en QCM -- la bonne réponse
/// mélangée à des distracteurs proches (voir [_nearMiss]) -- utilisées à la
/// place du traçage de chiffres (voir [CalculProblem.choices]). Aucun signe
/// ni trace n'est jamais demandé au Palier "Les Calculs" : l'enfant choisit
/// parmi des propositions plutôt que d'écrire la réponse.
List<String> _mcqChoices(Random rand, int correct, {int min = 0}) {
  final values = <int>{correct};
  while (values.length < 4) {
    values.add(_nearMiss(rand, correct, min: min));
  }
  final list = values.toList()..shuffle(rand);
  return list.map((n) => '$n').toList();
}

/// Variante de [_mcqChoices] pour une réponse composée (ex. "4 R 2", "12,5",
/// "7/12") -- seule la première partie ([correctFirst]) varie parmi les
/// distracteurs, la seconde ([fixedSecondPart]) restant identique, jointe
/// avec [separator] exactement comme à l'affichage (voir
/// [CalculProblem.secondPartSeparator]).
List<String> _mcqChoicesCombined(
  Random rand,
  int correctFirst,
  String fixedSecondPart,
  String separator, {
  int min = 0,
}) {
  return _mcqChoices(rand, correctFirst, min: min)
      .map((first) => '$first$separator$fixedSecondPart')
      .toList();
}

List<TrueFalseEquation> _generateVraiFauxCp(int seed, int count) {
  final rand = Random(seed);
  return List.generate(count, (i) {
    final isAddition = rand.nextBool();
    final a = 1 + rand.nextInt(10);
    final b = 1 + rand.nextInt(isAddition ? 10 : a);
    final correct = isAddition ? a + b : a - b;
    final shown = rand.nextBool() ? correct : _nearMiss(rand, correct);
    return TrueFalseEquation(
      display: '$a ${isAddition ? '+' : '-'} $b = $shown',
      isTrue: shown == correct,
      correctDisplay: '$a ${isAddition ? '+' : '-'} $b = $correct',
    );
  });
}

List<TrueFalseEquation> _generateVraiFauxCe1(int seed, int count) {
  final rand = Random(seed);
  return List.generate(count, (i) {
    final op = rand.nextInt(3);
    late int a, b, correct;
    late String sign;
    if (op == 0) {
      a = 10 + rand.nextInt(80);
      b = 1 + rand.nextInt(20);
      correct = a + b;
      sign = '+';
    } else if (op == 1) {
      a = 20 + rand.nextInt(70);
      b = 1 + rand.nextInt(a - 10);
      correct = a - b;
      sign = '-';
    } else {
      a = 1 + rand.nextInt(9);
      b = 1 + rand.nextInt(10);
      correct = a * b;
      sign = '×';
    }
    final shown = rand.nextBool() ? correct : _nearMiss(rand, correct);
    return TrueFalseEquation(
      display: '$a $sign $b = $shown',
      isTrue: shown == correct,
      correctDisplay: '$a $sign $b = $correct',
    );
  });
}

List<TrueFalseEquation> _generateVraiFauxCe2(int seed, int count) {
  final rand = Random(seed);
  return List.generate(count, (i) {
    final op = rand.nextInt(4);
    late int a, b, correct;
    late String sign;
    switch (op) {
      case 0:
        a = 100 + rand.nextInt(4000);
        b = 100 + rand.nextInt(4000);
        correct = a + b;
        sign = '+';
        break;
      case 1:
        a = 1000 + rand.nextInt(8000);
        b = 100 + rand.nextInt(a - 100);
        correct = a - b;
        sign = '-';
        break;
      case 2:
        a = 10 + rand.nextInt(90);
        b = 2 + rand.nextInt(8);
        correct = a * b;
        sign = '×';
        break;
      default:
        b = 2 + rand.nextInt(8);
        correct = 2 + rand.nextInt(20);
        a = b * correct;
        sign = '÷';
    }
    final shown = rand.nextBool() ? correct : _nearMiss(rand, correct);
    return TrueFalseEquation(
      display: '$a $sign $b = $shown',
      isTrue: shown == correct,
      correctDisplay: '$a $sign $b = $correct',
    );
  });
}

List<TrueFalseEquation> _generateVraiFauxCm1(int seed, int count) {
  final rand = Random(seed);
  return List.generate(count, (i) {
    if (i.isEven) {
      final denom = [4, 5, 8][rand.nextInt(3)];
      final numA = 1 + rand.nextInt(denom - 1);
      final numB = 1 + rand.nextInt(denom - numA);
      final correct = numA + numB;
      final shown = rand.nextBool()
          ? correct
          : _nearMiss(rand, correct, min: 1);
      return TrueFalseEquation(
        display: '$numA/$denom + $numB/$denom = $shown/$denom',
        isTrue: shown == correct,
        correctDisplay: '$numA/$denom + $numB/$denom = $correct/$denom',
      );
    }
    final aTenths = 10 + rand.nextInt(490);
    final bTenths = 10 + rand.nextInt(490);
    final correctTenths = aTenths + bTenths;
    final showTrue = rand.nextBool();
    final shownTenths = showTrue
        ? correctTenths
        : correctTenths + (rand.nextBool() ? 10 : -10);
    return TrueFalseEquation(
      display:
          '${_formatDixiemes(aTenths)} + ${_formatDixiemes(bTenths)} = '
          '${_formatDixiemes(shownTenths)}',
      isTrue: shownTenths == correctTenths,
      correctDisplay:
          '${_formatDixiemes(aTenths)} + ${_formatDixiemes(bTenths)} = '
          '${_formatDixiemes(correctTenths)}',
    );
  });
}

List<TrueFalseEquation> _generateVraiFauxCm2(int seed, int count) {
  final rand = Random(seed);
  return List.generate(count, (i) {
    if (i.isEven) {
      final pct = [10, 20, 25, 50][rand.nextInt(4)];
      final base = (1 + rand.nextInt(20)) * (100 ~/ pct);
      final correct = base * pct ~/ 100;
      final shown = rand.nextBool() ? correct : _nearMiss(rand, correct);
      return TrueFalseEquation(
        display: '$pct % de $base = $shown',
        isTrue: shown == correct,
        correctDisplay: '$pct % de $base = $correct',
      );
    }
    final aTenths = 10 + rand.nextInt(90);
    final b = 2 + rand.nextInt(8);
    final correctTenths = aTenths * b;
    final showTrue = rand.nextBool();
    final shownTenths = showTrue
        ? correctTenths
        : correctTenths + (rand.nextBool() ? 10 : -10);
    return TrueFalseEquation(
      display:
          '${_formatDixiemes(aTenths)} × $b = ${_formatDixiemes(shownTenths)}',
      isTrue: shownTenths == correctTenths,
      correctDisplay:
          '${_formatDixiemes(aTenths)} × $b = ${_formatDixiemes(correctTenths)}',
    );
  });
}

const Map<String, String> _kVraiFauxTitle = {
  'fr': 'Vrai ou faux ?',
  'en': 'True or false?',
  'es': '¿Verdadero o falso?',
  'ar': 'صح أم خطأ؟',
};

const List<VraiFauxLevel> VRAI_FAUX_LEVELS = [
  VraiFauxLevel(
    niveau: 'CP',
    title: _kVraiFauxTitle,
    generateItems: _generateVraiFauxCp,
  ),
  VraiFauxLevel(
    niveau: 'CE1',
    title: _kVraiFauxTitle,
    generateItems: _generateVraiFauxCe1,
  ),
  VraiFauxLevel(
    niveau: 'CE2',
    title: _kVraiFauxTitle,
    generateItems: _generateVraiFauxCe2,
  ),
  VraiFauxLevel(
    niveau: 'CM1',
    title: _kVraiFauxTitle,
    generateItems: _generateVraiFauxCm1,
  ),
  VraiFauxLevel(
    niveau: 'CM2',
    title: _kVraiFauxTitle,
    generateItems: _generateVraiFauxCm2,
  ),
];

/// Un puzzle "Compose le nombre !" : associer des nombres et des signes pour
/// atteindre la cible, en calculant strictement de gauche à droite (pas de
/// priorité opératoire — reste accessible dès le CP). [numberTiles] et
/// [operatorTiles] contiennent la solution + un élément "décoy" en plus du
/// nécessaire, pour qu'il y ait un vrai choix à faire.
class NumberComposePuzzle {
  final int target;
  final List<int> numberTiles;
  final List<String> operatorTiles;
  final int slotCount;

  /// La séquence attendue (nombres et signes, dans l'ordre de gauche à
  /// droite) — sert de référence pour le code couleur façon "Wordle" de
  /// l'exercice (vert/jaune/rouge), en plus de la vérification arithmétique
  /// du résultat.
  final List<int> solutionNumbers;
  final List<String> solutionOperators;

  const NumberComposePuzzle({
    required this.target,
    required this.numberTiles,
    required this.operatorTiles,
    required this.slotCount,
    required this.solutionNumbers,
    required this.solutionOperators,
  });
}

class ComposeNombreLevel {
  final String niveau;
  final Map<String, String> title;
  final List<NumberComposePuzzle> Function(int seed, int count) generatePuzzles;

  const ComposeNombreLevel({
    required this.niveau,
    required this.title,
    required this.generatePuzzles,
  });
}

/// Évalue une expression "Compose le nombre !" strictement de gauche à
/// droite (pas de priorité opératoire) — exposé (pas de `_`) pour la
/// validation dans `widgets/number_compose_puzzle.dart`.
int evalComposeLeftToRight(List<int> nums, List<String> ops) {
  var result = nums[0];
  for (var i = 0; i < ops.length; i++) {
    final b = nums[i + 1];
    switch (ops[i]) {
      case '+':
        result += b;
        break;
      case '-':
        result -= b;
        break;
      case '×':
        result *= b;
        break;
      case '÷':
        result = result ~/ b;
        break;
    }
  }
  return result;
}

/// Construit un puzzle valide par construction (jamais de résultat négatif
/// ni de division non-exacte) plutôt que par génération-puis-validation.
NumberComposePuzzle _buildComposePuzzle(
  Random rand, {
  required int slotCount,
  required List<String> opsPool,
  required int maxNum,
  required int decoyRange,
}) {
  var current = 1 + rand.nextInt(maxNum);
  final nums = <int>[current];
  final ops = <String>[];
  for (var i = 0; i < slotCount - 1; i++) {
    var op = opsPool[rand.nextInt(opsPool.length)];
    int b;
    switch (op) {
      case '-':
        if (current <= 1) {
          op = '+';
          b = 1 + rand.nextInt(maxNum);
          current += b;
        } else {
          b = 1 + rand.nextInt(current);
          current -= b;
        }
        break;
      case '×':
        b = 2 + rand.nextInt(4);
        current *= b;
        break;
      case '÷':
        final divisors = [
          for (var d = 2; d <= current; d++)
            if (current % d == 0) d,
        ];
        if (divisors.isEmpty) {
          op = '+';
          b = 1 + rand.nextInt(maxNum);
          current += b;
        } else {
          b = divisors[rand.nextInt(divisors.length)];
          current = current ~/ b;
        }
        break;
      default:
        op = '+';
        b = 1 + rand.nextInt(maxNum);
        current += b;
    }
    nums.add(b);
    ops.add(op);
  }
  var decoyNumber = 1 + rand.nextInt(decoyRange);
  while (nums.contains(decoyNumber)) {
    decoyNumber = 1 + rand.nextInt(decoyRange);
  }
  final numberTiles = [...nums, decoyNumber]..shuffle(rand);
  final unusedOps = opsPool.where((o) => !ops.contains(o)).toList();
  final operatorTiles = [...ops];
  if (unusedOps.isNotEmpty) {
    operatorTiles.add(unusedOps[rand.nextInt(unusedOps.length)]);
  }
  operatorTiles.shuffle(rand);
  return NumberComposePuzzle(
    target: current,
    numberTiles: numberTiles,
    operatorTiles: operatorTiles,
    slotCount: slotCount,
    solutionNumbers: nums,
    solutionOperators: ops,
  );
}

List<NumberComposePuzzle> _generateComposeCp(int seed, int count) {
  final rand = Random(seed);
  return List.generate(
    count,
    (_) => _buildComposePuzzle(
      rand,
      slotCount: 2,
      opsPool: const ['+', '-'],
      maxNum: 10,
      decoyRange: 12,
    ),
  );
}

List<NumberComposePuzzle> _generateComposeCe1(int seed, int count) {
  final rand = Random(seed);
  return List.generate(
    count,
    (i) => _buildComposePuzzle(
      rand,
      slotCount: i.isEven ? 2 : 3,
      opsPool: const ['+', '-', '×'],
      maxNum: 10,
      decoyRange: 20,
    ),
  );
}

List<NumberComposePuzzle> _generateComposeCe2(int seed, int count) {
  final rand = Random(seed);
  return List.generate(
    count,
    (_) => _buildComposePuzzle(
      rand,
      slotCount: 3,
      opsPool: const ['+', '-', '×', '÷'],
      maxNum: 20,
      decoyRange: 40,
    ),
  );
}

List<NumberComposePuzzle> _generateComposeCm1(int seed, int count) {
  final rand = Random(seed);
  return List.generate(
    count,
    (_) => _buildComposePuzzle(
      rand,
      slotCount: 3,
      opsPool: const ['+', '-', '×', '÷'],
      maxNum: 30,
      decoyRange: 60,
    ),
  );
}

List<NumberComposePuzzle> _generateComposeCm2(int seed, int count) {
  final rand = Random(seed);
  return List.generate(
    count,
    (_) => _buildComposePuzzle(
      rand,
      slotCount: 3,
      opsPool: const ['+', '-', '×', '÷'],
      maxNum: 50,
      decoyRange: 100,
    ),
  );
}

const Map<String, String> _kComposeNombreTitle = {
  'fr': 'Compose le nombre !',
  'en': 'Build the number!',
  'es': '¡Compón el número!',
  'ar': 'كوّن العدد!',
};

const List<ComposeNombreLevel> COMPOSE_NOMBRE_LEVELS = [
  ComposeNombreLevel(
    niveau: 'CP',
    title: _kComposeNombreTitle,
    generatePuzzles: _generateComposeCp,
  ),
  ComposeNombreLevel(
    niveau: 'CE1',
    title: _kComposeNombreTitle,
    generatePuzzles: _generateComposeCe1,
  ),
  ComposeNombreLevel(
    niveau: 'CE2',
    title: _kComposeNombreTitle,
    generatePuzzles: _generateComposeCe2,
  ),
  ComposeNombreLevel(
    niveau: 'CM1',
    title: _kComposeNombreTitle,
    generatePuzzles: _generateComposeCm1,
  ),
  ComposeNombreLevel(
    niveau: 'CM2',
    title: _kComposeNombreTitle,
    generatePuzzles: _generateComposeCm2,
  ),
];
