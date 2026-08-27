// Nommage SCREAMING_SNAKE_CASE volontaire (miroir 1:1 du module TypeScript
// source) — voir `calcul_catalog.dart` pour l'explication complète.
// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:convert';

final List<dynamic> TRAITS = jsonDecode(r'''
[
  {
    "id": "trait-vertical-full",
    "label": {
      "fr": "Trait vertical",
      "en": "Vertical line",
      "es": "Trazo vertical",
      "ar": "خط عمودي"
    },
    "consigne": {
      "fr": "Trace le trait vertical. Pars du haut et descends jusqu'en bas d'un seul geste régulier.",
      "en": "Trace the vertical line. Start at the top and go down to the bottom in one steady motion.",
      "es": "Traza el trazo vertical. Parte de arriba y baja hasta abajo con un solo gesto regular.",
      "ar": "ارسم الخط العمودي. ابدأ من الأعلى وانزل حتى الأسفل بحركة واحدة منتظمة."
    },
    "family": "trait",
    "variant": "vertical",
    "scale": "full",
    "pathD": "M 100 28 L 100 172",
    "startXY": [
      100,
      28
    ],
    "endXY": [
      100,
      172
    ],
    "zone": "hampe",
    "strokeColor": "#4A3B2A",
    "badgeBg": "#F5EDE0",
    "badgeText": "#4A3B2A"
  },
  {
    "id": "trait-vertical-reduced",
    "label": {
      "fr": "Petit trait vertical",
      "en": "Small vertical line",
      "es": "Trazo vertical pequeño",
      "ar": "خط عمودي صغير"
    },
    "consigne": {
      "fr": "Trace le petit trait vertical, dans le corps de la ligne.",
      "en": "Trace the small vertical line, within the body of the writing line.",
      "es": "Traza el trazo vertical pequeño, dentro del cuerpo de la línea.",
      "ar": "ارسم الخط العمودي الصغير، داخل جسم السطر."
    },
    "family": "trait",
    "variant": "vertical",
    "scale": "reduced",
    "pathD": "M 100 75 L 100 155",
    "startXY": [
      100,
      75
    ],
    "endXY": [
      100,
      155
    ],
    "zone": "corps",
    "strokeColor": "#4A3B2A",
    "badgeBg": "#F5EDE0",
    "badgeText": "#4A3B2A"
  },
  {
    "id": "trait-horizontal-full",
    "label": {
      "fr": "Trait horizontal",
      "en": "Horizontal line",
      "es": "Trazo horizontal",
      "ar": "خط أفقي"
    },
    "consigne": {
      "fr": "Trace le trait horizontal. Pars de gauche à droite d'un geste stable.",
      "en": "Trace the horizontal line. Go from left to right in one steady motion.",
      "es": "Traza el trazo horizontal. Parte de izquierda a derecha con un gesto estable.",
      "ar": "ارسم الخط الأفقي. انطلق من اليسار نحو اليمين بحركة ثابتة."
    },
    "family": "trait",
    "variant": "horizontal",
    "scale": "full",
    "pathD": "M 28 100 L 172 100",
    "startXY": [
      28,
      100
    ],
    "endXY": [
      172,
      100
    ],
    "zone": "corps",
    "strokeColor": "#4A3B2A",
    "badgeBg": "#F5EDE0",
    "badgeText": "#4A3B2A"
  },
  {
    "id": "trait-horizontal-reduced",
    "label": {
      "fr": "Petit trait horizontal",
      "en": "Small horizontal line",
      "es": "Trazo horizontal pequeño",
      "ar": "خط أفقي صغير"
    },
    "consigne": {
      "fr": "Trace le petit trait horizontal.",
      "en": "Trace the small horizontal line.",
      "es": "Traza el trazo horizontal pequeño.",
      "ar": "ارسم الخط الأفقي الصغير."
    },
    "family": "trait",
    "variant": "horizontal",
    "scale": "reduced",
    "pathD": "M 60 115 L 140 115",
    "startXY": [
      60,
      115
    ],
    "endXY": [
      140,
      115
    ],
    "zone": "corps",
    "strokeColor": "#4A3B2A",
    "badgeBg": "#F5EDE0",
    "badgeText": "#4A3B2A"
  },
  {
    "id": "trait-oblique-gauche-full",
    "label": {
      "fr": "Trait oblique à droite",
      "en": "Diagonal line to the left",
      "es": "Trazo oblicuo a la izquierda",
      "ar": "خط مائل إلى اليسار"
    },
    "consigne": {
      "fr": "Trace le trait oblique à droite en partant du haut droit et en descendant vers le bas gauche.",
      "en": "Trace the left diagonal line, starting at the top left and going down to the bottom right.",
      "es": "Traza el trazo oblicuo a la izquierda, partiendo de arriba a la izquierda y bajando hacia abajo a la derecha.",
      "ar": "ارسم الخط المائل إلى اليسار، بدءًا من أعلى اليسار وانزل نحو أسفل اليمين."
    },
    "family": "trait",
    "variant": "oblique-gauche",
    "scale": "full",
    "pathD": "M 40 40 L 160 160",
    "startXY": [
      40,
      40
    ],
    "endXY": [
      160,
      160
    ],
    "zone": "hampe",
    "strokeColor": "#4A3B2A",
    "badgeBg": "#F5EDE0",
    "badgeText": "#4A3B2A"
  },
  {
    "id": "trait-oblique-droit-full",
    "label": {
      "fr": "Trait oblique à gauche",
      "en": "Diagonal line to the right",
      "es": "Trazo oblicuo a la derecha",
      "ar": "خط مائل إلى اليمين"
    },
    "consigne": {
      "fr": "Trace le trait oblique à gauche en partant du haut gauche et en descendant vers le bas droit.",
      "en": "Trace the right diagonal line, starting at the top right and going down to the bottom left.",
      "es": "Traza el trazo oblicuo a la derecha, partiendo de arriba a la derecha y bajando hacia abajo a la izquierda.",
      "ar": "ارسم الخط المائل إلى اليمين، بدءًا من أعلى اليمين وانزل نحو أسفل اليسار."
    },
    "family": "trait",
    "variant": "oblique-droit",
    "scale": "full",
    "pathD": "M 160 40 L 40 160",
    "startXY": [
      160,
      40
    ],
    "endXY": [
      40,
      160
    ],
    "zone": "hampe",
    "strokeColor": "#4A3B2A",
    "badgeBg": "#F5EDE0",
    "badgeText": "#4A3B2A"
  },
  {
    "id": "trait-oblique-gauche-reduced",
    "label": {
      "fr": "Petit oblique à droite",
      "en": "Small left diagonal",
      "es": "Oblicuo a la izquierda pequeño",
      "ar": "مائل صغير إلى اليسار"
    },
    "consigne": {
      "fr": "Trace le petit trait oblique à droite en partant du haut et en descendant.",
      "en": "Trace the small left diagonal line, starting at the top and going down.",
      "es": "Traza el pequeño trazo oblicuo a la izquierda, partiendo de arriba y bajando.",
      "ar": "ارسم الخط المائل الصغير إلى اليسار، بدءًا من الأعلى ونزولًا."
    },
    "family": "trait",
    "variant": "oblique-gauche",
    "scale": "reduced",
    "pathD": "M 60 60 L 140 140",
    "startXY": [
      60,
      60
    ],
    "endXY": [
      140,
      140
    ],
    "zone": "corps",
    "strokeColor": "#4A3B2A",
    "badgeBg": "#F5EDE0",
    "badgeText": "#4A3B2A"
  },
  {
    "id": "trait-oblique-droit-reduced",
    "label": {
      "fr": "Petit oblique à gauche",
      "en": "Small right diagonal",
      "es": "Oblicuo a la derecha pequeño",
      "ar": "مائل صغير إلى اليمين"
    },
    "consigne": {
      "fr": "Trace le petit trait oblique à gauche en partant du haut et en descendant.",
      "en": "Trace the small right diagonal line, starting at the top and going down.",
      "es": "Traza el pequeño trazo oblicuo a la derecha, partiendo de arriba y bajando.",
      "ar": "ارسم الخط المائل الصغير إلى اليمين، بدءًا من الأعلى ونزولًا."
    },
    "family": "trait",
    "variant": "oblique-droit",
    "scale": "reduced",
    "pathD": "M 140 60 L 60 140",
    "startXY": [
      140,
      60
    ],
    "endXY": [
      60,
      140
    ],
    "zone": "corps",
    "strokeColor": "#4A3B2A",
    "badgeBg": "#F5EDE0",
    "badgeText": "#4A3B2A"
  }
]
''');

