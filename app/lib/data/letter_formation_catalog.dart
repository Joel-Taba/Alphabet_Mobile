import 'dart:convert';

final List<dynamic> VOWELS = jsonDecode(r'''
[
  {
    "char": "a",
    "name": {
      "fr": "a minuscule",
      "en": "lowercase a"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre A se forme en deux gestes. D'abord, trace une courbe bien ronde, presque fermée, qui ne reste ouverte qu'à droite. Ensuite, ajoute un trait vertical qui vient refermer cette ouverture, du haut vers le bas.",
      "en": "The letter A is formed in two gestures. First, trace a nicely round curve, almost closed, staying open only at the right. Then, add a vertical line that closes that opening, from top to bottom."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 125 90.4 C 118.2 81.9 107.9 77 97 77 C 77.1 77 61 93.1 61 113 C 61 132.9 77.1 149 97 149 C 107.9 149 118.2 144.1 125 135.6",
        "startXY": [
          125,
          90.4
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe circulaire presque fermée, ouverte à droite horizontalement",
          "en": "Circular curve almost closed, open horizontally at the right"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 125 90.4 L 125 135.6",
        "startXY": [
          125,
          90.4
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical qui referme la courbe, du haut vers le bas",
          "en": "Vertical line that closes the curve, from top to bottom"
        }
      }
    ]
  },
  {
    "char": "e",
    "name": {
      "fr": "e minuscule",
      "en": "lowercase e"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre E se forme en deux gestes. D'abord, trace un trait horizontal au milieu. Ensuite, dessine une courbe bien ronde qui part de la pointe du trait, encercle tout le tour et s'ouvre juste un peu en bas à droite.",
      "en": "The letter E is formed in two gestures. First, trace a horizontal line in the middle. Then, draw a nicely round curve that starts from the tip of the line, circles all the way round and opens just a little at the bottom right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 68 118 L 136 118",
        "startXY": [
          68,
          118
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal au centre, de gauche à droite",
          "en": "Horizontal line in the center, left to right"
        }
      },
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 136 118 C 136 98.1 119.9 82 100 82 C 80.1 82 64 98.1 64 118 C 64 137.9 80.1 154 100 154",
        "startXY": [
          136,
          118
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe qui entoure le trait, ouverte en bas à droite",
          "en": "Curve that surrounds the line, open at the bottom right"
        }
      }
    ]
  },
  {
    "char": "i",
    "name": {
      "fr": "i minuscule",
      "en": "lowercase i"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre I se forme en deux gestes. D'abord, trace un trait vertical dans le corps de la ligne. Ensuite, pose un point rond au-dessus du trait, sans le toucher.",
      "en": "The letter I is formed in two gestures. First, trace a vertical line in the body of the writing line. Then, place a round dot above the line, without touching it."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 100 78 L 100 150",
        "startXY": [
          100,
          78
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, du haut vers le bas",
          "en": "Vertical line, from top to bottom"
        }
      },
      {
        "family": "point",
        "variant": "center",
        "pathD": "M 100 41 A 11 11 0 1 0 100.1 41",
        "startXY": [
          100,
          41
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Point au-dessus du trait, petit rond détaché",
          "en": "Dot above the line, small detached circle"
        }
      }
    ]
  },
  {
    "char": "o",
    "name": {
      "fr": "o minuscule",
      "en": "lowercase o"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre O est un ovale complet. Pars du sommet et tourne dans le sens anti-horaire en un seul mouvement continu, doux et régulier.",
      "en": "The letter O is a full oval. Start at the top and turn counter-clockwise in one smooth, continuous motion."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 100 55 A 42 47 0 1 0 100.1 55",
        "startXY": [
          100,
          55
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Ovale complet, anti-horaire depuis le sommet",
          "en": "Full oval, counter-clockwise from the top"
        }
      }
    ]
  },
  {
    "char": "u",
    "name": {
      "fr": "u minuscule",
      "en": "lowercase u"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre U se forme en deux gestes. D'abord, trace un crochet bas-droite : descends puis arrondis doucement vers la droite en bas. Ensuite, ajoute un trait vertical sur le bord droit, du haut vers le bas.",
      "en": "The letter U is formed in two gestures. First, trace a bottom-right hook: go down, then curve gently to the right at the bottom. Then, add a vertical line on the right edge, from top to bottom."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "bottom-right",
        "pathD": "M 68 60 L 68 118 C 68 140 84 150 102 150 C 120 150 132 140 132 118",
        "startXY": [
          68,
          60
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet bas-droite : descends puis arrondis à droite",
          "en": "Bottom-right hook: go down then curve to the right"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 132 60 L 132 150",
        "startXY": [
          132,
          60
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical accolé à droite, du haut vers le bas",
          "en": "Vertical line on the right edge, from top to bottom"
        }
      }
    ]
  }
]
''');

