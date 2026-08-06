import 'dart:convert';

/// CATALOGUE CURSIF — extrait/résolu depuis Web (src/data/cursive-formation-catalog.ts), tracés déjà calculés (plus de système de tampons procédural ici).
final List<dynamic> CURSIVE_LETTERS = jsonDecode(r'''
[
  {
    "char": "a",
    "name": {
      "fr": "a cursif",
      "en": "cursive a"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "En cursive, la lettre \"a\" s'écrit d'un geste lié : courbe puis crochet.",
      "en": "In cursive, the letter \"a\" is written in one connected gesture: curve then hook."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 117.27 86.93 L 112.90 83.23 L 107.96 80.32 L 102.61 78.28 L 96.99 77.16 L 91.27 77.00 L 85.59 77.80 L 80.13 79.54 L 75.04 82.17 L 70.47 85.61 L 66.53 89.78 L 63.35 94.54 L 61.01 99.77 L 59.58 105.32 L 59.10 111.03 L 59.58 116.73 L 61.01 122.28 L 63.35 127.51 L 66.53 132.27 L 70.47 136.44 L 75.04 139.88 L 80.13 142.51 L 85.59 144.25 L 91.27 145.05 L 96.99 144.89 L 102.61 143.77 L 107.96 141.73 L 112.90 138.82 L 117.27 135.12",
        "startXY": [
          117.27,
          86.93
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 121.41 80.84 L 121.41 138.96 L 121.48 140.08 L 121.66 141.19 L 121.97 142.26 L 122.40 143.30 L 122.94 144.29 L 123.59 145.20 L 124.34 146.04 L 125.17 146.79 L 126.09 147.44 L 127.07 147.99 L 128.10 148.42 L 129.18 148.74 L 130.28 148.93 L 131.40 149.00 L 132.53 148.94 L 133.63 148.76 L 134.71 148.46 L 135.75 148.03 L 136.74 147.50 L 137.66 146.85 L 138.50 146.11 L 139.26 145.28 L 139.91 144.37 L 140.46 143.39 L 140.90 142.36",
        "startXY": [
          121.41,
          80.84
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2"
        }
      }
    ]
  },
  {
    "char": "c",
    "name": {
      "fr": "c cursif",
      "en": "cursive c"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "En cursive, la lettre \"c\" s'écrit d'un geste lié : courbe.",
      "en": "In cursive, the letter \"c\" is written in one connected gesture: curve."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 130.78 87.50 L 126.15 83.59 L 120.92 80.51 L 115.26 78.35 L 109.32 77.17 L 103.26 77.00 L 97.26 77.85 L 91.48 79.69 L 86.10 82.47 L 81.25 86.11 L 77.09 90.52 L 73.72 95.56 L 71.25 101.09 L 69.73 106.96 L 69.22 113.00 L 69.73 119.04 L 71.25 124.91 L 73.72 130.44 L 77.09 135.48 L 81.25 139.89 L 86.10 143.53 L 91.48 146.31 L 97.26 148.15 L 103.26 149.00 L 109.32 148.83 L 115.26 147.65 L 120.92 145.49 L 126.15 142.41 L 130.78 138.50",
        "startXY": [
          130.78,
          87.5
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1"
        }
      }
    ]
  },
  {
    "char": "d",
    "name": {
      "fr": "d cursif",
      "en": "cursive d"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"d\" s'écrit d'un geste lié : courbe puis crochet.",
      "en": "In cursive, the letter \"d\" is written in one connected gesture: curve then hook."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 115.77 84.44 L 110.90 80.34 L 105.42 77.10 L 99.48 74.84 L 93.24 73.59 L 86.88 73.42 L 80.58 74.31 L 74.52 76.24 L 68.86 79.16 L 63.78 82.98 L 59.41 87.61 L 55.87 92.90 L 53.27 98.71 L 51.68 104.87 L 51.15 111.21 L 51.68 117.55 L 53.27 123.71 L 55.87 129.52 L 59.41 134.81 L 63.78 139.43 L 68.86 143.26 L 74.52 146.18 L 80.58 148.11 L 86.88 149.00 L 93.24 148.82 L 99.48 147.58 L 105.42 145.31 L 110.90 142.08 L 115.77 137.97",
        "startXY": [
          115.77,
          84.44
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 116.38 35.00 L 116.38 131.82 L 116.48 133.69 L 116.80 135.54 L 117.31 137.33 L 118.03 139.06 L 118.93 140.70 L 120.01 142.23 L 121.25 143.62 L 122.64 144.87 L 124.16 145.96 L 125.80 146.87 L 127.52 147.59 L 129.32 148.12 L 131.16 148.44 L 133.03 148.55 L 134.89 148.46 L 136.74 148.16 L 138.54 147.65 L 140.27 146.94 L 141.91 146.05 L 143.45 144.98 L 144.85 143.74 L 146.11 142.36 L 147.20 140.84 L 148.12 139.21 L 148.85 137.49",
        "startXY": [
          116.38,
          35
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2"
        }
      }
    ]
  },
  {
    "char": "e",
    "name": {
      "fr": "e cursif",
      "en": "cursive e"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "En cursive, la lettre \"e\" s'écrit d'un geste lié : crochet puis courbe.",
      "en": "In cursive, the letter \"e\" is written in one connected gesture: hook then curve."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 67.64 108.40 L 120.63 107.47 L 121.93 107.38 L 123.23 107.14 L 124.48 106.76 L 125.69 106.24 L 126.84 105.60 L 127.90 104.84 L 128.88 103.96 L 129.76 102.98 L 130.52 101.91 L 131.16 100.76 L 131.67 99.55 L 132.04 98.29 L 132.27 97.00 L 132.36 95.69 L 132.31 94.38 L 132.11 93.08 L 131.77 91.81 L 131.30 90.59 L 130.69 89.42 L 129.96 88.33 L 129.11 87.33 L 128.16 86.42 L 127.12 85.63 L 125.99 84.95",
        "startXY": [
          67.64,
          108.4
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 128.82 87.09 L 124.16 83.27 L 118.93 80.29 L 113.27 78.21 L 107.35 77.10 L 101.33 77.00 L 95.37 77.90 L 89.65 79.78 L 84.31 82.58 L 79.52 86.23 L 75.41 90.63 L 72.08 95.65 L 69.63 101.16 L 68.14 107.00 L 67.64 113.00 L 68.14 119.00 L 69.63 124.84 L 72.08 130.35 L 75.41 135.37 L 79.52 139.77 L 84.31 143.42 L 89.65 146.22 L 95.37 148.10 L 101.33 149.00 L 107.35 148.90 L 113.27 147.79 L 118.93 145.71 L 124.16 142.73 L 128.82 138.91",
        "startXY": [
          128.82,
          87.09
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2"
        }
      }
    ]
  },
  {
    "char": "h",
    "name": {
      "fr": "h cursif",
      "en": "cursive h"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"h\" s'écrit d'un geste lié : crochet, trait puis boucle de liaison.",
      "en": "In cursive, the letter \"h\" is written in one connected gesture: hook, line then connecting loop."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 87.63 113.31 L 111.35 54.62 L 111.85 53.13 L 112.19 51.60 L 112.37 50.04 L 112.36 48.47 L 112.19 46.91 L 111.85 45.38 L 111.34 43.90 L 110.67 42.48 L 109.85 41.14 L 108.89 39.91 L 107.79 38.78 L 106.58 37.78 L 105.27 36.92 L 103.87 36.21 L 102.41 35.66 L 100.89 35.27 L 99.33 35.05 L 97.76 35.00 L 96.20 35.12 L 94.66 35.42 L 93.16 35.88 L 91.72 36.51 L 90.36 37.28 L 89.09 38.21",
        "startXY": [
          87.63,
          113.31
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 87.76 36.90 L 87.76 147.72",
        "startXY": [
          87.76,
          36.9
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "crochet",
        "variant": "hd-bg",
        "pathD": "M 91.34 110.76 L 92.72 110.34 L 94.15 110.23 L 95.58 110.43 L 96.92 110.94 L 98.13 111.73 L 99.13 112.76 L 99.88 113.99 L 100.34 115.35 L 100.50 116.78 L 100.50 145.16 L 100.61 146.05 L 100.92 146.90 L 101.41 147.65 L 102.07 148.26 L 102.86 148.71 L 103.72 148.96 L 104.62 149.00 L 105.50 148.83 L 106.33 148.47 L 107.04 147.92 L 107.61 147.22",
        "startXY": [
          91.34,
          110.76
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le boucle de liaison n°3",
          "en": "Trace the connecting loop #3"
        }
      }
    ]
  },
  {
    "char": "i",
    "name": {
      "fr": "i cursif",
      "en": "cursive i"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "En cursive, la lettre \"i\" s'écrit d'un geste lié : crochet puis point.",
      "en": "In cursive, the letter \"i\" is written in one connected gesture: hook then dot."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 93.93 98.33 L 93.93 140.05 L 93.98 141.04 L 94.15 142.02 L 94.42 142.98 L 94.80 143.90 L 95.28 144.78 L 95.85 145.59 L 96.51 146.34 L 97.25 147.01 L 98.06 147.59 L 98.92 148.08 L 99.84 148.47 L 100.79 148.75 L 101.77 148.93 L 102.76 149.00 L 103.76 148.96 L 104.74 148.81 L 105.70 148.54 L 106.63 148.18 L 107.51 147.71 L 108.33 147.15 L 109.09 146.50 L 109.77 145.77 L 110.36 144.97 L 110.86 144.11",
        "startXY": [
          93.93,
          98.33
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "point",
        "variant": "cursive-point",
        "pathD": "M 98.60 80.60 L 98.04 79.26 L 97.10 78.16 L 95.87 77.38 L 94.47 77.00 L 93.02 77.05 L 91.66 77.54 L 90.50 78.40 L 89.64 79.58 L 89.18 80.95 L 89.14 82.40 L 89.54 83.80 L 90.33 85.01 L 91.45 85.93 L 92.79 86.48 L 94.23 86.61 L 95.65 86.30 L 96.91 85.59 L 97.90 84.53 L 98.54 83.23 L 98.76 81.80",
        "startXY": [
          98.6,
          80.6
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le point n°2",
          "en": "Trace the dot #2"
        }
      }
    ]
  },
  {
    "char": "o",
    "name": {
      "fr": "o cursif",
      "en": "cursive o"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "En cursive, la lettre \"o\" s'écrit d'un geste lié : courbe puis crochet.",
      "en": "In cursive, the letter \"o\" is written in one connected gesture: curve then hook."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 93.22 77.75 L 85.29 78.64 L 77.76 81.28 L 71.01 85.52 L 65.37 91.16 L 61.12 97.92 L 58.49 105.45 L 57.59 113.37 L 58.49 121.30 L 61.12 128.83 L 65.37 135.59 L 71.01 141.23 L 77.76 145.47 L 85.29 148.11 L 93.22 149.00 L 101.15 148.11 L 108.68 145.47 L 115.43 141.23 L 121.07 135.59 L 125.32 128.83 L 127.95 121.30 L 128.85 113.37 L 127.95 105.45 L 125.32 97.92 L 121.07 91.16 L 115.43 85.52 L 108.68 81.28 L 101.15 78.64 L 93.22 77.75",
        "startXY": [
          93.22,
          77.75
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 94.09 77.00 L 92.82 77.71 L 91.65 78.55 L 90.57 79.52 L 89.62 80.61 L 88.79 81.80 L 88.11 83.07 L 87.57 84.41 L 87.19 85.81 L 86.96 87.24 L 86.91 88.69 L 87.01 90.13 L 87.28 91.55 L 87.71 92.93 L 88.29 94.26 L 89.02 95.51 L 89.88 96.67 L 90.88 97.72 L 91.98 98.66 L 93.18 99.46 L 94.47 100.13 L 95.82 100.64 L 97.23 101.00 L 142.41 109.78",
        "startXY": [
          94.09,
          77
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2"
        }
      }
    ]
  },
  {
    "char": "v",
    "name": {
      "fr": "v cursif",
      "en": "cursive v"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "En cursive, la lettre \"v\" s'écrit d'un geste lié : crochet, crochet puis courbe.",
      "en": "In cursive, the letter \"v\" is written in one connected gesture: hook, hook then curve."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 66.42 83.62 L 66.93 82.55 L 67.55 81.55 L 68.28 80.63 L 69.11 79.79 L 70.02 79.04 L 71.01 78.40 L 72.07 77.88 L 73.17 77.47 L 74.32 77.18 L 75.48 77.03 L 76.66 77.00 L 77.84 77.10 L 78.99 77.33 L 80.12 77.69 L 81.20 78.16 L 82.21 78.76 L 83.16 79.46 L 84.03 80.26 L 84.80 81.15 L 85.47 82.12 L 86.03 83.15 L 86.47 84.25 L 86.79 85.38 L 86.99 86.54 L 87.05 87.72 L 87.05 144.74",
        "startXY": [
          66.42,
          83.62
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 86.69 142.57 L 87.00 143.49 L 87.40 144.36 L 87.90 145.19 L 88.49 145.95 L 89.16 146.65 L 89.90 147.27 L 90.71 147.80 L 91.57 148.25 L 92.47 148.59 L 93.40 148.83 L 94.36 148.97 L 95.32 149.00 L 96.29 148.92 L 97.23 148.74 L 98.16 148.46 L 99.04 148.07 L 99.88 147.59 L 100.66 147.02 L 101.37 146.37 L 102.01 145.64 L 102.56 144.85 L 103.02 144.00 L 103.39 143.11 L 103.65 142.18 L 103.81 141.23 L 103.86 140.26 L 103.86 81.26",
        "startXY": [
          86.69,
          142.57
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 103.49 81.79 L 103.65 83.47 L 103.99 85.12 L 104.51 86.72 L 105.21 88.26 L 106.08 89.71 L 107.10 91.05 L 108.27 92.27 L 109.57 93.35 L 110.98 94.28 L 112.48 95.04 L 114.07 95.63 L 115.70 96.04 L 117.38 96.27 L 119.06 96.30 L 120.75 96.15 L 122.40 95.81 L 124.00 95.29 L 125.54 94.59 L 126.99 93.72 L 128.33 92.69 L 129.55 91.53 L 130.63 90.23 L 131.56 88.82 L 132.32 87.31 L 132.91 85.73 L 133.32 84.10 L 133.55 82.42 L 133.58 80.73",
        "startXY": [
          103.49,
          81.79
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°3",
          "en": "Trace the curve #3"
        }
      }
    ]
  },
  {
    "char": "w",
    "name": {
      "fr": "w cursif",
      "en": "cursive w"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "En cursive, la lettre \"w\" s'écrit d'un geste lié : boucle de liaison, crochet, crochet puis courbe.",
      "en": "In cursive, the letter \"w\" is written in one connected gesture: connecting loop, hook, hook then curve."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "hd-bg",
        "pathD": "M 64.55 79.59 L 66.04 78.39 L 67.74 77.54 L 69.59 77.07 L 71.50 77.00 L 73.38 77.34 L 75.14 78.07 L 76.71 79.16 L 78.01 80.56 L 78.99 82.20 L 79.59 84.01 L 79.79 85.91 L 79.79 139.48 L 80.00 141.37 L 80.60 143.19 L 81.57 144.83 L 82.87 146.22 L 84.44 147.31 L 86.21 148.04 L 88.08 148.38 L 89.99 148.31 L 91.84 147.84 L 93.55 146.99 L 95.03 145.79",
        "startXY": [
          64.55,
          79.59
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le boucle de liaison n°1",
          "en": "Trace the connecting loop #1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 94.91 77.33 L 94.91 138.76 L 94.98 139.89 L 95.17 141.01 L 95.48 142.09 L 95.92 143.13 L 96.47 144.12 L 97.13 145.04 L 97.89 145.88 L 98.73 146.63 L 99.66 147.27 L 100.65 147.81 L 101.70 148.23 L 102.79 148.54 L 103.91 148.71 L 105.04 148.76 L 106.17 148.68 L 107.28 148.48 L 108.36 148.15 L 109.40 147.70 L 110.38 147.14 L 111.29 146.47 L 112.11 145.70 L 112.85 144.84 L 113.49 143.91 L 114.01 142.91 L 114.42 141.85",
        "startXY": [
          94.91,
          77.33
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 95.40 142.09 L 95.81 143.14 L 96.34 144.15 L 96.97 145.08 L 97.71 145.94 L 98.54 146.71 L 99.45 147.38 L 100.43 147.94 L 101.47 148.39 L 102.55 148.72 L 103.66 148.92 L 104.79 149.00 L 105.92 148.95 L 107.03 148.77 L 108.12 148.47 L 109.17 148.05 L 110.16 147.51 L 111.09 146.86 L 111.94 146.12 L 112.70 145.28 L 113.36 144.36 L 113.91 143.37 L 114.34 142.33 L 114.66 141.24 L 114.85 140.13 L 114.91 139.00 L 114.91 77.57",
        "startXY": [
          95.4,
          142.09
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 114.85 77.60 L 114.58 78.77 L 114.45 79.96 L 114.45 81.16 L 114.59 82.36 L 114.86 83.53 L 115.26 84.66 L 115.78 85.74 L 116.42 86.76 L 117.17 87.70 L 118.02 88.55 L 118.96 89.29 L 119.98 89.93 L 121.06 90.45 L 122.20 90.85 L 123.37 91.11 L 124.56 91.25 L 125.76 91.25 L 126.96 91.11 L 128.13 90.84 L 129.26 90.44 L 130.34 89.92 L 131.36 89.28 L 132.30 88.53 L 133.15 87.68 L 133.90 86.74 L 134.53 85.72 L 135.05 84.64 L 135.45 83.50",
        "startXY": [
          114.85,
          77.6
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°4",
          "en": "Trace the curve #4"
        }
      }
    ]
  },
  {
    "char": "x",
    "name": {
      "fr": "x cursif",
      "en": "cursive x"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "En cursive, la lettre \"x\" s'écrit d'un geste lié : courbe puis courbe.",
      "en": "In cursive, the letter \"x\" is written in one connected gesture: curve then curve."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 47.95 80.89 L 52.77 78.86 L 57.84 77.56 L 63.04 77.00 L 68.26 77.21 L 73.40 78.17 L 78.35 79.87 L 83.00 82.27 L 87.24 85.32 L 91.00 88.95 L 94.20 93.10 L 96.75 97.66 L 98.62 102.55 L 99.75 107.65 L 100.13 112.87 L 99.75 118.08 L 98.62 123.19 L 96.75 128.07 L 94.20 132.64 L 91.00 136.78 L 87.24 140.42 L 83.00 143.47 L 78.35 145.87 L 73.40 147.57 L 68.26 148.53 L 63.04 148.73 L 57.84 148.18 L 52.77 146.87 L 47.95 144.84",
        "startXY": [
          47.95,
          80.89
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 152.05 81.16 L 147.23 79.13 L 142.16 77.82 L 136.96 77.27 L 131.74 77.47 L 126.60 78.43 L 121.65 80.13 L 117.00 82.53 L 112.76 85.58 L 109.00 89.22 L 105.80 93.36 L 103.25 97.93 L 101.38 102.81 L 100.25 107.92 L 99.87 113.13 L 100.25 118.35 L 101.38 123.45 L 103.25 128.34 L 105.80 132.90 L 109.00 137.05 L 112.76 140.68 L 117.00 143.73 L 121.65 146.13 L 126.60 147.83 L 131.74 148.79 L 136.96 149.00 L 142.16 148.44 L 147.23 147.14 L 152.05 145.11",
        "startXY": [
          152.05,
          81.16
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2"
        }
      }
    ]
  },
  {
    "char": "y",
    "name": {
      "fr": "y cursif",
      "en": "cursive y"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "En cursive, la lettre \"y\" s'écrit d'un geste lié : boucle de liaison, trait puis crochet.",
      "en": "In cursive, the letter \"y\" is written in one connected gesture: connecting loop, line then hook."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "hd-bg",
        "pathD": "M 88.37 78.22 L 89.59 77.53 L 90.94 77.11 L 92.34 77.00 L 93.74 77.20 L 95.06 77.70 L 96.23 78.47 L 97.21 79.48 L 97.95 80.68 L 98.41 82.02 L 98.56 83.42 L 98.56 115.21 L 98.72 116.63 L 99.17 117.98 L 99.91 119.20 L 100.89 120.24 L 102.07 121.04 L 103.39 121.56 L 104.80 121.79 L 106.22 121.71 L 107.59 121.33 L 108.85 120.66",
        "startXY": [
          88.37,
          78.22
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le boucle de liaison n°1",
          "en": "Trace the connecting loop #1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 110.06 77.74 L 110.06 162.87",
        "startXY": [
          110.06,
          77.74
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 109.26 162.85 L 108.77 163.35 L 108.24 163.79 L 107.66 164.17 L 107.04 164.49 L 106.39 164.73 L 105.72 164.90 L 105.03 164.99 L 104.33 165.00 L 103.64 164.94 L 102.96 164.80 L 102.31 164.58 L 101.67 164.29 L 101.08 163.94 L 100.53 163.52 L 100.03 163.04 L 99.58 162.50 L 99.20 161.93 L 98.88 161.31 L 98.64 160.66 L 98.47 159.99 L 98.37 159.30 L 98.36 158.61 L 98.42 157.92 L 98.55 157.24 L 98.77 156.58 L 111.63 123.05",
        "startXY": [
          109.26,
          162.85
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3"
        }
      }
    ]
  },
  {
    "char": "z",
    "name": {
      "fr": "z cursif",
      "en": "cursive z"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "En cursive, la lettre \"z\" s'écrit d'un geste lié : trait, crochet, trait, boucle de liaison puis trait.",
      "en": "In cursive, the letter \"z\" is written in one connected gesture: line, hook, line, connecting loop then line."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 87.88 78.53 L 71.09 100.82",
        "startXY": [
          87.88,
          78.53
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 117.40 87.88 L 94.85 89.46 L 94.01 89.47 L 93.17 89.39 L 92.34 89.21 L 91.54 88.94 L 90.77 88.59 L 90.05 88.15 L 89.38 87.63 L 88.78 87.04 L 88.24 86.39 L 87.78 85.68 L 87.41 84.92 L 87.12 84.13 L 86.92 83.31 L 86.81 82.47 L 86.80 81.62 L 86.88 80.78 L 87.06 79.96 L 87.33 79.16 L 87.68 78.39 L 88.12 77.67 L 88.64 77.00",
        "startXY": [
          117.4,
          87.88
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 117.43 88.92 L 101.44 106.06",
        "startXY": [
          117.43,
          88.92
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "crochet",
        "variant": "hd-bg",
        "pathD": "M 128.91 107.63 L 126.81 107.09 L 124.64 107.00 L 122.51 107.38 L 120.50 108.21 L 118.71 109.44 L 117.23 111.02 L 116.12 112.89 L 115.44 114.95 L 115.20 117.11 L 115.20 157.76 L 115.04 159.31 L 114.55 160.78 L 113.76 162.11 L 112.70 163.25 L 111.42 164.13 L 109.99 164.72 L 108.47 165.00 L 106.92 164.94 L 105.41 164.56 L 104.03 163.87 L 102.82 162.89",
        "startXY": [
          128.91,
          107.63
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le boucle de liaison n°4",
          "en": "Trace the connecting loop #4"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 121.39 112.08 L 100.46 161.40",
        "startXY": [
          121.39,
          112.08
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      }
    ]
  },
  {
    "char": "A",
    "name": {
      "fr": "A cursif",
      "en": "cursive A"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"A\" s'écrit d'un geste lié : crochet, crochet puis trait.",
      "en": "In cursive, the letter \"A\" is written in one connected gesture: hook, hook then line."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 24.44 129.36 L 24.66 131.56 L 25.11 133.72 L 25.80 135.82 L 26.72 137.83 L 27.85 139.72 L 29.19 141.48 L 30.71 143.09 L 32.39 144.51 L 34.22 145.74 L 36.18 146.77 L 38.23 147.57 L 40.37 148.15 L 42.55 148.48 L 44.76 148.58 L 46.96 148.43 L 49.13 148.04 L 51.25 147.41 L 53.29 146.56 L 55.22 145.49 L 57.02 144.21 L 58.67 142.74 L 60.15 141.10 L 61.44 139.31 L 62.52 137.39 L 63.39 135.36 L 99.92 35.00",
        "startXY": [
          24.44,
          129.36
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 100.08 35.42 L 136.61 135.78 L 137.48 137.81 L 138.56 139.73 L 139.85 141.53 L 141.33 143.17 L 142.98 144.63 L 144.78 145.91 L 146.71 146.98 L 148.75 147.84 L 150.87 148.46 L 153.04 148.85 L 155.24 149.00 L 157.45 148.91 L 159.63 148.57 L 161.77 148.00 L 163.82 147.19 L 165.78 146.17 L 167.61 144.93 L 169.29 143.51 L 170.81 141.91 L 172.15 140.15 L 173.28 138.25 L 174.20 136.24 L 174.89 134.14 L 175.34 131.98 L 175.56 129.79",
        "startXY": [
          100.08,
          35.42
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 123.90 102.02 L 75.68 102.02",
        "startXY": [
          123.9,
          102.02
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      }
    ]
  },
  {
    "char": "B",
    "name": {
      "fr": "B cursif",
      "en": "cursive B"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"B\" s'écrit d'un geste lié : boucle de liaison, courbe puis courbe.",
      "en": "In cursive, the letter \"B\" is written in one connected gesture: connecting loop, curve then curve."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "hd-bg",
        "pathD": "M 112.98 35.54 L 107.51 36.15 L 102.32 37.97 L 97.67 40.90 L 93.78 44.78 L 90.85 49.44 L 89.03 54.63 L 88.42 60.10 L 88.42 137.21 L 88.11 139.88 L 87.19 142.42 L 85.72 144.68 L 83.77 146.53 L 81.44 147.90 L 78.87 148.69 L 76.18 148.87 L 73.52 148.43 L 71.03 147.39 L 68.85 145.81 L 67.09 143.77",
        "startXY": [
          112.98,
          35.54
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le boucle de liaison n°1",
          "en": "Trace the connecting loop #1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 79.54 49.98 L 82.09 46.00 L 85.28 42.50 L 89.00 39.58 L 93.15 37.31 L 97.63 35.77 L 102.29 35.00 L 107.03 35.01 L 111.69 35.81 L 116.15 37.38 L 120.30 39.67 L 124.00 42.61 L 127.16 46.13 L 129.70 50.13 L 131.53 54.49 L 132.61 59.09 L 132.91 63.82 L 132.42 68.52 L 131.15 73.08 L 129.15 77.37 L 126.45 81.26 L 123.15 84.65 L 119.33 87.44 L 115.10 89.55 L 110.58 90.94 L 105.88 91.55 L 101.16 91.37 L 96.52 90.41 L 92.11 88.69",
        "startXY": [
          79.54,
          49.98
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 92.13 92.99 L 96.66 91.71 L 101.33 91.18 L 106.04 91.41 L 110.64 92.39 L 115.02 94.12 L 119.06 96.52 L 122.66 99.56 L 125.73 103.13 L 128.17 107.15 L 129.93 111.52 L 130.96 116.11 L 131.23 120.81 L 130.74 125.49 L 129.49 130.03 L 127.53 134.31 L 124.90 138.21 L 121.67 141.64 L 117.93 144.50 L 113.77 146.71 L 109.31 148.22 L 104.67 148.99 L 99.96 149.00 L 95.32 148.24 L 90.85 146.75 L 86.69 144.55 L 82.94 141.70 L 79.70 138.28 L 77.06 134.39",
        "startXY": [
          92.13,
          92.99
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°3",
          "en": "Trace the curve #3"
        }
      }
    ]
  },
  {
    "char": "C",
    "name": {
      "fr": "C cursif",
      "en": "cursive C"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"C\" s'écrit d'un geste lié : courbe puis courbe.",
      "en": "In cursive, the letter \"C\" is written in one connected gesture: curve then curve."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 91.12 35.00 L 89.75 37.71 L 88.69 40.55 L 87.96 43.50 L 87.57 46.51 L 87.51 49.54 L 87.79 52.56 L 88.41 55.53 L 89.36 58.41 L 90.63 61.17 L 92.19 63.77 L 94.04 66.18 L 96.14 68.36 L 98.48 70.30 L 101.02 71.96 L 103.73 73.33 L 106.57 74.38 L 109.52 75.11 L 112.53 75.51 L 115.56 75.57 L 118.58 75.28 L 121.55 74.66 L 124.43 73.72 L 127.19 72.45 L 129.79 70.88 L 132.20 69.04 L 134.38 66.93 L 136.32 64.60 L 137.98 62.06",
        "startXY": [
          91.12,
          35
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 138.66 60.90 L 132.15 56.90 L 125.09 53.98 L 117.66 52.19 L 110.04 51.59 L 102.42 52.19 L 94.99 53.98 L 87.93 56.90 L 81.41 60.90 L 75.60 65.86 L 70.64 71.67 L 66.64 78.19 L 63.72 85.25 L 61.94 92.68 L 61.34 100.30 L 61.94 107.92 L 63.72 115.35 L 66.64 122.41 L 70.64 128.92 L 75.60 134.74 L 81.41 139.70 L 87.93 143.69 L 94.99 146.62 L 102.42 148.40 L 110.04 149.00 L 117.66 148.40 L 125.09 146.62 L 132.15 143.69 L 138.66 139.70",
        "startXY": [
          138.66,
          60.9
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2"
        }
      }
    ]
  },
  {
    "char": "D",
    "name": {
      "fr": "D cursif",
      "en": "cursive D"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"D\" s'écrit d'un geste lié : boucle de liaison puis courbe.",
      "en": "In cursive, the letter \"D\" is written in one connected gesture: connecting loop then curve."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "hd-bg",
        "pathD": "M 107.72 37.61 L 103.90 36.06 L 99.83 35.41 L 95.71 35.71 L 91.77 36.95 L 88.22 39.05 L 85.24 41.90 L 82.99 45.36 L 81.60 49.25 L 81.12 53.35 L 81.12 134.40 L 80.73 137.77 L 79.57 140.96 L 77.71 143.79 L 75.24 146.12 L 72.31 147.82 L 69.06 148.80 L 65.68 149.00 L 62.33 148.42 L 59.22 147.08 L 56.49 145.06",
        "startXY": [
          107.72,
          37.61
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le boucle de liaison n°1",
          "en": "Trace the connecting loop #1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 69.17 41.01 L 76.26 37.87 L 83.75 35.85 L 91.46 35.00 L 99.21 35.34 L 106.81 36.87 L 114.09 39.54 L 120.88 43.29 L 127.01 48.04 L 132.34 53.67 L 136.75 60.05 L 140.13 67.03 L 142.40 74.45 L 143.51 82.12 L 143.43 89.88 L 142.16 97.53 L 139.74 104.89 L 136.21 111.80 L 131.67 118.09 L 126.22 123.61 L 120.00 128.23 L 113.13 131.84 L 105.80 134.36 L 98.16 135.72 L 90.41 135.90 L 82.72 134.90 L 75.28 132.72 L 68.25 129.43 L 61.82 125.11",
        "startXY": [
          69.17,
          41.01
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2"
        }
      }
    ]
  },
  {
    "char": "E",
    "name": {
      "fr": "E cursif",
      "en": "cursive E"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"E\" s'écrit d'un geste lié : courbe, courbe puis courbe.",
      "en": "In cursive, the letter \"E\" is written in one connected gesture: curve, curve then curve."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 96.13 35.00 L 95.15 36.36 L 94.33 37.82 L 93.68 39.36 L 93.20 40.96 L 92.91 42.61 L 92.80 44.28 L 92.89 45.95 L 93.15 47.60 L 93.60 49.21 L 94.23 50.76 L 95.03 52.23 L 95.99 53.60 L 97.10 54.86 L 98.33 55.98 L 99.69 56.96 L 101.15 57.78 L 102.69 58.44 L 104.30 58.91 L 105.94 59.20 L 107.61 59.31 L 109.28 59.23 L 110.94 58.96 L 112.55 58.51 L 114.10 57.88 L 115.57 57.08 L 116.94 56.12 L 118.19 55.02 L 119.32 53.78",
        "startXY": [
          96.13,
          35
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 119.70 52.58 L 116.67 50.46 L 113.38 48.79 L 109.88 47.61 L 106.25 46.95 L 102.56 46.81 L 98.89 47.19 L 95.32 48.11 L 91.91 49.52 L 88.73 51.41 L 85.86 53.73 L 83.36 56.44 L 81.26 59.48 L 79.62 62.78 L 78.48 66.29 L 77.84 69.93 L 77.74 73.62 L 78.16 77.28 L 79.10 80.85 L 80.54 84.25 L 82.46 87.41 L 84.81 90.26 L 87.54 92.74 L 90.60 94.81 L 93.92 96.41 L 97.44 97.53 L 101.08 98.13 L 104.77 98.21 L 108.43 97.75",
        "startXY": [
          119.7,
          52.58
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 107.39 97.58 L 103.85 97.66 L 100.34 98.22 L 96.95 99.27 L 93.74 100.76 L 90.76 102.69 L 88.07 105.01 L 85.73 107.67 L 83.78 110.63 L 82.25 113.84 L 81.18 117.22 L 80.58 120.71 L 80.47 124.26 L 80.85 127.79 L 81.71 131.23 L 83.04 134.52 L 84.81 137.59 L 86.98 140.40 L 89.52 142.88 L 92.37 144.98 L 95.49 146.68 L 98.81 147.92 L 102.27 148.70 L 105.81 149.00 L 109.35 148.81 L 112.83 148.13 L 116.18 146.98 L 119.35 145.38 L 122.26 143.35",
        "startXY": [
          107.39,
          97.58
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°3",
          "en": "Trace the curve #3"
        }
      }
    ]
  },
  {
    "char": "F",
    "name": {
      "fr": "F cursif",
      "en": "cursive F"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"F\" s'écrit d'un geste lié : crochet, crochet puis trait.",
      "en": "In cursive, the letter \"F\" is written in one connected gesture: hook, hook then line."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 83.23 36.50 L 83.23 129.13 L 83.11 131.33 L 82.74 133.51 L 82.14 135.64 L 81.30 137.68 L 80.24 139.62 L 78.97 141.43 L 77.50 143.09 L 75.87 144.57 L 74.07 145.87 L 72.15 146.95 L 70.11 147.82 L 68.00 148.45 L 65.82 148.85 L 63.62 149.00 L 61.41 148.91 L 59.23 148.57 L 57.09 147.99 L 55.04 147.18 L 53.08 146.14 L 51.26 144.89 L 49.58 143.45 L 48.08 141.84 L 46.76 140.06 L 45.65 138.15",
        "startXY": [
          83.23,
          36.5
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 53.66 72.25 L 51.79 71.07 L 50.06 69.69 L 48.50 68.13 L 47.12 66.40 L 45.93 64.54 L 44.97 62.55 L 44.23 60.47 L 43.72 58.31 L 43.46 56.12 L 43.44 53.91 L 43.67 51.71 L 44.14 49.55 L 44.85 47.46 L 45.79 45.46 L 46.94 43.57 L 48.30 41.82 L 49.84 40.24 L 51.54 38.83 L 53.40 37.63 L 55.37 36.64 L 57.44 35.87 L 59.59 35.34 L 61.78 35.05 L 63.99 35.00 L 156.56 38.23",
        "startXY": [
          53.66,
          72.25
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 138.54 94.18 L 82.30 93.20",
        "startXY": [
          138.54,
          94.18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      }
    ]
  },
  {
    "char": "G",
    "name": {
      "fr": "G cursif",
      "en": "cursive G"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"G\" s'écrit d'un geste lié : courbe, courbe, trait puis crochet.",
      "en": "In cursive, the letter \"G\" is written in one connected gesture: curve, curve, line then hook."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 96.72 35.00 L 95.49 36.99 L 94.49 39.10 L 93.73 41.31 L 93.22 43.60 L 92.97 45.92 L 92.99 48.26 L 93.26 50.58 L 93.80 52.86 L 94.59 55.06 L 95.61 57.16 L 96.87 59.13 L 98.34 60.95 L 100.00 62.59 L 101.84 64.04 L 103.83 65.27 L 105.94 66.27 L 108.15 67.03 L 110.43 67.54 L 112.76 67.79 L 115.10 67.77 L 117.42 67.49 L 119.70 66.96 L 121.90 66.17 L 124.00 65.15 L 125.97 63.89 L 127.79 62.42 L 129.43 60.76 L 130.88 58.92",
        "startXY": [
          96.72,
          35
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 132.26 58.16 L 126.39 53.20 L 119.76 49.29 L 112.57 46.54 L 105.02 45.04 L 97.33 44.83 L 89.71 45.90 L 82.38 48.24 L 75.55 51.77 L 69.40 56.40 L 64.11 61.99 L 59.84 68.39 L 56.70 75.41 L 54.77 82.86 L 54.13 90.53 L 54.77 98.19 L 56.70 105.64 L 59.84 112.67 L 64.11 119.07 L 69.40 124.66 L 75.55 129.28 L 82.38 132.81 L 89.71 135.15 L 97.33 136.23 L 105.02 136.01 L 112.57 134.51 L 119.76 131.77 L 126.39 127.86 L 132.26 122.89",
        "startXY": [
          132.26,
          58.16
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 132.11 113.58 L 132.11 164.44",
        "startXY": [
          132.11,
          113.58
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 130.67 164.14 L 129.73 164.52 L 128.74 164.79 L 127.74 164.95 L 126.72 165.00 L 125.70 164.93 L 124.70 164.76 L 123.72 164.47 L 122.78 164.07 L 121.89 163.58 L 121.06 162.98 L 120.31 162.30 L 119.63 161.54 L 119.04 160.71 L 118.55 159.82 L 118.15 158.88 L 117.87 157.90 L 117.70 156.89 L 117.64 155.88 L 117.69 154.86 L 117.85 153.85 L 118.13 152.87 L 118.51 151.93 L 119.00 151.03 L 119.58 150.19 L 145.87 116.54",
        "startXY": [
          130.67,
          164.14
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°4",
          "en": "Trace the hook #4"
        }
      }
    ]
  },
  {
    "char": "H",
    "name": {
      "fr": "H cursif",
      "en": "cursive H"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"H\" s'écrit d'un geste lié : crochet, trait, crochet, crochet, crochet puis crochet.",
      "en": "In cursive, the letter \"H\" is written in one connected gesture: hook, line, hook, hook, hook then hook."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 57.17 44.09 L 56.77 43.63 L 56.43 43.13 L 56.14 42.59 L 55.92 42.03 L 55.77 41.44 L 55.68 40.84 L 55.66 40.23 L 55.71 39.63 L 55.83 39.03 L 56.01 38.46 L 56.26 37.90 L 56.56 37.38 L 56.93 36.90 L 57.35 36.46 L 57.81 36.07 L 58.32 35.73 L 58.86 35.45 L 59.42 35.24 L 60.01 35.09 L 60.61 35.01 L 61.22 35.00 L 61.82 35.06 L 62.42 35.18 L 62.99 35.37 L 63.54 35.62 L 92.64 51.09",
        "startXY": [
          57.17,
          44.09
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 92.28 51.48 L 92.28 147.27",
        "startXY": [
          92.28,
          51.48
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 92.59 148.09 L 91.13 148.56 L 89.63 148.87 L 88.11 149.00 L 86.58 148.96 L 85.07 148.76 L 83.58 148.39 L 82.15 147.85 L 80.79 147.17 L 79.51 146.33 L 78.33 145.35 L 77.26 144.26 L 76.33 143.05 L 75.53 141.74 L 74.89 140.35 L 74.40 138.90 L 74.08 137.41 L 73.92 135.89 L 73.94 134.36 L 74.12 132.84 L 74.48 131.35 L 74.99 129.91 L 75.66 128.54 L 76.48 127.25 L 77.44 126.06 L 120.32 78.44",
        "startXY": [
          92.59,
          148.09
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 98.48 103.15 L 141.71 53.41 L 142.46 52.45 L 143.09 51.41 L 143.60 50.31 L 143.98 49.16 L 144.23 47.97 L 144.34 46.77 L 144.32 45.55 L 144.15 44.35 L 143.86 43.18 L 143.43 42.04 L 142.88 40.96 L 142.21 39.95 L 141.43 39.02 L 140.55 38.19 L 139.59 37.46 L 138.54 36.84 L 137.43 36.34 L 136.28 35.98 L 135.09 35.74 L 133.88 35.65 L 132.67 35.68 L 131.47 35.86 L 130.30 36.17 L 129.17 36.61 L 128.09 37.17",
        "startXY": [
          98.48,
          103.15
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°4",
          "en": "Trace the hook #4"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 144.20 42.97 L 143.75 41.84 L 143.16 40.78 L 142.46 39.79 L 141.66 38.88 L 140.75 38.07 L 139.76 37.37 L 138.70 36.79 L 137.58 36.32 L 136.42 35.99 L 135.22 35.79 L 134.01 35.73 L 132.80 35.81 L 131.60 36.02 L 130.44 36.36 L 129.32 36.83 L 128.27 37.43 L 127.29 38.14 L 126.39 38.96 L 125.59 39.87 L 124.90 40.87 L 124.33 41.94 L 123.88 43.07 L 123.57 44.24 L 123.38 45.43 L 123.33 46.65 L 124.48 112.54",
        "startXY": [
          144.2,
          42.97
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°5",
          "en": "Trace the hook #5"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 124.21 100.77 L 124.21 140.38 L 124.27 141.31 L 124.42 142.22 L 124.68 143.11 L 125.03 143.97 L 125.48 144.78 L 126.01 145.53 L 126.63 146.23 L 127.32 146.85 L 128.07 147.38 L 128.88 147.83 L 129.74 148.19 L 130.63 148.45 L 131.54 148.61 L 132.47 148.67 L 133.39 148.62 L 134.31 148.47 L 135.20 148.21 L 136.06 147.86 L 136.87 147.42 L 137.63 146.89 L 138.32 146.27 L 138.95 145.59 L 139.49 144.83 L 139.94 144.02",
        "startXY": [
          124.21,
          100.77
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°6",
          "en": "Trace the hook #6"
        }
      }
    ]
  },
  {
    "char": "I",
    "name": {
      "fr": "I cursif",
      "en": "cursive I"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"I\" s'écrit d'un geste lié : crochet puis crochet.",
      "en": "In cursive, the letter \"I\" is written in one connected gesture: hook then hook."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 57.05 72.35 L 55.23 70.95 L 53.58 69.36 L 52.13 67.59 L 50.87 65.67 L 49.84 63.62 L 49.05 61.47 L 48.50 59.25 L 48.20 56.98 L 48.16 54.69 L 48.37 52.41 L 48.84 50.16 L 49.55 47.99 L 50.51 45.90 L 51.69 43.94 L 53.08 42.12 L 54.67 40.47 L 56.44 39.00 L 58.35 37.75 L 60.39 36.71 L 62.54 35.91 L 64.76 35.35 L 67.04 35.05 L 69.33 35.00 L 151.84 37.88",
        "startXY": [
          57.05,
          72.35
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 102.71 36.08 L 102.71 126.98 L 102.57 129.46 L 102.15 131.90 L 101.46 134.28 L 100.51 136.57 L 99.31 138.74 L 97.86 140.76 L 96.21 142.60 L 94.35 144.25 L 92.32 145.68 L 90.15 146.87 L 87.85 147.80 L 85.46 148.48 L 83.02 148.88 L 80.54 149.00 L 78.06 148.84 L 75.62 148.41 L 73.25 147.70 L 70.96 146.74 L 68.80 145.52 L 66.79 144.06 L 64.96 142.39 L 63.33 140.52 L 61.92 138.49",
        "startXY": [
          102.71,
          36.08
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2"
        }
      }
    ]
  },
  {
    "char": "J",
    "name": {
      "fr": "J cursif",
      "en": "cursive J"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"J\" s'écrit d'un geste lié : crochet, trait puis crochet.",
      "en": "In cursive, the letter \"J\" is written in one connected gesture: hook, line then hook."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 65.92 64.63 L 64.48 63.52 L 63.17 62.26 L 62.01 60.86 L 61.02 59.34 L 60.20 57.71 L 59.57 56.01 L 59.13 54.24 L 58.90 52.44 L 58.86 50.62 L 59.03 48.81 L 59.41 47.03 L 59.97 45.30 L 60.73 43.65 L 61.67 42.09 L 62.77 40.65 L 64.03 39.34 L 65.43 38.18 L 66.95 37.18 L 68.57 36.36 L 70.28 35.72 L 72.04 35.28 L 73.84 35.04 L 75.66 35.00 L 141.14 37.29",
        "startXY": [
          65.92,
          64.63
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 99.60 37.00 L 99.60 146.00",
        "startXY": [
          99.6,
          37
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 98.44 148.25 L 96.60 148.71 L 94.71 148.96 L 92.81 149.00 L 90.92 148.83 L 89.05 148.46 L 87.24 147.88 L 85.50 147.10 L 83.86 146.14 L 82.34 145.00 L 80.95 143.70 L 79.72 142.25 L 78.65 140.68 L 77.76 139.00 L 77.06 137.23 L 76.56 135.40 L 76.27 133.52 L 76.18 131.62 L 76.31 129.72 L 76.64 127.85 L 77.18 126.02 L 77.92 124.27 L 78.85 122.61 L 79.95 121.06 L 81.22 119.65 L 136.50 64.36",
        "startXY": [
          98.44,
          148.25
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3"
        }
      }
    ]
  },
  {
    "char": "K",
    "name": {
      "fr": "K cursif",
      "en": "cursive K"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"K\" s'écrit d'un geste lié : crochet, crochet, trait, crochet puis crochet.",
      "en": "In cursive, the letter \"K\" is written in one connected gesture: hook, hook, line, hook then hook."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 62.10 40.41 L 62.26 39.71 L 62.49 39.02 L 62.79 38.37 L 63.17 37.76 L 63.61 37.19 L 64.11 36.68 L 64.67 36.22 L 65.28 35.83 L 65.92 35.51 L 66.60 35.26 L 67.30 35.10 L 68.01 35.01 L 68.73 35.00 L 69.45 35.07 L 70.15 35.22 L 70.84 35.46 L 71.49 35.76 L 72.10 36.14 L 72.67 36.58 L 73.19 37.08 L 73.64 37.64 L 84.96 53.23",
        "startXY": [
          62.1,
          40.41
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 85.20 53.15 L 85.20 130.74 L 85.10 132.51 L 84.80 134.27 L 84.31 135.98 L 83.62 137.62 L 82.76 139.18 L 81.73 140.62 L 80.54 141.95 L 79.21 143.13 L 77.75 144.16 L 76.19 145.01 L 74.55 145.69 L 72.83 146.17 L 71.08 146.46 L 69.30 146.55 L 67.52 146.44 L 65.77 146.13 L 64.06 145.63 L 62.42 144.94 L 60.87 144.07 L 59.43 143.03 L 58.11 141.83 L 56.94 140.49 L 55.92 139.03 L 55.07 137.47",
        "startXY": [
          85.2,
          53.15
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 86.76 96.15 L 105.44 96.15",
        "startXY": [
          86.76,
          96.15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 144.93 50.99 L 144.75 49.86 L 144.44 48.75 L 144.01 47.69 L 143.46 46.68 L 142.81 45.73 L 142.06 44.87 L 141.21 44.09 L 140.29 43.42 L 139.29 42.85 L 138.24 42.39 L 137.14 42.05 L 136.02 41.84 L 134.87 41.75 L 133.73 41.80 L 132.59 41.96 L 131.48 42.26 L 130.42 42.67 L 129.40 43.20 L 128.45 43.84 L 127.57 44.59 L 126.79 45.42 L 126.10 46.34 L 125.51 47.32 L 125.04 48.37 L 107.82 93.24",
        "startXY": [
          144.93,
          50.99
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°4",
          "en": "Trace the hook #4"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 107.70 95.34 L 120.95 141.54 L 121.33 142.62 L 121.82 143.66 L 122.43 144.63 L 123.14 145.53 L 123.95 146.35 L 124.84 147.07 L 125.81 147.68 L 126.84 148.19 L 127.92 148.58 L 129.03 148.85 L 130.17 148.99 L 131.32 149.00 L 132.46 148.89 L 133.58 148.65 L 134.67 148.28 L 135.71 147.80 L 136.69 147.21 L 137.60 146.51 L 138.42 145.71 L 139.16 144.83 L 139.79 143.87 L 140.31 142.85 L 140.71 141.78 L 140.99 140.66",
        "startXY": [
          107.7,
          95.34
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°5",
          "en": "Trace the hook #5"
        }
      }
    ]
  },
  {
    "char": "L",
    "name": {
      "fr": "L cursif",
      "en": "cursive L"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"L\" s'écrit d'un geste lié : courbe, crochet, crochet puis crochet.",
      "en": "In cursive, the letter \"L\" is written in one connected gesture: curve, hook, hook then hook."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 60.06 46.15 L 60.33 49.82 L 61.01 53.44 L 62.09 56.96 L 63.56 60.34 L 65.39 63.53 L 67.58 66.49 L 70.08 69.20 L 72.87 71.60 L 75.91 73.68 L 79.16 75.40 L 82.58 76.75 L 86.14 77.71 L 89.78 78.26 L 93.46 78.41 L 97.13 78.14 L 100.75 77.46 L 104.27 76.37 L 107.64 74.91 L 110.84 73.07 L 113.80 70.89 L 116.50 68.39 L 118.91 65.60 L 120.99 62.56 L 122.71 59.31 L 124.06 55.88 L 125.02 52.32 L 125.57 48.68 L 125.71 45.01",
        "startXY": [
          60.06,
          46.15
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 125.97 43.15 L 124.88 41.57 L 123.61 40.12 L 122.19 38.83 L 120.63 37.70 L 118.96 36.76 L 117.19 36.00 L 115.35 35.46 L 113.45 35.12 L 111.53 35.00 L 109.61 35.10 L 107.72 35.41 L 105.87 35.93 L 104.08 36.65 L 102.40 37.58 L 100.82 38.68 L 99.39 39.96 L 98.10 41.39 L 96.98 42.95 L 96.05 44.63 L 95.31 46.41 L 94.78 48.26 L 94.45 50.15 L 94.34 52.07 L 94.34 122.55",
        "startXY": [
          125.97,
          43.15
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 94.34 105.22 L 94.34 143.67 L 94.31 144.27 L 94.21 144.85 L 94.05 145.43 L 93.82 145.98 L 93.53 146.50 L 93.19 146.98 L 92.80 147.43 L 92.35 147.83 L 91.87 148.17 L 91.35 148.46 L 90.80 148.69 L 90.23 148.86 L 89.64 148.96 L 89.05 149.00 L 88.46 148.97 L 87.87 148.87 L 87.30 148.71 L 86.75 148.49 L 86.22 148.21 L 85.73 147.87 L 85.29 147.47 L 84.89 147.03 L 84.54 146.55 L 84.24 146.03 L 84.01 145.49 L 83.84 144.92",
        "startXY": [
          94.34,
          105.22
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 85.22 145.35 L 132.69 145.35 L 133.51 145.30 L 134.33 145.16 L 135.13 144.93 L 135.89 144.61 L 136.61 144.20 L 137.28 143.71 L 137.90 143.15 L 138.44 142.52 L 138.91 141.83 L 139.29 141.10 L 139.59 140.33 L 139.80 139.52 L 139.92 138.70 L 139.94 137.87 L 139.87 137.05 L 139.70 136.23 L 139.45 135.45 L 139.10 134.69 L 138.67 133.98 L 138.16 133.33 L 137.58 132.73 L 136.94 132.21 L 136.24 131.76 L 135.49 131.40 L 134.71 131.12",
        "startXY": [
          85.22,
          145.35
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°4",
          "en": "Trace the hook #4"
        }
      }
    ]
  },
  {
    "char": "M",
    "name": {
      "fr": "M cursif",
      "en": "cursive M"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"M\" s'écrit d'un geste lié : crochet, trait, trait puis crochet.",
      "en": "In cursive, the letter \"M\" is written in one connected gesture: hook, line, line then hook."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 33.03 138.07 L 33.83 139.80 L 34.82 141.44 L 35.99 142.96 L 37.31 144.34 L 38.78 145.57 L 40.37 146.63 L 42.07 147.50 L 43.86 148.18 L 45.71 148.66 L 47.61 148.94 L 49.52 149.00 L 51.42 148.85 L 53.30 148.49 L 55.13 147.93 L 56.89 147.17 L 58.55 146.22 L 60.09 145.09 L 61.50 143.80 L 62.76 142.36 L 63.86 140.79 L 64.77 139.11 L 65.49 137.33 L 66.01 135.49 L 66.33 133.61 L 66.43 131.70 L 66.43 37.10",
        "startXY": [
          33.03,
          138.07
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 68.90 37.93 L 101.74 99.68",
        "startXY": [
          68.9,
          37.93
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 101.93 98.37 L 132.59 35.51",
        "startXY": [
          101.93,
          98.37
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 132.88 35.00 L 132.88 129.19 L 132.99 131.13 L 133.31 133.05 L 133.83 134.93 L 134.56 136.73 L 135.49 138.45 L 136.60 140.05 L 137.87 141.52 L 139.30 142.84 L 140.87 144.00 L 142.55 144.97 L 144.33 145.76 L 146.19 146.35 L 148.10 146.73 L 150.04 146.90 L 151.99 146.85 L 153.92 146.59 L 155.81 146.12 L 157.63 145.45 L 159.38 144.58 L 161.01 143.52 L 162.52 142.29 L 163.89 140.91 L 165.09 139.38 L 166.12 137.72 L 166.97 135.97",
        "startXY": [
          132.88,
          35
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°4",
          "en": "Trace the hook #4"
        }
      }
    ]
  },
  {
    "char": "N",
    "name": {
      "fr": "N cursif",
      "en": "cursive N"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"N\" s'écrit d'un geste lié : crochet, trait puis crochet.",
      "en": "In cursive, the letter \"N\" is written in one connected gesture: hook, line then hook."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 41.34 138.29 L 42.12 139.99 L 43.09 141.59 L 44.23 143.08 L 45.53 144.44 L 46.96 145.64 L 48.53 146.67 L 50.19 147.53 L 51.95 148.20 L 53.76 148.67 L 55.62 148.94 L 57.49 149.00 L 59.36 148.85 L 61.20 148.50 L 62.99 147.95 L 64.71 147.20 L 66.34 146.27 L 67.85 145.17 L 69.24 143.90 L 70.47 142.49 L 71.54 140.95 L 72.44 139.30 L 73.14 137.57 L 73.66 135.76 L 73.96 133.91 L 74.07 132.04 L 74.07 39.34",
        "startXY": [
          41.34,
          138.29
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 74.73 40.05 L 126.41 146.01",
        "startXY": [
          74.73,
          40.05
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 125.93 144.66 L 125.93 51.96 L 126.04 50.09 L 126.34 48.24 L 126.86 46.43 L 127.56 44.70 L 128.46 43.05 L 129.53 41.51 L 130.76 40.10 L 132.15 38.83 L 133.66 37.73 L 135.29 36.80 L 137.01 36.05 L 138.80 35.50 L 140.64 35.15 L 142.51 35.00 L 144.38 35.06 L 146.24 35.33 L 148.05 35.80 L 149.81 36.47 L 151.47 37.33 L 153.04 38.36 L 154.47 39.56 L 155.77 40.92 L 156.91 42.41 L 157.88 44.01 L 158.66 45.71",
        "startXY": [
          125.93,
          144.66
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3"
        }
      }
    ]
  },
  {
    "char": "Ñ",
    "name": {
      "fr": "Ñ cursif",
      "en": "cursive Ñ"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"Ñ\" s'écrit d'un geste lié : crochet, trait, crochet puis boucle de liaison.",
      "en": "In cursive, the letter \"Ñ\" is written in one connected gesture: hook, line, hook then connecting loop."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 65.21 142.65 L 65.68 143.66 L 66.25 144.61 L 66.93 145.49 L 67.70 146.29 L 68.55 147.01 L 69.48 147.62 L 70.47 148.13 L 71.51 148.53 L 72.58 148.80 L 73.68 148.96 L 74.79 149.00 L 75.90 148.91 L 76.99 148.71 L 78.06 148.38 L 79.08 147.93 L 80.04 147.38 L 80.94 146.73 L 81.76 145.98 L 82.49 145.14 L 83.12 144.23 L 83.66 143.25 L 84.08 142.22 L 84.38 141.15 L 84.56 140.05 L 84.62 138.94 L 84.62 83.97",
        "startXY": [
          65.21,
          142.65
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 85.02 84.40 L 115.66 147.23",
        "startXY": [
          85.02,
          84.4
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 115.38 146.43 L 115.38 91.46 L 115.44 90.35 L 115.62 89.25 L 115.92 88.18 L 116.34 87.15 L 116.88 86.18 L 117.51 85.26 L 118.24 84.43 L 119.06 83.68 L 119.96 83.02 L 120.92 82.47 L 121.94 82.03 L 123.01 81.70 L 124.10 81.49 L 125.21 81.40 L 126.32 81.44 L 127.42 81.60 L 128.49 81.88 L 129.53 82.27 L 130.52 82.78 L 131.45 83.40 L 132.30 84.11 L 133.07 84.91 L 133.75 85.79 L 134.32 86.75 L 134.79 87.76",
        "startXY": [
          115.38,
          146.43
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3"
        }
      },
      {
        "family": "crochet",
        "variant": "hd-bg",
        "pathD": "M 105.49 47.33 L 105.33 45.96 L 104.88 44.65 L 104.14 43.48 L 103.17 42.51 L 102.00 41.77 L 100.69 41.32 L 99.32 41.16 L 83.20 41.16 L 81.83 41.01 L 80.53 40.55 L 79.36 39.82 L 78.38 38.84 L 77.65 37.67 L 77.19 36.37 L 77.04 35.00",
        "startXY": [
          105.49,
          47.33
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le boucle de liaison n°4",
          "en": "Trace the connecting loop #4"
        }
      }
    ]
  },
  {
    "char": "O",
    "name": {
      "fr": "O cursif",
      "en": "cursive O"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"O\" s'écrit d'un geste lié : courbe puis courbe.",
      "en": "In cursive, the letter \"O\" is written in one connected gesture: curve then curve."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 115.77 37.04 L 104.44 35.00 L 92.93 35.27 L 81.72 37.85 L 71.24 42.62 L 61.94 49.40 L 54.18 57.90 L 48.29 67.79 L 44.51 78.66 L 42.97 90.07 L 43.76 101.55 L 46.84 112.64 L 52.08 122.89 L 59.26 131.88 L 68.11 139.24 L 78.25 144.69 L 89.28 147.98 L 100.74 149.00 L 112.18 147.70 L 123.12 144.13 L 133.12 138.43 L 141.78 130.85 L 148.74 121.68 L 153.73 111.31 L 156.52 100.14 L 157.03 88.65 L 155.21 77.28 L 151.15 66.51 L 145.02 56.77",
        "startXY": [
          115.77,
          37.04
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 148.12 62.10 L 146.77 60.11 L 145.20 58.29 L 143.44 56.66 L 141.51 55.23 L 139.44 54.03 L 137.24 53.06 L 134.94 52.35 L 132.59 51.90 L 130.19 51.72 L 127.79 51.81 L 125.42 52.16 L 123.10 52.78 L 120.86 53.66 L 118.74 54.78 L 116.75 56.13 L 114.93 57.69 L 113.30 59.45 L 111.87 61.38 L 110.67 63.45 L 109.70 65.65 L 108.99 67.95 L 108.54 70.30 L 108.36 72.70 L 108.45 75.10 L 108.80 77.47 L 109.42 79.79 L 110.30 82.03 L 111.41 84.15",
        "startXY": [
          148.12,
          62.1
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2"
        }
      }
    ]
  },
  {
    "char": "P",
    "name": {
      "fr": "P cursif",
      "en": "cursive P"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"P\" s'écrit d'un geste lié : crochet puis courbe.",
      "en": "In cursive, the letter \"P\" is written in one connected gesture: hook then curve."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 96.50 39.66 L 96.50 128.08 L 96.37 130.45 L 95.97 132.78 L 95.30 135.06 L 94.39 137.25 L 93.23 139.32 L 91.85 141.24 L 90.25 143.00 L 88.47 144.56 L 86.52 145.91 L 84.44 147.04 L 82.24 147.92 L 79.95 148.54 L 77.61 148.90 L 75.24 149.00 L 72.87 148.83 L 70.54 148.39 L 68.28 147.69 L 66.11 146.74 L 64.06 145.54 L 62.16 144.13 L 60.43 142.51 L 58.89 140.70 L 57.57 138.73",
        "startXY": [
          96.5,
          39.66
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 70.26 64.37 L 71.98 58.40 L 74.69 52.81 L 78.31 47.77 L 82.73 43.41 L 87.83 39.86 L 93.45 37.23 L 99.44 35.60 L 105.62 35.00 L 111.81 35.46 L 117.83 36.97 L 123.51 39.47 L 128.69 42.90 L 133.20 47.17 L 136.93 52.13 L 139.76 57.66 L 141.61 63.58 L 142.43 69.74 L 142.19 75.94 L 140.90 82.02 L 138.60 87.78 L 135.36 93.08 L 131.26 97.74 L 126.43 101.64 L 121.01 104.67 L 115.15 106.73 L 109.03 107.77 L 102.82 107.76 L 96.71 106.69",
        "startXY": [
          70.26,
          64.37
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2"
        }
      }
    ]
  },
  {
    "char": "Q",
    "name": {
      "fr": "Q cursif",
      "en": "cursive Q"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"Q\" s'écrit d'un geste lié : courbe, courbe puis trait.",
      "en": "In cursive, the letter \"Q\" is written in one connected gesture: curve, curve then line."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 72.46 35.00 L 64.10 40.50 L 56.81 47.36 L 50.81 55.37 L 46.27 64.29 L 43.34 73.86 L 42.09 83.79 L 42.57 93.79 L 44.76 103.56 L 48.60 112.80 L 53.97 121.25 L 60.72 128.64 L 68.63 134.77 L 77.48 139.45 L 87.00 142.53 L 96.91 143.93 L 106.92 143.61 L 116.72 141.57 L 126.02 137.88 L 134.55 132.64 L 142.05 126.02 L 148.30 118.20 L 153.12 109.42 L 156.35 99.95 L 157.91 90.06 L 157.74 80.06 L 155.86 70.23 L 152.31 60.87 L 147.21 52.26",
        "startXY": [
          72.46,
          35
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 148.87 55.77 L 147.56 53.08 L 145.95 50.56 L 144.06 48.25 L 141.90 46.18 L 139.52 44.38 L 136.94 42.87 L 134.21 41.67 L 131.35 40.80 L 128.41 40.28 L 125.42 40.10 L 122.44 40.28 L 119.50 40.80 L 116.64 41.67 L 113.90 42.87 L 111.33 44.38 L 108.94 46.18 L 106.79 48.25 L 104.90 50.56 L 103.28 53.08 L 101.98 55.77 L 101.00 58.59 L 100.36 61.51 L 100.07 64.48 L 100.13 67.47 L 100.54 70.43 L 101.29 73.32 L 102.38 76.10 L 103.79 78.74",
        "startXY": [
          148.87,
          55.77
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 131.39 112.94 L 155.71 149.00",
        "startXY": [
          131.39,
          112.94
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      }
    ]
  },
  {
    "char": "R",
    "name": {
      "fr": "R cursif",
      "en": "cursive R"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"R\" s'écrit d'un geste lié : crochet, courbe puis crochet.",
      "en": "In cursive, the letter \"R\" is written in one connected gesture: hook, curve then hook."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 90.53 38.65 L 90.53 129.42 L 90.41 131.58 L 90.05 133.71 L 89.45 135.80 L 88.63 137.80 L 87.59 139.70 L 86.35 141.47 L 84.92 143.10 L 83.31 144.55 L 81.55 145.82 L 79.67 146.88 L 77.68 147.73 L 75.60 148.35 L 73.47 148.74 L 71.31 148.89 L 69.15 148.80 L 67.00 148.47 L 64.91 147.90 L 62.90 147.10 L 60.99 146.09 L 59.20 144.87 L 57.56 143.46 L 56.08 141.87 L 54.79 140.13 L 53.70 138.26",
        "startXY": [
          90.53,
          38.65
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 63.47 66.75 L 65.06 60.45 L 67.71 54.52 L 71.33 49.12 L 75.83 44.43 L 81.05 40.57 L 86.86 37.66 L 93.08 35.78 L 99.53 35.00 L 106.02 35.33 L 112.36 36.76 L 118.36 39.26 L 123.84 42.74 L 128.65 47.11 L 132.65 52.23 L 135.70 57.96 L 137.74 64.14 L 138.69 70.56 L 138.53 77.06 L 137.26 83.43 L 134.92 89.49 L 131.58 95.07 L 127.34 99.99 L 122.32 104.11 L 116.67 107.32 L 110.55 109.51 L 104.15 110.62 L 97.65 110.63 L 91.25 109.53",
        "startXY": [
          63.47,
          66.75
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 110.26 110.77 L 130.81 144.96 L 131.33 145.73 L 131.94 146.44 L 132.62 147.07 L 133.37 147.63 L 134.18 148.10 L 135.03 148.47 L 135.92 148.75 L 136.84 148.93 L 137.77 149.00 L 138.70 148.97 L 139.63 148.83 L 140.53 148.60 L 141.40 148.26 L 142.23 147.83 L 143.00 147.31 L 143.71 146.70 L 144.35 146.02 L 144.91 145.27 L 145.38 144.47 L 145.76 143.61 L 146.04 142.72 L 146.22 141.81 L 146.30 140.88 L 146.27 139.95",
        "startXY": [
          110.26,
          110.77
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3"
        }
      }
    ]
  },
  {
    "char": "S",
    "name": {
      "fr": "S cursif",
      "en": "cursive S"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"S\" s'écrit d'un geste lié : courbe puis boucle de liaison.",
      "en": "In cursive, the letter \"S\" is written in one connected gesture: curve then connecting loop."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 65.88 57.20 L 66.39 60.51 L 67.43 63.68 L 68.96 66.66 L 70.95 69.34 L 73.34 71.68 L 76.08 73.60 L 79.08 75.07 L 82.28 76.03 L 85.60 76.47 L 88.94 76.38 L 92.22 75.75 L 95.36 74.60 L 98.28 72.97 L 100.90 70.90 L 103.16 68.43 L 104.99 65.63 L 106.35 62.58 L 107.20 59.34 L 107.53 56.02 L 107.32 52.68 L 106.59 49.42 L 105.34 46.32 L 103.61 43.46 L 101.44 40.91 L 98.90 38.74 L 96.04 37.00 L 92.95 35.75 L 89.69 35.00",
        "startXY": [
          65.88,
          57.2
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1"
        }
      },
      {
        "family": "crochet",
        "variant": "hd-bg",
        "pathD": "M 94.84 36.35 L 92.16 35.71 L 89.41 35.71 L 86.73 36.33 L 84.26 37.54 L 82.14 39.29 L 80.46 41.47 L 79.33 43.98 L 78.80 46.68 L 78.90 49.43 L 79.63 52.08 L 80.94 54.50 L 131.59 126.84 L 133.05 129.49 L 133.91 132.40 L 134.12 135.42 L 133.69 138.42 L 132.62 141.26 L 130.97 143.81 L 128.82 145.94 L 126.26 147.56 L 123.41 148.60 L 120.40 149.00 L 117.38 148.75",
        "startXY": [
          94.84,
          36.35
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le boucle de liaison n°2",
          "en": "Trace the connecting loop #2"
        }
      }
    ]
  },
  {
    "char": "T",
    "name": {
      "fr": "T cursif",
      "en": "cursive T"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"T\" s'écrit d'un geste lié : crochet, crochet puis trait.",
      "en": "In cursive, the letter \"T\" is written in one connected gesture: hook, hook then line."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 60.50 63.06 L 59.01 62.43 L 57.61 61.63 L 56.30 60.69 L 55.10 59.60 L 54.03 58.39 L 53.11 57.06 L 52.33 55.64 L 51.72 54.15 L 51.29 52.59 L 51.02 51.00 L 50.94 49.38 L 51.04 47.77 L 51.32 46.18 L 51.77 44.63 L 52.40 43.14 L 53.18 41.73 L 54.12 40.41 L 55.20 39.21 L 56.41 38.13 L 57.73 37.20 L 59.14 36.42 L 60.64 35.81 L 62.19 35.36 L 63.78 35.09 L 65.40 35.00 L 149.06 35.00",
        "startXY": [
          60.5,
          63.06
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 101.87 36.87 L 101.87 129.60 L 101.99 131.77 L 102.35 133.91 L 102.95 135.99 L 103.78 138.00 L 104.83 139.90 L 106.08 141.67 L 107.52 143.29 L 109.14 144.74 L 110.91 146.00 L 112.80 147.06 L 114.80 147.89 L 116.89 148.50 L 119.03 148.87 L 121.19 149.00 L 123.36 148.89 L 125.50 148.53 L 127.59 147.94 L 129.60 147.12 L 131.50 146.08 L 133.28 144.84 L 134.90 143.40 L 136.36 141.79 L 137.63 140.03 L 138.69 138.14",
        "startXY": [
          101.87,
          36.87
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 73.84 83.59 L 129.90 83.59",
        "startXY": [
          73.84,
          83.59
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      }
    ]
  },
  {
    "char": "U",
    "name": {
      "fr": "U cursif",
      "en": "cursive U"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"U\" s'écrit d'un geste lié : boucle de liaison puis crochet.",
      "en": "In cursive, the letter \"U\" is written in one connected gesture: connecting loop then hook."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "hd-bg",
        "pathD": "M 62.80 40.47 L 63.93 38.65 L 65.43 37.12 L 67.23 35.97 L 69.25 35.25 L 71.37 35.00 L 73.50 35.23 L 75.52 35.93 L 77.34 37.06 L 78.86 38.57 L 80.00 40.38 L 80.71 42.40 L 80.95 44.53 L 80.95 128.90 L 81.41 133.02 L 82.77 136.94 L 84.97 140.46 L 87.89 143.40 L 91.39 145.62 L 95.30 147.01 L 99.42 147.50 L 103.54 147.07 L 107.47 145.73",
        "startXY": [
          62.8,
          40.47
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le boucle de liaison n°1",
          "en": "Trace the connecting loop #1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 107.20 36.50 L 107.20 133.67 L 107.30 135.41 L 107.59 137.12 L 108.08 138.80 L 108.76 140.40 L 109.61 141.92 L 110.63 143.34 L 111.81 144.63 L 113.12 145.77 L 114.56 146.76 L 116.09 147.58 L 117.71 148.23 L 119.40 148.68 L 121.12 148.94 L 122.86 149.00 L 124.60 148.86 L 126.31 148.53 L 127.98 148.01 L 129.57 147.30 L 131.07 146.41 L 132.46 145.36 L 133.72 144.16 L 134.84 142.82 L 135.80 141.37 L 136.59 139.81 L 137.20 138.18",
        "startXY": [
          107.2,
          36.5
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2"
        }
      }
    ]
  },
  {
    "char": "V",
    "name": {
      "fr": "V cursif",
      "en": "cursive V"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"V\" s'écrit d'un geste lié : crochet, trait puis trait.",
      "en": "In cursive, the letter \"V\" is written in one connected gesture: hook, line then line."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 25.93 57.91 L 27.64 54.96 L 29.67 52.23 L 32.00 49.74 L 34.59 47.53 L 37.41 45.62 L 40.43 44.04 L 43.61 42.81 L 46.90 41.94 L 50.27 41.44 L 53.68 41.33 L 57.08 41.59 L 60.42 42.24 L 63.67 43.26 L 66.79 44.63 L 69.73 46.34 L 72.47 48.38 L 74.96 50.70 L 77.17 53.30 L 79.08 56.12 L 80.66 59.14 L 81.89 62.31 L 110.06 149.00",
        "startXY": [
          25.93,
          57.91
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 111.11 148.44 L 143.36 36.00",
        "startXY": [
          111.11,
          148.44
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 143.69 35.00 L 174.07 35.00",
        "startXY": [
          143.69,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      }
    ]
  },
  {
    "char": "W",
    "name": {
      "fr": "W cursif",
      "en": "cursive W"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"W\" s'écrit d'un geste lié : crochet, trait, trait, trait puis trait.",
      "en": "In cursive, the letter \"W\" is written in one connected gesture: hook, line, line, line then line."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 8.83 49.98 L 10.77 47.11 L 13.03 44.48 L 15.57 42.12 L 18.35 40.06 L 21.35 38.33 L 24.52 36.94 L 27.83 35.91 L 31.23 35.26 L 34.69 35.00 L 38.15 35.13 L 41.58 35.64 L 44.92 36.53 L 48.15 37.79 L 51.22 39.41 L 54.08 41.35 L 56.71 43.61 L 59.07 46.15 L 61.13 48.93 L 62.87 51.93 L 64.25 55.10 L 65.28 58.41 L 87.70 148.34",
        "startXY": [
          8.83,
          49.98
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 112.44 51.26 L 88.15 148.68",
        "startXY": [
          112.44,
          51.26
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 115.04 52.49 L 142.71 149.00",
        "startXY": [
          115.04,
          52.49
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 167.46 50.80 L 144.87 148.63",
        "startXY": [
          167.46,
          50.8
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 168.01 51.32 L 191.17 51.32",
        "startXY": [
          168.01,
          51.32
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      }
    ]
  },
  {
    "char": "X",
    "name": {
      "fr": "X cursif",
      "en": "cursive X"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"X\" s'écrit d'un geste lié : courbe puis courbe.",
      "en": "In cursive, the letter \"X\" is written in one connected gesture: curve then curve."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 16.77 41.17 L 24.42 37.95 L 32.45 35.88 L 40.70 35.00 L 48.98 35.33 L 57.14 36.85 L 64.98 39.55 L 72.35 43.35 L 79.09 48.19 L 85.05 53.96 L 90.11 60.53 L 94.16 67.76 L 97.12 75.51 L 98.92 83.61 L 99.53 91.88 L 98.92 100.15 L 97.12 108.25 L 94.16 116.00 L 90.11 123.23 L 85.05 129.81 L 79.09 135.57 L 72.35 140.41 L 64.98 144.22 L 57.14 146.91 L 48.98 148.44 L 40.70 148.76 L 32.45 147.88 L 24.42 145.81 L 16.77 142.59",
        "startXY": [
          16.77,
          41.17
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 183.23 41.41 L 175.58 38.19 L 167.55 36.12 L 159.30 35.24 L 151.02 35.56 L 142.86 37.09 L 135.02 39.78 L 127.65 43.59 L 120.91 48.43 L 114.95 54.19 L 109.89 60.77 L 105.84 68.00 L 102.88 75.75 L 101.08 83.85 L 100.47 92.12 L 101.08 100.39 L 102.88 108.49 L 105.84 116.24 L 109.89 123.47 L 114.95 130.04 L 120.91 135.81 L 127.65 140.65 L 135.02 144.45 L 142.86 147.15 L 151.02 148.67 L 159.30 149.00 L 167.55 148.12 L 175.58 146.05 L 183.23 142.83",
        "startXY": [
          183.23,
          41.41
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2"
        }
      }
    ]
  },
  {
    "char": "Y",
    "name": {
      "fr": "Y cursif",
      "en": "cursive Y"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"Y\" s'écrit d'un geste lié : crochet, trait puis crochet.",
      "en": "In cursive, the letter \"Y\" is written in one connected gesture: hook, line then hook."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 74.85 35.76 L 74.85 67.36 L 74.94 68.91 L 75.20 70.44 L 75.62 71.92 L 76.21 73.35 L 76.96 74.71 L 77.85 75.97 L 78.87 77.13 L 80.02 78.17 L 81.28 79.07 L 82.63 79.83 L 84.06 80.43 L 85.54 80.87 L 87.06 81.14 L 88.61 81.24 L 90.15 81.16 L 91.68 80.92 L 93.17 80.50 L 94.61 79.93 L 95.97 79.19",
        "startXY": [
          74.85,
          35.76
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 97.97 35.00 L 97.97 148.69",
        "startXY": [
          97.97,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 96.69 147.82 L 94.97 148.41 L 93.20 148.80 L 91.40 149.00 L 89.59 149.00 L 87.79 148.79 L 86.02 148.39 L 84.30 147.80 L 82.67 147.02 L 81.12 146.07 L 79.70 144.95 L 78.40 143.68 L 77.26 142.27 L 76.27 140.75 L 75.46 139.13 L 74.84 137.43 L 74.40 135.67 L 74.16 133.87 L 74.13 132.06 L 74.29 130.25 L 74.65 128.47 L 75.20 126.75 L 75.95 125.09 L 76.87 123.53 L 77.95 122.08 L 125.87 64.97",
        "startXY": [
          96.69,
          147.82
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3"
        }
      }
    ]
  },
  {
    "char": "Z",
    "name": {
      "fr": "Z cursif",
      "en": "cursive Z"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"Z\" s'écrit d'un geste lié : crochet, trait, crochet puis trait.",
      "en": "In cursive, the letter \"Z\" is written in one connected gesture: hook, line, hook then line."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 70.34 35.00 L 69.41 35.91 L 68.59 36.91 L 67.88 38.01 L 67.31 39.17 L 66.86 40.39 L 66.55 41.66 L 66.39 42.95 L 66.37 44.25 L 66.50 45.54 L 66.77 46.81 L 67.18 48.05 L 67.73 49.23 L 68.40 50.34 L 69.20 51.37 L 70.10 52.30 L 71.10 53.13 L 72.19 53.84 L 73.36 54.42 L 74.57 54.87 L 75.84 55.18 L 77.13 55.35 L 78.43 55.38 L 79.72 55.25 L 80.99 54.99 L 134.67 40.61",
        "startXY": [
          70.34,
          35
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 134.75 39.89 L 65.21 146.96",
        "startXY": [
          134.75,
          39.89
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 66.95 147.15 L 121.04 130.62 L 122.17 130.34 L 123.33 130.18 L 124.50 130.16 L 125.67 130.26 L 126.81 130.49 L 127.93 130.84 L 129.00 131.32 L 130.01 131.91 L 130.95 132.60 L 131.80 133.40 L 132.57 134.28 L 133.23 135.25 L 133.78 136.28 L 134.22 137.36 L 134.54 138.49 L 134.73 139.64 L 134.79 140.81 L 134.72 141.98 L 134.53 143.13 L 134.21 144.25 L 133.77 145.34 L 133.21 146.37 L 132.54 147.33 L 131.78 148.21 L 130.92 149.00",
        "startXY": [
          66.95,
          147.15
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 81.39 92.31 L 121.71 92.31",
        "startXY": [
          81.39,
          92.31
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      }
    ]
  },
  {
    "char": "b",
    "name": {
      "fr": "b cursif",
      "en": "cursive b"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"b\" s'écrit d'un geste lié : crochet, crochet, trait.",
      "en": "In cursive, the letter \"b\" is written in one connected gesture: hook, hook, line."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 69.32 124.79 L 93.79 53.73 L 94.21 52.24 L 94.47 50.71 L 94.56 49.15 L 94.48 47.60 L 94.22 46.07 L 93.80 44.57 L 93.22 43.13 L 92.49 41.76 L 91.61 40.48 L 90.59 39.31 L 89.45 38.25 L 88.20 37.33 L 86.86 36.54 L 85.44 35.91 L 83.96 35.44 L 82.44 35.14 L 80.89 35.00 L 79.34 35.03 L 77.80 35.24 L 76.29 35.61 L 74.83 36.15 L 73.44 36.84 L 72.13 37.68 L 70.92 38.66 L 69.34 40.11",
        "startXY": [
          69.32,
          124.79
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 69.34 40.11 L 69.34 136.95 L 69.41 138.32 L 69.65 139.67 L 70.03 140.98 L 70.56 142.24 L 71.23 143.43 L 72.03 144.54 L 72.95 145.55 L 73.98 146.46 L 75.10 147.23 L 76.31 147.88 L 77.58 148.39 L 78.90 148.74 L 80.25 148.95 L 81.62 149.00 L 82.98 148.90 L 84.33 148.64 L 85.63 148.23 L 86.88 147.68 L 88.06 146.98 L 89.16 146.16 L 90.15 145.22 L 91.03 144.18 L 91.79 143.04 L 92.41 141.82 L 92.89 140.54 L 93.22 139.21 L 93.44 137.86 L 93.58 136.52 L 93.65 135.18 L 93.64 133.84 L 93.55 132.50 L 93.39 131.16 L 93.16 129.82 L 92.88 128.48 L 92.68 127.14 L 92.57 125.80 L 92.57 124.79",
        "startXY": [
          69.34,
          40.11
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 92.57 124.79 L 108.68 124.79",
        "startXY": [
          92.57,
          124.79
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      }
    ]
  },
  {
    "char": "g",
    "name": {
      "fr": "g cursif",
      "en": "cursive g"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "En cursive, la lettre \"g\" s'écrit d'un geste lié : courbe, trait, crochet.",
      "en": "In cursive, the letter \"g\" is written in one connected gesture: curve, line, hook."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 113.44 52.31 A 27.30 27.30 0 1 0 113.44 83.20",
        "startXY": [
          113.44,
          52.31
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 113.71 43.55 L 113.71 177.95",
        "startXY": [
          113.71,
          43.55
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 113.74 178.19 A 17.67 17.67 0 0 1 90.32 153.84 L 123.35 94.26",
        "startXY": [
          113.74,
          178.19
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3"
        }
      }
    ]
  },
  {
    "char": "j",
    "name": {
      "fr": "j cursif",
      "en": "cursive j"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "En cursive, la lettre \"j\" s'écrit d'un geste lié : trait, trait, crochet, point.",
      "en": "In cursive, the letter \"j\" is written in one connected gesture: line, line, hook, dot."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 94.14 79.54 L 113.86 42.46",
        "startXY": [
          94.14,
          79.54
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 113.71 43.55 L 113.71 177.95",
        "startXY": [
          113.71,
          43.55
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 113.74 178.19 A 17.67 17.67 0 0 1 90.32 153.84 L 123.35 94.26",
        "startXY": [
          113.74,
          178.19
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3"
        }
      },
      {
        "family": "point",
        "variant": "cursive-point",
        "pathD": "M 114.13 18.57 A 6.16 6.16 0 1 0 114.20 18.57",
        "startXY": [
          114.13,
          18.57
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le point n°4",
          "en": "Trace the dot #4"
        }
      }
    ]
  },
  {
    "char": "m",
    "name": {
      "fr": "m cursif",
      "en": "cursive m"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "En cursive, la lettre \"m\" s'écrit d'un geste lié : courbe, courbe, courbe.",
      "en": "In cursive, the letter \"m\" is written in one connected gesture: curve, curve, curve."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 21 77 C 21 67.6 28.6 60 38 60 C 47.4 60 55 67.6 55 77 L 55 149",
        "startXY": [
          21,
          77
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 55 77 C 55 67.6 62.6 60 72 60 C 81.4 60 89 67.6 89 77 L 89 149",
        "startXY": [
          55,
          77
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 89 77 C 89 67.6 96.6 60 106 60 C 115.4 60 123 67.6 123 77 L 123 140 C 123 146 126 149 130 149.3 C 133 150 138 148 139 145",
        "startXY": [
          89,
          77
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°3",
          "en": "Trace the curve #3"
        }
      }
    ]
  },
  {
    "char": "n",
    "name": {
      "fr": "n cursif",
      "en": "cursive n"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "En cursive, la lettre \"n\" s'écrit d'un geste lié : courbe, courbe.",
      "en": "In cursive, the letter \"n\" is written in one connected gesture: curve, curve."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 55 77 C 55 67.6 62.6 60 72 60 C 81.4 60 89 67.6 89 77 L 89 149",
        "startXY": [
          55,
          77
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 89 77 C 89 67.6 96.6 60 106 60 C 115.4 60 123 67.6 123 77 L 123 140 C 123 146 126 149 130 149.3 C 133 150 138 148 139 145",
        "startXY": [
          89,
          77
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2"
        }
      }
    ]
  },
  {
    "char": "ñ",
    "name": {
      "fr": "ñ cursif",
      "en": "cursive ñ"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "En cursive, la lettre \"ñ\" s'écrit d'un geste lié : courbe, courbe, boucle de liaison.",
      "en": "In cursive, the letter \"ñ\" is written in one connected gesture: curve, curve, connecting loop."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 55 77 C 55 67.6 62.6 60 72 60 C 81.4 60 89 67.6 89 77 L 89 149",
        "startXY": [
          55,
          77
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 89 77 C 89 67.6 96.6 60 106 60 C 115.4 60 123 67.6 123 77 L 123 140 C 123 146 126 149 130 149.3 C 133 150 138 148 139 145",
        "startXY": [
          89,
          77
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°2",
          "en": "Trace the curve #2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-double-crochet",
        "pathD": "M 99.50 75.55 A 4.55 4.55 0 0 0 94.95 71.00 L 89.00 71.00 L 83.05 71.00 A 4.55 4.55 0 0 1 78.50 66.45",
        "startXY": [
          99.5,
          75.55
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le boucle de liaison n°3",
          "en": "Trace the connecting loop #3"
        }
      }
    ]
  },
  {
    "char": "f",
    "name": {
      "fr": "f cursif",
      "en": "cursive f"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"f\" s'écrit d'un geste lié : crochet, crochet, crochet, crochet, crochet.",
      "en": "In cursive, the letter \"f\" is written in one connected gesture: hook, hook, hook, hook, hook."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 80.64 89.93 L 110.35 59.17 A 14.25 14.25 0.00 0 0 99.85 35.03",
        "startXY": [
          80.64,
          89.93
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 111.54 40.31 A 11.12 11.12 0.00 0 0 90.95 46.10 L 90.95 92.00",
        "startXY": [
          111.54,
          40.31
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 90.95 92.00 L 90.95 134.76 A 14.25 14.25 0.00 0 0 115.27 144.83",
        "startXY": [
          90.95,
          92
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 103.37 148.73 A 14.25 14.25 0.00 0 0 116.34 125.80 L 90.02 92.09",
        "startXY": [
          103.37,
          148.73
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°4",
          "en": "Trace the hook #4"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 91.11 102.90 A 5.34 5.34 0.00 0 0 100.31 106.54 L 111.45 94.99",
        "startXY": [
          91.11,
          102.9
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°5",
          "en": "Trace the hook #5"
        }
      }
    ]
  },
  {
    "char": "k",
    "name": {
      "fr": "k cursif",
      "en": "cursive k"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"k\" s'écrit d'un geste lié : crochet, trait, courbe, crochet, crochet.",
      "en": "In cursive, the letter \"k\" is written in one connected gesture: hook, line, curve, hook, hook."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 83.89 104.42 L 105.30 51.45 A 11.96 11.96 0.00 0 0 86.23 38.05",
        "startXY": [
          83.89,
          104.42
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 86.20 38.72 L 86.20 145.04",
        "startXY": [
          86.2,
          38.72
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 87.46 106.44 A 15.95 15.95 0.00 1 1 87.46 132.24",
        "startXY": [
          87.46,
          106.44
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°3",
          "en": "Trace the curve #3"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 87.54 132.99 A 4.38 4.38 0.00 0 1 95.55 130.56 L 105.00 144.54",
        "startXY": [
          87.54,
          132.99
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°4",
          "en": "Trace the hook #4"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 97.38 133.68 L 106.52 146.74 A 5.32 5.32 0.00 0 0 116.11 144.61",
        "startXY": [
          97.38,
          133.68
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°5",
          "en": "Trace the hook #5"
        }
      }
    ]
  },
  {
    "char": "p",
    "name": {
      "fr": "p cursif",
      "en": "cursive p"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "En cursive, la lettre \"p\" s'écrit d'un geste lié : trait, trait, courbe.",
      "en": "In cursive, the letter \"p\" is written in one connected gesture: line, line, curve."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 83 100 L 101 77",
        "startXY": [
          83,
          100
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 101 68 L 101 180",
        "startXY": [
          101,
          68
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 101 95 C 101 80 110 72 123 75 C 126 76 129 79 130 82 C 131 86 131 90 131 94 C 131 100 133 103 136 103 C 136 103 140 104 142 98",
        "startXY": [
          101,
          95
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°3",
          "en": "Trace the curve #3"
        }
      }
    ]
  },
  {
    "char": "r",
    "name": {
      "fr": "r cursif",
      "en": "cursive r"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "En cursive, la lettre \"r\" s'écrit d'un geste lié : trait, crochet, crochet.",
      "en": "In cursive, the letter \"r\" is written in one connected gesture: line, hook, hook."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 47 100.34 L 67 50.42",
        "startXY": [
          47,
          100.34
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 61.26 50.40 A 5.12 5.12 0 0 0 61.62 58.60 L 105.30 58.60",
        "startXY": [
          61.26,
          50.4
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 105.28 58.04 L 105.28 105.57 A 10.67 10.67 0 0 0 125.21 109.49",
        "startXY": [
          105.28,
          58.04
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°3",
          "en": "Trace the hook #3"
        }
      }
    ]
  },
  {
    "char": "s",
    "name": {
      "fr": "s cursif",
      "en": "cursive s"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "En cursive, la lettre \"s\" s'écrit d'un geste lié : trait, crochet.",
      "en": "In cursive, the letter \"s\" is written in one connected gesture: line, hook."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 71 124 L 107 64",
        "startXY": [
          71,
          124
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 108 63 L 129 113 A 18 18 0 0 1 106 136",
        "startXY": [
          108,
          63
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2"
        }
      }
    ]
  },
  {
    "char": "t",
    "name": {
      "fr": "t cursif",
      "en": "cursive t"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"t\" s'écrit d'un geste lié : crochet, trait.",
      "en": "In cursive, the letter \"t\" is written in one connected gesture: hook, line."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 97 27 L 97 140 C 97 146 100 149 105 149.3 C 107 150 115 149 119 145",
        "startXY": [
          97,
          27
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 97 51 L 117 51",
        "startXY": [
          97,
          51
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      }
    ]
  },
  {
    "char": "u",
    "name": {
      "fr": "u cursif",
      "en": "cursive u"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "En cursive, la lettre \"u\" s'écrit d'un geste lié : crochet, crochet.",
      "en": "In cursive, the letter \"u\" is written in one connected gesture: hook, hook."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 68 60 L 68 118 C 68 140 84 150 102 150 C 120 150 132 140 132 118",
        "startXY": [
          68,
          60
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 132 60 L 132 140 C 133 146 137 149 141 149.6 C 145 150 149 148 150 145",
        "startXY": [
          132,
          60
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2"
        }
      }
    ]
  },
  {
    "char": "q",
    "name": {
      "fr": "q cursif",
      "en": "cursive q"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "En cursive, la lettre \"q\" s'écrit d'un geste lié : courbe, trait, trait.",
      "en": "In cursive, the letter \"q\" is written in one connected gesture: curve, line, line."
    },
    "steps": [
      {
        "family": "courbe",
        "variant": "cursive-courbe",
        "pathD": "M 125 75.3 C 115.4 63.5 99.4 59 85 64.1 C 70.6 69.2 61 82.8 61 98 C 61 113.2 70.6 126.8 85 131.9 C 99.4 137 115.4 132.5 125 120",
        "startXY": [
          125,
          75.3
        ],
        "strokeColor": "#E05252",
        "description": {
          "fr": "Trace le courbe n°1",
          "en": "Trace the curve #1"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 125 62 L 125 195",
        "startXY": [
          125,
          62
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "cursive-trait",
        "pathD": "M 125 133 L 145 110",
        "startXY": [
          125,
          133
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      }
    ]
  },
  {
    "char": "l",
    "name": {
      "fr": "l cursif",
      "en": "cursive l"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "En cursive, la lettre \"l\" s'écrit d'un geste lié : crochet, crochet.",
      "en": "In cursive, the letter \"l\" is written in one connected gesture: hook, hook."
    },
    "steps": [
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 86 115 L 107 36 A 11.3 11.3 0 0 0 86 28",
        "startXY": [
          86,
          115
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°1",
          "en": "Trace the hook #1"
        }
      },
      {
        "family": "crochet",
        "variant": "cursive-crochet",
        "pathD": "M 86 28.5 L 86 133 A 12 12 0 0 0 110 135",
        "startXY": [
          86,
          28.5
        ],
        "strokeColor": "#4A90E2",
        "description": {
          "fr": "Trace le crochet n°2",
          "en": "Trace the hook #2"
        }
      }
    ]
  }
]
''');

final Map<String, dynamic> CURSIVE_MAP = {
  for (final l in CURSIVE_LETTERS) l['char'] as String: l,
};
