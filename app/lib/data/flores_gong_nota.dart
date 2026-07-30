import 'dart:convert';
import 'package:flutter/material.dart';

final List<dynamic> MINUSCULES = jsonDecode(r'''
[
  {
    "caractere": "a",
    "nom": {
      "fr": "a minuscule",
      "en": "lowercase a"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "courbe",
        "variante": "open-right",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "b",
    "nom": {
      "fr": "b minuscule",
      "en": "lowercase b"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      },
      {
        "famille": "courbe",
        "variante": "open-left",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "c",
    "nom": {
      "fr": "c minuscule",
      "en": "lowercase c"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "courbe",
        "variante": "open-right",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "d",
    "nom": {
      "fr": "d minuscule",
      "en": "lowercase d"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "courbe",
        "variante": "open-right",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      }
    ],
    "validee": true
  },
  {
    "caractere": "e",
    "nom": {
      "fr": "e minuscule",
      "en": "lowercase e"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "corps"
      },
      {
        "famille": "courbe",
        "variante": "open-right",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "f",
    "nom": {
      "fr": "f minuscule",
      "en": "lowercase f"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "crochet",
        "variante": "top-right",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "g",
    "nom": {
      "fr": "g minuscule",
      "en": "lowercase g"
    },
    "zone": "jambe",
    "signes": [
      {
        "famille": "courbe",
        "variante": "open-right",
        "zone": "corps"
      },
      {
        "famille": "crochet",
        "variante": "bottom-left",
        "zone": "jambe"
      }
    ],
    "validee": true
  },
  {
    "caractere": "h",
    "nom": {
      "fr": "h minuscule",
      "en": "lowercase h"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      },
      {
        "famille": "crochet",
        "variante": "top-left",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "i",
    "nom": {
      "fr": "i minuscule",
      "en": "lowercase i"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "corps"
      },
      {
        "famille": "point",
        "variante": "center",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "j",
    "nom": {
      "fr": "j minuscule",
      "en": "lowercase j"
    },
    "zone": "jambe",
    "signes": [
      {
        "famille": "crochet",
        "variante": "bottom-left",
        "zone": "jambe"
      },
      {
        "famille": "point",
        "variante": "center",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "k",
    "nom": {
      "fr": "k minuscule",
      "en": "lowercase k"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "oblique-droit",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "l",
    "nom": {
      "fr": "l minuscule",
      "en": "lowercase l"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      }
    ],
    "validee": true
  },
  {
    "caractere": "m",
    "nom": {
      "fr": "m minuscule",
      "en": "lowercase m"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "corps"
      },
      {
        "famille": "crochet",
        "variante": "top-left",
        "zone": "corps"
      },
      {
        "famille": "crochet",
        "variante": "top-left",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "n",
    "nom": {
      "fr": "n minuscule",
      "en": "lowercase n"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "corps"
      },
      {
        "famille": "crochet",
        "variante": "top-left",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "o",
    "nom": {
      "fr": "o minuscule",
      "en": "lowercase o"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "courbe",
        "variante": "closed",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "p",
    "nom": {
      "fr": "p minuscule",
      "en": "lowercase p"
    },
    "zone": "jambe",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "jambe"
      },
      {
        "famille": "courbe",
        "variante": "open-left",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "q",
    "nom": {
      "fr": "q minuscule",
      "en": "lowercase q"
    },
    "zone": "jambe",
    "signes": [
      {
        "famille": "courbe",
        "variante": "open-right",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "jambe"
      }
    ],
    "validee": true
  },
  {
    "caractere": "r",
    "nom": {
      "fr": "r minuscule",
      "en": "lowercase r"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "corps"
      },
      {
        "famille": "crochet",
        "variante": "top-right",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "s",
    "nom": {
      "fr": "s minuscule",
      "en": "lowercase s"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "crochet",
        "variante": "top-right",
        "zone": "corps"
      },
      {
        "famille": "crochet",
        "variante": "bottom-left",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "t",
    "nom": {
      "fr": "t minuscule",
      "en": "lowercase t"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "u",
    "nom": {
      "fr": "u minuscule",
      "en": "lowercase u"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "crochet",
        "variante": "bottom-right",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "v",
    "nom": {
      "fr": "v minuscule",
      "en": "lowercase v"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "trait",
        "variante": "oblique-droit",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "w",
    "nom": {
      "fr": "w minuscule",
      "en": "lowercase w"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "trait",
        "variante": "oblique-droit",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "oblique-droit",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "x",
    "nom": {
      "fr": "x minuscule",
      "en": "lowercase x"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "oblique-droit",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "y",
    "nom": {
      "fr": "y minuscule",
      "en": "lowercase y"
    },
    "zone": "jambe",
    "signes": [
      {
        "famille": "trait",
        "variante": "oblique-droit",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "jambe"
      }
    ],
    "validee": true
  },
  {
    "caractere": "z",
    "nom": {
      "fr": "z minuscule",
      "en": "lowercase z"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "corps"
      }
    ],
    "validee": true
  }
]
''');