final List<dynamic> CONSONANTS = jsonDecode(r'''
[
  {
    "char": "b",
    "name": {
      "fr": "b minuscule",
      "en": "lowercase b"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre B se forme en deux gestes. D'abord, trace un trait vertical qui monte en zone haute. Ensuite, ajoute une courbe ronde accolée en bas à droite du trait.",
      "en": "The letter B is formed in two gestures. First, trace a vertical line rising into the ascender zone. Then, add a round curve attached to the lower right of the line."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 68 27 L 68 149",
        "startXY": [
          68,
          27
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, monte en zone haute",
          "en": "Vertical line, rising into the ascender zone"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 76 98.3 C 85.6 86.5 101.6 82 116 87.1 C 130.4 92.2 140 105.8 140 121 C 140 136.2 130.4 149.8 116 154.9 C 101.6 160 85.6 155.5 76 143.7",
        "startXY": [
          76,
          98.3
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde accolée en bas à droite du trait",
          "en": "Round curve attached to the lower right of the line"
        }
      }
    ]
  },
  {
    "char": "c",
    "name": {
      "fr": "c minuscule",
      "en": "lowercase c"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre C est une courbe ronde, presque fermée, ouverte seulement à droite. Trace-la en un seul geste, en partant du haut.",
      "en": "The letter C is a round curve, almost closed, open only on the right. Trace it in a single motion, starting from the top."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 125 90.3 C 115.4 78.5 99.4 74 85 79.1 C 70.6 84.2 61 97.8 61 113 C 61 128.2 70.6 141.8 85 146.9 C 99.4 152 115.4 147.5 125 135.7",
        "startXY": [
          125,
          90.3
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde ouverte à droite, un seul geste",
          "en": "Round curve open on the right, single motion"
        }
      }
    ]
  },
  {
    "char": "d",
    "name": {
      "fr": "d minuscule",
      "en": "lowercase d"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre D se forme en deux gestes. D'abord, trace une courbe ronde ouverte à droite. Ensuite, ajoute un trait vertical sur le bord droit, qui monte cette fois en zone haute.",
      "en": "The letter D is formed in two gestures. First, trace a round curve open on the right. Then, add a vertical line on the right edge, this time rising into the ascender zone."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 125 90.3 C 115.4 78.5 99.4 74 85 79.1 C 70.6 84.2 61 97.8 61 113 C 61 128.2 70.6 141.8 85 146.9 C 99.4 152 115.4 147.5 125 135.7",
        "startXY": [
          125,
          90.3
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde ouverte à droite",
          "en": "Round curve open on the right"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 125 27 L 125 149",
        "startXY": [
          125,
          27
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical à droite, prolongé vers le haut",
          "en": "Vertical line on the right, extended upward"
        }
      }
    ]
  },
  {
    "char": "f",
    "name": {
      "fr": "f minuscule",
      "en": "lowercase f"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre F se forme en deux gestes. D'abord, trace un grand trait qui monte en zone haute et se termine par un petit crochet arrondi vers la droite en haut. Ensuite, ajoute un trait horizontal qui traverse le trait vertical.",
      "en": "The letter F is formed in two gestures. First, trace a tall line rising into the ascender zone, finishing with a small rounded hook to the right at the top. Then, add a horizontal line crossing the vertical line."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "top-right",
        "pathD": "M 115 41 C 115 31.1 106.9 23 97 23 C 87.1 23 79 31.1 79 41 L 79 149",
        "startXY": [
          115,
          41
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trait qui monte et s'arrondit vers la droite en haut",
          "en": "Line rising and curving right at the top"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 63 99 L 99 99",
        "startXY": [
          63,
          99
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal qui coupe le crochet",
          "en": "Horizontal line cutting across the hook"
        }
      }
    ]
  },
  {
    "char": "g",
    "name": {
      "fr": "g minuscule",
      "en": "lowercase g"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre G se forme en deux gestes. D'abord, trace une courbe ronde ouverte à droite. Ensuite, ajoute un crochet qui descend en zone basse et s'arrondit vers la gauche.",
      "en": "The letter G is formed in two gestures. First, trace a round curve open on the right. Then, add a hook going down into the descender zone, curving to the left."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 111.8 77.4 C 104.3 68.2 91.8 64.6 80.7 68.6 C 69.5 72.6 62 83.1 62 95 C 62 106.9 69.5 117.4 80.7 121.4 C 91.8 125.4 104.3 121.8 111.8 112.6",
        "startXY": [
          111.8,
          77.4
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde ouverte à droite",
          "en": "Round curve open on the right"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 111.8 77.4 L 111.8 165 C 111.8 172.2 105.9 178 98.8 178 C 91.6 178 85.8 172.2 85.8 165",
        "startXY": [
          111.8,
          77.4
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trait qui descend en zone basse et s'arrondit à gauche",
          "en": "Line going down into the descender zone, curving left"
        }
      }
    ]
  },
  {
    "char": "h",
    "name": {
      "fr": "h minuscule",
      "en": "lowercase h"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre H se forme en deux gestes. D'abord, trace un trait vertical qui monte en zone haute. Ensuite, ajoute un crochet qui part du trait, s'arrondit vers le haut puis redescend jusqu'à la ligne.",
      "en": "The letter H is formed in two gestures. First, trace a vertical line rising into the ascender zone. Then, add a hook starting from the line, arching up and coming back down to the baseline."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 68 27 L 68 149",
        "startXY": [
          68,
          27
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, monte en zone haute",
          "en": "Vertical line, rising into the ascender zone"
        }
      },
      {
        "family": "crochet",
        "variant": "top-left",
        "pathD": "M 68 90 C 68 76.7 78.7 66 92 66 C 105.3 66 116 76.7 116 90 L 116 149",
        "startXY": [
          68,
          90
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet accolé en bas à droite du trait",
          "en": "Hook attached to the lower right of the line"
        }
      }
    ]
  },
  {
    "char": "j",
    "name": {
      "fr": "j minuscule",
      "en": "lowercase j"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre J se forme en deux gestes. D'abord, trace un trait qui descend en zone basse et s'arrondit vers la gauche. Ensuite, pose un point rond au-dessus, sans le toucher.",
      "en": "The letter J is formed in two gestures. First, trace a line going down into the descender zone, curving to the left. Then, place a round dot above, without touching it."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 113 77 L 113 162 C 113 169.2 107.2 175 100 175 C 92.8 175 87 169.2 87 162",
        "startXY": [
          113,
          77
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trait qui descend en zone basse et s'arrondit à gauche",
          "en": "Line going down into the descender zone, curving left"
        }
      },
      {
        "family": "point",
        "variant": "center",
        "pathD": "M 113 48 A 7 7 0 1 0 113.1 48",
        "startXY": [
          113,
          48
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Point au-dessus, sans toucher le crochet",
          "en": "Dot above, without touching the hook"
        }
      }
    ]
  },
  {
    "char": "k",
    "name": {
      "fr": "k minuscule",
      "en": "lowercase k"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre K se forme en trois gestes. D'abord, trace un trait vertical qui monte en zone haute. Ensuite, trace un premier trait oblique du milieu vers le haut-droite. Enfin, trace un second trait oblique du milieu vers le bas-droite.",
      "en": "The letter K is formed in three gestures. First, trace a vertical line rising into the ascender zone. Then, trace a diagonal line from the middle toward the upper right. Finally, trace a second diagonal line from the middle toward the lower right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 68 27 L 68 149",
        "startXY": [
          68,
          27
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, monte en zone haute",
          "en": "Vertical line, rising into the ascender zone"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 68 113 L 102 77",
        "startXY": [
          68,
          113
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique du milieu du trait vers le haut-droite",
          "en": "Diagonal from the middle of the line toward the upper right"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 68 113 L 102 149",
        "startXY": [
          68,
          113
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique du milieu du trait vers le bas-droite",
          "en": "Diagonal from the middle of the line toward the lower right"
        }
      }
    ]
  },
  {
    "char": "l",
    "name": {
      "fr": "l minuscule",
      "en": "lowercase l"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre L est un simple trait vertical qui monte en zone haute. Trace-le d'un seul geste, du haut vers le bas.",
      "en": "The letter L is a simple vertical line rising into the ascender zone. Trace it in a single motion, from top to bottom."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 97 27 L 97 149",
        "startXY": [
          97,
          27
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, du haut vers le bas",
          "en": "Vertical line, from top to bottom"
        }
      }
    ]
  },
  {
    "char": "m",
    "name": {
      "fr": "m minuscule",
      "en": "lowercase m"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre M se forme en trois gestes. D'abord, trace un trait vertical court. Ensuite, ajoute un premier crochet qui s'arrondit vers le haut. Enfin, ajoute un second crochet identique, juste à côté.",
      "en": "The letter M is formed in three gestures. First, trace a short vertical line. Then, add a first hook arching upward. Finally, add a second matching hook right next to it."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 55 77 L 55 149",
        "startXY": [
          55,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical court",
          "en": "Short vertical line"
        }
      },
      {
        "family": "crochet",
        "variant": "top-left",
        "pathD": "M 55 77 C 55 67.6 62.6 60 72 60 C 81.4 60 89 67.6 89 77 L 89 149",
        "startXY": [
          55,
          77
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Premier crochet, accolé à droite du trait",
          "en": "First hook, attached to the right of the line"
        }
      },
      {
        "family": "crochet",
        "variant": "top-left",
        "pathD": "M 89 77 C 89 67.6 96.6 60 106 60 C 115.4 60 123 67.6 123 77 L 123 149",
        "startXY": [
          89,
          77
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Second crochet, accolé au premier",
          "en": "Second hook, attached to the first"
        }
      }
    ]
  },
  {
    "char": "n",
    "name": {
      "fr": "n minuscule",
      "en": "lowercase n"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre N se forme en deux gestes. D'abord, trace un trait vertical court. Ensuite, ajoute un crochet qui s'arrondit vers le haut puis redescend jusqu'à la ligne.",
      "en": "The letter N is formed in two gestures. First, trace a short vertical line. Then, add a hook arching upward and coming back down to the baseline."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 68 77 L 68 149",
        "startXY": [
          68,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical court",
          "en": "Short vertical line"
        }
      },
      {
        "family": "crochet",
        "variant": "top-left",
        "pathD": "M 68 77 C 68 59.3 82.3 45 100 45 C 117.7 45 132 59.3 132 77 L 132 149",
        "startXY": [
          68,
          77
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet accolé à droite du trait",
          "en": "Hook attached to the right of the line"
        }
      }
    ]
  },
  {
    "char": "p",
    "name": {
      "fr": "p minuscule",
      "en": "lowercase p"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre P se forme en deux gestes. D'abord, trace un trait vertical qui descend en zone basse. Ensuite, ajoute une courbe ronde accolée en haut à droite du trait.",
      "en": "The letter P is formed in two gestures. First, trace a vertical line going down into the descender zone. Then, add a round curve attached to the upper right of the line."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 68 62 L 68 179",
        "startXY": [
          68,
          62
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, descend en zone basse",
          "en": "Vertical line, going down into the descender zone"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 76 67.3 C 85.6 55.5 101.6 51 116 56.1 C 130.4 61.2 140 74.8 140 90 C 140 105.2 130.4 118.8 116 123.9 C 101.6 129 85.6 124.5 76 112.7",
        "startXY": [
          76,
          67.3
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde accolée en haut à droite du trait",
          "en": "Round curve attached to the upper right of the line"
        }
      }
    ]
  },
  {
    "char": "q",
    "name": {
      "fr": "q minuscule",
      "en": "lowercase q"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre Q se forme en deux gestes. D'abord, trace une courbe ronde ouverte à droite. Ensuite, ajoute un trait vertical sur le bord droit, qui descend cette fois en zone basse.",
      "en": "The letter Q is formed in two gestures. First, trace a round curve open on the right. Then, add a vertical line on the right edge, this time going down into the descender zone."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 125 75.3 C 115.4 63.5 99.4 59 85 64.1 C 70.6 69.2 61 82.8 61 98 C 61 113.2 70.6 126.8 85 131.9 C 99.4 137 115.4 132.5 125 120.7",
        "startXY": [
          125,
          75.3
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde ouverte à droite",
          "en": "Round curve open on the right"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 125 62 L 125 179",
        "startXY": [
          125,
          62
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical à droite, prolongé vers le bas",
          "en": "Vertical line on the right, extended downward"
        }
      }
    ]
  },
  {
    "char": "r",
    "name": {
      "fr": "r minuscule",
      "en": "lowercase r"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre R se forme en deux gestes. D'abord, trace un trait vertical court. Ensuite, ajoute un petit crochet en haut à droite, qui ne descend pas jusqu'à la ligne.",
      "en": "The letter R is formed in two gestures. First, trace a short vertical line. Then, add a small hook at the upper right, which doesn't reach the baseline."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 71 77 L 71 149",
        "startXY": [
          71,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical court",
          "en": "Short vertical line"
        }
      },
      {
        "family": "crochet",
        "variant": "top-right",
        "pathD": "M 71 92 C 71 84.8 76.8 79 84 79 C 91.2 79 97 84.8 97 92",
        "startXY": [
          71,
          92
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Petit crochet en haut à droite du trait",
          "en": "Small hook at the upper right of the line"
        }
      }
    ]
  },
  {
    "char": "s",
    "name": {
      "fr": "s minuscule",
      "en": "lowercase s"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre S se forme en deux gestes enchaînés. D'abord, un petit crochet en haut qui s'arrondit vers la droite. Ensuite, sans lever le crayon, un second petit crochet en bas qui s'arrondit vers la gauche.",
      "en": "The letter S is formed in two linked gestures. First, a small hook at the top curving to the right. Then, without lifting the pencil, a second small hook at the bottom curving to the left."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "top-right",
        "pathD": "M 117.7 83.5 C 113.9 73 102.8 67 91.9 69.6 C 81.1 72.2 73.9 82.5 75.1 93.6 C 76.4 104.6 85.8 113 97 113",
        "startXY": [
          117.7,
          83.5
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Petit crochet, s'arrondit vers la droite en haut",
          "en": "Small hook, curving right at the top"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 97 113 C 108.2 113 117.6 121.4 118.9 132.4 C 120.1 143.5 112.9 153.8 102.1 156.4 C 91.2 159 80.1 153 76.3 142.5",
        "startXY": [
          97,
          113
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Petit crochet, s'arrondit vers la gauche en bas",
          "en": "Small hook, curving left at the bottom"
        }
      }
    ]
  },
  {
    "char": "t",
    "name": {
      "fr": "t minuscule",
      "en": "lowercase t"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre T se forme en deux gestes. D'abord, trace un trait vertical qui monte en zone haute. Ensuite, ajoute un trait horizontal qui le traverse, plus haut que pour le F.",
      "en": "The letter T is formed in two gestures. First, trace a vertical line rising into the ascender zone. Then, add a horizontal line crossing it, higher than for the F."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 97 27 L 97 149",
        "startXY": [
          97,
          27
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, monte en zone haute",
          "en": "Vertical line, rising into the ascender zone"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 77 51 L 117 51",
        "startXY": [
          77,
          51
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal qui traverse, en haut de la zone haute",
          "en": "Horizontal line crossing, high in the ascender zone"
        }
      }
    ]
  },
  {
    "char": "v",
    "name": {
      "fr": "v minuscule",
      "en": "lowercase v"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre V se forme en deux gestes. D'abord, un trait oblique qui descend du haut-gauche vers le centre-bas. Ensuite, un trait oblique qui remonte du centre-bas vers le haut-droite.",
      "en": "The letter V is formed in two gestures. First, a diagonal line going down from the upper left to the center-bottom. Then, a diagonal line going up from the center-bottom to the upper right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 65 77 L 97 149",
        "startXY": [
          65,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique descendante, haut-gauche vers centre-bas",
          "en": "Diagonal going down, upper left to center-bottom"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 97 149 L 129 77",
        "startXY": [
          97,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique montante, centre-bas vers haut-droite",
          "en": "Diagonal going up, center-bottom to upper right"
        }
      }
    ]
  },
  {
    "char": "w",
    "name": {
      "fr": "w minuscule",
      "en": "lowercase w"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre W se forme en quatre traits obliques qui s'enchaînent, alternant descente et montée, comme deux V collés.",
      "en": "The letter W is formed with four diagonal lines linked together, alternating down and up, like two Vs side by side."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 57 77 L 77 149",
        "startXY": [
          57,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Première oblique descendante",
          "en": "First diagonal going down"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 77 149 L 97 77",
        "startXY": [
          77,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Deuxième oblique montante",
          "en": "Second diagonal going up"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 97 77 L 117 149",
        "startXY": [
          97,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Troisième oblique descendante",
          "en": "Third diagonal going down"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 117 149 L 137 77",
        "startXY": [
          117,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Quatrième oblique montante",
          "en": "Fourth diagonal going up"
        }
      }
    ]
  },
  {
    "char": "x",
    "name": {
      "fr": "x minuscule",
      "en": "lowercase x"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre X se forme en deux traits obliques qui se croisent au centre. D'abord du haut-gauche vers le bas-droite, puis du haut-droite vers le bas-gauche.",
      "en": "The letter X is formed with two diagonal lines crossing at the center. First from the upper left to the lower right, then from the upper right to the lower left."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 65 77 L 129 149",
        "startXY": [
          65,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique haut-gauche vers bas-droite",
          "en": "Diagonal upper left to lower right"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 129 77 L 65 149",
        "startXY": [
          129,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique haut-droite vers bas-gauche",
          "en": "Diagonal upper right to lower left"
        }
      }
    ]
  },
  {
    "char": "y",
    "name": {
      "fr": "y minuscule",
      "en": "lowercase y"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre Y se forme en deux gestes. D'abord, une diagonale du haut-gauche qui descend jusqu'au point de croisement sur la ligne de base. Ensuite, une diagonale du haut-droite qui passe par le même point, puis continue en zone basse et se termine par un petit crochet vers la gauche.",
      "en": "The letter Y is formed in two gestures. First, a diagonal from the upper left descending to the crossing point on the baseline. Then, a diagonal from the upper right passing through the same point, continuing into the descender zone and ending with a small hook to the left."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 65 77 L 97 149",
        "startXY": [
          65,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Diagonale du haut-gauche vers le point de croisement sur la ligne de base",
          "en": "Diagonal from upper left to the crossing point on the baseline"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 129 77 L 97 149 L 83 185",
        "startXY": [
          129,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Diagonale du haut-droite, croise, descend en zone basse",
          "en": "Diagonal from upper right, crosses, descends into the descender zone"
        }
      }
    ]
  },
  {
    "char": "z",
    "name": {
      "fr": "z minuscule",
      "en": "lowercase z"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre Z se forme en trois gestes enchaînés sans lever le crayon : un trait horizontal en haut, un trait oblique vers le bas-gauche, puis un trait horizontal en bas.",
      "en": "The letter Z is formed in three linked gestures without lifting the pencil: a horizontal line at the top, a diagonal going to the lower left, then a horizontal line at the bottom."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 63 77 L 131 77",
        "startXY": [
          63,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en haut",
          "en": "Horizontal line at the top"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 131 77 L 63 149",
        "startXY": [
          131,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique vers le bas-gauche",
          "en": "Diagonal toward the lower left"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 63 149 L 131 149",
        "startXY": [
          63,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en bas",
          "en": "Horizontal line at the bottom"
        }
      }
    ]
  }
]
''');