final List<dynamic> COURBES = jsonDecode(r'''
[
  {
    "id": "courbe-open-right-full",
    "label": {
      "fr": "Courbe ouverte à droite",
      "en": "Curve open to the right",
      "es": "Curva abierta a la derecha",
      "ar": "منحنى مفتوح من اليمين"
    },
    "consigne": {
      "fr": "Trace la courbe ouverte à droite, comme la lettre C.",
      "en": "Trace the curve open to the right, like the letter C.",
      "es": "Traza la curva abierta a la derecha, como la letra C.",
      "ar": "ارسم المنحنى المفتوح من اليمين، مثل الحرف C."
    },
    "family": "courbe",
    "variant": "open-right",
    "scale": "full",
    "pathD": "M 130 35 A 65 65 0 0 0 130 165",
    "startXY": [
      130,
      35
    ],
    "endXY": [
      130,
      165
    ],
    "zone": "hampe",
    "strokeColor": "#E05252",
    "badgeBg": "#FDEAEA",
    "badgeText": "#C03E3E"
  },
  {
    "id": "courbe-open-right-reduced",
    "label": {
      "fr": "Petite courbe à droite",
      "en": "Small curve to the right",
      "es": "Curva pequeña a la derecha",
      "ar": "منحنى صغير من اليمين"
    },
    "consigne": {
      "fr": "Trace la petite courbe ouverte à droite.",
      "en": "Trace the small curve open to the right.",
      "es": "Traza la pequeña curva abierta a la derecha.",
      "ar": "ارسم المنحنى الصغير المفتوح من اليمين."
    },
    "family": "courbe",
    "variant": "open-right",
    "scale": "reduced",
    "pathD": "M 120 65 A 40 40 0 0 0 120 135",
    "startXY": [
      120,
      65
    ],
    "endXY": [
      120,
      135
    ],
    "zone": "corps",
    "strokeColor": "#E05252",
    "badgeBg": "#FDEAEA",
    "badgeText": "#C03E3E"
  },
  {
    "id": "courbe-open-left-full",
    "label": {
      "fr": "Courbe ouverte à gauche",
      "en": "Curve open to the left",
      "es": "Curva abierta a la izquierda",
      "ar": "منحنى مفتوح من اليسار"
    },
    "consigne": {
      "fr": "Trace la courbe ouverte à gauche.",
      "en": "Trace the curve open to the left.",
      "es": "Traza la curva abierta a la izquierda.",
      "ar": "ارسم المنحنى المفتوح من اليسار."
    },
    "family": "courbe",
    "variant": "open-left",
    "scale": "full",
    "pathD": "M 70 35 A 65 65 0 0 1 70 165",
    "startXY": [
      70,
      35
    ],
    "endXY": [
      70,
      165
    ],
    "zone": "hampe",
    "strokeColor": "#E05252",
    "badgeBg": "#FDEAEA",
    "badgeText": "#C03E3E"
  },
  {
    "id": "courbe-open-left-reduced",
    "label": {
      "fr": "Petite courbe à gauche",
      "en": "Small curve to the left",
      "es": "Curva pequeña a la izquierda",
      "ar": "منحنى صغير من اليسار"
    },
    "consigne": {
      "fr": "Trace la petite courbe ouverte à gauche.",
      "en": "Trace the small curve open to the left.",
      "es": "Traza la pequeña curva abierta a la izquierda.",
      "ar": "ارسم المنحنى الصغير المفتوح من اليسار."
    },
    "family": "courbe",
    "variant": "open-left",
    "scale": "reduced",
    "pathD": "M 80 65 A 40 40 0 0 1 80 135",
    "startXY": [
      80,
      65
    ],
    "endXY": [
      80,
      135
    ],
    "zone": "corps",
    "strokeColor": "#E05252",
    "badgeBg": "#FDEAEA",
    "badgeText": "#C03E3E"
  },
  {
    "id": "courbe-closed-full",
    "label": {
      "fr": "Cercle fermé",
      "en": "Closed circle",
      "es": "Círculo cerrado",
      "ar": "دائرة مغلقة"
    },
    "consigne": {
      "fr": "Trace le cercle complet, en partant du haut et en tournant dans le sens anti-horaire (vers la gauche).",
      "en": "Trace the full circle, starting at the top and turning counter-clockwise (to the left).",
      "es": "Traza el círculo completo, partiendo de arriba y girando en sentido antihorario (hacia la izquierda).",
      "ar": "ارسم الدائرة الكاملة، بدءًا من الأعلى ودورانًا عكس اتجاه عقارب الساعة (نحو اليسار)."
    },
    "family": "courbe",
    "variant": "closed",
    "scale": "full",
    "pathD": "M 100 32 A 68 68 0 1 0 100.1 32",
    "startXY": [
      100,
      32
    ],
    "endXY": [
      100,
      32
    ],
    "zone": "corps",
    "strokeColor": "#E05252",
    "badgeBg": "#FDEAEA",
    "badgeText": "#C03E3E"
  }
]
''');