final List<dynamic> MAJUSCULES = jsonDecode(r'''
[
  {
    "caractere": "A",
    "nom": {
      "fr": "A majuscule",
      "en": "uppercase A"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "oblique-droit",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "corps"
      }
    ],
    "validee": false
  },
  {
    "caractere": "B",
    "nom": {
      "fr": "B majuscule",
      "en": "uppercase B"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      },
      {
        "famille": "courbe",
        "variante": "open-left",
        "zone": "hampe"
      },
      {
        "famille": "courbe",
        "variante": "open-left",
        "zone": "corps"
      }
    ],
    "validee": false
  },
  {
    "caractere": "C",
    "nom": {
      "fr": "C majuscule",
      "en": "uppercase C"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "courbe",
        "variante": "open-right",
        "zone": "hampe"
      }
    ],
    "validee": false
  },
  {
    "caractere": "D",
    "nom": {
      "fr": "D majuscule",
      "en": "uppercase D"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      },
      {
        "famille": "courbe",
        "variante": "open-left",
        "zone": "hampe"
      }
    ],
    "validee": false
  },
  {
    "caractere": "E",
    "nom": {
      "fr": "E majuscule",
      "en": "uppercase E"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "corps"
      }
    ],
    "validee": false
  },
  {
    "caractere": "F",
    "nom": {
      "fr": "F majuscule",
      "en": "uppercase F"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "corps"
      }
    ],
    "validee": false
  },
  {
    "caractere": "G",
    "nom": {
      "fr": "G majuscule",
      "en": "uppercase G"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "courbe",
        "variante": "open-right",
        "zone": "hampe"
      },
      {
        "famille": "crochet",
        "variante": "top-left",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "corps"
      }
    ],
    "validee": false
  },
  {
    "caractere": "H",
    "nom": {
      "fr": "H majuscule",
      "en": "uppercase H"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      }
    ],
    "validee": false
  },
  {
    "caractere": "I",
    "nom": {
      "fr": "I majuscule",
      "en": "uppercase I"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      }
    ],
    "validee": false
  },
  {
    "caractere": "J",
    "nom": {
      "fr": "J majuscule",
      "en": "uppercase J"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "crochet",
        "variante": "bottom-left",
        "zone": "jambe"
      },
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      }
    ],
    "validee": false
  },
  {
    "caractere": "K",
    "nom": {
      "fr": "K majuscule",
      "en": "uppercase K"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "oblique-droit",
        "zone": "corps"
      }
    ],
    "validee": false
  },
  {
    "caractere": "L",
    "nom": {
      "fr": "L majuscule",
      "en": "uppercase L"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "corps"
      }
    ],
    "validee": false
  },
  {
    "caractere": "M",
    "nom": {
      "fr": "M majuscule",
      "en": "uppercase M"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "oblique-droit",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      }
    ],
    "validee": false
  },
  {
    "caractere": "N",
    "nom": {
      "fr": "N majuscule",
      "en": "uppercase N"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      }
    ],
    "validee": false
  },
  {
    "caractere": "O",
    "nom": {
      "fr": "O majuscule",
      "en": "uppercase O"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "courbe",
        "variante": "closed",
        "zone": "hampe"
      }
    ],
    "validee": false
  },
  {
    "caractere": "P",
    "nom": {
      "fr": "P majuscule",
      "en": "uppercase P"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      },
      {
        "famille": "courbe",
        "variante": "open-left",
        "zone": "hampe"
      }
    ],
    "validee": false
  },
  {
    "caractere": "Q",
    "nom": {
      "fr": "Q majuscule",
      "en": "uppercase Q"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "courbe",
        "variante": "closed",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "corps"
      }
    ],
    "validee": false
  },
  {
    "caractere": "R",
    "nom": {
      "fr": "R majuscule",
      "en": "uppercase R"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      },
      {
        "famille": "courbe",
        "variante": "open-left",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "corps"
      }
    ],
    "validee": false
  },
  {
    "caractere": "S",
    "nom": {
      "fr": "S majuscule",
      "en": "uppercase S"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "crochet",
        "variante": "top-right",
        "zone": "hampe"
      },
      {
        "famille": "crochet",
        "variante": "bottom-left",
        "zone": "corps"
      }
    ],
    "validee": false
  },
  {
    "caractere": "T",
    "nom": {
      "fr": "T majuscule",
      "en": "uppercase T"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      }
    ],
    "validee": false
  },
  {
    "caractere": "U",
    "nom": {
      "fr": "U majuscule",
      "en": "uppercase U"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      },
      {
        "famille": "crochet",
        "variante": "bottom-right",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "hampe"
      }
    ],
    "validee": false
  },
  {
    "caractere": "V",
    "nom": {
      "fr": "V majuscule",
      "en": "uppercase V"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "oblique-droit",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "hampe"
      }
    ],
    "validee": false
  },
  {
    "caractere": "W",
    "nom": {
      "fr": "W majuscule",
      "en": "uppercase W"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "oblique-droit",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "oblique-droit",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "hampe"
      }
    ],
    "validee": false
  },
  {
    "caractere": "X",
    "nom": {
      "fr": "X majuscule",
      "en": "uppercase X"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "oblique-droit",
        "zone": "hampe"
      }
    ],
    "validee": false
  },
  {
    "caractere": "Y",
    "nom": {
      "fr": "Y majuscule",
      "en": "uppercase Y"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "oblique-droit",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "corps"
      }
    ],
    "validee": false
  },
  {
    "caractere": "Z",
    "nom": {
      "fr": "Z majuscule",
      "en": "uppercase Z"
    },
    "zone": "hampe",
    "signes": [
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "hampe"
      },
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "corps"
      }
    ],
    "validee": false
  }
]
''');