final List<dynamic> UPPERCASE = jsonDecode(r'''
[
  {
    "char": "A",
    "name": {
      "fr": "A majuscule",
      "en": "uppercase A"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre A se forme en trois gestes. D'abord une oblique du sommet vers le bas-gauche, puis une oblique du sommet vers le bas-droite, enfin une barre horizontale qui relie les deux obliques à mi-hauteur.",
      "en": "The letter A is formed in three gestures. First a diagonal from the top to the lower left, then a diagonal from the top to the lower right, finally a horizontal bar linking the two diagonals at mid-height."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 97 18 L 55 149",
        "startXY": [
          97,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique du sommet vers le bas-gauche",
          "en": "Diagonal from the top to the lower left"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 97 18 L 139 149",
        "startXY": [
          97,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique du sommet vers le bas-droite",
          "en": "Diagonal from the top to the lower right"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 69 123 L 125 123",
        "startXY": [
          69,
          123
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Barre horizontale médiane",
          "en": "Horizontal middle bar"
        }
      }
    ]
  },
  {
    "char": "B",
    "name": {
      "fr": "B majuscule",
      "en": "uppercase B"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre B se forme en trois gestes. D'abord un trait vertical pleine hauteur. Ensuite une courbe ronde accolée en haut à droite. Enfin une seconde courbe ronde accolée en bas à droite, qui touche la première au milieu.",
      "en": "The letter B is formed in three gestures. First a full-height vertical line. Then a round curve attached to the upper right. Finally a second round curve attached to the lower right, touching the first in the middle."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 73.8 40.9 L 73.8 155.6",
        "startXY": [
          73.8,
          40.9
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical pleine hauteur",
          "en": "Full-height vertical line"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 73.8 40.9 C 86.3 32.2 103.3 34.2 113.4 45.6 C 123.5 56.9 123.5 74.1 113.4 85.4 C 103.3 96.8 86.3 98.8 73.8 90.1",
        "startXY": [
          73.8,
          40.9
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe du haut, accolée à droite",
          "en": "Upper curve, attached on the right"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 73.8 106.4 C 86.3 97.7 103.3 99.7 113.4 111.1 C 123.5 122.4 123.5 139.6 113.4 150.9 C 103.3 162.3 86.3 164.3 73.8 155.6",
        "startXY": [
          73.8,
          106.4
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe du bas, accolée à droite",
          "en": "Lower curve, attached on the right"
        }
      }
    ]
  },
  {
    "char": "C",
    "name": {
      "fr": "C majuscule",
      "en": "uppercase C"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre C est une grande courbe ronde, presque fermée, ouverte seulement à droite. Trace-la en un seul geste depuis le haut.",
      "en": "The letter C is a large round curve, almost closed, open only on the right. Trace it in a single motion from the top."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 128.1 58.3 C 117.4 45.2 99.6 40.1 83.6 45.8 C 67.7 51.5 57 66.6 57 83.5 C 57 100.4 67.7 115.5 83.6 121.2 C 99.6 126.9 117.4 121.8 128.1 108.7",
        "startXY": [
          128.1,
          58.3
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Grande courbe ouverte à droite",
          "en": "Large curve open on the right"
        }
      }
    ]
  },
  {
    "char": "D",
    "name": {
      "fr": "D majuscule",
      "en": "uppercase D"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre D se forme en deux gestes. D'abord un trait vertical pleine hauteur. Ensuite une grande courbe qui referme l'ouverture en haut et en bas, accolée à droite du trait.",
      "en": "The letter D is formed in two gestures. First a full-height vertical line. Then a large curve closing the opening at the top and bottom, attached to the right of the line."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 75 48.9 L 75 118.1",
        "startXY": [
          75,
          48.9
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical pleine hauteur",
          "en": "Full-height vertical line"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 75 48.9 C 91.8 39.2 113.2 42.9 125.6 57.8 C 138.1 72.7 138.1 94.3 125.6 109.2 C 113.2 124.1 91.8 127.8 75 118.1",
        "startXY": [
          75,
          48.9
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Grande courbe, accolée à droite du trait",
          "en": "Large curve, attached to the right of the line"
        }
      }
    ]
  },
  {
    "char": "E",
    "name": {
      "fr": "E majuscule",
      "en": "uppercase E"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre E se forme en quatre gestes. Un trait vertical, puis trois traits horizontaux qui partent tous du trait vers la droite : en haut, au milieu, en bas.",
      "en": "The letter E is formed in four gestures. A vertical line, then three horizontal lines all starting from the line toward the right: at the top, in the middle, at the bottom."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 61 18 L 61 149",
        "startXY": [
          61,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical",
          "en": "Vertical line"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 61 18 L 133 18",
        "startXY": [
          61,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Horizontale du haut",
          "en": "Top horizontal"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 61 83.5 L 123 83.5",
        "startXY": [
          61,
          83.5
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Horizontale du milieu",
          "en": "Middle horizontal"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 61 149 L 133 149",
        "startXY": [
          61,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Horizontale du bas",
          "en": "Bottom horizontal"
        }
      }
    ]
  },
  {
    "char": "F",
    "name": {
      "fr": "F majuscule",
      "en": "uppercase F"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre F se forme comme le E, mais sans la barre du bas : un trait vertical, une horizontale en haut, une horizontale au milieu.",
      "en": "The letter F is formed like the E, but without the bottom bar: a vertical line, a horizontal at the top, a horizontal in the middle."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 61 18 L 61 149",
        "startXY": [
          61,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical",
          "en": "Vertical line"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 61 18 L 133 18",
        "startXY": [
          61,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Horizontale du haut",
          "en": "Top horizontal"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 61 83.5 L 123 83.5",
        "startXY": [
          61,
          83.5
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Horizontale du milieu",
          "en": "Middle horizontal"
        }
      }
    ]
  },
  {
    "char": "G",
    "name": {
      "fr": "G majuscule",
      "en": "uppercase G"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre G se forme en trois gestes. D'abord une grande courbe ouverte à droite. Ensuite un trait horizontal qui va de la gauche vers la droite, au niveau du centre de la courbe. Enfin, à son extrémité, un trait vertical qui descend du haut vers le bas.",
      "en": "The letter G is formed in three gestures. First a large curve open on the right. Then a horizontal line going from left to right, at the curve's center height. Finally, at its end, a vertical line going down from top to bottom."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 128.1 65.6 C 109.7 60.1 89.8 66.9 78.6 82.5 C 67.5 98.2 67.5 119.2 78.6 134.9 C 89.8 150.5 109.7 157.3 128.1 151.8",
        "startXY": [
          128.1,
          65.6
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Grande courbe ouverte à droite",
          "en": "Large curve open on the right"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 100.7 108.7 L 128.1 108.7",
        "startXY": [
          100.7,
          108.7
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal, de gauche à droite, au centre de la courbe",
          "en": "Horizontal line, left to right, at the curve's center"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 128.1 108.7 L 128.1 149.3",
        "startXY": [
          128.1,
          108.7
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, à l'extrémité de l'horizontale, du haut vers le bas",
          "en": "Vertical line, at the end of the horizontal, top to bottom"
        }
      }
    ]
  },
  {
    "char": "H",
    "name": {
      "fr": "H majuscule",
      "en": "uppercase H"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre H se forme en trois gestes. Deux traits verticaux parallèles, puis un trait horizontal qui les relie au milieu.",
      "en": "The letter H is formed in three gestures. Two parallel vertical lines, then a horizontal line linking them in the middle."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 61 18 L 61 149",
        "startXY": [
          61,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Premier trait vertical, à gauche",
          "en": "First vertical line, on the left"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 133 18 L 133 149",
        "startXY": [
          133,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Second trait vertical, à droite",
          "en": "Second vertical line, on the right"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 61 83.5 L 133 83.5",
        "startXY": [
          61,
          83.5
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal, relie les deux au milieu",
          "en": "Horizontal line, links the two in the middle"
        }
      }
    ]
  },
  {
    "char": "I",
    "name": {
      "fr": "I majuscule",
      "en": "uppercase I"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre I est un simple trait vertical pleine hauteur, tracé du haut vers le bas.",
      "en": "The letter I is a simple full-height vertical line, traced from top to bottom."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 97 18 L 97 149",
        "startXY": [
          97,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, du haut vers le bas",
          "en": "Vertical line, from top to bottom"
        }
      }
    ]
  },
  {
    "char": "J",
    "name": {
      "fr": "J majuscule",
      "en": "uppercase J"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre J se forme en un grand crochet : un trait vertical pleine hauteur qui s'arrondit vers la gauche tout en bas.",
      "en": "The letter J is formed as one large hook: a full-height vertical line curving to the left at the very bottom."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 77 18 L 77 117 C 77 125.3 70.3 132 62 132 C 53.7 132 47 125.3 47 117",
        "startXY": [
          77,
          18
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trait qui descend et s'arrondit à gauche en bas",
          "en": "Line going down and curving left at the bottom"
        }
      }
    ]
  },
  {
    "char": "K",
    "name": {
      "fr": "K majuscule",
      "en": "uppercase K"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre K se forme en trois gestes. Un trait vertical, puis une oblique du milieu vers le haut-droite, puis une oblique du milieu vers le bas-droite.",
      "en": "The letter K is formed in three gestures. A vertical line, then a diagonal from the middle to the upper right, then a diagonal from the middle to the lower right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 61 18 L 61 149",
        "startXY": [
          61,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical",
          "en": "Vertical line"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 61 113 L 133 18",
        "startXY": [
          61,
          113
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique du milieu vers le haut-droite",
          "en": "Diagonal from the middle to the upper right"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 61 113 L 133 149",
        "startXY": [
          61,
          113
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique du milieu vers le bas-droite",
          "en": "Diagonal from the middle to the lower right"
        }
      }
    ]
  },
  {
    "char": "L",
    "name": {
      "fr": "L majuscule",
      "en": "uppercase L"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre L se forme en deux gestes. Un trait vertical, puis un trait horizontal qui part du bas vers la droite.",
      "en": "The letter L is formed in two gestures. A vertical line, then a horizontal line going from the bottom toward the right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 61 18 L 61 149",
        "startXY": [
          61,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical",
          "en": "Vertical line"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 61 149 L 125 149",
        "startXY": [
          61,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Horizontale du bas",
          "en": "Bottom horizontal"
        }
      }
    ]
  },
  {
    "char": "M",
    "name": {
      "fr": "M majuscule",
      "en": "uppercase M"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre M se forme en quatre gestes. Un trait vertical à gauche, une oblique qui descend vers le centre, une oblique qui remonte vers la droite, puis un trait vertical à droite.",
      "en": "The letter M is formed in four gestures. A vertical line on the left, a diagonal going down to the center, a diagonal going up to the right, then a vertical line on the right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 57 18 L 57 149",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical gauche",
          "en": "Left vertical line"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 57 18 L 97 117",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique, sommet gauche vers le centre",
          "en": "Diagonal, left top to the center"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 97 117 L 137 18",
        "startXY": [
          97,
          117
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique, centre vers le sommet droit",
          "en": "Diagonal, center to the right top"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 137 18 L 137 149",
        "startXY": [
          137,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical droit",
          "en": "Right vertical line"
        }
      }
    ]
  },
  {
    "char": "N",
    "name": {
      "fr": "N majuscule",
      "en": "uppercase N"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre N se forme en trois gestes. Un trait vertical à gauche, une oblique qui relie son sommet à la base du second trait, puis le trait vertical à droite.",
      "en": "The letter N is formed in three gestures. A vertical line on the left, a diagonal linking its top to the base of the second line, then the vertical line on the right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 57 18 L 57 149",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical gauche",
          "en": "Left vertical line"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 57 18 L 137 149",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique, sommet gauche vers la base droite",
          "en": "Diagonal, left top to the right base"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 137 18 L 137 149",
        "startXY": [
          137,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical droit",
          "en": "Right vertical line"
        }
      }
    ]
  },
  {
    "char": "O",
    "name": {
      "fr": "O majuscule",
      "en": "uppercase O"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre O est un grand ovale complet. Pars du sommet et tourne dans le sens anti-horaire en un seul mouvement continu.",
      "en": "The letter O is a large full oval. Start at the top and turn counter-clockwise in one continuous motion."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 97 18 A 40 65.5 0 1 0 97.1 18",
        "startXY": [
          97,
          18
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Grand ovale complet, anti-horaire depuis le sommet",
          "en": "Large full oval, counter-clockwise from the top"
        }
      }
    ]
  },
  {
    "char": "P",
    "name": {
      "fr": "P majuscule",
      "en": "uppercase P"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre P se forme en deux gestes. Un trait vertical pleine hauteur, puis une courbe ronde accolée en haut à droite seulement.",
      "en": "The letter P is formed in two gestures. A full-height vertical line, then a round curve attached only to the upper right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 61 40.9 L 61 149",
        "startXY": [
          61,
          40.9
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical pleine hauteur",
          "en": "Full-height vertical line"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 73.8 40.9 C 86.3 32.2 103.3 34.2 113.4 45.6 C 123.5 56.9 123.5 74.1 113.4 85.4 C 103.3 96.8 86.3 98.8 73.8 90.1",
        "startXY": [
          73.8,
          40.9
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe du haut, accolée à droite",
          "en": "Upper curve, attached on the right"
        }
      }
    ]
  },
  {
    "char": "Q",
    "name": {
      "fr": "Q majuscule",
      "en": "uppercase Q"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre Q se forme en deux gestes. D'abord un grand ovale complet, comme le O. Ensuite une petite oblique qui sort du cercle vers le bas-droite.",
      "en": "The letter Q is formed in two gestures. First a large full oval, like the O. Then a small diagonal coming out of the circle toward the lower right."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 97 18 A 40 65.5 0 1 0 97.1 18",
        "startXY": [
          97,
          18
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Grand ovale complet",
          "en": "Large full oval"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 105 127 L 123 153",
        "startXY": [
          105,
          127
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Petite oblique sortant vers le bas-droite",
          "en": "Small diagonal coming out toward the lower right"
        }
      }
    ]
  },
  {
    "char": "R",
    "name": {
      "fr": "R majuscule",
      "en": "uppercase R"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre R se forme comme un P, avec une jambe en plus. Trait vertical, courbe en haut à droite, puis une oblique qui part du point de jonction vers le bas-droite.",
      "en": "The letter R is formed like a P, with an extra leg. Vertical line, curve at the upper right, then a diagonal starting from the junction point toward the lower right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 61 40.9 L 61 149",
        "startXY": [
          61,
          40.9
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical pleine hauteur",
          "en": "Full-height vertical line"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 73.8 40.9 C 86.3 32.2 103.3 34.2 113.4 45.6 C 123.5 56.9 123.5 74.1 113.4 85.4 C 103.3 96.8 86.3 98.8 73.8 90.1",
        "startXY": [
          73.8,
          40.9
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe du haut, accolée à droite",
          "en": "Upper curve, attached on the right"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 73.8 90.1 L 129 149",
        "startXY": [
          73.8,
          90.1
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Jambe oblique vers le bas-droite",
          "en": "Diagonal leg toward the lower right"
        }
      }
    ]
  },
  {
    "char": "S",
    "name": {
      "fr": "S majuscule",
      "en": "uppercase S"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre S se forme comme le s minuscule mais à pleine hauteur : un grand crochet en haut qui s'arrondit à droite, puis un grand crochet en bas qui s'arrondit à gauche.",
      "en": "The letter S is formed like the lowercase s but at full height: a large hook at the top curving right, then a large hook at the bottom curving left."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "top-right",
        "pathD": "M 127.1 40.6 C 121.5 25.3 105.4 16.6 89.6 20.4 C 73.8 24.1 63.3 39.1 65.2 55.2 C 67.1 71.3 80.8 83.5 97 83.5",
        "startXY": [
          127.1,
          40.6
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Grand crochet, s'arrondit vers la droite en haut",
          "en": "Large hook, curving right at the top"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 97 83.5 C 113.2 83.5 126.9 95.7 128.8 111.8 C 130.7 127.9 120.2 142.9 104.4 146.6 C 88.6 150.4 72.5 141.7 66.9 126.4",
        "startXY": [
          97,
          83.5
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Grand crochet, s'arrondit vers la gauche en bas",
          "en": "Large hook, curving left at the bottom"
        }
      }
    ]
  },
  {
    "char": "T",
    "name": {
      "fr": "T majuscule",
      "en": "uppercase T"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre T se forme en deux gestes. Un trait horizontal en haut, puis un trait vertical qui part du centre de l'horizontale vers le bas.",
      "en": "The letter T is formed in two gestures. A horizontal line at the top, then a vertical line starting from the center of the horizontal going down."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 57 18 L 137 18",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en haut",
          "en": "Horizontal line at the top"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 97 18 L 97 149",
        "startXY": [
          97,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, centré sous l'horizontale",
          "en": "Vertical line, centered under the horizontal"
        }
      }
    ]
  },
  {
    "char": "U",
    "name": {
      "fr": "U majuscule",
      "en": "uppercase U"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre U se forme en trois gestes. Un trait vertical à gauche, un grand crochet qui relie le bas des deux traits, puis le trait vertical à droite.",
      "en": "The letter U is formed in three gestures. A vertical line on the left, a large hook linking the bottom of the two lines, then the vertical line on the right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 57 18 L 57 119",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical gauche",
          "en": "Left vertical line"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom",
        "pathD": "M 57 117 C 57 139.1 74.9 157 97 157 C 119.1 157 137 139.1 137 117",
        "startXY": [
          57,
          117
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet bas, relie les deux traits",
          "en": "Bottom hook, links the two lines"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 137 18 L 137 119",
        "startXY": [
          137,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical droit",
          "en": "Right vertical line"
        }
      }
    ]
  },
  {
    "char": "V",
    "name": {
      "fr": "V majuscule",
      "en": "uppercase V"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre V se forme en deux gestes, comme le v minuscule mais à pleine hauteur. Une oblique qui descend du haut-gauche vers le centre-bas, puis une oblique qui remonte vers le haut-droite.",
      "en": "The letter V is formed in two gestures, like the lowercase v but at full height. A diagonal going down from the upper left to the center-bottom, then a diagonal going up to the upper right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 57 18 L 97 149",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique descendante, haut-gauche vers centre-bas",
          "en": "Diagonal going down, upper left to center-bottom"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 97 149 L 137 18",
        "startXY": [
          97,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique montante, centre-bas vers haut-droite",
          "en": "Diagonal going up, center-bottom to upper right"
        }
      }
    ]
  },
  {
    "char": "W",
    "name": {
      "fr": "W majuscule",
      "en": "uppercase W"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre W se forme en quatre obliques alternant descente et montée.",
      "en": "The letter W is formed with four diagonals alternating down and up."
    },
    "steps": [
      {
        "family": "traits",
        "variant": "oblique-gauche",
        "pathD": "M 53 18 L 75 149",
        "startXY": [
          53,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Première oblique descendante",
          "en": "First diagonal going down"
        }
      },
      {
        "family": "traits",
        "variant": "oblique-droit",
        "pathD": "M 75 149 L 97 18",
        "startXY": [
          75,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Deuxième oblique montante",
          "en": "Second diagonal going up"
        }
      },
      {
        "family": "traits",
        "variant": "oblique-gauche",
        "pathD": "M 97 18 L 119 149",
        "startXY": [
          97,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Troisième oblique descendante",
          "en": "Third diagonal going down"
        }
      },
      {
        "family": "traits",
        "variant": "oblique-droit",
        "pathD": "M 119 149 L 141 18",
        "startXY": [
          119,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Quatrième oblique montante",
          "en": "Fourth diagonal going up"
        }
      }
    ]
  },
  {
    "char": "X",
    "name": {
      "fr": "X majuscule",
      "en": "uppercase X"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre X se forme en deux traits obliques qui se croisent au centre, à pleine hauteur.",
      "en": "The letter X is formed with two diagonal lines crossing at the center, at full height."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 57 18 L 137 149",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique haut-gauche vers bas-droite",
          "en": "Diagonal upper left to lower right"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 137 18 L 57 149",
        "startXY": [
          137,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique haut-droite vers bas-gauche",
          "en": "Diagonal upper right to lower left"
        }
      }
    ]
  },
  {
    "char": "Y",
    "name": {
      "fr": "Y majuscule",
      "en": "uppercase Y"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre Y se forme en trois gestes. Deux obliques qui partent du sommet et se rejoignent au centre, puis un trait vertical court qui descend depuis ce point.",
      "en": "The letter Y is formed in three gestures. Two diagonals starting from the top and meeting at the center, then a short vertical line going down from that point."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 57 18 L 97 113",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique, sommet gauche vers le centre",
          "en": "Diagonal, left top to the center"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 137 18 L 97 113",
        "startXY": [
          137,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique, sommet droit vers le centre",
          "en": "Diagonal, right top to the center"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 97 113 L 97 149",
        "startXY": [
          97,
          113
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical court, centre vers le bas",
          "en": "Short vertical line, center to the bottom"
        }
      }
    ]
  },
  {
    "char": "Z",
    "name": {
      "fr": "Z majuscule",
      "en": "uppercase Z"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre Z se forme comme le z minuscule à pleine hauteur : un trait horizontal en haut, une oblique vers le bas-gauche, un trait horizontal en bas.",
      "en": "The letter Z is formed like the full-height lowercase z: a horizontal line at the top, a diagonal toward the lower left, a horizontal line at the bottom."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 57 18 L 137 18",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en haut",
          "en": "Horizontal line at the top"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 137 18 L 57 149",
        "startXY": [
          137,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique vers le bas-gauche",
          "en": "Diagonal toward the lower left"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 57 149 L 137 149",
        "startXY": [
          57,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en bas",
          "en": "Horizontal line at the bottom"
        }
      }
    ]
  }
]
''');