final List<dynamic> POINTS = jsonDecode(r'''
[
  {
    "id": "point-center-full",
    "label": {
      "fr": "Le Point",
      "en": "The Dot",
      "es": "El Punto",
      "ar": "النقطة"
    },
    "consigne": {
      "fr": "Trace le point en faisant un petit rond circulaire dans le sens anti-horaire (vers la gauche).",
      "en": "Trace the dot by making a small round circle counter-clockwise (to the left).",
      "es": "Traza el punto haciendo un pequeño círculo redondo en sentido antihorario (hacia la izquierda).",
      "ar": "ارسم النقطة بتكوين دائرة صغيرة مستديرة عكس اتجاه عقارب الساعة (نحو اليسار)."
    },
    "family": "point",
    "variant": "center",
    "scale": "full",
    "pathD": "M 100 82 A 10 10 0 1 0 100.1 82",
    "startXY": [
      100,
      82
    ],
    "endXY": [
      100,
      82
    ],
    "zone": "corps",
    "strokeColor": "#4A3B2A",
    "badgeBg": "#FBF6EC",
    "badgeText": "#4A3B2A"
  }
]
''');

final List<dynamic> CROCHETS = jsonDecode(r'''
[
  {
    "id": "crochet-top-right-full",
    "label": {
      "fr": "Crochet haut-droite",
      "en": "Top-right hook",
      "es": "Gancho arriba-derecha",
      "ar": "خطاف أعلى اليمين"
    },
    "consigne": {
      "fr": "Trace le crochet haut droite en partant de l'extrémité haute puis en descendant la tige vers le bas.",
      "en": "Trace the top-right hook, starting at the top end then going down the stem.",
      "es": "Traza el gancho arriba a la derecha, partiendo del extremo superior y bajando luego por el tallo.",
      "ar": "ارسم الخطاف أعلى اليمين، بدءًا من الطرف العلوي ثم انزل بمحاذاة الساق نحو الأسفل."
    },
    "family": "crochet",
    "variant": "top-right",
    "scale": "full",
    "pathD": "M 150 70 A 45 45 0 0 0 60 70 L 60 170",
    "startXY": [
      150,
      70
    ],
    "endXY": [
      60,
      170
    ],
    "zone": "hampe",
    "strokeColor": "#4A90E2",
    "badgeBg": "#EAF1FB",
    "badgeText": "#2D6BBF"
  },
  {
    "id": "crochet-top-left-full",
    "label": {
      "fr": "Crochet haut-gauche",
      "en": "Top-left hook",
      "es": "Gancho arriba-izquierda",
      "ar": "خطاف أعلى اليسار"
    },
    "consigne": {
      "fr": "Trace le crochet haut gauche en partant de l'extrémité haute puis en descendant la tige vers le bas.",
      "en": "Trace the top-left hook, starting at the top end then going down the stem.",
      "es": "Traza el gancho arriba a la izquierda, partiendo del extremo superior y bajando luego por el tallo.",
      "ar": "ارسم الخطاف أعلى اليسار، بدءًا من الطرف العلوي ثم انزل بمحاذاة الساق نحو الأسفل."
    },
    "family": "crochet",
    "variant": "top-left",
    "scale": "full",
    "pathD": "M 50 70 A 45 45 0 0 1 140 70 L 140 170",
    "startXY": [
      50,
      70
    ],
    "endXY": [
      140,
      170
    ],
    "zone": "hampe",
    "strokeColor": "#4A90E2",
    "badgeBg": "#EAF1FB",
    "badgeText": "#2D6BBF"
  },
  {
    "id": "crochet-bottom-right-full",
    "label": {
      "fr": "Crochet bas-droite",
      "en": "Bottom-right hook",
      "es": "Gancho abajo-derecha",
      "ar": "خطاف أسفل اليمين"
    },
    "consigne": {
      "fr": "Trace le crochet bas droite : descends la tige puis courbe vers la droite en bas.",
      "en": "Trace the bottom-right hook: go down the stem, then curve to the right at the bottom.",
      "es": "Traza el gancho abajo a la derecha: baja por el tallo y luego curva hacia la derecha en la parte inferior.",
      "ar": "ارسم الخطاف أسفل اليمين: انزل بمحاذاة الساق ثم انحنِ نحو اليمين في الأسفل."
    },
    "family": "crochet",
    "variant": "bottom-right",
    "scale": "full",
    "pathD": "M 60 30 L 60 130 A 45 45 0 0 0 150 130",
    "startXY": [
      60,
      30
    ],
    "endXY": [
      150,
      130
    ],
    "zone": "jambe",
    "strokeColor": "#4A90E2",
    "badgeBg": "#EAF1FB",
    "badgeText": "#2D6BBF"
  },
  {
    "id": "crochet-bottom-left-full",
    "label": {
      "fr": "Crochet bas-gauche",
      "en": "Bottom-left hook",
      "es": "Gancho abajo-izquierda",
      "ar": "خطاف أسفل اليسار"
    },
    "consigne": {
      "fr": "Trace le crochet bas gauche, comme la lettre J.",
      "en": "Trace the bottom-left hook, like the letter J.",
      "es": "Traza el gancho abajo a la izquierda, como la letra J.",
      "ar": "ارسم الخطاف أسفل اليسار، مثل الحرف J."
    },
    "family": "crochet",
    "variant": "bottom-left",
    "scale": "full",
    "pathD": "M 140 30 L 140 130 A 45 45 0 0 1 50 130",
    "startXY": [
      140,
      30
    ],
    "endXY": [
      50,
      130
    ],
    "zone": "jambe",
    "strokeColor": "#4A90E2",
    "badgeBg": "#EAF1FB",
    "badgeText": "#2D6BBF"
  },
  {
    "id": "crochet-double-gauche-full",
    "label": {
      "fr": "Double-crochet gauche",
      "en": "Left double hook",
      "es": "Bucle izquierdo",
      "ar": "حلقة مزدوجة يسرى"
    },
    "consigne": {
      "fr": "Trace le double-crochet gauche : courbe en haut et en bas reliées à gauche.",
      "en": "Trace the left double hook: curves at the top and bottom joined on the left.",
      "es": "Traza el bucle izquierdo: curvas arriba y abajo unidas por la izquierda.",
      "ar": "ارسم الحلقة المزدوجة اليسرى: منحنيان في الأعلى والأسفل متصلان من اليسار."
    },
    "family": "crochet",
    "variant": "double-crochet-gauche",
    "scale": "full",
    "pathD": "M 65 55 C 65 25, 130 25, 130 80 L 130 120 C 130 175, 65 175, 65 145",
    "startXY": [
      65,
      55
    ],
    "endXY": [
      65,
      145
    ],
    "zone": "hampe",
    "strokeColor": "#4A90E2",
    "badgeBg": "#EAF1FB",
    "badgeText": "#2D6BBF"
  },
  {
    "id": "crochet-double-droit-full",
    "label": {
      "fr": "Double-crochet droit",
      "en": "Right double hook",
      "es": "Bucle derecho",
      "ar": "حلقة مزدوجة يمنى"
    },
    "consigne": {
      "fr": "Trace le double-crochet droit : courbe en haut et en bas reliées à droite.",
      "en": "Trace the right double hook: curves at the top and bottom joined on the right.",
      "es": "Traza el bucle derecho: curvas arriba y abajo unidas por la derecha.",
      "ar": "ارسم الحلقة المزدوجة اليمنى: منحنيان في الأعلى والأسفل متصلان من اليمين."
    },
    "family": "crochet",
    "variant": "double-crochet-droit",
    "scale": "full",
    "pathD": "M 135 55 C 135 25, 70 25, 70 80 L 70 120 C 70 175, 135 175, 135 145",
    "startXY": [
      135,
      55
    ],
    "endXY": [
      135,
      145
    ],
    "zone": "hampe",
    "strokeColor": "#4A90E2",
    "badgeBg": "#EAF1FB",
    "badgeText": "#2D6BBF"
  },
  {
    "id": "crochet-double-gauche-droit-full",
    "label": {
      "fr": "Double-crochet gauche-droit",
      "en": "Left-right double hook",
      "es": "Bucle izquierda-derecha",
      "ar": "حلقة مزدوجة يسار-يمين"
    },
    "consigne": {
      "fr": "Trace le double-crochet gauche et droit en forme de S.",
      "en": "Trace the left-right double hook in an S shape.",
      "es": "Traza el bucle izquierda-derecha en forma de S.",
      "ar": "ارسم الحلقة المزدوجة يسار-يمين على شكل حرف S."
    },
    "family": "crochet",
    "variant": "double-crochet-gauche-droit",
    "scale": "full",
    "pathD": "M 60 55 C 60 25, 100 25, 100 80 L 100 120 C 100 175, 140 175, 140 145",
    "startXY": [
      60,
      55
    ],
    "endXY": [
      140,
      145
    ],
    "zone": "hampe",
    "strokeColor": "#4A90E2",
    "badgeBg": "#EAF1FB",
    "badgeText": "#2D6BBF"
  },
  {
    "id": "crochet-double-droit-gauche-full",
    "label": {
      "fr": "Double-crochet droit-gauche",
      "en": "Right-left double hook",
      "es": "Bucle derecha-izquierda",
      "ar": "حلقة مزدوجة يمين-يسار"
    },
    "consigne": {
      "fr": "Trace le double-crochet droit et gauche en forme de Z adouci.",
      "en": "Trace the right-left double hook in a softened Z shape.",
      "es": "Traza el bucle derecha-izquierda en forma de Z suavizada.",
      "ar": "ارسم الحلقة المزدوجة يمين-يسار على شكل حرف Z ملطف."
    },
    "family": "crochet",
    "variant": "double-crochet-droit-gauche",
    "scale": "full",
    "pathD": "M 140 55 C 140 25, 100 25, 100 80 L 100 120 C 100 175, 60 175, 60 145",
    "startXY": [
      140,
      55
    ],
    "endXY": [
      60,
      145
    ],
    "zone": "hampe",
    "strokeColor": "#4A90E2",
    "badgeBg": "#EAF1FB",
    "badgeText": "#2D6BBF"
  }
]
''');

/// Catalogue combiné de tous les signes (toutes familles), pour les écrans
/// qui parcourent l'ensemble (cours de famille, cahier d'écriture...).
final List<dynamic> EXERCISE_CATALOG = [
  ...TRAITS,
  ...COURBES,
  ...CROCHETS,
  ...POINTS,
];

final Map<String, dynamic> EXERCISE_MAP = {
  for (final e in EXERCISE_CATALOG) e['id'] as String: e,
};

/// Ordre du Palier 1 (voir parcours_screen.dart) : sert à la navigation
/// entre les cours/exercices de chaque famille.
const List<String> FAMILY_ORDER = ['trait', 'crochet', 'courbe', 'point'];