final List<dynamic> CHIFFRES = jsonDecode(r'''
[
  {
    "caractere": "0",
    "nom": {
      "fr": "Zéro",
      "en": "Zero"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "courbe",
        "variante": "closed",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "1",
    "nom": {
      "fr": "Un",
      "en": "One"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "2",
    "nom": {
      "fr": "Deux",
      "en": "Two"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "courbe",
        "variante": "open-right",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "3",
    "nom": {
      "fr": "Trois",
      "en": "Three"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "courbe",
        "variante": "open-left",
        "zone": "corps"
      },
      {
        "famille": "courbe",
        "variante": "open-left",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "4",
    "nom": {
      "fr": "Quatre",
      "en": "Four"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "corps"
      }
    ],
    "validee": true
  },
  {
    "caractere": "5",
    "nom": {
      "fr": "Cinq",
      "en": "Five"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "vertical",
        "zone": "corps"
      },
      {
        "famille": "courbe",
        "variante": "open-left",
        "zone": "corps"
      }
    ],
    "validee": false
  },
  {
    "caractere": "6",
    "nom": {
      "fr": "Six",
      "en": "Six"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "crochet",
        "variante": "top-right",
        "zone": "corps"
      },
      {
        "famille": "courbe",
        "variante": "closed",
        "zone": "corps"
      }
    ],
    "validee": false
  },
  {
    "caractere": "7",
    "nom": {
      "fr": "Sept",
      "en": "Seven"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "trait",
        "variante": "horizontal",
        "zone": "corps"
      },
      {
        "famille": "trait",
        "variante": "oblique-gauche",
        "zone": "corps"
      }
    ],
    "validee": false
  },
  {
    "caractere": "8",
    "nom": {
      "fr": "Huit",
      "en": "Eight"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "courbe",
        "variante": "closed",
        "zone": "corps"
      },
      {
        "famille": "courbe",
        "variante": "closed",
        "zone": "corps"
      }
    ],
    "validee": false
  },
  {
    "caractere": "9",
    "nom": {
      "fr": "Neuf",
      "en": "Nine"
    },
    "zone": "corps",
    "signes": [
      {
        "famille": "courbe",
        "variante": "closed",
        "zone": "corps"
      },
      {
        "famille": "crochet",
        "variante": "top-right",
        "zone": "corps"
      }
    ],
    "validee": false
  }
]
''');


/// Couleur des glyphes SVG par famille.
const Map<String, Color> STROKE_FAMILLE = {
  'trait': Color(0xFF4A3B2A),
  'courbe': Color(0xFFE05252),
  'crochet': Color(0xFF4A90E2),
  'point': Color(0xFF4A3B2A),
};
