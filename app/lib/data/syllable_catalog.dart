import 'dart:convert';

/// PALIER "Les syllabes" — entre les lettres (Palier 2) et les mots (Palier 4).
/// Méthode syllabique classique : consonne + voyelle = syllabe (ex. "b + a = ba").
/// Disponible en français uniquement (pédagogie de lecture spécifique au français) —
/// voir le filtre par langue dans parcours_screen.dart. Port fidèle de
/// `src/data/syllable-catalog.ts`.
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
        "exampleWord": "banane"
      },
      {
        "syllable": "be",
        "consonant": "b",
        "vowel": "e",
        "exampleWord": "bebe"
      },
      {
        "syllable": "bi",
        "consonant": "b",
        "vowel": "i",
        "exampleWord": "biche"
      },
      {
        "syllable": "bo",
        "consonant": "b",
        "vowel": "o",
        "exampleWord": "bobo"
      },
      {
        "syllable": "bu",
        "consonant": "b",
        "vowel": "u",
        "exampleWord": "bulle"
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
        "exampleWord": "canard"
      },
      {
        "syllable": "ce",
        "consonant": "c",
        "vowel": "e",
        "exampleWord": "cerise"
      },
      {
        "syllable": "ci",
        "consonant": "c",
        "vowel": "i",
        "exampleWord": "citron"
      },
      {
        "syllable": "co",
        "consonant": "c",
        "vowel": "o",
        "exampleWord": "coco"
      },
      {
        "syllable": "cu",
        "consonant": "c",
        "vowel": "u",
        "exampleWord": "cube"
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
        "exampleWord": "dada"
      },
      {
        "syllable": "de",
        "consonant": "d",
        "vowel": "e",
        "exampleWord": "dent"
      },
      {
        "syllable": "di",
        "consonant": "d",
        "vowel": "i",
        "exampleWord": "dix"
      },
      {
        "syllable": "do",
        "consonant": "d",
        "vowel": "o",
        "exampleWord": "dodo"
      },
      {
        "syllable": "du",
        "consonant": "d",
        "vowel": "u",
        "exampleWord": "dune"
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
        "exampleWord": "face"
      },
      {
        "syllable": "fe",
        "consonant": "f",
        "vowel": "e",
        "exampleWord": "fee"
      },
      {
        "syllable": "fi",
        "consonant": "f",
        "vowel": "i",
        "exampleWord": "fil"
      },
      {
        "syllable": "fo",
        "consonant": "f",
        "vowel": "o",
        "exampleWord": "fort"
      },
      {
        "syllable": "fu",
        "consonant": "f",
        "vowel": "u",
        "exampleWord": "fume"
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
        "exampleWord": "gare"
      },
      {
        "syllable": "ge",
        "consonant": "g",
        "vowel": "e",
        "exampleWord": "genou"
      },
      {
        "syllable": "gi",
        "consonant": "g",
        "vowel": "i",
        "exampleWord": "girafe"
      },
      {
        "syllable": "go",
        "consonant": "g",
        "vowel": "o",
        "exampleWord": "gomme"
      },
      {
        "syllable": "gu",
        "consonant": "g",
        "vowel": "u",
        "exampleWord": "legume"
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
        "exampleWord": "habit"
      },
      {
        "syllable": "he",
        "consonant": "h",
        "vowel": "e",
        "exampleWord": "herbe"
      },
      {
        "syllable": "hi",
        "consonant": "h",
        "vowel": "i",
        "exampleWord": "hibou"
      },
      {
        "syllable": "ho",
        "consonant": "h",
        "vowel": "o",
        "exampleWord": "homme"
      },
      {
        "syllable": "hu",
        "consonant": "h",
        "vowel": "u",
        "exampleWord": "huile"
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
        "exampleWord": "jambe"
      },
      {
        "syllable": "je",
        "consonant": "j",
        "vowel": "e",
        "exampleWord": "jeu"
      },
      {
        "syllable": "jo",
        "consonant": "j",
        "vowel": "o",
        "exampleWord": "joue"
      },
      {
        "syllable": "ju",
        "consonant": "j",
        "vowel": "u",
        "exampleWord": "jupe"
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
        "exampleWord": "kayak"
      },
      {
        "syllable": "ki",
        "consonant": "k",
        "vowel": "i",
        "exampleWord": "kiwi"
      },
      {
        "syllable": "ko",
        "consonant": "k",
        "vowel": "o",
        "exampleWord": "koala"
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
        "exampleWord": "lama"
      },
      {
        "syllable": "le",
        "consonant": "l",
        "vowel": "e",
        "exampleWord": "lettre"
      },
      {
        "syllable": "li",
        "consonant": "l",
        "vowel": "i",
        "exampleWord": "lion"
      },
      {
        "syllable": "lo",
        "consonant": "l",
        "vowel": "o",
        "exampleWord": "loup"
      },
      {
        "syllable": "lu",
        "consonant": "l",
        "vowel": "u",
        "exampleWord": "lune"
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
        "exampleWord": "maman"
      },
      {
        "syllable": "me",
        "consonant": "m",
        "vowel": "e",
        "exampleWord": "melon"
      },
      {
        "syllable": "mi",
        "consonant": "m",
        "vowel": "i",
        "exampleWord": "midi"
      },
      {
        "syllable": "mo",
        "consonant": "m",
        "vowel": "o",
        "exampleWord": "moto"
      },
      {
        "syllable": "mu",
        "consonant": "m",
        "vowel": "u",
        "exampleWord": "mur"
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
        "exampleWord": "natte"
      },
      {
        "syllable": "ne",
        "consonant": "n",
        "vowel": "e",
        "exampleWord": "neige"
      },
      {
        "syllable": "ni",
        "consonant": "n",
        "vowel": "i",
        "exampleWord": "nid"
      },
      {
        "syllable": "no",
        "consonant": "n",
        "vowel": "o",
        "exampleWord": "note"
      },
      {
        "syllable": "nu",
        "consonant": "n",
        "vowel": "u",
        "exampleWord": "nuit"
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
        "exampleWord": "papa"
      },
      {
        "syllable": "pe",
        "consonant": "p",
        "vowel": "e",
        "exampleWord": "petit"
      },
      {
        "syllable": "pi",
        "consonant": "p",
        "vowel": "i",
        "exampleWord": "pile"
      },
      {
        "syllable": "po",
        "consonant": "p",
        "vowel": "o",
        "exampleWord": "pomme"
      },
      {
        "syllable": "pu",
        "consonant": "p",
        "vowel": "u",
        "exampleWord": "pull"
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
        "exampleWord": "quatre"
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
        "exampleWord": "radis"
      },
      {
        "syllable": "re",
        "consonant": "r",
        "vowel": "e",
        "exampleWord": "renard"
      },
      {
        "syllable": "ri",
        "consonant": "r",
        "vowel": "i",
        "exampleWord": "riz"
      },
      {
        "syllable": "ro",
        "consonant": "r",
        "vowel": "o",
        "exampleWord": "robe"
      },
      {
        "syllable": "ru",
        "consonant": "r",
        "vowel": "u",
        "exampleWord": "rue"
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
        "exampleWord": "salade"
      },
      {
        "syllable": "se",
        "consonant": "s",
        "vowel": "e",
        "exampleWord": "sel"
      },
      {
        "syllable": "si",
        "consonant": "s",
        "vowel": "i",
        "exampleWord": "singe"
      },
      {
        "syllable": "so",
        "consonant": "s",
        "vowel": "o",
        "exampleWord": "soleil"
      },
      {
        "syllable": "su",
        "consonant": "s",
        "vowel": "u",
        "exampleWord": "sucre"
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
        "exampleWord": "tasse"
      },
      {
        "syllable": "te",
        "consonant": "t",
        "vowel": "e",
        "exampleWord": "tete"
      },
      {
        "syllable": "ti",
        "consonant": "t",
        "vowel": "i",
        "exampleWord": "tigre"
      },
      {
        "syllable": "to",
        "consonant": "t",
        "vowel": "o",
        "exampleWord": "toto"
      },
      {
        "syllable": "tu",
        "consonant": "t",
        "vowel": "u",
        "exampleWord": "tulipe"
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
        "exampleWord": "vache"
      },
      {
        "syllable": "ve",
        "consonant": "v",
        "vowel": "e",
        "exampleWord": "verre"
      },
      {
        "syllable": "vi",
        "consonant": "v",
        "vowel": "i",
        "exampleWord": "vite"
      },
      {
        "syllable": "vo",
        "consonant": "v",
        "vowel": "o",
        "exampleWord": "voile"
      },
      {
        "syllable": "vu",
        "consonant": "v",
        "vowel": "u",
        "exampleWord": "vue"
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
        "exampleWord": "wagon"
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
        "exampleWord": "yaourt"
      },
      {
        "syllable": "ye",
        "consonant": "y",
        "vowel": "e",
        "exampleWord": "yeux"
      },
      {
        "syllable": "yo",
        "consonant": "y",
        "vowel": "o",
        "exampleWord": "yoyo"
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
        "exampleWord": "pizza"
      },
      {
        "syllable": "ze",
        "consonant": "z",
        "vowel": "e",
        "exampleWord": "zero"
      },
      {
        "syllable": "zo",
        "consonant": "z",
        "vowel": "o",
        "exampleWord": "zoo"
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
