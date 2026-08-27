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
/// Arithmétique de base enseignée du CP au CM2 (programme scolaire français).
/// Français uniquement (nomenclature CP/CE1/CE2/CM1/CM2 propre au système
/// scolaire français) — voir le filtre par langue dans parcours_screen.dart,
/// sur le même principe que le Palier "Les Syllabes".
///
/// Chaque sujet correspond à une paire Cours + Exercice sur le chemin en
/// zigzag. Les problèmes eux-mêmes sont soit une liste fixe (quand l'espace
/// à mémoriser est pédagogiquement fermé — doubles, amis de 10, tables),
/// soit générés par une fonction seedée (même principe que
/// `generateCrossword`/`generateWordSearch` dans `lib/utils/`) pour les
/// sujets à grand espace numérique.
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

  const CalculProblem({
    required this.display,
    required this.answer,
    this.answerSecondPart,
    this.secondPartSeparator = '',
    this.illustrateA,
    this.illustrateB,
    this.choices,
  });
}

class CalculTopic {
  final String id;
  final String niveau; // 'CP' | 'CE1' | 'CE2' | 'CM1' | 'CM2'
  final String title;
  final String subtitle;
  final String mnemonicTitle;
  final String mnemonicBody;

  /// [seed] varie à chaque "Relancer"/nouvelle tentative pour varier les
  /// problèmes ; [count] vient du réglage "Répétitions" (Profil > Réglages),
  /// réutilisé ici comme "nombre de problèmes par session d'exercice".
  final List<CalculProblem> Function(int seed, int count) generateProblems;

  const CalculTopic({
    required this.id,
    required this.niveau,
    required this.title,
    required this.subtitle,
    required this.mnemonicTitle,
    required this.mnemonicBody,
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
        ),
      );
    } else {
      final a = 1 + rand.nextInt(50);
      final b = 1 + rand.nextInt(100 - a);
      problems.add(CalculProblem(display: '$a + $b', answer: '${a + b}'));
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
        ),
      );
    } else {
      final a = 5 + rand.nextInt(16); // 5..20
      final b = rand.nextInt(a + 1); // 0..a (jamais de résultat négatif)
      problems.add(CalculProblem(display: '$a - $b', answer: '${a - b}'));
    }
  }
  return problems;
}

/// Doubles (1+1 à 9+9) et "amis de 10" — un espace de réponses fermé,
/// pédagogiquement destiné à être mémorisé par cœur plutôt que recalculé :
/// les problèmes sont donc puisés dans une liste fixe (mélangée par [seed]
/// pour varier les sessions), jamais générés aléatoirement.
List<CalculProblem> _generateCalculMentalCp(int seed, int count) {
  final pool = <CalculProblem>[
    for (var d = 1; d <= 9; d++)
      CalculProblem(display: '$d + $d', answer: '${d + d}'),
    for (final pair in const [
      [1, 9],
      [2, 8],
      [3, 7],
      [4, 6],
      [5, 5],
    ])
      CalculProblem(display: '${pair[0]} + ${pair[1]}', answer: '10'),
  ];
  pool.shuffle(Random(seed));
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
      unitsB = (10 - unitsA) + rand.nextInt(unitsA); // garantit unitsA+unitsB ≥ 10
    } else {
      unitsA = rand.nextInt(5); // 0..4
      unitsB = rand.nextInt(10 - unitsA); // garantit unitsA+unitsB ≤ 9
    }
    final a = tensA * 10 + unitsA;
    final b = tensB * 10 + unitsB;
    problems.add(CalculProblem(display: '$a + $b', answer: '${a + b}'));
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
    problems.add(CalculProblem(display: '$a - $b', answer: '${a - b}'));
  }
  return problems;
}

/// Construit 4 choix de QCM pour "table × n" : la bonne réponse et 3
/// distracteurs plausibles (table voisine, opérande voisin, confusion
/// addition/multiplication) — jamais une valeur absurde.
List<String> _mcqChoicesForMultiplication(int table, int n, Random rand) {
  final correct = table * n;
  final neighborTable = table > 1 ? table - 1 : table + 1;
  final neighborN = n > 1 ? n - 1 : n + 1;
  final candidates = <int>{
    neighborTable * n,
    table * neighborN,
    table + n,
  }..removeWhere((c) => c <= 0 || c == correct);
  var offset = 1;
  while (candidates.length < 3) {
    final cand = correct + offset;
    if (cand > 0 && cand != correct) candidates.add(cand);
    offset = offset > 0 ? -offset : -(offset - 1);
  }
  final distractors = candidates.toList()..shuffle(rand);
  final choices = [
    correct.toString(),
    ...distractors.take(3).map((c) => c.toString()),
  ];
  choices.shuffle(rand);
  return choices;
}

