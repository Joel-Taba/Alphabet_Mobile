import 'dart:convert';

final List<dynamic> VOWELS = jsonDecode(r'''
[
  {
    "char": "a",
    "name": {
      "fr": "a minuscule",
      "en": "lowercase a",
      "es": "a minúscula"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre A se forme en deux gestes. D'abord, trace une courbe bien ronde, presque fermée, qui ne reste ouverte qu'à droite. Ensuite, ajoute un trait vertical qui vient refermer cette ouverture, du haut vers le bas.",
      "en": "The letter A is formed in two gestures. First, trace a nicely round curve, almost closed, staying open only at the right. Then, add a vertical line that closes that opening, from top to bottom.",
      "es": "La letra A se forma en dos gestos. Primero, traza una curva bien redonda, casi cerrada, que quede abierta solo a la derecha. Luego, añade un trazo vertical que cierre esa abertura, de arriba hacia abajo."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 122.46 87.54 A 36.00 36.00 0 1 0 122.46 138.46",
        "startXY": [
          122.46,
          87.54
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe circulaire presque fermée, ouverte à droite horizontalement",
          "en": "Circular curve almost closed, open horizontally at the right",
          "es": "Curva circular casi cerrada, abierta a la derecha horizontalmente"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 122.46 83 L 122.46 150",
        "startXY": [
          122.46,
          83.54
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical qui referme la courbe, du haut vers le bas, en débordant légèrement de part et d'autre",
          "en": "Vertical line that closes the curve, from top to bottom, slightly overshooting both ends",
          "es": "Trazo vertical que cierra la curva, de arriba hacia abajo, sobrepasando ligeramente por ambos lados"
        }
      }
    ]
  },
  {
    "char": "e",
    "name": {
      "fr": "e minuscule",
      "en": "lowercase e",
      "es": "e minúscula"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre E se forme en deux gestes. D'abord, trace un trait horizontal au milieu. Ensuite, dessine une courbe bien ronde qui part de la pointe du trait, encercle tout le tour et s'ouvre juste un peu en bas à droite.",
      "en": "The letter E is formed in two gestures. First, trace a horizontal line in the middle. Then, draw a nicely round curve that starts from the tip of the line, circles all the way round and opens just a little at the bottom right.",
      "es": "La letra E se forma en dos gestos. Primero, traza un trazo horizontal en el medio. Luego, dibuja una curva bien redonda que parte de la punta del trazo, rodea todo el contorno y se abre un poco abajo a la derecha."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 102.81 126.00 L 62.61 126.00",
        "startXY": [
          102.81,
          126
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal au centre, de gauche à droite",
          "en": "Horizontal line in the center, left to right",
          "es": "Trazo horizontal en el centro, de izquierda a derecha"
        }
      },
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 99.34 143.49 A 21.00 21.00 0 1 1 102.59 125.03",
        "startXY": [
          99.34,
          143.49
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe qui entoure le trait, ouverte en bas à droite",
          "en": "Curve that surrounds the line, open at the bottom right",
          "es": "Curva que rodea el trazo, abierta abajo a la derecha"
        }
      }
    ]
  },
  {
    "char": "i",
    "name": {
      "fr": "i minuscule",
      "en": "lowercase i",
      "es": "i minúscula"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre I se forme en deux gestes. D'abord, trace un trait vertical dans le corps de la ligne. Ensuite, pose un point rond au-dessus du trait, sans le toucher.",
      "en": "The letter I is formed in two gestures. First, trace a vertical line in the body of the writing line. Then, place a round dot above the line, without touching it.",
      "es": "La letra I se forma en dos gestos. Primero, traza un trazo vertical en el cuerpo de la línea de escritura. Luego, coloca un punto redondo encima del trazo, sin tocarlo."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 90.75 113.00 L 90.75 149.00",
        "startXY": [
          90.75,
          113
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, du haut vers le bas",
          "en": "Vertical line, from top to bottom",
          "es": "Trazo vertical, de arriba hacia abajo"
        }
      },
      {
        "family": "point",
        "variant": "center",
        "pathD": "M 90.55 102.25 A 3.20 3.20 0 1 0 90.59 102.25",
        "startXY": [
          90.55,
          102.25
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Point au-dessus du trait, petit rond détaché",
          "en": "Dot above the line, small detached circle",
          "es": "Punto encima del trazo, pequeño círculo separado"
        }
      }
    ]
  },
  {
    "char": "o",
    "name": {
      "fr": "o minuscule",
      "en": "lowercase o",
      "es": "o minúscula"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre O est un ovale complet. Pars du sommet et tourne dans le sens anti-horaire en un seul mouvement continu, doux et régulier.",
      "en": "The letter O is a full oval. Start at the top and turn counter-clockwise in one smooth, continuous motion.",
      "es": "La letra O es un óvalo completo. Parte desde arriba y gira en sentido antihorario en un solo movimiento continuo, suave y regular."
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
          "en": "Full oval, counter-clockwise from the top",
          "es": "Óvalo completo, antihorario desde arriba"
        }
      }
    ]
  },
  {
    "char": "u",
    "name": {
      "fr": "u minuscule",
      "en": "lowercase u",
      "es": "u minúscula"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre U se forme en deux gestes. D'abord, trace un crochet bas-droite : descends puis arrondis doucement vers la droite en bas. Ensuite, ajoute un trait vertical sur le bord droit, du haut vers le bas.",
      "en": "The letter U is formed in two gestures. First, trace a bottom-right hook: go down, then curve gently to the right at the bottom. Then, add a vertical line on the right edge, from top to bottom.",
      "es": "La letra U se forma en dos gestos. Primero, traza un gancho abajo-derecha: baja y luego curva suavemente hacia la derecha en la parte inferior. Luego, añade un trazo vertical en el borde derecho, de arriba hacia abajo."
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
          "en": "Bottom-right hook: go down then curve to the right",
          "es": "Gancho abajo-derecha: baja y luego curva hacia la derecha"
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
          "en": "Vertical line on the right edge, from top to bottom",
          "es": "Trazo vertical pegado a la derecha, de arriba hacia abajo"
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
      "en": "lowercase b",
      "es": "b minúscula"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre B se forme en deux gestes. D'abord, trace un trait vertical qui monte en zone haute. Ensuite, ajoute une courbe ronde accolée en bas à droite du trait.",
      "en": "The letter B is formed in two gestures. First, trace a vertical line rising into the ascender zone. Then, add a round curve attached to the lower right of the line.",
      "es": "La letra B se forma en dos gestos. Primero, traza un trazo vertical que sube a la zona alta. Luego, añade una curva redonda pegada abajo a la derecha del trazo."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 69.78 88.65 L 69.78 148.65",
        "startXY": [
          69.78,
          88.65
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, monte en zone haute",
          "en": "Vertical line, rising into the ascender zone",
          "es": "Trazo vertical, sube a la zona alta"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 69.95 143.94 A 18.00 18.00 0 1 0 69.95 118.04",
        "startXY": [
          69.95,
          143.94
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde accolée en bas à droite du trait",
          "en": "Round curve attached to the lower right of the line",
          "es": "Curva redonda pegada abajo a la derecha del trazo"
        }
      }
    ]
  },
  {
    "char": "c",
    "name": {
      "fr": "c minuscule",
      "en": "lowercase c",
      "es": "c minúscula"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre C est une courbe ronde, presque fermée, ouverte seulement à droite. Trace-la en un seul geste, en partant du haut.",
      "en": "The letter C is a round curve, almost closed, open only on the right. Trace it in a single motion, starting from the top.",
      "es": "La letra C es una curva redonda, casi cerrada, abierta solo a la derecha. Trázala en un solo gesto, empezando desde arriba."
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
          "en": "Round curve open on the right, single motion",
          "es": "Curva redonda abierta a la derecha, un solo gesto"
        }
      }
    ]
  },
  {
    "char": "d",
    "name": {
      "fr": "d minuscule",
      "en": "lowercase d",
      "es": "d minúscula"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre D se forme en deux gestes. D'abord, trace une courbe ronde ouverte à droite. Ensuite, ajoute un trait vertical sur le bord droit, qui monte cette fois en zone haute.",
      "en": "The letter D is formed in two gestures. First, trace a round curve open on the right. Then, add a vertical line on the right edge, this time rising into the ascender zone.",
      "es": "La letra D se forma en dos gestos. Primero, traza una curva redonda abierta a la derecha. Luego, añade un trazo vertical en el borde derecho, esta vez subiendo a la zona alta."
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
          "en": "Round curve open on the right",
          "es": "Curva redonda abierta a la derecha"
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
          "en": "Vertical line on the right, extended upward",
          "es": "Trazo vertical a la derecha, prolongado hacia arriba"
        }
      }
    ]
  },
  {
    "char": "f",
    "name": {
      "fr": "f minuscule",
      "en": "lowercase f",
      "es": "f minúscula"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre F se forme en deux gestes. D'abord, trace un grand trait qui monte en zone haute et se termine par un petit crochet arrondi vers la droite en haut. Ensuite, ajoute un trait horizontal qui traverse le trait vertical.",
      "en": "The letter F is formed in two gestures. First, trace a tall line rising into the ascender zone, finishing with a small rounded hook to the right at the top. Then, add a horizontal line crossing the vertical line.",
      "es": "La letra F se forma en dos gestos. Primero, traza un trazo alto que sube a la zona alta y termina con un pequeño gancho redondeado hacia la derecha arriba. Luego, añade un trazo horizontal que cruza el trazo vertical."
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
          "en": "Line rising and curving right at the top",
          "es": "Trazo que sube y se curva hacia la derecha arriba"
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
          "en": "Horizontal line cutting across the hook",
          "es": "Trazo horizontal que cruza el gancho"
        }
      }
    ]
  },
  {
    "char": "g",
    "name": {
      "fr": "g minuscule",
      "en": "lowercase g",
      "es": "g minúscula"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre G se forme en deux gestes. D'abord, trace une courbe ronde ouverte à droite. Ensuite, ajoute un crochet qui descend en zone basse et s'arrondit vers la gauche.",
      "en": "The letter G is formed in two gestures. First, trace a round curve open on the right. Then, add a hook going down into the descender zone, curving to the left.",
      "es": "La letra G se forma en dos gestos. Primero, traza una curva redonda abierta a la derecha. Luego, añade un gancho que baja a la zona baja y se curva hacia la izquierda."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 97.42 144.68 A 15.00 15.00 0 1 1 97.42 123.10",
        "startXY": [
          97.42,
          144.68
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde ouverte à droite",
          "en": "Round curve open on the right",
          "es": "Curva redonda abierta a la derecha"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 97.77 122.47 L 97.77 168.97 A 13.50 13.50 0 0 1 73.21 176.71",
        "startXY": [
          97.77,
          122.47
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trait qui descend en zone basse et s'arrondit à gauche",
          "en": "Line going down into the descender zone, curving left",
          "es": "Trazo que baja a la zona baja y se curva hacia la izquierda"
        }
      }
    ]
  },
  {
    "char": "h",
    "name": {
      "fr": "h minuscule",
      "en": "lowercase h",
      "es": "h minúscula"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre H se forme en deux gestes. D'abord, trace un trait vertical qui monte en zone haute. Ensuite, ajoute un crochet qui part du trait, s'arrondit vers le haut puis redescend jusqu'à la ligne.",
      "en": "The letter H is formed in two gestures. First, trace a vertical line rising into the ascender zone. Then, add a hook starting from the line, arching up and coming back down to the baseline.",
      "es": "La letra H se forma en dos gestos. Primero, traza un trazo vertical que sube a la zona alta. Luego, añade un gancho que parte del trazo, se curva hacia arriba y vuelve a bajar hasta la línea."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 80.00 101.00 L 80.00 149.00",
        "startXY": [
          80,
          101
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, monte en zone haute",
          "en": "Vertical line, rising into the ascender zone",
          "es": "Trazo vertical, sube a la zona alta"
        }
      },
      {
        "family": "crochet",
        "variant": "top-left",
        "pathD": "M 92.00 149.00 L 92.00 131.00 A 6.00 6.00 0 0 0 80.00 131.00",
        "startXY": [
          92,
          149
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet accolé en bas à droite du trait",
          "en": "Hook attached to the lower right of the line",
          "es": "Gancho pegado abajo a la derecha del trazo"
        }
      }
    ]
  },
  {
    "char": "j",
    "name": {
      "fr": "j minuscule",
      "en": "lowercase j",
      "es": "j minúscula"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre J se forme en deux gestes. D'abord, trace un trait qui descend en zone basse et s'arrondit vers la gauche. Ensuite, pose un point rond au-dessus, sans le toucher.",
      "en": "The letter J is formed in two gestures. First, trace a line going down into the descender zone, curving to the left. Then, place a round dot above, without touching it.",
      "es": "La letra J se forma en dos gestos. Primero, traza un trazo que baja a la zona baja y se curva hacia la izquierda. Luego, coloca un punto redondo encima, sin tocarlo."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 105.62 115.33 L 105.62 140.08 A 8.25 8.25 0 0 1 89.12 140.08",
        "startXY": [
          105.62,
          115.33
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trait qui descend en zone basse et s'arrondit à gauche",
          "en": "Line going down into the descender zone, curving left",
          "es": "Trazo que baja a la zona baja y se curva hacia la izquierda"
        }
      },
      {
        "family": "point",
        "variant": "center",
        "pathD": "M 105.70 103.50 A 2.80 2.80 0 1 0 105.73 103.50",
        "startXY": [
          105.7,
          103.5
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Point au-dessus, sans toucher le crochet",
          "en": "Dot above, without touching the hook",
          "es": "Punto encima, sin tocar el gancho"
        }
      }
    ]
  },
  {
    "char": "k",
    "name": {
      "fr": "k minuscule",
      "en": "lowercase k",
      "es": "k minúscula"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre K se forme en trois gestes. D'abord, trace un trait vertical qui monte en zone haute. Ensuite, trace un premier trait oblique du milieu vers le haut-droite. Enfin, trace un second trait oblique du milieu vers le bas-droite.",
      "en": "The letter K is formed in three gestures. First, trace a vertical line rising into the ascender zone. Then, trace a diagonal line from the middle toward the upper right. Finally, trace a second diagonal line from the middle toward the lower right.",
      "es": "La letra K se forma en tres gestos. Primero, traza un trazo vertical que sube a la zona alta. Luego, traza un primer trazo oblicuo desde el medio hacia arriba a la derecha. Por último, traza un segundo trazo oblicuo desde el medio hacia abajo a la derecha."
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
          "en": "Vertical line, rising into the ascender zone",
          "es": "Trazo vertical, sube a la zona alta"
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
          "en": "Diagonal from the middle of the line toward the upper right",
          "es": "Oblicuo desde el medio del trazo hacia arriba a la derecha"
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
          "en": "Diagonal from the middle of the line toward the lower right",
          "es": "Oblicuo desde el medio del trazo hacia abajo a la derecha"
        }
      }
    ]
  },
  {
    "char": "l",
    "name": {
      "fr": "l minuscule",
      "en": "lowercase l",
      "es": "l minúscula"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre L est un simple trait vertical qui monte en zone haute. Trace-le d'un seul geste, du haut vers le bas.",
      "en": "The letter L is a simple vertical line rising into the ascender zone. Trace it in a single motion, from top to bottom.",
      "es": "La letra L es un simple trazo vertical que sube a la zona alta. Trázalo en un solo gesto, de arriba hacia abajo."
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
          "en": "Vertical line, from top to bottom",
          "es": "Trazo vertical, de arriba hacia abajo"
        }
      }
    ]
  },
  {
    "char": "m",
    "name": {
      "fr": "m minuscule",
      "en": "lowercase m",
      "es": "m minúscula"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre M se forme en trois gestes. D'abord, trace un premier crochet qui s'arrondit vers le haut. Ensuite, ajoute un trait vertical court, accolé au premier crochet. Enfin, ajoute un second crochet identique, juste à côté.",
      "en": "The letter M is formed in three gestures. First, trace a first hook arching upward. Then, add a short vertical line, attached to the first hook. Finally, add a second matching hook right next to it.",
      "es": "La letra M se forma en tres gestos. Primero, traza un primer gancho que se curva hacia arriba. Luego, añade un trazo vertical corto, pegado al primer gancho. Por último, añade un segundo gancho idéntico, justo al lado."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "top-left",
        "pathD": "M 87.50 149.00 L 87.50 118.45 A 8.45 8.45 0 0 0 70.89 116.27",
        "startXY": [
          87.5,
          149
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Premier crochet qui s'arrondit vers le haut",
          "en": "First hook arching upward",
          "es": "Primer gancho que se curva hacia arriba"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 70.75 107.50 L 70.75 149.50",
        "startXY": [
          70.75,
          107.5
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical court, accolé au premier crochet",
          "en": "Short vertical line, attached to the first hook",
          "es": "Trazo vertical corto, pegado al primer gancho"
        }
      },
      {
        "family": "crochet",
        "variant": "top-left",
        "pathD": "M 104.50 149.50 L 104.50 118.95 A 8.45 8.45 0 0 0 87.89 116.77",
        "startXY": [
          104.5,
          149.5
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Second crochet, identique au premier",
          "en": "Second hook, matching the first",
          "es": "Segundo gancho, idéntico al primero"
        }
      }
    ]
  },
  {
    "char": "n",
    "name": {
      "fr": "n minuscule",
      "en": "lowercase n",
      "es": "n minúscula"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre N se forme en deux gestes. D'abord, trace un trait vertical court. Ensuite, ajoute un crochet qui s'arrondit vers le haut puis redescend jusqu'à la ligne.",
      "en": "The letter N is formed in two gestures. First, trace a short vertical line. Then, add a hook arching upward and coming back down to the baseline.",
      "es": "La letra N se forma en dos gestos. Primero, traza un trazo vertical corto. Luego, añade un gancho que se curva hacia arriba y vuelve a bajar hasta la línea."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 71.00 107.75 L 71.00 149.75",
        "startXY": [
          71,
          107.75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical court",
          "en": "Short vertical line",
          "es": "Trazo vertical corto"
        }
      },
      {
        "family": "crochet",
        "variant": "top-left",
        "pathD": "M 93.00 149.50 L 93.00 121.55 A 11.05 11.05 0 0 0 71.28 118.69",
        "startXY": [
          93,
          149.5
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet accolé à droite du trait",
          "en": "Hook attached to the right of the line",
          "es": "Gancho pegado a la derecha del trazo"
        }
      }
    ]
  },
  {
    "char": "ñ",
    "name": {
      "fr": "n espagnol (eñe) minuscule",
      "en": "lowercase spanish ñ",
      "es": "eñe minúscula"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre ñ se forme comme un n, puis on ajoute un petit tilde ondulé au-dessus.",
      "en": "The letter ñ is formed like an n, then a small wavy tilde is added above it.",
      "es": "La letra ñ se forma como una n, y luego se añade una pequeña virgulilla ondulada encima."
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
          "en": "Short vertical line",
          "es": "Trazo vertical corto"
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
          "en": "Hook attached to the right of the line",
          "es": "Gancho pegado a la derecha del trazo"
        }
      },
      {
        "family": "courbe",
        "variant": "tilde",
        "pathD": "M 79 30 C 85 21 93 21 100 28 C 107 35 115 35 121 26",
        "startXY": [
          79,
          30
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Petit tilde ondulé au-dessus du n",
          "en": "Small wavy tilde above the n",
          "es": "Pequeña virgulilla ondulada encima de la n"
        }
      }
    ]
  },
  {
    "char": "p",
    "name": {
      "fr": "p minuscule",
      "en": "lowercase p",
      "es": "p minúscula"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre P se forme en deux gestes. D'abord, trace un trait vertical qui descend en zone basse. Ensuite, ajoute une courbe ronde accolée en haut à droite du trait.",
      "en": "The letter P is formed in two gestures. First, trace a vertical line going down into the descender zone. Then, add a round curve attached to the upper right of the line.",
      "es": "La letra P se forma en dos gestos. Primero, traza un trazo vertical que baja a la zona baja. Luego, añade una curva redonda pegada arriba a la derecha del trazo."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 72.00 105.00 L 72.00 153.00",
        "startXY": [
          72,
          105
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, descend en zone basse",
          "en": "Vertical line, going down into the descender zone",
          "es": "Trazo vertical, baja a la zona baja"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 71.83 128.29 A 15.00 15.00 0 1 0 71.83 106.71",
        "startXY": [
          71.83,
          128.29
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde accolée en haut à droite du trait",
          "en": "Round curve attached to the upper right of the line",
          "es": "Curva redonda pegada arriba a la derecha del trazo"
        }
      }
    ]
  },
  {
    "char": "q",
    "name": {
      "fr": "q minuscule",
      "en": "lowercase q",
      "es": "q minúscula"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre Q se forme en deux gestes. D'abord, trace une courbe ronde ouverte à droite. Ensuite, ajoute un trait vertical sur le bord droit, qui descend cette fois en zone basse.",
      "en": "The letter Q is formed in two gestures. First, trace a round curve open on the right. Then, add a vertical line on the right edge, this time going down into the descender zone.",
      "es": "La letra Q se forma en dos gestos. Primero, traza una curva redonda abierta a la derecha. Luego, añade un trazo vertical en el borde derecho, esta vez bajando a la zona baja."
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
          "en": "Round curve open on the right",
          "es": "Curva redonda abierta a la derecha"
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
          "en": "Vertical line on the right, extended downward",
          "es": "Trazo vertical a la derecha, prolongado hacia abajo"
        }
      }
    ]
  },
  {
    "char": "r",
    "name": {
      "fr": "r minuscule",
      "en": "lowercase r",
      "es": "r minúscula"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre R se forme en deux gestes. D'abord, trace un trait vertical court. Ensuite, ajoute un petit crochet en haut à droite, qui ne descend pas jusqu'à la ligne.",
      "en": "The letter R is formed in two gestures. First, trace a short vertical line. Then, add a small hook at the upper right, which doesn't reach the baseline.",
      "es": "La letra R se forma en dos gestos. Primero, traza un trazo vertical corto. Luego, añade un pequeño gancho arriba a la derecha, que no llega hasta la línea."
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
          "en": "Short vertical line",
          "es": "Trazo vertical corto"
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
          "en": "Small hook at the upper right of the line",
          "es": "Pequeño gancho arriba a la derecha del trazo"
        }
      }
    ]
  },
  {
    "char": "s",
    "name": {
      "fr": "s minuscule",
      "en": "lowercase s",
      "es": "s minúscula"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre S se forme en deux gestes enchaînés. D'abord, un petit crochet en haut qui s'arrondit vers la droite. Ensuite, sans lever le crayon, un second petit crochet en bas qui s'arrondit vers la gauche.",
      "en": "The letter S is formed in two linked gestures. First, a small hook at the top curving to the right. Then, without lifting the pencil, a second small hook at the bottom curving to the left.",
      "es": "La letra S se forma en dos gestos encadenados. Primero, un pequeño gancho arriba que se curva hacia la derecha. Luego, sin levantar el lápiz, un segundo pequeño gancho abajo que se curva hacia la izquierda."
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
          "en": "Small hook, curving right at the top",
          "es": "Pequeño gancho, se curva hacia la derecha arriba"
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
          "en": "Small hook, curving left at the bottom",
          "es": "Pequeño gancho, se curva hacia la izquierda abajo"
        }
      }
    ]
  },
  {
    "char": "t",
    "name": {
      "fr": "t minuscule",
      "en": "lowercase t",
      "es": "t minúscula"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre T se forme en deux gestes. D'abord, trace un trait vertical qui monte en zone haute. Ensuite, ajoute un trait horizontal qui le traverse, plus haut que pour le F.",
      "en": "The letter T is formed in two gestures. First, trace a vertical line rising into the ascender zone. Then, add a horizontal line crossing it, higher than for the F.",
      "es": "La letra T se forma en dos gestos. Primero, traza un trazo vertical que sube a la zona alta. Luego, añade un trazo horizontal que lo cruza, más arriba que en la F."
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
          "en": "Vertical line, rising into the ascender zone",
          "es": "Trazo vertical, sube a la zona alta"
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
          "en": "Horizontal line crossing, high in the ascender zone",
          "es": "Trazo horizontal que cruza, arriba en la zona alta"
        }
      }
    ]
  },
  {
    "char": "v",
    "name": {
      "fr": "v minuscule",
      "en": "lowercase v",
      "es": "v minúscula"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre V se forme en deux gestes. D'abord, un trait oblique qui descend du haut-gauche vers le centre-bas. Ensuite, un trait oblique qui remonte du centre-bas vers le haut-droite.",
      "en": "The letter V is formed in two gestures. First, a diagonal line going down from the upper left to the center-bottom. Then, a diagonal line going up from the center-bottom to the upper right.",
      "es": "La letra V se forma en dos gestos. Primero, un trazo oblicuo que baja desde arriba a la izquierda hacia el centro abajo. Luego, un trazo oblicuo que sube desde el centro abajo hacia arriba a la derecha."
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
          "en": "Diagonal going down, upper left to center-bottom",
          "es": "Oblicuo descendente, de arriba a la izquierda al centro abajo"
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
          "en": "Diagonal going up, center-bottom to upper right",
          "es": "Oblicuo ascendente, del centro abajo hacia arriba a la derecha"
        }
      }
    ]
  },
  {
    "char": "w",
    "name": {
      "fr": "w minuscule",
      "en": "lowercase w",
      "es": "w minúscula"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre W se forme en quatre traits obliques qui s'enchaînent, alternant descente et montée, comme deux V collés.",
      "en": "The letter W is formed with four diagonal lines linked together, alternating down and up, like two Vs side by side.",
      "es": "La letra W se forma con cuatro trazos oblicuos encadenados, alternando bajada y subida, como dos V pegadas."
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
          "en": "First diagonal going down",
          "es": "Primer oblicuo descendente"
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
          "en": "Second diagonal going up",
          "es": "Segundo oblicuo ascendente"
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
          "en": "Third diagonal going down",
          "es": "Tercer oblicuo descendente"
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
          "en": "Fourth diagonal going up",
          "es": "Cuarto oblicuo ascendente"
        }
      }
    ]
  },
  {
    "char": "x",
    "name": {
      "fr": "x minuscule",
      "en": "lowercase x",
      "es": "x minúscula"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre X se forme en deux traits obliques qui se croisent au centre. D'abord du haut-gauche vers le bas-droite, puis du haut-droite vers le bas-gauche.",
      "en": "The letter X is formed with two diagonal lines crossing at the center. First from the upper left to the lower right, then from the upper right to the lower left.",
      "es": "La letra X se forma con dos trazos oblicuos que se cruzan en el centro. Primero de arriba a la izquierda hacia abajo a la derecha, luego de arriba a la derecha hacia abajo a la izquierda."
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
          "en": "Diagonal upper left to lower right",
          "es": "Oblicuo de arriba a la izquierda hacia abajo a la derecha"
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
          "en": "Diagonal upper right to lower left",
          "es": "Oblicuo de arriba a la derecha hacia abajo a la izquierda"
        }
      }
    ]
  },
  {
    "char": "y",
    "name": {
      "fr": "y minuscule",
      "en": "lowercase y",
      "es": "y minúscula"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre Y se forme en deux gestes. D'abord, une diagonale du haut-gauche qui descend jusqu'au point de croisement sur la ligne de base. Ensuite, une diagonale du haut-droite qui passe par le même point, puis continue en zone basse et se termine par un petit crochet vers la gauche.",
      "en": "The letter Y is formed in two gestures. First, a diagonal from the upper left descending to the crossing point on the baseline. Then, a diagonal from the upper right passing through the same point, continuing into the descender zone and ending with a small hook to the left.",
      "es": "La letra Y se forma en dos gestos. Primero, una diagonal desde arriba a la izquierda que baja hasta el punto de cruce en la línea de base. Luego, una diagonal desde arriba a la derecha que pasa por el mismo punto, continúa en la zona baja y termina con un pequeño gancho hacia la izquierda."
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
          "en": "Diagonal from upper left to the crossing point on the baseline",
          "es": "Diagonal desde arriba a la izquierda hasta el punto de cruce en la línea de base"
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
          "en": "Diagonal from upper right, crosses, descends into the descender zone",
          "es": "Diagonal desde arriba a la derecha, cruza, baja a la zona baja"
        }
      }
    ]
  },
  {
    "char": "z",
    "name": {
      "fr": "z minuscule",
      "en": "lowercase z",
      "es": "z minúscula"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre Z se forme en trois gestes enchaînés sans lever le crayon : un trait horizontal en haut, un trait oblique vers le bas-gauche, puis un trait horizontal en bas.",
      "en": "The letter Z is formed in three linked gestures without lifting the pencil: a horizontal line at the top, a diagonal going to the lower left, then a horizontal line at the bottom.",
      "es": "La letra Z se forma en tres gestos encadenados sin levantar el lápiz: un trazo horizontal arriba, un trazo oblicuo hacia abajo a la izquierda, luego un trazo horizontal abajo."
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
          "en": "Horizontal line at the top",
          "es": "Trazo horizontal arriba"
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
          "en": "Diagonal toward the lower left",
          "es": "Oblicuo hacia abajo a la izquierda"
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
          "en": "Horizontal line at the bottom",
          "es": "Trazo horizontal abajo"
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
      "en": "uppercase A",
      "es": "A mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre A se forme en trois gestes. D'abord une oblique du sommet vers le bas-gauche, puis une oblique du sommet vers le bas-droite, enfin une barre horizontale qui relie les deux obliques à mi-hauteur.",
      "en": "The letter A is formed in three gestures. First a diagonal from the top to the lower left, then a diagonal from the top to the lower right, finally a horizontal bar linking the two diagonals at mid-height.",
      "es": "La letra A se forma en tres gestos. Primero un oblicuo desde arriba hacia abajo a la izquierda, luego un oblicuo desde arriba hacia abajo a la derecha, y por último una barra horizontal que une los dos oblicuos a media altura."
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
          "en": "Diagonal from the top to the lower left",
          "es": "Oblicuo desde arriba hacia abajo a la izquierda"
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
          "en": "Diagonal from the top to the lower right",
          "es": "Oblicuo desde arriba hacia abajo a la derecha"
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
          "en": "Horizontal middle bar",
          "es": "Barra horizontal media"
        }
      }
    ]
  },
  {
    "char": "B",
    "name": {
      "fr": "B majuscule",
      "en": "uppercase B",
      "es": "B mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre B se forme en trois gestes. D'abord un trait vertical pleine hauteur. Ensuite une courbe ronde accolée en haut à droite. Enfin une seconde courbe ronde accolée en bas à droite, qui touche la première au milieu.",
      "en": "The letter B is formed in three gestures. First a full-height vertical line. Then a round curve attached to the upper right. Finally a second round curve attached to the lower right, touching the first in the middle.",
      "es": "La letra B se forma en tres gestos. Primero un trazo vertical de altura completa. Luego una curva redonda pegada arriba a la derecha. Por último una segunda curva redonda pegada abajo a la derecha, que toca la primera en el medio."
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
          "en": "Full-height vertical line",
          "es": "Trazo vertical de altura completa"
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
          "en": "Upper curve, attached on the right",
          "es": "Curva de arriba, pegada a la derecha"
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
          "en": "Lower curve, attached on the right",
          "es": "Curva de abajo, pegada a la derecha"
        }
      }
    ]
  },
  {
    "char": "C",
    "name": {
      "fr": "C majuscule",
      "en": "uppercase C",
      "es": "C mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre C est une grande courbe ronde, presque fermée, ouverte seulement à droite. Trace-la en un seul geste depuis le haut.",
      "en": "The letter C is a large round curve, almost closed, open only on the right. Trace it in a single motion from the top.",
      "es": "La letra C es una gran curva redonda, casi cerrada, abierta solo a la derecha. Trázala en un solo gesto desde arriba."
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
          "en": "Large curve open on the right",
          "es": "Gran curva abierta a la derecha"
        }
      }
    ]
  },
  {
    "char": "D",
    "name": {
      "fr": "D majuscule",
      "en": "uppercase D",
      "es": "D mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre D se forme en deux gestes. D'abord un trait vertical pleine hauteur. Ensuite une grande courbe qui referme l'ouverture en haut et en bas, accolée à droite du trait.",
      "en": "The letter D is formed in two gestures. First a full-height vertical line. Then a large curve closing the opening at the top and bottom, attached to the right of the line.",
      "es": "La letra D se forma en dos gestos. Primero un trazo vertical de altura completa. Luego una gran curva que cierra la abertura arriba y abajo, pegada a la derecha del trazo."
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
          "en": "Full-height vertical line",
          "es": "Trazo vertical de altura completa"
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
          "en": "Large curve, attached to the right of the line",
          "es": "Gran curva, pegada a la derecha del trazo"
        }
      }
    ]
  },
  {
    "char": "E",
    "name": {
      "fr": "E majuscule",
      "en": "uppercase E",
      "es": "E mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre E se forme en quatre gestes. Un trait vertical, puis trois traits horizontaux qui partent tous du trait vers la droite : en haut, au milieu, en bas.",
      "en": "The letter E is formed in four gestures. A vertical line, then three horizontal lines all starting from the line toward the right: at the top, in the middle, at the bottom.",
      "es": "La letra E se forma en cuatro gestos. Un trazo vertical, luego tres trazos horizontales que salen todos del trazo hacia la derecha: arriba, en el medio, abajo."
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
          "en": "Vertical line",
          "es": "Trazo vertical"
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
          "en": "Top horizontal",
          "es": "Horizontal de arriba"
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
          "en": "Middle horizontal",
          "es": "Horizontal del medio"
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
          "en": "Bottom horizontal",
          "es": "Horizontal de abajo"
        }
      }
    ]
  },
  {
    "char": "F",
    "name": {
      "fr": "F majuscule",
      "en": "uppercase F",
      "es": "F mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre F se forme comme le E, mais sans la barre du bas : un trait vertical, une horizontale en haut, une horizontale au milieu.",
      "en": "The letter F is formed like the E, but without the bottom bar: a vertical line, a horizontal at the top, a horizontal in the middle.",
      "es": "La letra F se forma como la E, pero sin la barra de abajo: un trazo vertical, una horizontal arriba, una horizontal en el medio."
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
          "en": "Vertical line",
          "es": "Trazo vertical"
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
          "en": "Top horizontal",
          "es": "Horizontal de arriba"
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
          "en": "Middle horizontal",
          "es": "Horizontal del medio"
        }
      }
    ]
  },
  {
    "char": "G",
    "name": {
      "fr": "G majuscule",
      "en": "uppercase G",
      "es": "G mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre G se forme en trois gestes. D'abord une grande courbe ouverte à droite. Ensuite un trait horizontal qui va de la gauche vers la droite, au niveau du centre de la courbe. Enfin, à son extrémité, un trait vertical qui descend du haut vers le bas.",
      "en": "The letter G is formed in three gestures. First a large curve open on the right. Then a horizontal line going from left to right, at the curve's center height. Finally, at its end, a vertical line going down from top to bottom.",
      "es": "La letra G se forma en tres gestos. Primero una gran curva abierta a la derecha. Luego un trazo horizontal que va de izquierda a derecha, a la altura del centro de la curva. Por último, en su extremo, un trazo vertical que baja de arriba hacia abajo."
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
          "en": "Large curve open on the right",
          "es": "Gran curva abierta a la derecha"
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
          "en": "Horizontal line, left to right, at the curve's center",
          "es": "Trazo horizontal, de izquierda a derecha, en el centro de la curva"
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
          "en": "Vertical line, at the end of the horizontal, top to bottom",
          "es": "Trazo vertical, en el extremo de la horizontal, de arriba hacia abajo"
        }
      }
    ]
  },
  {
    "char": "H",
    "name": {
      "fr": "H majuscule",
      "en": "uppercase H",
      "es": "H mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre H se forme en trois gestes. Deux traits verticaux parallèles, puis un trait horizontal qui les relie au milieu.",
      "en": "The letter H is formed in three gestures. Two parallel vertical lines, then a horizontal line linking them in the middle.",
      "es": "La letra H se forma en tres gestos. Dos trazos verticales paralelos, luego un trazo horizontal que los une en el medio."
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
          "en": "First vertical line, on the left",
          "es": "Primer trazo vertical, a la izquierda"
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
          "en": "Second vertical line, on the right",
          "es": "Segundo trazo vertical, a la derecha"
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
          "en": "Horizontal line, links the two in the middle",
          "es": "Trazo horizontal, une los dos en el medio"
        }
      }
    ]
  },
  {
    "char": "I",
    "name": {
      "fr": "I majuscule",
      "en": "uppercase I",
      "es": "I mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre I est un simple trait vertical pleine hauteur, tracé du haut vers le bas.",
      "en": "The letter I is a simple full-height vertical line, traced from top to bottom.",
      "es": "La letra I es un simple trazo vertical de altura completa, trazado de arriba hacia abajo."
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
          "en": "Vertical line, from top to bottom",
          "es": "Trazo vertical, de arriba hacia abajo"
        }
      }
    ]
  },
  {
    "char": "J",
    "name": {
      "fr": "J majuscule",
      "en": "uppercase J",
      "es": "J mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre J se forme en un grand crochet : un trait vertical pleine hauteur qui s'arrondit vers la gauche tout en bas.",
      "en": "The letter J is formed as one large hook: a full-height vertical line curving to the left at the very bottom.",
      "es": "La letra J se forma con un gran gancho: un trazo vertical de altura completa que se curva hacia la izquierda hasta abajo."
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
          "en": "Line going down and curving left at the bottom",
          "es": "Trazo que baja y se curva hacia la izquierda abajo"
        }
      }
    ]
  },
  {
    "char": "K",
    "name": {
      "fr": "K majuscule",
      "en": "uppercase K",
      "es": "K mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre K se forme en trois gestes. Un trait vertical, puis une oblique du milieu vers le haut-droite, puis une oblique du milieu vers le bas-droite.",
      "en": "The letter K is formed in three gestures. A vertical line, then a diagonal from the middle to the upper right, then a diagonal from the middle to the lower right.",
      "es": "La letra K se forma en tres gestos. Un trazo vertical, luego un oblicuo desde el medio hacia arriba a la derecha, luego un oblicuo desde el medio hacia abajo a la derecha."
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
          "en": "Vertical line",
          "es": "Trazo vertical"
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
          "en": "Diagonal from the middle to the upper right",
          "es": "Oblicuo desde el medio hacia arriba a la derecha"
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
          "en": "Diagonal from the middle to the lower right",
          "es": "Oblicuo desde el medio hacia abajo a la derecha"
        }
      }
    ]
  },
  {
    "char": "L",
    "name": {
      "fr": "L majuscule",
      "en": "uppercase L",
      "es": "L mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre L se forme en deux gestes. Un trait vertical, puis un trait horizontal qui part du bas vers la droite.",
      "en": "The letter L is formed in two gestures. A vertical line, then a horizontal line going from the bottom toward the right.",
      "es": "La letra L se forma en dos gestos. Un trazo vertical, luego un trazo horizontal que sale de abajo hacia la derecha."
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
          "en": "Vertical line",
          "es": "Trazo vertical"
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
          "en": "Bottom horizontal",
          "es": "Horizontal de abajo"
        }
      }
    ]
  },
  {
    "char": "M",
    "name": {
      "fr": "M majuscule",
      "en": "uppercase M",
      "es": "M mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre M se forme en quatre gestes. Un trait vertical à gauche, une oblique qui descend vers le centre, une oblique qui remonte vers la droite, puis un trait vertical à droite.",
      "en": "The letter M is formed in four gestures. A vertical line on the left, a diagonal going down to the center, a diagonal going up to the right, then a vertical line on the right.",
      "es": "La letra M se forma en cuatro gestos. Un trazo vertical a la izquierda, un oblicuo que baja hacia el centro, un oblicuo que sube hacia la derecha, y luego un trazo vertical a la derecha."
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
          "en": "Left vertical line",
          "es": "Trazo vertical izquierdo"
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
          "en": "Diagonal, left top to the center",
          "es": "Oblicuo, del vértice izquierdo al centro"
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
          "en": "Diagonal, center to the right top",
          "es": "Oblicuo, del centro al vértice derecho"
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
          "en": "Right vertical line",
          "es": "Trazo vertical derecho"
        }
      }
    ]
  },
  {
    "char": "N",
    "name": {
      "fr": "N majuscule",
      "en": "uppercase N",
      "es": "N mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre N se forme en trois gestes. Un trait vertical à gauche, une oblique qui relie son sommet à la base du second trait, puis le trait vertical à droite.",
      "en": "The letter N is formed in three gestures. A vertical line on the left, a diagonal linking its top to the base of the second line, then the vertical line on the right.",
      "es": "La letra N se forma en tres gestos. Un trazo vertical a la izquierda, un oblicuo que une su vértice con la base del segundo trazo, y luego el trazo vertical a la derecha."
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
          "en": "Left vertical line",
          "es": "Trazo vertical izquierdo"
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
          "en": "Diagonal, left top to the right base",
          "es": "Oblicuo, del vértice izquierdo a la base derecha"
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
          "en": "Right vertical line",
          "es": "Trazo vertical derecho"
        }
      }
    ]
  },
  {
    "char": "Ñ",
    "name": {
      "fr": "N espagnol (Eñe) majuscule",
      "en": "uppercase spanish Ñ",
      "es": "Eñe mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre Ñ se forme comme un N, puis on ajoute un petit tilde ondulé au-dessus.",
      "en": "The letter Ñ is formed like an N, then a small wavy tilde is added above it.",
      "es": "La letra Ñ se forma como una N, y luego se añade una pequeña virgulilla ondulada encima."
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
          "en": "Left vertical line",
          "es": "Trazo vertical izquierdo"
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
          "en": "Diagonal, left top to the right base",
          "es": "Oblicuo, del vértice izquierdo a la base derecha"
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
          "en": "Right vertical line",
          "es": "Trazo vertical derecho"
        }
      },
      {
        "family": "courbe",
        "variant": "tilde",
        "pathD": "M 75 10 C 81 1 89 1 96 8 C 103 15 111 15 119 6",
        "startXY": [
          75,
          10
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Petit tilde ondulé au-dessus du N",
          "en": "Small wavy tilde above the N",
          "es": "Pequeña virgulilla ondulada encima de la N"
        }
      }
    ]
  },
  {
    "char": "O",
    "name": {
      "fr": "O majuscule",
      "en": "uppercase O",
      "es": "O mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre O est un grand ovale complet. Pars du sommet et tourne dans le sens anti-horaire en un seul mouvement continu.",
      "en": "The letter O is a large full oval. Start at the top and turn counter-clockwise in one continuous motion.",
      "es": "La letra O es un gran óvalo completo. Parte desde arriba y gira en sentido antihorario en un solo movimiento continuo."
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
          "en": "Large full oval, counter-clockwise from the top",
          "es": "Gran óvalo completo, antihorario desde arriba"
        }
      }
    ]
  },
  {
    "char": "P",
    "name": {
      "fr": "P majuscule",
      "en": "uppercase P",
      "es": "P mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre P se forme en deux gestes. Un trait vertical pleine hauteur, puis une courbe ronde accolée en haut à droite seulement.",
      "en": "The letter P is formed in two gestures. A full-height vertical line, then a round curve attached only to the upper right.",
      "es": "La letra P se forma en dos gestos. Un trazo vertical de altura completa, luego una curva redonda pegada solo arriba a la derecha."
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
          "en": "Full-height vertical line",
          "es": "Trazo vertical de altura completa"
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
          "en": "Upper curve, attached on the right",
          "es": "Curva de arriba, pegada a la derecha"
        }
      }
    ]
  },
  {
    "char": "Q",
    "name": {
      "fr": "Q majuscule",
      "en": "uppercase Q",
      "es": "Q mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre Q se forme en deux gestes. D'abord un grand ovale complet, comme le O. Ensuite une petite oblique qui sort du cercle vers le bas-droite.",
      "en": "The letter Q is formed in two gestures. First a large full oval, like the O. Then a small diagonal coming out of the circle toward the lower right.",
      "es": "La letra Q se forma en dos gestos. Primero un gran óvalo completo, como la O. Luego un pequeño oblicuo que sale del círculo hacia abajo a la derecha."
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
          "en": "Large full oval",
          "es": "Gran óvalo completo"
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
          "en": "Small diagonal coming out toward the lower right",
          "es": "Pequeño oblicuo que sale hacia abajo a la derecha"
        }
      }
    ]
  },
  {
    "char": "R",
    "name": {
      "fr": "R majuscule",
      "en": "uppercase R",
      "es": "R mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre R se forme comme un P, avec une jambe en plus. Trait vertical, courbe en haut à droite, puis une oblique qui part du point de jonction vers le bas-droite.",
      "en": "The letter R is formed like a P, with an extra leg. Vertical line, curve at the upper right, then a diagonal starting from the junction point toward the lower right.",
      "es": "La letra R se forma como una P, con una pierna adicional. Trazo vertical, curva arriba a la derecha, luego un oblicuo que sale del punto de unión hacia abajo a la derecha."
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
          "en": "Full-height vertical line",
          "es": "Trazo vertical de altura completa"
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
          "en": "Upper curve, attached on the right",
          "es": "Curva de arriba, pegada a la derecha"
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
          "en": "Diagonal leg toward the lower right",
          "es": "Pierna oblicua hacia abajo a la derecha"
        }
      }
    ]
  },
  {
    "char": "S",
    "name": {
      "fr": "S majuscule",
      "en": "uppercase S",
      "es": "S mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre S se forme comme le s minuscule mais à pleine hauteur : un grand crochet en haut qui s'arrondit à droite, puis un grand crochet en bas qui s'arrondit à gauche.",
      "en": "The letter S is formed like the lowercase s but at full height: a large hook at the top curving right, then a large hook at the bottom curving left.",
      "es": "La letra S se forma como la s minúscula pero a altura completa: un gran gancho arriba que se curva a la derecha, luego un gran gancho abajo que se curva a la izquierda."
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
          "en": "Large hook, curving right at the top",
          "es": "Gran gancho, se curva hacia la derecha arriba"
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
          "en": "Large hook, curving left at the bottom",
          "es": "Gran gancho, se curva hacia la izquierda abajo"
        }
      }
    ]
  },
  {
    "char": "T",
    "name": {
      "fr": "T majuscule",
      "en": "uppercase T",
      "es": "T mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre T se forme en deux gestes. Un trait horizontal en haut, puis un trait vertical qui part du centre de l'horizontale vers le bas.",
      "en": "The letter T is formed in two gestures. A horizontal line at the top, then a vertical line starting from the center of the horizontal going down.",
      "es": "La letra T se forma en dos gestos. Un trazo horizontal arriba, luego un trazo vertical que sale del centro de la horizontal hacia abajo."
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
          "en": "Horizontal line at the top",
          "es": "Trazo horizontal arriba"
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
          "en": "Vertical line, centered under the horizontal",
          "es": "Trazo vertical, centrado bajo la horizontal"
        }
      }
    ]
  },
  {
    "char": "U",
    "name": {
      "fr": "U majuscule",
      "en": "uppercase U",
      "es": "U mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre U se forme en trois gestes. Un trait vertical à gauche, un grand crochet qui relie le bas des deux traits, puis le trait vertical à droite.",
      "en": "The letter U is formed in three gestures. A vertical line on the left, a large hook linking the bottom of the two lines, then the vertical line on the right.",
      "es": "La letra U se forma en tres gestos. Un trazo vertical a la izquierda, un gran gancho que une la base de los dos trazos, y luego el trazo vertical a la derecha."
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
          "en": "Left vertical line",
          "es": "Trazo vertical izquierdo"
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
          "en": "Bottom hook, links the two lines",
          "es": "Gancho de abajo, une los dos trazos"
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
          "en": "Right vertical line",
          "es": "Trazo vertical derecho"
        }
      }
    ]
  },
  {
    "char": "V",
    "name": {
      "fr": "V majuscule",
      "en": "uppercase V",
      "es": "V mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre V se forme en deux gestes, comme le v minuscule mais à pleine hauteur. Une oblique qui descend du haut-gauche vers le centre-bas, puis une oblique qui remonte vers le haut-droite.",
      "en": "The letter V is formed in two gestures, like the lowercase v but at full height. A diagonal going down from the upper left to the center-bottom, then a diagonal going up to the upper right.",
      "es": "La letra V se forma en dos gestos, como la v minúscula pero a altura completa. Un oblicuo que baja desde arriba a la izquierda hacia el centro abajo, luego un oblicuo que sube hacia arriba a la derecha."
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
          "en": "Diagonal going down, upper left to center-bottom",
          "es": "Oblicuo descendente, de arriba a la izquierda al centro abajo"
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
          "en": "Diagonal going up, center-bottom to upper right",
          "es": "Oblicuo ascendente, del centro abajo hacia arriba a la derecha"
        }
      }
    ]
  },
  {
    "char": "W",
    "name": {
      "fr": "W majuscule",
      "en": "uppercase W",
      "es": "W mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre W se forme en quatre obliques alternant descente et montée.",
      "en": "The letter W is formed with four diagonals alternating down and up.",
      "es": "La letra W se forma con cuatro oblicuos alternando bajada y subida."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 53 18 L 75 149",
        "startXY": [
          53,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Première oblique descendante",
          "en": "First diagonal going down",
          "es": "Primer oblicuo descendente"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 75 149 L 97 18",
        "startXY": [
          75,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Deuxième oblique montante",
          "en": "Second diagonal going up",
          "es": "Segundo oblicuo ascendente"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 97 18 L 119 149",
        "startXY": [
          97,
          18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Troisième oblique descendante",
          "en": "Third diagonal going down",
          "es": "Tercer oblicuo descendente"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 119 149 L 141 18",
        "startXY": [
          119,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Quatrième oblique montante",
          "en": "Fourth diagonal going up",
          "es": "Cuarto oblicuo ascendente"
        }
      }
    ]
  },
  {
    "char": "X",
    "name": {
      "fr": "X majuscule",
      "en": "uppercase X",
      "es": "X mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre X se forme en deux traits obliques qui se croisent au centre, à pleine hauteur.",
      "en": "The letter X is formed with two diagonal lines crossing at the center, at full height.",
      "es": "La letra X se forma con dos trazos oblicuos que se cruzan en el centro, a altura completa."
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
          "en": "Diagonal upper left to lower right",
          "es": "Oblicuo de arriba a la izquierda hacia abajo a la derecha"
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
          "en": "Diagonal upper right to lower left",
          "es": "Oblicuo de arriba a la derecha hacia abajo a la izquierda"
        }
      }
    ]
  },
  {
    "char": "Y",
    "name": {
      "fr": "Y majuscule",
      "en": "uppercase Y",
      "es": "Y mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre Y se forme en trois gestes. Deux obliques qui partent du sommet et se rejoignent au centre, puis un trait vertical court qui descend depuis ce point.",
      "en": "The letter Y is formed in three gestures. Two diagonals starting from the top and meeting at the center, then a short vertical line going down from that point.",
      "es": "La letra Y se forma en tres gestos. Dos oblicuos que parten desde arriba y se juntan en el centro, luego un trazo vertical corto que baja desde ese punto."
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
          "en": "Diagonal, left top to the center",
          "es": "Oblicuo, del vértice izquierdo al centro"
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
          "en": "Diagonal, right top to the center",
          "es": "Oblicuo, del vértice derecho al centro"
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
          "en": "Short vertical line, center to the bottom",
          "es": "Trazo vertical corto, del centro hacia abajo"
        }
      }
    ]
  },
  {
    "char": "Z",
    "name": {
      "fr": "Z majuscule",
      "en": "uppercase Z",
      "es": "Z mayúscula"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre Z se forme comme le z minuscule à pleine hauteur : un trait horizontal en haut, une oblique vers le bas-gauche, un trait horizontal en bas.",
      "en": "The letter Z is formed like the full-height lowercase z: a horizontal line at the top, a diagonal toward the lower left, a horizontal line at the bottom.",
      "es": "La letra Z se forma como la z minúscula a altura completa: un trazo horizontal arriba, un oblicuo hacia abajo a la izquierda, un trazo horizontal abajo."
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
          "en": "Horizontal line at the top",
          "es": "Trazo horizontal arriba"
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
          "en": "Diagonal toward the lower left",
          "es": "Oblicuo hacia abajo a la izquierda"
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
          "en": "Horizontal line at the bottom",
          "es": "Trazo horizontal abajo"
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
      "en": "zero",
      "es": "cero"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 0 est un ovale complet. Pars du sommet et tourne dans le sens anti-horaire.",
      "en": "The digit 0 is a full oval. Start at the top and turn counter-clockwise.",
      "es": "El número 0 es un óvalo completo. Parte desde arriba y gira en sentido antihorario."
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
          "en": "Full oval, counter-clockwise from the top",
          "es": "Óvalo completo, antihorario desde arriba"
        }
      }
    ]
  },
  {
    "char": "1",
    "name": {
      "fr": "un",
      "en": "one",
      "es": "uno"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 1 se forme en deux gestes. Une petite amorce oblique qui rejoint le sommet, puis un trait vertical qui descend jusqu'à la ligne.",
      "en": "The digit 1 is formed in two gestures. A small diagonal lead-in reaching the top, then a vertical line going down to the baseline.",
      "es": "El número 1 se forma en dos gestos. Un pequeño trazo oblicuo de entrada que llega hasta arriba, luego un trazo vertical que baja hasta la línea."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 88.50 89.26 L 67.85 118.75",
        "startXY": [
          88.5,
          89.26
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Amorce oblique vers le sommet",
          "en": "Diagonal lead-in to the top",
          "es": "Trazo oblicuo de entrada hacia arriba"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 88.71 89.64 L 88.71 143.64",
        "startXY": [
          88.71,
          89.64
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, du haut vers le bas",
          "en": "Vertical line, from top to bottom",
          "es": "Trazo vertical, de arriba hacia abajo"
        }
      }
    ]
  },
  {
    "char": "2",
    "name": {
      "fr": "deux",
      "en": "two",
      "es": "dos"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 2 se forme en deux gestes. Un crochet qui part du haut, s'arrondit puis descend vers le bas-gauche, ensuite un trait horizontal à la base.",
      "en": "The digit 2 is formed in two gestures. A hook starting at the top, curving and going down to the lower left, then a horizontal line at the base.",
      "es": "El número 2 se forma en dos gestos. Un gancho que parte de arriba, se curva y baja hacia abajo a la izquierda, luego un trazo horizontal en la base."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "top-left",
        "pathD": "M 83.67 148.45 L 110.72 121.40 A 12.75 12.75 0 0 0 92.69 103.37",
        "startXY": [
          83.67,
          148.45
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet qui part du haut et descend vers le bas-gauche",
          "en": "Hook starting at the top, going down to the lower left",
          "es": "Gancho que parte de arriba y baja hacia abajo a la izquierda"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 119.77 148.59 L 83.77 148.59",
        "startXY": [
          119.77,
          148.59
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal à la base",
          "en": "Horizontal line at the base",
          "es": "Trazo horizontal en la base"
        }
      }
    ]
  },
  {
    "char": "3",
    "name": {
      "fr": "trois",
      "en": "three",
      "es": "tres"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 3 se forme en deux courbes empilées, ouvertes vers la gauche, qui se touchent au centre.",
      "en": "The digit 3 is formed with two stacked curves, open to the left, touching in the middle.",
      "es": "El número 3 se forma con dos curvas apiladas, abiertas hacia la izquierda, que se tocan en el centro."
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
          "en": "Upper curve, open to the left",
          "es": "Curva de arriba, abierta a la izquierda"
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
          "en": "Lower curve, open to the left",
          "es": "Curva de abajo, abierta a la izquierda"
        }
      }
    ]
  },
  {
    "char": "4",
    "name": {
      "fr": "quatre",
      "en": "four",
      "es": "cuatro"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 4 se forme en trois gestes. Une oblique qui descend vers le bas-gauche, un trait horizontal à sa base, puis un trait vertical qui traverse l'horizontale et dépasse vers le haut.",
      "en": "The digit 4 is formed in three gestures. A diagonal going down to the lower left, a horizontal line at its base, then a vertical line crossing the horizontal and going past it at the top.",
      "es": "El número 4 se forma en tres gestos. Un oblicuo que baja hacia abajo a la izquierda, un trazo horizontal en su base, luego un trazo vertical que cruza la horizontal y sobrepasa hacia arriba."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 96.49 94.24 L 72.09 149.05",
        "startXY": [
          96.49,
          94.24
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique vers le bas-gauche",
          "en": "Diagonal toward the lower left",
          "es": "Oblicuo hacia abajo a la izquierda"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 132.29 149.12 L 72.29 149.12",
        "startXY": [
          132.29,
          149.12
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal, base de l'oblique",
          "en": "Horizontal line, base of the diagonal",
          "es": "Trazo horizontal, base del oblicuo"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 102.47 119.69 L 102.47 179.69",
        "startXY": [
          102.47,
          119.69
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical qui traverse et dépasse",
          "en": "Vertical line crossing and going past",
          "es": "Trazo vertical que cruza y sobrepasa"
        }
      }
    ]
  },
  {
    "char": "5",
    "name": {
      "fr": "cinq",
      "en": "five",
      "es": "cinco"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 5 se forme en trois gestes. Un trait horizontal en haut, un petit trait vertical qui descend à gauche, puis un crochet qui balaie un grand arc, de haut en bas, en restant aligné à la verticale entre son origine et son extrémité.",
      "en": "The digit 5 is formed in three gestures. A horizontal line at the top, a small vertical line going down on the left, then a hook sweeping a large arc, top to bottom, with its start and end vertically aligned.",
      "es": "El número 5 se forma en tres gestos. Un trazo horizontal arriba, un pequeño trazo vertical que baja a la izquierda, luego un gancho que traza un gran arco, de arriba abajo, quedando alineado verticalmente entre su origen y su extremo."
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
          "en": "Horizontal line at the top",
          "es": "Trazo horizontal arriba"
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
          "en": "Small vertical line on the left",
          "es": "Pequeño trazo vertical a la izquierda"
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
          "en": "Hook sweeping a large arc and coming back down aligned with its starting point",
          "es": "Gancho que traza un gran arco y vuelve a bajar alineado con su punto de partida"
        }
      }
    ]
  },
  {
    "char": "6",
    "name": {
      "fr": "six",
      "en": "six",
      "es": "seis"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 6 se forme comme le 9, mais inversé : d'abord un crochet qui part du haut, descend et s'arrondit en haut à droite, puis un anneau fermé en bas, dessiné dans le sens anti-horaire à partir du point où s'arrête le crochet.",
      "en": "The digit 6 is formed like the 9, but inverted: first a hook starting at the top, going down and curving at the upper right, then a closed ring at the bottom, drawn counterclockwise starting exactly where the hook ends.",
      "es": "El número 6 se forma como el 9, pero invertido: primero un gancho que parte de arriba, baja y se curva arriba a la derecha, luego un anillo cerrado abajo, trazado en sentido antihorario a partir del punto donde termina el gancho."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "top-right",
        "pathD": "M 91.50 142.00 L 91.50 115.30 A 9.30 9.30 0 0 1 110.05 114.33",
        "startXY": [
          91.5,
          142
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet qui part de la courbure en haut à droite, puis descend tout droit",
          "en": "Hook starting from the upper-right curve, then going straight down",
          "es": "Gancho que parte de la curva arriba a la derecha, luego baja recto"
        }
      },
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 91.68 134.88 A 10.32 10.32 0 1 1 91.68 142.62",
        "startXY": [
          91.68,
          134.88
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Anneau fermé en bas, tracé dans le sens anti-horaire à partir du point d'arrêt du crochet",
          "en": "Closed ring at the bottom, drawn counterclockwise from the hook's end point",
          "es": "Anillo cerrado abajo, trazado en sentido antihorario desde el punto final del gancho"
        }
      }
    ]
  },
  {
    "char": "7",
    "name": {
      "fr": "sept",
      "en": "seven",
      "es": "siete"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 7 se forme en deux gestes. Un trait horizontal en haut, puis une oblique qui descend du haut-droite vers le bas-centre.",
      "en": "The digit 7 is formed in two gestures. A horizontal line at the top, then a diagonal going down from the upper right to the center-bottom.",
      "es": "El número 7 se forma en dos gestos. Un trazo horizontal arriba, luego un oblicuo que baja desde arriba a la derecha hacia el centro abajo."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 116.50 105.75 L 86.50 105.75",
        "startXY": [
          116.5,
          105.75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en haut",
          "en": "Horizontal line at the top",
          "es": "Trazo horizontal arriba"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 116.89 106.00 L 96.61 149.50",
        "startXY": [
          116.89,
          106
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique vers le bas-centre",
          "en": "Diagonal toward the center-bottom",
          "es": "Oblicuo hacia el centro abajo"
        }
      }
    ]
  },
  {
    "char": "8",
    "name": {
      "fr": "huit",
      "en": "eight",
      "es": "ocho"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 8 se forme en deux petits anneaux empilés, celui du haut un peu plus petit que celui du bas.",
      "en": "The digit 8 is formed with two small stacked rings, the top one a little smaller than the bottom one.",
      "es": "El número 8 se forma con dos pequeños anillos apilados, el de arriba un poco más pequeño que el de abajo."
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
          "en": "Small upper ring",
          "es": "Pequeño anillo de arriba"
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
          "en": "Bottom ring, slightly larger",
          "es": "Anillo de abajo, ligeramente más grande"
        }
      }
    ]
  },
  {
    "char": "9",
    "name": {
      "fr": "neuf",
      "en": "nine",
      "es": "nueve"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 9 se forme comme le 6 mais inversé. D'abord un anneau fermé en haut, dessiné dans le sens anti-horaire, puis un crochet tangent au bord droit de l'anneau, qui descend et s'arrondit en bas à gauche.",
      "en": "The digit 9 is formed like the 6 but inverted. First a closed ring at the top, drawn counterclockwise, then a hook tangent to the ring's right edge, going down and curving at the lower left.",
      "es": "El número 9 se forma como el 6 pero invertido. Primero un anillo cerrado arriba, trazado en sentido antihorario, luego un gancho tangente al borde derecho del anillo, que baja y se curva abajo a la izquierda."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 119.08 115.92 A 12.00 12.00 0 1 1 119.08 105.58",
        "startXY": [
          119.08,
          115.92
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Anneau fermé en haut, tracé dans le sens anti-horaire",
          "en": "Closed ring at the top, drawn counterclockwise",
          "es": "Anillo cerrado arriba, trazado en sentido antihorario"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 119.00 104.25 L 119.00 135.75 A 10.50 10.50 0 0 1 98.63 139.34",
        "startXY": [
          119,
          104.25
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet tangent au bord droit de l'anneau, descend puis s'arrondit en bas à gauche",
          "en": "Hook tangent to the ring's right edge, going down then curving at the lower left",
          "es": "Gancho tangente al borde derecho del anillo, baja y luego se curva abajo a la izquierda"
        }
      }
    ]
  }
]
''');

final List<dynamic> LETTER_CATALOG = [
  ...VOWELS,
  ...CONSONANTS,
  ...UPPERCASE,
  ...DIGITS,
];

/// Table de correspondance caractère → formation, pour les écrans qui
/// recherchent une lettre/chiffre précis (cahier d'écriture, mots...).
final Map<String, dynamic> LETTER_MAP = {
  for (final l in LETTER_CATALOG) l['char'] as String: l,
};
