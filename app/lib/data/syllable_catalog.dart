// Nommage SCREAMING_SNAKE_CASE volontaire (miroir 1:1 du module TypeScript
// source) — voir `calcul_catalog.dart` pour l'explication complète.
// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:convert';

/// PALIER "Les syllabes" — entre les lettres (Palier 2) et les mots (Palier 4).
/// Méthode syllabique classique : consonne + voyelle = syllabe (ex. "b + a = ba").
/// Les syllabes elles-mêmes restent en alphabet latin dans les 4 langues de
/// l'app (l'infrastructure de traçage ne connaît que a-z/A-Z, voir
/// `letter_formation_catalog.dart`) : seul `exampleWord` varie par langue
/// (`fr`/`en`/`es`, plus `frSpoken` quand la version accentuée correcte
/// diffère de l'orthographe non accentuée utilisée pour le traçage lettre
/// par lettre -- voir `cours_syllabes_screen.dart`). L'arabe réutilise le
/// mot français (`fr`) : mêmes syllabes que le français, narrées en arabe --
/// même principe que `WordEntry.text('ar')` dans `word_catalog.dart`. Port
/// fidèle de `src/data/syllable-catalog.ts`, étendu pour le multi-langue.
final List<dynamic> SYLLABLE_GROUPS = jsonDecode(r'''
[
  {
    "id": "syl-b",
    "consonant": "b",
    "syllables": [
      {
        "syllable": "ba",
        "consonant": "b",
        "vowel": "a",
        "exampleWord": {
          "fr": "banane",
          "en": "banana",
          "es": "banana"
        }
      },
      {
        "syllable": "be",
        "consonant": "b",
        "vowel": "e",
        "exampleWord": {
          "fr": "bebe",
          "en": "bed",
          "es": "bebe",
          "frSpoken": "bébé"
        }
      },
      {
        "syllable": "bi",
        "consonant": "b",
        "vowel": "i",
        "exampleWord": {
          "fr": "biche",
          "en": "bib",
          "es": "bicho"
        }
      },
      {
        "syllable": "bo",
        "consonant": "b",
        "vowel": "o",
        "exampleWord": {
          "fr": "bobo",
          "en": "box",
          "es": "bota"
        }
      },
      {
        "syllable": "bu",
        "consonant": "b",
        "vowel": "u",
        "exampleWord": {
          "fr": "bulle",
          "en": "bus",
          "es": "burro"
        }
      }
    ]
  },
  {
    "id": "syl-c",
    "consonant": "c",
    "syllables": [
      {
        "syllable": "ca",
        "consonant": "c",
        "vowel": "a",
        "exampleWord": {
          "fr": "canard",
          "en": "cat",
          "es": "casa"
        }
      },
      {
        "syllable": "ce",
        "consonant": "c",
        "vowel": "e",
        "exampleWord": {
          "fr": "cerise",
          "en": "cent",
          "es": "cereza"
        }
      },
      {
        "syllable": "ci",
        "consonant": "c",
        "vowel": "i",
        "exampleWord": {
          "fr": "citron",
          "en": "city",
          "es": "cinco"
        }
      },
      {
        "syllable": "co",
        "consonant": "c",
        "vowel": "o",
        "exampleWord": {
          "fr": "coco",
          "en": "corn",
          "es": "coco"
        }
      },
      {
        "syllable": "cu",
        "consonant": "c",
        "vowel": "u",
        "exampleWord": {
          "fr": "cube",
          "en": "cup",
          "es": "cuna"
        }
      }
    ]
  },
  {
    "id": "syl-d",
    "consonant": "d",
    "syllables": [
      {
        "syllable": "da",
        "consonant": "d",
        "vowel": "a",
        "exampleWord": {
          "fr": "dada",
          "en": "dad",
          "es": "dado"
        }
      },
      {
        "syllable": "de",
        "consonant": "d",
        "vowel": "e",
        "exampleWord": {
          "fr": "dent",
          "en": "desk",
          "es": "dedo"
        }
      },
      {
        "syllable": "di",
        "consonant": "d",
        "vowel": "i",
        "exampleWord": {
          "fr": "dix",
          "en": "dig",
          "es": "diez"
        }
      },
      {
        "syllable": "do",
        "consonant": "d",
        "vowel": "o",
        "exampleWord": {
          "fr": "dodo",
          "en": "dog",
          "es": "dos"
        }
      },
      {
        "syllable": "du",
        "consonant": "d",
        "vowel": "u",
        "exampleWord": {
          "fr": "dune",
          "en": "duck",
          "es": "duna"
        }
      }
    ]
  },
  {
    "id": "syl-f",
    "consonant": "f",
    "syllables": [
      {
        "syllable": "fa",
        "consonant": "f",
        "vowel": "a",
        "exampleWord": {
          "fr": "face",
          "en": "fan",
          "es": "falda"
        }
      },
      {
        "syllable": "fe",
        "consonant": "f",
        "vowel": "e",
        "exampleWord": {
          "fr": "fee",
          "en": "fence",
          "es": "fecha",
          "frSpoken": "fée"
        }
      },
      {
        "syllable": "fi",
        "consonant": "f",
        "vowel": "i",
        "exampleWord": {
          "fr": "fil",
          "en": "fish",
          "es": "figura"
        }
      },
      {
        "syllable": "fo",
        "consonant": "f",
        "vowel": "o",
        "exampleWord": {
          "fr": "fort",
          "en": "fox",
          "es": "foca"
        }
      },
      {
        "syllable": "fu",
        "consonant": "f",
        "vowel": "u",
        "exampleWord": {
          "fr": "fume",
          "en": "fun",
          "es": "fuego"
        }
      }
    ]
  },
  {
    "id": "syl-g",
    "consonant": "g",
    "syllables": [
      {
        "syllable": "ga",
        "consonant": "g",
        "vowel": "a",
        "exampleWord": {
          "fr": "gare",
          "en": "gap",
          "es": "gato"
        }
      },
      {
        "syllable": "ge",
        "consonant": "g",
        "vowel": "e",
        "exampleWord": {
          "fr": "genou",
          "en": "gem",
          "es": "gente"
        }
      },
      {
        "syllable": "gi",
        "consonant": "g",
        "vowel": "i",
        "exampleWord": {
          "fr": "girafe",
          "en": "gift",
          "es": "gigante"
        }
      },
      {
        "syllable": "go",
        "consonant": "g",
        "vowel": "o",
        "exampleWord": {
          "fr": "gomme",
          "en": "got",
          "es": "goma"
        }
      },
      {
        "syllable": "gu",
        "consonant": "g",
        "vowel": "u",
        "exampleWord": {
          "fr": "legume",
          "en": "gum",
          "es": "guante",
          "frSpoken": "légume"
        }
      }
    ]
  },
  {
    "id": "syl-h",
    "consonant": "h",
    "syllables": [
      {
        "syllable": "ha",
        "consonant": "h",
        "vowel": "a",
        "exampleWord": {
          "fr": "habit",
          "en": "hat",
          "es": "hamaca"
        }
      },
      {
        "syllable": "he",
        "consonant": "h",
        "vowel": "e",
        "exampleWord": {
          "fr": "herbe",
          "en": "hen",
          "es": "helado"
        }
      },
      {
        "syllable": "hi",
        "consonant": "h",
        "vowel": "i",
        "exampleWord": {
          "fr": "hibou",
          "en": "hill",
          "es": "hilo"
        }
      },
      {
        "syllable": "ho",
        "consonant": "h",
        "vowel": "o",
        "exampleWord": {
          "fr": "homme",
          "en": "hot",
          "es": "hoja"
        }
      },
      {
        "syllable": "hu",
        "consonant": "h",
        "vowel": "u",
        "exampleWord": {
          "fr": "huile",
          "en": "hug",
          "es": "huevo"
        }
      }
    ]
  },
  {
    "id": "syl-j",
    "consonant": "j",
    "syllables": [
      {
        "syllable": "ja",
        "consonant": "j",
        "vowel": "a",
        "exampleWord": {
          "fr": "jambe",
          "en": "jam",
          "es": "jabon"
        }
      },
      {
        "syllable": "je",
        "consonant": "j",
        "vowel": "e",
        "exampleWord": {
          "fr": "jeu",
          "en": "jet",
          "es": "jefe"
        }
      },
      {
        "syllable": "jo",
        "consonant": "j",
        "vowel": "o",
        "exampleWord": {
          "fr": "joue",
          "en": "job",
          "es": "joya"
        }
      },
      {
        "syllable": "ju",
        "consonant": "j",
        "vowel": "u",
        "exampleWord": {
          "fr": "jupe",
          "en": "jug",
          "es": "jugo"
        }
      }
    ]
  },
  {
    "id": "syl-k",
    "consonant": "k",
    "syllables": [
      {
        "syllable": "ka",
        "consonant": "k",
        "vowel": "a",
        "exampleWord": {
          "fr": "kayak",
          "en": "kayak",
          "es": "kayak"
        }
      },
      {
        "syllable": "ki",
        "consonant": "k",
        "vowel": "i",
        "exampleWord": {
          "fr": "kiwi",
          "en": "kiwi",
          "es": "kiwi"
        }
      },
      {
        "syllable": "ko",
        "consonant": "k",
        "vowel": "o",
        "exampleWord": {
          "fr": "koala",
          "en": "koala",
          "es": "koala"
        }
      }
    ]
  },
  {
    "id": "syl-l",
    "consonant": "l",
    "syllables": [
      {
        "syllable": "la",
        "consonant": "l",
        "vowel": "a",
        "exampleWord": {
          "fr": "lama",
          "en": "lamp",
          "es": "lama"
        }
      },
      {
        "syllable": "le",
        "consonant": "l",
        "vowel": "e",
        "exampleWord": {
          "fr": "lettre",
          "en": "leg",
          "es": "leche"
        }
      },
      {
        "syllable": "li",
        "consonant": "l",
        "vowel": "i",
        "exampleWord": {
          "fr": "lion",
          "en": "lid",
          "es": "libro"
        }
      },
      {
        "syllable": "lo",
        "consonant": "l",
        "vowel": "o",
        "exampleWord": {
          "fr": "loup",
          "en": "log",
          "es": "lobo"
        }
      },
      {
        "syllable": "lu",
        "consonant": "l",
        "vowel": "u",
        "exampleWord": {
          "fr": "lune",
          "en": "lung",
          "es": "luna"
        }
      }
    ]
  },
  {
    "id": "syl-m",
    "consonant": "m",
    "syllables": [
      {
        "syllable": "ma",
        "consonant": "m",
        "vowel": "a",
        "exampleWord": {
          "fr": "maman",
          "en": "map",
          "es": "mano"
        }
      },
      {
        "syllable": "me",
        "consonant": "m",
        "vowel": "e",
        "exampleWord": {
          "fr": "melon",
          "en": "melon",
          "es": "melon"
        }
      },
      {
        "syllable": "mi",
        "consonant": "m",
        "vowel": "i",
        "exampleWord": {
          "fr": "midi",
          "en": "milk",
          "es": "miel"
        }
      },
      {
        "syllable": "mo",
        "consonant": "m",
        "vowel": "o",
        "exampleWord": {
          "fr": "moto",
          "en": "mop",
          "es": "mono"
        }
      },
      {
        "syllable": "mu",
        "consonant": "m",
        "vowel": "u",
        "exampleWord": {
          "fr": "mur",
          "en": "mud",
          "es": "muneca"
        }
      }
    ]
  },
  {
    "id": "syl-n",
    "consonant": "n",
    "syllables": [
      {
        "syllable": "na",
        "consonant": "n",
        "vowel": "a",
        "exampleWord": {
          "fr": "natte",
          "en": "nap",
          "es": "nariz"
        }
      },
      {
        "syllable": "ne",
        "consonant": "n",
        "vowel": "e",
        "exampleWord": {
          "fr": "neige",
          "en": "net",
          "es": "negro"
        }
      },
      {
        "syllable": "ni",
        "consonant": "n",
        "vowel": "i",
        "exampleWord": {
          "fr": "nid",
          "en": "nine",
          "es": "nido"
        }
      },
      {
        "syllable": "no",
        "consonant": "n",
        "vowel": "o",
        "exampleWord": {
          "fr": "note",
          "en": "nose",
          "es": "noche"
        }
      },
      {
        "syllable": "nu",
        "consonant": "n",
        "vowel": "u",
        "exampleWord": {
          "fr": "nuit",
          "en": "nut",
          "es": "nube"
        }
      }
    ]
  },
  {
    "id": "syl-p",
    "consonant": "p",
    "syllables": [
      {
        "syllable": "pa",
        "consonant": "p",
        "vowel": "a",
        "exampleWord": {
          "fr": "papa",
          "en": "panda",
          "es": "pato"
        }
      },
      {
        "syllable": "pe",
        "consonant": "p",
        "vowel": "e",
        "exampleWord": {
          "fr": "petit",
          "en": "pen",
          "es": "pelota"
        }
      },
      {
        "syllable": "pi",
        "consonant": "p",
        "vowel": "i",
        "exampleWord": {
          "fr": "pile",
          "en": "pig",
          "es": "pie"
        }
      },
      {
        "syllable": "po",
        "consonant": "p",
        "vowel": "o",
        "exampleWord": {
          "fr": "pomme",
          "en": "pot",
          "es": "polo"
        }
      },
      {
        "syllable": "pu",
        "consonant": "p",
        "vowel": "u",
        "exampleWord": {
          "fr": "pull",
          "en": "pup",
          "es": "puerta"
        }
      }
    ]
  },
  {
    "id": "syl-q",
    "consonant": "q",
    "syllables": [
      {
        "syllable": "qu",
        "consonant": "q",
        "vowel": "u",
        "exampleWord": {
          "fr": "quatre",
          "en": "queen",
          "es": "queso"
        }
      }
    ]
  },
  {
    "id": "syl-r",
    "consonant": "r",
    "syllables": [
      {
        "syllable": "ra",
        "consonant": "r",
        "vowel": "a",
        "exampleWord": {
          "fr": "radis",
          "en": "rat",
          "es": "rana"
        }
      },
      {
        "syllable": "re",
        "consonant": "r",
        "vowel": "e",
        "exampleWord": {
          "fr": "renard",
          "en": "red",
          "es": "regalo"
        }
      },
      {
        "syllable": "ri",
        "consonant": "r",
        "vowel": "i",
        "exampleWord": {
          "fr": "riz",
          "en": "rib",
          "es": "rio"
        }
      },
      {
        "syllable": "ro",
        "consonant": "r",
        "vowel": "o",
        "exampleWord": {
          "fr": "robe",
          "en": "rock",
          "es": "robot"
        }
      },
      {
        "syllable": "ru",
        "consonant": "r",
        "vowel": "u",
        "exampleWord": {
          "fr": "rue",
          "en": "rug",
          "es": "rueda"
        }
      }
    ]
  },
  {
    "id": "syl-s",
    "consonant": "s",
    "syllables": [
      {
        "syllable": "sa",
        "consonant": "s",
        "vowel": "a",
        "exampleWord": {
          "fr": "salade",
          "en": "sand",
          "es": "sapo"
        }
      },
      {
        "syllable": "se",
        "consonant": "s",
        "vowel": "e",
        "exampleWord": {
          "fr": "sel",
          "en": "six",
          "es": "seis"
        }
      },
      {
        "syllable": "si",
        "consonant": "s",
        "vowel": "i",
        "exampleWord": {
          "fr": "singe",
          "en": "sit",
          "es": "silla"
        }
      },
      {
        "syllable": "so",
        "consonant": "s",
        "vowel": "o",
        "exampleWord": {
          "fr": "soleil",
          "en": "sock",
          "es": "sol"
        }
      },
      {
        "syllable": "su",
        "consonant": "s",
        "vowel": "u",
        "exampleWord": {
          "fr": "sucre",
          "en": "sun",
          "es": "suma"
        }
      }
    ]
  },
  {
    "id": "syl-t",
    "consonant": "t",
    "syllables": [
      {
        "syllable": "ta",
        "consonant": "t",
        "vowel": "a",
        "exampleWord": {
          "fr": "tasse",
          "en": "tap",
          "es": "taza"
        }
      },
      {
        "syllable": "te",
        "consonant": "t",
        "vowel": "e",
        "exampleWord": {
          "fr": "tete",
          "en": "ten",
          "es": "techo",
          "frSpoken": "tête"
        }
      },
      {
        "syllable": "ti",
        "consonant": "t",
        "vowel": "i",
        "exampleWord": {
          "fr": "tigre",
          "en": "tiger",
          "es": "tigre"
        }
      },
      {
        "syllable": "to",
        "consonant": "t",
        "vowel": "o",
        "exampleWord": {
          "fr": "toto",
          "en": "top",
          "es": "tomate"
        }
      },
      {
        "syllable": "tu",
        "consonant": "t",
        "vowel": "u",
        "exampleWord": {
          "fr": "tulipe",
          "en": "tub",
          "es": "tubo"
        }
      }
    ]
  },
  {
    "id": "syl-v",
    "consonant": "v",
    "syllables": [
      {
        "syllable": "va",
        "consonant": "v",
        "vowel": "a",
        "exampleWord": {
          "fr": "vache",
          "en": "van",
          "es": "vaca"
        }
      },
      {
        "syllable": "ve",
        "consonant": "v",
        "vowel": "e",
        "exampleWord": {
          "fr": "verre",
          "en": "vet",
          "es": "vela"
        }
      },
      {
        "syllable": "vi",
        "consonant": "v",
        "vowel": "i",
        "exampleWord": {
          "fr": "vite",
          "en": "vine",
          "es": "vibora"
        }
      },
      {
        "syllable": "vo",
        "consonant": "v",
        "vowel": "o",
        "exampleWord": {
          "fr": "voile",
          "en": "voice",
          "es": "volcan"
        }
      },
      {
        "syllable": "vu",
        "consonant": "v",
        "vowel": "u",
        "exampleWord": {
          "fr": "vue",
          "en": "vulture",
          "es": "vuelo"
        }
      }
    ]
  },
  {
    "id": "syl-w",
    "consonant": "w",
    "syllables": [
      {
        "syllable": "wa",
        "consonant": "w",
        "vowel": "a",
        "exampleWord": {
          "fr": "wagon",
          "en": "wagon",
          "es": "wafle"
        }
      }
    ]
  },
  {
    "id": "syl-y",
    "consonant": "y",
    "syllables": [
      {
        "syllable": "ya",
        "consonant": "y",
        "vowel": "a",
        "exampleWord": {
          "fr": "yaourt",
          "en": "yarn",
          "es": "yate"
        }
      },
      {
        "syllable": "ye",
        "consonant": "y",
        "vowel": "e",
        "exampleWord": {
          "fr": "yeux",
          "en": "yellow",
          "es": "yeso"
        }
      },
      {
        "syllable": "yo",
        "consonant": "y",
        "vowel": "o",
        "exampleWord": {
          "fr": "yoyo",
          "en": "yoyo",
          "es": "yogur"
        }
      }
    ]
  },
  {
    "id": "syl-z",
    "consonant": "z",
    "syllables": [
      {
        "syllable": "za",
        "consonant": "z",
        "vowel": "a",
        "exampleWord": {
          "fr": "pizza",
          "en": "pizza",
          "es": "pizza"
        }
      },
      {
        "syllable": "ze",
        "consonant": "z",
        "vowel": "e",
        "exampleWord": {
          "fr": "zero",
          "en": "zebra",
          "es": "cebra",
          "frSpoken": "zéro"
        }
      },
      {
        "syllable": "zo",
        "consonant": "z",
        "vowel": "o",
        "exampleWord": {
          "fr": "zoo",
          "en": "zoo",
          "es": "zoo"
        }
      }
    ]
  }
]
''');

final Map<String, dynamic> SYLLABLE_GROUP_MAP = {
  for (final g in SYLLABLE_GROUPS) g['id'] as String: g,
};

/// Retrouve le groupe de syllabes pour une consonne donnée (ex: "b" -> groupe "syl-b").
Map<String, dynamic>? findSyllableGroupForConsonant(String consonant) {
  return SYLLABLE_GROUP_MAP['syl-$consonant'] as Map<String, dynamic>?;
}
