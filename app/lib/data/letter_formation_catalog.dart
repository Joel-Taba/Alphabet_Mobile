import 'dart:convert';

final List<dynamic> VOWELS = jsonDecode(r'''
[
  {
    "char": "a",
    "name": {
      "fr": "a minuscule",
      "en": "lowercase a",
      "es": "a minúscula",
      "ar": "الحرف a الصغير"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre A se forme en deux gestes. D'abord, trace une courbe bien ronde, presque fermée, qui ne reste ouverte qu'à droite. Ensuite, ajoute un trait vertical qui vient refermer cette ouverture, du haut vers le bas.",
      "en": "The letter A is formed in two gestures. First, trace a nicely round curve, almost closed, staying open only at the right. Then, add a vertical line that closes that opening, from top to bottom.",
      "es": "La letra A se forma en dos gestos. Primero, traza una curva bien redonda, casi cerrada, que quede abierta solo a la derecha. Luego, añade un trazo vertical que cierre esa abertura, de arriba hacia abajo.",
      "ar": "يتكون الحرف A من حركتين. أولاً، ارسم منحنى مستديرًا جميلاً، شبه مغلق، يبقى مفتوحًا فقط من الجهة اليمنى. ثم أضف خطًا عموديًا يغلق تلك الفتحة، من الأعلى إلى الأسفل."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 112.77 82.21 A 24.66 24.66 0 1 0 112.77 117.1",
        "startXY": [
          112.77,
          82.21
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe circulaire presque fermée, ouverte à droite horizontalement",
          "en": "Circular curve almost closed, open horizontally at the right",
          "es": "Curva circular casi cerrada, abierta a la derecha horizontalmente",
          "ar": "منحنى دائري شبه مغلق، مفتوح إلى اليمين أفقيًا"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 112.77 79.1 L 112.77 125",
        "startXY": [
          112.77,
          79.1
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical qui referme la courbe, du haut vers le bas, en débordant légèrement de part et d'autre",
          "en": "Vertical line that closes the curve, from top to bottom, slightly overshooting both ends",
          "es": "Trazo vertical que cierra la curva, de arriba hacia abajo, sobrepasando ligeramente por ambos lados",
          "ar": "خط عمودي يغلق المنحنى، من الأعلى إلى الأسفل، متجاوزًا قليلاً من الجانبين"
        }
      }
    ]
  },
  {
    "char": "e",
    "name": {
      "fr": "e minuscule",
      "en": "lowercase e",
      "es": "e minúscula",
      "ar": "الحرف e الصغير"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre E se forme en deux gestes. D'abord, trace un trait horizontal au milieu. Ensuite, dessine une courbe bien ronde qui part de la pointe du trait, encercle tout le tour et s'ouvre juste un peu en bas à droite.",
      "en": "The letter E is formed in two gestures. First, trace a horizontal line in the middle. Then, draw a nicely round curve that starts from the tip of the line, circles all the way round and opens just a little at the bottom right.",
      "es": "La letra E se forma en dos gestos. Primero, traza un trazo horizontal en el medio. Luego, dibuja una curva bien redonda que parte de la punta del trazo, rodea todo el contorno y se abre un poco abajo a la derecha.",
      "ar": "يتكون الحرف E من حركتين. أولاً، ارسم خطًا أفقيًا في المنتصف. ثم ارسم منحنى مستديرًا جميلاً ينطلق من طرف الخط، يحيط بالدائرة بالكامل وينفتح قليلاً أسفل اليمين."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 58.88 94.04 L 106.76 94.04",
        "startXY": [
          58.88,
          94.04
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal au centre, de gauche à droite",
          "en": "Horizontal line in the center, left to right",
          "es": "Trazo horizontal en el centro, de izquierda a derecha",
          "ar": "خط أفقي في المنتصف، من اليسار إلى اليمين"
        }
      },
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 106.48 92.89 A 25 25 0 1 0 102.61 114.87",
        "startXY": [
          106.48,
          92.89
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe qui entoure le trait, ouverte en bas à droite",
          "en": "Curve that surrounds the line, open at the bottom right",
          "es": "Curva que rodea el trazo, abierta abajo a la derecha",
          "ar": "منحنى يحيط بالخط، مفتوح أسفل اليمين"
        }
      }
    ]
  },
  {
    "char": "i",
    "name": {
      "fr": "i minuscule",
      "en": "lowercase i",
      "es": "i minúscula",
      "ar": "الحرف i الصغير"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre I se forme en deux gestes. D'abord, trace un trait vertical dans le corps de la ligne. Ensuite, pose un point rond au-dessus du trait, sans le toucher.",
      "en": "The letter I is formed in two gestures. First, trace a vertical line in the body of the writing line. Then, place a round dot above the line, without touching it.",
      "es": "La letra I se forma en dos gestos. Primero, traza un trazo vertical en el cuerpo de la línea de escritura. Luego, coloca un punto redondo encima del trazo, sin tocarlo.",
      "ar": "يتكون الحرف I من حركتين. أولاً، ارسم خطًا عموديًا في جسم السطر. ثم ضع نقطة مستديرة فوق الخط، دون لمسه."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 91.24 75 L 91.24 125",
        "startXY": [
          91.24,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, du haut vers le bas",
          "en": "Vertical line, from top to bottom",
          "es": "Trazo vertical, de arriba hacia abajo",
          "ar": "خط عمودي، من الأعلى إلى الأسفل"
        }
      },
      {
        "family": "point",
        "variant": "center",
        "pathD": "M 92.11 57 A 2.33 2.33 0 1 0 92.17 57",
        "startXY": [
          92.11,
          57
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Point au-dessus du trait, petit rond détaché",
          "en": "Dot above the line, small detached circle",
          "es": "Punto encima del trazo, pequeño círculo separado",
          "ar": "نقطة فوق الخط، دائرة صغيرة منفصلة"
        }
      }
    ]
  },
  {
    "char": "o",
    "name": {
      "fr": "o minuscule",
      "en": "lowercase o",
      "es": "o minúscula",
      "ar": "الحرف o الصغير"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre O est un ovale complet. Pars du sommet et tourne dans le sens anti-horaire en un seul mouvement continu, doux et régulier.",
      "en": "The letter O is a full oval. Start at the top and turn counter-clockwise in one smooth, continuous motion.",
      "es": "La letra O es un óvalo completo. Parte desde arriba y gira en sentido antihorario en un solo movimiento continuo, suave y regular.",
      "ar": "الحرف O عبارة عن بيضاوي كامل. ابدأ من الأعلى ودُر في اتجاه عكس عقارب الساعة بحركة واحدة متصلة، ليّنة ومنتظمة."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 100.03 75 A 22.34 25 0 1 0 100.08 75",
        "startXY": [
          100.03,
          75
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Ovale complet, anti-horaire depuis le sommet",
          "en": "Full oval, counter-clockwise from the top",
          "es": "Óvalo completo, antihorario desde arriba",
          "ar": "بيضاوي كامل، عكس اتجاه عقارب الساعة من الأعلى"
        }
      }
    ]
  },
  {
    "char": "u",
    "name": {
      "fr": "u minuscule",
      "en": "lowercase u",
      "es": "u minúscula",
      "ar": "الحرف u الصغير"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre U se forme en deux gestes. D'abord, trace un crochet bas-droite : descends puis arrondis doucement vers la droite en bas. Ensuite, ajoute un trait vertical sur le bord droit, du haut vers le bas.",
      "en": "The letter U is formed in two gestures. First, trace a bottom-right hook: go down, then curve gently to the right at the bottom. Then, add a vertical line on the right edge, from top to bottom.",
      "es": "La letra U se forma en dos gestos. Primero, traza un gancho abajo-derecha: baja y luego curva suavemente hacia la derecha en la parte inferior. Luego, añade un trazo vertical en el borde derecho, de arriba hacia abajo.",
      "ar": "يتكون الحرف U من حركتين. أولاً، ارسم خطافًا أسفل اليمين: انزل ثم انحنِ برفق نحو اليمين في الأسفل. ثم أضف خطًا عموديًا على الحافة اليمنى، من الأعلى إلى الأسفل."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "bottom-right",
        "pathD": "M 82.23 75 L 82.23 107.23 C 82.23 119.44 91.11 125 101.11 125 C 111.11 125 117.77 119.44 117.77 107.23",
        "startXY": [
          82.23,
          75
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet bas-droite : descends puis arrondis à droite",
          "en": "Bottom-right hook: go down then curve to the right",
          "es": "Gancho abajo-derecha: baja y luego curva hacia la derecha",
          "ar": "خطاف أسفل اليمين: انزل ثم انحنِ نحو اليمين"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 117.77 75 L 117.77 125",
        "startXY": [
          117.77,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical accolé à droite, du haut vers le bas",
          "en": "Vertical line on the right edge, from top to bottom",
          "es": "Trazo vertical pegado a la derecha, de arriba hacia abajo",
          "ar": "خط عمودي ملاصق لليمين، من الأعلى إلى الأسفل"
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
      "es": "b minúscula",
      "ar": "الحرف b الصغير"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre B se forme en deux gestes. D'abord, trace un trait vertical qui monte en zone haute. Ensuite, ajoute une courbe ronde accolée en bas à droite du trait.",
      "en": "The letter B is formed in two gestures. First, trace a vertical line rising into the ascender zone. Then, add a round curve attached to the lower right of the line.",
      "es": "La letra B se forma en dos gestos. Primero, traza un trazo vertical que sube a la zona alta. Luego, añade una curva redonda pegada abajo a la derecha del trazo.",
      "ar": "يتكون الحرف B من حركتين. أولاً، ارسم خطًا عموديًا يصعد إلى المنطقة العليا. ثم أضف منحنى مستديرًا ملاصقًا أسفل يمين الخط."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 57.15 15 L 57.15 124.37",
        "startXY": [
          57.15,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, monte en zone haute",
          "en": "Vertical line, rising into the ascender zone",
          "es": "Trazo vertical, sube a la zona alta",
          "ar": "خط عمودي، يصعد إلى المنطقة العليا"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 57.15 82.21 A 24.66 24.66 0 1 1 57.15 117.1",
        "startXY": [
          57.15,
          82.21
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde accolée en bas à droite du trait",
          "en": "Round curve attached to the lower right of the line",
          "es": "Curva redonda pegada abajo a la derecha del trazo",
          "ar": "منحنى مستدير ملاصق أسفل يمين الخط"
        }
      }
    ]
  },
  {
    "char": "c",
    "name": {
      "fr": "c minuscule",
      "en": "lowercase c",
      "es": "c minúscula",
      "ar": "الحرف c الصغير"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre C est une courbe ronde, presque fermée, ouverte seulement à droite. Trace-la en un seul geste, en partant du haut.",
      "en": "The letter C is a round curve, almost closed, open only on the right. Trace it in a single motion, starting from the top.",
      "es": "La letra C es una curva redonda, casi cerrada, abierta solo a la derecha. Trázala en un solo gesto, empezando desde arriba.",
      "ar": "الحرف C منحنى مستدير، شبه مغلق، مفتوح فقط من اليمين. ارسمه بحركة واحدة، بدءًا من الأعلى."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 115.23 84.23 C 108.57 76.03 97.44 72.9 87.43 76.44 C 77.43 79.99 70.77 89.43 70.77 100 C 70.77 110.57 77.43 120.01 87.43 123.56 C 97.44 127.1 108.57 123.97 115.23 115.77",
        "startXY": [
          115.23,
          84.23
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde ouverte à droite, un seul geste",
          "en": "Round curve open on the right, single motion",
          "es": "Curva redonda abierta a la derecha, un solo gesto",
          "ar": "منحنى مستدير مفتوح من اليمين، بحركة واحدة"
        }
      }
    ]
  },
  {
    "char": "d",
    "name": {
      "fr": "d minuscule",
      "en": "lowercase d",
      "es": "d minúscula",
      "ar": "الحرف d الصغير"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre D se forme en deux gestes. D'abord, trace une courbe ronde ouverte à droite. Ensuite, ajoute un trait vertical sur le bord droit, qui monte cette fois en zone haute.",
      "en": "The letter D is formed in two gestures. First, trace a round curve open on the right. Then, add a vertical line on the right edge, this time rising into the ascender zone.",
      "es": "La letra D se forma en dos gestos. Primero, traza una curva redonda abierta a la derecha. Luego, añade un trazo vertical en el borde derecho, esta vez subiendo a la zona alta.",
      "ar": "يتكون الحرف D من حركتين. أولاً، ارسم منحنى مستديرًا مفتوحًا من اليمين. ثم أضف خطًا عموديًا على الحافة اليمنى، يصعد هذه المرة إلى المنطقة العليا."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 112.77 82.21 A 24.66 24.66 0 1 0 112.77 117.1",
        "startXY": [
          112.77,
          82.21
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde ouverte à droite",
          "en": "Round curve open on the right",
          "es": "Curva redonda abierta a la derecha",
          "ar": "منحنى مستدير مفتوح من اليمين"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 112.77 15 L 112.77 125",
        "startXY": [
          112.77,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical à droite, prolongé vers le haut",
          "en": "Vertical line on the right, extended upward",
          "es": "Trazo vertical a la derecha, prolongado hacia arriba",
          "ar": "خط عمودي إلى اليمين، ممتد نحو الأعلى"
        }
      }
    ]
  },
  {
    "char": "f",
    "name": {
      "fr": "f minuscule",
      "en": "lowercase f",
      "es": "f minúscula",
      "ar": "الحرف f الصغير"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre F se forme en deux gestes. D'abord, trace un grand trait qui monte en zone haute et se termine par un petit crochet arrondi vers la droite en haut. Ensuite, ajoute un trait horizontal qui traverse le trait vertical.",
      "en": "The letter F is formed in two gestures. First, trace a tall line rising into the ascender zone, finishing with a small rounded hook to the right at the top. Then, add a horizontal line crossing the vertical line.",
      "es": "La letra F se forma en dos gestos. Primero, traza un trazo alto que sube a la zona alta y termina con un pequeño gancho redondeado hacia la derecha arriba. Luego, añade un trazo horizontal que cruza el trazo vertical.",
      "ar": "يتكون الحرف F من حركتين. أولاً، ارسم خطًا طويلًا يصعد إلى المنطقة العليا وينتهي بخطاف صغير منحنٍ نحو اليمين في الأعلى. ثم أضف خطًا أفقيًا يقطع الخط العمودي."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "top-right",
        "pathD": "M 111.7 30.72 C 111.7 22.08 104.63 15 95.99 15 C 87.34 15 80.27 22.08 80.27 30.72 L 80.27 125",
        "startXY": [
          111.7,
          30.72
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trait qui monte et s'arrondit vers la droite en haut",
          "en": "Line rising and curving right at the top",
          "es": "Trazo que sube y se curva hacia la derecha arriba",
          "ar": "خط يصعد وينحني نحو اليمين في الأعلى"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 66.3 75 L 97.73 75",
        "startXY": [
          66.3,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal qui coupe le crochet",
          "en": "Horizontal line cutting across the hook",
          "es": "Trazo horizontal que cruza el gancho",
          "ar": "خط أفقي يقطع الخطاف"
        }
      }
    ]
  },
  {
    "char": "g",
    "name": {
      "fr": "g minuscule",
      "en": "lowercase g",
      "es": "g minúscula",
      "ar": "الحرف g الصغير"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre G se forme en deux gestes. D'abord, trace une courbe ronde ouverte à droite. Ensuite, ajoute un crochet qui descend en zone basse et s'arrondit vers la gauche.",
      "en": "The letter G is formed in two gestures. First, trace a round curve open on the right. Then, add a hook going down into the descender zone, curving to the left.",
      "es": "La letra G se forma en dos gestos. Primero, traza una curva redonda abierta a la derecha. Luego, añade un gancho que baja a la zona baja y se curva hacia la izquierda.",
      "ar": "يتكون الحرف G من حركتين. أولاً، ارسم منحنى مستديرًا مفتوحًا من اليمين. ثم أضف خطافًا ينزل إلى المنطقة السفلية وينحني نحو اليسار."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 106.58 82.29 A 25.97 25.97 0 1 0 106.58 119.64",
        "startXY": [
          106.58,
          82.29
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde ouverte à droite",
          "en": "Round curve open on the right",
          "es": "Curva redonda abierta a la derecha",
          "ar": "منحنى مستدير مفتوح من اليمين"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 107.19 81.2 L 107.19 161.68 A 23.38 23.38 0 0 1 64.69 175.08",
        "startXY": [
          107.19,
          81.2
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trait qui descend en zone basse et s'arrondit à gauche",
          "en": "Line going down into the descender zone, curving left",
          "es": "Trazo que baja a la zona baja y se curva hacia la izquierda",
          "ar": "خط ينزل إلى المنطقة السفلية وينحني نحو اليسار"
        }
      }
    ]
  },
  {
    "char": "h",
    "name": {
      "fr": "h minuscule",
      "en": "lowercase h",
      "es": "h minúscula",
      "ar": "الحرف h الصغير"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre H se forme en deux gestes. D'abord, trace un trait vertical qui monte en zone haute. Ensuite, ajoute un crochet qui part du trait, s'arrondit vers le haut puis redescend jusqu'à la ligne.",
      "en": "The letter H is formed in two gestures. First, trace a vertical line rising into the ascender zone. Then, add a hook starting from the line, arching up and coming back down to the baseline.",
      "es": "La letra H se forma en dos gestos. Primero, traza un trazo vertical que sube a la zona alta. Luego, añade un gancho que parte del trazo, se curva hacia arriba y vuelve a bajar hasta la línea.",
      "ar": "يتكون الحرف H من حركتين. أولاً، ارسم خطًا عموديًا يصعد إلى المنطقة العليا. ثم أضف خطافًا ينطلق من الخط، ينحني نحو الأعلى ثم ينزل مجددًا حتى السطر."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 72.25 15 L 72.25 125",
        "startXY": [
          72.25,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, monte en zone haute",
          "en": "Vertical line, rising into the ascender zone",
          "es": "Trazo vertical, sube a la zona alta",
          "ar": "خط عمودي، يصعد إلى المنطقة العليا"
        }
      },
      {
        "family": "crochet",
        "variant": "top-left",
        "pathD": "M 72.25 83.75 A 13.75 13.75 0 0 1 99.75 83.75 L 99.75 125",
        "startXY": [
          72.25,
          83.75
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet accolé en bas à droite du trait",
          "en": "Hook attached to the lower right of the line",
          "es": "Gancho pegado abajo a la derecha del trazo",
          "ar": "خطاف ملاصق أسفل يمين الخط"
        }
      }
    ]
  },
  {
    "char": "j",
    "name": {
      "fr": "j minuscule",
      "en": "lowercase j",
      "es": "j minúscula",
      "ar": "الحرف j الصغير"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre J se forme en deux gestes. D'abord, trace un trait qui descend en zone basse et s'arrondit vers la gauche. Ensuite, pose un point rond au-dessus, sans le toucher.",
      "en": "The letter J is formed in two gestures. First, trace a line going down into the descender zone, curving to the left. Then, place a round dot above, without touching it.",
      "es": "La letra J se forma en dos gestos. Primero, traza un trazo que baja a la zona baja y se curva hacia la izquierda. Luego, coloca un punto redondo encima, sin tocarlo.",
      "ar": "يتكون الحرف J من حركتين. أولاً، ارسم خطًا ينزل إلى المنطقة السفلية وينحني نحو اليسار. ثم ضع نقطة مستديرة فوقه، دون لمسها."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 115.54 75 L 115.54 165.19 A 20.34 20.34 0 0 1 74.86 165.19",
        "startXY": [
          115.54,
          75
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trait qui descend en zone basse et s'arrondit à gauche",
          "en": "Line going down into the descender zone, curving left",
          "es": "Trazo que baja a la zona baja y se curva hacia la izquierda",
          "ar": "خط ينزل إلى المنطقة السفلية وينحني نحو اليسار"
        }
      },
      {
        "family": "point",
        "variant": "center",
        "pathD": "M 112.22 57 A 3.31 3.31 0 1 0 112.29 57",
        "startXY": [
          112.22,
          57
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Point au-dessus, sans toucher le crochet",
          "en": "Dot above, without touching the hook",
          "es": "Punto encima, sin tocar el gancho",
          "ar": "نقطة في الأعلى، دون لمس الخطاف"
        }
      }
    ]
  },
  {
    "char": "k",
    "name": {
      "fr": "k minuscule",
      "en": "lowercase k",
      "es": "k minúscula",
      "ar": "الحرف k الصغير"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre K se forme en trois gestes. D'abord, trace un trait vertical qui monte en zone haute. Ensuite, trace un premier trait oblique du milieu vers le haut-droite. Enfin, trace un second trait oblique du milieu vers le bas-droite.",
      "en": "The letter K is formed in three gestures. First, trace a vertical line rising into the ascender zone. Then, trace a diagonal line from the middle toward the upper right. Finally, trace a second diagonal line from the middle toward the lower right.",
      "es": "La letra K se forma en tres gestos. Primero, traza un trazo vertical que sube a la zona alta. Luego, traza un primer trazo oblicuo desde el medio hacia arriba a la derecha. Por último, traza un segundo trazo oblicuo desde el medio hacia abajo a la derecha.",
      "ar": "يتكون الحرف K من ثلاث حركات. أولاً، ارسم خطًا عموديًا يصعد إلى المنطقة العليا. ثم ارسم خطًا مائلًا أول من المنتصف نحو أعلى اليمين. وأخيرًا، ارسم خطًا مائلًا ثانيًا من المنتصف نحو أسفل اليمين."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 69.67 15 L 69.67 125",
        "startXY": [
          69.67,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, monte en zone haute",
          "en": "Vertical line, rising into the ascender zone",
          "es": "Trazo vertical, sube a la zona alta",
          "ar": "خط عمودي، يصعد إلى المنطقة العليا"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 125.9 75 L 69.67 100",
        "startXY": [
          125.9,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique du milieu du trait vers le haut-droite",
          "en": "Diagonal from the middle of the line toward the upper right",
          "es": "Oblicuo desde el medio del trazo hacia arriba a la derecha",
          "ar": "مائل من منتصف الخط نحو أعلى اليمين"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 69.67 100 L 125.9 125",
        "startXY": [
          69.67,
          100
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique du milieu du trait vers le bas-droite",
          "en": "Diagonal from the middle of the line toward the lower right",
          "es": "Oblicuo desde el medio del trazo hacia abajo a la derecha",
          "ar": "مائل من منتصف الخط نحو أسفل اليمين"
        }
      }
    ]
  },
  {
    "char": "l",
    "name": {
      "fr": "l minuscule",
      "en": "lowercase l",
      "es": "l minúscula",
      "ar": "الحرف l الصغير"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre L est un simple trait vertical qui monte en zone haute. Trace-le d'un seul geste, du haut vers le bas.",
      "en": "The letter L is a simple vertical line rising into the ascender zone. Trace it in a single motion, from top to bottom.",
      "es": "La letra L es un simple trazo vertical que sube a la zona alta. Trázalo en un solo gesto, de arriba hacia abajo.",
      "ar": "الحرف L هو خط عمودي بسيط يصعد إلى المنطقة العليا. ارسمه بحركة واحدة، من الأعلى إلى الأسفل."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 97 15 L 97 125",
        "startXY": [
          97,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, du haut vers le bas",
          "en": "Vertical line, from top to bottom",
          "es": "Trazo vertical, de arriba hacia abajo",
          "ar": "خط عمودي، من الأعلى إلى الأسفل"
        }
      }
    ]
  },
  {
    "char": "m",
    "name": {
      "fr": "m minuscule",
      "en": "lowercase m",
      "es": "m minúscula",
      "ar": "الحرف m الصغير"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre M se forme en trois gestes. D'abord, trace un trait vertical court. Ensuite, ajoute un premier crochet qui s'arrondit vers le haut, accolé au trait. Enfin, ajoute un second crochet identique, juste à côté.",
      "en": "The letter M is formed in three gestures. First, trace a short vertical line. Then, add a first hook arching upward, attached to the line. Finally, add a second matching hook right next to it.",
      "es": "La letra M se forma en tres gestos. Primero, traza un trazo vertical corto. Luego, añade un primer gancho que se curva hacia arriba, pegado al trazo. Por último, añade un segundo gancho idéntico, justo al lado.",
      "ar": "يتكون الحرف M من ثلاث حركات. أولاً، ارسم خطًا عموديًا قصيرًا. ثم أضف خطافًا أول ينحني نحو الأعلى، ملاصقًا للخط. وأخيرًا، أضف خطافًا ثانيًا مطابقًا، بجانبه مباشرة."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 82.23 75 L 82.23 125",
        "startXY": [
          82.23,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical court",
          "en": "Short vertical line",
          "es": "Trazo vertical corto",
          "ar": "خط عمودي قصير"
        }
      },
      {
        "family": "crochet",
        "variant": "top-right",
        "pathD": "M 82.23 92.77 C 82.23 80.56 88.89 75 98.89 75 C 108.89 75 117.77 80.56 117.77 92.77 L 117.77 125",
        "startXY": [
          82.23,
          92.77
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Premier crochet qui s'arrondit vers le haut, accolé au trait",
          "en": "First hook arching upward, attached to the line",
          "es": "Primer gancho que se curva hacia arriba, pegado al trazo",
          "ar": "الخطاف الأول ينحني نحو الأعلى، ملاصقًا للخط"
        }
      },
      {
        "family": "crochet",
        "variant": "top-right",
        "pathD": "M 117.77 92.77 C 117.77 80.56 124.43 75 134.43 75 C 144.43 75 153.31 80.56 153.31 92.77 L 153.31 125",
        "startXY": [
          117.77,
          92.77
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Second crochet, identique au premier",
          "en": "Second hook, matching the first",
          "es": "Segundo gancho, idéntico al primero",
          "ar": "الخطاف الثاني، مطابق للأول"
        }
      }
    ]
  },
  {
    "char": "n",
    "name": {
      "fr": "n minuscule",
      "en": "lowercase n",
      "es": "n minúscula",
      "ar": "الحرف n الصغير"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre N se forme en deux gestes. D'abord, trace un trait vertical court. Ensuite, ajoute un crochet qui s'arrondit vers le haut puis redescend jusqu'à la ligne.",
      "en": "The letter N is formed in two gestures. First, trace a short vertical line. Then, add a hook arching upward and coming back down to the baseline.",
      "es": "La letra N se forma en dos gestos. Primero, traza un trazo vertical corto. Luego, añade un gancho que se curva hacia arriba y vuelve a bajar hasta la línea.",
      "ar": "يتكون الحرف N من حركتين. أولاً، ارسم خطًا عموديًا قصيرًا. ثم أضف خطافًا ينحني نحو الأعلى ثم ينزل مجددًا حتى السطر."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 82.23 75 L 82.23 125",
        "startXY": [
          82.23,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical court",
          "en": "Short vertical line",
          "es": "Trazo vertical corto",
          "ar": "خط عمودي قصير"
        }
      },
      {
        "family": "crochet",
        "variant": "top-right",
        "pathD": "M 82.23 92.77 C 82.23 80.56 88.89 75 98.89 75 C 108.89 75 117.77 80.56 117.77 92.77 L 117.77 125",
        "startXY": [
          82.23,
          92.77
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet accolé à droite du trait",
          "en": "Hook attached to the right of the line",
          "es": "Gancho pegado a la derecha del trazo",
          "ar": "خطاف ملاصق يمين الخط"
        }
      }
    ]
  },
  {
    "char": "ñ",
    "name": {
      "fr": "n espagnol (eñe) minuscule",
      "en": "lowercase spanish ñ",
      "es": "eñe minúscula",
      "ar": "الحرف الإسباني ñ الصغير"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre ñ se forme comme un n, puis on ajoute un petit tilde ondulé au-dessus.",
      "en": "The letter ñ is formed like an n, then a small wavy tilde is added above it.",
      "es": "La letra ñ se forma como una n, y luego se añade una pequeña virgulilla ondulada encima.",
      "ar": "يتكون الحرف ñ مثل الحرف n، ثم تُضاف فوقه علامة تلدة صغيرة متموجة."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 87.31 96.44 L 87.31 125",
        "startXY": [
          87.31,
          96.44
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical court",
          "en": "Short vertical line",
          "es": "Trazo vertical corto",
          "ar": "خط عمودي قصير"
        }
      },
      {
        "family": "crochet",
        "variant": "top-left",
        "pathD": "M 87.31 96.44 C 87.31 89.41 92.97 83.74 100 83.74 C 107.03 83.74 112.69 89.41 112.69 96.44 L 112.69 125",
        "startXY": [
          87.31,
          96.44
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet accolé à droite du trait",
          "en": "Hook attached to the right of the line",
          "es": "Gancho pegado a la derecha del trazo",
          "ar": "خطاف ملاصق يمين الخط"
        }
      },
      {
        "family": "courbe",
        "variant": "tilde",
        "pathD": "M 91.67 77.8 C 94.04 74.21 97.23 74.21 100 77 C 102.77 79.77 105.96 79.77 108.33 76.2",
        "startXY": [
          91.67,
          77.8
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Petit tilde ondulé au-dessus du n",
          "en": "Small wavy tilde above the n",
          "es": "Pequeña virgulilla ondulada encima de la n",
          "ar": "علامة تلدة صغيرة متموجة فوق الحرف n"
        }
      }
    ]
  },
  {
    "char": "p",
    "name": {
      "fr": "p minuscule",
      "en": "lowercase p",
      "es": "p minúscula",
      "ar": "الحرف p الصغير"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre P se forme en deux gestes. D'abord, trace un trait vertical qui descend en zone basse. Ensuite, ajoute une courbe ronde accolée en haut à droite du trait.",
      "en": "The letter P is formed in two gestures. First, trace a vertical line going down into the descender zone. Then, add a round curve attached to the upper right of the line.",
      "es": "La letra P se forma en dos gestos. Primero, traza un trazo vertical que baja a la zona baja. Luego, añade una curva redonda pegada arriba a la derecha del trazo.",
      "ar": "يتكون الحرف P من حركتين. أولاً، ارسم خطًا عموديًا ينزل إلى المنطقة السفلية. ثم أضف منحنى مستديرًا ملاصقًا أعلى يمين الخط."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 57.22 80.43 L 57.22 185",
        "startXY": [
          57.22,
          80.43
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, descend en zone basse",
          "en": "Vertical line, going down into the descender zone",
          "es": "Trazo vertical, baja a la zona baja",
          "ar": "خط عمودي، ينزل إلى المنطقة السفلية"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 57.15 82.21 A 24.66 24.66 0 1 1 57.15 117.1",
        "startXY": [
          57.15,
          82.21
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde accolée en haut à droite du trait",
          "en": "Round curve attached to the upper right of the line",
          "es": "Curva redonda pegada arriba a la derecha del trazo",
          "ar": "منحنى مستدير ملاصق أعلى يمين الخط"
        }
      }
    ]
  },
  {
    "char": "q",
    "name": {
      "fr": "q minuscule",
      "en": "lowercase q",
      "es": "q minúscula",
      "ar": "الحرف q الصغير"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre Q se forme en deux gestes. D'abord, trace une courbe ronde ouverte à droite. Ensuite, ajoute un trait vertical sur le bord droit, qui descend cette fois en zone basse.",
      "en": "The letter Q is formed in two gestures. First, trace a round curve open on the right. Then, add a vertical line on the right edge, this time going down into the descender zone.",
      "es": "La letra Q se forma en dos gestos. Primero, traza una curva redonda abierta a la derecha. Luego, añade un trazo vertical en el borde derecho, esta vez bajando a la zona baja.",
      "ar": "يتكون الحرف Q من حركتين. أولاً، ارسم منحنى مستديرًا مفتوحًا من اليمين. ثم أضف خطًا عموديًا على الحافة اليمنى، ينزل هذه المرة إلى المنطقة السفلية."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 112.77 82.21 A 24.66 24.66 0 1 0 112.77 117.1",
        "startXY": [
          112.77,
          82.21
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe ronde ouverte à droite",
          "en": "Round curve open on the right",
          "es": "Curva redonda abierta a la derecha",
          "ar": "منحنى مستدير مفتوح من اليمين"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 112.77 75 L 112.77 185",
        "startXY": [
          112.77,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical à droite, prolongé vers le bas",
          "en": "Vertical line on the right, extended downward",
          "es": "Trazo vertical a la derecha, prolongado hacia abajo",
          "ar": "خط عمودي إلى اليمين، ممتد نحو الأسفل"
        }
      }
    ]
  },
  {
    "char": "r",
    "name": {
      "fr": "r minuscule",
      "en": "lowercase r",
      "es": "r minúscula",
      "ar": "الحرف r الصغير"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre R se forme en deux gestes. D'abord, trace un trait vertical court. Ensuite, ajoute un petit crochet en haut à droite, qui ne descend pas jusqu'à la ligne.",
      "en": "The letter R is formed in two gestures. First, trace a short vertical line. Then, add a small hook at the upper right, which doesn't reach the baseline.",
      "es": "La letra R se forma en dos gestos. Primero, traza un trazo vertical corto. Luego, añade un pequeño gancho arriba a la derecha, que no llega hasta la línea.",
      "ar": "يتكون الحرف R من حركتين. أولاً، ارسم خطًا عموديًا قصيرًا. ثم أضف خطافًا صغيرًا أعلى اليمين، لا ينزل حتى السطر."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 74.98 75 L 74.98 125",
        "startXY": [
          74.98,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical court",
          "en": "Short vertical line",
          "es": "Trazo vertical corto",
          "ar": "خط عمودي قصير"
        }
      },
      {
        "family": "crochet",
        "variant": "top-right",
        "pathD": "M 74.98 85.43 C 74.98 80.43 79 76.39 84 76.39 C 89 76.39 93.03 80.43 93.03 85.43",
        "startXY": [
          74.98,
          85.43
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Petit crochet en haut à droite du trait",
          "en": "Small hook at the upper right of the line",
          "es": "Pequeño gancho arriba a la derecha del trazo",
          "ar": "خطاف صغير أعلى يمين الخط"
        }
      }
    ]
  },
  {
    "char": "s",
    "name": {
      "fr": "s minuscule",
      "en": "lowercase s",
      "es": "s minúscula",
      "ar": "الحرف s الصغير"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre S se forme en deux gestes enchaînés. D'abord, un petit crochet en haut qui s'arrondit vers la droite. Ensuite, sans lever le crayon, un second petit crochet en bas qui s'arrondit vers la gauche.",
      "en": "The letter S is formed in two linked gestures. First, a small hook at the top curving to the right. Then, without lifting the pencil, a second small hook at the bottom curving to the left.",
      "es": "La letra S se forma en dos gestos encadenados. Primero, un pequeño gancho arriba que se curva hacia la derecha. Luego, sin levantar el lápiz, un segundo pequeño gancho abajo que se curva hacia la izquierda.",
      "ar": "يتكون الحرف S من حركتين متتاليتين. أولاً، خطاف صغير في الأعلى ينحني نحو اليمين. ثم، دون رفع القلم، خطاف صغير ثانٍ في الأسفل ينحني نحو اليسار."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "top-right",
        "pathD": "M 108.76 83.24 C 106.6 77.27 100.3 73.87 94.1 75.34 C 87.97 76.81 83.87 82.67 84.56 88.97 C 85.3 95.23 90.64 100 97 100",
        "startXY": [
          108.76,
          83.24
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Petit crochet, s'arrondit vers la droite en haut",
          "en": "Small hook, curving right at the top",
          "es": "Pequeño gancho, se curva hacia la derecha arriba",
          "ar": "خطاف صغير، ينحني نحو اليمين في الأعلى"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 97 100 C 103.36 100 108.7 104.77 109.44 111.03 C 110.13 117.33 106.03 123.19 99.9 124.66 C 93.71 126.13 87.4 122.73 85.24 116.76",
        "startXY": [
          97,
          100
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Petit crochet, s'arrondit vers la gauche en bas",
          "en": "Small hook, curving left at the bottom",
          "es": "Pequeño gancho, se curva hacia la izquierda abajo",
          "ar": "خطاف صغير، ينحني نحو اليسار في الأسفل"
        }
      }
    ]
  },
  {
    "char": "t",
    "name": {
      "fr": "t minuscule",
      "en": "lowercase t",
      "es": "t minúscula",
      "ar": "الحرف t الصغير"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre T se forme en deux gestes. D'abord, trace un trait vertical qui monte en zone haute. Ensuite, ajoute un trait horizontal qui le traverse, plus haut que pour le F.",
      "en": "The letter T is formed in two gestures. First, trace a vertical line rising into the ascender zone. Then, add a horizontal line crossing it, higher than for the F.",
      "es": "La letra T se forma en dos gestos. Primero, traza un trazo vertical que sube a la zona alta. Luego, añade un trazo horizontal que lo cruza, más arriba que en la F.",
      "ar": "يتكون الحرف T من حركتين. أولاً، ارسم خطًا عموديًا يصعد إلى المنطقة العليا. ثم أضف خطًا أفقيًا يقطعه، أعلى مما هو عليه في حرف F."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 97 15 L 97 125",
        "startXY": [
          97,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, monte en zone haute",
          "en": "Vertical line, rising into the ascender zone",
          "es": "Trazo vertical, sube a la zona alta",
          "ar": "خط عمودي، يصعد إلى المنطقة العليا"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 78.96 36.64 L 115.04 36.64",
        "startXY": [
          78.96,
          36.64
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal qui traverse, en haut de la zone haute",
          "en": "Horizontal line crossing, high in the ascender zone",
          "es": "Trazo horizontal que cruza, arriba en la zona alta",
          "ar": "خط أفقي يقطع، في أعلى المنطقة العليا"
        }
      }
    ]
  },
  {
    "char": "v",
    "name": {
      "fr": "v minuscule",
      "en": "lowercase v",
      "es": "v minúscula",
      "ar": "الحرف v الصغير"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre V se forme en deux gestes. D'abord, un trait oblique qui descend du haut-gauche vers le centre-bas. Ensuite, un trait oblique qui remonte du centre-bas vers le haut-droite.",
      "en": "The letter V is formed in two gestures. First, a diagonal line going down from the upper left to the center-bottom. Then, a diagonal line going up from the center-bottom to the upper right.",
      "es": "La letra V se forma en dos gestos. Primero, un trazo oblicuo que baja desde arriba a la izquierda hacia el centro abajo. Luego, un trazo oblicuo que sube desde el centro abajo hacia arriba a la derecha.",
      "ar": "يتكون الحرف V من حركتين. أولاً، خط مائل ينزل من أعلى اليسار نحو منتصف الأسفل. ثم خط مائل يصعد من منتصف الأسفل نحو أعلى اليمين."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 74.77 75 L 97 125",
        "startXY": [
          74.77,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique descendante, haut-gauche vers centre-bas",
          "en": "Diagonal going down, upper left to center-bottom",
          "es": "Oblicuo descendente, de arriba a la izquierda al centro abajo",
          "ar": "مائل نازل، من أعلى اليسار نحو منتصف الأسفل"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 119.23 75 L 97 125",
        "startXY": [
          119.23,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique montante, centre-bas vers haut-droite",
          "en": "Diagonal going up, center-bottom to upper right",
          "es": "Oblicuo ascendente, del centro abajo hacia arriba a la derecha",
          "ar": "مائل صاعد، من منتصف الأسفل نحو أعلى اليمين"
        }
      }
    ]
  },
  {
    "char": "w",
    "name": {
      "fr": "w minuscule",
      "en": "lowercase w",
      "es": "w minúscula",
      "ar": "الحرف w الصغير"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre W se forme en quatre traits obliques qui s'enchaînent, alternant descente et montée, comme deux V collés.",
      "en": "The letter W is formed with four diagonal lines linked together, alternating down and up, like two Vs side by side.",
      "es": "La letra W se forma con cuatro trazos oblicuos encadenados, alternando bajada y subida, como dos V pegadas.",
      "ar": "يتكون الحرف W من أربعة خطوط مائلة متصلة، تتناوب بين النزول والصعود، كأنهما حرفا V متلاصقان."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 69.23 75 L 83.11 125",
        "startXY": [
          69.23,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Première oblique descendante",
          "en": "First diagonal going down",
          "es": "Primer oblicuo descendente",
          "ar": "المائل الأول النازل"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 97 75 L 83.11 125",
        "startXY": [
          97,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Deuxième oblique montante",
          "en": "Second diagonal going up",
          "es": "Segundo oblicuo ascendente",
          "ar": "المائل الثاني الصاعد"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 97 75 L 110.89 125",
        "startXY": [
          97,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Troisième oblique descendante",
          "en": "Third diagonal going down",
          "es": "Tercer oblicuo descendente",
          "ar": "المائل الثالث النازل"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 124.77 75 L 110.89 125",
        "startXY": [
          124.77,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Quatrième oblique montante",
          "en": "Fourth diagonal going up",
          "es": "Cuarto oblicuo ascendente",
          "ar": "المائل الرابع الصاعد"
        }
      }
    ]
  },
  {
    "char": "x",
    "name": {
      "fr": "x minuscule",
      "en": "lowercase x",
      "es": "x minúscula",
      "ar": "الحرف x الصغير"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre X se forme en deux traits obliques qui se croisent au centre. D'abord du haut-gauche vers le bas-droite, puis du haut-droite vers le bas-gauche.",
      "en": "The letter X is formed with two diagonal lines crossing at the center. First from the upper left to the lower right, then from the upper right to the lower left.",
      "es": "La letra X se forma con dos trazos oblicuos que se cruzan en el centro. Primero de arriba a la izquierda hacia abajo a la derecha, luego de arriba a la derecha hacia abajo a la izquierda.",
      "ar": "يتكون الحرف X من خطين مائلين يتقاطعان في المنتصف. أولاً من أعلى اليسار نحو أسفل اليمين، ثم من أعلى اليمين نحو أسفل اليسار."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 74.77 75 L 119.23 125",
        "startXY": [
          74.77,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique haut-gauche vers bas-droite",
          "en": "Diagonal upper left to lower right",
          "es": "Oblicuo de arriba a la izquierda hacia abajo a la derecha",
          "ar": "مائل من أعلى اليسار نحو أسفل اليمين"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 119.23 75 L 74.77 125",
        "startXY": [
          119.23,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique haut-droite vers bas-gauche",
          "en": "Diagonal upper right to lower left",
          "es": "Oblicuo de arriba a la derecha hacia abajo a la izquierda",
          "ar": "مائل من أعلى اليمين نحو أسفل اليسار"
        }
      }
    ]
  },
  {
    "char": "y",
    "name": {
      "fr": "y minuscule",
      "en": "lowercase y",
      "es": "y minúscula",
      "ar": "الحرف y الصغير"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "La lettre Y se forme en deux gestes. D'abord, une diagonale du haut-gauche qui descend jusqu'au point de croisement sur la ligne de base. Ensuite, une diagonale du haut-droite qui passe par le même point, puis continue en zone basse et se termine par un petit crochet vers la gauche.",
      "en": "The letter Y is formed in two gestures. First, a diagonal from the upper left descending to the crossing point on the baseline. Then, a diagonal from the upper right passing through the same point, continuing into the descender zone and ending with a small hook to the left.",
      "es": "La letra Y se forma en dos gestos. Primero, una diagonal desde arriba a la izquierda que baja hasta el punto de cruce en la línea de base. Luego, una diagonal desde arriba a la derecha que pasa por el mismo punto, continúa en la zona baja y termina con un pequeño gancho hacia la izquierda.",
      "ar": "يتكون الحرف Y من حركتين. أولاً، قطر من أعلى اليسار ينزل حتى نقطة التقاطع على خط الأساس. ثم قطر من أعلى اليمين يمر بالنقطة نفسها، ويتابع في المنطقة السفلية لينتهي بخطاف صغير نحو اليسار."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 74.78 75 L 97 125",
        "startXY": [
          74.78,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Diagonale du haut-gauche vers le point de croisement sur la ligne de base",
          "en": "Diagonal from upper left to the crossing point on the baseline",
          "es": "Diagonal desde arriba a la izquierda hasta el punto de cruce en la línea de base",
          "ar": "قطر من أعلى اليسار نحو نقطة التقاطع على خط الأساس"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 119.22 75 L 97 125 L 87.28 150",
        "startXY": [
          119.22,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Diagonale du haut-droite, croise, descend en zone basse",
          "en": "Diagonal from upper right, crosses, descends into the descender zone",
          "es": "Diagonal desde arriba a la derecha, cruza, baja a la zona baja",
          "ar": "قطر من أعلى اليمين، يتقاطع، وينزل إلى المنطقة السفلية"
        }
      }
    ]
  },
  {
    "char": "z",
    "name": {
      "fr": "z minuscule",
      "en": "lowercase z",
      "es": "z minúscula",
      "ar": "الحرف z الصغير"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "La lettre Z se forme en trois gestes enchaînés sans lever le crayon : un trait horizontal en haut, un trait oblique vers le bas-gauche, puis un trait horizontal en bas.",
      "en": "The letter Z is formed in three linked gestures without lifting the pencil: a horizontal line at the top, a diagonal going to the lower left, then a horizontal line at the bottom.",
      "es": "La letra Z se forma en tres gestos encadenados sin levantar el lápiz: un trazo horizontal arriba, un trazo oblicuo hacia abajo a la izquierda, luego un trazo horizontal abajo.",
      "ar": "يتكون الحرف Z من ثلاث حركات متتالية دون رفع القلم: خط أفقي في الأعلى، خط مائل نحو أسفل اليسار، ثم خط أفقي في الأسفل."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 73.39 75 L 120.61 75",
        "startXY": [
          73.39,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en haut",
          "en": "Horizontal line at the top",
          "es": "Trazo horizontal arriba",
          "ar": "خط أفقي في الأعلى"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 120.61 75 L 73.39 125",
        "startXY": [
          120.61,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique vers le bas-gauche",
          "en": "Diagonal toward the lower left",
          "es": "Oblicuo hacia abajo a la izquierda",
          "ar": "مائل نحو أسفل اليسار"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 73.39 125 L 120.61 125",
        "startXY": [
          73.39,
          125
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en bas",
          "en": "Horizontal line at the bottom",
          "es": "Trazo horizontal abajo",
          "ar": "خط أفقي في الأسفل"
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
      "es": "A mayúscula",
      "ar": "الحرف A الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre A se forme en trois gestes. D'abord une oblique du sommet vers le bas-gauche, puis une oblique du sommet vers le bas-droite, enfin une barre horizontale qui relie les deux obliques à mi-hauteur.",
      "en": "The letter A is formed in three gestures. First a diagonal from the top to the lower left, then a diagonal from the top to the lower right, finally a horizontal bar linking the two diagonals at mid-height.",
      "es": "La letra A se forma en tres gestos. Primero un oblicuo desde arriba hacia abajo a la izquierda, luego un oblicuo desde arriba hacia abajo a la derecha, y por último una barra horizontal que une los dos oblicuos a media altura.",
      "ar": "يتكون الحرف A من ثلاث حركات. أولاً خط مائل من القمة نحو أسفل اليسار، ثم خط مائل من القمة نحو أسفل اليمين، وأخيرًا خط أفقي يربط بين الخطين المائلين في منتصف الارتفاع."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 92.91 15.95 L 55.36 125",
        "startXY": [
          92.91,
          15.95
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique du sommet vers le bas-gauche",
          "en": "Diagonal from the top to the lower left",
          "es": "Oblicuo desde arriba hacia abajo a la izquierda",
          "ar": "مائل من القمة نحو أسفل اليسار"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 93.24 15 L 128.88 124.67",
        "startXY": [
          93.24,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique du sommet vers le bas-droite",
          "en": "Diagonal from the top to the lower right",
          "es": "Oblicuo desde arriba hacia abajo a la derecha",
          "ar": "مائل من القمة نحو أسفل اليمين"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 73.63 80.16 L 114 80.16",
        "startXY": [
          73.63,
          80.16
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Barre horizontale médiane",
          "en": "Horizontal middle bar",
          "es": "Barra horizontal media",
          "ar": "شريط أفقي في المنتصف"
        }
      }
    ]
  },
  {
    "char": "B",
    "name": {
      "fr": "B majuscule",
      "en": "uppercase B",
      "es": "B mayúscula",
      "ar": "الحرف B الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre B se forme en trois gestes. D'abord un trait vertical pleine hauteur. Ensuite une courbe ronde accolée en haut à droite. Enfin une seconde courbe ronde accolée en bas à droite, qui touche la première au milieu.",
      "en": "The letter B is formed in three gestures. First a full-height vertical line. Then a round curve attached to the upper right. Finally a second round curve attached to the lower right, touching the first in the middle.",
      "es": "La letra B se forma en tres gestos. Primero un trazo vertical de altura completa. Luego una curva redonda pegada arriba a la derecha. Por último una segunda curva redonda pegada abajo a la derecha, que toca la primera en el medio.",
      "ar": "يتكون الحرف B من ثلاث حركات. أولاً خط عمودي بارتفاع كامل. ثم منحنى مستدير ملاصق أعلى اليمين. وأخيرًا منحنى مستدير ثانٍ ملاصق أسفل اليمين، يلامس الأول في المنتصف."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 73.58 17.75 L 73.58 124.96",
        "startXY": [
          73.58,
          17.75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical pleine hauteur",
          "en": "Full-height vertical line",
          "es": "Trazo vertical de altura completa",
          "ar": "خط عمودي بارتفاع كامل"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 75.06 16.34 A 27.3 27.3 0 1 1 75.06 68.26",
        "startXY": [
          75.06,
          16.34
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe du haut, accolée à droite",
          "en": "Upper curve, attached on the right",
          "es": "Curva de arriba, pegada a la derecha",
          "ar": "المنحنى العلوي، ملاصق لليمين"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 75.78 71.74 A 27.3 27.3 0 1 1 75.78 123.66",
        "startXY": [
          75.78,
          71.74
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe du bas, accolée à droite",
          "en": "Lower curve, attached on the right",
          "es": "Curva de abajo, pegada a la derecha",
          "ar": "المنحنى السفلي، ملاصق لليمين"
        }
      }
    ]
  },
  {
    "char": "C",
    "name": {
      "fr": "C majuscule",
      "en": "uppercase C",
      "es": "C mayúscula",
      "ar": "الحرف C الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre C est une grande courbe ronde, presque fermée, ouverte seulement à droite. Trace-la en un seul geste depuis le haut.",
      "en": "The letter C is a large round curve, almost closed, open only on the right. Trace it in a single motion from the top.",
      "es": "La letra C es una gran curva redonda, casi cerrada, abierta solo a la derecha. Trázala en un solo gesto desde arriba.",
      "ar": "الحرف C منحنى مستدير كبير، شبه مغلق، مفتوح فقط من اليمين. ارسمه بحركة واحدة بدءًا من الأعلى."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 140.03 30.44 A 55 55 0 1 0 140.03 109.56",
        "startXY": [
          140.03,
          30.44
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Grande courbe ouverte à droite",
          "en": "Large curve open on the right",
          "es": "Gran curva abierta a la derecha",
          "ar": "منحنى كبير مفتوح من اليمين"
        }
      }
    ]
  },
  {
    "char": "D",
    "name": {
      "fr": "D majuscule",
      "en": "uppercase D",
      "es": "D mayúscula",
      "ar": "الحرف D الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre D se forme en deux gestes. D'abord un trait vertical pleine hauteur. Ensuite une grande courbe qui referme l'ouverture en haut et en bas, accolée à droite du trait.",
      "en": "The letter D is formed in two gestures. First a full-height vertical line. Then a large curve closing the opening at the top and bottom, attached to the right of the line.",
      "es": "La letra D se forma en dos gestos. Primero un trazo vertical de altura completa. Luego una gran curva que cierra la abertura arriba y abajo, pegada a la derecha del trazo.",
      "ar": "يتكون الحرف D من حركتين. أولاً خط عمودي بارتفاع كامل. ثم منحنى كبير يغلق الفتحة من الأعلى والأسفل، ملاصق يمين الخط."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 63.73 22.4 L 63.73 117.61",
        "startXY": [
          63.73,
          22.4
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical pleine hauteur",
          "en": "Full-height vertical line",
          "es": "Trazo vertical de altura completa",
          "ar": "خط عمودي بارتفاع كامل"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 63.73 22.4 C 86.84 9.04 116.28 14.15 133.34 34.64 C 150.55 55.14 150.55 84.86 133.34 105.37 C 116.28 125.86 86.84 130.95 63.73 117.61",
        "startXY": [
          63.73,
          22.4
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Grande courbe, accolée à droite du trait",
          "en": "Large curve, attached to the right of the line",
          "es": "Gran curva, pegada a la derecha del trazo",
          "ar": "منحنى كبير، ملاصق يمين الخط"
        }
      }
    ]
  },
  {
    "char": "E",
    "name": {
      "fr": "E majuscule",
      "en": "uppercase E",
      "es": "E mayúscula",
      "ar": "الحرف E الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre E se forme en quatre gestes. Un trait vertical, puis trois traits horizontaux qui partent tous du trait vers la droite : en haut, au milieu, en bas.",
      "en": "The letter E is formed in four gestures. A vertical line, then three horizontal lines all starting from the line toward the right: at the top, in the middle, at the bottom.",
      "es": "La letra E se forma en cuatro gestos. Un trazo vertical, luego tres trazos horizontales que salen todos del trazo hacia la derecha: arriba, en el medio, abajo.",
      "ar": "يتكون الحرف E من أربع حركات. خط عمودي، ثم ثلاثة خطوط أفقية تنطلق جميعها من الخط نحو اليمين: في الأعلى، في المنتصف، وفي الأسفل."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 66.77 15 L 66.77 125",
        "startXY": [
          66.77,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical",
          "en": "Vertical line",
          "es": "Trazo vertical",
          "ar": "خط عمودي"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 66.77 15 L 127.23 15",
        "startXY": [
          66.77,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Horizontale du haut",
          "en": "Top horizontal",
          "es": "Horizontal de arriba",
          "ar": "الأفقي العلوي"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 66.77 70 L 118.83 70",
        "startXY": [
          66.77,
          70
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Horizontale du milieu",
          "en": "Middle horizontal",
          "es": "Horizontal del medio",
          "ar": "الأفقي الأوسط"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 66.77 125 L 127.23 125",
        "startXY": [
          66.77,
          125
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Horizontale du bas",
          "en": "Bottom horizontal",
          "es": "Horizontal de abajo",
          "ar": "الأفقي السفلي"
        }
      }
    ]
  },
  {
    "char": "F",
    "name": {
      "fr": "F majuscule",
      "en": "uppercase F",
      "es": "F mayúscula",
      "ar": "الحرف F الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre F se forme comme le E, mais sans la barre du bas : un trait vertical, une horizontale en haut, une horizontale au milieu.",
      "en": "The letter F is formed like the E, but without the bottom bar: a vertical line, a horizontal at the top, a horizontal in the middle.",
      "es": "La letra F se forma como la E, pero sin la barra de abajo: un trazo vertical, una horizontal arriba, una horizontal en el medio.",
      "ar": "يتكون الحرف F مثل الحرف E، لكن دون الشريط السفلي: خط عمودي، أفقي في الأعلى، أفقي في المنتصف."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 66.77 15 L 66.77 125",
        "startXY": [
          66.77,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical",
          "en": "Vertical line",
          "es": "Trazo vertical",
          "ar": "خط عمودي"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 66.77 15 L 127.23 15",
        "startXY": [
          66.77,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Horizontale du haut",
          "en": "Top horizontal",
          "es": "Horizontal de arriba",
          "ar": "الأفقي العلوي"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 66.77 70 L 118.83 70",
        "startXY": [
          66.77,
          70
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Horizontale du milieu",
          "en": "Middle horizontal",
          "es": "Horizontal del medio",
          "ar": "الأفقي الأوسط"
        }
      }
    ]
  },
  {
    "char": "G",
    "name": {
      "fr": "G majuscule",
      "en": "uppercase G",
      "es": "G mayúscula",
      "ar": "الحرف G الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre G se forme en trois gestes. D'abord une grande courbe ouverte à droite. Ensuite un trait horizontal qui va de la gauche vers la droite, au niveau du centre de la courbe. Enfin, à son extrémité, un trait vertical qui descend du haut vers le bas.",
      "en": "The letter G is formed in three gestures. First a large curve open on the right. Then a horizontal line going from left to right, at the curve's center height. Finally, at its end, a vertical line going down from top to bottom.",
      "es": "La letra G se forma en tres gestos. Primero una gran curva abierta a la derecha. Luego un trazo horizontal que va de izquierda a derecha, a la altura del centro de la curva. Por último, en su extremo, un trazo vertical que baja de arriba hacia abajo.",
      "ar": "يتكون الحرف G من ثلاث حركات. أولاً منحنى كبير مفتوح من اليمين. ثم خط أفقي يمتد من اليسار إلى اليمين عند مستوى منتصف المنحنى. وأخيرًا، عند طرفه، خط عمودي ينزل من الأعلى إلى الأسفل."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-right",
        "pathD": "M 134.54 17.31 C 112.04 10.58 87.71 18.89 74.01 37.96 C 60.44 57.16 60.44 82.84 74.01 102.03 C 87.71 121.1 112.04 129.41 134.54 122.7",
        "startXY": [
          134.54,
          17.31
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Grande courbe ouverte à droite",
          "en": "Large curve open on the right",
          "es": "Gran curva abierta a la derecha",
          "ar": "منحنى كبير مفتوح من اليمين"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 101.04 70 L 134.54 70",
        "startXY": [
          101.04,
          70
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal, de gauche à droite, au centre de la courbe",
          "en": "Horizontal line, left to right, at the curve's center",
          "es": "Trazo horizontal, de izquierda a derecha, en el centro de la curva",
          "ar": "خط أفقي، من اليسار إلى اليمين، في منتصف المنحنى"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 134.54 70 L 134.54 119.63",
        "startXY": [
          134.54,
          70
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, à l'extrémité de l'horizontale, du haut vers le bas",
          "en": "Vertical line, at the end of the horizontal, top to bottom",
          "es": "Trazo vertical, en el extremo de la horizontal, de arriba hacia abajo",
          "ar": "خط عمودي، عند طرف الأفقي، من الأعلى إلى الأسفل"
        }
      }
    ]
  },
  {
    "char": "H",
    "name": {
      "fr": "H majuscule",
      "en": "uppercase H",
      "es": "H mayúscula",
      "ar": "الحرف H الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre H se forme en trois gestes. Deux traits verticaux parallèles, puis un trait horizontal qui les relie au milieu.",
      "en": "The letter H is formed in three gestures. Two parallel vertical lines, then a horizontal line linking them in the middle.",
      "es": "La letra H se forma en tres gestos. Dos trazos verticales paralelos, luego un trazo horizontal que los une en el medio.",
      "ar": "يتكون الحرف H من ثلاث حركات. خطان عموديان متوازيان، ثم خط أفقي يربط بينهما في المنتصف."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 66.77 15 L 66.77 125",
        "startXY": [
          66.77,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Premier trait vertical, à gauche",
          "en": "First vertical line, on the left",
          "es": "Primer trazo vertical, a la izquierda",
          "ar": "الخط العمودي الأول، إلى اليسار"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 127.23 15 L 127.23 125",
        "startXY": [
          127.23,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Second trait vertical, à droite",
          "en": "Second vertical line, on the right",
          "es": "Segundo trazo vertical, a la derecha",
          "ar": "الخط العمودي الثاني، إلى اليمين"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 66.77 70 L 127.23 70",
        "startXY": [
          66.77,
          70
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal, relie les deux au milieu",
          "en": "Horizontal line, links the two in the middle",
          "es": "Trazo horizontal, une los dos en el medio",
          "ar": "خط أفقي، يربط بينهما في المنتصف"
        }
      }
    ]
  },
  {
    "char": "I",
    "name": {
      "fr": "I majuscule",
      "en": "uppercase I",
      "es": "I mayúscula",
      "ar": "الحرف I الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre I se forme en trois gestes. D'abord un trait vertical pleine hauteur. Ensuite un trait horizontal en haut, puis un trait horizontal en bas.",
      "en": "The letter I is formed in three gestures. First a full-height vertical line. Then a horizontal line at the top, then a horizontal line at the bottom.",
      "es": "La letra I se forma en tres gestos. Primero un trazo vertical de altura completa. Luego un trazo horizontal arriba, y otro trazo horizontal abajo.",
      "ar": "يتكون الحرف I من ثلاث حركات. أولاً خط عمودي بارتفاع كامل. ثم خط أفقي في الأعلى، ثم خط أفقي في الأسفل."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 103 15 L 103 125",
        "startXY": [
          103,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, du haut vers le bas",
          "en": "Vertical line, from top to bottom",
          "es": "Trazo vertical, de arriba hacia abajo",
          "ar": "خط عمودي، من الأعلى إلى الأسفل"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 78 15 L 126 15",
        "startXY": [
          78,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en haut",
          "en": "Horizontal line at the top",
          "es": "Trazo horizontal arriba",
          "ar": "خط أفقي في الأعلى"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 80 125 L 128 125",
        "startXY": [
          80,
          125
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en bas",
          "en": "Horizontal line at the bottom",
          "es": "Trazo horizontal abajo",
          "ar": "خط أفقي في الأسفل"
        }
      }
    ]
  },
  {
    "char": "J",
    "name": {
      "fr": "J majuscule",
      "en": "uppercase J",
      "es": "J mayúscula",
      "ar": "الحرف J الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre J se forme en deux gestes. D'abord un trait horizontal qui barre le sommet. Ensuite un crochet qui descend et s'arrondit vers la gauche en bas.",
      "en": "The letter J is formed in two gestures. First a horizontal line crossing the top. Then a hook going down and curving to the left at the bottom.",
      "es": "La letra J se forma en dos gestos. Primero un trazo horizontal que cruza la parte de arriba. Luego un gancho que baja y se curva hacia la izquierda abajo.",
      "ar": "يتكون الحرف J من حركتين. أولاً خط أفقي يمر أعلى القمة. ثم خطاف ينزل وينحني نحو اليسار في الأسفل."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 70.42 15 L 137.76 15",
        "startXY": [
          70.42,
          15
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 2,
        "description": {
          "fr": "Trait horizontal qui barre le sommet",
          "en": "Horizontal line crossing the top",
          "es": "Trazo horizontal que cruza la parte de arriba",
          "ar": "خط أفقي يمر أعلى القمة"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 103.42 17.7 L 103.42 102.11 A 23.35 23.35 0 0 1 56.74 102.11",
        "startXY": [
          103.42,
          17.7
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 1,
        "description": {
          "fr": "Crochet qui descend et s'arrondit à gauche en bas",
          "en": "Hook going down and curving left at the bottom",
          "es": "Gancho que baja y se curva hacia la izquierda abajo",
          "ar": "خطاف ينزل وينحني نحو اليسار في الأسفل"
        }
      }
    ]
  },
  {
    "char": "K",
    "name": {
      "fr": "K majuscule",
      "en": "uppercase K",
      "es": "K mayúscula",
      "ar": "الحرف K الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre K se forme en trois gestes. Un trait vertical, puis une oblique du milieu vers le haut-droite, puis une oblique du milieu vers le bas-droite.",
      "en": "The letter K is formed in three gestures. A vertical line, then a diagonal from the middle to the upper right, then a diagonal from the middle to the lower right.",
      "es": "La letra K se forma en tres gestos. Un trazo vertical, luego un oblicuo desde el medio hacia arriba a la derecha, luego un oblicuo desde el medio hacia abajo a la derecha.",
      "ar": "يتكون الحرف K من ثلاث حركات. خط عمودي، ثم خط مائل من المنتصف نحو أعلى اليمين، ثم خط مائل من المنتصف نحو أسفل اليمين."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 62.33 15 L 62.33 125",
        "startXY": [
          62.33,
          15
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 1,
        "description": {
          "fr": "Trait vertical",
          "en": "Vertical line",
          "es": "Trazo vertical",
          "ar": "خط عمودي"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 144.42 15 L 62.51 72.35",
        "startXY": [
          144.42,
          15
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 2,
        "description": {
          "fr": "Oblique du milieu vers le haut-droite",
          "en": "Diagonal from the middle to the upper right",
          "es": "Oblicuo desde el medio hacia arriba a la derecha",
          "ar": "مائل من المنتصف نحو أعلى اليمين"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 65.57 73.57 L 139.04 125",
        "startXY": [
          65.57,
          73.57
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 3,
        "description": {
          "fr": "Oblique du milieu vers le bas-droite",
          "en": "Diagonal from the middle to the lower right",
          "es": "Oblicuo desde el medio hacia abajo a la derecha",
          "ar": "مائل من المنتصف نحو أسفل اليمين"
        }
      }
    ]
  },
  {
    "char": "L",
    "name": {
      "fr": "L majuscule",
      "en": "uppercase L",
      "es": "L mayúscula",
      "ar": "الحرف L الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre L se forme en deux gestes. Un trait vertical, puis un trait horizontal qui part du bas vers la droite.",
      "en": "The letter L is formed in two gestures. A vertical line, then a horizontal line going from the bottom toward the right.",
      "es": "La letra L se forma en dos gestos. Un trazo vertical, luego un trazo horizontal que sale de abajo hacia la derecha.",
      "ar": "يتكون الحرف L من حركتين. خط عمودي، ثم خط أفقي ينطلق من الأسفل نحو اليمين."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 66.12 15 L 66.12 125",
        "startXY": [
          66.12,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical",
          "en": "Vertical line",
          "es": "Trazo vertical",
          "ar": "خط عمودي"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 66.12 125 L 119.88 125",
        "startXY": [
          66.12,
          125
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Horizontale du bas",
          "en": "Bottom horizontal",
          "es": "Horizontal de abajo",
          "ar": "الأفقي السفلي"
        }
      }
    ]
  },
  {
    "char": "M",
    "name": {
      "fr": "M majuscule",
      "en": "uppercase M",
      "es": "M mayúscula",
      "ar": "الحرف M الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre M se forme en quatre gestes. Un trait vertical à gauche, une oblique qui descend vers le centre, une oblique qui remonte vers la droite, puis un trait vertical à droite.",
      "en": "The letter M is formed in four gestures. A vertical line on the left, a diagonal going down to the center, a diagonal going up to the right, then a vertical line on the right.",
      "es": "La letra M se forma en cuatro gestos. Un trazo vertical a la izquierda, un oblicuo que baja hacia el centro, un oblicuo que sube hacia la derecha, y luego un trazo vertical a la derecha.",
      "ar": "يتكون الحرف M من أربع حركات. خط عمودي إلى اليسار، خط مائل ينزل نحو المنتصف، خط مائل يصعد نحو اليمين، ثم خط عمودي إلى اليمين."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 63.41 15 L 63.41 125",
        "startXY": [
          63.41,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical gauche",
          "en": "Left vertical line",
          "es": "Trazo vertical izquierdo",
          "ar": "خط عمودي أيسر"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 63.41 15 L 97 98.12",
        "startXY": [
          63.41,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique, sommet gauche vers le centre",
          "en": "Diagonal, left top to the center",
          "es": "Oblicuo, del vértice izquierdo al centro",
          "ar": "مائل، من القمة اليسرى نحو المنتصف"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 97 98.12 L 130.59 15",
        "startXY": [
          97,
          98.12
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique, centre vers le sommet droit",
          "en": "Diagonal, center to the right top",
          "es": "Oblicuo, del centro al vértice derecho",
          "ar": "مائل، من المنتصف نحو القمة اليمنى"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 130.59 15 L 130.59 125",
        "startXY": [
          130.59,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical droit",
          "en": "Right vertical line",
          "es": "Trazo vertical derecho",
          "ar": "خط عمودي أيمن"
        }
      }
    ]
  },
  {
    "char": "N",
    "name": {
      "fr": "N majuscule",
      "en": "uppercase N",
      "es": "N mayúscula",
      "ar": "الحرف N الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre N se forme en trois gestes. Un trait vertical à gauche, une oblique qui relie son sommet à la base du second trait, puis le trait vertical à droite.",
      "en": "The letter N is formed in three gestures. A vertical line on the left, a diagonal linking its top to the base of the second line, then the vertical line on the right.",
      "es": "La letra N se forma en tres gestos. Un trazo vertical a la izquierda, un oblicuo que une su vértice con la base del segundo trazo, y luego el trazo vertical a la derecha.",
      "ar": "يتكون الحرف N من ثلاث حركات. خط عمودي إلى اليسار، خط مائل يربط قمته بقاعدة الخط الثاني، ثم الخط العمودي إلى اليمين."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 63.41 15 L 63.41 125",
        "startXY": [
          63.41,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical gauche",
          "en": "Left vertical line",
          "es": "Trazo vertical izquierdo",
          "ar": "خط عمودي أيسر"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 63.41 15 L 130.59 125",
        "startXY": [
          63.41,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique, sommet gauche vers la base droite",
          "en": "Diagonal, left top to the right base",
          "es": "Oblicuo, del vértice izquierdo a la base derecha",
          "ar": "مائل، من القمة اليسرى نحو القاعدة اليمنى"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 130.59 15 L 130.59 125",
        "startXY": [
          130.59,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical droit",
          "en": "Right vertical line",
          "es": "Trazo vertical derecho",
          "ar": "خط عمودي أيمن"
        }
      }
    ]
  },
  {
    "char": "Ñ",
    "name": {
      "fr": "N espagnol (Eñe) majuscule",
      "en": "uppercase spanish Ñ",
      "es": "Eñe mayúscula",
      "ar": "الحرف الإسباني Ñ الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre Ñ se forme comme un N, puis on ajoute un petit tilde ondulé au-dessus.",
      "en": "The letter Ñ is formed like an N, then a small wavy tilde is added above it.",
      "es": "La letra Ñ se forma como una N, y luego se añade una pequeña virgulilla ondulada encima.",
      "ar": "يتكون الحرف Ñ مثل الحرف N، ثم تُضاف فوقه علامة تلدة صغيرة متموجة."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 66.87 26.32 L 66.87 125",
        "startXY": [
          66.87,
          26.32
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical gauche",
          "en": "Left vertical line",
          "es": "Trazo vertical izquierdo",
          "ar": "خط عمودي أيسر"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 66.87 26.32 L 127.13 125",
        "startXY": [
          66.87,
          26.32
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique, sommet gauche vers la base droite",
          "en": "Diagonal, left top to the right base",
          "es": "Oblicuo, del vértice izquierdo a la base derecha",
          "ar": "مائل، من القمة اليسرى نحو القاعدة اليمنى"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 127.13 26.32 L 127.13 125",
        "startXY": [
          127.13,
          26.32
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical droit",
          "en": "Right vertical line",
          "es": "Trazo vertical derecho",
          "ar": "خط عمودي أيمن"
        }
      },
      {
        "family": "courbe",
        "variant": "tilde",
        "pathD": "M 80.43 20.29 C 84.95 13.51 90.97 13.51 96.24 18.78 C 101.51 24.06 107.54 24.06 113.57 17.28",
        "startXY": [
          80.43,
          20.29
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Petit tilde ondulé au-dessus du N",
          "en": "Small wavy tilde above the N",
          "es": "Pequeña virgulilla ondulada encima de la N",
          "ar": "علامة تلدة صغيرة متموجة فوق الحرف N"
        }
      }
    ]
  },
  {
    "char": "O",
    "name": {
      "fr": "O majuscule",
      "en": "uppercase O",
      "es": "O mayúscula",
      "ar": "الحرف O الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre O est un grand ovale complet. Pars du sommet et tourne dans le sens anti-horaire en un seul mouvement continu.",
      "en": "The letter O is a large full oval. Start at the top and turn counter-clockwise in one continuous motion.",
      "es": "La letra O es un gran óvalo completo. Parte desde arriba y gira en sentido antihorario en un solo movimiento continuo.",
      "ar": "الحرف O عبارة عن بيضاوي كبير كامل. ابدأ من الأعلى ودُر في اتجاه عكس عقارب الساعة بحركة واحدة متصلة."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 97.01 15 A 33.59 55 0 1 0 97.09 15",
        "startXY": [
          97.01,
          15
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Grand ovale complet, anti-horaire depuis le sommet",
          "en": "Large full oval, counter-clockwise from the top",
          "es": "Gran óvalo completo, antihorario desde arriba",
          "ar": "بيضاوي كبير كامل، عكس اتجاه عقارب الساعة من الأعلى"
        }
      }
    ]
  },
  {
    "char": "P",
    "name": {
      "fr": "P majuscule",
      "en": "uppercase P",
      "es": "P mayúscula",
      "ar": "الحرف P الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre P se forme en deux gestes. Un trait vertical pleine hauteur, puis une courbe ronde accolée en haut à droite seulement.",
      "en": "The letter P is formed in two gestures. A full-height vertical line, then a round curve attached only to the upper right.",
      "es": "La letra P se forma en dos gestos. Un trazo vertical de altura completa, luego una curva redonda pegada solo arriba a la derecha.",
      "ar": "يتكون الحرف P من حركتين. خط عمودي بارتفاع كامل، ثم منحنى مستدير ملاصق أعلى اليمين فقط."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 100 15 L 100 125",
        "startXY": [
          100,
          15
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 2,
        "description": {
          "fr": "Trait vertical pleine hauteur",
          "en": "Full-height vertical line",
          "es": "Trazo vertical de altura completa",
          "ar": "خط عمودي بارتفاع كامل"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 100 23.78 A 30 30 0 1 1 100 66.23",
        "startXY": [
          100,
          23.78
        ],
        "strokeColor": "#E05252",
        "zIndex": 1,
        "description": {
          "fr": "Courbe du haut, accolée à droite",
          "en": "Upper curve, attached on the right",
          "es": "Curva de arriba, pegada a la derecha",
          "ar": "المنحنى العلوي، ملاصق لليمين"
        }
      }
    ]
  },
  {
    "char": "Q",
    "name": {
      "fr": "Q majuscule",
      "en": "uppercase Q",
      "es": "Q mayúscula",
      "ar": "الحرف Q الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre Q se forme en deux gestes. D'abord un grand ovale complet, comme le O. Ensuite une petite oblique qui sort du cercle vers le bas-droite.",
      "en": "The letter Q is formed in two gestures. First a large full oval, like the O. Then a small diagonal coming out of the circle toward the lower right.",
      "es": "La letra Q se forma en dos gestos. Primero un gran óvalo completo, como la O. Luego un pequeño oblicuo que sale del círculo hacia abajo a la derecha.",
      "ar": "يتكون الحرف Q من حركتين. أولاً بيضاوي كبير كامل، مثل حرف O. ثم خط مائل صغير يخرج من الدائرة نحو أسفل اليمين."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 97.01 15 A 34.21 56 0 1 0 97.09 15",
        "startXY": [
          97.01,
          15
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Grand ovale complet",
          "en": "Large full oval",
          "es": "Gran óvalo completo",
          "ar": "بيضاوي كبير كامل"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 103.53 103.82 L 118.2 125",
        "startXY": [
          103.53,
          103.82
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Petite oblique sortant vers le bas-droite",
          "en": "Small diagonal coming out toward the lower right",
          "es": "Pequeño oblicuo que sale hacia abajo a la derecha",
          "ar": "مائل صغير يخرج نحو أسفل اليمين"
        }
      }
    ]
  },
  {
    "char": "R",
    "name": {
      "fr": "R majuscule",
      "en": "uppercase R",
      "es": "R mayúscula",
      "ar": "الحرف R الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre R se forme comme un P, avec une jambe en plus. Trait vertical, courbe en haut à droite, puis une oblique qui part du point de jonction vers le bas-droite.",
      "en": "The letter R is formed like a P, with an extra leg. Vertical line, curve at the upper right, then a diagonal starting from the junction point toward the lower right.",
      "es": "La letra R se forma como una P, con una pierna adicional. Trazo vertical, curva arriba a la derecha, luego un oblicuo que sale del punto de unión hacia abajo a la derecha.",
      "ar": "يتكون الحرف R مثل الحرف P، مع رجل إضافية. خط عمودي، منحنى أعلى اليمين، ثم خط مائل ينطلق من نقطة الالتقاء نحو أسفل اليمين."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 78.67 15 L 78.67 125",
        "startXY": [
          78.67,
          15
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 3,
        "description": {
          "fr": "Trait vertical pleine hauteur",
          "en": "Full-height vertical line",
          "es": "Trazo vertical de altura completa",
          "ar": "خط عمودي بارتفاع كامل"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 78.67 23.78 A 30 30 0 1 1 78.67 66.23",
        "startXY": [
          78.67,
          23.78
        ],
        "strokeColor": "#E05252",
        "zIndex": 2,
        "description": {
          "fr": "Courbe du haut, accolée à droite",
          "en": "Upper curve, attached on the right",
          "es": "Curva de arriba, pegada a la derecha",
          "ar": "المنحنى العلوي، ملاصق لليمين"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 104.39 77.18 L 134.59 125",
        "startXY": [
          104.39,
          77.18
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 1,
        "description": {
          "fr": "Jambe oblique vers le bas-droite",
          "en": "Diagonal leg toward the lower right",
          "es": "Pierna oblicua hacia abajo a la derecha",
          "ar": "رِجل مائلة نحو أسفل اليمين"
        }
      }
    ]
  },
  {
    "char": "S",
    "name": {
      "fr": "S majuscule",
      "en": "uppercase S",
      "es": "S mayúscula",
      "ar": "الحرف S الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre S se forme comme le s minuscule mais à pleine hauteur : un grand crochet en haut qui s'arrondit à droite, puis un grand crochet en bas qui s'arrondit à gauche.",
      "en": "The letter S is formed like the lowercase s but at full height: a large hook at the top curving right, then a large hook at the bottom curving left.",
      "es": "La letra S se forma como la s minúscula pero a altura completa: un gran gancho arriba que se curva a la derecha, luego un gran gancho abajo que se curva a la izquierda.",
      "ar": "يتكون الحرف S مثل الحرف s الصغير لكن بارتفاع كامل: خطاف كبير في الأعلى ينحني نحو اليمين، ثم خطاف كبير في الأسفل ينحني نحو اليسار."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "top-right",
        "pathD": "M 122.87 33.13 C 118.07 19.97 104.22 12.5 90.65 15.76 C 77.05 18.94 68.03 31.83 69.67 45.68 C 71.3 59.51 83.08 70 97 70",
        "startXY": [
          122.87,
          33.13
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Grand crochet, s'arrondit vers la droite en haut",
          "en": "Large hook, curving right at the top",
          "es": "Gran gancho, se curva hacia la derecha arriba",
          "ar": "خطاف كبير، ينحني نحو اليمين في الأعلى"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 97 70 C 110.92 70 122.7 80.49 124.33 94.33 C 125.97 108.17 116.95 121.06 103.35 124.24 C 89.78 127.5 75.93 120.02 71.13 106.87",
        "startXY": [
          97,
          70
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Grand crochet, s'arrondit vers la gauche en bas",
          "en": "Large hook, curving left at the bottom",
          "es": "Gran gancho, se curva hacia la izquierda abajo",
          "ar": "خطاف كبير، ينحني نحو اليسار في الأسفل"
        }
      }
    ]
  },
  {
    "char": "T",
    "name": {
      "fr": "T majuscule",
      "en": "uppercase T",
      "es": "T mayúscula",
      "ar": "الحرف T الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre T se forme en deux gestes. Un trait horizontal en haut, puis un trait vertical qui part du centre de l'horizontale vers le bas.",
      "en": "The letter T is formed in two gestures. A horizontal line at the top, then a vertical line starting from the center of the horizontal going down.",
      "es": "La letra T se forma en dos gestos. Un trazo horizontal arriba, luego un trazo vertical que sale del centro de la horizontal hacia abajo.",
      "ar": "يتكون الحرف T من حركتين. خط أفقي في الأعلى، ثم خط عمودي ينطلق من منتصف الأفقي نحو الأسفل."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 63.41 15 L 130.59 15",
        "startXY": [
          63.41,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en haut",
          "en": "Horizontal line at the top",
          "es": "Trazo horizontal arriba",
          "ar": "خط أفقي في الأعلى"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 97 15 L 97 125",
        "startXY": [
          97,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, centré sous l'horizontale",
          "en": "Vertical line, centered under the horizontal",
          "es": "Trazo vertical, centrado bajo la horizontal",
          "ar": "خط عمودي، متمركز أسفل الأفقي"
        }
      }
    ]
  },
  {
    "char": "U",
    "name": {
      "fr": "U majuscule",
      "en": "uppercase U",
      "es": "U mayúscula",
      "ar": "الحرف U الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre U se forme en deux gestes. D'abord un crochet qui descend et s'arrondit pour relier la base des deux traits. Ensuite le trait vertical droit.",
      "en": "The letter U is formed in two gestures. First a hook going down and curving to link the base of the two lines. Then the right vertical line.",
      "es": "La letra U se forma en dos gestos. Primero un gancho que baja y se curva para unir la base de los dos trazos. Luego el trazo vertical derecho.",
      "ar": "يتكون الحرف U من حركتين. أولاً خطاف ينزل وينحني ليصل بين قاعدتَي الخطين. ثم الخط العمودي الأيمن."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "bottom",
        "pathD": "M 63.06 15 L 63.06 93.86 A 31.17 31.17 0 0 0 123.52 104.5",
        "startXY": [
          63.06,
          15
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 1,
        "description": {
          "fr": "Crochet qui descend et relie la base des deux traits",
          "en": "Hook going down, linking the base of the two lines",
          "es": "Gancho que baja y une la base de los dos trazos",
          "ar": "خطاف ينزل ويصل بين قاعدتَي الخطين"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 123.39 15.53 L 123.39 103.55",
        "startXY": [
          123.39,
          15.53
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 2,
        "description": {
          "fr": "Trait vertical droit",
          "en": "Right vertical line",
          "es": "Trazo vertical derecho",
          "ar": "خط عمودي أيمن"
        }
      }
    ]
  },
  {
    "char": "V",
    "name": {
      "fr": "V majuscule",
      "en": "uppercase V",
      "es": "V mayúscula",
      "ar": "الحرف V الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre V se forme en deux gestes, comme le v minuscule mais à pleine hauteur. Une oblique qui descend du haut-gauche vers le centre-bas, puis une oblique qui remonte vers le haut-droite.",
      "en": "The letter V is formed in two gestures, like the lowercase v but at full height. A diagonal going down from the upper left to the center-bottom, then a diagonal going up to the upper right.",
      "es": "La letra V se forma en dos gestos, como la v minúscula pero a altura completa. Un oblicuo que baja desde arriba a la izquierda hacia el centro abajo, luego un oblicuo que sube hacia arriba a la derecha.",
      "ar": "يتكون الحرف V من حركتين، مثل الحرف v الصغير لكن بارتفاع كامل. خط مائل ينزل من أعلى اليسار نحو منتصف الأسفل، ثم خط مائل يصعد نحو أعلى اليمين."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 63.41 15 L 97 125",
        "startXY": [
          63.41,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique descendante, haut-gauche vers centre-bas",
          "en": "Diagonal going down, upper left to center-bottom",
          "es": "Oblicuo descendente, de arriba a la izquierda al centro abajo",
          "ar": "مائل نازل، من أعلى اليسار نحو منتصف الأسفل"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 130.59 15 L 97 125",
        "startXY": [
          130.59,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique montante, centre-bas vers haut-droite",
          "en": "Diagonal going up, center-bottom to upper right",
          "es": "Oblicuo ascendente, del centro abajo hacia arriba a la derecha",
          "ar": "مائل صاعد، من منتصف الأسفل نحو أعلى اليمين"
        }
      }
    ]
  },
  {
    "char": "W",
    "name": {
      "fr": "W majuscule",
      "en": "uppercase W",
      "es": "W mayúscula",
      "ar": "الحرف W الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre W se forme en quatre obliques alternant descente et montée.",
      "en": "The letter W is formed with four diagonals alternating down and up.",
      "es": "La letra W se forma con cuatro oblicuos alternando bajada y subida.",
      "ar": "يتكون الحرف W من أربعة خطوط مائلة تتناوب بين النزول والصعود."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 60.06 15 L 78.53 125",
        "startXY": [
          60.06,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Première oblique descendante",
          "en": "First diagonal going down",
          "es": "Primer oblicuo descendente",
          "ar": "المائل الأول النازل"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 97 15 L 78.53 125",
        "startXY": [
          97,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Deuxième oblique montante",
          "en": "Second diagonal going up",
          "es": "Segundo oblicuo ascendente",
          "ar": "المائل الثاني الصاعد"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 97 15 L 115.47 125",
        "startXY": [
          97,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Troisième oblique descendante",
          "en": "Third diagonal going down",
          "es": "Tercer oblicuo descendente",
          "ar": "المائل الثالث النازل"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 133.94 15 L 115.47 125",
        "startXY": [
          133.94,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Quatrième oblique montante",
          "en": "Fourth diagonal going up",
          "es": "Cuarto oblicuo ascendente",
          "ar": "المائل الرابع الصاعد"
        }
      }
    ]
  },
  {
    "char": "X",
    "name": {
      "fr": "X majuscule",
      "en": "uppercase X",
      "es": "X mayúscula",
      "ar": "الحرف X الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre X se forme en deux traits obliques qui se croisent au centre, à pleine hauteur.",
      "en": "The letter X is formed with two diagonal lines crossing at the center, at full height.",
      "es": "La letra X se forma con dos trazos oblicuos que se cruzan en el centro, a altura completa.",
      "ar": "يتكون الحرف X من خطين مائلين يتقاطعان في المنتصف، بارتفاع كامل."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 63.41 15 L 130.59 125",
        "startXY": [
          63.41,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique haut-gauche vers bas-droite",
          "en": "Diagonal upper left to lower right",
          "es": "Oblicuo de arriba a la izquierda hacia abajo a la derecha",
          "ar": "مائل من أعلى اليسار نحو أسفل اليمين"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 130.59 15 L 63.41 125",
        "startXY": [
          130.59,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique haut-droite vers bas-gauche",
          "en": "Diagonal upper right to lower left",
          "es": "Oblicuo de arriba a la derecha hacia abajo a la izquierda",
          "ar": "مائل من أعلى اليمين نحو أسفل اليسار"
        }
      }
    ]
  },
  {
    "char": "Y",
    "name": {
      "fr": "Y majuscule",
      "en": "uppercase Y",
      "es": "Y mayúscula",
      "ar": "الحرف Y الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre Y se forme en trois gestes. Deux obliques qui partent du sommet et se rejoignent au centre, puis un trait vertical court qui descend depuis ce point.",
      "en": "The letter Y is formed in three gestures. Two diagonals starting from the top and meeting at the center, then a short vertical line going down from that point.",
      "es": "La letra Y se forma en tres gestos. Dos oblicuos que parten desde arriba y se juntan en el centro, luego un trazo vertical corto que baja desde ese punto.",
      "ar": "يتكون الحرف Y من ثلاث حركات. خطان مائلان ينطلقان من القمة ويلتقيان في المنتصف، ثم خط عمودي قصير ينزل من تلك النقطة."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 86.02 15 L 110.51 67.48",
        "startXY": [
          86.02,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique, sommet gauche vers le centre",
          "en": "Diagonal, left top to the center",
          "es": "Oblicuo, del vértice izquierdo al centro",
          "ar": "مائل، من القمة اليسرى نحو المنتصف"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 135.38 15.25 L 110.89 67.73",
        "startXY": [
          135.38,
          15.25
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique, sommet droit vers le centre",
          "en": "Diagonal, right top to the center",
          "es": "Oblicuo, del vértice derecho al centro",
          "ar": "مائل، من القمة اليمنى نحو المنتصف"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 110.7 67.09 L 110.7 125",
        "startXY": [
          110.7,
          67.09
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical court, centre vers le bas",
          "en": "Short vertical line, center to the bottom",
          "es": "Trazo vertical corto, del centro hacia abajo",
          "ar": "خط عمودي قصير، من المنتصف نحو الأسفل"
        }
      }
    ]
  },
  {
    "char": "Z",
    "name": {
      "fr": "Z majuscule",
      "en": "uppercase Z",
      "es": "Z mayúscula",
      "ar": "الحرف Z الكبير"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "La lettre Z se forme comme le z minuscule à pleine hauteur : un trait horizontal en haut, une oblique vers le bas-gauche, un trait horizontal en bas.",
      "en": "The letter Z is formed like the full-height lowercase z: a horizontal line at the top, a diagonal toward the lower left, a horizontal line at the bottom.",
      "es": "La letra Z se forma como la z minúscula a altura completa: un trazo horizontal arriba, un oblicuo hacia abajo a la izquierda, un trazo horizontal abajo.",
      "ar": "يتكون الحرف Z مثل الحرف z الصغير بارتفاع كامل: خط أفقي في الأعلى، مائل نحو أسفل اليسار، خط أفقي في الأسفل."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 63.41 15 L 130.59 15",
        "startXY": [
          63.41,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en haut",
          "en": "Horizontal line at the top",
          "es": "Trazo horizontal arriba",
          "ar": "خط أفقي في الأعلى"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 130.59 15 L 63.41 125",
        "startXY": [
          130.59,
          15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique vers le bas-gauche",
          "en": "Diagonal toward the lower left",
          "es": "Oblicuo hacia abajo a la izquierda",
          "ar": "مائل نحو أسفل اليسار"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 63.41 125 L 130.59 125",
        "startXY": [
          63.41,
          125
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en bas",
          "en": "Horizontal line at the bottom",
          "es": "Trazo horizontal abajo",
          "ar": "خط أفقي في الأسفل"
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
      "es": "cero",
      "ar": "صفر"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 0 est un ovale complet. Pars du sommet et tourne dans le sens anti-horaire.",
      "en": "The digit 0 is a full oval. Start at the top and turn counter-clockwise.",
      "es": "El número 0 es un óvalo completo. Parte desde arriba y gira en sentido antihorario.",
      "ar": "الرقم 0 عبارة عن بيضاوي كامل. ابدأ من الأعلى ودُر في اتجاه عكس عقارب الساعة."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 97.02 75 A 15.27 25 0 1 0 97.08 75",
        "startXY": [
          97.02,
          75
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Ovale complet, anti-horaire depuis le sommet",
          "en": "Full oval, counter-clockwise from the top",
          "es": "Óvalo completo, antihorario desde arriba",
          "ar": "بيضاوي كامل، عكس اتجاه عقارب الساعة من الأعلى"
        }
      }
    ]
  },
  {
    "char": "1",
    "name": {
      "fr": "un",
      "en": "one",
      "es": "uno",
      "ar": "واحد"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 1 se forme en deux gestes. Une petite amorce oblique qui rejoint le sommet, puis un trait vertical qui descend jusqu'à la ligne.",
      "en": "The digit 1 is formed in two gestures. A small diagonal lead-in reaching the top, then a vertical line going down to the baseline.",
      "es": "El número 1 se forma en dos gestos. Un pequeño trazo oblicuo de entrada que llega hasta arriba, luego un trazo vertical que baja hasta la línea.",
      "ar": "يتكون الرقم 1 من حركتين. بداية مائلة صغيرة تصل إلى القمة، ثم خط عمودي ينزل حتى السطر."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-droit",
        "pathD": "M 68.69 102.13 L 87.68 75",
        "startXY": [
          68.69,
          102.13
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Amorce oblique vers le sommet",
          "en": "Diagonal lead-in to the top",
          "es": "Trazo oblicuo de entrada hacia arriba",
          "ar": "بداية مائلة نحو القمة"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 87.87 75.34 L 87.87 125",
        "startXY": [
          87.87,
          75.34
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical, du haut vers le bas",
          "en": "Vertical line, from top to bottom",
          "es": "Trazo vertical, de arriba hacia abajo",
          "ar": "خط عمودي، من الأعلى إلى الأسفل"
        }
      }
    ]
  },
  {
    "char": "2",
    "name": {
      "fr": "deux",
      "en": "two",
      "es": "dos",
      "ar": "اثنان"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 2 se forme en deux gestes. Un crochet qui part du haut, s'arrondit puis descend vers le bas-gauche, ensuite un trait horizontal à la base.",
      "en": "The digit 2 is formed in two gestures. A hook starting at the top, curving and going down to the lower left, then a horizontal line at the base.",
      "es": "El número 2 se forma en dos gestos. Un gancho que parte de arriba, se curva y baja hacia abajo a la izquierda, luego un trazo horizontal en la base.",
      "ar": "يتكون الرقم 2 من حركتين. خطاف ينطلق من الأعلى، ينحني ثم ينزل نحو أسفل اليسار، ثم خط أفقي عند القاعدة."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "top-left",
        "pathD": "M 92.5 78.81 A 13.02 13.02 0 0 1 110.92 97.22 L 83.29 124.86",
        "startXY": [
          92.5,
          78.81
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet qui part du haut et descend vers le bas-gauche",
          "en": "Hook starting at the top, going down to the lower left",
          "es": "Gancho que parte de arriba y baja hacia abajo a la izquierda",
          "ar": "خطاف ينطلق من الأعلى وينزل نحو أسفل اليسار"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 83.39 125 L 120.15 125",
        "startXY": [
          83.39,
          125
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal à la base",
          "en": "Horizontal line at the base",
          "es": "Trazo horizontal en la base",
          "ar": "خط أفقي عند القاعدة"
        }
      }
    ]
  },
  {
    "char": "3",
    "name": {
      "fr": "trois",
      "en": "three",
      "es": "tres",
      "ar": "ثلاثة"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 3 se forme en deux courbes empilées, ouvertes vers la gauche, qui se touchent au centre.",
      "en": "The digit 3 is formed with two stacked curves, open to the left, touching in the middle.",
      "es": "El número 3 se forma con dos curvas apiladas, abiertas hacia la izquierda, que se tocan en el centro.",
      "ar": "يتكون الرقم 3 من منحنيين متراكبين، مفتوحين نحو اليسار، يتلامسان في المنتصف."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 77.67 89.67 C 76.77 84.5 79.21 79.33 83.75 76.66 C 88.28 74.05 94.02 74.56 97.99 77.92 C 102.02 81.33 103.49 86.83 101.75 91.77 C 99.94 96.71 95.21 100 89.99 100",
        "startXY": [
          77.67,
          89.67
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe du haut, ouverte à gauche",
          "en": "Upper curve, open to the left",
          "es": "Curva de arriba, abierta a la izquierda",
          "ar": "المنحنى العلوي، مفتوح نحو اليسار"
        }
      },
      {
        "family": "courbe",
        "variant": "open-left",
        "pathD": "M 89.99 100 C 95.21 100 99.94 103.29 101.75 108.23 C 103.49 113.17 102.02 118.67 97.99 122.08 C 94.02 125.44 88.28 125.95 83.75 123.34 C 79.21 120.67 76.77 115.5 77.67 110.33",
        "startXY": [
          89.99,
          100
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Courbe du bas, ouverte à gauche",
          "en": "Lower curve, open to the left",
          "es": "Curva de abajo, abierta a la izquierda",
          "ar": "المنحنى السفلي، مفتوح نحو اليسار"
        }
      }
    ]
  },
  {
    "char": "4",
    "name": {
      "fr": "quatre",
      "en": "four",
      "es": "cuatro",
      "ar": "أربعة"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 4 se forme en trois gestes. Une oblique qui descend vers le bas-gauche, un trait horizontal à sa base, puis un trait vertical qui traverse l'horizontale et dépasse vers le haut.",
      "en": "The digit 4 is formed in three gestures. A diagonal going down to the lower left, a horizontal line at its base, then a vertical line crossing the horizontal and going past it at the top.",
      "es": "El número 4 se forma en tres gestos. Un oblicuo que baja hacia abajo a la izquierda, un trazo horizontal en su base, luego un trazo vertical que cruza la horizontal y sobrepasa hacia arriba.",
      "ar": "يتكون الرقم 4 من ثلاث حركات. خط مائل ينزل نحو أسفل اليسار، خط أفقي عند قاعدته، ثم خط عمودي يقطع الأفقي ويتجاوزه نحو الأعلى."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 98.86 75 L 84.58 107.07",
        "startXY": [
          98.86,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique vers le bas-gauche",
          "en": "Diagonal toward the lower left",
          "es": "Oblicuo hacia abajo a la izquierda",
          "ar": "مائل نحو أسفل اليسار"
        }
      },
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 84.7 107.11 L 119.8 107.11",
        "startXY": [
          84.7,
          107.11
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal, base de l'oblique",
          "en": "Horizontal line, base of the diagonal",
          "es": "Trazo horizontal, base del oblicuo",
          "ar": "خط أفقي، قاعدة المائل"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 102.36 89.89 L 102.36 125",
        "startXY": [
          102.36,
          89.89
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait vertical qui traverse et dépasse",
          "en": "Vertical line crossing and going past",
          "es": "Trazo vertical que cruza y sobrepasa",
          "ar": "خط عمودي يقطع ويتجاوز"
        }
      }
    ]
  },
  {
    "char": "5",
    "name": {
      "fr": "cinq",
      "en": "five",
      "es": "cinco",
      "ar": "خمسة"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 5 se forme en trois gestes. Un trait horizontal en haut, un petit trait vertical qui descend à gauche, puis un crochet qui balaie un grand arc, de haut en bas, en restant aligné à la verticale entre son origine et son extrémité.",
      "en": "The digit 5 is formed in three gestures. A horizontal line at the top, a small vertical line going down on the left, then a hook sweeping a large arc, top to bottom, with its start and end vertically aligned.",
      "es": "El número 5 se forma en tres gestos. Un trazo horizontal arriba, un pequeño trazo vertical que baja a la izquierda, luego un gancho que traza un gran arco, de arriba abajo, quedando alineado verticalmente entre su origen y su extremo.",
      "ar": "يتكون الرقم 5 من ثلاث حركات. خط أفقي في الأعلى، خط عمودي صغير ينزل إلى اليسار، ثم خطاف يرسم قوسًا كبيرًا، من الأعلى إلى الأسفل، مع بقائه محاذيًا عموديًا بين بدايته ونهايته."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 85.06 75 L 106.22 75",
        "startXY": [
          85.06,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en haut",
          "en": "Horizontal line at the top",
          "es": "Trazo horizontal arriba",
          "ar": "خط أفقي في الأعلى"
        }
      },
      {
        "family": "trait",
        "variant": "vertical",
        "pathD": "M 85.59 77.64 L 85.59 95.63",
        "startXY": [
          85.59,
          77.64
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Petit trait vertical à gauche",
          "en": "Small vertical line on the left",
          "es": "Pequeño trazo vertical a la izquierda",
          "ar": "خط عمودي صغير إلى اليسار"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom-right",
        "pathD": "M 85.59 95.63 C 92.26 91.51 100.93 92.83 106.06 98.76 C 111.2 104.73 111.2 113.53 106.06 119.5 C 100.93 125.43 92.26 126.74 85.59 122.57",
        "startXY": [
          85.59,
          95.63
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet qui balaie un grand arc et redescend aligné avec son point de départ",
          "en": "Hook sweeping a large arc and coming back down aligned with its starting point",
          "es": "Gancho que traza un gran arco y vuelve a bajar alineado con su punto de partida",
          "ar": "خطاف يرسم قوسًا كبيرًا وينزل محاذيًا لنقطة انطلاقه"
        }
      }
    ]
  },
  {
    "char": "6",
    "name": {
      "fr": "six",
      "en": "six",
      "es": "seis",
      "ar": "ستة"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 6 se forme comme le 9, mais inversé : d'abord un crochet qui part du haut, descend et s'arrondit en haut à droite, puis un anneau fermé en bas, dessiné dans le sens anti-horaire à partir du point où s'arrête le crochet.",
      "en": "The digit 6 is formed like the 9, but inverted: first a hook starting at the top, going down and curving at the upper right, then a closed ring at the bottom, drawn counterclockwise starting exactly where the hook ends.",
      "es": "El número 6 se forma como el 9, pero invertido: primero un gancho que parte de arriba, baja y se curva arriba a la derecha, luego un anillo cerrado abajo, trazado en sentido antihorario a partir del punto donde termina el gancho.",
      "ar": "يتكون الرقم 6 مثل الرقم 9 لكن معكوسًا: أولاً خطاف ينطلق من الأعلى، ينزل وينحني أعلى اليمين، ثم حلقة مغلقة في الأسفل، تُرسم عكس اتجاه عقارب الساعة بدءًا من النقطة التي توقف عندها الخطاف."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "top-right",
        "pathD": "M 111.42 84.68 A 10.79 10.79 0 0 0 89.89 85.81 L 89.89 116.8",
        "startXY": [
          111.42,
          84.68
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet qui part de la courbure en haut à droite, puis descend tout droit",
          "en": "Hook starting from the upper-right curve, then going straight down",
          "es": "Gancho que parte de la curva arriba a la derecha, luego baja recto",
          "ar": "خطاف ينطلق من الانحناء أعلى اليمين، ثم ينزل مستقيمًا"
        }
      },
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 90.11 117.52 A 11.98 11.98 0 1 0 90.11 108.53",
        "startXY": [
          90.11,
          117.52
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Anneau fermé en bas, tracé dans le sens anti-horaire à partir du point d'arrêt du crochet",
          "en": "Closed ring at the bottom, drawn counterclockwise from the hook's end point",
          "es": "Anillo cerrado abajo, trazado en sentido antihorario desde el punto final del gancho",
          "ar": "حلقة مغلقة في الأسفل، تُرسم عكس اتجاه عقارب الساعة بدءًا من نقطة توقف الخطاف"
        }
      }
    ]
  },
  {
    "char": "7",
    "name": {
      "fr": "sept",
      "en": "seven",
      "es": "siete",
      "ar": "سبعة"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 7 se forme en deux gestes. Un trait horizontal en haut, puis une oblique qui descend du haut-droite vers le bas-centre.",
      "en": "The digit 7 is formed in two gestures. A horizontal line at the top, then a diagonal going down from the upper right to the center-bottom.",
      "es": "El número 7 se forma en dos gestos. Un trazo horizontal arriba, luego un oblicuo que baja desde arriba a la derecha hacia el centro abajo.",
      "ar": "يتكون الرقم 7 من حركتين. خط أفقي في الأعلى، ثم خط مائل ينزل من أعلى اليمين نحو منتصف الأسفل."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "horizontal",
        "pathD": "M 84.33 75 L 118.62 75",
        "startXY": [
          84.33,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trait horizontal en haut",
          "en": "Horizontal line at the top",
          "es": "Trazo horizontal arriba",
          "ar": "خط أفقي في الأعلى"
        }
      },
      {
        "family": "trait",
        "variant": "oblique-gauche",
        "pathD": "M 119.06 75.29 L 95.89 125",
        "startXY": [
          119.06,
          75.29
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Oblique vers le bas-centre",
          "en": "Diagonal toward the center-bottom",
          "es": "Oblicuo hacia el centro abajo",
          "ar": "مائل نحو منتصف الأسفل"
        }
      }
    ]
  },
  {
    "char": "8",
    "name": {
      "fr": "huit",
      "en": "eight",
      "es": "ocho",
      "ar": "ثمانية"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 8 se forme en deux petits anneaux empilés, celui du haut un peu plus petit que celui du bas.",
      "en": "The digit 8 is formed with two small stacked rings, the top one a little smaller than the bottom one.",
      "es": "El número 8 se forma con dos pequeños anillos apilados, el de arriba un poco más pequeño que el de abajo.",
      "ar": "يتكون الرقم 8 من حلقتين صغيرتين متراكبتين، العلوية أصغر قليلاً من السفلية."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 97.02 75 A 14.87 12.16 0 1 0 97.08 75",
        "startXY": [
          97.02,
          75
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Petit anneau du haut",
          "en": "Small upper ring",
          "es": "Pequeño anillo de arriba",
          "ar": "الحلقة العلوية الصغيرة"
        }
      },
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 97.02 97.97 A 16.21 13.51 0 1 0 97.08 97.97",
        "startXY": [
          97.02,
          97.97
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Anneau du bas, légèrement plus grand",
          "en": "Bottom ring, slightly larger",
          "es": "Anillo de abajo, ligeramente más grande",
          "ar": "الحلقة السفلية، أكبر قليلاً"
        }
      }
    ]
  },
  {
    "char": "9",
    "name": {
      "fr": "neuf",
      "en": "nine",
      "es": "nueve",
      "ar": "تسعة"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "Le chiffre 9 se forme comme le 6 mais inversé. D'abord un anneau fermé en haut, dessiné dans le sens anti-horaire, puis un crochet tangent au bord droit de l'anneau, qui descend et s'arrondit en bas à gauche.",
      "en": "The digit 9 is formed like the 6 but inverted. First a closed ring at the top, drawn counterclockwise, then a hook tangent to the ring's right edge, going down and curving at the lower left.",
      "es": "El número 9 se forma como el 6 pero invertido. Primero un anillo cerrado arriba, trazado en sentido antihorario, luego un gancho tangente al borde derecho del anillo, que baja y se curva abajo a la izquierda.",
      "ar": "يتكون الرقم 9 مثل الرقم 6 لكن معكوسًا. أولاً حلقة مغلقة في الأعلى، تُرسم عكس اتجاه عقارب الساعة، ثم خطاف مماس للحافة اليمنى للحلقة، ينزل وينحني أسفل اليسار."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "closed",
        "pathD": "M 119.68 82.19 A 12.62 12.62 0 1 0 119.68 93.05",
        "startXY": [
          119.68,
          82.19
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Anneau fermé en haut, tracé dans le sens anti-horaire",
          "en": "Closed ring at the top, drawn counterclockwise",
          "es": "Anillo cerrado arriba, trazado en sentido antihorario",
          "ar": "حلقة مغلقة في الأعلى، تُرسم عكس اتجاه عقارب الساعة"
        }
      },
      {
        "family": "crochet",
        "variant": "bottom-left",
        "pathD": "M 119.59 80.79 L 119.59 113.91 A 11.03 11.03 0 0 1 98.16 117.68",
        "startXY": [
          119.59,
          80.79
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Crochet tangent au bord droit de l'anneau, descend puis s'arrondit en bas à gauche",
          "en": "Hook tangent to the ring's right edge, going down then curving at the lower left",
          "es": "Gancho tangente al borde derecho del anillo, baja y luego se curva abajo a la izquierda",
          "ar": "خطاف مماس للحافة اليمنى للحلقة، ينزل ثم ينحني أسفل اليسار"
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
