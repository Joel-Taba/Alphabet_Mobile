import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Langues supportées
enum Lang { fr, en }

/// Locale BCP-47 pour la synthèse vocale
const Map<Lang, String> speechLocale = {Lang.fr: 'fr-FR', Lang.en: 'en-US'};

const _storageKey = 'amani_setting_lang';

class LanguageProvider extends ChangeNotifier {
  Lang _lang = Lang.fr;

  Lang get lang => _lang;
  Map<String, dynamic> get t => _lang == Lang.fr ? fr : en;

  LanguageProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_storageKey);
    if (saved == 'en') {
      _lang = Lang.en;
      notifyListeners();
    }
  }

  Future<void> setLang(Lang next) async {
    _lang = next;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, next == Lang.fr ? 'fr' : 'en');
  }
}

/// Remplace les {placeholders} d'une chaîne traduite par des valeurs.
String tFormat(String template, Map<String, dynamic> values) {
  return template.replaceAllMapped(
    RegExp(r'\{(\w+)\}'),
    (match) => '${values[match.group(1)] ?? ''}',
  );
}

// ─── DICTIONNAIRES ──────────────────────────────────────────────────────────

const Map<String, dynamic> fr = {
  'nav': {
    'accueil': 'Accueil',
    'bibliotheque': 'Mode libre',
    'communaute': 'Clairière',
    'profil': 'Profil',
    'reglages': 'Paramètres',
    'mainNavAria': 'Navigation principale',
  },
  'common': {
    'back': 'Retour',
    'listen': 'Écouter',
    'stop': 'Arrêter',
    'continue': 'Continuer',
    'close': 'Fermer',
    'replay': 'Relancer',
    'instruction': 'Consigne',
    'settings': 'Paramètres',
    'tryAgain': 'Essayer à nouveau',
  },
  'welcome': {
    'title': 'Bienvenue',
    'heading': 'Salut ! Je suis Amani.',
    'subheading': 'Tu veux bien jouer avec moi ?',
    'start': "Commencer l'aventure",
    'imBack': "C'est encore moi ! 🐿️",
  },
  'onboarding': {
    'title': 'Bienvenue !',
    'subtitle': "Dis-nous qui tu es pour commencer l'aventure",
    'namePlaceholder': "Comment tu t'appelles ?",
    'passwordPlaceholder': 'Mot de passe secret',
    'passwordHint': "Ce mot de passe protège l'accès à Mon Profil.",
    'showPassword': 'Afficher le mot de passe',
    'hidePassword': 'Masquer le mot de passe',
    'languageLabel': 'Langue',
    'start': "Commencer l'aventure",
  },
  'profileLock': {
    'title': 'Mon Profil est protégé',
    'subtitle': "Entre le mot de passe défini à l'inscription pour continuer.",
    'passwordPlaceholder': 'Mot de passe',
    'wrongPassword': 'Mot de passe incorrect, réessaie.',
    'unlockButton': 'Déverrouiller',
  },
  'parcours': {
    'title': 'Parcours de la branche',
    'subtitle':
        'Suis le chemin en zigzag et fais éclore les bourgeons une étape à la fois.',
    'start': 'Commencer',
    'lockedAria': 'Étape verrouillée',
    'bonusAria': 'Récompense bonus verrouillée',
    'medalAria': 'Médaille de fin de palier',
    'coursStep': 'Cours',
    'exerciceStep': 'Exercice',
    'crosswordStep': 'Mots croisés',
    'comingSoon':
        'Cette étape arrive bientôt ! Amani continue de la préparer 🌱',
    'paliers': [
      {
        'title': 'Les Signes de base',
        'subtitle': 'PALIER 1',
        'tagline': 'Points, courbes, crochets et traits',
      },
      {
        'title': 'La combinatoire : lettres et chiffres',
        'subtitle': 'PALIER 2',
        'tagline': 'Assemble les signes pour écrire',
      },
      {
        'title': 'Les Syllabes',
        'subtitle': 'PALIER 3',
        'tagline': 'Assemble consonnes et voyelles pour lire',
      },
      {
        'title': 'Les Mots',
        'subtitle': 'PALIER 4',
        'tagline': 'Relie les lettres entre elles',
      },
    ],
  },
  'coursFamily': {
    'intro':
        'Voici le cours sur {title}. Touche une carte en bas pour voir comment tracer chaque variante.',
    'variantsTitle': 'Toutes les variantes',
    'exercer': "M'exercer",
    'passExercices': 'Passer aux Exercices ({title})',
    'titles': {
      'point': 'Le Point',
      'courbe': 'Les Courbes',
      'crochet': 'Les Crochets & Doubles-Crochets',
      'trait': 'Les Traits',
    },
  },
  'exerciceListe': {
    'titleGroup': 'Cahier : {titre}',
    'subtitleGroupLettres': 'Exerce-toi à tracer ces lettres',
    'subtitleGroupDigits': 'Exerce-toi à tracer ces chiffres',
    'introGroup':
        "Voici le cahier d'écriture pour {titre} ! Choisis un caractère pour t'entraîner à le former signe par signe.",
    'groupHint':
        "Touche un caractère ci-dessous pour t'entraîner sur la grille Seyès avec validation de chaque geste !",
    'letterPrefix': 'La lettre',
    'digitPrefix': 'Le chiffre',
    'gestureCount': '{count} geste(s)',
    'title': "Cahier d'Écriture",
    'titleFamily': 'Cahier : {titre}',
    'subtitle': 'Repasse sur les pointillés',
    'introGeneral':
        "Bienvenue dans le cahier d'écriture ! Repasse sur les pointillés en suivant la pastille verte pour apprendre à tracer chaque signe correctement.",
    'startHint':
        'Le point vert indique le point de départ. Suis les pointillés en levant le moins possible le doigt.',
    'done': 'Terminé !',
    'rowComplete':
        'Bravo ! Tu as tracé tous les signes de cette ligne. Excellent travail !',
    'reducedLabel': 'réduit',
    'backAria': "Retour à l'accueil",
    'familyNames': {
      'point': 'Points',
      'courbe': 'Courbes',
      'crochet': 'Crochets',
      'trait': 'Traits',
    },
  },
  'coursFormation': {
    'title': 'Former les Lettres',
    'subtitle': 'Combinaison des signes de base',
    'signeCount': '{count} signe(s)',
  },
  'coursFormationChar': {
    'notFound': "n'est pas disponible pour le moment.",
    'backToList': 'Retour aux cours',
    'formulaTitle': 'Formule',
    'practice': "M'exercer sur",
    'vowelsTitle': 'Les Voyelles',
    'families': {
      'trait': 'Trait',
      'courbe': 'Courbe',
      'crochet': 'Crochet',
      'point': 'Point',
    },
  },
  'exerciceLettre': {
    'title': 'Tracer',
    'stepPrefix': 'Signe',
    'signsReady': '{done}/{total} signes prêts',
    'practiceStepsTitle': 'Entraîne-toi sur chaque signe',
    'practiceStepsHint':
        "Réussis chaque signe {reps} fois avant d'écrire la lettre complète.",
    'finalTitle': 'Écris la lettre complète',
    'finalHint':
        'Trace maintenant tous les signes à la suite, comme pour écrire la vraie lettre.',
    'finalLocked':
        'Termine d\'abord tous les signes ci-dessus pour débloquer cette étape.',
    'successAll': 'Félicitations ! Lettre complète !',
    'successAllSub': "Tu maîtrises l'assemblage de ce caractère.",
    'formulaTitle': 'Formule de',
    'validated': 'validé(s)',
    'resetAll': 'Recommencer à zéro',
    'notFound': 'non trouvé.',
    'backToNotebook': 'Retour au cahier',
    'successTitle': 'Magnifique !',
    'successBody': 'Tu sais maintenant écrire',
    'nextLetter': 'Lettre suivante',
    'practiceAgain': "S'exercer à nouveau",
    'backToNotebookLink': "Retour au cahier d'écriture",
    'speakStart': 'Exerce-toi sur la lettre {name}.',
    'speakNextStep': 'Super ! Passe maintenant au signe suivant.',
    'speakLetterDone': 'Bravo ! Tu as parfaitement formé la lettre {name} !',
    'speakRetryStep': 'Presque ! Réessaie juste ce geste : {desc}',
  },
  'coursSyllabes': {
    'title': 'Les syllabes',
    'subtitle': 'Assemble les lettres pour lire',
    'notFound': "n'est pas disponible pour le moment.",
    'backToList': 'Retour au parcours',
    'consonantTitle': 'Syllabes avec « {consonant} »',
    'syllableCount': '{count} syllabe(s)',
    'formingLabel': '{consonant} + {vowel} = {syllable}',
    'exampleWordLabel': 'Un mot avec « {syllable} »',
    'speakFormation': '{consonant}... {vowel}... {syllable} !',
    'practice': "M'exercer sur ces syllabes",
    'nextConsonant': 'Consonne suivante : {consonant}',
  },
  'exerciceSyllabes': {
    'title': 'Trace',
    'syllablesReady': '{done}/{total} syllabes tracées',
    'introTitle': 'Écris chaque syllabe',
    'introBody':
        'Trace la consonne puis la voyelle pour former chaque syllabe.',
    'allDoneTitle': 'Bravo, toutes les syllabes sont tracées !',
    'allDoneBody': 'Tu maîtrises les syllabes de cette consonne.',
    'nextGroup': 'Consonne suivante : {consonant}',
    'exampleWordPrefix': 'comme dans',
  },
  'coursMots': {
    'notFound': "n'est pas disponible pour le moment.",
    'backToList': "Retour à l'accueil",
    'wordCount': '{count} mot(s) à découvrir',
    'introSpeak':
        'Voici le cours sur {titre}. Touche le haut-parleur de chaque mot pour l\'écouter.',
    'introTitle': 'Écoute et regarde chaque mot',
    'introBody':
        "Chaque mot est déjà écrit avec les lettres que tu connais. Touche le haut-parleur pour l'entendre !",
    'practiceGroup': "M'exercer sur {titre}",
  },
  'exerciceMots': {
    'wordsReady': '{done}/{total} mots écrits',
    'introTitle': 'Écris chaque mot',
    'introBody': 'Trace les lettres dans l\'ordre pour former chaque mot.',
    'allDoneTitle': 'Bravo, tous les mots sont écrits !',
    'allDoneBody': 'Tu maîtrises ce groupe de mots.',
    'nextGroup': 'Groupe suivant : {titre}',
  },
  'motsCroises': {
    'title': 'Mots croisés',
    'subtitle': 'Complète la grille lettre par lettre',
    'levelSubtitle': 'Niveau {level} · {count} mots',
    'hintTitle': 'Écoute puis complète',
    'hintBody':
        'Écoute chaque mot ci-dessous et trace ses lettres dans la grille, comme un vrai mot croisé !',
    'doneTitle': 'Grille complétée !',
    'doneBody': 'Bravo, tu as résolu ce mot croisé.',
    'across': 'Horizontal',
    'down': 'Vertical',
    'featuredTitle': 'Grille terminée, bravo !',
    'featuredBody':
        'Tu as écrit et prononcé tous les mots ! Voici le mot vedette à l\'honneur :',
    'continueLabel': 'Continuer',
    'generationFailed': 'Impossible de créer cette grille, réessaie.',
    'wordsFoundLabel': '{solved} sur {total} mots trouvés',
  },
  'modeLibreCroises': {
    'title': 'Mots croisés',
    'subtitle': 'Une nouvelle grille à chaque partie',
    'intro':
        'Touche « Nouvelle grille » pour piocher des mots au hasard et jouer aux mots croisés autant de fois que tu veux !',
    'newGame': 'Nouvelle grille',
    'generating': 'Préparation de la grille…',
  },
  'community': {
    'title': 'Notre Communauté ',
    'subtitle': 'Le classement',
    'othersTitle': 'Les autres pousses',
    'you': 'moi',
    'amaniQuote': "Chacun grandit à son rythme, l'important est d'y aller.",
    'amaniLine': 'Bravo à toutes les pousses de la clairière !',
    'starsSuffix': '⭐',
    'stumpAria': 'Souche rang {rank}',
  },
  'profileHub': {
    'title': "Mon carnet d'explorateur",
    'subtitle': "Continue sur ta lancée, tu apprends magnifiquement bien !",
    'statsSignes': 'Signes maîtrisés',
    'statsExercices': 'Exercices réussis',
    'statsDays': "Jours d'aventure",
    'progressionTitle': 'Ma progression dans la forêt',
    'stepsValidated': 'sur {total} étapes validées',
    'settingsTitle': 'Mes Réglages',
    'languageCardTitle': "Langue de l'explorateur",
    'soundCardTitle': 'Son & Animations',
    'voiceLabel': "Voix d'Amani",
    'volumeLabel': 'Volume de la voix',
    'volumeTest': 'Tester le volume',
    'volumeTestPhrase': 'Voici à quoi ressemble ma voix !',
    'voiceGenderLabel': 'Style de voix',
    'voiceGenderOptions': [
      {'label': 'Voix Homme', 'desc': 'Douce et chaleureuse'},
      {'label': 'Voix Femme', 'desc': 'Douce et chaleureuse'},
    ],
    'voiceGenderTest': 'Écouter un exemple',
    'voiceGenderTestPhrase':
        "Coucou, c'est Amani ! On continue à apprendre ensemble ?",
    'formatCardTitle': "Format d'écriture",
    'formatOptions': [
      {'label': 'Script', 'desc': 'Imprimé'},
      {'label': 'Cursive', 'desc': 'Attaché'},
      {'label': 'Digitale', 'desc': 'Tablette'},
    ],
    'exercisesCardTitle': "Exercices d'écriture",
    'branches': [
      {'name': 'Palier 1 : Points & Courbes'},
      {'name': 'Palier 2 : Crochets & Traits'},
      {'name': 'Palier 3 : La Combinatoire'},
    ],
    'lockAction': 'Verrouiller Mon Profil',
    'passwordCardTitle': 'Mot de passe de Mon Profil',
    'newPasswordPlaceholder': 'Nouveau mot de passe',
    'confirmPasswordPlaceholder': 'Confirmer le mot de passe',
    'passwordMismatch': 'Les deux mots de passe ne correspondent pas.',
    'passwordTooShort':
        'Le mot de passe doit contenir au moins {count} caractères.',
    'passwordSaved': 'Mot de passe mis à jour !',
    'savePassword': 'Enregistrer le mot de passe',
    'repetitionsLabel': 'Répétitions par signe',
    'repetitionsHint': 'Nombre de fois à tracer chaque signe sur la ligne',
    'toleranceLabel': 'Tolérance de validation',
    'toleranceHint': 'Plus haute = plus facile pour les plus jeunes',
  },
  'modeLibre': {
    'title': 'Mode Libre',
    'subtitle': 'Dessine et exerce-toi librement, sans contrainte !',
    'helpText':
        "Choisis un modèle si tu veux t'en inspirer, puis dessine-le de mémoire sur la page blanche.",
    'tabs': {
      'scribble': 'Griffonnage',
      'sign': 'Signe',
      'letter': 'Lettre',
      'digit': 'Chiffre',
      'crossword': 'Mots croisés',
    },
    'modelLabel': 'Modèle',
    'noModelTitle': 'Dessine ce que tu veux !',
    'noModelBody': 'Laisse aller ton doigt librement sur la page.',
    'clear': 'Effacer',
    'colorLabel': 'Couleur',
    'signNames': {
      'trait': 'Le Trait',
      'courbe': 'La Courbe',
      'point': 'Le Point',
      'crochet': 'Le Crochet',
    },
  },
};

