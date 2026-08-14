import 'dart:convert';
import 'package:flutter/material.dart';

final List<dynamic> MINUSCULES = jsonDecode(r'''
[
  {
    "caractere": "a",
    "nom": {
      "fr": "a minuscule",
      "en": "lowercase a",
      "es": "a minúscula",
      "ar": "الحرف a الصغير"
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
      "en": "lowercase b",
      "es": "b minúscula",
      "ar": "الحرف b الصغير"
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
      "en": "lowercase c",
      "es": "c minúscula",
      "ar": "الحرف c الصغير"
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
      "en": "lowercase d",
      "es": "d minúscula",
      "ar": "الحرف d الصغير"
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
      "en": "lowercase e",
      "es": "e minúscula",
      "ar": "الحرف e الصغير"
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
      "en": "lowercase f",
      "es": "f minúscula",
      "ar": "الحرف f الصغير"
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
      "en": "lowercase g",
      "es": "g minúscula",
      "ar": "الحرف g الصغير"
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
      "en": "lowercase h",
      "es": "h minúscula",
      "ar": "الحرف h الصغير"
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
      "en": "lowercase i",
      "es": "i minúscula",
      "ar": "الحرف i الصغير"
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
      "en": "lowercase j",
      "es": "j minúscula",
      "ar": "الحرف j الصغير"
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
      "en": "lowercase k",
      "es": "k minúscula",
      "ar": "الحرف k الصغير"
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
      "en": "lowercase l",
      "es": "l minúscula",
      "ar": "الحرف l الصغير"
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
      "en": "lowercase m",
      "es": "m minúscula",
      "ar": "الحرف m الصغير"
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
      "en": "lowercase n",
      "es": "n minúscula",
      "ar": "الحرف n الصغير"
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
      "en": "lowercase o",
      "es": "o minúscula",
      "ar": "الحرف o الصغير"
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
      "en": "lowercase p",
      "es": "p minúscula",
      "ar": "الحرف p الصغير"
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
      "en": "lowercase q",
      "es": "q minúscula",
      "ar": "الحرف q الصغير"
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
      "en": "lowercase r",
      "es": "r minúscula",
      "ar": "الحرف r الصغير"
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
      "en": "lowercase s",
      "es": "s minúscula",
      "ar": "الحرف s الصغير"
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
      "en": "lowercase t",
      "es": "t minúscula",
      "ar": "الحرف t الصغير"
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
      "en": "lowercase u",
      "es": "u minúscula",
      "ar": "الحرف u الصغير"
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
      "en": "lowercase v",
      "es": "v minúscula",
      "ar": "الحرف v الصغير"
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
      "en": "lowercase w",
      "es": "w minúscula",
      "ar": "الحرف w الصغير"
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
      "en": "lowercase x",
      "es": "x minúscula",
      "ar": "الحرف x الصغير"
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
      "en": "lowercase y",
      "es": "y minúscula",
      "ar": "الحرف y الصغير"
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
      "en": "lowercase z",
      "es": "z minúscula",
      "ar": "الحرف z الصغير"
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
      "en": "uppercase A",
      "es": "A mayúscula",
      "ar": "الحرف A الكبير"
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
      "en": "uppercase B",
      "es": "B mayúscula",
      "ar": "الحرف B الكبير"
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
      "en": "uppercase C",
      "es": "C mayúscula",
      "ar": "الحرف C الكبير"
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
      "en": "uppercase D",
      "es": "D mayúscula",
      "ar": "الحرف D الكبير"
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
      "en": "uppercase E",
      "es": "E mayúscula",
      "ar": "الحرف E الكبير"
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
      "en": "uppercase F",
      "es": "F mayúscula",
      "ar": "الحرف F الكبير"
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
      "en": "uppercase G",
      "es": "G mayúscula",
      "ar": "الحرف G الكبير"
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
      "en": "uppercase H",
      "es": "H mayúscula",
      "ar": "الحرف H الكبير"
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
      "en": "uppercase I",
      "es": "I mayúscula",
      "ar": "الحرف I الكبير"
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
      "en": "uppercase J",
      "es": "J mayúscula",
      "ar": "الحرف J الكبير"
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
      "en": "uppercase K",
      "es": "K mayúscula",
      "ar": "الحرف K الكبير"
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
      "en": "uppercase L",
      "es": "L mayúscula",
      "ar": "الحرف L الكبير"
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
      "en": "uppercase M",
      "es": "M mayúscula",
      "ar": "الحرف M الكبير"
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
      "en": "uppercase N",
      "es": "N mayúscula",
      "ar": "الحرف N الكبير"
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
      "en": "uppercase O",
      "es": "O mayúscula",
      "ar": "الحرف O الكبير"
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
      "en": "uppercase P",
      "es": "P mayúscula",
      "ar": "الحرف P الكبير"
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
      "en": "uppercase Q",
      "es": "Q mayúscula",
      "ar": "الحرف Q الكبير"
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
      "en": "uppercase R",
      "es": "R mayúscula",
      "ar": "الحرف R الكبير"
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
      "en": "uppercase S",
      "es": "S mayúscula",
      "ar": "الحرف S الكبير"
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
      "en": "uppercase T",
      "es": "T mayúscula",
      "ar": "الحرف T الكبير"
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
      "en": "uppercase U",
      "es": "U mayúscula",
      "ar": "الحرف U الكبير"
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
      "en": "uppercase V",
      "es": "V mayúscula",
      "ar": "الحرف V الكبير"
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
      "en": "uppercase W",
      "es": "W mayúscula",
      "ar": "الحرف W الكبير"
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
      "en": "uppercase X",
      "es": "X mayúscula",
      "ar": "الحرف X الكبير"
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
      "en": "uppercase Y",
      "es": "Y mayúscula",
      "ar": "الحرف Y الكبير"
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
      "en": "uppercase Z",
      "es": "Z mayúscula",
      "ar": "الحرف Z الكبير"
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
      "en": "Zero",
      "es": "Cero",
      "ar": "صفر"
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
      "en": "One",
      "es": "Uno",
      "ar": "واحد"
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
      "en": "Two",
      "es": "Dos",
      "ar": "اثنان"
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
      "en": "Three",
      "es": "Tres",
      "ar": "ثلاثة"
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
      "en": "Four",
      "es": "Cuatro",
      "ar": "أربعة"
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
      "en": "Five",
      "es": "Cinco",
      "ar": "خمسة"
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
      "en": "Six",
      "es": "Seis",
      "ar": "ستة"
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
      "en": "Seven",
      "es": "Siete",
      "ar": "سبعة"
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
      "en": "Eight",
      "es": "Ocho",
      "ar": "ثمانية"
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
      "en": "Nine",
      "es": "Nueve",
      "ar": "تسعة"
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
