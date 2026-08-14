import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Langues supportées
enum Lang { fr, en, es, ar }

/// Locale BCP-47 pour la synthèse vocale
const Map<Lang, String> speechLocale = {
  Lang.fr: 'fr-FR',
  Lang.en: 'en-US',
  Lang.es: 'es-ES',
  Lang.ar: 'ar-SA',
};

/// Langues qui s'écrivent de droite à gauche : la mise en page entière
/// (Directionality) s'inverse — voir AmaniApp dans app.dart.
const Set<Lang> rtlLangs = {Lang.ar};

const _storageKey = 'amani_setting_lang';

class LanguageProvider extends ChangeNotifier {
  Lang _lang = Lang.fr;

  Lang get lang => _lang;
  Map<String, dynamic> get t {
    switch (_lang) {
      case Lang.fr:
        return fr;
      case Lang.en:
        return en;
      case Lang.es:
        return es;
      case Lang.ar:
        return ar;
    }
  }

  LanguageProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_storageKey);
    if (saved == 'en') {
      _lang = Lang.en;
      notifyListeners();
    } else if (saved == 'es') {
      _lang = Lang.es;
      notifyListeners();
    } else if (saved == 'ar') {
      _lang = Lang.ar;
      notifyListeners();
    }
  }

  Future<void> setLang(Lang next) async {
    _lang = next;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, next.name);
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
    'pointsEarnedAria': 'points gagnés',
    'next': 'Suivant',
    'previous': 'Précédent',
    'backToHome': "Retour à l'accueil",
    'restart': 'Recommencer',
  },
  'evaluation': {
    'badge': 'Évaluation',
    'timeLeft': 'Temps restant',
    'finishedTitle': 'Bravo, évaluation terminée !',
    'finishedMessage':
        'Le temps est écoulé. Tu as bien travaillé sur cette évaluation.',
    'backToPath': 'Retour au parcours',
  },
  'mascotPoses': {
    'accueil': 'Amani te salue',
    'demonstration': 'Amani te montre un signe',
    'encouragement': "Amani t'encourage",
    'celebration': 'Amani célèbre ta réussite',
    'reconfort': 'Amani te réconforte',
    'reflexion': 'Amani réfléchit',
    'veille': 'Amani se repose',
  },
  'notFound': {
    'title': '404',
    'heading': 'Page introuvable',
    'body': "La page que tu cherches n'existe pas ou a été déplacée.",
    'goHome': "Retour à l'accueil",
  },
  'errorPage': {
    'heading': "Cette page n'a pas pu se charger",
    'body':
        "Quelque chose s'est mal passé de notre côté. Tu peux réessayer ou revenir à l'accueil.",
    'retry': 'Réessayer',
    'goHome': 'Accueil',
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
    'passwordPlaceholder': 'Mot de passe (pour Mon Profil)',
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
  'modeLibre': {
    'title': 'Mode Libre',
    'subtitle': 'Dessine et exerce-toi librement, sans contrainte !',
    'helpText': 'À toi de jouer, deviens le maître du dessin !',
    'tabs': {
      'scribble': 'Griffonnage',
      'sign': 'Signe',
      'letter': 'Lettre',
      'digit': 'Chiffre',
      'crossword': 'Mots croisés',
    },
    'modelLabel': 'Modèle',
    'noModelTitle': 'Laisse libre cours à ton imagination !',
    'noModelBody': 'Laisse ton doigt se promener librement sur la page.',
    'clear': 'Effacer',
    'colorLabel': 'Couleur',
    'canvasAria': 'Espace de dessin libre',
    'signNames': {
      'trait': 'Le Trait',
      'courbe': 'La Courbe',
      'point': 'Le Point',
      'crochet': 'Le Crochet',
    },
  },
  'parcours': {
    'title': 'Prêt à commencer ?',
    'subtitle': 'Je suis tout feu, tout flamme.On y va quand tu veux.',
    'start': 'Commencer',
    'lockedAria': 'Étape verrouillée',
    'bonusAria': 'Récompense bonus verrouillée',
    'medalAria': 'Médaille de fin de palier',
    'medalDoneAria': 'Médaille de fin de palier obtenue',
    'coursStep': 'Cours',
    'exerciceStep': 'Exercice',
    'crosswordStep': 'Mots croisés',
    'paliers': [
      {
        'title': 'Les Signes de base',
        'subtitle': 'PALIER 1',
        'tagline': 'Points, courbes, crochets et traits',
      },
      {
        'title': 'La combinatoire : lettres et chiffres',
        'subtitle': 'PALIER 2',
        'tagline': 'Assembler les signes',
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
    'comingSoon': 'Cette étape arrive bientôt !',
  },
  'community': {
    'title': 'Notre Communauté',
    'subtitle': 'Le classement',
    'othersTitle': 'Les autres pousses',
    'you': 'moi',
    'amaniQuote': "Chacun grandit à son rythme, l'important est d'y aller.",
    'amaniLine': 'Bravo à toutes les pousses de la clairière !',
    'footnote': 'Ce classement ne concerne que cette tablette.',
    'starsSuffix': '⭐',
    'stumpAria': 'Souche rang {rank}',
  },
  'profileHub': {
    'title': "Mon carnet d'explorateur",
    'subtitle': 'Continue sur ta lancée, tu apprends magnifiquement bien !',
    'totalPointsLabel': 'Mes points',
    'totalPointsHint': 'Gagnés en terminant tes cours et tes exercices',
    'statsSignes': 'Signes maîtrisés',
    'statsExercices': 'Exercices réussis',
    'statsDays': "Jours d'aventure",
    'progressionTitle': 'Ma progression dans la forêt',
    'stepsValidated': 'sur {total} étapes validées',
    'settingsTitle': 'Mes Réglages',
    'languageCardTitle': "Langue de l'explorateur",
    'soundCardTitle': 'Son & Animations',
    'voiceLabel': "Voix d'Amani",
    'voiceOn': 'Activée',
    'voiceOff': 'Coupée',
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
    'photoTitle': 'Ma photo de profil',
    'photoHint': '',
    'photoChangeAria': 'Changer la photo de profil',
    'photoRemove': 'Supprimer',
    'formatCardTitle': "Format d'écriture",
    'formatOptions': [
      {'label': 'Script', 'desc': 'Imprimé'},
      {'label': 'Cursive', 'desc': 'Attaché'},
    ],
    'exercisesCardTitle': "Exercices d'écriture",
    'evaluationDurationLabel': "Durée de l'évaluation",
    'evaluationDurationHint':
        "Temps donné pour l'évaluation chronométrée de fin de palier",
    'speedLabel': 'Vitesse de formation',
    'speedHint': "Vitesse de l'animation qui montre comment tracer un signe",
    'speedOptions': [
      {'label': 'Lent'},
      {'label': 'Normal'},
      {'label': 'Rapide'},
    ],
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
  },
  'plusScreen': {
    'title': "Plus d'options",
    'subtitle': "D'autres réglages pratiques, à portée de main.",
  },
  'exerciceComplete': {
    'title': 'Exercice terminé !',
    'body': 'Bravo, tu as terminé cet exercice. Que veux-tu faire maintenant ?',
  },
  'coursScreen': {
    'title': 'Mes Cours',
    'subtitle': 'Méthode Flores Gong Nota',
    'intro':
        'Voici les 4 signes fondamentaux de la méthode Flores Gong Nota. Touche une carte pour explorer toutes ses variantes.',
    'letters': 'Lettres & Chiffres',
    'lettersSubtitle': 'Combinatoire — a à z, A à Z, 0 à 9',
    'signNames': {
      'trait': 'Le Trait',
      'crochet': 'Le Crochet',
      'courbe': 'Les Courbes',
      'point': 'Le Point',
    },
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
  'coursLettres': {
    'title': 'Lettres & Chiffres',
    'subtitle': 'Touche une lettre pour voir sa formule',
    'intro':
        'Lettres et Chiffres. Chaque lettre est formée en assemblant les signes fondamentaux. Touche une lettre pour voir sa formule !',
    'legendSuffix': 'dominant',
    'minusculesTitle': 'Minuscules (a – z)',
    'minusculesSubtitle': 'Source : Manuel CP1 — formules validées',
    'chiffresTitle': 'Chiffres (0 – 9)',
    'chiffresSubtitle':
        '0–4 validés · 5–9 en cours de validation avec M. Moussa',
    'majusculesTitle': 'Majuscules (A – Z)',
    'majusculesSubtitle':
        '⚠️ Formules à valider avec M. Moussa avant usage pédagogique',
    'signeCount': '{count} signe(s)',
    'pendingAria': 'à valider',
    'viewAria': 'Voir la décomposition de {name}',
  },
  'coursLettresChar': {
    'notFound': 'non trouvé',
    'backToList': 'Retour à la liste',
    'pendingWarning':
        "Cette formule est une reconstruction visuelle et doit être validée par Monsieur Moussa avant d'être utilisée dans les exercices pédagogiques.",
    'seenOnLines': 'Aperçu sur les lignes',
    'formulaTitle': 'Formule',
    'signeCount': '{count} signe(s) · Touche un signe pour en savoir plus',
    'result': 'Résultat',
    'adqNote':
        "Attention : Les lettres a, d et q utilisent la même formule de signes. C'est la position du trait vertical (corps / hampe / jambe) qui les distingue — pas les signes eux-mêmes.",
    'practiceLink': "S'exercer dans le cahier d'écriture",
    'seeAll': 'Voir toutes les lettres',
    'families': {
      'trait': 'Le Trait',
      'courbe': 'La Courbe',
      'crochet': 'Le Crochet',
      'point': 'Le Point',
    },
    'variants': {
      'vertical': 'Vertical',
      'horizontal': 'Horizontal',
      'oblique-gauche': 'Oblique à gauche',
      'oblique-droit': 'Oblique à droite',
      'open-right': 'Ouvert à droite (C)',
      'open-left': 'Ouvert à gauche (Ɔ)',
      'bridge': 'En pont (∩)',
      'bowl': 'En creux (∪)',
      'closed': 'Fermé (rond complet)',
      'top-right': 'Haut droite',
      'top-left': 'Haut gauche',
      'bottom-right': 'Bas droite',
      'bottom-left': 'Bas gauche',
      'center': 'Central',
    },
    'zones': {'corps': 'Corps', 'hampe': '↑ Hampe', 'jambe': '↓ Jambe'},
  },
  'coursFormation': {
    'title': 'Former les Lettres',
    'subtitle': 'Combinaison des signes de base',
    'intro':
        'Bienvenue dans la combinatoire ! Ici, tu vas apprendre à combiner les signes pour former des lettres et des chiffres.',
    'magicTitle': 'La magie de la combinatoire !',
    'magicBody':
        'Chaque lettre est formée en assemblant les signes que tu as appris : traits, courbes, crochets et points. Touche un groupe pour commencer !',
    'previewTitle': 'Aperçu',
    'signeCount': '{count} signe(s)',
  },
  'coursFormationChar': {
    'notFound': "n'est pas disponible pour le moment.",
    'backToList': 'Retour aux cours',
    'formulaTitle': 'Formule',
    'vowelsTitle': 'Les Voyelles',
    'practice': "M'exercer sur",
    'families': {
      'trait': 'Trait',
      'courbe': 'Courbe',
      'crochet': 'Crochet',
      'point': 'Point',
    },
  },
  'exerciceIntro': {
    'title': 'Prochain exercice',
    'intro': 'On va reconnaître des signes ensemble !',
    'typeLabel': "Type d'exercice",
    'typeValue': 'Reconnaissance',
    'typeDesc': 'Trouve le bon signe parmi une petite grille.',
    'previewLabel': 'Aperçu',
    'start': 'Commencer',
    'demo': 'Voir une démonstration',
  },
  'exercice': {
    'findPrefix': 'Trouve la',
    'replay': 'Réécouter',
    'helpText':
        "La <b>Courbe</b>, c'est un arc doux comme un pont, en couleur verte.",
    'successTitle': 'Bravo, tu as trouvé !',
    'successBody': "Un bourgeon vient de s'ouvrir sur ta branche.",
    'tryAgain': 'Essayer à nouveau',
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
    'repetitionsLabel': 'Répétitions par signe',
    'repetitionsHint': 'Nombre de fois à tracer chaque signe sur la ligne',
    'toleranceLabel': 'Tolérance de validation',
    'toleranceHint': 'Plus haute = plus facile pour les plus jeunes',
    'startHint':
        'Le point vert indique le point de départ. Suis les pointillés en levant le moins possible le doigt.',
    'done': 'Terminé !',
    'rowComplete':
        'Bravo ! Tu as tracé tous les signes de cette ligne. Excellent travail !',
    'listenConsigne': 'Écouter la consigne : {label}',
    'reducedLabel': 'réduit',
    'settingsAria': 'Paramètres',
    'backAria': "Retour à l'accueil",
    'familyNames': {
      'point': 'Points',
      'courbe': 'Courbes',
      'crochet': 'Crochets',
      'trait': 'Traits',
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
        "Termine d'abord tous les signes ci-dessus pour débloquer cette étape.",
    'successAll': 'Félicitations ! Lettre complète !',
    'successAllSub': "Tu maîtrises l'assemblage de ce caractère.",
    'formulaTitle': 'Formule de',
    'validated': 'validé(s)',
    'resetAll': 'Recommencer à zéro',
    'reviewCourse': 'Revoir le cours',
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
    'speakReset': 'On recommence la lettre {name}.',
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
    'introSpeak': "Voici le cours sur {titre}. Touche un mot pour l'écouter.",
    'introTitle': 'Écoute et regarde chaque mot',
    'introBody':
        "Chaque mot est déjà écrit avec les lettres que tu connais. Touche le mot pour l'entendre, ou l'haltère pour t'exercer dessus !",
    'practiceGroup': "M'exercer sur {titre}",
    'practiceWordAria': "S'exercer sur « {mot} »",
  },
  'exerciceMots': {
    'wordsReady': '{done}/{total} mots écrits',
    'introTitle': 'Écris chaque mot',
    'introBody': "Trace les lettres dans l'ordre pour former chaque mot.",
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
        "Tu as écrit et prononcé tous les mots ! Voici le mot vedette à l'honneur :",
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
    'pointsEarnedAria': 'points earned',
    'next': 'Next',
    'previous': 'Previous',
    'backToHome': 'Back to home',
    'restart': 'Start over',
  },
  'evaluation': {
    'badge': 'Evaluation',
    'timeLeft': 'Time left',
    'finishedTitle': 'Well done, evaluation complete!',
    'finishedMessage': "Time's up. You worked hard on this evaluation.",
    'backToPath': 'Back to the path',
  },
  'mascotPoses': {
    'accueil': 'Amani waves hello',
    'demonstration': 'Amani shows a sign',
    'encouragement': 'Amani cheers you on',
    'celebration': 'Amani celebrates your success',
    'reconfort': 'Amani comforts you',
    'reflexion': 'Amani is thinking',
    'veille': 'Amani is resting',
  },
  'notFound': {
    'title': '404',
    'heading': 'Page not found',
    'body': "The page you're looking for doesn't exist or has been moved.",
    'goHome': 'Back home',
  },
  'errorPage': {
    'heading': "This page didn't load",
    'body':
        'Something went wrong on our end. You can try again or head back home.',
    'retry': 'Try again',
    'goHome': 'Home',
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
    'passwordPlaceholder': 'Password (for My Profile)',
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
  'modeLibre': {
    'title': 'Free Mode',
    'subtitle': 'Draw and practice freely, no rules attached!',
    'helpText':
        'Pick a model if you want some inspiration, then draw it from memory on the blank page. Clear it and start over as many times as you like!',
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
    'canvasAria': 'Free drawing area',
    'signNames': {
      'trait': 'The Line',
      'courbe': 'The Curve',
      'point': 'The Dot',
      'crochet': 'The Hook',
    },
  },
  'parcours': {
    'title': 'The Branch Path',
    'subtitle': 'Follow the zigzag path and open the buds one step at a time.',
    'start': 'Start',
    'lockedAria': 'Locked step',
    'bonusAria': 'Locked bonus reward',
    'medalAria': 'End-of-tier medal',
    'medalDoneAria': 'End-of-tier medal earned',
    'coursStep': 'Lesson',
    'exerciceStep': 'Exercise',
    'crosswordStep': 'Crossword',
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
        'tagline': 'Blend consonants and vowels to read',
      },
      {
        'title': 'Words',
        'subtitle': 'TIER 4',
        'tagline': 'Link letters together',
      },
    ],
    'comingSoon': 'This step is coming soon!',
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
    'totalPointsLabel': 'My points',
    'totalPointsHint': 'Earned by finishing your lessons and exercises',
    'statsSignes': 'Signs mastered',
    'statsExercices': 'Exercises passed',
    'statsDays': 'Days of adventure',
    'progressionTitle': 'My progress through the forest',
    'stepsValidated': 'of {total} steps completed',
    'settingsTitle': 'My Settings',
    'languageCardTitle': "Explorer's language",
    'soundCardTitle': 'Sound & Animations',
    'voiceLabel': "Amani's voice",
    'voiceOn': 'On',
    'voiceOff': 'Off',
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
    'photoTitle': 'My profile photo',
    'photoHint':
        'It will show up next to your name on the Clearing leaderboard.',
    'photoChangeAria': 'Change profile photo',
    'photoRemove': 'Remove',
    'formatCardTitle': 'Writing format',
    'formatOptions': [
      {'label': 'Print', 'desc': 'Printed'},
      {'label': 'Cursive', 'desc': 'Joined'},
    ],
    'exercisesCardTitle': 'Writing exercises',
    'evaluationDurationLabel': 'Evaluation duration',
    'evaluationDurationHint': 'Time given for the timed end-of-tier evaluation',
    'speedLabel': 'Formation speed',
    'speedHint': 'Speed of the animation that shows how to trace a sign',
    'speedOptions': [
      {'label': 'Slow'},
      {'label': 'Normal'},
      {'label': 'Fast'},
    ],
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
  },
  'plusScreen': {
    'title': 'More options',
    'subtitle': 'A few more handy settings, within reach.',
  },
  'exerciceComplete': {
    'title': 'Exercise complete!',
    'body':
        'Well done, you finished this exercise. What would you like to do next?',
  },
  'coursScreen': {
    'title': 'My Lessons',
    'subtitle': 'Flores Gong Nota Method',
    'intro':
        'Here are the 4 fundamental signs of the Flores Gong Nota method. Tap a card to explore all its variants.',
    'letters': 'Letters & Numbers',
    'lettersSubtitle': 'Combinatorics — a to z, A to Z, 0 to 9',
    'signNames': {
      'trait': 'The Line',
      'crochet': 'The Hook',
      'courbe': 'The Curves',
      'point': 'The Dot',
    },
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
  'coursLettres': {
    'title': 'Letters & Numbers',
    'subtitle': 'Tap a letter to see its formula',
    'intro':
        'Letters and Numbers. Each letter is formed by combining the fundamental signs. Tap a letter to see its formula!',
    'legendSuffix': 'dominant',
    'minusculesTitle': 'Lowercase (a – z)',
    'minusculesSubtitle': 'Source: CP1 Manual — validated formulas',
    'chiffresTitle': 'Numbers (0 – 9)',
    'chiffresSubtitle':
        '0–4 validated · 5–9 pending validation with Mr. Moussa',
    'majusculesTitle': 'Uppercase (A – Z)',
    'majusculesSubtitle':
        '⚠️ Formulas to be validated with Mr. Moussa before pedagogical use',
    'signeCount': '{count} sign(s)',
    'pendingAria': 'pending validation',
    'viewAria': 'View the breakdown of {name}',
  },
  'coursLettresChar': {
    'notFound': 'not found',
    'backToList': 'Back to list',
    'pendingWarning':
        'This formula is a visual reconstruction and must be validated by Mr. Moussa before being used in the lessons.',
    'seenOnLines': 'Preview on the lines',
    'formulaTitle': 'Formula',
    'signeCount': '{count} sign(s) · Tap a sign to learn more',
    'result': 'Result',
    'adqNote':
        "Note: The letters a, d and q use the same formula of signs. It's the position of the vertical line (body / ascender / descender) that tells them apart — not the signs themselves.",
    'practiceLink': 'Practice in the writing notebook',
    'seeAll': 'See all letters',
    'families': {
      'trait': 'The Line',
      'courbe': 'The Curve',
      'crochet': 'The Hook',
      'point': 'The Dot',
    },
    'variants': {
      'vertical': 'Vertical',
      'horizontal': 'Horizontal',
      'oblique-gauche': 'Diagonal left',
      'oblique-droit': 'Diagonal right',
      'open-right': 'Open right (C)',
      'open-left': 'Open left (Ɔ)',
      'bridge': 'Arch (∩)',
      'bowl': 'Bowl (∪)',
      'closed': 'Closed (full circle)',
      'top-right': 'Top right',
      'top-left': 'Top left',
      'bottom-right': 'Bottom right',
      'bottom-left': 'Bottom left',
      'center': 'Centered',
    },
    'zones': {'corps': 'Body', 'hampe': '↑ Ascender', 'jambe': '↓ Descender'},
  },
  'coursFormation': {
    'title': 'Building Letters',
    'subtitle': 'Combining the basic signs',
    'intro':
        "Welcome to combinatorics! Here, you'll learn to combine signs to form letters and numbers.",
    'magicTitle': 'The magic of combinatorics!',
    'magicBody':
        "Every letter is formed by assembling the signs you've learned: lines, curves, hooks and dots. Tap a group to start!",
    'previewTitle': 'Preview',
    'signeCount': '{count} sign(s)',
  },
  'coursFormationChar': {
    'notFound': "isn't available yet.",
    'backToList': 'Back to lessons',
    'formulaTitle': 'Formula',
    'vowelsTitle': 'The Vowels',
    'practice': 'Practice',
    'families': {
      'trait': 'Line',
      'courbe': 'Curve',
      'crochet': 'Hook',
      'point': 'Dot',
    },
  },
  'exerciceIntro': {
    'title': 'Next exercise',
    'intro': "We're going to recognize signs together!",
    'typeLabel': 'Exercise type',
    'typeValue': 'Recognition',
    'typeDesc': 'Find the right sign among a small grid.',
    'previewLabel': 'Preview',
    'start': 'Start',
    'demo': 'See a demonstration',
  },
  'exercice': {
    'findPrefix': 'Find the',
    'replay': 'Replay',
    'helpText': 'The <b>Curve</b> is a gentle arc like a bridge, in green.',
    'successTitle': 'Well done, you found it!',
    'successBody': 'A bud just opened on your branch.',
    'tryAgain': 'Try again',
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
        'Welcome to the writing notebook! Trace over the dotted line following the green dot to learn how to draw each sign correctly.',
    'repetitionsLabel': 'Repetitions per sign',
    'repetitionsHint': 'Number of times to trace each sign on the line',
    'toleranceLabel': 'Validation tolerance',
    'toleranceHint': 'Higher = easier for younger learners',
    'startHint':
        'The green dot shows the starting point. Follow the dotted line, lifting your finger as little as possible.',
    'done': 'Done!',
    'rowComplete':
        'Well done! You traced every sign on this line. Excellent work!',
    'listenConsigne': 'Listen to the instructions: {label}',
    'reducedLabel': 'reduced',
    'settingsAria': 'Settings',
    'backAria': 'Back to home',
    'familyNames': {
      'point': 'Dots',
      'courbe': 'Curves',
      'crochet': 'Hooks',
      'trait': 'Lines',
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
    'reviewCourse': 'Review the lesson',
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
    'speakReset': "Let's start the letter {name} again.",
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
    'introSpeak': "Here's the lesson on {titre}. Tap a word to hear it.",
    'introTitle': 'Listen and look at each word',
    'introBody':
        'Each word is already written with letters you know. Tap the word to hear it, or the dumbbell to practice it!',
    'practiceGroup': 'Practice {titre}',
    'practiceWordAria': 'Practice "{mot}"',
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
};

const Map<String, dynamic> es = {
  'nav': {
    'accueil': 'Inicio',
    'bibliotheque': 'Modo libre',
    'communaute': 'Claro',
    'profil': 'Perfil',
    'reglages': 'Ajustes',
    'mainNavAria': 'Navegación principal',
  },
  'common': {
    'back': 'Atrás',
    'listen': 'Escuchar',
    'stop': 'Detener',
    'continue': 'Continuar',
    'close': 'Cerrar',
    'replay': 'Repetir',
    'instruction': 'Instrucción',
    'settings': 'Ajustes',
    'tryAgain': 'Intentar de nuevo',
    'pointsEarnedAria': 'puntos ganados',
    'next': 'Siguiente',
    'previous': 'Anterior',
    'backToHome': 'Volver al inicio',
    'restart': 'Empezar de nuevo',
  },
  'evaluation': {
    'badge': 'Evaluación',
    'timeLeft': 'Tiempo restante',
    'finishedTitle': '¡Bien hecho, evaluación terminada!',
    'finishedMessage':
        'Se acabó el tiempo. Has trabajado muy bien en esta evaluación.',
    'backToPath': 'Volver al recorrido',
  },
  'mascotPoses': {
    'accueil': 'Amani te saluda',
    'demonstration': 'Amani te muestra un signo',
    'encouragement': 'Amani te anima',
    'celebration': 'Amani celebra tu éxito',
    'reconfort': 'Amani te consuela',
    'reflexion': 'Amani está pensando',
    'veille': 'Amani está descansando',
  },
  'notFound': {
    'title': '404',
    'heading': 'Página no encontrada',
    'body': 'La página que buscas no existe o ha sido movida.',
    'goHome': 'Volver al inicio',
  },
  'errorPage': {
    'heading': 'Esta página no se pudo cargar',
    'body':
        'Algo salió mal de nuestro lado. Puedes intentarlo de nuevo o volver al inicio.',
    'retry': 'Reintentar',
    'goHome': 'Inicio',
  },
  'welcome': {
    'title': 'Bienvenido',
    'heading': '¡Hola! Soy Amani.',
    'subheading': '¿Quieres jugar conmigo?',
    'start': 'Comenzar la aventura',
    'imBack': '¡Soy yo otra vez! 🐿️',
  },
  'onboarding': {
    'title': '¡Bienvenido!',
    'subtitle': 'Cuéntanos quién eres para comenzar la aventura',
    'namePlaceholder': '¿Cómo te llamas?',
    'passwordPlaceholder': 'Contraseña (para Mi Perfil)',
    'passwordHint': 'Esta contraseña protege el acceso a Mi Perfil.',
    'showPassword': 'Mostrar contraseña',
    'hidePassword': 'Ocultar contraseña',
    'languageLabel': 'Idioma',
    'start': 'Comenzar la aventura',
  },
  'profileLock': {
    'title': 'Mi Perfil está protegido',
    'subtitle':
        'Introduce la contraseña definida al registrarte para continuar.',
    'passwordPlaceholder': 'Contraseña',
    'wrongPassword': 'Contraseña incorrecta, inténtalo de nuevo.',
    'unlockButton': 'Desbloquear',
  },
  'modeLibre': {
    'title': 'Modo Libre',
    'subtitle': '¡Dibuja y practica libremente, sin reglas!',
    'helpText':
        'Elige un modelo si quieres inspirarte, luego dibújalo de memoria en la página en blanco. ¡Bórralo y vuelve a empezar todas las veces que quieras!',
    'tabs': {
      'scribble': 'Garabato',
      'sign': 'Signo',
      'letter': 'Letra',
      'digit': 'Dígito',
      'crossword': 'Crucigrama',
    },
    'modelLabel': 'Modelo',
    'noModelTitle': '¡Dibuja lo que quieras!',
    'noModelBody': 'Deja que tu dedo se mueva libremente por la página.',
    'clear': 'Borrar',
    'colorLabel': 'Color',
    'canvasAria': 'Área de dibujo libre',
    'signNames': {
      'trait': 'El Trazo',
      'courbe': 'La Curva',
      'point': 'El Punto',
      'crochet': 'El Gancho',
    },
  },
  'parcours': {
    'title': 'Recorrido de la rama',
    'subtitle':
        'Sigue el camino en zigzag y haz florecer los brotes paso a paso.',
    'start': 'Comenzar',
    'lockedAria': 'Etapa bloqueada',
    'bonusAria': 'Recompensa bonus bloqueada',
    'medalAria': 'Medalla de fin de nivel',
    'medalDoneAria': 'Medalla de fin de nivel obtenida',
    'coursStep': 'Lección',
    'exerciceStep': 'Ejercicio',
    'crosswordStep': 'Crucigrama',
    'paliers': [
      {
        'title': 'Los Signos básicos',
        'subtitle': 'NIVEL 1',
        'tagline': 'Puntos, curvas, ganchos y trazos',
      },
      {
        'title': 'La combinatoria: letras y números',
        'subtitle': 'NIVEL 2',
        'tagline': 'Combina los signos para escribir',
      },
      {
        'title': 'Las Sílabas',
        'subtitle': 'NIVEL 3',
        'tagline': 'Combina consonantes y vocales para leer',
      },
      {
        'title': 'Las Palabras',
        'subtitle': 'NIVEL 4',
        'tagline': 'Une las letras entre sí',
      },
    ],
    'comingSoon': '¡Esta etapa llega pronto!',
  },
  'community': {
    'title': 'Nuestra Comunidad del Claro',
    'subtitle': 'Clasificación de la semana',
    'othersTitle': 'Los otros brotes',
    'you': 'yo',
    'amaniQuote': 'Cada uno crece a su propio ritmo, lo importante es avanzar.',
    'amaniLine': '¡Bravo a todos los brotes del claro!',
    'footnote': 'Esta clasificación solo corresponde a esta tableta.',
    'starsSuffix': '⭐',
    'stumpAria': 'Tocón puesto {rank}',
  },
  'profileHub': {
    'title': 'Mi cuaderno de explorador',
    'subtitle': '¡Sigue así, estás aprendiendo maravillosamente bien!',
    'totalPointsLabel': 'Mis puntos',
    'totalPointsHint': 'Ganados al terminar tus lecciones y ejercicios',
    'statsSignes': 'Signos dominados',
    'statsExercices': 'Ejercicios superados',
    'statsDays': 'Días de aventura',
    'progressionTitle': 'Mi progreso en el bosque',
    'stepsValidated': 'de {total} etapas superadas',
    'settingsTitle': 'Mis Ajustes',
    'languageCardTitle': 'Idioma del explorador',
    'soundCardTitle': 'Sonido y Animaciones',
    'voiceLabel': 'Voz de Amani',
    'voiceOn': 'Activada',
    'voiceOff': 'Desactivada',
    'volumeLabel': 'Volumen de la voz',
    'volumeTest': 'Probar el volumen',
    'volumeTestPhrase': '¡Así suena mi voz!',
    'voiceGenderLabel': 'Estilo de voz',
    'voiceGenderOptions': [
      {'label': 'Voz masculina', 'desc': 'Suave y cálida'},
      {'label': 'Voz femenina', 'desc': 'Suave y cálida'},
    ],
    'voiceGenderTest': 'Escuchar un ejemplo',
    'voiceGenderTestPhrase': '¡Hola, soy Amani! ¿Seguimos aprendiendo juntos?',
    'photoTitle': 'Mi foto de perfil',
    'photoHint': 'Aparecerá junto a tu nombre en la clasificación de El Claro.',
    'photoChangeAria': 'Cambiar la foto de perfil',
    'photoRemove': 'Eliminar',
    'formatCardTitle': 'Formato de escritura',
    'formatOptions': [
      {'label': 'Script', 'desc': 'Imprenta'},
      {'label': 'Cursiva', 'desc': 'Ligada'},
    ],
    'exercisesCardTitle': 'Ejercicios de escritura',
    'evaluationDurationLabel': 'Duración de la evaluación',
    'evaluationDurationHint':
        'Tiempo dado para la evaluación cronometrada de fin de nivel',
    'speedLabel': 'Velocidad de formación',
    'speedHint': 'Velocidad de la animación que muestra cómo trazar un signo',
    'speedOptions': [
      {'label': 'Lenta'},
      {'label': 'Normal'},
      {'label': 'Rápida'},
    ],
    'branches': [
      {'name': 'Nivel 1: Puntos y Curvas'},
      {'name': 'Nivel 2: Ganchos y Trazos'},
      {'name': 'Nivel 3: La Combinatoria'},
    ],
    'lockAction': 'Bloquear Mi Perfil',
    'passwordCardTitle': 'Contraseña de Mi Perfil',
    'newPasswordPlaceholder': 'Nueva contraseña',
    'confirmPasswordPlaceholder': 'Confirmar contraseña',
    'passwordMismatch': 'Las dos contraseñas no coinciden.',
    'passwordTooShort': 'La contraseña debe tener al menos {count} caracteres.',
    'passwordSaved': '¡Contraseña actualizada!',
    'savePassword': 'Guardar contraseña',
  },
  'plusScreen': {
    'title': 'Más opciones',
    'subtitle': 'Otros ajustes prácticos, a mano.',
  },
  'exerciceComplete': {
    'title': '¡Ejercicio terminado!',
    'body': 'Muy bien, has terminado este ejercicio. ¿Qué quieres hacer ahora?',
  },
  'coursScreen': {
    'title': 'Mis Lecciones',
    'subtitle': 'Método Flores Gong Nota',
    'intro':
        'Aquí están los 4 signos fundamentales del método Flores Gong Nota. Toca una tarjeta para explorar todas sus variantes.',
    'letters': 'Letras y Números',
    'lettersSubtitle': 'Combinatoria — de a a z, de A a Z, de 0 a 9',
    'signNames': {
      'trait': 'El Trazo',
      'crochet': 'El Gancho',
      'courbe': 'Las Curvas',
      'point': 'El Punto',
    },
  },
  'coursFamily': {
    'intro':
        'Aquí está la lección sobre {title}. Toca una tarjeta abajo para ver cómo trazar cada variante.',
    'variantsTitle': 'Todas las variantes',
    'exercer': 'Practicar',
    'passExercices': 'Ir a los Ejercicios ({title})',
    'titles': {
      'point': 'El Punto',
      'courbe': 'Las Curvas',
      'crochet': 'Los Ganchos y Dobles Ganchos',
      'trait': 'Los Trazos',
    },
  },
  'coursLettres': {
    'title': 'Letras y Números',
    'subtitle': 'Toca una letra para ver su fórmula',
    'intro':
        'Letras y Números. Cada letra se forma combinando los signos fundamentales. ¡Toca una letra para ver su fórmula!',
    'legendSuffix': 'dominante',
    'minusculesTitle': 'Minúsculas (a – z)',
    'minusculesSubtitle': 'Fuente: Manual CP1 — fórmulas validadas',
    'chiffresTitle': 'Números (0 – 9)',
    'chiffresSubtitle':
        '0–4 validados · 5–9 en proceso de validación con el Sr. Moussa',
    'majusculesTitle': 'Mayúsculas (A – Z)',
    'majusculesSubtitle':
        '⚠️ Fórmulas por validar con el Sr. Moussa antes de su uso pedagógico',
    'signeCount': '{count} signo(s)',
    'pendingAria': 'por validar',
    'viewAria': 'Ver el desglose de {name}',
  },
  'coursLettresChar': {
    'notFound': 'no encontrado',
    'backToList': 'Volver a la lista',
    'pendingWarning':
        'Esta fórmula es una reconstrucción visual y debe ser validada por el Sr. Moussa antes de usarse en los ejercicios pedagógicos.',
    'seenOnLines': 'Vista previa en las líneas',
    'formulaTitle': 'Fórmula',
    'signeCount': '{count} signo(s) · Toca un signo para saber más',
    'result': 'Resultado',
    'adqNote':
        'Atención: Las letras a, d y q usan la misma fórmula de signos. Es la posición del trazo vertical (cuerpo / asta ascendente / asta descendente) lo que las distingue, no los signos en sí.',
    'practiceLink': 'Practicar en el cuaderno de escritura',
    'seeAll': 'Ver todas las letras',
    'families': {
      'trait': 'El Trazo',
      'courbe': 'La Curva',
      'crochet': 'El Gancho',
      'point': 'El Punto',
    },
    'variants': {
      'vertical': 'Vertical',
      'horizontal': 'Horizontal',
      'oblique-gauche': 'Oblicuo a la izquierda',
      'oblique-droit': 'Oblicuo a la derecha',
      'open-right': 'Abierto a la derecha (C)',
      'open-left': 'Abierto a la izquierda (Ɔ)',
      'bridge': 'En puente (∩)',
      'bowl': 'En cuenco (∪)',
      'closed': 'Cerrado (círculo completo)',
      'top-right': 'Arriba derecha',
      'top-left': 'Arriba izquierda',
      'bottom-right': 'Abajo derecha',
      'bottom-left': 'Abajo izquierda',
      'center': 'Central',
    },
    'zones': {
      'corps': 'Cuerpo',
      'hampe': '↑ Asta ascendente',
      'jambe': '↓ Asta descendente',
    },
  },
  'coursFormation': {
    'title': 'Formar las Letras',
    'subtitle': 'Combinación de los signos básicos',
    'intro':
        '¡Bienvenido a la combinatoria! Aquí aprenderás a combinar los signos para formar letras y números.',
    'magicTitle': '¡La magia de la combinatoria!',
    'magicBody':
        'Cada letra se forma ensamblando los signos que has aprendido: trazos, curvas, ganchos y puntos. ¡Toca un grupo para empezar!',
    'previewTitle': 'Vista previa',
    'signeCount': '{count} signo(s)',
  },
  'coursFormationChar': {
    'notFound': 'no está disponible por el momento.',
    'backToList': 'Volver a las lecciones',
    'formulaTitle': 'Fórmula',
    'vowelsTitle': 'Las Vocales',
    'practice': 'Practicar',
    'families': {
      'trait': 'Trazo',
      'courbe': 'Curva',
      'crochet': 'Gancho',
      'point': 'Punto',
    },
  },
  'exerciceIntro': {
    'title': 'Próximo ejercicio',
    'intro': '¡Vamos a reconocer signos juntos!',
    'typeLabel': 'Tipo de ejercicio',
    'typeValue': 'Reconocimiento',
    'typeDesc': 'Encuentra el signo correcto entre una pequeña cuadrícula.',
    'previewLabel': 'Vista previa',
    'start': 'Comenzar',
    'demo': 'Ver una demostración',
  },
  'exercice': {
    'findPrefix': 'Encuentra la',
    'replay': 'Reescuchar',
    'helpText':
        'La <b>Curva</b> es un arco suave como un puente, de color verde.',
    'successTitle': '¡Bien hecho, la encontraste!',
    'successBody': 'Un brote acaba de abrirse en tu rama.',
    'tryAgain': 'Intentar de nuevo',
  },
  'exerciceListe': {
    'titleGroup': 'Cuaderno: {titre}',
    'subtitleGroupLettres': 'Practica trazando estas letras',
    'subtitleGroupDigits': 'Practica trazando estos números',
    'introGroup':
        '¡Aquí está el cuaderno de escritura para {titre}! Elige un carácter para practicar formándolo signo por signo.',
    'groupHint':
        '¡Toca un carácter abajo para practicar en la cuadrícula Seyès con validación de cada gesto!',
    'letterPrefix': 'La letra',
    'digitPrefix': 'El dígito',
    'gestureCount': '{count} gesto(s)',
    'title': 'Cuaderno de Escritura',
    'titleFamily': 'Cuaderno: {titre}',
    'subtitle': 'Repasa las líneas punteadas',
    'introGeneral':
        '¡Bienvenido al cuaderno de escritura! Repasa las líneas punteadas siguiendo el punto verde para aprender a trazar cada signo correctamente.',
    'repetitionsLabel': 'Repeticiones por signo',
    'repetitionsHint':
        'Número de veces que hay que trazar cada signo en la línea',
    'toleranceLabel': 'Tolerancia de validación',
    'toleranceHint': 'Más alta = más fácil para los más pequeños',
    'startHint':
        'El punto verde indica el punto de partida. Sigue las líneas punteadas levantando el dedo lo menos posible.',
    'done': '¡Terminado!',
    'rowComplete':
        '¡Bien hecho! Has trazado todos los signos de esta línea. ¡Excelente trabajo!',
    'listenConsigne': 'Escuchar la instrucción: {label}',
    'reducedLabel': 'reducido',
    'settingsAria': 'Ajustes',
    'backAria': 'Volver al inicio',
    'familyNames': {
      'point': 'Puntos',
      'courbe': 'Curvas',
      'crochet': 'Ganchos',
      'trait': 'Trazos',
    },
  },
  'exerciceLettre': {
    'title': 'Trazar',
    'stepPrefix': 'Signo',
    'signsReady': '{done}/{total} signos listos',
    'practiceStepsTitle': 'Practica cada signo',
    'practiceStepsHint':
        'Consigue cada signo {reps} veces antes de escribir la letra completa.',
    'finalTitle': 'Escribe la letra completa',
    'finalHint':
        'Ahora traza todos los signos seguidos, como para escribir la letra de verdad.',
    'finalLocked':
        'Termina primero todos los signos de arriba para desbloquear esta etapa.',
    'successAll': '¡Felicidades! ¡Letra completa!',
    'successAllSub': 'Dominas el ensamblaje de este carácter.',
    'formulaTitle': 'Fórmula de',
    'validated': 'validado(s)',
    'resetAll': 'Empezar de nuevo',
    'reviewCourse': 'Repasar la lección',
    'notFound': 'no encontrado.',
    'backToNotebook': 'Volver al cuaderno',
    'successTitle': '¡Magnífico!',
    'successBody': 'Ahora sabes escribir',
    'nextLetter': 'Letra siguiente',
    'practiceAgain': 'Practicar de nuevo',
    'backToNotebookLink': 'Volver al cuaderno de escritura',
    'speakStart': 'Practica la letra {name}.',
    'speakNextStep': '¡Genial! Ahora pasa al siguiente signo.',
    'speakLetterDone':
        '¡Bien hecho! ¡Has formado perfectamente la letra {name}!',
    'speakRetryStep': '¡Casi! Vuelve a intentar solo este gesto: {desc}',
    'speakReset': 'Empezamos de nuevo la letra {name}.',
  },
  'coursSyllabes': {
    'title': 'Las sílabas',
    'subtitle': 'Combina las letras para leer',
    'notFound': 'no está disponible por el momento.',
    'backToList': 'Volver al recorrido',
    'consonantTitle': 'Sílabas con «{consonant}»',
    'syllableCount': '{count} sílaba(s)',
    'formingLabel': '{consonant} + {vowel} = {syllable}',
    'exampleWordLabel': 'Una palabra con «{syllable}»',
    'speakFormation': '{consonant}... {vowel}... ¡{syllable}!',
    'practice': 'Practicar estas sílabas',
    'nextConsonant': 'Siguiente consonante: {consonant}',
  },
  'exerciceSyllabes': {
    'title': 'Trazar',
    'syllablesReady': '{done}/{total} sílabas trazadas',
    'introTitle': 'Escribe cada sílaba',
    'introBody':
        'Traza la consonante y luego la vocal para formar cada sílaba.',
    'allDoneTitle': '¡Bien hecho, todas las sílabas están trazadas!',
    'allDoneBody': 'Dominas las sílabas de esta consonante.',
    'nextGroup': 'Siguiente consonante: {consonant}',
    'exampleWordPrefix': 'como en',
  },
  'coursMots': {
    'notFound': 'no está disponible por el momento.',
    'backToList': 'Volver al inicio',
    'wordCount': '{count} palabra(s) por descubrir',
    'introSpeak':
        'Aquí está la lección sobre {titre}. Toca una palabra para escucharla.',
    'introTitle': 'Escucha y observa cada palabra',
    'introBody':
        'Cada palabra ya está escrita con letras que conoces. ¡Toca la palabra para escucharla, o la mancuerna para practicarla!',
    'practiceGroup': 'Practicar {titre}',
    'practiceWordAria': 'Practicar «{mot}»',
  },
  'exerciceMots': {
    'wordsReady': '{done}/{total} palabras escritas',
    'introTitle': 'Escribe cada palabra',
    'introBody': 'Traza las letras en orden para formar cada palabra.',
    'allDoneTitle': '¡Bien hecho, todas las palabras están escritas!',
    'allDoneBody': 'Dominas este grupo de palabras.',
    'nextGroup': 'Siguiente grupo: {titre}',
  },
  'motsCroises': {
    'title': 'Crucigrama',
    'subtitle': 'Completa la cuadrícula letra por letra',
    'levelSubtitle': 'Nivel {level} · {count} palabras',
    'hintTitle': 'Escucha y luego completa',
    'hintBody':
        '¡Escucha cada palabra de abajo y traza sus letras en la cuadrícula, como un verdadero crucigrama!',
    'doneTitle': '¡Cuadrícula completada!',
    'doneBody': 'Bien hecho, has resuelto este crucigrama.',
    'across': 'Horizontal',
    'down': 'Vertical',
    'featuredTitle': '¡Cuadrícula terminada, bien hecho!',
    'featuredBody':
        '¡Has escrito y pronunciado todas las palabras! Aquí está la palabra destacada:',
    'continueLabel': 'Continuar',
    'generationFailed': 'No se pudo crear esta cuadrícula, inténtalo de nuevo.',
    'wordsFoundLabel': '{solved} de {total} palabras encontradas',
  },
  'modeLibreCroises': {
    'title': 'Crucigrama',
    'subtitle': 'Una cuadrícula nueva en cada partida',
    'intro':
        '¡Toca «Nueva cuadrícula» para sacar palabras al azar y jugar al crucigrama todas las veces que quieras!',
    'newGame': 'Nueva cuadrícula',
    'generating': 'Preparando la cuadrícula…',
  },
};

const Map<String, dynamic> ar = {
  "nav": {
    "accueil": "الرئيسية",
    "bibliotheque": "الوضع الحر",
    "communaute": "الساحة",
    "profil": "الملف الشخصي",
    "reglages": "الإعدادات",
    "mainNavAria": "التنقل الرئيسي"
  },
  "common": {
    "back": "رجوع",
    "listen": "استماع",
    "stop": "إيقاف",
    "continue": "متابعة",
    "close": "إغلاق",
    "replay": "إعادة",
    "instruction": "التعليمة",
    "settings": "الإعدادات",
    "tryAgain": "حاول مرة أخرى",
    "pointsEarnedAria": "نقاط مكتسبة",
    "next": "التالي",
    "previous": "السابق",
    "backToHome": "العودة إلى الرئيسية",
    "restart": "إعادة البدء"
  },
  "evaluation": {
    "badge": "تقييم",
    "timeLeft": "الوقت المتبقي",
    "finishedTitle": "أحسنت، انتهى التقييم!",
    "finishedMessage": "انتهى الوقت. لقد بذلت جهدًا رائعًا في هذا التقييم.",
    "backToPath": "العودة إلى المسار"
  },
  "mascotPoses": {
    "accueil": "أماني تحييك",
    "demonstration": "أماني تريك إشارة",
    "encouragement": "أماني تشجعك",
    "celebration": "أماني تحتفل بنجاحك",
    "reconfort": "أماني تواسيك",
    "reflexion": "أماني تفكر",
    "veille": "أماني ترتاح"
  },
  "notFound": {
    "title": "404",
    "heading": "الصفحة غير موجودة",
    "body": "الصفحة التي تبحث عنها غير موجودة أو تم نقلها.",
    "goHome": "العودة إلى الرئيسية"
  },
  "errorPage": {
    "heading": "تعذر تحميل هذه الصفحة",
    "body": "حدث خطأ ما من جانبنا. يمكنك إعادة المحاولة أو العودة إلى الرئيسية.",
    "retry": "إعادة المحاولة",
    "goHome": "الرئيسية"
  },
  "welcome": {
    "title": "مرحبًا",
    "heading": "مرحبًا! أنا أماني.",
    "subheading": "هل تريد اللعب معي؟",
    "start": "ابدأ المغامرة",
    "imBack": "ها أنا ذا مجددًا! 🐿️"
  },
  "onboarding": {
    "title": "مرحبًا بك!",
    "subtitle": "أخبرنا من أنت لتبدأ المغامرة",
    "namePlaceholder": "ما اسمك؟",
    "passwordPlaceholder": "كلمة المرور (لملفي الشخصي)",
    "passwordHint": "تحمي كلمة المرور هذه الوصول إلى ملفي الشخصي.",
    "showPassword": "إظهار كلمة المرور",
    "hidePassword": "إخفاء كلمة المرور",
    "languageLabel": "اللغة",
    "start": "ابدأ المغامرة"
  },
  "profileLock": {
    "title": "ملفي الشخصي محمي",
    "subtitle": "أدخل كلمة المرور التي حددتها عند التسجيل للمتابعة.",
    "passwordPlaceholder": "كلمة المرور",
    "wrongPassword": "كلمة مرور خاطئة، حاول مرة أخرى.",
    "unlockButton": "فتح القفل"
  },
  "modeLibre": {
    "title": "الوضع الحر",
    "subtitle": "ارسم وتدرّب بحرية، بلا قيود!",
    "helpText": "اختر نموذجًا إذا أردت الإلهام، ثم ارسمه من الذاكرة على الصفحة الفارغة. امسحه وابدأ من جديد كما تشاء!",
    "tabs": {
      "scribble": "خربشة",
      "sign": "إشارة",
      "letter": "حرف",
      "digit": "رقم",
      "crossword": "الكلمات المتقاطعة"
    },
    "modelLabel": "نموذج",
    "noModelTitle": "ارسم ما تريد!",
    "noModelBody": "دع إصبعك يتجول بحرية على الصفحة.",
    "clear": "مسح",
    "colorLabel": "اللون",
    "canvasAria": "مساحة الرسم الحر",
    "signNames": {
      "trait": "الخط",
      "courbe": "المنحنى",
      "point": "النقطة",
      "crochet": "الخطاف"
    }
  },
  "parcours": {
    "title": "مسار الغصن",
    "subtitle": "اتبع المسار المتعرج وافتح البراعم خطوة بخطوة.",
    "start": "ابدأ",
    "lockedAria": "خطوة مقفلة",
    "bonusAria": "مكافأة إضافية مقفلة",
    "medalAria": "ميدالية نهاية المرحلة",
    "medalDoneAria": "تم الحصول على ميدالية نهاية المرحلة",
    "coursStep": "درس",
    "exerciceStep": "تمرين",
    "crosswordStep": "الكلمات المتقاطعة",
    "paliers": [
      {
        "title": "الإشارات الأساسية",
        "subtitle": "المرحلة 1",
        "tagline": "نقاط، منحنيات، خطاطيف وخطوط"
      },
      {
        "title": "التركيب: الحروف والأرقام",
        "subtitle": "المرحلة 2",
        "tagline": "اجمع الإشارات للكتابة"
      },
      {
        "title": "المقاطع",
        "subtitle": "المرحلة 3",
        "tagline": "اجمع الحروف الساكنة والمتحركة للقراءة"
      },
      {
        "title": "الكلمات",
        "subtitle": "المرحلة 4",
        "tagline": "اربط الحروف ببعضها"
      }
    ]
  },
  "community": {
    "title": "مجتمعنا في الساحة",
    "subtitle": "ترتيب هذا الأسبوع",
    "othersTitle": "البراعم الأخرى",
    "you": "أنا",
    "amaniQuote": "كل واحد ينمو بوتيرته الخاصة، المهم أن تتقدم دائمًا.",
    "amaniLine": "أحسنتم يا براعم الساحة جميعًا!",
    "footnote": "هذا الترتيب خاص بهذا الجهاز فقط.",
    "starsSuffix": "⭐",
    "stumpAria": "جذع المرتبة {rank}"
  },
  "profileHub": {
    "title": "دفتر مستكشفي",
    "subtitle": "واصل هكذا، أنت تتعلم بشكل رائع!",
    "totalPointsLabel": "نقاطي",
    "totalPointsHint": "مكتسبة من إنهاء دروسك وتمارينك",
    "statsSignes": "الإشارات المتقنة",
    "statsExercices": "التمارين المنجزة",
    "statsDays": "أيام المغامرة",
    "progressionTitle": "تقدمي في الغابة",
    "stepsValidated": "من أصل {total} خطوة منجزة",
    "settingsTitle": "إعداداتي",
    "languageCardTitle": "لغة المستكشف",
    "soundCardTitle": "الصوت والحركات",
    "voiceLabel": "صوت أماني",
    "voiceOn": "مفعّل",
    "voiceOff": "معطّل",
    "volumeLabel": "مستوى الصوت",
    "volumeTest": "اختبار مستوى الصوت",
    "volumeTestPhrase": "هكذا يبدو صوتي!",
    "voiceGenderLabel": "نمط الصوت",
    "voiceGenderOptions": [
      {
        "label": "صوت رجل",
        "desc": "دافئ ولطيف"
      },
      {
        "label": "صوت امرأة",
        "desc": "دافئ ولطيف"
      }
    ],
    "voiceGenderTest": "استمع إلى مثال",
    "voiceGenderTestPhrase": "مرحبًا، أنا أماني! هل نواصل التعلم معًا؟",
    "photoTitle": "صورتي الشخصية",
    "photoHint": "ستظهر بجانب اسمك في ترتيب الساحة.",
    "photoChangeAria": "تغيير الصورة الشخصية",
    "photoRemove": "حذف",
    "formatCardTitle": "نمط الكتابة",
    "formatOptions": [
      {
        "label": "مطبوع",
        "desc": "مطبوع"
      },
      {
        "label": "مربوط",
        "desc": "متصل"
      }
    ],
    "exercisesCardTitle": "تمارين الكتابة",
    "evaluationDurationLabel": "مدة التقييم",
    "evaluationDurationHint": "الوقت المخصص لتقييم نهاية المرحلة المحدد بمؤقت",
    "speedLabel": "سرعة التكوين",
    "speedHint": "سرعة الرسم المتحرك الذي يوضح كيفية رسم الإشارة",
    "speedOptions": [
      {
        "label": "بطيئة"
      },
      {
        "label": "عادية"
      },
      {
        "label": "سريعة"
      }
    ],
    "branches": [
      {
        "name": "المرحلة 1: النقاط والمنحنيات"
      },
      {
        "name": "المرحلة 2: الخطاطيف والخطوط"
      },
      {
        "name": "المرحلة 3: التركيب"
      }
    ],
    "lockAction": "قفل ملفي الشخصي",
    "passwordCardTitle": "كلمة مرور ملفي الشخصي",
    "newPasswordPlaceholder": "كلمة مرور جديدة",
    "confirmPasswordPlaceholder": "تأكيد كلمة المرور",
    "passwordMismatch": "كلمتا المرور غير متطابقتين.",
    "passwordTooShort": "يجب أن تحتوي كلمة المرور على {count} أحرف على الأقل.",
    "passwordSaved": "تم تحديث كلمة المرور!",
    "savePassword": "حفظ كلمة المرور"
  },
  "plusScreen": {
    "title": "المزيد من الخيارات",
    "subtitle": "إعدادات عملية أخرى، في متناول يدك."
  },
  "exerciceComplete": {
    "title": "انتهى التمرين!",
    "body": "أحسنت، لقد أنهيت هذا التمرين. ماذا تريد أن تفعل الآن؟"
  },
  "coursScreen": {
    "title": "دروسي",
    "subtitle": "منهج فلوريس غونغ نوتا",
    "intro": "إليك الإشارات الأربع الأساسية لمنهج فلوريس غونغ نوتا. المس بطاقة لاستكشاف جميع أشكالها.",
    "letters": "الحروف والأرقام",
    "lettersSubtitle": "التركيب — من a إلى z، من A إلى Z، من 0 إلى 9",
    "signNames": {
      "trait": "الخط",
      "crochet": "الخطاف",
      "courbe": "المنحنيات",
      "point": "النقطة"
    }
  },
  "coursFamily": {
    "intro": "إليك درس {title}. المس بطاقة في الأسفل لترى كيفية رسم كل شكل.",
    "variantsTitle": "جميع الأشكال",
    "exercer": "تدرّب",
    "passExercices": "الانتقال إلى التمارين ({title})",
    "titles": {
      "point": "النقطة",
      "courbe": "المنحنيات",
      "crochet": "الخطاطيف والخطاطيف المزدوجة",
      "trait": "الخطوط"
    }
  },
  "coursLettres": {
    "title": "الحروف والأرقام",
    "subtitle": "المس حرفًا لترى تركيبته",
    "intro": "الحروف والأرقام. يتكون كل حرف بتجميع الإشارات الأساسية. المس حرفًا لترى تركيبته!",
    "legendSuffix": "الغالب",
    "minusculesTitle": "الحروف الصغيرة (a – z)",
    "minusculesSubtitle": "المصدر: دليل CP1 — تركيبات معتمدة",
    "chiffresTitle": "الأرقام (0 – 9)",
    "chiffresSubtitle": "0–4 معتمدة · 5–9 قيد الاعتماد مع السيد موسى",
    "majusculesTitle": "الحروف الكبيرة (A – Z)",
    "majusculesSubtitle": "⚠️ تركيبات يجب اعتمادها مع السيد موسى قبل الاستخدام التربوي",
    "signeCount": "{count} إشارة",
    "pendingAria": "قيد الاعتماد",
    "viewAria": "عرض تفاصيل {name}"
  },
  "coursLettresChar": {
    "notFound": "غير موجود",
    "backToList": "العودة إلى القائمة",
    "pendingWarning": "هذه التركيبة إعادة بناء بصرية ويجب أن يعتمدها السيد موسى قبل استخدامها في التمارين التربوية.",
    "seenOnLines": "معاينة على الأسطر",
    "formulaTitle": "التركيبة",
    "signeCount": "{count} إشارة · المس إشارة لمعرفة المزيد",
    "result": "النتيجة",
    "adqNote": "ملاحظة: الحروف a وd وq تستخدم نفس تركيبة الإشارات. موضع الخط العمودي (الجسم / الساق العلوية / الساق السفلية) هو ما يميزها، وليس الإشارات نفسها.",
    "practiceLink": "تدرّب في دفتر الكتابة",
    "seeAll": "عرض جميع الحروف",
    "families": {
      "trait": "الخط",
      "courbe": "المنحنى",
      "crochet": "الخطاف",
      "point": "النقطة"
    },
    "variants": {
      "vertical": "عمودي",
      "horizontal": "أفقي",
      "oblique-gauche": "مائل إلى اليسار",
      "oblique-droit": "مائل إلى اليمين",
      "open-right": "مفتوح إلى اليمين (C)",
      "open-left": "مفتوح إلى اليسار (Ɔ)",
      "bridge": "على شكل قنطرة (∩)",
      "bowl": "على شكل حوض (∪)",
      "closed": "مغلق (دائرة كاملة)",
      "top-right": "أعلى اليمين",
      "top-left": "أعلى اليسار",
      "bottom-right": "أسفل اليمين",
      "bottom-left": "أسفل اليسار",
      "center": "وسط"
    },
    "zones": {
      "corps": "الجسم",
      "hampe": "↑ الساق العلوية",
      "jambe": "↓ الساق السفلية"
    }
  },
  "coursFormation": {
    "title": "تكوين الحروف",
    "subtitle": "الجمع بين الإشارات الأساسية",
    "intro": "مرحبًا بك في التركيب! هنا ستتعلم كيفية الجمع بين الإشارات لتكوين الحروف والأرقام.",
    "magicTitle": "سحر التركيب!",
    "magicBody": "يتكون كل حرف بتجميع الإشارات التي تعلمتها: الخطوط، المنحنيات، الخطاطيف والنقاط. المس مجموعة للبدء!",
    "previewTitle": "معاينة",
    "signeCount": "{count} إشارة"
  },
  "coursFormationChar": {
    "notFound": "غير متوفر حاليًا.",
    "backToList": "العودة إلى الدروس",
    "formulaTitle": "التركيبة",
    "vowelsTitle": "الحروف المتحركة",
    "practice": "تدرّب على",
    "families": {
      "trait": "خط",
      "courbe": "منحنى",
      "crochet": "خطاف",
      "point": "نقطة"
    }
  },
  "exerciceIntro": {
    "title": "التمرين التالي",
    "intro": "سنتعرف على الإشارات معًا!",
    "typeLabel": "نوع التمرين",
    "typeValue": "التعرف",
    "typeDesc": "ابحث عن الإشارة الصحيحة ضمن شبكة صغيرة.",
    "previewLabel": "معاينة",
    "start": "ابدأ",
    "demo": "شاهد عرضًا توضيحيًا"
  },
  "exercice": {
    "findPrefix": "ابحث عن",
    "replay": "إعادة الاستماع",
    "helpText": "<b>المنحنى</b> قوس ليّن كالجسر، بلون أخضر.",
    "successTitle": "أحسنت، لقد وجدته!",
    "successBody": "تفتحت برعمة جديدة على غصنك.",
    "tryAgain": "حاول مرة أخرى"
  },
  "exerciceListe": {
    "titleGroup": "الدفتر: {titre}",
    "subtitleGroupLettres": "تدرّب على رسم هذه الحروف",
    "subtitleGroupDigits": "تدرّب على رسم هذه الأرقام",
    "introGroup": "إليك دفتر الكتابة لـ{titre}! اختر حرفًا للتدرب على تكوينه إشارة بإشارة.",
    "groupHint": "المس حرفًا أدناه للتدرب على شبكة سييس مع التحقق من كل حركة!",
    "letterPrefix": "الحرف",
    "digitPrefix": "الرقم",
    "gestureCount": "{count} حركة",
    "title": "دفتر الكتابة",
    "titleFamily": "الدفتر: {titre}",
    "subtitle": "أعد رسم الخط المنقط",
    "introGeneral": "مرحبًا بك في دفتر الكتابة! أعد رسم الخط المنقط متبعًا النقطة الخضراء لتتعلم رسم كل إشارة بشكل صحيح.",
    "repetitionsLabel": "التكرارات لكل إشارة",
    "repetitionsHint": "عدد مرات رسم كل إشارة على السطر",
    "toleranceLabel": "درجة التسامح في التحقق",
    "toleranceHint": "أعلى = أسهل على الأصغر سنًا",
    "startHint": "تشير النقطة الخضراء إلى نقطة البداية. اتبع الخط المنقط مع رفع إصبعك بأقل قدر ممكن.",
    "done": "تم!",
    "rowComplete": "أحسنت! لقد رسمت جميع إشارات هذا السطر. عمل ممتاز!",
    "listenConsigne": "استمع إلى التعليمة: {label}",
    "reducedLabel": "مصغّر",
    "settingsAria": "الإعدادات",
    "backAria": "العودة إلى الرئيسية",
    "familyNames": {
      "point": "نقاط",
      "courbe": "منحنيات",
      "crochet": "خطاطيف",
      "trait": "خطوط"
    }
  },
  "exerciceLettre": {
    "title": "ارسم",
    "stepPrefix": "إشارة",
    "signsReady": "{done}/{total} إشارات جاهزة",
    "practiceStepsTitle": "تدرّب على كل إشارة",
    "practiceStepsHint": "أنجز كل إشارة {reps} مرات قبل كتابة الحرف كاملاً.",
    "finalTitle": "اكتب الحرف كاملاً",
    "finalHint": "ارسم الآن جميع الإشارات تباعًا، كما لو كنت تكتب الحرف الحقيقي.",
    "finalLocked": "أنجز أولاً جميع الإشارات أعلاه لفتح هذه الخطوة.",
    "successAll": "تهانينا! الحرف كامل!",
    "successAllSub": "لقد أتقنت تجميع هذا الحرف.",
    "formulaTitle": "تركيبة",
    "validated": "منجزة",
    "resetAll": "البدء من جديد",
    "reviewCourse": "مراجعة الدرس",
    "notFound": "غير موجود.",
    "backToNotebook": "العودة إلى الدفتر",
    "successTitle": "رائع!",
    "successBody": "أصبحت الآن تعرف كتابة",
    "nextLetter": "الحرف التالي",
    "practiceAgain": "تدرّب مرة أخرى",
    "backToNotebookLink": "العودة إلى دفتر الكتابة",
    "speakStart": "تدرّب على الحرف {name}.",
    "speakNextStep": "رائع! انتقل الآن إلى الإشارة التالية.",
    "speakLetterDone": "أحسنت! لقد كوّنت الحرف {name} بشكل مثالي!",
    "speakRetryStep": "تقريبًا! أعد المحاولة في هذه الحركة فقط: {desc}",
    "speakReset": "لنبدأ الحرف {name} من جديد."
  },
  "coursSyllabes": {
    "title": "المقاطع",
    "subtitle": "اجمع الحروف للقراءة",
    "notFound": "غير متوفر حاليًا.",
    "backToList": "العودة إلى المسار",
    "consonantTitle": "مقاطع مع «{consonant}»",
    "syllableCount": "{count} مقطع",
    "formingLabel": "{consonant} + {vowel} = {syllable}",
    "exampleWordLabel": "كلمة تحتوي على «{syllable}»",
    "speakFormation": "{consonant}... {vowel}... {syllable}!",
    "practice": "تدرّب على هذه المقاطع",
    "nextConsonant": "الحرف الساكن التالي: {consonant}"
  },
  "exerciceSyllabes": {
    "title": "ارسم",
    "syllablesReady": "{done}/{total} مقاطع مرسومة",
    "introTitle": "اكتب كل مقطع",
    "introBody": "ارسم الحرف الساكن ثم المتحرك لتكوين كل مقطع.",
    "allDoneTitle": "أحسنت، جميع المقاطع مرسومة!",
    "allDoneBody": "لقد أتقنت مقاطع هذا الحرف الساكن.",
    "nextGroup": "الحرف الساكن التالي: {consonant}",
    "exampleWordPrefix": "كما في"
  },
  "coursMots": {
    "notFound": "غير متوفر حاليًا.",
    "backToList": "العودة إلى الرئيسية",
    "wordCount": "{count} كلمة لاكتشافها",
    "introSpeak": "إليك درس {titre}. المس الكلمة لسماعها.",
    "introTitle": "استمع وشاهد كل كلمة",
    "introBody": "كل كلمة مكتوبة بالفعل بالحروف التي تعرفها. المس الكلمة لسماعها، أو المس الدمبل للتدرّب عليها!",
    "practiceGroup": "تدرّب على {titre}",
    "practiceWordAria": "تدرّب على «{mot}»"
  },
  "exerciceMots": {
    "wordsReady": "{done}/{total} كلمات مكتوبة",
    "introTitle": "اكتب كل كلمة",
    "introBody": "ارسم الحروف بالترتيب لتكوين كل كلمة.",
    "allDoneTitle": "أحسنت، جميع الكلمات مكتوبة!",
    "allDoneBody": "لقد أتقنت هذه المجموعة من الكلمات.",
    "nextGroup": "المجموعة التالية: {titre}"
  },
  "motsCroises": {
    "title": "الكلمات المتقاطعة",
    "subtitle": "أكمل الشبكة حرفًا بحرف",
    "levelSubtitle": "المستوى {level} · {count} كلمات",
    "hintTitle": "استمع ثم أكمل",
    "hintBody": "استمع إلى كل كلمة أدناه وارسم حروفها في الشبكة، تمامًا كالكلمات المتقاطعة الحقيقية!",
    "doneTitle": "اكتملت الشبكة!",
    "doneBody": "أحسنت، لقد حللت هذه الكلمات المتقاطعة.",
    "across": "أفقي",
    "down": "عمودي",
    "featuredTitle": "اكتملت الشبكة، أحسنت!",
    "featuredBody": "لقد كتبت ونطقت جميع الكلمات! إليك الكلمة المميزة:",
    "continueLabel": "متابعة",
    "generationFailed": "تعذر إنشاء هذه الشبكة، حاول مرة أخرى.",
    "wordsFoundLabel": "{solved} من أصل {total} كلمات موجودة"
  },
  "modeLibreCroises": {
    "title": "الكلمات المتقاطعة",
    "subtitle": "شبكة جديدة في كل مرة",
    "intro": "المس «شبكة جديدة» لسحب كلمات عشوائية واللعب بالكلمات المتقاطعة كما تشاء!",
    "newGame": "شبكة جديدة",
    "generating": "جارٍ تحضير الشبكة…"
  }
};