const Map<String, dynamic> en = {
  'nav': {
    'accueil': 'Home',
    'bibliotheque': 'Free mode',
    'communaute': 'Clearing',
    'profil': 'Profile',
    'reglages': 'Settings',
    'mainNavAria': 'Main navigation',
  },
  'common': {
    'back': 'Back',
    'listen': 'Listen',
    'stop': 'Stop',
    'continue': 'Continue',
    'close': 'Close',
    'replay': 'Replay',
    'instruction': 'Instructions',
    'settings': 'Settings',
    'tryAgain': 'Try again',
  },
  'welcome': {
    'title': 'Welcome',
    'heading': "Hi! I'm Amani.",
    'subheading': 'Want to play with me?',
    'start': 'Start the adventure',
    'imBack': "It's me again! 🐿️",
  },
  'onboarding': {
    'title': 'Welcome!',
    'subtitle': 'Tell us who you are to start the adventure',
    'namePlaceholder': "What's your name?",
    'passwordPlaceholder': 'Secret password',
    'passwordHint': 'This password protects access to My Profile.',
    'showPassword': 'Show password',
    'hidePassword': 'Hide password',
    'languageLabel': 'Language',
    'start': 'Start the adventure',
  },
  'profileLock': {
    'title': 'My Profile is protected',
    'subtitle': 'Enter the password set at sign-up to continue.',
    'passwordPlaceholder': 'Password',
    'wrongPassword': 'Wrong password, try again.',
    'unlockButton': 'Unlock',
  },
  'parcours': {
    'title': 'The Branch Path',
    'subtitle': 'Follow the zigzag path and open the buds one step at a time.',
    'start': 'Start',
    'lockedAria': 'Locked step',
    'bonusAria': 'Locked bonus reward',
    'medalAria': 'End-of-tier medal',
    'coursStep': 'Lesson',
    'exerciceStep': 'Exercise',
    'crosswordStep': 'Crossword',
    'comingSoon': 'This step is coming soon! Amani is still preparing it 🌱',
    'paliers': [
      {
        'title': 'The Basic Signs',
        'subtitle': 'TIER 1',
        'tagline': 'Dots, curves, hooks and lines',
      },
      {
        'title': 'Combinatorics: letters and numbers',
        'subtitle': 'TIER 2',
        'tagline': 'Combine signs to write',
      },
      {
        'title': 'Syllables',
        'subtitle': 'TIER 3',
        'tagline': 'Blend letters to read',
      },
      {
        'title': 'Words',
        'subtitle': 'TIER 3',
        'tagline': 'Link letters together',
      },
    ],
  },
  'coursFamily': {
    'intro':
        "Here's the lesson on {title}. Tap a card below to see how to trace each variant.",
    'variantsTitle': 'All variants',
    'exercer': 'Practice',
    'passExercices': 'Go to Exercises ({title})',
    'titles': {
      'point': 'The Dot',
      'courbe': 'The Curves',
      'crochet': 'Hooks & Double Hooks',
      'trait': 'The Lines',
    },
  },
  'exerciceListe': {
    'titleGroup': 'Notebook: {titre}',
    'subtitleGroupLettres': 'Practice tracing these letters',
    'subtitleGroupDigits': 'Practice tracing these digits',
    'introGroup':
        "Here's the writing notebook for {titre}! Choose a character to practice forming it sign by sign.",
    'groupHint':
        'Tap a character below to practice on the Seyès grid with validation of every gesture!',
    'letterPrefix': 'The letter',
    'digitPrefix': 'The digit',
    'gestureCount': '{count} gesture(s)',
    'title': 'Writing Notebook',
    'titleFamily': 'Notebook: {titre}',
    'subtitle': 'Trace over the dotted line',
    'introGeneral':
        "Welcome to the writing notebook! Trace over the dotted line following the green dot to learn how to draw each sign correctly.",
    'startHint':
        'The green dot shows the starting point. Follow the dotted line, lifting your finger as little as possible.',
    'done': 'Done!',
    'rowComplete':
        'Well done! You traced every sign on this line. Excellent work!',
    'reducedLabel': 'reduced',
    'backAria': 'Back to home',
    'familyNames': {
      'point': 'Dots',
      'courbe': 'Curves',
      'crochet': 'Hooks',
      'trait': 'Lines',
    },
  },
  'coursFormation': {
    'title': 'Building Letters',
    'subtitle': 'Combining the basic signs',
    'signeCount': '{count} sign(s)',
  },
  'coursFormationChar': {
    'notFound': "isn't available yet.",
    'backToList': 'Back to lessons',
    'formulaTitle': 'Formula',
    'practice': 'Practice',
    'vowelsTitle': 'The Vowels',
    'families': {
      'trait': 'Line',
      'courbe': 'Curve',
      'crochet': 'Hook',
      'point': 'Dot',
    },
  },
  'exerciceLettre': {
    'title': 'Trace',
    'stepPrefix': 'Sign',
    'signsReady': '{done}/{total} signs ready',
    'practiceStepsTitle': 'Practice each sign',
    'practiceStepsHint':
        'Succeed at each sign {reps} times before writing the complete letter.',
    'finalTitle': 'Write the complete letter',
    'finalHint':
        'Now trace all the signs one after another, just like writing the real letter.',
    'finalLocked': 'Finish all the signs above to unlock this step.',
    'successAll': 'Congratulations! Letter complete!',
    'successAllSub': "You've mastered assembling this character.",
    'formulaTitle': 'Formula for',
    'validated': 'validated',
    'resetAll': 'Start over',
    'notFound': 'not found.',
    'backToNotebook': 'Back to notebook',
    'successTitle': 'Wonderful!',
    'successBody': 'You now know how to write',
    'nextLetter': 'Next letter',
    'practiceAgain': 'Practice again',
    'backToNotebookLink': 'Back to the writing notebook',
    'speakStart': 'Practice the letter {name}.',
    'speakNextStep': 'Great! Now move on to the next sign.',
    'speakLetterDone': "Well done! You've perfectly formed the letter {name}!",
    'speakRetryStep': 'Almost! Try just this gesture again: {desc}',
  },
  'coursSyllabes': {
    'title': 'Syllables',
    'subtitle': 'Blend letters to read',
    'notFound': "isn't available yet.",
    'backToList': 'Back to the path',
    'consonantTitle': 'Syllables with "{consonant}"',
    'syllableCount': '{count} syllable(s)',
    'formingLabel': '{consonant} + {vowel} = {syllable}',
    'exampleWordLabel': 'A word with "{syllable}"',
    'speakFormation': '{consonant}... {vowel}... {syllable}!',
    'practice': 'Practice these syllables',
    'nextConsonant': 'Next consonant: {consonant}',
  },
  'exerciceSyllabes': {
    'title': 'Trace',
    'syllablesReady': '{done}/{total} syllables traced',
    'introTitle': 'Write each syllable',
    'introBody': 'Trace the consonant then the vowel to form each syllable.',
    'allDoneTitle': 'Well done, every syllable is traced!',
    'allDoneBody': "You've mastered this consonant's syllables.",
    'nextGroup': 'Next consonant: {consonant}',
    'exampleWordPrefix': 'as in',
  },
  'coursMots': {
    'notFound': 'is not available yet.',
    'backToList': 'Back to home',
    'wordCount': '{count} word(s) to discover',
    'introSpeak':
        "Here's the lesson on {titre}. Tap each word's speaker to hear it.",
    'introTitle': 'Listen and look at each word',
    'introBody':
        'Each word is already written with letters you know. Tap the speaker to hear it!',
    'practiceGroup': 'Practice {titre}',
  },
  'exerciceMots': {
    'wordsReady': '{done}/{total} words written',
    'introTitle': 'Write each word',
    'introBody': 'Trace the letters in order to spell each word.',
    'allDoneTitle': 'Well done, every word is written!',
    'allDoneBody': "You've mastered this group of words.",
    'nextGroup': 'Next group: {titre}',
  },
  'motsCroises': {
    'title': 'Crossword',
    'subtitle': 'Complete the grid letter by letter',
    'levelSubtitle': 'Level {level} · {count} words',
    'hintTitle': 'Listen, then complete',
    'hintBody':
        'Listen to each word below and trace its letters in the grid, like a real crossword!',
    'doneTitle': 'Grid complete!',
    'doneBody': 'Well done, you solved this crossword.',
    'across': 'Across',
    'down': 'Down',
    'featuredTitle': 'Grid complete, well done!',
    'featuredBody': "You wrote and said every word! Here's the featured word:",
    'continueLabel': 'Continue',
    'generationFailed': "Couldn't build this grid, try again.",
    'wordsFoundLabel': '{solved} of {total} words found',
  },
  'modeLibreCroises': {
    'title': 'Crossword',
    'subtitle': 'A new grid every game',
    'intro':
        'Tap "New grid" to draw random words and play crosswords as many times as you like!',
    'newGame': 'New grid',
    'generating': 'Building the grid…',
  },
  'community': {
    'title': 'Our Clearing Community',
    'subtitle': "This week's leaderboard",
    'othersTitle': 'The other sprouts',
    'you': 'me',
    'amaniQuote':
        'Everyone grows at their own pace, what matters is moving forward.',
    'amaniLine': 'Well done to every sprout in the clearing!',
    'footnote': 'This leaderboard only covers this tablet.',
    'starsSuffix': '⭐',
    'stumpAria': 'Rank {rank} stump',
  },
  'profileHub': {
    'title': 'My explorer notebook',
    'subtitle': "Keep it up, you're learning wonderfully well!",
    'statsSignes': 'Signs mastered',
    'statsExercices': 'Exercises passed',
    'statsDays': 'Days of adventure',
    'progressionTitle': 'My progress through the forest',
    'stepsValidated': 'of {total} steps completed',
    'settingsTitle': 'My Settings',
    'languageCardTitle': "Explorer's language",
    'soundCardTitle': 'Sound & Animations',
    'voiceLabel': "Amani's voice",
    'volumeLabel': 'Voice volume',
    'volumeTest': 'Test the volume',
    'volumeTestPhrase': 'This is what my voice sounds like!',
    'voiceGenderLabel': 'Voice style',
    'voiceGenderOptions': [
      {'label': 'Male voice', 'desc': 'Soft and warm'},
      {'label': 'Female voice', 'desc': 'Soft and warm'},
    ],
    'voiceGenderTest': 'Hear an example',
    'voiceGenderTestPhrase': "Hi, it's Amani! Shall we keep learning together?",
    'formatCardTitle': 'Writing format',
    'formatOptions': [
      {'label': 'Print', 'desc': 'Printed'},
      {'label': 'Cursive', 'desc': 'Joined'},
      {'label': 'Digital', 'desc': 'Tablet'},
    ],
    'exercisesCardTitle': 'Writing exercises',
    'branches': [
      {'name': 'Tier 1: Dots & Curves'},
      {'name': 'Tier 2: Hooks & Lines'},
      {'name': 'Tier 3: Combinatorics'},
    ],
    'lockAction': 'Lock My Profile',
    'passwordCardTitle': 'My Profile password',
    'newPasswordPlaceholder': 'New password',
    'confirmPasswordPlaceholder': 'Confirm password',
    'passwordMismatch': "The two passwords don't match.",
    'passwordTooShort':
        'The password must be at least {count} characters long.',
    'passwordSaved': 'Password updated!',
    'savePassword': 'Save password',
    'repetitionsLabel': 'Repetitions per sign',
    'repetitionsHint': 'Number of times to trace each sign on the line',
    'toleranceLabel': 'Validation tolerance',
    'toleranceHint': 'Higher = easier for younger learners',
  },
  'modeLibre': {
    'title': 'Free Mode',
    'subtitle': 'Draw and practice freely, no rules attached!',
    'helpText':
        'Pick a model if you want some inspiration, then draw it from memory on the blank page.',
    'tabs': {
      'scribble': 'Scribble',
      'sign': 'Sign',
      'letter': 'Letter',
      'digit': 'Digit',
      'crossword': 'Crossword',
    },
    'modelLabel': 'Model',
    'noModelTitle': 'Draw whatever you want!',
    'noModelBody': 'Let your finger move freely across the page.',
    'clear': 'Clear',
    'colorLabel': 'Color',
    'signNames': {
      'trait': 'The Line',
      'courbe': 'The Curve',
      'point': 'The Dot',
      'crochet': 'The Hook',
    },
  },
};