/// Tables de 1 à 9 — espace fermé, destiné à être mémorisé plutôt que
/// recalculé (même principe que les doubles/amis de 10 du CP). Exercice en
/// QCM (voir [CalculProblem.choices]) plutôt qu'en traçage : c'est le rappel
/// du fait mémorisé qui est testé, pas le tracé du chiffre.
List<CalculProblem> _generateMultiplicationCe1(int seed, int count) {
  final rand = Random(seed);
  final pool = <CalculProblem>[
    for (final table in [1, 2, 3, 4, 5, 6, 7, 8, 9])
      for (var n = 1; n <= 10; n++)
        CalculProblem(
          display: '$table × $n',
          answer: '${table * n}',
          choices: _mcqChoicesForMultiplication(table, n, rand),
        ),
  ];
  pool.shuffle(rand);
  return pool.take(count).toList();
}

List<CalculProblem> _generateMultiplicationPoseeCe2(int seed, int count) {
  final rand = Random(seed);
  final problems = <CalculProblem>[];
  for (var i = 0; i < count; i++) {
    final a = 10 + rand.nextInt(90); // 10..99
    final b = 2 + rand.nextInt(8); // 2..9
    problems.add(CalculProblem(display: '$a × $b', answer: '${a * b}'));
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
        CalculProblem(display: '$dividende ÷ $diviseur', answer: '$quotient'),
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
      problems.add(CalculProblem(display: '$a + $b', answer: '${a + b}'));
    } else {
      final a = 5000 + rand.nextInt(5000); // 5000..9999
      final b = 100 + rand.nextInt(a - 100);
      problems.add(CalculProblem(display: '$a - $b', answer: '${a - b}'));
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
        CalculProblem(display: '$dividende ÷ $diviseur', answer: '$quotient'),
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
        display:
            '${_formatDixiemes(aTenths)} $op ${_formatDixiemes(bTenths)}',
        answer: '${resultTenths ~/ 10}',
        answerSecondPart: '${resultTenths % 10}',
        secondPartSeparator: ',',
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
      CalculProblem(display: '$pct % de $base', answer: '$resultat'),
    );
  }
  return problems;
}