final List<dynamic> DIGITS = jsonDecode(r'''
[
  {
    "char": "0",
    "name": {
      "fr": "zéro",
      "en": "zero"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 0 est un ovale complet. Pars du sommet et tourne dans le sens anti-horaire.",
      "en": "The digit 0 is a full oval. Start at the top and turn counter-clockwise."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 97 77 A 36 36 0 1 0 97.1 77",
        "startXY": [
          97,
          77
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Ovale complet, anti-horaire depuis le sommet",
          "en": "Full oval, counter-clockwise from the top"
        }
      }
    ]
  },
  {
    "char": "1",
    "name": {
      "fr": "un",
      "en": "one"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 1 se forme en deux gestes. Une petite amorce oblique qui rejoint le sommet, puis un trait vertical qui descend jusqu'à la ligne.",
      "en": "The digit 1 is formed in two gestures. A small diagonal lead-in reaching the top, then a vertical line going down to the baseline."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 83 89 L 97 77",
        "startXY": [
          83,
          89
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Amorce oblique vers le sommet",
          "en": "Diagonal lead-in to the top"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 97 77 L 97 149",
        "startXY": [
          97,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, du haut vers le bas",
          "en": "Vertical line, from top to bottom"
        }
      }
    ]
  },
  {
    "char": "2",
    "name": {
      "fr": "deux",
      "en": "two"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 2 se forme en trois gestes. Une courbe en haut qui ressemble à un crochet renversé, une oblique qui descend vers le bas-gauche, puis un trait horizontal à la base.",
      "en": "The digit 2 is formed in three gestures. A curve at the top like an upside-down hook, a diagonal going down to the lower left, then a horizontal line at the base."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "top",
        "pathD": "M 67 85 C 67 68.4 80.4 55 97 55 C 113.6 55 127 68.4 127 85",
        "startXY": [
          67,
          85
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe du haut, en crochet renversé",
          "en": "Curve at the top, like an upside-down hook"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 127 85 L 65 149",
        "startXY": [
          127,
          85
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique vers le bas-gauche",
          "en": "Diagonal toward the lower left"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 65 149 L 131 149",
        "startXY": [
          65,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal à la base",
          "en": "Horizontal line at the base"
        }
      }
    ]
  },
  {
    "char": "3",
    "name": {
      "fr": "trois",
      "en": "three"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 3 se forme en deux courbes empilées, ouvertes vers la gauche, qui se touchent au centre.",
      "en": "The digit 3 is formed with two stacked curves, open to the left, touching in the middle."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 68.3 95.8 C 66.7 86.7 71 77.6 79 72.9 C 87 68.3 97.1 69.2 104.1 75.1 C 111.2 81.1 113.8 90.8 110.7 99.5 C 107.5 108.2 99.2 114 90 114",
        "startXY": [
          68.3,
          95.8
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe du haut, ouverte à gauche",
          "en": "Upper curve, open to the left"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 90 114 C 99.2 114 107.5 119.8 110.7 128.5 C 113.8 137.2 111.2 146.9 104.1 152.9 C 97.1 158.8 87 159.7 79 155.1 C 71 150.4 66.7 141.3 68.3 132.2",
        "startXY": [
          90,
          114
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe du bas, ouverte à gauche",
          "en": "Lower curve, open to the left"
        }
      }
    ]
  },
  {
    "char": "4",
    "name": {
      "fr": "quatre",
      "en": "four"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 4 se forme en trois gestes. Une oblique qui descend vers le bas-gauche, un trait horizontal à sa base, puis un trait vertical qui traverse l'horizontale et dépasse vers le haut.",
      "en": "The digit 4 is formed in three gestures. A diagonal going down to the lower left, a horizontal line at its base, then a vertical line crossing the horizontal and going past it at the top."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 123 77 L 67 123",
        "startXY": [
          123,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique vers le bas-gauche",
          "en": "Diagonal toward the lower left"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 67 123 L 131 123",
        "startXY": [
          67,
          123
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal, base de l'oblique",
          "en": "Horizontal line, base of the diagonal"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 123 71 L 123 149",
        "startXY": [
          123,
          71
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical qui traverse et dépasse",
          "en": "Vertical line crossing and going past"
        }
      }
    ]
  },
  {
    "char": "5",
    "name": {
      "fr": "cinq",
      "en": "five"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 5 se forme en trois gestes. Un trait horizontal en haut, un petit trait vertical qui descend à gauche, puis un crochet qui balaie un grand arc, de haut en bas, en restant aligné à la verticale entre son origine et son extrémité.",
      "en": "The digit 5 is formed in three gestures. A horizontal line at the top, a small vertical line going down on the left, then a hook sweeping a large arc, top to bottom, with its start and end vertically aligned."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 74 77 L 114 77",
        "startXY": [
          74,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en haut",
          "en": "Horizontal line at the top"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 75 82 L 75 116",
        "startXY": [
          75,
          82
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Petit trait vertical à gauche",
          "en": "Small vertical line on the left"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom-right",
        "pathD": "M 75 116 C 87.6 108.2 104 110.7 113.7 121.9 C 123.4 133.2 123.4 149.8 113.7 161.1 C 104 172.3 87.6 174.8 75 166.9",
        "startXY": [
          75,
          116
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet qui balaie un grand arc et redescend aligné avec son point de départ",
          "en": "Hook sweeping a large arc and coming back down aligned with its starting point"
        }
      }
    ]
  },
  {
    "char": "6",
    "name": {
      "fr": "six",
      "en": "six"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 6 se forme comme le 9, mais inversé : d'abord un crochet qui part du haut, descend et s'arrondit en haut à droite, puis un anneau fermé en bas, dessiné dans le sens anti-horaire à partir du point où s'arrête le crochet.",
      "en": "The digit 6 is formed like the 9, but inverted: first a hook starting at the top, going down and curving at the upper right, then a closed ring at the bottom, drawn counterclockwise starting exactly where the hook ends."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "top-right",
        "pathD": "M 116 101 C 116 88.3 105.7 78 93 78 C 80.3 78 70 88.3 70 101 L 70 138",
        "startXY": [
          116,
          101
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet qui part de la courbure en haut à droite, puis descend tout droit",
          "en": "Hook starting from the upper-right curve, then going straight down"
        }
      },
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 70 138 A 21 21 0 1 0 112 138 A 21 21 0 1 0 70 138",
        "startXY": [
          80,
          138
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Anneau fermé en bas, tracé dans le sens anti-horaire à partir du point d'arrêt du crochet",
          "en": "Closed ring at the bottom, drawn counterclockwise from the hook's end point"
        }
      }
    ]
  },
  {
    "char": "7",
    "name": {
      "fr": "sept",
      "en": "seven"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 7 se forme en deux gestes. Un trait horizontal en haut, puis une oblique qui descend du haut-droite vers le bas-centre.",
      "en": "The digit 7 is formed in two gestures. A horizontal line at the top, then a diagonal going down from the upper right to the center-bottom."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 65 77 L 131 77",
        "startXY": [
          65,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en haut",
          "en": "Horizontal line at the top"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 131 77 L 91 149",
        "startXY": [
          131,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique vers le bas-centre",
          "en": "Diagonal toward the center-bottom"
        }
      }
    ]
  },
  {
    "char": "8",
    "name": {
      "fr": "huit",
      "en": "eight"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 8 se forme en deux petits anneaux empilés, celui du haut un peu plus petit que celui du bas.",
      "en": "The digit 8 is formed with two small stacked rings, the top one a little smaller than the bottom one."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 97 77 A 22 18 0 1 0 97.1 77",
        "startXY": [
          97,
          77
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Petit anneau du haut",
          "en": "Small upper ring"
        }
      },
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 97 111 A 24 20 0 1 0 97.1 111",
        "startXY": [
          97,
          111
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Anneau du bas, légèrement plus grand",
          "en": "Bottom ring, slightly larger"
        }
      }
    ]
  },
  {
    "char": "9",
    "name": {
      "fr": "neuf",
      "en": "nine"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 9 se forme comme le 6 mais inversé. D'abord un anneau fermé en haut, dessiné dans le sens anti-horaire, puis un crochet tangent au bord droit de l'anneau, qui descend et s'arrondit en bas à gauche.",
      "en": "The digit 9 is formed like the 6 but inverted. First a closed ring at the top, drawn counterclockwise, then a hook tangent to the ring's right edge, going down and curving at the lower left."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 112 108 A 21 21 0 1 0 70 108 A 21 21 0 1 0 112 108",
        "startXY": [
          112,
          108
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Anneau fermé en haut, tracé dans le sens anti-horaire",
          "en": "Closed ring at the top, drawn counterclockwise"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 112 108 L 112 145 C 112 157.7 101.7 168 89 168 C 76.3 168 66 157.7 66 145",
        "startXY": [
          112,
          108
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet tangent au bord droit de l'anneau, descend puis s'arrondit en bas à gauche",
          "en": "Hook tangent to the ring's right edge, going down then curving at the lower left"
        }
      }
    ]
  }
]
''');

