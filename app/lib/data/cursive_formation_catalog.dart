import 'dart:convert';

/// CATALOGUE CURSIF — extrait/résolu depuis Web (src/data/cursive-formation-catalog.ts), tracés déjà calculés (plus de système de tampons procédural ici).
final List<dynamic> CURSIVE_LETTERS = jsonDecode(r'''
[
  {
    "char": "x",
    "name": {
      "fr": "x cursif",
      "en": "cursive x",
      "es": "x cursiva",
      "ar": "x بخط متصل"
    },
    "category": "consonne",
    "zone": "corps",
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 63.86 77.70 L 67.20 76.29 L 70.72 75.39 L 74.33 75.00 L 77.96 75.14 L 81.53 75.81 L 84.97 76.99 L 88.19 78.66 L 91.14 80.78 L 93.75 83.30 L 95.97 86.18 L 97.74 89.35 L 99.04 92.74 L 99.83 96.29 L 100.09 99.91 L 99.83 103.53 L 99.04 107.08 L 97.74 110.47 L 95.97 113.64 L 93.75 116.51 L 91.14 119.04 L 88.19 121.16 L 84.97 122.82 L 81.53 124.00 L 77.96 124.67 L 74.33 124.82 L 70.72 124.43 L 67.20 123.52 L 63.86 122.11",
        "startXY": [
          63.86,
          77.7
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1",
          "es": "Traza la curva n.º1",
          "ar": "ارسم منحنى رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 136.14 77.89 L 132.80 76.48 L 129.28 75.57 L 125.67 75.18 L 122.04 75.33 L 118.47 76.00 L 115.03 77.18 L 111.81 78.84 L 108.86 80.96 L 106.25 83.49 L 104.03 86.36 L 102.26 89.53 L 100.96 92.92 L 100.17 96.47 L 99.91 100.09 L 100.17 103.71 L 100.96 107.26 L 102.26 110.65 L 104.03 113.82 L 106.25 116.70 L 108.86 119.22 L 111.81 121.34 L 115.03 123.01 L 118.47 124.19 L 122.04 124.86 L 125.67 125.00 L 129.28 124.61 L 132.80 123.71 L 136.14 122.30",
        "startXY": [
          136.14,
          77.89
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"x\" s'écrit d'un geste lié : courbe puis courbe.",
      "en": "In cursive, the letter \"x\" is written in one connected gesture: curve then curve.",
      "es": "En cursiva, la letra \"x\" se escribe en un solo gesto: curva y luego curva.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"x\" بحركة واحدة متصلة: منحنى ثم منحنى."
    }
  },
  {
    "char": "C",
    "name": {
      "fr": "C cursif",
      "en": "cursive C",
      "es": "C cursiva",
      "ar": "C بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 91.43 15.00 L 90.11 17.61 L 89.09 20.36 L 88.38 23.20 L 88.00 26.10 L 87.95 29.03 L 88.22 31.94 L 88.82 34.81 L 89.73 37.59 L 90.95 40.25 L 92.47 42.76 L 94.25 45.08 L 96.28 47.19 L 98.53 49.06 L 100.98 50.66 L 103.60 51.98 L 106.34 53.00 L 109.18 53.71 L 112.09 54.09 L 115.01 54.14 L 117.93 53.87 L 120.79 53.27 L 123.58 52.36 L 126.24 51.14 L 128.74 49.62 L 131.07 47.84 L 133.18 45.81 L 135.04 43.56 L 136.65 41.11",
        "startXY": [
          91.43,
          15
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1",
          "es": "Traza la curva n.º1",
          "ar": "ارسم منحنى رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 137.31 39.99 L 131.02 36.13 L 124.21 33.31 L 117.04 31.59 L 109.69 31.01 L 102.33 31.59 L 95.16 33.31 L 88.35 36.13 L 82.06 39.99 L 76.46 44.78 L 71.67 50.38 L 67.81 56.67 L 64.99 63.48 L 63.27 70.65 L 62.69 78.01 L 63.27 85.36 L 64.99 92.53 L 67.81 99.34 L 71.67 105.63 L 76.46 111.24 L 82.06 116.03 L 88.35 119.88 L 95.16 122.70 L 102.33 124.42 L 109.69 125.00 L 117.04 124.42 L 124.21 122.70 L 131.02 119.88 L 137.31 116.03",
        "startXY": [
          137.31,
          39.99
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"C\" s'écrit d'un geste lié : courbe puis courbe.",
      "en": "In cursive, the letter \"C\" is written in one connected gesture: curve then curve.",
      "es": "En cursiva, la letra \"C\" se escribe en un solo gesto: curva y luego curva.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"C\" بحركة واحدة متصلة: منحنى ثم منحنى."
    }
  },
  {
    "char": "E",
    "name": {
      "fr": "E cursif",
      "en": "cursive E",
      "es": "E cursiva",
      "ar": "E بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 87.05 15.00 A 15.73 18.78 0 1 0 111.13 39.12",
        "startXY": [
          87.05,
          15.00
        ],
        "strokeColor": "#E05252",
        "zIndex": 3,
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1",
          "es": "Traza la curva n.º1",
          "ar": "ارسم منحنى رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 110.83 38.35 A 18.60 22.20 0 1 0 100.84 75.09",
        "startXY": [
          110.83,
          38.35
        ],
        "strokeColor": "#E05252",
        "zIndex": 2,
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 100.75 75.05 A 20.92 24.98 0 1 0 121.25 96.33",
        "startXY": [
          100.75,
          75.05
        ],
        "strokeColor": "#E05252",
        "zIndex": 1,
        "description": {
          "fr": "Trace le courbe n°3",
          "en": "Trace the curve #3",
          "es": "Traza la curva n.º3",
          "ar": "ارسم منحنى رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"E\" s'écrit d'un geste lié : courbe, courbe puis courbe.",
      "en": "In cursive, the letter \"E\" is written in one connected gesture: curve, curve then curve.",
      "es": "En cursiva, la letra \"E\" se escribe en un solo gesto: curva, curva y luego curva.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"E\" بحركة واحدة متصلة: منحنى، منحنى ثم منحنى."
    }
  },
  {
    "char": "F",
    "name": {
      "fr": "F cursif",
      "en": "cursive F",
      "es": "F cursiva",
      "ar": "F بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 83.82 16.45 L 83.82 105.82 L 83.70 107.95 L 83.35 110.06 L 82.76 112.11 L 81.95 114.08 L 80.93 115.95 L 79.70 117.70 L 78.29 119.30 L 76.71 120.73 L 74.98 121.98 L 73.13 123.02 L 71.16 123.86 L 69.12 124.47 L 67.02 124.85 L 64.89 125.00 L 62.76 124.91 L 60.66 124.58 L 58.60 124.02 L 56.61 123.24 L 54.73 122.24 L 52.97 121.04 L 51.35 119.65 L 49.90 118.09 L 48.63 116.37 L 47.56 114.53",
        "startXY": [
          83.82,
          16.45
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 55.29 50.94 L 53.48 49.80 L 51.81 48.47 L 50.30 46.97 L 48.97 45.30 L 47.83 43.50 L 46.90 41.58 L 46.18 39.57 L 45.70 37.50 L 45.44 35.38 L 45.43 33.25 L 45.65 31.12 L 46.10 29.04 L 46.79 27.02 L 47.69 25.09 L 48.80 23.27 L 50.11 21.58 L 51.60 20.05 L 53.24 18.70 L 55.03 17.54 L 56.94 16.58 L 58.94 15.84 L 61.01 15.32 L 63.12 15.04 L 65.25 15.00 L 154.57 18.12",
        "startXY": [
          55.29,
          50.94
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2",
          "es": "Traza el gancho n.º2",
          "ar": "ارسم خطاف رقم 2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 82.92 71.16 L 137.19 72.10",
        "startXY": [
          82.92,
          71.16
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3",
          "es": "Traza el trazo n.º3",
          "ar": "ارسم خط رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"F\" s'écrit d'un geste lié : crochet, crochet puis trait.",
      "en": "In cursive, the letter \"F\" is written in one connected gesture: hook, hook then line.",
      "es": "En cursiva, la letra \"F\" se escribe en un solo gesto: gancho, gancho y luego trazo.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"F\" بحركة واحدة متصلة: خطاف، خطاف ثم خط."
    }
  },
  {
    "char": "H",
    "name": {
      "fr": "H cursif",
      "en": "cursive H",
      "es": "H cursiva",
      "ar": "H بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 58.67 23.77 L 58.29 23.32 L 57.96 22.84 L 57.68 22.32 L 57.47 21.78 L 57.32 21.21 L 57.24 20.63 L 57.22 20.05 L 57.26 19.47 L 57.38 18.89 L 57.55 18.33 L 57.79 17.80 L 58.09 17.30 L 58.44 16.83 L 58.84 16.40 L 59.29 16.03 L 59.78 15.70 L 60.30 15.44 L 60.85 15.23 L 61.41 15.09 L 61.99 15.01 L 62.58 15.00 L 63.16 15.05 L 63.73 15.17 L 64.29 15.36 L 64.82 15.60 L 92.89 30.53",
        "startXY": [
          58.67,
          23.77
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 92.56 30.90 L 92.56 123.33",
        "startXY": [
          92.56,
          30.9
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2",
          "es": "Traza el trazo n.º2",
          "ar": "ارسم خط رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 92.85 124.13 L 91.44 124.58 L 90.00 124.87 L 88.53 125.00 L 87.05 124.97 L 85.59 124.77 L 84.16 124.41 L 82.78 123.90 L 81.46 123.23 L 80.22 122.42 L 79.09 121.48 L 78.06 120.42 L 77.16 119.25 L 76.39 117.99 L 75.77 116.66 L 75.30 115.26 L 74.99 113.82 L 74.84 112.35 L 74.85 110.87 L 75.03 109.41 L 75.37 107.97 L 75.87 106.58 L 76.52 105.26 L 77.31 104.01 L 78.23 102.86 L 119.61 56.91",
        "startXY": [
          92.85,
          124.13
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3",
          "es": "Traza el gancho n.º3",
          "ar": "ارسم خطاف رقم 3"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 98.53 80.76 L 140.25 32.76 L 140.97 31.84 L 141.58 30.84 L 142.07 29.78 L 142.43 28.66 L 142.67 27.52 L 142.78 26.35 L 142.76 25.18 L 142.61 24.02 L 142.32 22.89 L 141.91 21.79 L 141.38 20.75 L 140.73 19.78 L 139.98 18.88 L 139.13 18.07 L 138.20 17.37 L 137.19 16.77 L 136.12 16.30 L 135.01 15.94 L 133.86 15.72 L 132.69 15.62 L 131.52 15.66 L 130.36 15.83 L 129.23 16.13 L 128.14 16.55 L 127.11 17.10",
        "startXY": [
          98.53,
          80.76
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°4",
          "en": "Trace the hook #4",
          "es": "Traza el gancho n.º4",
          "ar": "ارسم خطاف رقم 4"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 142.65 22.69 L 142.21 21.60 L 141.65 20.58 L 140.97 19.62 L 140.20 18.75 L 139.32 17.97 L 138.37 17.29 L 137.34 16.72 L 136.26 16.28 L 135.14 15.96 L 133.98 15.77 L 132.81 15.71 L 131.65 15.78 L 130.49 15.98 L 129.37 16.31 L 128.30 16.77 L 127.28 17.34 L 126.33 18.03 L 125.46 18.82 L 124.69 19.70 L 124.03 20.66 L 123.48 21.70 L 123.05 22.78 L 122.74 23.91 L 122.56 25.07 L 122.52 26.24 L 123.62 89.82",
        "startXY": [
          142.65,
          22.69
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°5",
          "en": "Trace the hook #5",
          "es": "Traza el gancho n.º5",
          "ar": "ارسم خطاف رقم 5"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 123.36 78.46 L 123.36 116.68 L 123.41 117.58 L 123.56 118.46 L 123.81 119.32 L 124.15 120.14 L 124.58 120.93 L 125.10 121.66 L 125.70 122.32 L 126.36 122.92 L 127.09 123.44 L 127.87 123.88 L 128.70 124.22 L 129.55 124.47 L 130.44 124.62 L 131.33 124.68 L 132.22 124.63 L 133.10 124.48 L 133.96 124.24 L 134.79 123.90 L 135.58 123.47 L 136.31 122.96 L 136.98 122.37 L 137.58 121.71 L 138.10 120.98 L 138.54 120.20",
        "startXY": [
          123.36,
          78.46
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°6",
          "en": "Trace the hook #6",
          "es": "Traza el gancho n.º6",
          "ar": "ارسم خطاف رقم 6"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"H\" s'écrit d'un geste lié : crochet, trait, crochet, crochet, crochet puis crochet.",
      "en": "In cursive, the letter \"H\" is written in one connected gesture: hook, line, hook, hook, hook then hook.",
      "es": "En cursiva, la letra \"H\" se escribe en un solo gesto: gancho, trazo, gancho, gancho, gancho y luego gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"H\" بحركة واحدة متصلة: خطاف، خط، خطاف، خطاف، خطاف ثم خطاف."
    }
  },
  {
    "char": "I",
    "name": {
      "fr": "I cursif",
      "en": "cursive I",
      "es": "I cursiva",
      "ar": "I بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 59.07 51.78 L 57.25 50.48 L 55.60 48.98 L 54.11 47.31 L 52.83 45.49 L 51.76 43.53 L 50.91 41.46 L 50.30 39.32 L 49.93 37.12 L 49.81 34.89 L 49.94 32.66 L 50.32 30.46 L 50.95 28.31 L 51.80 26.25 L 52.89 24.30 L 54.18 22.48 L 55.67 20.82 L 57.34 19.34 L 59.16 18.05 L 61.12 16.97 L 63.18 16.12 L 65.32 15.50 L 67.52 15.12 L 69.75 15.00 L 150.19 15.00",
        "startXY": [
          59.07,
          51.78
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 102.61 16.05 L 102.61 103.75 L 102.48 106.14 L 102.08 108.50 L 101.41 110.80 L 100.49 113.01 L 99.33 115.10 L 97.94 117.05 L 96.34 118.83 L 94.55 120.42 L 92.59 121.79 L 90.49 122.94 L 88.28 123.85 L 85.97 124.50 L 83.61 124.88 L 81.22 125.00 L 78.83 124.85 L 76.48 124.43 L 74.18 123.75 L 71.98 122.81 L 69.90 121.64 L 67.96 120.24 L 66.19 118.62 L 64.62 116.82 L 63.25 114.86",
        "startXY": [
          102.61,
          16.05
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2",
          "es": "Traza el gancho n.º2",
          "ar": "ارسم خطاف رقم 2"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"I\" s'écrit d'un geste lié : crochet puis crochet.",
      "en": "In cursive, the letter \"I\" is written in one connected gesture: hook then hook.",
      "es": "En cursiva, la letra \"I\" se escribe en un solo gesto: gancho y luego gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"I\" بحركة واحدة متصلة: خطاف ثم خطاف."
    }
  },
  {
    "char": "J",
    "name": {
      "fr": "J cursif",
      "en": "cursive J",
      "es": "J cursiva",
      "ar": "J بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 67.59 44.12 L 66.15 43.10 L 64.84 41.91 L 63.66 40.59 L 62.65 39.14 L 61.80 37.59 L 61.13 35.96 L 60.64 34.26 L 60.35 32.51 L 60.26 30.75 L 60.36 28.98 L 60.66 27.24 L 61.15 25.54 L 61.83 23.91 L 62.69 22.37 L 63.72 20.93 L 64.90 19.61 L 66.22 18.43 L 67.66 17.41 L 69.21 16.56 L 70.84 15.88 L 72.54 15.39 L 74.28 15.10 L 76.05 15.00 L 139.74 15.00",
        "startXY": [
          67.59,
          44.12
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 99.62 16.93 L 99.62 122.11",
        "startXY": [
          99.62,
          16.93
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2",
          "es": "Traza el trazo n.º2",
          "ar": "ارسم خط رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 98.50 124.28 L 96.71 124.72 L 94.90 124.96 L 93.06 125.00 L 91.23 124.84 L 89.44 124.47 L 87.69 123.91 L 86.01 123.17 L 84.43 122.24 L 82.96 121.14 L 81.62 119.88 L 80.43 118.49 L 79.40 116.97 L 78.54 115.35 L 77.86 113.64 L 77.38 111.87 L 77.10 110.06 L 77.02 108.23 L 77.14 106.40 L 77.46 104.59 L 77.98 102.83 L 78.70 101.14 L 79.59 99.54 L 80.66 98.04 L 81.88 96.68 L 135.22 43.33",
        "startXY": [
          98.5,
          124.28
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3",
          "es": "Traza el gancho n.º3",
          "ar": "ارسم خطاف رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"J\" s'écrit d'un geste lié : crochet, trait puis crochet.",
      "en": "In cursive, the letter \"J\" is written in one connected gesture: hook, line then hook.",
      "es": "En cursiva, la letra \"J\" se escribe en un solo gesto: gancho, trazo y luego gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"J\" بحركة واحدة متصلة: خطاف، خط ثم خطاف."
    }
  },
  {
    "char": "K",
    "name": {
      "fr": "K cursif",
      "en": "cursive K",
      "es": "K cursiva",
      "ar": "K بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 63.43 20.22 L 63.58 19.54 L 63.80 18.88 L 64.10 18.25 L 64.46 17.66 L 64.89 17.11 L 65.37 16.62 L 65.91 16.18 L 66.50 15.80 L 67.12 15.49 L 67.77 15.26 L 68.45 15.09 L 69.14 15.01 L 69.83 15.00 L 70.52 15.07 L 71.20 15.22 L 71.86 15.44 L 72.49 15.73 L 73.08 16.10 L 73.63 16.52 L 74.13 17.01 L 74.57 17.55 L 85.49 32.59",
        "startXY": [
          63.43,
          20.22
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 85.72 32.51 L 85.72 107.38 L 85.62 109.09 L 85.33 110.78 L 84.86 112.43 L 84.20 114.02 L 83.36 115.52 L 82.37 116.92 L 81.22 118.20 L 79.94 119.34 L 78.53 120.33 L 77.03 121.15 L 75.44 121.80 L 73.79 122.27 L 72.09 122.55 L 70.38 122.64 L 68.66 122.53 L 66.97 122.23 L 65.33 121.75 L 63.74 121.08 L 62.25 120.24 L 60.85 119.24 L 59.58 118.08 L 58.45 116.79 L 57.47 115.38 L 56.65 113.87",
        "startXY": [
          85.72,
          32.51
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2",
          "es": "Traza el gancho n.º2",
          "ar": "ارسم خطاف رقم 2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 87.22 74.01 L 105.25 74.01",
        "startXY": [
          87.22,
          74.01
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3",
          "es": "Traza el trazo n.º3",
          "ar": "ارسم خط رقم 3"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 143.35 30.43 L 143.18 29.33 L 142.88 28.27 L 142.46 27.24 L 141.94 26.27 L 141.31 25.36 L 140.58 24.52 L 139.77 23.77 L 138.87 23.12 L 137.91 22.57 L 136.90 22.13 L 135.84 21.81 L 134.75 21.60 L 133.65 21.52 L 132.54 21.56 L 131.45 21.72 L 130.38 22.00 L 129.35 22.40 L 128.37 22.92 L 127.45 23.53 L 126.60 24.25 L 125.85 25.05 L 125.18 25.94 L 124.62 26.89 L 124.16 27.90 L 107.54 71.20",
        "startXY": [
          143.35,
          30.43
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°4",
          "en": "Trace the hook #4",
          "es": "Traza el gancho n.º4",
          "ar": "ارسم خطاف رقم 4"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 107.43 73.22 L 120.22 117.80 L 120.58 118.85 L 121.06 119.84 L 121.64 120.78 L 122.33 121.65 L 123.11 122.44 L 123.97 123.13 L 124.90 123.73 L 125.89 124.22 L 126.94 124.59 L 128.01 124.85 L 129.11 124.99 L 130.22 125.00 L 131.32 124.89 L 132.40 124.66 L 133.45 124.31 L 134.45 123.84 L 135.40 123.27 L 136.28 122.60 L 137.08 121.83 L 137.78 120.98 L 138.39 120.05 L 138.89 119.07 L 139.28 118.03 L 139.55 116.96",
        "startXY": [
          107.43,
          73.22
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°5",
          "en": "Trace the hook #5",
          "es": "Traza el gancho n.º5",
          "ar": "ارسم خطاف رقم 5"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"K\" s'écrit d'un geste lié : crochet, crochet, trait, crochet puis crochet.",
      "en": "In cursive, the letter \"K\" is written in one connected gesture: hook, hook, line, hook then hook.",
      "es": "En cursiva, la letra \"K\" se escribe en un solo gesto: gancho, gancho, trazo, gancho y luego gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"K\" بحركة واحدة متصلة: خطاف، خطاف، خط، خطاف ثم خطاف."
    }
  },
  {
    "char": "L",
    "name": {
      "fr": "L cursif",
      "en": "cursive L",
      "es": "L cursiva",
      "ar": "L بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 61.46 25.76 L 61.72 29.30 L 62.38 32.80 L 63.42 36.19 L 64.84 39.45 L 66.61 42.53 L 68.72 45.39 L 71.13 48.00 L 73.82 50.32 L 76.75 52.32 L 79.89 53.99 L 83.20 55.29 L 86.63 56.21 L 90.14 56.75 L 93.69 56.88 L 97.23 56.62 L 100.72 55.97 L 104.12 54.92 L 107.38 53.51 L 110.46 51.73 L 113.32 49.63 L 115.92 47.21 L 118.24 44.52 L 120.25 41.59 L 121.91 38.45 L 123.22 35.15 L 124.14 31.72 L 124.67 28.20 L 124.81 24.65",
        "startXY": [
          61.46,
          25.76
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1",
          "es": "Traza la curva n.º1",
          "ar": "ارسم منحنى رقم 1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 125.06 22.87 L 124.01 21.34 L 122.78 19.94 L 121.41 18.69 L 119.91 17.61 L 118.29 16.69 L 116.59 15.97 L 114.81 15.44 L 112.98 15.12 L 111.13 15.00 L 109.28 15.09 L 107.45 15.39 L 105.66 15.90 L 103.94 16.60 L 102.31 17.49 L 100.80 18.55 L 99.41 19.78 L 98.17 21.16 L 97.09 22.67 L 96.19 24.30 L 95.48 26.01 L 94.96 27.79 L 94.65 29.62 L 94.54 31.47 L 94.54 99.48",
        "startXY": [
          125.06,
          22.87
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2",
          "es": "Traza el gancho n.º2",
          "ar": "ارسم خطاف رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 94.54 82.76 L 94.54 119.86 L 94.51 120.43 L 94.42 121.00 L 94.26 121.55 L 94.04 122.08 L 93.76 122.59 L 93.43 123.05 L 93.05 123.48 L 92.62 123.87 L 92.16 124.20 L 91.65 124.48 L 91.12 124.70 L 90.57 124.87 L 90.01 124.96 L 89.43 125.00 L 88.86 124.97 L 88.29 124.88 L 87.74 124.72 L 87.21 124.51 L 86.71 124.23 L 86.23 123.91 L 85.80 123.53 L 85.42 123.10 L 85.08 122.64 L 84.80 122.14 L 84.57 121.61 L 84.41 121.06",
        "startXY": [
          94.54,
          82.76
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3",
          "es": "Traza el gancho n.º3",
          "ar": "ارسم خطاف رقم 3"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 85.74 121.48 L 131.54 121.48 L 132.34 121.43 L 133.13 121.30 L 133.89 121.07 L 134.63 120.76 L 135.33 120.37 L 135.98 119.89 L 136.57 119.35 L 137.09 118.75 L 137.54 118.09 L 137.91 117.38 L 138.20 116.63 L 138.41 115.86 L 138.52 115.06 L 138.54 114.26 L 138.47 113.47 L 138.31 112.68 L 138.06 111.92 L 137.73 111.19 L 137.31 110.51 L 136.82 109.88 L 136.26 109.30 L 135.64 108.80 L 134.97 108.37 L 134.25 108.02 L 133.49 107.75",
        "startXY": [
          85.74,
          121.48
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°4",
          "en": "Trace the hook #4",
          "es": "Traza el gancho n.º4",
          "ar": "ارسم خطاف رقم 4"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"L\" s'écrit d'un geste lié : courbe, crochet, crochet puis crochet.",
      "en": "In cursive, the letter \"L\" is written in one connected gesture: curve, hook, hook then hook.",
      "es": "En cursiva, la letra \"L\" se escribe en un solo gesto: curva, gancho, gancho y luego gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"L\" بحركة واحدة متصلة: منحنى، خطاف، خطاف ثم خطاف."
    }
  },
  {
    "char": "M",
    "name": {
      "fr": "M cursif",
      "en": "cursive M",
      "es": "M cursiva",
      "ar": "M بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 35.38 114.45 L 36.16 116.13 L 37.11 117.71 L 38.23 119.17 L 39.51 120.51 L 40.93 121.69 L 42.46 122.71 L 44.11 123.55 L 45.83 124.21 L 47.62 124.68 L 49.44 124.94 L 51.29 125.00 L 53.13 124.86 L 54.94 124.51 L 56.71 123.97 L 58.40 123.23 L 60.00 122.31 L 61.49 121.22 L 62.85 119.98 L 64.07 118.59 L 65.12 117.07 L 66.00 115.45 L 66.70 113.74 L 67.21 111.97 L 67.51 110.15 L 67.61 108.30 L 67.61 17.02",
        "startXY": [
          35.38,
          114.45
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 69.99 17.82 L 101.68 77.41",
        "startXY": [
          69.99,
          17.82
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2",
          "es": "Traza el trazo n.º2",
          "ar": "ارسم خط رقم 2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 101.86 76.15 L 131.44 15.49",
        "startXY": [
          101.86,
          76.15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3",
          "es": "Traza el trazo n.º3",
          "ar": "ارسم خط رقم 3"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 131.72 15.00 L 131.72 105.88 L 131.83 107.76 L 132.14 109.61 L 132.65 111.42 L 133.35 113.16 L 134.24 114.82 L 135.31 116.36 L 136.54 117.78 L 137.92 119.06 L 139.44 120.17 L 141.06 121.12 L 142.78 121.88 L 144.57 122.44 L 146.41 122.81 L 148.28 122.97 L 150.16 122.93 L 152.03 122.68 L 153.85 122.22 L 155.61 121.57 L 157.29 120.73 L 158.87 119.71 L 160.33 118.53 L 161.65 117.19 L 162.81 115.71 L 163.80 114.12 L 164.62 112.43",
        "startXY": [
          131.72,
          15
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°4",
          "en": "Trace the hook #4",
          "es": "Traza el gancho n.º4",
          "ar": "ارسم خطاف رقم 4"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"M\" s'écrit d'un geste lié : crochet, trait, trait puis crochet.",
      "en": "In cursive, the letter \"M\" is written in one connected gesture: hook, line, line then hook.",
      "es": "En cursiva, la letra \"M\" se escribe en un solo gesto: gancho, trazo, trazo y luego gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"M\" بحركة واحدة متصلة: خطاف، خط، خط ثم خطاف."
    }
  },
  {
    "char": "N",
    "name": {
      "fr": "N cursif",
      "en": "cursive N",
      "es": "N cursiva",
      "ar": "N بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 43.39 114.66 L 44.15 116.30 L 45.09 117.85 L 46.19 119.29 L 47.44 120.60 L 48.83 121.76 L 50.33 122.76 L 51.94 123.58 L 53.63 124.23 L 55.38 124.68 L 57.17 124.94 L 58.98 125.00 L 60.78 124.86 L 62.56 124.52 L 64.29 123.99 L 65.95 123.27 L 67.52 122.37 L 68.98 121.30 L 70.31 120.08 L 71.51 118.72 L 72.54 117.23 L 73.40 115.64 L 74.09 113.97 L 74.58 112.23 L 74.88 110.44 L 74.98 108.64 L 74.98 19.18",
        "startXY": [
          43.39,
          114.66
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 75.62 19.87 L 125.48 122.11",
        "startXY": [
          75.62,
          19.87
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2",
          "es": "Traza el trazo n.º2",
          "ar": "ارسم خط رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 125.02 120.82 L 125.02 31.36 L 125.12 29.56 L 125.42 27.77 L 125.91 26.03 L 126.60 24.36 L 127.46 22.77 L 128.49 21.28 L 129.69 19.92 L 131.02 18.70 L 132.48 17.63 L 134.05 16.73 L 135.71 16.01 L 137.44 15.48 L 139.22 15.14 L 141.02 15.00 L 142.83 15.06 L 144.62 15.32 L 146.37 15.77 L 148.06 16.42 L 149.67 17.24 L 151.17 18.24 L 152.56 19.40 L 153.81 20.71 L 154.91 22.15 L 155.85 23.70 L 156.61 25.34",
        "startXY": [
          125.02,
          120.82
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3",
          "es": "Traza el gancho n.º3",
          "ar": "ارسم خطاف رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"N\" s'écrit d'un geste lié : crochet, trait puis crochet.",
      "en": "In cursive, the letter \"N\" is written in one connected gesture: hook, line then hook.",
      "es": "En cursiva, la letra \"N\" se escribe en un solo gesto: gancho, trazo y luego gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"N\" بحركة واحدة متصلة: خطاف، خط ثم خطاف."
    }
  },
  {
    "char": "Ñ",
    "name": {
      "fr": "Ñ cursif",
      "en": "cursive Ñ",
      "es": "Ñ cursiva",
      "ar": "Ñ بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 66.43 118.87 L 66.88 119.84 L 67.44 120.76 L 68.09 121.61 L 68.83 122.39 L 69.66 123.08 L 70.55 123.67 L 71.50 124.16 L 72.51 124.54 L 73.54 124.81 L 74.61 124.96 L 75.68 125.00 L 76.75 124.92 L 77.80 124.72 L 78.83 124.40 L 79.81 123.97 L 80.74 123.44 L 81.61 122.81 L 82.40 122.08 L 83.10 121.27 L 83.72 120.39 L 84.23 119.45 L 84.63 118.46 L 84.93 117.43 L 85.10 116.37 L 85.16 115.30 L 85.16 62.26",
        "startXY": [
          66.43,
          118.87
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 85.54 62.66 L 115.11 123.29",
        "startXY": [
          85.54,
          62.66
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2",
          "es": "Traza el trazo n.º2",
          "ar": "ارسم خط رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 114.84 122.52 L 114.84 69.48 L 114.90 68.41 L 115.07 67.35 L 115.37 66.32 L 115.77 65.32 L 116.28 64.38 L 116.90 63.50 L 117.60 62.69 L 118.39 61.97 L 119.26 61.34 L 120.19 60.80 L 121.17 60.38 L 122.20 60.06 L 123.25 59.86 L 124.32 59.77 L 125.39 59.81 L 126.46 59.96 L 127.49 60.23 L 128.50 60.61 L 129.45 61.11 L 130.34 61.70 L 131.17 62.39 L 131.91 63.16 L 132.56 64.01 L 133.12 64.93 L 133.57 65.90",
        "startXY": [
          114.84,
          122.52
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3",
          "es": "Traza el gancho n.º3",
          "ar": "ارسم خطاف رقم 3"
        }
      },
      {
        "family": "crochet",
        "variant": "hd-bg",
        "pathD": "M 105.29 26.90 L 105.15 25.57 L 104.71 24.32 L 104.00 23.19 L 103.05 22.25 L 101.93 21.54 L 100.67 21.10 L 99.35 20.95 L 83.79 20.95 L 82.47 20.80 L 81.21 20.36 L 80.08 19.65 L 79.14 18.71 L 78.43 17.58 L 77.99 16.32 L 77.84 15.00",
        "startXY": [
          105.29,
          26.9
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le boucle de liaison n°4",
          "en": "Trace the connecting loop #4",
          "es": "Traza el bucle de enlace n.º4",
          "ar": "ارسم حلقة وصل رقم 4"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"Ñ\" s'écrit d'un geste lié : crochet, trait, crochet puis boucle de liaison.",
      "en": "In cursive, the letter \"Ñ\" is written in one connected gesture: hook, line, hook then connecting loop.",
      "es": "En cursiva, la letra \"Ñ\" se escribe en un solo gesto: gancho, trazo, gancho y luego bucle de enlace.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"Ñ\" بحركة واحدة متصلة: خطاف، خط، خطاف ثم حلقة وصل."
    }
  },
  {
    "char": "T",
    "name": {
      "fr": "T cursif",
      "en": "cursive T",
      "es": "T cursiva",
      "ar": "T بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 61.89 42.07 L 60.45 41.46 L 59.09 40.70 L 57.83 39.78 L 56.68 38.74 L 55.64 37.57 L 54.75 36.29 L 54.01 34.92 L 53.42 33.47 L 53.00 31.97 L 52.74 30.44 L 52.66 28.88 L 52.76 27.32 L 53.03 25.79 L 53.46 24.29 L 54.07 22.85 L 54.83 21.49 L 55.73 20.22 L 56.77 19.06 L 57.94 18.02 L 59.21 17.12 L 60.58 16.37 L 62.02 15.78 L 63.52 15.35 L 65.06 15.09 L 66.61 15.00 L 147.34 15.00",
        "startXY": [
          61.89,
          42.07
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 101.80 16.80 L 101.80 106.28 L 101.92 108.37 L 102.27 110.44 L 102.85 112.45 L 103.65 114.38 L 104.66 116.22 L 105.87 117.93 L 107.26 119.49 L 108.82 120.89 L 110.52 122.11 L 112.35 123.12 L 114.28 123.93 L 116.29 124.52 L 118.36 124.87 L 120.45 125.00 L 122.54 124.89 L 124.60 124.55 L 126.62 123.98 L 128.56 123.19 L 130.40 122.18 L 132.11 120.98 L 133.68 119.60 L 135.08 118.04 L 136.31 116.34 L 137.33 114.52",
        "startXY": [
          101.8,
          16.8
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2",
          "es": "Traza el gancho n.º2",
          "ar": "ارسم خطاف رقم 2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 74.75 61.89 L 128.85 61.89",
        "startXY": [
          74.75,
          61.89
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3",
          "es": "Traza el trazo n.º3",
          "ar": "ارسم خط رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"T\" s'écrit d'un geste lié : crochet, crochet puis trait.",
      "en": "In cursive, the letter \"T\" is written in one connected gesture: hook, hook then line.",
      "es": "En cursiva, la letra \"T\" se escribe en un solo gesto: gancho, gancho y luego trazo.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"T\" بحركة واحدة متصلة: خطاف، خطاف ثم خط."
    }
  },
  {
    "char": "X",
    "name": {
      "fr": "X cursif",
      "en": "cursive X",
      "es": "X cursiva",
      "ar": "X بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 19.69 20.95 L 27.07 17.85 L 34.82 15.85 L 42.78 15.00 L 50.77 15.31 L 58.64 16.79 L 66.21 19.39 L 73.32 23.06 L 79.82 27.73 L 85.57 33.29 L 90.46 39.63 L 94.37 46.61 L 97.22 54.09 L 98.96 61.90 L 99.54 69.89 L 98.96 77.87 L 97.22 85.68 L 94.37 93.16 L 90.46 100.14 L 85.57 106.48 L 79.82 112.04 L 73.32 116.71 L 66.21 120.38 L 58.64 122.98 L 50.77 124.46 L 42.78 124.77 L 34.82 123.92 L 27.07 121.92 L 19.69 118.82",
        "startXY": [
          19.69,
          20.95
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1",
          "es": "Traza la curva n.º1",
          "ar": "ارسم منحنى رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 180.31 21.18 L 172.93 18.08 L 165.18 16.08 L 157.22 15.23 L 149.23 15.54 L 141.36 17.02 L 133.79 19.62 L 126.68 23.29 L 120.18 27.96 L 114.43 33.52 L 109.54 39.86 L 105.63 46.84 L 102.78 54.32 L 101.04 62.13 L 100.46 70.11 L 101.04 78.10 L 102.78 85.91 L 105.63 93.39 L 109.54 100.37 L 114.43 106.71 L 120.18 112.27 L 126.68 116.94 L 133.79 120.61 L 141.36 123.21 L 149.23 124.69 L 157.22 125.00 L 165.18 124.15 L 172.93 122.15 L 180.31 119.05",
        "startXY": [
          180.31,
          21.18
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"X\" s'écrit d'un geste lié : courbe puis courbe.",
      "en": "In cursive, the letter \"X\" is written in one connected gesture: curve then curve.",
      "es": "En cursiva, la letra \"X\" se escribe en un solo gesto: curva y luego curva.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"X\" بحركة واحدة متصلة: منحنى ثم منحنى."
    }
  },
  {
    "char": "Z",
    "name": {
      "fr": "Z cursif",
      "en": "cursive Z",
      "es": "Z cursiva",
      "ar": "Z بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 71.38 15.00 L 70.49 15.88 L 69.69 16.85 L 69.01 17.90 L 68.45 19.02 L 68.02 20.20 L 67.73 21.42 L 67.57 22.67 L 67.55 23.92 L 67.67 25.17 L 67.94 26.40 L 68.33 27.59 L 68.86 28.73 L 69.51 29.80 L 70.28 30.79 L 71.15 31.69 L 72.12 32.49 L 73.17 33.18 L 74.29 33.74 L 75.47 34.18 L 76.69 34.48 L 77.93 34.64 L 79.18 34.66 L 80.43 34.54 L 81.66 34.29 L 133.46 20.41",
        "startXY": [
          71.38,
          15
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 133.53 19.72 L 66.43 123.04",
        "startXY": [
          133.53,
          19.72
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2",
          "es": "Traza el trazo n.º2",
          "ar": "ارسم خط رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 68.11 123.22 L 120.30 107.26 L 121.40 106.99 L 122.51 106.84 L 123.64 106.82 L 124.77 106.92 L 125.87 107.14 L 126.95 107.48 L 127.98 107.94 L 128.95 108.51 L 129.86 109.18 L 130.69 109.95 L 131.42 110.80 L 132.06 111.73 L 132.60 112.72 L 133.02 113.77 L 133.32 114.86 L 133.51 115.97 L 133.57 117.10 L 133.50 118.22 L 133.32 119.34 L 133.01 120.42 L 132.58 121.47 L 132.05 122.46 L 131.40 123.38 L 130.66 124.24 L 129.83 125.00",
        "startXY": [
          68.11,
          123.22
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3",
          "es": "Traza el gancho n.º3",
          "ar": "ارسم خطاف رقم 3"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 82.04 70.30 L 120.94 70.30",
        "startXY": [
          82.04,
          70.3
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4",
          "es": "Traza el trazo n.º4",
          "ar": "ارسم خط رقم 4"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"Z\" s'écrit d'un geste lié : crochet, trait, crochet puis trait.",
      "en": "In cursive, the letter \"Z\" is written in one connected gesture: hook, line, hook then line.",
      "es": "En cursiva, la letra \"Z\" se escribe en un solo gesto: gancho, trazo, gancho y luego trazo.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"Z\" بحركة واحدة متصلة: خطاف، خط، خطاف ثم خط."
    }
  },
  {
    "char": "a",
    "name": {
      "fr": "a cursif",
      "en": "cursive a",
      "es": "a cursiva",
      "ar": "a بخط متصل"
    },
    "category": "voyelle",
    "zone": "corps",
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 64.17 125 L 74.46 111.3",
        "startXY": [
          64.17,
          125
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1",
          "es": "Traza el trazo n.º1",
          "ar": "ارسم خط رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 115.54 84.17 C 110.89 78.36 103.83 75 96.37 75 C 82.74 75 71.71 86.03 71.71 99.66 C 71.71 113.29 82.74 124.31 96.37 124.31 C 103.83 124.31 110.89 120.96 115.54 115.14",
        "startXY": [
          115.54,
          84.17
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 115.54 77.06 L 115.54 118.16 C 116.23 122.26 118.29 123.63 121.03 123.63 C 123.77 123.63 125.83 120.89 125.83 120.89",
        "startXY": [
          115.54,
          77.06
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3",
          "es": "Traza el gancho n.º3",
          "ar": "ارسم خطاف رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"a\" s'écrit d'un geste lié : trait, courbe, crochet.",
      "en": "In cursive, the letter \"a\" is written in one connected gesture: line, curve, hook.",
      "es": "En cursiva, la letra \"a\" se escribe en un solo gesto: trazo, curva, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"a\" بحركة واحدة متصلة: خط، منحنى، خطاف."
    }
  },
  {
    "char": "b",
    "name": {
      "fr": "b cursif",
      "en": "cursive b",
      "es": "b cursiva",
      "ar": "b بخط متصل"
    },
    "category": "consonne",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 61.06 109.55 L 103.80 39.71 A 16.60 16.29 0 0 0 85.54 15.52",
        "startXY": [
          61.06,
          109.55
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "double-crochet",
        "variant": "hg-bg",
        "pathD": "M 100.23 19.02 A 14.01 13.75 0 0 0 76.33 28.74 L 76.33 69.98 L 76.33 108.47 A 16.81 16.50 0 1 0 109.12 103.38",
        "startXY": [
          100.23,
          19.02
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2",
          "es": "Traza el gancho n.º2",
          "ar": "ارسم خطاف رقم 2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 108.45 103.12 L 133.35 103.12",
        "startXY": [
          108.45,
          103.12
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3",
          "es": "Traza el trazo n.º3",
          "ar": "ارسم خط رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"b\" s'écrit d'un geste lié : crochet, crochet, trait.",
      "en": "In cursive, the letter \"b\" is written in one connected gesture: hook, hook, line.",
      "es": "En cursiva, la letra \"b\" se escribe en un solo gesto: gancho, gancho, trazo.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"b\" بحركة واحدة متصلة: خطاف، خطاف، خط."
    }
  },
  {
    "char": "d",
    "name": {
      "fr": "d cursif",
      "en": "cursive d",
      "es": "d cursiva",
      "ar": "d بخط متصل"
    },
    "category": "consonne",
    "zone": "hampe",
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 54.75 125 L 80.8 100.01",
        "startXY": [
          54.75,
          125
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1",
          "es": "Traza el trazo n.º1",
          "ar": "ارسم خط رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 121.83 85.45 C 115.68 77.88 105.42 75 96.18 78.26 C 86.96 81.54 80.8 90.26 80.8 100.01 C 80.8 109.74 86.96 118.46 96.18 121.72 C 105.42 125 115.68 122.11 121.83 114.55",
        "startXY": [
          121.83,
          85.45
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 121.83 15 L 121.83 116.05 C 122.72 121.43 125.42 123.21 128.99 123.21 C 132.57 123.21 135.25 119.64 135.25 119.64",
        "startXY": [
          121.83,
          15
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3",
          "es": "Traza el gancho n.º3",
          "ar": "ارسم خطاف رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"d\" s'écrit d'un geste lié : trait, courbe, crochet.",
      "en": "In cursive, the letter \"d\" is written in one connected gesture: line, curve, hook.",
      "es": "En cursiva, la letra \"d\" se escribe en un solo gesto: trazo, curva, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"d\" بحركة واحدة متصلة: خط، منحنى، خطاف."
    }
  },
  {
    "char": "e",
    "name": {
      "fr": "e cursif",
      "en": "cursive e",
      "es": "e cursiva",
      "ar": "e بخط متصل"
    },
    "category": "voyelle",
    "zone": "corps",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 55.31 106.25 L 97.98 100.25 A 11.93 11.93 0 0 0 104.31 79.58",
        "startXY": [
          55.31,
          106.25
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 3,
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 105.37 80.58 A 25 25 0 1 0 104.68 119.96",
        "startXY": [
          105.37,
          80.58
        ],
        "strokeColor": "#E05252",
        "zIndex": 2,
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"e\" s'écrit d'un geste lié : crochet, courbe.",
      "en": "In cursive, the letter \"e\" is written in one connected gesture: hook, curve.",
      "es": "En cursiva, la letra \"e\" se escribe en un solo gesto: gancho, curva.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"e\" بحركة واحدة متصلة: خطاف، منحنى."
    }
  },
  {
    "char": "g",
    "name": {
      "fr": "g cursif",
      "en": "cursive g",
      "es": "g cursiva",
      "ar": "g بخط متصل"
    },
    "category": "consonne",
    "zone": "jambe",
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 66.73 114.02 L 72.24 106.13",
        "startXY": [
          66.73,
          114.02
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1",
          "es": "Traza el trazo n.º1",
          "ar": "ارسم خط رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 108.81 84.34 A 21.5 21.5 0 1 0 108.81 108.66",
        "startXY": [
          108.81,
          84.34
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 109.03 77.43 L 109.03 183.32",
        "startXY": [
          109.03,
          77.43
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3",
          "es": "Traza el trazo n.º3",
          "ar": "ارسم خط رقم 3"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 109.06 183.49 A 13.91 13.91 0 0 1 90.61 164.32 L 116.62 117.38",
        "startXY": [
          109.06,
          183.49
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°4",
          "en": "Trace the hook #4",
          "es": "Traza el gancho n.º4",
          "ar": "ارسم خطاف رقم 4"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"g\" s'écrit d'un geste lié : trait, courbe, trait, crochet.",
      "en": "In cursive, the letter \"g\" is written in one connected gesture: line, curve, line, hook.",
      "es": "En cursiva, la letra \"g\" se escribe en un solo gesto: trazo, curva, trazo, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"g\" بحركة واحدة متصلة: خط، منحنى، خط، خطاف."
    }
  },
  {
    "char": "j",
    "name": {
      "fr": "j cursif",
      "en": "cursive j",
      "es": "j cursiva",
      "ar": "j بخط متصل"
    },
    "category": "consonne",
    "zone": "jambe",
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 98.5 122.24 L 110.79 99.09",
        "startXY": [
          98.5,
          122.24
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1",
          "es": "Traza el trazo n.º1",
          "ar": "ارسم خط رقم 1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 110.71 99.76 L 110.71 183.67",
        "startXY": [
          110.71,
          99.76
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2",
          "es": "Traza el trazo n.º2",
          "ar": "ارسم خط رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 110.73 183.82 A 11.04 11.04 0 0 1 96.11 168.63 L 116.73 131.43",
        "startXY": [
          110.73,
          183.82
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3",
          "es": "Traza el gancho n.º3",
          "ar": "ارسم خطاف رقم 3"
        }
      },
      {
        "family": "point",
        "variant": "cursive-point",
        "pathD": "M 110.97 75 A 3.85 3.85 0 1 0 111.02 75",
        "startXY": [
          110.97,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le point n°4",
          "en": "Trace the dot #4",
          "es": "Traza el punto n.º4",
          "ar": "ارسم نقطة رقم 4"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"j\" s'écrit d'un geste lié : trait, trait, crochet, point.",
      "en": "In cursive, the letter \"j\" is written in one connected gesture: line, line, hook, dot.",
      "es": "En cursiva, la letra \"j\" se escribe en un solo gesto: trazo, trazo, gancho, punto.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"j\" بحركة واحدة متصلة: خط، خط، خطاف، نقطة."
    }
  },
  {
    "char": "m",
    "name": {
      "fr": "m cursif",
      "en": "cursive m",
      "es": "m cursiva",
      "ar": "m بخط متصل"
    },
    "category": "consonne",
    "zone": "corps",
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 46.85 84.56 C 46.85 79.26 51.13 75 56.41 75 C 61.68 75 65.96 79.26 65.96 84.56 L 65.96 125",
        "startXY": [
          46.85,
          84.56
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1",
          "es": "Traza la curva n.º1",
          "ar": "ارسم منحنى رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 65.96 84.56 C 65.96 79.26 70.22 75 75.51 75 C 80.79 75 85.06 79.26 85.06 84.56 L 85.06 125",
        "startXY": [
          65.96,
          84.56
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 85.06 84.56 C 85.06 79.26 89.32 75 94.6 75 C 99.88 75 104.16 79.26 104.16 84.56 L 104.16 119.94 C 104.16 123.31 105.84 125 108.09 125.17 C 109.78 125.56 112.59 124.43 113.15 122.76",
        "startXY": [
          85.06,
          84.56
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°3",
          "en": "Trace the curve #3",
          "es": "Traza la curva n.º3",
          "ar": "ارسم منحنى رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"m\" s'écrit d'un geste lié : courbe, courbe, courbe.",
      "en": "In cursive, the letter \"m\" is written in one connected gesture: curve, curve, curve.",
      "es": "En cursiva, la letra \"m\" se escribe en un solo gesto: curva, curva, curva.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"m\" بحركة واحدة متصلة: منحنى، منحنى، منحنى."
    }
  },
  {
    "char": "n",
    "name": {
      "fr": "n cursif",
      "en": "cursive n",
      "es": "n cursiva",
      "ar": "n بخط متصل"
    },
    "category": "consonne",
    "zone": "corps",
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 73.41 84.56 C 73.41 79.26 77.67 75 82.96 75 C 88.23 75 92.51 79.26 92.51 84.56 L 92.51 125",
        "startXY": [
          73.41,
          84.56
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1",
          "es": "Traza la curva n.º1",
          "ar": "ارسم منحنى رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 92.51 84.56 C 92.51 79.26 96.77 75 102.06 75 C 107.33 75 111.6 79.26 111.6 84.56 L 111.6 119.94 C 111.6 123.31 113.29 125 115.55 125.17 C 117.23 125.56 120.05 124.43 120.59 122.76",
        "startXY": [
          92.51,
          84.56
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"n\" s'écrit d'un geste lié : courbe, courbe.",
      "en": "In cursive, the letter \"n\" is written in one connected gesture: curve, curve.",
      "es": "En cursiva, la letra \"n\" se escribe en un solo gesto: curva, curva.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"n\" بحركة واحدة متصلة: منحنى، منحنى."
    }
  },
  {
    "char": "ñ",
    "name": {
      "fr": "ñ cursif",
      "en": "cursive ñ",
      "es": "ñ cursiva",
      "ar": "ñ بخط متصل"
    },
    "category": "consonne",
    "zone": "corps",
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 73.53 84.51 C 73.53 79.24 77.77 75 83.03 75 C 88.27 75 92.53 79.24 92.53 84.51 L 92.53 124.75",
        "startXY": [
          73.53,
          84.51
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1",
          "es": "Traza la curva n.º1",
          "ar": "ارسم منحنى رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 92.53 84.51 C 92.53 79.24 96.77 75 102.03 75 C 107.28 75 111.53 79.24 111.53 84.51 L 111.53 119.72 C 111.53 123.07 113.21 124.75 115.46 124.92 C 117.13 125.31 119.93 124.18 120.47 122.52",
        "startXY": [
          92.53,
          84.51
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-double-crochet",
        "pathD": "M 98.4 83.68 A 2.54 2.54 0 0 0 95.86 81.16 L 92.53 81.16 L 89.2 81.16 A 2.54 2.54 0 0 1 86.66 78.6",
        "startXY": [
          98.4,
          83.68
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le boucle de liaison n°3",
          "en": "Trace the connecting loop #3",
          "es": "Traza el bucle de enlace n.º3",
          "ar": "ارسم حلقة وصل رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"ñ\" s'écrit d'un geste lié : courbe, courbe, boucle de liaison.",
      "en": "In cursive, the letter \"ñ\" is written in one connected gesture: curve, curve, connecting loop.",
      "es": "En cursiva, la letra \"ñ\" se escribe en un solo gesto: curva, curva, bucle de enlace.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"ñ\" بحركة واحدة متصلة: منحنى، منحنى، حلقة وصل."
    }
  },
  {
    "char": "f",
    "name": {
      "fr": "f cursif",
      "en": "cursive f",
      "es": "f cursiva",
      "ar": "f بخط متصل"
    },
    "category": "consonne",
    "zone": "jambe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 81.33 125 L 109.98 95.32 A 13.75 13.75 0 0 0 99.85 72.01",
        "startXY": [
          81.33,
          125
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 111.13 77.11 A 10.74 10.74 0 0 0 91.27 82.7 L 91.27 126.99",
        "startXY": [
          111.13,
          77.11
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2",
          "es": "Traza el gancho n.º2",
          "ar": "ارسم خطاف رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 91.27 126.99 L 91.27 168.26 A 13.75 13.75 0 0 0 114.73 177.98",
        "startXY": [
          91.27,
          126.99
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3",
          "es": "Traza el gancho n.º3",
          "ar": "ارسم خطاف رقم 3"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 103.26 181.74 A 13.75 13.75 0 0 0 115.77 159.62 L 90.37 127.07",
        "startXY": [
          103.26,
          181.74
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°4",
          "en": "Trace the hook #4",
          "es": "Traza el gancho n.º4",
          "ar": "ارسم خطاف رقم 4"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 91.42 137.51 A 5.16 5.16 0 0 0 100.3 141.02 L 111.05 129.88",
        "startXY": [
          91.42,
          137.51
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°5",
          "en": "Trace the hook #5",
          "es": "Traza el gancho n.º5",
          "ar": "ارسم خطاف رقم 5"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"f\" s'écrit d'un geste lié : crochet, crochet, crochet, crochet, crochet.",
      "en": "In cursive, the letter \"f\" is written in one connected gesture: hook, hook, hook, hook, hook.",
      "es": "En cursiva, la letra \"f\" se escribe en un solo gesto: gancho, gancho, gancho, gancho, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"f\" بحركة واحدة متصلة: خطاف، خطاف، خطاف، خطاف، خطاف."
    }
  },
  {
    "char": "k",
    "name": {
      "fr": "k cursif",
      "en": "cursive k",
      "es": "k cursiva",
      "ar": "k بخط متصل"
    },
    "category": "consonne",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 84.45 81.97 L 105.11 30.88 A 11.53 11.53 0 0 0 86.72 17.95",
        "startXY": [
          84.45,
          81.97
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 86.69 18.59 L 86.69 121.17",
        "startXY": [
          86.69,
          18.59
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2",
          "es": "Traza el trazo n.º2",
          "ar": "ارسم خط رقم 2"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 87.9 83.93 A 15.38 15.38 0 1 1 87.9 108.82",
        "startXY": [
          87.9,
          83.93
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°3",
          "en": "Trace the curve #3",
          "es": "Traza la curva n.º3",
          "ar": "ارسم منحنى رقم 3"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 87.97 109.54 A 4.23 4.23 0 0 1 95.71 107.19 L 104.83 120.68",
        "startXY": [
          87.97,
          109.54
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°4",
          "en": "Trace the hook #4",
          "es": "Traza el gancho n.º4",
          "ar": "ارسم خطاف رقم 4"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 97.47 110.21 L 106.3 122.82 A 5.13 5.13 0 0 0 115.55 120.74",
        "startXY": [
          97.47,
          110.21
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°5",
          "en": "Trace the hook #5",
          "es": "Traza el gancho n.º5",
          "ar": "ارسم خطاف رقم 5"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"k\" s'écrit d'un geste lié : crochet, trait, courbe, crochet, crochet.",
      "en": "In cursive, the letter \"k\" is written in one connected gesture: hook, line, curve, hook, hook.",
      "es": "En cursiva, la letra \"k\" se escribe en un solo gesto: gancho, trazo, curva, gancho, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"k\" بحركة واحدة متصلة: خطاف، خط، منحنى، خطاف، خطاف."
    }
  },
  {
    "char": "p",
    "name": {
      "fr": "p cursif",
      "en": "cursive p",
      "es": "p cursiva",
      "ar": "p بخط متصل"
    },
    "category": "consonne",
    "zone": "jambe",
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 83.52 106.42 L 101.2 83.84",
        "startXY": [
          83.52,
          106.42
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1",
          "es": "Traza el trazo n.º1",
          "ar": "ارسم خط رقم 1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 101.2 75 L 101.2 185",
        "startXY": [
          101.2,
          75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2",
          "es": "Traza el trazo n.º2",
          "ar": "ارسم خط رقم 2"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 101.2 84.56 C 101.2 79.26 105.46 75 110.75 75 C 116.02 75 120.29 79.26 120.29 84.56 L 120.29 119.94 C 120.29 123.31 121.98 125 124.24 125.17 C 125.92 125.56 128.74 124.43 129.28 122.76",
        "startXY": [
          101.2,
          84.56
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°3",
          "en": "Trace the curve #3",
          "es": "Traza la curva n.º3",
          "ar": "ارسم منحنى رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"p\" s'écrit d'un geste lié : trait, trait, courbe.",
      "en": "In cursive, the letter \"p\" is written in one connected gesture: line, line, curve.",
      "es": "En cursiva, la letra \"p\" se escribe en un solo gesto: trazo, trazo, curva.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"p\" بحركة واحدة متصلة: خط، خط، منحنى."
    }
  },
  {
    "char": "r",
    "name": {
      "fr": "r cursif",
      "en": "cursive r",
      "es": "r cursiva",
      "ar": "r بخط متصل"
    },
    "category": "consonne",
    "zone": "corps",
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 52.22 107.61 L 54.89 76.92",
        "startXY": [
          52.22,
          107.61
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1",
          "es": "Traza el trazo n.º1",
          "ar": "ارسم خط رقم 1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 55.61 78.23 A 2.46 2.46 0 0 0 57.36 82.45 L 91.86 82.45",
        "startXY": [
          55.61,
          78.23
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2",
          "es": "Traza el gancho n.º2",
          "ar": "ارسم خطاف رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 91.32 81.36 L 91.32 118.33 A 12.32 12.32 0 0 0 115.08 122.93",
        "startXY": [
          91.32,
          81.36
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3",
          "es": "Traza el gancho n.º3",
          "ar": "ارسم خطاف رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"r\" s'écrit d'un geste lié : trait, crochet, crochet.",
      "en": "In cursive, the letter \"r\" is written in one connected gesture: line, hook, hook.",
      "es": "En cursiva, la letra \"r\" se escribe en un solo gesto: trazo, gancho, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"r\" بحركة واحدة متصلة: خط، خطاف، خطاف."
    }
  },
  {
    "char": "s",
    "name": {
      "fr": "s cursif",
      "en": "cursive s",
      "es": "s cursiva",
      "ar": "s بخط متصل"
    },
    "category": "consonne",
    "zone": "corps",
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 80.59 116.19 L 104.9 75.67",
        "startXY": [
          80.59,
          116.19
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1",
          "es": "Traza el trazo n.º1",
          "ar": "ارسم خط رقم 1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 105.57 75 L 119.76 108.77 A 12.16 12.16 0 0 1 104.22 124.29",
        "startXY": [
          105.57,
          75
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2",
          "es": "Traza el gancho n.º2",
          "ar": "ارسم خطاف رقم 2"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"s\" s'écrit d'un geste lié : trait, crochet.",
      "en": "In cursive, the letter \"s\" is written in one connected gesture: line, hook.",
      "es": "En cursiva, la letra \"s\" se escribe en un solo gesto: trazo, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"s\" بحركة واحدة متصلة: خط، خطاف."
    }
  },
  {
    "char": "t",
    "name": {
      "fr": "t cursif",
      "en": "cursive t",
      "es": "t cursiva",
      "ar": "t بخط متصل"
    },
    "category": "consonne",
    "zone": "hampe",
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 77.32 125 L 97 98.17",
        "startXY": [
          77.32,
          125
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1",
          "es": "Traza el trazo n.º1",
          "ar": "ارسم خط رقم 1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 97 15 L 97 116.05 C 97 121.43 99.68 124.11 104.15 124.38 C 105.95 125 113.1 124.11 116.68 120.53",
        "startXY": [
          97,
          15
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2",
          "es": "Traza el gancho n.º2",
          "ar": "ارسم خطاف رقم 2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 79.11 36.46 L 114.89 36.46",
        "startXY": [
          79.11,
          36.46
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3",
          "es": "Traza el trazo n.º3",
          "ar": "ارسم خط رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"t\" s'écrit d'un geste lié : trait, crochet, trait.",
      "en": "In cursive, the letter \"t\" is written in one connected gesture: line, hook, line.",
      "es": "En cursiva, la letra \"t\" se escribe en un solo gesto: trazo, gancho, trazo.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"t\" بحركة واحدة متصلة: خط، خطاف، خط."
    }
  },
  {
    "char": "u",
    "name": {
      "fr": "u cursif",
      "en": "cursive u",
      "es": "u cursiva",
      "ar": "u بخط متصل"
    },
    "category": "voyelle",
    "zone": "corps",
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 80 125 L 85.56 113.89",
        "startXY": [
          80,
          125
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1",
          "es": "Traza el trazo n.º1",
          "ar": "ارسم خط رقم 1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 84.44 75 L 84.44 107.23 C 84.44 119.44 93.33 125 103.33 125 C 113.33 125 120 119.44 120 107.23",
        "startXY": [
          84.44,
          75
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2",
          "es": "Traza el gancho n.º2",
          "ar": "ارسم خطاف رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 120 75 L 120 119.44 C 120.56 122.77 122.77 124.44 125 124.77 C 127.23 125 129.44 123.89 130 122.23",
        "startXY": [
          120,
          75
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3",
          "es": "Traza el gancho n.º3",
          "ar": "ارسم خطاف رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"u\" s'écrit d'un geste lié : trait, crochet, crochet.",
      "en": "In cursive, the letter \"u\" is written in one connected gesture: line, hook, hook.",
      "es": "En cursiva, la letra \"u\" se escribe en un solo gesto: trazo, gancho, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"u\" بحركة واحدة متصلة: خط، خطاف، خطاف."
    }
  },
  {
    "char": "l",
    "name": {
      "fr": "l cursif",
      "en": "cursive l",
      "es": "l cursiva",
      "ar": "l بخط متصل"
    },
    "category": "consonne",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 77.94 116.92 L 106.05 40.74 A 10.91 16.38 0 0 0 91.21 18.47",
        "startXY": [
          77.94,
          116.92
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "double-crochet",
        "variant": "cursive-double-crochet",
        "pathD": "M 102.09 18.54 A 7.92 11.9 0 0 0 88.54 26.99 L 88.54 70.04 L 88.54 110.36 A 9.76 14.66 0 0 0 108.06 110.36",
        "startXY": [
          102.09,
          18.54
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le double crochet n°2",
          "en": "Trace the double hook #2",
          "es": "Traza el doble gancho n.º2",
          "ar": "ارسم الخطاف المزدوج رقم 2"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"l\" s'écrit d'un geste lié : crochet, double crochet.",
      "en": "In cursive, the letter \"l\" is written in one connected gesture: hook, double hook.",
      "es": "En cursiva, la letra \"l\" se escribe en un solo gesto: gancho, doble gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"l\" بحركة واحدة متصلة: خطاف، خطاف مزدوج."
    }
  },
  {
    "char": "o",
    "name": {
      "fr": "o cursif",
      "en": "cursive o",
      "es": "o cursiva",
      "ar": "o بخط متصل"
    },
    "category": "voyelle",
    "zone": "corps",
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 58.84 121.13 L 67.44 108.83",
        "startXY": [
          58.84,
          121.13
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 0,
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1",
          "es": "Traza el trazo n.º1",
          "ar": "ارسم خط رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 96.89 75.57 A 25 25 0 1 0 99 76.13",
        "startXY": [
          96.89,
          75.57
        ],
        "strokeColor": "#E05252",
        "zIndex": 2,
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 98.11 75.7 A 12.5 12.5 0 0 0 102.29 98.26 L 138.83 106.68",
        "startXY": [
          98.11,
          75.7
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 3,
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3",
          "es": "Traza el gancho n.º3",
          "ar": "ارسم خطاف رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"o\" s'écrit d'un geste lié : trait, courbe, crochet.",
      "en": "In cursive, the letter \"o\" is written in one connected gesture: line, curve, hook.",
      "es": "En cursiva, la letra \"o\" se escribe en un solo gesto: trazo, curva, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"o\" بحركة واحدة متصلة: خط، منحنى، خطاف."
    }
  },
  {
    "char": "v",
    "name": {
      "fr": "v cursif",
      "en": "cursive v",
      "es": "v cursiva",
      "ar": "v بخط متصل"
    },
    "category": "consonne",
    "zone": "corps",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 67.23 78.33 L 67.48 77.79 L 67.78 77.29 L 68.16 76.83 L 68.58 76.4 L 69.04 76.03 L 69.54 75.7 L 70.05 75.44 L 70.61 75.23 L 71.18 75.09 L 71.78 75.01 L 72.37 75 L 72.97 75.04 L 73.54 75.17 L 74.11 75.34 L 74.64 75.59 L 75.15 75.87 L 75.64 76.23 L 76.07 76.64 L 76.45 77.09 L 76.78 77.57 L 77.08 78.09 L 77.3 78.64 L 77.45 79.21 L 77.55 79.79 L 77.58 80.37 L 77.55 113.67",
        "startXY": [
          67.23,
          78.33
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 77.55 113.67 C 77.55 113.67 77.55 116.68 78.05 118.2 C 78.57 119.69 79.57 121.71 82.08 123.21 C 86.1 125.22 87.6 125.22 90.61 124.72 C 92.12 124.21 94.64 123.21 96.14 121.71 C 97.14 120.69 98.65 118.68 99.15 113.67 L 99.15 78.33",
        "startXY": [
          77.55,
          113.67
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 99.15 78.33 C 99.15 78.33 98.14 76.51 95.64 78.01 C 94.64 79.03 93.64 80.53 94.64 82.53 C 95.64 84.54 97.14 85.04 99.15 85.04 L 109.19 85.04",
        "startXY": [
          99.15,
          78.33
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3",
          "es": "Traza el gancho n.º3",
          "ar": "ارسم خطاف رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"v\" s'écrit d'un geste lié : crochet, courbe, crochet.",
      "en": "In cursive, the letter \"v\" is written in one connected gesture: hook, curve, hook.",
      "es": "En cursiva, la letra \"v\" se escribe en un solo gesto: gancho, curva, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"v\" بحركة واحدة متصلة: خطاف، منحنى، خطاف."
    }
  },
  {
    "char": "w",
    "name": {
      "fr": "w cursif",
      "en": "cursive w",
      "es": "w cursiva",
      "ar": "w بخط متصل"
    },
    "category": "consonne",
    "zone": "corps",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 77.93 78.33 L 78.19 77.79 L 78.5 77.29 L 78.86 76.83 L 79.28 76.4 L 79.74 76.03 L 80.24 75.7 L 80.76 75.44 L 81.31 75.23 L 81.88 75.09 L 82.48 75.01 L 83.07 75 L 83.67 75.04 L 84.24 75.17 L 84.81 75.34 L 85.36 75.59 L 85.86 75.87 L 86.34 76.23 L 86.77 76.64 L 87.16 77.09 L 87.5 77.57 L 87.78 78.09 L 88 78.64 L 88.16 79.21 L 88.26 79.79 L 88.28 80.37 L 88.26 113.67",
        "startXY": [
          77.93,
          78.33
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 88.26 113.67 C 88.26 113.67 88.26 116.68 88.76 118.2 C 89.27 119.69 90.27 121.71 92.78 123.21 C 96.8 125.22 98.31 125.22 101.33 124.72 C 102.83 124.21 105.34 123.21 106.84 121.71 C 107.85 120.69 109.35 118.68 109.85 113.67 L 109.85 78.33",
        "startXY": [
          88.26,
          113.67
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 109.85 113.67 C 109.85 113.67 109.85 116.68 110.35 118.2 C 110.87 119.69 111.87 121.71 114.38 123.21 C 118.38 125.22 119.89 125.22 122.91 124.72 C 124.42 124.21 126.94 123.21 128.44 121.71 C 129.44 120.69 130.94 118.68 131.45 113.67 L 131.45 78.33",
        "startXY": [
          109.85,
          113.67
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le courbe n°3",
          "en": "Trace the curve #3",
          "es": "Traza la curva n.º3",
          "ar": "ارسم منحنى رقم 3"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 131.45 78.33 C 131.45 78.33 130.44 76.51 127.94 78.01 C 126.94 79.03 125.92 80.53 126.94 82.53 C 127.94 84.54 129.44 85.04 131.45 85.04 L 141.49 85.04",
        "startXY": [
          131.45,
          78.33
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°4",
          "en": "Trace the hook #4",
          "es": "Traza el gancho n.º4",
          "ar": "ارسم خطاف رقم 4"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"w\" s'écrit d'un geste lié : crochet, courbe, courbe, crochet.",
      "en": "In cursive, the letter \"w\" is written in one connected gesture: hook, curve, curve, hook.",
      "es": "En cursiva, la letra \"w\" se escribe en un solo gesto: gancho, curva, curva, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"w\" بحركة واحدة متصلة: خطاف، منحنى، منحنى، خطاف."
    }
  },
  {
    "char": "y",
    "name": {
      "fr": "y cursif",
      "en": "cursive y",
      "es": "y cursiva",
      "ar": "y بخط متصل"
    },
    "category": "consonne",
    "zone": "jambe",
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 92.68 99.23 L 101.32 78.86",
        "startXY": [
          92.68,
          99.23
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 3,
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1",
          "es": "Traza el trazo n.º1",
          "ar": "ارسم خط رقم 1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 101.72 79.17 L 101.72 100.23 A 16.1 16.1 0 0 0 129.61 111.21",
        "startXY": [
          101.72,
          79.17
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 3,
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2",
          "es": "Traza el gancho n.º2",
          "ar": "ارسم خطاف رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 129.47 78 L 129.47 161.55 A 13.79 13.79 0 0 1 105.93 171.29",
        "startXY": [
          129.47,
          78
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 2,
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3",
          "es": "Traza el gancho n.º3",
          "ar": "ارسم خطاف رقم 3"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 123.65 173 A 12.91 12.91 0 0 1 106.23 154 L 140.9 119.31",
        "startXY": [
          123.65,
          173
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 4,
        "description": {
          "fr": "Trace le crochet n°4",
          "en": "Trace the hook #4",
          "es": "Traza el gancho n.º4",
          "ar": "ارسم خطاف رقم 4"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"y\" s'écrit d'un geste lié : trait, crochet, crochet, crochet.",
      "en": "In cursive, the letter \"y\" is written in one connected gesture: line, hook, hook, hook.",
      "es": "En cursiva, la letra \"y\" se escribe en un solo gesto: trazo, gancho, gancho, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"y\" بحركة واحدة متصلة: خط، خطاف، خطاف، خطاف."
    }
  },
  {
    "char": "c",
    "name": {
      "fr": "c cursif",
      "en": "cursive c",
      "es": "c cursiva",
      "ar": "c بخط متصل"
    },
    "category": "consonne",
    "zone": "corps",
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 71.15 125 L 80.06 111.3",
        "startXY": [
          71.15,
          125
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1",
          "es": "Traza el trazo n.º1",
          "ar": "ارسم خط رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 119.63 82.2 L 116.46 79.51 L 112.88 77.4 L 109 75.93 L 104.93 75.13 L 100.78 75 L 96.66 75.59 L 92.72 76.84 L 89.03 78.76 L 85.7 81.24 L 82.86 84.26 L 80.55 87.71 L 78.86 91.5 L 77.82 95.53 L 77.46 99.66 L 77.82 103.79 L 78.86 107.81 L 80.55 111.6 L 82.86 115.06 L 85.7 118.07 L 89.03 120.57 L 92.72 122.47 L 96.66 123.73 L 100.78 124.31 L 104.93 124.2 L 109 123.39 L 112.88 121.91 L 116.46 119.8 L 119.63 117.13",
        "startXY": [
          119.63,
          82.2
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"c\" s'écrit d'un geste lié : trait, courbe.",
      "en": "In cursive, the letter \"c\" is written in one connected gesture: line, curve.",
      "es": "En cursiva, la letra \"c\" se escribe en un solo gesto: trazo, curva.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"c\" بحركة واحدة متصلة: خط، منحنى."
    }
  },
  {
    "char": "i",
    "name": {
      "fr": "i cursif",
      "en": "cursive i",
      "es": "i cursiva",
      "ar": "i بخط متصل"
    },
    "category": "voyelle",
    "zone": "corps",
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 88.46 125 L 95.06 110.34",
        "startXY": [
          88.46,
          125
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1",
          "es": "Traza el trazo n.º1",
          "ar": "ارسم خط رقم 1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 95 78.33 L 95 113.67 C 95.5 118.68 97.01 120.69 98.01 121.71 C 99.51 123.21 102.03 124.21 103.54 124.72 C 106.55 125.22 108.05 125.22 112.07 123.21 C 114.58 121.71 115.58 119.69 116.1 118.2 C 116.6 116.68 116.6 113.67 116.6 113.67",
        "startXY": [
          95,
          78.33
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2",
          "es": "Traza el gancho n.º2",
          "ar": "ارسم خطاف رقم 2"
        }
      },
      {
        "family": "point",
        "variant": "cursive-point",
        "pathD": "M 92.56 55 A 2.47 2.47 0 1 0 92.57 55",
        "startXY": [
          92.56,
          55
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le point n°3",
          "en": "Trace the dot #3",
          "es": "Traza el punto n.º3",
          "ar": "ارسم نقطة رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"i\" s'écrit d'un geste lié : trait, crochet, point.",
      "en": "In cursive, the letter \"i\" is written in one connected gesture: line, hook, dot.",
      "es": "En cursiva, la letra \"i\" se escribe en un solo gesto: trazo, gancho, punto.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"i\" بحركة واحدة متصلة: خط، خطاف، نقطة."
    }
  },
  {
    "char": "q",
    "name": {
      "fr": "q cursif",
      "en": "cursive q",
      "es": "q cursiva",
      "ar": "q بخط متصل"
    },
    "category": "consonne",
    "zone": "jambe",
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 51.01 128.75 L 68.28 100.01",
        "startXY": [
          51.01,
          128.75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1",
          "es": "Traza el trazo n.º1",
          "ar": "ارسم خط رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 114.55 86.56 L 111.74 82.91 L 108.3 79.83 L 104.35 77.44 L 100.04 75.81 L 95.5 75 L 90.87 75.03 L 86.36 75.91 L 82.08 77.6 L 78.16 80.04 L 74.77 83.15 L 72 86.85 L 69.94 90.98 L 68.7 95.41 L 68.28 100.01 L 68.7 104.59 L 69.94 109.03 L 72 113.15 L 74.77 116.85 L 78.16 119.96 L 82.08 122.41 L 86.36 124.11 L 90.87 124.97 L 95.5 125 L 100.04 124.19 L 104.35 122.56 L 108.3 120.18 L 111.74 117.09 L 114.55 113.45",
        "startXY": [
          114.55,
          86.56
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 113.78 79.63 L 113.78 185",
        "startXY": [
          113.78,
          79.63
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3",
          "es": "Traza el trazo n.º3",
          "ar": "ارسم خط رقم 3"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 113.96 115.86 L 113.67 116.62 L 113.48 117.41 L 113.37 118.22 L 113.35 119.05 L 113.42 119.84 L 113.59 120.65 L 113.83 121.42 L 114.17 122.17 L 114.6 122.87 L 115.1 123.51 L 115.66 124.11 L 116.28 124.61 L 116.97 125.07 L 117.7 125.43 L 118.45 125.71 L 119.24 125.91 L 120.06 126.02 L 120.88 126.04 L 121.69 125.96 L 122.48 125.78 L 140.91 120.85",
        "startXY": [
          113.96,
          115.86
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°4",
          "en": "Trace the hook #4",
          "es": "Traza el gancho n.º4",
          "ar": "ارسم خطاف رقم 4"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"q\" s'écrit d'un geste lié : trait, courbe, trait, crochet.",
      "en": "In cursive, the letter \"q\" is written in one connected gesture: line, curve, line, hook.",
      "es": "En cursiva, la letra \"q\" se escribe en un solo gesto: trazo, curva, trazo, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"q\" بحركة واحدة متصلة: خط، منحنى، خط، خطاف."
    }
  },
  {
    "char": "z",
    "name": {
      "fr": "z cursif",
      "en": "cursive z",
      "es": "z cursiva",
      "ar": "z بخط متصل"
    },
    "category": "consonne",
    "zone": "jambe",
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 61.33 102.63 L 63.46 78.11",
        "startXY": [
          61.33,
          102.63
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1",
          "es": "Traza el trazo n.º1",
          "ar": "ارسم خط رقم 1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 63.77 78 A 1.64 1.64 0 0 0 64.92 80.8 L 87.89 80.8",
        "startXY": [
          63.77,
          78
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2",
          "es": "Traza el gancho n.º2",
          "ar": "ارسم خطاف رقم 2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 87.87 80.3 L 83.39 108.64",
        "startXY": [
          87.87,
          80.3
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3",
          "es": "Traza el trazo n.º3",
          "ar": "ارسم خط رقم 3"
        }
      },
      {
        "family": "double-crochet",
        "variant": "cursive-double-crochet",
        "pathD": "M 83.06 108.23 A 11.11 11.11 0 0 1 97.05 118.96 L 97.05 161.15 M 97.1 127.99 L 97.1 173.92 A 11.48 11.48 0 0 1 76.69 181.13",
        "startXY": [
          83.06,
          108.23
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le double crochet n°4",
          "en": "Trace the double hook #4",
          "es": "Traza el doble gancho n.º4",
          "ar": "ارسم الخطاف المزدوج رقم 4"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 94.24 182 A 12.98 12.98 0 0 1 75.01 164.97 L 112.6 107.08",
        "startXY": [
          94.24,
          182
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°5",
          "en": "Trace the hook #5",
          "es": "Traza el gancho n.º5",
          "ar": "ارسم خطاف رقم 5"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"z\" s'écrit d'un geste lié : trait, crochet, trait, double crochet, crochet.",
      "en": "In cursive, the letter \"z\" is written in one connected gesture: line, hook, line, double hook, hook.",
      "es": "En cursiva, la letra \"z\" se escribe en un solo gesto: trazo, gancho, trazo, doble gancho, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"z\" بحركة واحدة متصلة: خط، خطاف، خط، خطاف مزدوج، خطاف."
    }
  },
  {
    "char": "h",
    "name": {
      "fr": "h cursif",
      "en": "cursive h",
      "es": "h cursiva",
      "ar": "h بخط متصل"
    },
    "category": "consonne",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 66.42 84.65 L 104.47 39.84 A 11 16 0 0 0 104.47 15",
        "startXY": [
          66.42,
          84.65
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 105.6 16.63 A 12.29 17.86 0 0 0 84.62 29.26 L 84.62 124.25",
        "startXY": [
          105.6,
          16.63
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2",
          "es": "Traza el gancho n.º2",
          "ar": "ارسم خطاف رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 84.74 89.25 A 13.09 19.03 0 0 1 107.54 100.98 L 108.41 125",
        "startXY": [
          84.74,
          89.25
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3",
          "es": "Traza el gancho n.º3",
          "ar": "ارسم خطاف رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"h\" s'écrit d'un geste lié : crochet, crochet, crochet.",
      "en": "In cursive, the letter \"h\" is written in one connected gesture: hook, hook, hook.",
      "es": "En cursiva, la letra \"h\" se escribe en un solo gesto: gancho, gancho, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"h\" بحركة واحدة متصلة: خطاف، خطاف، خطاف."
    }
  },
  {
    "char": "A",
    "name": {
      "fr": "A cursif",
      "en": "cursive A",
      "es": "A cursiva",
      "ar": "A بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 30.36 111.94 A 17.72 17.72 0 0 0 64.55 111.93 L 90.52 15",
        "startXY": [
          30.36,
          111.94
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 2,
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 91.48 15 L 117.45 111.93 A 17.72 17.72 0 0 0 151.64 111.94",
        "startXY": [
          91.48,
          15
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 3,
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2",
          "es": "Traza el gancho n.º2",
          "ar": "ارسم خطاف رقم 2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 73.28 81.86 L 108.72 81.86",
        "startXY": [
          73.28,
          81.86
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 1,
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3",
          "es": "Traza el trazo n.º3",
          "ar": "ارسم خط رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"A\" s'écrit d'un geste lié : crochet, crochet, trait.",
      "en": "In cursive, the letter \"A\" is written in one connected gesture: hook, hook, line.",
      "es": "En cursiva, la letra \"A\" se escribe en un solo gesto: gancho, gancho, trazo.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"A\" بحركة واحدة متصلة: خطاف، خطاف، خط."
    }
  },
  {
    "char": "B",
    "name": {
      "fr": "B cursif",
      "en": "cursive B",
      "es": "B cursiva",
      "ar": "B بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 81.8 19.48 L 81.8 109.18 A 15.84 15.84 0 0 1 52.26 117.11",
        "startXY": [
          81.8,
          19.48
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 3,
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 66.18 34.42 A 25.07 25.07 0 1 1 83.27 64.04",
        "startXY": [
          66.18,
          34.42
        ],
        "strokeColor": "#E05252",
        "zIndex": 1,
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 87.87 65.49 A 28.04 28.04 0 1 1 62.82 104.05",
        "startXY": [
          87.87,
          65.49
        ],
        "strokeColor": "#E05252",
        "zIndex": 3,
        "description": {
          "fr": "Trace le courbe n°3",
          "en": "Trace the curve #3",
          "es": "Traza la curva n.º3",
          "ar": "ارسم منحنى رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"B\" s'écrit d'un geste lié : crochet, courbe, courbe.",
      "en": "In cursive, the letter \"B\" is written in one connected gesture: hook, curve, curve.",
      "es": "En cursiva, la letra \"B\" se escribe en un solo gesto: gancho, curva, curva.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"B\" بحركة واحدة متصلة: خطاف، منحنى، منحنى."
    }
  },
  {
    "char": "D",
    "name": {
      "fr": "D cursif",
      "en": "cursive D",
      "es": "D cursiva",
      "ar": "D بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "hd-bg",
        "pathD": "M 87.04 16.29 A 10.27 10.27 0 0 0 80.99 24.77 L 77.01 70.32 L 73.28 113.07 A 13.07 13.07 0 0 1 47.24 110.79",
        "startXY": [
          87.04,
          16.29
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 1,
        "description": {
          "fr": "Trace le boucle de liaison n°1",
          "en": "Trace the connecting loop #1",
          "es": "Traza el bucle de enlace n.º1",
          "ar": "ارسم حلقة وصل رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 38.53 41.14 A 53.9 53.9 0 1 1 68.96 120.44",
        "startXY": [
          38.53,
          41.14
        ],
        "strokeColor": "#E05252",
        "zIndex": 2,
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"D\" s'écrit d'un geste lié : boucle de liaison, courbe.",
      "en": "In cursive, the letter \"D\" is written in one connected gesture: connecting loop, curve.",
      "es": "En cursiva, la letra \"D\" se escribe en un solo gesto: bucle de enlace, curva.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"D\" بحركة واحدة متصلة: حلقة وصل، منحنى."
    }
  },
  {
    "char": "G",
    "name": {
      "fr": "G cursif",
      "en": "cursive G",
      "es": "G cursiva",
      "ar": "G بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 108.02 15 A 23.64 23.64 0 1 0 134.86 46.99",
        "startXY": [
          108.02,
          15
        ],
        "strokeColor": "#E05252",
        "zIndex": 2,
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1",
          "es": "Traza la curva n.º1",
          "ar": "ارسم منحنى رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 135.22 46.03 A 43 43 0 1 0 135.22 107.87",
        "startXY": [
          135.22,
          46.03
        ],
        "strokeColor": "#E05252",
        "zIndex": 2,
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 135.95 94.35 L 135.95 180.33",
        "startXY": [
          135.95,
          94.35
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 3,
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3",
          "es": "Traza el trazo n.º3",
          "ar": "ارسم خط رقم 3"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 135.89 180.18 A 16.43 16.43 0 0 1 112.62 156.94 L 152.67 116.88",
        "startXY": [
          135.89,
          180.18
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 4,
        "description": {
          "fr": "Trace le crochet n°4",
          "en": "Trace the hook #4",
          "es": "Traza el gancho n.º4",
          "ar": "ارسم خطاف رقم 4"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"G\" s'écrit d'un geste lié : courbe, courbe, trait, crochet.",
      "en": "In cursive, the letter \"G\" is written in one connected gesture: curve, curve, line, hook.",
      "es": "En cursiva, la letra \"G\" se escribe en un solo gesto: curva, curva, trazo, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"G\" بحركة واحدة متصلة: منحنى، منحنى، خط، خطاف."
    }
  },
  {
    "char": "O",
    "name": {
      "fr": "O cursif",
      "en": "cursive O",
      "es": "O cursiva",
      "ar": "O بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 116.15 17.13 A 55 55 0 1 0 140.56 31.81",
        "startXY": [
          116.15,
          17.13
        ],
        "strokeColor": "#E05252",
        "zIndex": 2,
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1",
          "es": "Traza la curva n.º1",
          "ar": "ارسم منحنى رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 148.92 43.23 A 22 22 0 1 0 107.09 56.83",
        "startXY": [
          148.92,
          43.23
        ],
        "strokeColor": "#E05252",
        "zIndex": 2,
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"O\" s'écrit d'un geste lié : courbe, courbe.",
      "en": "In cursive, the letter \"O\" is written in one connected gesture: curve, curve.",
      "es": "En cursiva, la letra \"O\" se escribe en un solo gesto: curva, curva.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"O\" بحركة واحدة متصلة: منحنى، منحنى."
    }
  },
  {
    "char": "Q",
    "name": {
      "fr": "Q cursif",
      "en": "cursive Q",
      "es": "Q cursiva",
      "ar": "Q بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 115.74 17.07 A 53.43 53.43 0 1 0 139.44 31.32",
        "startXY": [
          115.74,
          17.07
        ],
        "strokeColor": "#E05252",
        "zIndex": 2,
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1",
          "es": "Traza la curva n.º1",
          "ar": "ارسم منحنى رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 147.4 41.34 A 26.05 26.05 0 1 0 99.83 62.53",
        "startXY": [
          147.4,
          41.34
        ],
        "strokeColor": "#E05252",
        "zIndex": 2,
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 126.48 95.93 L 140.02 125",
        "startXY": [
          126.48,
          95.93
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 3,
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3",
          "es": "Traza el trazo n.º3",
          "ar": "ارسم خط رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"Q\" s'écrit d'un geste lié : courbe, courbe, trait.",
      "en": "In cursive, the letter \"Q\" is written in one connected gesture: curve, curve, line.",
      "es": "En cursiva, la letra \"Q\" se escribe en un solo gesto: curva, curva, trazo.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"Q\" بحركة واحدة متصلة: منحنى، منحنى، خط."
    }
  },
  {
    "char": "P",
    "name": {
      "fr": "P cursif",
      "en": "cursive P",
      "es": "P cursiva",
      "ar": "P بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 86.99 19.71 L 86.99 110.07 A 14.92 14.92 0 0 1 59.27 117.76",
        "startXY": [
          86.99,
          19.71
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 1,
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 69.58 37.73 A 30 30 0 1 1 87.43 72.81",
        "startXY": [
          69.58,
          37.73
        ],
        "strokeColor": "#E05252",
        "zIndex": 2,
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"P\" s'écrit d'un geste lié : crochet, courbe.",
      "en": "In cursive, the letter \"P\" is written in one connected gesture: hook, curve.",
      "es": "En cursiva, la letra \"P\" se escribe en un solo gesto: gancho, curva.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"P\" بحركة واحدة متصلة: خطاف، منحنى."
    }
  },
  {
    "char": "R",
    "name": {
      "fr": "R cursif",
      "en": "cursive R",
      "es": "R cursiva",
      "ar": "R بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 83.92 19.85 L 83.92 114.44 A 10.51 10.51 0 0 1 63.02 116.1",
        "startXY": [
          83.92,
          19.85
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 3,
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 66.49 37.73 A 30 30 0 1 1 84.36 72.83",
        "startXY": [
          66.49,
          37.73
        ],
        "strokeColor": "#E05252",
        "zIndex": 2,
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2",
          "es": "Traza la curva n.º2",
          "ar": "ارسم منحنى رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 110.11 74.16 L 113.52 113.22 A 10.83 10.83 0 0 0 135.14 111.53",
        "startXY": [
          110.11,
          74.16
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 1,
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3",
          "es": "Traza el gancho n.º3",
          "ar": "ارسم خطاف رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"R\" s'écrit d'un geste lié : crochet, courbe, crochet.",
      "en": "In cursive, the letter \"R\" is written in one connected gesture: hook, curve, hook.",
      "es": "En cursiva, la letra \"R\" se escribe en un solo gesto: gancho, curva, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"R\" بحركة واحدة متصلة: خطاف، منحنى، خطاف."
    }
  },
  {
    "char": "S",
    "name": {
      "fr": "S cursif",
      "en": "cursive S",
      "es": "S cursiva",
      "ar": "S بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 86.51 15 A 17.87 17.87 0 1 0 118.6 30.65",
        "startXY": [
          86.51,
          15
        ],
        "strokeColor": "#E05252",
        "zIndex": 3,
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1",
          "es": "Traza la curva n.º1",
          "ar": "ارسم منحنى رقم 1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 118.49 29.93 A 18.75 18.75 0 0 0 90.17 54.53 L 113.01 80.82",
        "startXY": [
          118.49,
          29.93
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 1,
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2",
          "es": "Traza el gancho n.º2",
          "ar": "ارسم خطاف رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 101.22 67.19 L 123.5 92.79 A 19.65 19.65 0 0 1 93.86 118.57",
        "startXY": [
          101.22,
          67.19
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 2,
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3",
          "es": "Traza el gancho n.º3",
          "ar": "ارسم خطاف رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"S\" s'écrit d'un geste lié : courbe, crochet, crochet.",
      "en": "In cursive, the letter \"S\" is written in one connected gesture: curve, hook, hook.",
      "es": "En cursiva, la letra \"S\" se escribe en un solo gesto: curva, gancho, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"S\" بحركة واحدة متصلة: منحنى، خطاف، خطاف."
    }
  },
  {
    "char": "U",
    "name": {
      "fr": "U cursif",
      "en": "cursive U",
      "es": "U cursiva",
      "ar": "U بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "hd-bg",
        "pathD": "M 43.91 30.07 A 13.92 13.92 0 0 1 71.77 30.07 L 71.77 68.38 L 71.77 94.5 A 26.12 26.12 0 0 0 121.93 104.71",
        "startXY": [
          43.91,
          30.07
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 1,
        "description": {
          "fr": "Trace le boucle de liaison n°1",
          "en": "Trace the connecting loop #1",
          "es": "Traza el bucle de enlace n.º1",
          "ar": "ارسم حلقة وصل رقم 1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 121.92 15 L 121.92 112.16 A 12.82 12.82 0 0 0 145.51 119.13",
        "startXY": [
          121.92,
          15
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 2,
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2",
          "es": "Traza el gancho n.º2",
          "ar": "ارسم خطاف رقم 2"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"U\" s'écrit d'un geste lié : boucle de liaison, crochet.",
      "en": "In cursive, the letter \"U\" is written in one connected gesture: connecting loop, hook.",
      "es": "En cursiva, la letra \"U\" se escribe en un solo gesto: bucle de enlace, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"U\" بحركة واحدة متصلة: حلقة وصل، خطاف."
    }
  },
  {
    "char": "V",
    "name": {
      "fr": "V cursif",
      "en": "cursive V",
      "es": "V cursiva",
      "ar": "V بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 17.89 33.31 A 31.62 31.62 0 0 1 76.26 35.86 L 108.69 125",
        "startXY": [
          17.89,
          33.31
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 1,
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 108.48 124.52 L 144.05 15.08",
        "startXY": [
          108.48,
          124.52
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 2,
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2",
          "es": "Traza el trazo n.º2",
          "ar": "ارسم خط رقم 2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 144.17 15 L 182.11 15",
        "startXY": [
          144.17,
          15
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 3,
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3",
          "es": "Traza el trazo n.º3",
          "ar": "ارسم خط رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"V\" s'écrit d'un geste lié : crochet, trait, trait.",
      "en": "In cursive, the letter \"V\" is written in one connected gesture: hook, line, line.",
      "es": "En cursiva, la letra \"V\" se escribe en un solo gesto: gancho, trazo, trazo.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"V\" بحركة واحدة متصلة: خطاف، خط، خط."
    }
  },
  {
    "char": "W",
    "name": {
      "fr": "W cursif",
      "en": "cursive W",
      "es": "W cursiva",
      "ar": "W بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 8 33.1 A 24.84 31.36 0 0 1 53.85 35.62 L 79.33 124.05",
        "startXY": [
          8,
          33.1
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 1,
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1",
          "es": "Traza el gancho n.º1",
          "ar": "ارسم خطاف رقم 1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 79.17 123.57 L 107.12 15",
        "startXY": [
          79.17,
          123.57
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 2,
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2",
          "es": "Traza el trazo n.º2",
          "ar": "ارسم خط رقم 2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 107.33 15 L 135.27 123.57",
        "startXY": [
          107.33,
          15
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 4,
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3",
          "es": "Traza el trazo n.º3",
          "ar": "ارسم خط رقم 3"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 166.57 17.74 L 135.63 125",
        "startXY": [
          166.57,
          17.74
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 5,
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4",
          "es": "Traza el trazo n.º4",
          "ar": "ارسم خط رقم 4"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 167.16 17.01 L 192 17.01",
        "startXY": [
          167.16,
          17.01
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 3,
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5",
          "es": "Traza el trazo n.º5",
          "ar": "ارسم خط رقم 5"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"W\" s'écrit d'un geste lié : crochet, trait, trait, trait, trait.",
      "en": "In cursive, the letter \"W\" is written in one connected gesture: hook, line, line, line, line.",
      "es": "En cursiva, la letra \"W\" se escribe en un solo gesto: gancho, trazo, trazo, trazo, trazo.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"W\" بحركة واحدة متصلة: خطاف، خط، خط، خط، خط."
    }
  },
  {
    "char": "Y",
    "name": {
      "fr": "Y cursif",
      "en": "cursive Y",
      "es": "Y cursiva",
      "ar": "Y بخط متصل"
    },
    "category": "majuscule",
    "zone": "hampe",
    "steps": [
      {
        "family": "crochet",
        "variant": "hd-bg",
        "pathD": "M 70.3 17.42 A 7.28 7.28 0 0 1 82.71 22.57 L 82.71 39.55 L 82.71 52.48 A 11.32 11.32 0 0 0 104.12 57.64",
        "startXY": [
          70.3,
          17.42
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 1,
        "description": {
          "fr": "Trace le boucle de liaison n°1",
          "en": "Trace the connecting loop #1",
          "es": "Traza el bucle de enlace n.º1",
          "ar": "ارسم حلقة وصل رقم 1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 105.16 15 L 105.16 122.81",
        "startXY": [
          105.16,
          15
        ],
        "strokeColor": "#4A3B2A",
        "zIndex": 2,
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2",
          "es": "Traza el trazo n.º2",
          "ar": "ارسم خط رقم 2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 104.9 123.24 A 20.13 20.13 0 0 1 83.51 89.65 L 133.4 46.28",
        "startXY": [
          104.9,
          123.24
        ],
        "strokeColor": "#4A90E2",
        "zIndex": 3,
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3",
          "es": "Traza el gancho n.º3",
          "ar": "ارسم خطاف رقم 3"
        }
      }
    ],
    "consigne": {
      "fr": "En cursive, la lettre \"Y\" s'écrit d'un geste lié : boucle de liaison, trait, crochet.",
      "en": "In cursive, the letter \"Y\" is written in one connected gesture: connecting loop, line, hook.",
      "es": "En cursiva, la letra \"Y\" se escribe en un solo gesto: bucle de enlace, trazo, gancho.",
      "ar": "بخط الرقعة المتصل، يُكتب الحرف \"Y\" بحركة واحدة متصلة: حلقة وصل، خط، خطاف."
    }
  }
]
''');

final Map<String, dynamic> CURSIVE_MAP = {
  for (final l in CURSIVE_LETTERS) l['char'] as String: l,
};