const List<CalculTopic> CALCUL_TOPICS = [
  CalculTopic(
    id: 'cp-addition',
    niveau: 'CP',
    title: "L'addition",
    subtitle: 'Comprendre le signe + et additionner jusqu\'à 100',
    mnemonicTitle: 'Le signe + réunit !',
    mnemonicBody:
        'Le signe "+" veut dire qu\'on rassemble deux groupes en un seul, '
        'comme quand on met tous ses jouets dans le même panier.',
    generateProblems: _generateAdditionCp,
  ),
  CalculTopic(
    id: 'cp-soustraction',
    niveau: 'CP',
    title: 'La soustraction',
    subtitle: 'Comprendre le reste et calculer de petites différences',
    mnemonicTitle: 'Le signe − enlève !',
    mnemonicBody:
        'Le signe "−" veut dire qu\'on enlève : comme quand on mange des '
        'bonbons dans un sachet, il en reste toujours un peu moins '
        'qu\'avant.',
    generateProblems: _generateSoustractionCp,
  ),
  CalculTopic(
    id: 'cp-calcul-mental',
    niveau: 'CP',
    title: 'Le calcul mental',
    subtitle: 'Automatiser les doubles et les compléments à 10',
    mnemonicTitle: 'Les doubles et les amis de 10 !',
    mnemonicBody:
        'Pour les doubles, pense à la comptine : 1+1 les jumeaux, 2+2 la '
        'porte, 3+3 les dés, 4+4 la pieuvre (elle a 8 pattes !), 5+5 les '
        'doigts de tes deux mains. Pour arriver à 10, cherche ton "ami de '
        '10" : 1 et 9, 2 et 8, 3 et 7, 4 et 6, 5 et 5 !',
    generateProblems: _generateCalculMentalCp,
  ),
  CalculTopic(
    id: 'ce1-addition-posee',
    niveau: 'CE1',
    title: "L'addition posée",
    subtitle: 'Maîtriser la technique avec des retenues',
    mnemonicTitle: 'La retenue qui grimpe !',
    mnemonicBody:
        'Quand les unités dépassent 9, on ne peut en garder que le chiffre '
        'des unités : la dizaine en trop "grimpe" tout en haut de la colonne '
        'suivante pour s\'ajouter aux dizaines. Elle voyage, elle ne '
        'disparaît jamais !',
    generateProblems: _generateAdditionPoseeCe1,
  ),
  CalculTopic(
    id: 'ce1-soustraction-posee',
    niveau: 'CE1',
    title: 'La soustraction posée',
    subtitle: 'Calcul écrit sans puis avec retenue',
    mnemonicTitle: "On emprunte une dizaine !",
    mnemonicBody:
        'Si le chiffre du haut est plus petit que celui du bas, on emprunte '
        'une dizaine à la colonne voisine : elle revient sous forme de 10 '
        'unités supplémentaires. Un emprunt, ça se rend toujours, alors on '
        'n\'oublie pas de l\'enlever à la colonne d\'à côté !',
    generateProblems: _generateSoustractionPoseeCe1,
  ),
  CalculTopic(
    id: 'ce1-multiplication',
    niveau: 'CE1',
    title: 'La multiplication',
    subtitle: 'Le sens de la multiplication et les tables de 1 à 9',
    mnemonicTitle: 'Multiplier, c\'est additionner en rythme !',
    mnemonicBody:
        'Multiplier, c\'est additionner plusieurs fois le même nombre : '
        '3 × 4, c\'est 3+3+3+3. La table de 2, ce sont les doubles que tu '
        'connais déjà. La table de 5, ce sont les doigts d\'une main : '
        'compte par bonds de 5 (5, 10, 15, 20...).',
    generateProblems: _generateMultiplicationCe1,
  ),
  CalculTopic(
    id: 'ce2-multiplication-posee',
    niveau: 'CE2',
    title: 'La multiplication posée',
    subtitle: 'Multiplier un nombre à plusieurs chiffres par un chiffre',
    mnemonicTitle: 'La pluie de chiffres !',
    mnemonicBody:
        'On multiplie chaque chiffre en partant de la droite, comme une '
        'pluie qui tombe colonne par colonne, et on n\'oublie jamais les '
        'retenues au passage — elles suivent le même chemin que dans une '
        'addition posée.',
    generateProblems: _generateMultiplicationPoseeCe2,
  ),
  CalculTopic(
    id: 'ce2-division',
    niveau: 'CE2',
    title: 'La division',
    subtitle: 'Le partage égal et le calcul du reste',
    mnemonicTitle: 'Le partage entre copains !',
    mnemonicBody:
        'Diviser, c\'est partager équitablement entre plusieurs copains. '
        'Parfois, ça tombe juste ! Parfois, il reste quelques objets qu\'on '
        'ne peut plus partager en entier — c\'est le reste, toujours plus '
        'petit que le nombre de copains.',
    generateProblems: _generateDivisionCe2,
  ),
  CalculTopic(
    id: 'ce2-grands-nombres',
    niveau: 'CE2',
    title: 'Les grands nombres',
    subtitle: "Calculer avec des nombres jusqu'à 10 000",
    mnemonicTitle: 'La maison des nombres !',
    mnemonicBody:
        'Chaque nombre habite une maison à plusieurs étages : les unités au '
        'rez-de-chaussée, puis les dizaines, les centaines et les milliers. '
        'Pour additionner ou soustraire de grands nombres, on garde chaque '
        'étage bien à sa place.',
    generateProblems: _generateGrandsNombresCe2,
  ),
  CalculTopic(
    id: 'cm1-division-posee',
    niveau: 'CM1',
    title: 'La division posée',
    subtitle: 'Diviser par un nombre à un ou deux chiffres',
    mnemonicTitle: 'Le grand partage, étage par étage !',
    mnemonicBody:
        'On partage la maison des nombres étage par étage, en commençant '
        'par le plus grand : à chaque étape, ce qui ne peut pas être '
        'partagé "descend" rejoindre le chiffre suivant, comme un petit '
        'reste qui continue le voyage.',
    generateProblems: _generateDivisionPoseeCm1,
  ),
  CalculTopic(
    id: 'cm1-fractions',
    niveau: 'CM1',
    title: 'Les fractions',
    subtitle: 'Additionner des fractions de même dénominateur',
    mnemonicTitle: 'La pizza en parts égales !',
    mnemonicBody:
        'Une fraction, ce sont des parts égales d\'une même pizza. Quand le '
        'nombre du bas (le dénominateur) est le même, il ne bouge jamais : '
        'on additionne juste les parts qu\'on a déjà, le nombre du haut '
        '(le numérateur).',
    generateProblems: _generateFractionsCm1,
  ),
  CalculTopic(
    id: 'cm1-decimaux',
    niveau: 'CM1',
    title: 'Les nombres décimaux',
    subtitle: 'Additionner et soustraire des nombres à virgule',
    mnemonicTitle: 'La virgule, comme un portefeuille !',
    mnemonicBody:
        'Imagine ton portefeuille : les euros entiers d\'un côté, les pièces '
        'de l\'autre. La virgule sépare toujours ces deux poches — on '
        'additionne ou on soustrait chaque poche avec celle d\'en face, '
        'jamais les deux mélangées.',
    generateProblems: _generateDecimauxCm1,
  ),
  CalculTopic(
    id: 'cm2-multiplication-decimale',
    niveau: 'CM2',
    title: 'La multiplication décimale',
    subtitle: 'Multiplier des nombres à virgule',
    mnemonicTitle: 'Compte les chiffres après la virgule !',
    mnemonicBody:
        'Calcule d\'abord comme si les virgules n\'existaient pas, puis '
        'recompte : ton résultat doit avoir le même nombre de chiffres '
        'après la virgule que dans les nombres de départ, réunis.',
    generateProblems: _generateMultiplicationDecimaleCm2,
  ),
  CalculTopic(
    id: 'cm2-division-decimale',
    niveau: 'CM2',
    title: 'La division décimale',
    subtitle: 'Diviser avec des nombres à virgule',
    mnemonicTitle: 'On continue après la virgule !',
    mnemonicBody:
        'La division décimale se pose exactement comme une division '
        'normale — on descend juste la virgule dans le résultat au bon '
        'moment, et on continue de partager après elle.',
    generateProblems: _generateDivisionDecimaleCm2,
  ),
  CalculTopic(
    id: 'cm2-proportionnalite',
    niveau: 'CM2',
    title: 'La proportionnalité',
    subtitle: 'Pourcentages, échelles et règle de trois',
    mnemonicTitle: 'La grille de 100 cases !',
    mnemonicBody:
        'Imagine un pourcentage comme une grille de 100 cases : "10 %", '
        'c\'est colorier 10 cases sur 100. Pour la règle de trois, les '
        'flèches se croisent en X entre ce que tu connais et ce que tu '
        'cherches : "produit en croix" !',
    generateProblems: _generateProportionnaliteCm2,
  ),
];