final List<dynamic> LETTER_CATALOG = jsonDecode(r'''
[
  {
    "char": "a",
    "name": {
      "fr": "a minuscule",
      "en": "lowercase a"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre A se forme en deux gestes. D'abord, trace une courbe bien ronde, presque fermée, qui ne reste ouverte qu'à droite. Ensuite, ajoute un trait vertical qui vient refermer cette ouverture, du haut vers le bas.",
      "en": "The letter A is formed in two gestures. First, trace a nicely round curve, almost closed, staying open only at the right. Then, add a vertical line that closes that opening, from top to bottom."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 125 90.4 C 118.2 81.9 107.9 77 97 77 C 77.1 77 61 93.1 61 113 C 61 132.9 77.1 149 97 149 C 107.9 149 118.2 144.1 125 135.6",
        "startXY": [
          125,
          90.4
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe circulaire presque fermée, ouverte à droite horizontalement",
          "en": "Circular curve almost closed, open horizontally at the right"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 125 90.4 L 125 135.6",
        "startXY": [
          125,
          90.4
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical qui referme la courbe, du haut vers le bas",
          "en": "Vertical line that closes the curve, from top to bottom"
        }
      }
    ]
  },
  {
    "char": "e",
    "name": {
      "fr": "e minuscule",
      "en": "lowercase e"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre E se forme en deux gestes. D'abord, trace un trait horizontal au milieu. Ensuite, dessine une courbe bien ronde qui part de la pointe du trait, encercle tout le tour et s'ouvre juste un peu en bas à droite.",
      "en": "The letter E is formed in two gestures. First, trace a horizontal line in the middle. Then, draw a nicely round curve that starts from the tip of the line, circles all the way round and opens just a little at the bottom right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 68 118 L 136 118",
        "startXY": [
          68,
          118
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal au centre, de gauche à droite",
          "en": "Horizontal line in the center, left to right"
        }
      },
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 136 118 C 136 98.1 119.9 82 100 82 C 80.1 82 64 98.1 64 118 C 64 137.9 80.1 154 100 154",
        "startXY": [
          136,
          118
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe qui entoure le trait, ouverte en bas à droite",
          "en": "Curve that surrounds the line, open at the bottom right"
        }
      }
    ]
  },
  {
    "char": "i",
    "name": {
      "fr": "i minuscule",
      "en": "lowercase i"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre I se forme en deux gestes. D'abord, trace un trait vertical dans le corps de la ligne. Ensuite, pose un point rond au-dessus du trait, sans le toucher.",
      "en": "The letter I is formed in two gestures. First, trace a vertical line in the body of the writing line. Then, place a round dot above the line, without touching it."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 100 78 L 100 150",
        "startXY": [
          100,
          78
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, du haut vers le bas",
          "en": "Vertical line, from top to bottom"
        }
      },
      {
        "family": "point",
        "variant": "center",
        "pathD": "M 100 41 A 11 11 0 1 0 100.1 41",
        "startXY": [
          100,
          41
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Point au-dessus du trait, petit rond détaché",
          "en": "Dot above the line, small detached circle"
        }
      }
    ]
  },
  {
    "char": "o",
    "name": {
      "fr": "o minuscule",
      "en": "lowercase o"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre O est un ovale complet. Pars du sommet et tourne dans le sens anti-horaire en un seul mouvement continu, doux et régulier.",
      "en": "The letter O is a full oval. Start at the top and turn counter-clockwise in one smooth, continuous motion."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 100 55 A 42 47 0 1 0 100.1 55",
        "startXY": [
          100,
          55
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Ovale complet, anti-horaire depuis le sommet",
          "en": "Full oval, counter-clockwise from the top"
        }
      }
    ]
  },
  {
    "char": "u",
    "name": {
      "fr": "u minuscule",
      "en": "lowercase u"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre U se forme en deux gestes. D'abord, trace un crochet bas-droite : descends puis arrondis doucement vers la droite en bas. Ensuite, ajoute un trait vertical sur le bord droit, du haut vers le bas.",
      "en": "The letter U is formed in two gestures. First, trace a bottom-right hook: go down, then curve gently to the right at the bottom. Then, add a vertical line on the right edge, from top to bottom."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "bottom-right",
        "pathD": "M 68 60 L 68 118 C 68 140 84 150 102 150 C 120 150 132 140 132 118",
        "startXY": [
          68,
          60
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet bas-droite : descends puis arrondis à droite",
          "en": "Bottom-right hook: go down then curve to the right"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 132 60 L 132 150",
        "startXY": [
          132,
          60
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical accolé à droite, du haut vers le bas",
          "en": "Vertical line on the right edge, from top to bottom"
        }
      }
    ]
  },
  {
    "char": "b",
    "name": {
      "fr": "b minuscule",
      "en": "lowercase b"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre B se forme en deux gestes. D'abord, trace un trait vertical qui monte en zone haute. Ensuite, ajoute une courbe ronde accolée en bas à droite du trait.",
      "en": "The letter B is formed in two gestures. First, trace a vertical line rising into the ascender zone. Then, add a round curve attached to the lower right of the line."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 68 27 L 68 149",
        "startXY": [
          68,
          27
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, monte en zone haute",
          "en": "Vertical line, rising into the ascender zone"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 76 98.3 C 85.6 86.5 101.6 82 116 87.1 C 130.4 92.2 140 105.8 140 121 C 140 136.2 130.4 149.8 116 154.9 C 101.6 160 85.6 155.5 76 143.7",
        "startXY": [
          76,
          98.3
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde accolée en bas à droite du trait",
          "en": "Round curve attached to the lower right of the line"
        }
      }
    ]
  },
  {
    "char": "c",
    "name": {
      "fr": "c minuscule",
      "en": "lowercase c"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre C est une courbe ronde, presque fermée, ouverte seulement à droite. Trace-la en un seul geste, en partant du haut.",
      "en": "The letter C is a round curve, almost closed, open only on the right. Trace it in a single motion, starting from the top."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 125 90.3 C 115.4 78.5 99.4 74 85 79.1 C 70.6 84.2 61 97.8 61 113 C 61 128.2 70.6 141.8 85 146.9 C 99.4 152 115.4 147.5 125 135.7",
        "startXY": [
          125,
          90.3
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde ouverte à droite, un seul geste",
          "en": "Round curve open on the right, single motion"
        }
      }
    ]
  },
  {
    "char": "d",
    "name": {
      "fr": "d minuscule",
      "en": "lowercase d"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre D se forme en deux gestes. D'abord, trace une courbe ronde ouverte à droite. Ensuite, ajoute un trait vertical sur le bord droit, qui monte cette fois en zone haute.",
      "en": "The letter D is formed in two gestures. First, trace a round curve open on the right. Then, add a vertical line on the right edge, this time rising into the ascender zone."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 125 90.3 C 115.4 78.5 99.4 74 85 79.1 C 70.6 84.2 61 97.8 61 113 C 61 128.2 70.6 141.8 85 146.9 C 99.4 152 115.4 147.5 125 135.7",
        "startXY": [
          125,
          90.3
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde ouverte à droite",
          "en": "Round curve open on the right"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 125 27 L 125 149",
        "startXY": [
          125,
          27
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical à droite, prolongé vers le haut",
          "en": "Vertical line on the right, extended upward"
        }
      }
    ]
  },
  {
    "char": "f",
    "name": {
      "fr": "f minuscule",
      "en": "lowercase f"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre F se forme en deux gestes. D'abord, trace un grand trait qui monte en zone haute et se termine par un petit crochet arrondi vers la droite en haut. Ensuite, ajoute un trait horizontal qui traverse le trait vertical.",
      "en": "The letter F is formed in two gestures. First, trace a tall line rising into the ascender zone, finishing with a small rounded hook to the right at the top. Then, add a horizontal line crossing the vertical line."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "top-right",
        "pathD": "M 115 41 C 115 31.1 106.9 23 97 23 C 87.1 23 79 31.1 79 41 L 79 149",
        "startXY": [
          115,
          41
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trait qui monte et s'arrondit vers la droite en haut",
          "en": "Line rising and curving right at the top"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 63 99 L 99 99",
        "startXY": [
          63,
          99
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal qui coupe le crochet",
          "en": "Horizontal line cutting across the hook"
        }
      }
    ]
  },
  {
    "char": "g",
    "name": {
      "fr": "g minuscule",
      "en": "lowercase g"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre G se forme en deux gestes. D'abord, trace une courbe ronde ouverte à droite. Ensuite, ajoute un crochet qui descend en zone basse et s'arrondit vers la gauche.",
      "en": "The letter G is formed in two gestures. First, trace a round curve open on the right. Then, add a hook going down into the descender zone, curving to the left."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 111.8 77.4 C 104.3 68.2 91.8 64.6 80.7 68.6 C 69.5 72.6 62 83.1 62 95 C 62 106.9 69.5 117.4 80.7 121.4 C 91.8 125.4 104.3 121.8 111.8 112.6",
        "startXY": [
          111.8,
          77.4
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde ouverte à droite",
          "en": "Round curve open on the right"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 111.8 77.4 L 111.8 165 C 111.8 172.2 105.9 178 98.8 178 C 91.6 178 85.8 172.2 85.8 165",
        "startXY": [
          111.8,
          77.4
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trait qui descend en zone basse et s'arrondit à gauche",
          "en": "Line going down into the descender zone, curving left"
        }
      }
    ]
  },
  {
    "char": "h",
    "name": {
      "fr": "h minuscule",
      "en": "lowercase h"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre H se forme en deux gestes. D'abord, trace un trait vertical qui monte en zone haute. Ensuite, ajoute un crochet qui part du trait, s'arrondit vers le haut puis redescend jusqu'à la ligne.",
      "en": "The letter H is formed in two gestures. First, trace a vertical line rising into the ascender zone. Then, add a hook starting from the line, arching up and coming back down to the baseline."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 68 27 L 68 149",
        "startXY": [
          68,
          27
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, monte en zone haute",
          "en": "Vertical line, rising into the ascender zone"
        }
      },
      {
        "family": "crochet",
        "variant": "top-left",
        "pathD": "M 68 90 C 68 76.7 78.7 66 92 66 C 105.3 66 116 76.7 116 90 L 116 149",
        "startXY": [
          68,
          90
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet accolé en bas à droite du trait",
          "en": "Hook attached to the lower right of the line"
        }
      }
    ]
  },
  {
    "char": "j",
    "name": {
      "fr": "j minuscule",
      "en": "lowercase j"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre J se forme en deux gestes. D'abord, trace un trait qui descend en zone basse et s'arrondit vers la gauche. Ensuite, pose un point rond au-dessus, sans le toucher.",
      "en": "The letter J is formed in two gestures. First, trace a line going down into the descender zone, curving to the left. Then, place a round dot above, without touching it."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 113 77 L 113 162 C 113 169.2 107.2 175 100 175 C 92.8 175 87 169.2 87 162",
        "startXY": [
          113,
          77
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trait qui descend en zone basse et s'arrondit à gauche",
          "en": "Line going down into the descender zone, curving left"
        }
      },
      {
        "family": "point",
        "variant": "center",
        "pathD": "M 113 48 A 7 7 0 1 0 113.1 48",
        "startXY": [
          113,
          48
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Point au-dessus, sans toucher le crochet",
          "en": "Dot above, without touching the hook"
        }
      }
    ]
  },
  {
    "char": "k",
    "name": {
      "fr": "k minuscule",
      "en": "lowercase k"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre K se forme en trois gestes. D'abord, trace un trait vertical qui monte en zone haute. Ensuite, trace un premier trait oblique du milieu vers le haut-droite. Enfin, trace un second trait oblique du milieu vers le bas-droite.",
      "en": "The letter K is formed in three gestures. First, trace a vertical line rising into the ascender zone. Then, trace a diagonal line from the middle toward the upper right. Finally, trace a second diagonal line from the middle toward the lower right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 68 27 L 68 149",
        "startXY": [
          68,
          27
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, monte en zone haute",
          "en": "Vertical line, rising into the ascender zone"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 68 113 L 102 77",
        "startXY": [
          68,
          113
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique du milieu du trait vers le haut-droite",
          "en": "Diagonal from the middle of the line toward the upper right"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 68 113 L 102 149",
        "startXY": [
          68,
          113
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique du milieu du trait vers le bas-droite",
          "en": "Diagonal from the middle of the line toward the lower right"
        }
      }
    ]
  },
  {
    "char": "l",
    "name": {
      "fr": "l minuscule",
      "en": "lowercase l"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre L est un simple trait vertical qui monte en zone haute. Trace-le d'un seul geste, du haut vers le bas.",
      "en": "The letter L is a simple vertical line rising into the ascender zone. Trace it in a single motion, from top to bottom."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 97 27 L 97 149",
        "startXY": [
          97,
          27
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, du haut vers le bas",
          "en": "Vertical line, from top to bottom"
        }
      }
    ]
  },
  {
    "char": "m",
    "name": {
      "fr": "m minuscule",
      "en": "lowercase m"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre M se forme en trois gestes. D'abord, trace un trait vertical court. Ensuite, ajoute un premier crochet qui s'arrondit vers le haut. Enfin, ajoute un second crochet identique, juste à côté.",
      "en": "The letter M is formed in three gestures. First, trace a short vertical line. Then, add a first hook arching upward. Finally, add a second matching hook right next to it."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 55 77 L 55 149",
        "startXY": [
          55,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical court",
          "en": "Short vertical line"
        }
      },
      {
        "family": "crochet",
        "variant": "top-left",
        "pathD": "M 55 77 C 55 67.6 62.6 60 72 60 C 81.4 60 89 67.6 89 77 L 89 149",
        "startXY": [
          55,
          77
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Premier crochet, accolé à droite du trait",
          "en": "First hook, attached to the right of the line"
        }
      },
      {
        "family": "crochet",
        "variant": "top-left",
        "pathD": "M 89 77 C 89 67.6 96.6 60 106 60 C 115.4 60 123 67.6 123 77 L 123 149",
        "startXY": [
          89,
          77
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Second crochet, accolé au premier",
          "en": "Second hook, attached to the first"
        }
      }
    ]
  },
  {
    "char": "n",
    "name": {
      "fr": "n minuscule",
      "en": "lowercase n"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre N se forme en deux gestes. D'abord, trace un trait vertical court. Ensuite, ajoute un crochet qui s'arrondit vers le haut puis redescend jusqu'à la ligne.",
      "en": "The letter N is formed in two gestures. First, trace a short vertical line. Then, add a hook arching upward and coming back down to the baseline."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 68 77 L 68 149",
        "startXY": [
          68,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical court",
          "en": "Short vertical line"
        }
      },
      {
        "family": "crochet",
        "variant": "top-left",
        "pathD": "M 68 77 C 68 59.3 82.3 45 100 45 C 117.7 45 132 59.3 132 77 L 132 149",
        "startXY": [
          68,
          77
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet accolé à droite du trait",
          "en": "Hook attached to the right of the line"
        }
      }
    ]
  },
  {
    "char": "p",
    "name": {
      "fr": "p minuscule",
      "en": "lowercase p"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre P se forme en deux gestes. D'abord, trace un trait vertical qui descend en zone basse. Ensuite, ajoute une courbe ronde accolée en haut à droite du trait.",
      "en": "The letter P is formed in two gestures. First, trace a vertical line going down into the descender zone. Then, add a round curve attached to the upper right of the line."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 68 62 L 68 179",
        "startXY": [
          68,
          62
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, descend en zone basse",
          "en": "Vertical line, going down into the descender zone"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 76 67.3 C 85.6 55.5 101.6 51 116 56.1 C 130.4 61.2 140 74.8 140 90 C 140 105.2 130.4 118.8 116 123.9 C 101.6 129 85.6 124.5 76 112.7",
        "startXY": [
          76,
          67.3
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde accolée en haut à droite du trait",
          "en": "Round curve attached to the upper right of the line"
        }
      }
    ]
  },
  {
    "char": "q",
    "name": {
      "fr": "q minuscule",
      "en": "lowercase q"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre Q se forme en deux gestes. D'abord, trace une courbe ronde ouverte à droite. Ensuite, ajoute un trait vertical sur le bord droit, qui descend cette fois en zone basse.",
      "en": "The letter Q is formed in two gestures. First, trace a round curve open on the right. Then, add a vertical line on the right edge, this time going down into the descender zone."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 125 75.3 C 115.4 63.5 99.4 59 85 64.1 C 70.6 69.2 61 82.8 61 98 C 61 113.2 70.6 126.8 85 131.9 C 99.4 137 115.4 132.5 125 120.7",
        "startXY": [
          125,
          75.3
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde ouverte à droite",
          "en": "Round curve open on the right"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 125 62 L 125 179",
        "startXY": [
          125,
          62
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical à droite, prolongé vers le bas",
          "en": "Vertical line on the right, extended downward"
        }
      }
    ]
  },
  {
    "char": "r",
    "name": {
      "fr": "r minuscule",
      "en": "lowercase r"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre R se forme en deux gestes. D'abord, trace un trait vertical court. Ensuite, ajoute un petit crochet en haut à droite, qui ne descend pas jusqu'à la ligne.",
      "en": "The letter R is formed in two gestures. First, trace a short vertical line. Then, add a small hook at the upper right, which doesn't reach the baseline."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 71 77 L 71 149",
        "startXY": [
          71,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical court",
          "en": "Short vertical line"
        }
      },
      {
        "family": "crochet",
        "variant": "top-right",
        "pathD": "M 71 92 C 71 84.8 76.8 79 84 79 C 91.2 79 97 84.8 97 92",
        "startXY": [
          71,
          92
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Petit crochet en haut à droite du trait",
          "en": "Small hook at the upper right of the line"
        }
      }
    ]
  },
  {
    "char": "s",
    "name": {
      "fr": "s minuscule",
      "en": "lowercase s"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre S se forme en deux gestes enchaînés. D'abord, un petit crochet en haut qui s'arrondit vers la droite. Ensuite, sans lever le crayon, un second petit crochet en bas qui s'arrondit vers la gauche.",
      "en": "The letter S is formed in two linked gestures. First, a small hook at the top curving to the right. Then, without lifting the pencil, a second small hook at the bottom curving to the left."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "top-right",
        "pathD": "M 117.7 83.5 C 113.9 73 102.8 67 91.9 69.6 C 81.1 72.2 73.9 82.5 75.1 93.6 C 76.4 104.6 85.8 113 97 113",
        "startXY": [
          117.7,
          83.5
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Petit crochet, s'arrondit vers la droite en haut",
          "en": "Small hook, curving right at the top"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 97 113 C 108.2 113 117.6 121.4 118.9 132.4 C 120.1 143.5 112.9 153.8 102.1 156.4 C 91.2 159 80.1 153 76.3 142.5",
        "startXY": [
          97,
          113
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Petit crochet, s'arrondit vers la gauche en bas",
          "en": "Small hook, curving left at the bottom"
        }
      }
    ]
  },
  {
    "char": "t",
    "name": {
      "fr": "t minuscule",
      "en": "lowercase t"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre T se forme en deux gestes. D'abord, trace un trait vertical qui monte en zone haute. Ensuite, ajoute un trait horizontal qui le traverse, plus haut que pour le F.",
      "en": "The letter T is formed in two gestures. First, trace a vertical line rising into the ascender zone. Then, add a horizontal line crossing it, higher than for the F."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 97 27 L 97 149",
        "startXY": [
          97,
          27
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, monte en zone haute",
          "en": "Vertical line, rising into the ascender zone"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 77 51 L 117 51",
        "startXY": [
          77,
          51
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal qui traverse, en haut de la zone haute",
          "en": "Horizontal line crossing, high in the ascender zone"
        }
      }
    ]
  },
  {
    "char": "v",
    "name": {
      "fr": "v minuscule",
      "en": "lowercase v"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre V se forme en deux gestes. D'abord, un trait oblique qui descend du haut-gauche vers le centre-bas. Ensuite, un trait oblique qui remonte du centre-bas vers le haut-droite.",
      "en": "The letter V is formed in two gestures. First, a diagonal line going down from the upper left to the center-bottom. Then, a diagonal line going up from the center-bottom to the upper right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 65 77 L 97 149",
        "startXY": [
          65,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique descendante, haut-gauche vers centre-bas",
          "en": "Diagonal going down, upper left to center-bottom"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 97 149 L 129 77",
        "startXY": [
          97,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique montante, centre-bas vers haut-droite",
          "en": "Diagonal going up, center-bottom to upper right"
        }
      }
    ]
  },
  {
    "char": "w",
    "name": {
      "fr": "w minuscule",
      "en": "lowercase w"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre W se forme en quatre traits obliques qui s'enchaînent, alternant descente et montée, comme deux V collés.",
      "en": "The letter W is formed with four diagonal lines linked together, alternating down and up, like two Vs side by side."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 57 77 L 77 149",
        "startXY": [
          57,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Première oblique descendante",
          "en": "First diagonal going down"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 77 149 L 97 77",
        "startXY": [
          77,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Deuxième oblique montante",
          "en": "Second diagonal going up"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 97 77 L 117 149",
        "startXY": [
          97,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Troisième oblique descendante",
          "en": "Third diagonal going down"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 117 149 L 137 77",
        "startXY": [
          117,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Quatrième oblique montante",
          "en": "Fourth diagonal going up"
        }
      }
    ]
  },
  {
    "char": "x",
    "name": {
      "fr": "x minuscule",
      "en": "lowercase x"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre X se forme en deux traits obliques qui se croisent au centre. D'abord du haut-gauche vers le bas-droite, puis du haut-droite vers le bas-gauche.",
      "en": "The letter X is formed with two diagonal lines crossing at the center. First from the upper left to the lower right, then from the upper right to the lower left."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 65 77 L 129 149",
        "startXY": [
          65,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique haut-gauche vers bas-droite",
          "en": "Diagonal upper left to lower right"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 129 77 L 65 149",
        "startXY": [
          129,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique haut-droite vers bas-gauche",
          "en": "Diagonal upper right to lower left"
        }
      }
    ]
  },
  {
    "char": "y",
    "name": {
      "fr": "y minuscule",
      "en": "lowercase y"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre Y se forme en deux gestes. D'abord, une diagonale du haut-gauche qui descend jusqu'au point de croisement sur la ligne de base. Ensuite, une diagonale du haut-droite qui passe par le même point, puis continue en zone basse et se termine par un petit crochet vers la gauche.",
      "en": "The letter Y is formed in two gestures. First, a diagonal from the upper left descending to the crossing point on the baseline. Then, a diagonal from the upper right passing through the same point, continuing into the descender zone and ending with a small hook to the left."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 65 77 L 97 149",
        "startXY": [
          65,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Diagonale du haut-gauche vers le point de croisement sur la ligne de base",
          "en": "Diagonal from upper left to the crossing point on the baseline"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 129 77 L 97 149 L 83 185",
        "startXY": [
          129,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Diagonale du haut-droite, croise, descend en zone basse",
          "en": "Diagonal from upper right, crosses, descends into the descender zone"
        }
      }
    ]
  },
  {
    "char": "z",
    "name": {
      "fr": "z minuscule",
      "en": "lowercase z"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre Z se forme en trois gestes enchaînés sans lever le crayon : un trait horizontal en haut, un trait oblique vers le bas-gauche, puis un trait horizontal en bas.",
      "en": "The letter Z is formed in three linked gestures without lifting the pencil: a horizontal line at the top, a diagonal going to the lower left, then a horizontal line at the bottom."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 63 77 L 131 77",
        "startXY": [
          63,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en haut",
          "en": "Horizontal line at the top"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 131 77 L 63 149",
        "startXY": [
          131,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique vers le bas-gauche",
          "en": "Diagonal toward the lower left"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 63 149 L 131 149",
        "startXY": [
          63,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en bas",
          "en": "Horizontal line at the bottom"
        }
      }
    ]
  },
  {
    "char": "A",
    "name": {
      "fr": "A majuscule",
      "en": "uppercase A"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre A se forme en trois gestes. D'abord une oblique du sommet vers le bas-gauche, puis une oblique du sommet vers le bas-droite, enfin une barre horizontale qui relie les deux obliques à mi-hauteur.",
      "en": "The letter A is formed in three gestures. First a diagonal from the top to the lower left, then a diagonal from the top to the lower right, finally a horizontal bar linking the two diagonals at mid-height."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 97 18 L 55 149",
        "startXY": [
          97,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique du sommet vers le bas-gauche",
          "en": "Diagonal from the top to the lower left"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 97 18 L 139 149",
        "startXY": [
          97,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique du sommet vers le bas-droite",
          "en": "Diagonal from the top to the lower right"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 69 123 L 125 123",
        "startXY": [
          69,
          123
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Barre horizontale médiane",
          "en": "Horizontal middle bar"
        }
      }
    ]
  },
  {
    "char": "B",
    "name": {
      "fr": "B majuscule",
      "en": "uppercase B"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre B se forme en trois gestes. D'abord un trait vertical pleine hauteur. Ensuite une courbe ronde accolée en haut à droite. Enfin une seconde courbe ronde accolée en bas à droite, qui touche la première au milieu.",
      "en": "The letter B is formed in three gestures. First a full-height vertical line. Then a round curve attached to the upper right. Finally a second round curve attached to the lower right, touching the first in the middle."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 73.8 40.9 L 73.8 155.6",
        "startXY": [
          73.8,
          40.9
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical pleine hauteur",
          "en": "Full-height vertical line"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 73.8 40.9 C 86.3 32.2 103.3 34.2 113.4 45.6 C 123.5 56.9 123.5 74.1 113.4 85.4 C 103.3 96.8 86.3 98.8 73.8 90.1",
        "startXY": [
          73.8,
          40.9
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe du haut, accolée à droite",
          "en": "Upper curve, attached on the right"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 73.8 106.4 C 86.3 97.7 103.3 99.7 113.4 111.1 C 123.5 122.4 123.5 139.6 113.4 150.9 C 103.3 162.3 86.3 164.3 73.8 155.6",
        "startXY": [
          73.8,
          106.4
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe du bas, accolée à droite",
          "en": "Lower curve, attached on the right"
        }
      }
    ]
  },
  {
    "char": "C",
    "name": {
      "fr": "C majuscule",
      "en": "uppercase C"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre C est une grande courbe ronde, presque fermée, ouverte seulement à droite. Trace-la en un seul geste depuis le haut.",
      "en": "The letter C is a large round curve, almost closed, open only on the right. Trace it in a single motion from the top."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 128.1 58.3 C 117.4 45.2 99.6 40.1 83.6 45.8 C 67.7 51.5 57 66.6 57 83.5 C 57 100.4 67.7 115.5 83.6 121.2 C 99.6 126.9 117.4 121.8 128.1 108.7",
        "startXY": [
          128.1,
          58.3
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Grande courbe ouverte à droite",
          "en": "Large curve open on the right"
        }
      }
    ]
  },
  {
    "char": "D",
    "name": {
      "fr": "D majuscule",
      "en": "uppercase D"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre D se forme en deux gestes. D'abord un trait vertical pleine hauteur. Ensuite une grande courbe qui referme l'ouverture en haut et en bas, accolée à droite du trait.",
      "en": "The letter D is formed in two gestures. First a full-height vertical line. Then a large curve closing the opening at the top and bottom, attached to the right of the line."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 75 48.9 L 75 118.1",
        "startXY": [
          75,
          48.9
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical pleine hauteur",
          "en": "Full-height vertical line"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 75 48.9 C 91.8 39.2 113.2 42.9 125.6 57.8 C 138.1 72.7 138.1 94.3 125.6 109.2 C 113.2 124.1 91.8 127.8 75 118.1",
        "startXY": [
          75,
          48.9
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Grande courbe, accolée à droite du trait",
          "en": "Large curve, attached to the right of the line"
        }
      }
    ]
  },
  {
    "char": "E",
    "name": {
      "fr": "E majuscule",
      "en": "uppercase E"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre E se forme en quatre gestes. Un trait vertical, puis trois traits horizontaux qui partent tous du trait vers la droite : en haut, au milieu, en bas.",
      "en": "The letter E is formed in four gestures. A vertical line, then three horizontal lines all starting from the line toward the right: at the top, in the middle, at the bottom."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 61 18 L 61 149",
        "startXY": [
          61,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical",
          "en": "Vertical line"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 61 18 L 133 18",
        "startXY": [
          61,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Horizontale du haut",
          "en": "Top horizontal"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 61 83.5 L 123 83.5",
        "startXY": [
          61,
          83.5
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Horizontale du milieu",
          "en": "Middle horizontal"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 61 149 L 133 149",
        "startXY": [
          61,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Horizontale du bas",
          "en": "Bottom horizontal"
        }
      }
    ]
  },
  {
    "char": "F",
    "name": {
      "fr": "F majuscule",
      "en": "uppercase F"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre F se forme comme le E, mais sans la barre du bas : un trait vertical, une horizontale en haut, une horizontale au milieu.",
      "en": "The letter F is formed like the E, but without the bottom bar: a vertical line, a horizontal at the top, a horizontal in the middle."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 61 18 L 61 149",
        "startXY": [
          61,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical",
          "en": "Vertical line"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 61 18 L 133 18",
        "startXY": [
          61,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Horizontale du haut",
          "en": "Top horizontal"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 61 83.5 L 123 83.5",
        "startXY": [
          61,
          83.5
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Horizontale du milieu",
          "en": "Middle horizontal"
        }
      }
    ]
  },
  {
    "char": "G",
    "name": {
      "fr": "G majuscule",
      "en": "uppercase G"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre G se forme en trois gestes. D'abord une grande courbe ouverte à droite. Ensuite un trait horizontal qui va de la gauche vers la droite, au niveau du centre de la courbe. Enfin, à son extrémité, un trait vertical qui descend du haut vers le bas.",
      "en": "The letter G is formed in three gestures. First a large curve open on the right. Then a horizontal line going from left to right, at the curve's center height. Finally, at its end, a vertical line going down from top to bottom."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 128.1 65.6 C 109.7 60.1 89.8 66.9 78.6 82.5 C 67.5 98.2 67.5 119.2 78.6 134.9 C 89.8 150.5 109.7 157.3 128.1 151.8",
        "startXY": [
          128.1,
          65.6
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Grande courbe ouverte à droite",
          "en": "Large curve open on the right"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 100.7 108.7 L 128.1 108.7",
        "startXY": [
          100.7,
          108.7
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal, de gauche à droite, au centre de la courbe",
          "en": "Horizontal line, left to right, at the curve's center"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 128.1 108.7 L 128.1 149.3",
        "startXY": [
          128.1,
          108.7
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, à l'extrémité de l'horizontale, du haut vers le bas",
          "en": "Vertical line, at the end of the horizontal, top to bottom"
        }
      }
    ]
  },
  {
    "char": "H",
    "name": {
      "fr": "H majuscule",
      "en": "uppercase H"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre H se forme en trois gestes. Deux traits verticaux parallèles, puis un trait horizontal qui les relie au milieu.",
      "en": "The letter H is formed in three gestures. Two parallel vertical lines, then a horizontal line linking them in the middle."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 61 18 L 61 149",
        "startXY": [
          61,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Premier trait vertical, à gauche",
          "en": "First vertical line, on the left"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 133 18 L 133 149",
        "startXY": [
          133,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Second trait vertical, à droite",
          "en": "Second vertical line, on the right"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 61 83.5 L 133 83.5",
        "startXY": [
          61,
          83.5
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal, relie les deux au milieu",
          "en": "Horizontal line, links the two in the middle"
        }
      }
    ]
  },
  {
    "char": "I",
    "name": {
      "fr": "I majuscule",
      "en": "uppercase I"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre I est un simple trait vertical pleine hauteur, tracé du haut vers le bas.",
      "en": "The letter I is a simple full-height vertical line, traced from top to bottom."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 97 18 L 97 149",
        "startXY": [
          97,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, du haut vers le bas",
          "en": "Vertical line, from top to bottom"
        }
      }
    ]
  },
  {
    "char": "J",
    "name": {
      "fr": "J majuscule",
      "en": "uppercase J"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre J se forme en un grand crochet : un trait vertical pleine hauteur qui s'arrondit vers la gauche tout en bas.",
      "en": "The letter J is formed as one large hook: a full-height vertical line curving to the left at the very bottom."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 77 18 L 77 117 C 77 125.3 70.3 132 62 132 C 53.7 132 47 125.3 47 117",
        "startXY": [
          77,
          18
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trait qui descend et s'arrondit à gauche en bas",
          "en": "Line going down and curving left at the bottom"
        }
      }
    ]
  },
  {
    "char": "K",
    "name": {
      "fr": "K majuscule",
      "en": "uppercase K"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre K se forme en trois gestes. Un trait vertical, puis une oblique du milieu vers le haut-droite, puis une oblique du milieu vers le bas-droite.",
      "en": "The letter K is formed in three gestures. A vertical line, then a diagonal from the middle to the upper right, then a diagonal from the middle to the lower right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 61 18 L 61 149",
        "startXY": [
          61,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical",
          "en": "Vertical line"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 61 113 L 133 18",
        "startXY": [
          61,
          113
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique du milieu vers le haut-droite",
          "en": "Diagonal from the middle to the upper right"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 61 113 L 133 149",
        "startXY": [
          61,
          113
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique du milieu vers le bas-droite",
          "en": "Diagonal from the middle to the lower right"
        }
      }
    ]
  },
  {
    "char": "L",
    "name": {
      "fr": "L majuscule",
      "en": "uppercase L"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre L se forme en deux gestes. Un trait vertical, puis un trait horizontal qui part du bas vers la droite.",
      "en": "The letter L is formed in two gestures. A vertical line, then a horizontal line going from the bottom toward the right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 61 18 L 61 149",
        "startXY": [
          61,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical",
          "en": "Vertical line"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 61 149 L 125 149",
        "startXY": [
          61,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Horizontale du bas",
          "en": "Bottom horizontal"
        }
      }
    ]
  },
  {
    "char": "M",
    "name": {
      "fr": "M majuscule",
      "en": "uppercase M"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre M se forme en quatre gestes. Un trait vertical à gauche, une oblique qui descend vers le centre, une oblique qui remonte vers la droite, puis un trait vertical à droite.",
      "en": "The letter M is formed in four gestures. A vertical line on the left, a diagonal going down to the center, a diagonal going up to the right, then a vertical line on the right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 57 18 L 57 149",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical gauche",
          "en": "Left vertical line"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 57 18 L 97 117",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique, sommet gauche vers le centre",
          "en": "Diagonal, left top to the center"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 97 117 L 137 18",
        "startXY": [
          97,
          117
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique, centre vers le sommet droit",
          "en": "Diagonal, center to the right top"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 137 18 L 137 149",
        "startXY": [
          137,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical droit",
          "en": "Right vertical line"
        }
      }
    ]
  },
  {
    "char": "N",
    "name": {
      "fr": "N majuscule",
      "en": "uppercase N"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre N se forme en trois gestes. Un trait vertical à gauche, une oblique qui relie son sommet à la base du second trait, puis le trait vertical à droite.",
      "en": "The letter N is formed in three gestures. A vertical line on the left, a diagonal linking its top to the base of the second line, then the vertical line on the right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 57 18 L 57 149",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical gauche",
          "en": "Left vertical line"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 57 18 L 137 149",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique, sommet gauche vers la base droite",
          "en": "Diagonal, left top to the right base"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 137 18 L 137 149",
        "startXY": [
          137,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical droit",
          "en": "Right vertical line"
        }
      }
    ]
  },
  {
    "char": "O",
    "name": {
      "fr": "O majuscule",
      "en": "uppercase O"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre O est un grand ovale complet. Pars du sommet et tourne dans le sens anti-horaire en un seul mouvement continu.",
      "en": "The letter O is a large full oval. Start at the top and turn counter-clockwise in one continuous motion."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 97 18 A 40 65.5 0 1 0 97.1 18",
        "startXY": [
          97,
          18
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Grand ovale complet, anti-horaire depuis le sommet",
          "en": "Large full oval, counter-clockwise from the top"
        }
      }
    ]
  },
  {
    "char": "P",
    "name": {
      "fr": "P majuscule",
      "en": "uppercase P"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre P se forme en deux gestes. Un trait vertical pleine hauteur, puis une courbe ronde accolée en haut à droite seulement.",
      "en": "The letter P is formed in two gestures. A full-height vertical line, then a round curve attached only to the upper right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 61 40.9 L 61 149",
        "startXY": [
          61,
          40.9
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical pleine hauteur",
          "en": "Full-height vertical line"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 73.8 40.9 C 86.3 32.2 103.3 34.2 113.4 45.6 C 123.5 56.9 123.5 74.1 113.4 85.4 C 103.3 96.8 86.3 98.8 73.8 90.1",
        "startXY": [
          73.8,
          40.9
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe du haut, accolée à droite",
          "en": "Upper curve, attached on the right"
        }
      }
    ]
  },
  {
    "char": "Q",
    "name": {
      "fr": "Q majuscule",
      "en": "uppercase Q"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre Q se forme en deux gestes. D'abord un grand ovale complet, comme le O. Ensuite une petite oblique qui sort du cercle vers le bas-droite.",
      "en": "The letter Q is formed in two gestures. First a large full oval, like the O. Then a small diagonal coming out of the circle toward the lower right."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 97 18 A 40 65.5 0 1 0 97.1 18",
        "startXY": [
          97,
          18
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Grand ovale complet",
          "en": "Large full oval"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 105 127 L 123 153",
        "startXY": [
          105,
          127
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Petite oblique sortant vers le bas-droite",
          "en": "Small diagonal coming out toward the lower right"
        }
      }
    ]
  },
  {
    "char": "R",
    "name": {
      "fr": "R majuscule",
      "en": "uppercase R"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre R se forme comme un P, avec une jambe en plus. Trait vertical, courbe en haut à droite, puis une oblique qui part du point de jonction vers le bas-droite.",
      "en": "The letter R is formed like a P, with an extra leg. Vertical line, curve at the upper right, then a diagonal starting from the junction point toward the lower right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 61 40.9 L 61 149",
        "startXY": [
          61,
          40.9
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical pleine hauteur",
          "en": "Full-height vertical line"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 73.8 40.9 C 86.3 32.2 103.3 34.2 113.4 45.6 C 123.5 56.9 123.5 74.1 113.4 85.4 C 103.3 96.8 86.3 98.8 73.8 90.1",
        "startXY": [
          73.8,
          40.9
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe du haut, accolée à droite",
          "en": "Upper curve, attached on the right"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 73.8 90.1 L 129 149",
        "startXY": [
          73.8,
          90.1
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Jambe oblique vers le bas-droite",
          "en": "Diagonal leg toward the lower right"
        }
      }
    ]
  },
  {
    "char": "S",
    "name": {
      "fr": "S majuscule",
      "en": "uppercase S"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre S se forme comme le s minuscule mais à pleine hauteur : un grand crochet en haut qui s'arrondit à droite, puis un grand crochet en bas qui s'arrondit à gauche.",
      "en": "The letter S is formed like the lowercase s but at full height: a large hook at the top curving right, then a large hook at the bottom curving left."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "top-right",
        "pathD": "M 127.1 40.6 C 121.5 25.3 105.4 16.6 89.6 20.4 C 73.8 24.1 63.3 39.1 65.2 55.2 C 67.1 71.3 80.8 83.5 97 83.5",
        "startXY": [
          127.1,
          40.6
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Grand crochet, s'arrondit vers la droite en haut",
          "en": "Large hook, curving right at the top"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 97 83.5 C 113.2 83.5 126.9 95.7 128.8 111.8 C 130.7 127.9 120.2 142.9 104.4 146.6 C 88.6 150.4 72.5 141.7 66.9 126.4",
        "startXY": [
          97,
          83.5
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Grand crochet, s'arrondit vers la gauche en bas",
          "en": "Large hook, curving left at the bottom"
        }
      }
    ]
  },
  {
    "char": "T",
    "name": {
      "fr": "T majuscule",
      "en": "uppercase T"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre T se forme en deux gestes. Un trait horizontal en haut, puis un trait vertical qui part du centre de l'horizontale vers le bas.",
      "en": "The letter T is formed in two gestures. A horizontal line at the top, then a vertical line starting from the center of the horizontal going down."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 57 18 L 137 18",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en haut",
          "en": "Horizontal line at the top"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 97 18 L 97 149",
        "startXY": [
          97,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, centré sous l'horizontale",
          "en": "Vertical line, centered under the horizontal"
        }
      }
    ]
  },
  {
    "char": "U",
    "name": {
      "fr": "U majuscule",
      "en": "uppercase U"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre U se forme en trois gestes. Un trait vertical à gauche, un grand crochet qui relie le bas des deux traits, puis le trait vertical à droite.",
      "en": "The letter U is formed in three gestures. A vertical line on the left, a large hook linking the bottom of the two lines, then the vertical line on the right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 57 18 L 57 119",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical gauche",
          "en": "Left vertical line"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom",
        "pathD": "M 57 117 C 57 139.1 74.9 157 97 157 C 119.1 157 137 139.1 137 117",
        "startXY": [
          57,
          117
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet bas, relie les deux traits",
          "en": "Bottom hook, links the two lines"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 137 18 L 137 119",
        "startXY": [
          137,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical droit",
          "en": "Right vertical line"
        }
      }
    ]
  },
  {
    "char": "V",
    "name": {
      "fr": "V majuscule",
      "en": "uppercase V"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre V se forme en deux gestes, comme le v minuscule mais à pleine hauteur. Une oblique qui descend du haut-gauche vers le centre-bas, puis une oblique qui remonte vers le haut-droite.",
      "en": "The letter V is formed in two gestures, like the lowercase v but at full height. A diagonal going down from the upper left to the center-bottom, then a diagonal going up to the upper right."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 57 18 L 97 149",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique descendante, haut-gauche vers centre-bas",
          "en": "Diagonal going down, upper left to center-bottom"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 97 149 L 137 18",
        "startXY": [
          97,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique montante, centre-bas vers haut-droite",
          "en": "Diagonal going up, center-bottom to upper right"
        }
      }
    ]
  },
  {
    "char": "W",
    "name": {
      "fr": "W majuscule",
      "en": "uppercase W"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre W se forme en quatre obliques alternant descente et montée.",
      "en": "The letter W is formed with four diagonals alternating down and up."
    },
    "steps": [
      {
        "family": "traits",
        "variant": "oblique-gauche",
        "pathD": "M 53 18 L 75 149",
        "startXY": [
          53,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Première oblique descendante",
          "en": "First diagonal going down"
        }
      },
      {
        "family": "traits",
        "variant": "oblique-droit",
        "pathD": "M 75 149 L 97 18",
        "startXY": [
          75,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Deuxième oblique montante",
          "en": "Second diagonal going up"
        }
      },
      {
        "family": "traits",
        "variant": "oblique-gauche",
        "pathD": "M 97 18 L 119 149",
        "startXY": [
          97,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Troisième oblique descendante",
          "en": "Third diagonal going down"
        }
      },
      {
        "family": "traits",
        "variant": "oblique-droit",
        "pathD": "M 119 149 L 141 18",
        "startXY": [
          119,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Quatrième oblique montante",
          "en": "Fourth diagonal going up"
        }
      }
    ]
  },
  {
    "char": "X",
    "name": {
      "fr": "X majuscule",
      "en": "uppercase X"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre X se forme en deux traits obliques qui se croisent au centre, à pleine hauteur.",
      "en": "The letter X is formed with two diagonal lines crossing at the center, at full height."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 57 18 L 137 149",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique haut-gauche vers bas-droite",
          "en": "Diagonal upper left to lower right"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 137 18 L 57 149",
        "startXY": [
          137,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique haut-droite vers bas-gauche",
          "en": "Diagonal upper right to lower left"
        }
      }
    ]
  },
  {
    "char": "Y",
    "name": {
      "fr": "Y majuscule",
      "en": "uppercase Y"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre Y se forme en trois gestes. Deux obliques qui partent du sommet et se rejoignent au centre, puis un trait vertical court qui descend depuis ce point.",
      "en": "The letter Y is formed in three gestures. Two diagonals starting from the top and meeting at the center, then a short vertical line going down from that point."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 57 18 L 97 113",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique, sommet gauche vers le centre",
          "en": "Diagonal, left top to the center"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 137 18 L 97 113",
        "startXY": [
          137,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique, sommet droit vers le centre",
          "en": "Diagonal, right top to the center"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 97 113 L 97 149",
        "startXY": [
          97,
          113
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical court, centre vers le bas",
          "en": "Short vertical line, center to the bottom"
        }
      }
    ]
  },
  {
    "char": "Z",
    "name": {
      "fr": "Z majuscule",
      "en": "uppercase Z"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre Z se forme comme le z minuscule à pleine hauteur : un trait horizontal en haut, une oblique vers le bas-gauche, un trait horizontal en bas.",
      "en": "The letter Z is formed like the full-height lowercase z: a horizontal line at the top, a diagonal toward the lower left, a horizontal line at the bottom."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 57 18 L 137 18",
        "startXY": [
          57,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en haut",
          "en": "Horizontal line at the top"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 137 18 L 57 149",
        "startXY": [
          137,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique vers le bas-gauche",
          "en": "Diagonal toward the lower left"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 57 149 L 137 149",
        "startXY": [
          57,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en bas",
          "en": "Horizontal line at the bottom"
        }
      }
    ]
  },
  {
    "char": "0",
    "name": {
      "fr": "zéro",
      "en": "zero"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 0 est un ovale complet. Pars du sommet et tourne dans le sens anti-horaire.",
      "en": "The digit 0 is a full oval. Start at the top and turn counter-clockwise."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 97 77 A 36 36 0 1 0 97.1 77",
        "startXY": [
          97,
          77
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Ovale complet, anti-horaire depuis le sommet",
          "en": "Full oval, counter-clockwise from the top"
        }
      }
    ]
  },
  {
    "char": "1",
    "name": {
      "fr": "un",
      "en": "one"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 1 se forme en deux gestes. Une petite amorce oblique qui rejoint le sommet, puis un trait vertical qui descend jusqu'à la ligne.",
      "en": "The digit 1 is formed in two gestures. A small diagonal lead-in reaching the top, then a vertical line going down to the baseline."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 83 89 L 97 77",
        "startXY": [
          83,
          89
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Amorce oblique vers le sommet",
          "en": "Diagonal lead-in to the top"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 97 77 L 97 149",
        "startXY": [
          97,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, du haut vers le bas",
          "en": "Vertical line, from top to bottom"
        }
      }
    ]
  },
  {
    "char": "2",
    "name": {
      "fr": "deux",
      "en": "two"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 2 se forme en trois gestes. Une courbe en haut qui ressemble à un crochet renversé, une oblique qui descend vers le bas-gauche, puis un trait horizontal à la base.",
      "en": "The digit 2 is formed in three gestures. A curve at the top like an upside-down hook, a diagonal going down to the lower left, then a horizontal line at the base."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "top",
        "pathD": "M 67 85 C 67 68.4 80.4 55 97 55 C 113.6 55 127 68.4 127 85",
        "startXY": [
          67,
          85
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe du haut, en crochet renversé",
          "en": "Curve at the top, like an upside-down hook"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 127 85 L 65 149",
        "startXY": [
          127,
          85
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique vers le bas-gauche",
          "en": "Diagonal toward the lower left"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 65 149 L 131 149",
        "startXY": [
          65,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal à la base",
          "en": "Horizontal line at the base"
        }
      }
    ]
  },
  {
    "char": "3",
    "name": {
      "fr": "trois",
      "en": "three"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 3 se forme en deux courbes empilées, ouvertes vers la gauche, qui se touchent au centre.",
      "en": "The digit 3 is formed with two stacked curves, open to the left, touching in the middle."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 68.3 95.8 C 66.7 86.7 71 77.6 79 72.9 C 87 68.3 97.1 69.2 104.1 75.1 C 111.2 81.1 113.8 90.8 110.7 99.5 C 107.5 108.2 99.2 114 90 114",
        "startXY": [
          68.3,
          95.8
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe du haut, ouverte à gauche",
          "en": "Upper curve, open to the left"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 90 114 C 99.2 114 107.5 119.8 110.7 128.5 C 113.8 137.2 111.2 146.9 104.1 152.9 C 97.1 158.8 87 159.7 79 155.1 C 71 150.4 66.7 141.3 68.3 132.2",
        "startXY": [
          90,
          114
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe du bas, ouverte à gauche",
          "en": "Lower curve, open to the left"
        }
      }
    ]
  },
  {
    "char": "4",
    "name": {
      "fr": "quatre",
      "en": "four"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 4 se forme en trois gestes. Une oblique qui descend vers le bas-gauche, un trait horizontal à sa base, puis un trait vertical qui traverse l'horizontale et dépasse vers le haut.",
      "en": "The digit 4 is formed in three gestures. A diagonal going down to the lower left, a horizontal line at its base, then a vertical line crossing the horizontal and going past it at the top."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 123 77 L 67 123",
        "startXY": [
          123,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique vers le bas-gauche",
          "en": "Diagonal toward the lower left"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 67 123 L 131 123",
        "startXY": [
          67,
          123
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal, base de l'oblique",
          "en": "Horizontal line, base of the diagonal"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 123 71 L 123 149",
        "startXY": [
          123,
          71
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical qui traverse et dépasse",
          "en": "Vertical line crossing and going past"
        }
      }
    ]
  },
  {
    "char": "5",
    "name": {
      "fr": "cinq",
      "en": "five"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 5 se forme en trois gestes. Un trait horizontal en haut, un petit trait vertical qui descend à gauche, puis un crochet qui balaie un grand arc, de haut en bas, en restant aligné à la verticale entre son origine et son extrémité.",
      "en": "The digit 5 is formed in three gestures. A horizontal line at the top, a small vertical line going down on the left, then a hook sweeping a large arc, top to bottom, with its start and end vertically aligned."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 74 77 L 114 77",
        "startXY": [
          74,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en haut",
          "en": "Horizontal line at the top"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 75 82 L 75 116",
        "startXY": [
          75,
          82
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Petit trait vertical à gauche",
          "en": "Small vertical line on the left"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom-right",
        "pathD": "M 75 116 C 87.6 108.2 104 110.7 113.7 121.9 C 123.4 133.2 123.4 149.8 113.7 161.1 C 104 172.3 87.6 174.8 75 166.9",
        "startXY": [
          75,
          116
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet qui balaie un grand arc et redescend aligné avec son point de départ",
          "en": "Hook sweeping a large arc and coming back down aligned with its starting point"
        }
      }
    ]
  },
  {
    "char": "6",
    "name": {
      "fr": "six",
      "en": "six"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 6 se forme comme le 9, mais inversé : d'abord un crochet qui part du haut, descend et s'arrondit en haut à droite, puis un anneau fermé en bas, dessiné dans le sens anti-horaire à partir du point où s'arrête le crochet.",
      "en": "The digit 6 is formed like the 9, but inverted: first a hook starting at the top, going down and curving at the upper right, then a closed ring at the bottom, drawn counterclockwise starting exactly where the hook ends."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "top-right",
        "pathD": "M 116 101 C 116 88.3 105.7 78 93 78 C 80.3 78 70 88.3 70 101 L 70 138",
        "startXY": [
          116,
          101
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet qui part de la courbure en haut à droite, puis descend tout droit",
          "en": "Hook starting from the upper-right curve, then going straight down"
        }
      },
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 70 138 A 21 21 0 1 0 112 138 A 21 21 0 1 0 70 138",
        "startXY": [
          80,
          138
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Anneau fermé en bas, tracé dans le sens anti-horaire à partir du point d'arrêt du crochet",
          "en": "Closed ring at the bottom, drawn counterclockwise from the hook's end point"
        }
      }
    ]
  },
  {
    "char": "7",
    "name": {
      "fr": "sept",
      "en": "seven"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 7 se forme en deux gestes. Un trait horizontal en haut, puis une oblique qui descend du haut-droite vers le bas-centre.",
      "en": "The digit 7 is formed in two gestures. A horizontal line at the top, then a diagonal going down from the upper right to the center-bottom."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 65 77 L 131 77",
        "startXY": [
          65,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en haut",
          "en": "Horizontal line at the top"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 131 77 L 91 149",
        "startXY": [
          131,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique vers le bas-centre",
          "en": "Diagonal toward the center-bottom"
        }
      }
    ]
  },
  {
    "char": "8",
    "name": {
      "fr": "huit",
      "en": "eight"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 8 se forme en deux petits anneaux empilés, celui du haut un peu plus petit que celui du bas.",
      "en": "The digit 8 is formed with two small stacked rings, the top one a little smaller than the bottom one."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 97 77 A 22 18 0 1 0 97.1 77",
        "startXY": [
          97,
          77
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Petit anneau du haut",
          "en": "Small upper ring"
        }
      },
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 97 111 A 24 20 0 1 0 97.1 111",
        "startXY": [
          97,
          111
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Anneau du bas, légèrement plus grand",
          "en": "Bottom ring, slightly larger"
        }
      }
    ]
  },
  {
    "char": "9",
    "name": {
      "fr": "neuf",
      "en": "nine"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 9 se forme comme le 6 mais inversé. D'abord un anneau fermé en haut, dessiné dans le sens anti-horaire, puis un crochet tangent au bord droit de l'anneau, qui descend et s'arrondit en bas à gauche.",
      "en": "The digit 9 is formed like the 6 but inverted. First a closed ring at the top, drawn counterclockwise, then a hook tangent to the ring's right edge, going down and curving at the lower left."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 112 108 A 21 21 0 1 0 70 108 A 21 21 0 1 0 112 108",
        "startXY": [
          112,
          108
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Anneau fermé en haut, tracé dans le sens anti-horaire",
          "en": "Closed ring at the top, drawn counterclockwise"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 112 108 L 112 145 C 112 157.7 101.7 168 89 168 C 76.3 168 66 157.7 66 145",
        "startXY": [
          112,
          108
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet tangent au bord droit de l'anneau, descend puis s'arrondit en bas à gauche",
          "en": "Hook tangent to the ring's right edge, going down then curving at the lower left"
        }
      }
    ]
  }
]
''');

/// Table de correspondance caractère → formation, pour les écrans qui
/// recherchent une lettre/chiffre précis (cahier d'écriture, mots...).
final Map<String, dynamic> LETTER_MAP = {
  for (final l in LETTER_CATALOG) l['char'] as String: l,
};