CalculTopic? findCalculTopic(String id) {
  for (final topic in CALCUL_TOPICS) {
    if (topic.id == id) return topic;
  }
  return null;
}

// ─── Mini-jeux bonus (5 niveaux chacun) ────────────────────────────────
//
// "Vrai ou Faux ?" et "Compose le nombre !" — intercalés dans le zigzag du
// Palier "Les Calculs" au même titre que les mots croisés/mêlés du Palier
// "Les Mots" : purement ludiques, sans points ni progression (voir
// parcours_screen.dart, aucun de ces écrans n'appelle awardCompletion).

/// Un "Vrai ou Faux ?" : l'énoncé est-il juste ?
class TrueFalseEquation {
  final String display;
  final bool isTrue;
  const TrueFalseEquation({required this.display, required this.isTrue});
}

class VraiFauxLevel {
  final String niveau;
  final String title;
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
      final shown = rand.nextBool() ? correct : _nearMiss(rand, correct, min: 1);
      return TrueFalseEquation(
        display: '$numA/$denom + $numB/$denom = $shown/$denom',
        isTrue: shown == correct,
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
      display: '${_formatDixiemes(aTenths)} × $b = ${_formatDixiemes(shownTenths)}',
      isTrue: shownTenths == correctTenths,
    );
  });
}

const List<VraiFauxLevel> VRAI_FAUX_LEVELS = [
  VraiFauxLevel(
    niveau: 'CP',
    title: 'Vrai ou faux ?',
    generateItems: _generateVraiFauxCp,
  ),
  VraiFauxLevel(
    niveau: 'CE1',
    title: 'Vrai ou faux ?',
    generateItems: _generateVraiFauxCe1,
  ),
  VraiFauxLevel(
    niveau: 'CE2',
    title: 'Vrai ou faux ?',
    generateItems: _generateVraiFauxCe2,
  ),
  VraiFauxLevel(
    niveau: 'CM1',
    title: 'Vrai ou faux ?',
    generateItems: _generateVraiFauxCm1,
  ),
  VraiFauxLevel(
    niveau: 'CM2',
    title: 'Vrai ou faux ?',
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

  const NumberComposePuzzle({
    required this.target,
    required this.numberTiles,
    required this.operatorTiles,
    required this.slotCount,
  });
}

class ComposeNombreLevel {
  final String niveau;
  final String title;
  final List<NumberComposePuzzle> Function(int seed, int count)
  generatePuzzles;

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

const List<ComposeNombreLevel> COMPOSE_NOMBRE_LEVELS = [
  ComposeNombreLevel(
    niveau: 'CP',
    title: 'Compose le nombre !',
    generatePuzzles: _generateComposeCp,
  ),
  ComposeNombreLevel(
    niveau: 'CE1',
    title: 'Compose le nombre !',
    generatePuzzles: _generateComposeCe1,
  ),
  ComposeNombreLevel(
    niveau: 'CE2',
    title: 'Compose le nombre !',
    generatePuzzles: _generateComposeCe2,
  ),
  ComposeNombreLevel(
    niveau: 'CM1',
    title: 'Compose le nombre !',
    generatePuzzles: _generateComposeCm1,
  ),
  ComposeNombreLevel(
    niveau: 'CM2',
    title: 'Compose le nombre !',
    generatePuzzles: _generateComposeCm2,
  ),
];
