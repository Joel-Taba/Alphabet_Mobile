import 'dart:convert';

/// CATALOGUE DIGITAL — extrait/résolu depuis Web (src/data/digital-formation-catalog.ts), tracés déjà calculés (plus de système de tampons procédural ici).
final List<dynamic> DIGITAL_LETTERS = jsonDecode(r'''
[
  {
    "char": "a",
    "name": {
      "fr": "a digital",
      "en": "digital a"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"a\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"a\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 118.83 82.72 L 93.65 81.84",
        "startXY": [
          118.83,
          82.72
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 91.95 81.94 L 79.25 99.42",
        "startXY": [
          91.95,
          81.94
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 78.64 100.88 L 78.64 126.08",
        "startXY": [
          78.64,
          100.88
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 79.88 126.24 L 95.16 141.52",
        "startXY": [
          79.88,
          126.24
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 97.00 141.32 L 118.60 141.32",
        "startXY": [
          97,
          141.32
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 121.36 77.00 L 121.36 149.00",
        "startXY": [
          121.36,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      }
    ]
  },
  {
    "char": "b",
    "name": {
      "fr": "b digital",
      "en": "digital b"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"b\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"b\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 77.44 35.00 L 77.44 149.00",
        "startXY": [
          77.44,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 79.15 91.73 L 109.93 92.27",
        "startXY": [
          79.15,
          91.73
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 111.73 92.69 L 122.56 111.45",
        "startXY": [
          111.73,
          92.69
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 122.09 110.24 L 122.09 130.76",
        "startXY": [
          122.09,
          110.24
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 119.69 132.25 L 103.59 146.75",
        "startXY": [
          119.69,
          132.25
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 103.28 147.10 L 78.20 147.10",
        "startXY": [
          103.28,
          147.1
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      }
    ]
  },
  {
    "char": "c",
    "name": {
      "fr": "c digital",
      "en": "digital c"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"c\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"c\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 127.66 78.74 L 73.26 77.79",
        "startXY": [
          127.66,
          78.74
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 72.34 77.00 L 72.34 147.73",
        "startXY": [
          72.34,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 72.34 149.00 L 126.75 149.00",
        "startXY": [
          72.34,
          149
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
    "char": "d",
    "name": {
      "fr": "d digital",
      "en": "digital d"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"d\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"d\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 120.85 35.00 L 120.85 149.00",
        "startXY": [
          120.85,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 116.60 98.71 L 92.46 98.71",
        "startXY": [
          116.6,
          98.71
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 92.71 99.17 L 80.60 115.23",
        "startXY": [
          92.71,
          99.17
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 79.85 115.03 L 79.15 128.43",
        "startXY": [
          79.85,
          115.03
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 80.05 129.11 L 93.25 144.30",
        "startXY": [
          80.05,
          129.11
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 92.46 143.41 L 116.60 143.41",
        "startXY": [
          92.46,
          143.41
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      }
    ]
  },
  {
    "char": "q",
    "name": {
      "fr": "q digital",
      "en": "digital q"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "En digital, la lettre \"q\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"q\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 120.03 86.26 L 110.98 77.52",
        "startXY": [
          120.03,
          86.26
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 110.62 77.70 L 89.66 77.70",
        "startXY": [
          110.62,
          77.7
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 89.17 78.23 L 80.38 88.35",
        "startXY": [
          89.17,
          78.23
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 79.19 89.43 L 79.19 116.25",
        "startXY": [
          79.19,
          89.43
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 79.51 116.05 L 87.25 125.95",
        "startXY": [
          79.51,
          116.05
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 88.27 126.59 L 109.22 126.59",
        "startXY": [
          88.27,
          126.59
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 110.55 126.38 L 119.90 115.62",
        "startXY": [
          110.55,
          126.38
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°7",
          "en": "Trace the line #7"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 120.81 77.00 L 120.81 165.00",
        "startXY": [
          120.81,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°8",
          "en": "Trace the line #8"
        }
      }
    ]
  },
  {
    "char": "o",
    "name": {
      "fr": "o digital",
      "en": "digital o"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"o\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"o\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 116.19 77.32 L 85.06 77.32",
        "startXY": [
          116.19,
          77.32
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 84.33 78.10 L 71.26 93.13",
        "startXY": [
          84.33,
          78.1
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 69.91 95.58 L 69.91 132.93",
        "startXY": [
          69.91,
          95.58
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 71.01 134.28 L 82.51 149.00",
        "startXY": [
          71.01,
          134.28
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 83.40 148.90 L 114.53 148.90",
        "startXY": [
          83.4,
          148.9
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 115.88 148.18 L 129.77 132.20",
        "startXY": [
          115.88,
          148.18
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 130.09 130.44 L 130.09 90.60",
        "startXY": [
          130.09,
          130.44
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°7",
          "en": "Trace the line #7"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 129.87 89.25 L 115.78 77.00",
        "startXY": [
          129.87,
          89.25
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°8",
          "en": "Trace the line #8"
        }
      }
    ]
  },
  {
    "char": "p",
    "name": {
      "fr": "p digital",
      "en": "digital p"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "En digital, la lettre \"p\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"p\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 79.27 80.11 L 79.27 165.00",
        "startXY": [
          79.27,
          80.11
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 80.19 88.07 L 89.10 77.82",
        "startXY": [
          80.19,
          88.07
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 89.88 77.00 L 111.11 77.00",
        "startXY": [
          89.88,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 111.48 77.10 L 120.64 85.95",
        "startXY": [
          111.48,
          77.1
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 120.73 86.76 L 120.73 113.93",
        "startXY": [
          120.73,
          86.76
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 120.08 114.99 L 110.62 125.88",
        "startXY": [
          120.08,
          114.99
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 109.69 126.80 L 88.47 126.80",
        "startXY": [
          109.69,
          126.8
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°7",
          "en": "Trace the line #7"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 87.44 126.16 L 79.60 116.12",
        "startXY": [
          87.44,
          126.16
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°8",
          "en": "Trace the line #8"
        }
      }
    ]
  },
  {
    "char": "r",
    "name": {
      "fr": "r digital",
      "en": "digital r"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"r\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"r\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 71.16 77.00 L 71.16 149.00",
        "startXY": [
          71.16,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 73.20 104.17 L 88.31 86.79",
        "startXY": [
          73.2,
          104.17
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 90.36 85.88 L 111.96 85.88",
        "startXY": [
          90.36,
          85.88
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 113.31 86.30 L 128.84 101.30",
        "startXY": [
          113.31,
          86.3
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
    "char": "e",
    "name": {
      "fr": "e digital",
      "en": "digital e"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"e\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"e\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 72.37 113.14 L 130.00 113.14",
        "startXY": [
          72.37,
          113.14
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 130.22 109.79 L 130.22 89.69",
        "startXY": [
          130.22,
          109.79
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 130.62 91.21 L 116.41 77.00",
        "startXY": [
          130.62,
          91.21
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 113.91 77.41 L 89.79 77.41",
        "startXY": [
          113.91,
          77.41
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 86.98 78.20 L 70.72 90.01",
        "startXY": [
          86.98,
          78.2
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 69.92 91.92 L 69.92 125.42",
        "startXY": [
          69.92,
          91.92
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 69.38 126.42 L 88.33 149.00",
        "startXY": [
          69.38,
          126.42
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°7",
          "en": "Trace the line #7"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 90.46 148.88 L 125.30 148.88",
        "startXY": [
          90.46,
          148.88
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°8",
          "en": "Trace the line #8"
        }
      }
    ]
  },
  {
    "char": "g",
    "name": {
      "fr": "g digital",
      "en": "digital g"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "En digital, la lettre \"g\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"g\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 112.51 84.96 L 107.61 78.69",
        "startXY": [
          112.51,
          84.96
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 106.45 78.21 L 91.98 78.21",
        "startXY": [
          106.45,
          78.21
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 91.55 78.63 L 82.77 85.01",
        "startXY": [
          91.55,
          78.63
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 82.34 86.04 L 82.34 104.12",
        "startXY": [
          82.34,
          86.04
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 82.05 104.66 L 92.27 116.85",
        "startXY": [
          82.05,
          104.66
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 91.98 116.78 L 106.45 116.78",
        "startXY": [
          91.98,
          116.78
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 107.30 117.23 L 112.83 111.51",
        "startXY": [
          107.3,
          117.23
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°7",
          "en": "Trace the line #7"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 113.68 77.00 L 113.68 163.79",
        "startXY": [
          113.68,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°8",
          "en": "Trace the line #8"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 114.40 165.00 L 105.72 165.00",
        "startXY": [
          114.4,
          165
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°9",
          "en": "Trace the line #9"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 104.05 164.53 L 94.38 155.82",
        "startXY": [
          104.05,
          164.53
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°10",
          "en": "Trace the line #10"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 94.39 154.15 L 94.39 146.92",
        "startXY": [
          94.39,
          154.15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°11",
          "en": "Trace the line #11"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 94.94 146.37 L 117.95 123.36",
        "startXY": [
          94.94,
          146.37
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°12",
          "en": "Trace the line #12"
        }
      }
    ]
  },
  {
    "char": "f",
    "name": {
      "fr": "f digital",
      "en": "digital f"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"f\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"f\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 142.30 51.15 L 131.09 35.14",
        "startXY": [
          142.3,
          51.15
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 130.99 35.00 L 101.68 35.00",
        "startXY": [
          130.99,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 100.07 35.88 L 87.00 50.40",
        "startXY": [
          100.07,
          35.88
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 87.02 51.29 L 87.02 149.00",
        "startXY": [
          87.02,
          51.29
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 57.70 92.00 L 116.33 92.00",
        "startXY": [
          57.7,
          92
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
    "char": "n",
    "name": {
      "fr": "n digital",
      "en": "digital n"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"n\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"n\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 67.52 77.00 L 67.52 147.36",
        "startXY": [
          67.52,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 68.10 103.73 L 78.66 85.45",
        "startXY": [
          68.1,
          103.73
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 79.71 84.50 L 114.89 84.50",
        "startXY": [
          79.71,
          84.5
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 115.14 84.62 L 131.07 98.46",
        "startXY": [
          115.14,
          84.62
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 132.48 99.75 L 132.48 149.00",
        "startXY": [
          132.48,
          99.75
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
    "char": "ñ",
    "name": {
      "fr": "ñ digital",
      "en": "digital ñ"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"ñ\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"ñ\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 80.22 98.19 L 80.22 147.84",
        "startXY": [
          80.22,
          98.19
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 80.63 117.05 L 88.08 104.15",
        "startXY": [
          80.63,
          117.05
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 88.83 103.48 L 113.66 103.48",
        "startXY": [
          88.83,
          103.48
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 113.83 103.56 L 125.07 113.33",
        "startXY": [
          113.83,
          103.56
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 126.07 114.24 L 126.07 149.00",
        "startXY": [
          126.07,
          114.24
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 108.69 77.00 L 73.93 77.00",
        "startXY": [
          108.69,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      }
    ]
  },
  {
    "char": "m",
    "name": {
      "fr": "m digital",
      "en": "digital m"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"m\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"m\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 46.68 84.00 L 46.68 140.13",
        "startXY": [
          46.68,
          84
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 47.34 109.52 L 57.24 95.90",
        "startXY": [
          47.34,
          109.52
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 58.84 95.23 L 86.90 95.23",
        "startXY": [
          58.84,
          95.23
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 87.10 95.32 L 99.81 106.36",
        "startXY": [
          87.1,
          95.32
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 100.94 108.32 L 100.94 142.00",
        "startXY": [
          100.94,
          108.32
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 101.60 107.65 L 111.50 94.03",
        "startXY": [
          101.6,
          107.65
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 112.16 93.92 L 140.23 93.92",
        "startXY": [
          112.16,
          93.92
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°7",
          "en": "Trace the line #7"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 140.05 94.01 L 152.75 105.05",
        "startXY": [
          140.05,
          94.01
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°8",
          "en": "Trace the line #8"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 153.32 105.33 L 153.32 141.25",
        "startXY": [
          153.32,
          105.33
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°9",
          "en": "Trace the line #9"
        }
      }
    ]
  },
  {
    "char": "s",
    "name": {
      "fr": "s digital",
      "en": "digital s"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"s\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"s\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 117.24 77.00 L 82.33 77.00",
        "startXY": [
          117.24,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 82.33 78.89 L 82.33 113.80",
        "startXY": [
          82.33,
          78.89
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 82.76 114.09 L 117.67 114.09",
        "startXY": [
          82.76,
          114.09
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 117.67 114.09 L 117.67 149.00",
        "startXY": [
          117.67,
          114.09
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 117.24 149.00 L 82.33 149.00",
        "startXY": [
          117.24,
          149
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
    "char": "t",
    "name": {
      "fr": "t digital",
      "en": "digital t"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"t\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"t\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 97.29 35.00 L 97.29 149.00",
        "startXY": [
          97.29,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 67.43 78.43 L 132.57 78.43",
        "startXY": [
          67.43,
          78.43
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
    "char": "x",
    "name": {
      "fr": "x digital",
      "en": "digital x"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"x\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"x\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 118.37 77.57 L 83.53 149.00",
        "startXY": [
          118.37,
          77.57
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 81.63 77.00 L 116.47 148.43",
        "startXY": [
          81.63,
          77
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
    "char": "y",
    "name": {
      "fr": "y digital",
      "en": "digital y"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "En digital, la lettre \"y\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"y\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 82.32 77.00 L 82.32 114.45",
        "startXY": [
          82.32,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 82.32 116.53 L 119.76 116.53",
        "startXY": [
          82.32,
          116.53
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 121.84 77.00 L 121.84 164.38",
        "startXY": [
          121.84,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 121.84 165.00 L 78.16 165.00",
        "startXY": [
          121.84,
          165
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
    "char": "z",
    "name": {
      "fr": "z digital",
      "en": "digital z"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "En digital, la lettre \"z\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"z\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 81.04 84.00 L 127.88 84.00",
        "startXY": [
          81.04,
          84
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 128.39 84.61 L 71.61 141.39",
        "startXY": [
          128.39,
          84.61
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 73.23 142.00 L 126.77 142.00",
        "startXY": [
          73.23,
          142
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
    "char": "v",
    "name": {
      "fr": "v digital",
      "en": "digital v"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"v\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"v\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 67.98 77.19 L 98.46 149.00",
        "startXY": [
          67.98,
          77.19
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 132.02 77.00 L 99.05 147.70",
        "startXY": [
          132.02,
          77
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
    "char": "w",
    "name": {
      "fr": "w digital",
      "en": "digital w"
    },
    "category": "consonne",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"w\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"w\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 38.39 77.54 L 67.66 146.50",
        "startXY": [
          38.39,
          77.54
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 100.96 77.00 L 69.30 144.90",
        "startXY": [
          100.96,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 100.82 80.04 L 130.09 149.00",
        "startXY": [
          100.82,
          80.04
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 161.61 79.85 L 129.95 147.75",
        "startXY": [
          161.61,
          79.85
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
    "char": "i",
    "name": {
      "fr": "i digital",
      "en": "digital i"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"i\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"i\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 100.00 77.00 L 100.00 149.00",
        "startXY": [
          100,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      }
    ]
  },
  {
    "char": "j",
    "name": {
      "fr": "j digital",
      "en": "digital j"
    },
    "category": "consonne",
    "zone": "jambe",
    "consigne": {
      "fr": "En digital, la lettre \"j\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"j\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 116.98 77.00 L 116.98 149.00",
        "startXY": [
          116.98,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 116.16 150.11 L 104.59 163.89",
        "startXY": [
          116.16,
          150.11
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 103.38 165.00 L 91.38 165.00",
        "startXY": [
          103.38,
          165
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 89.73 164.37 L 83.02 154.43",
        "startXY": [
          89.73,
          164.37
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
    "char": "h",
    "name": {
      "fr": "h digital",
      "en": "digital h"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"h\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"h\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 76.39 35.00 L 76.39 149.00",
        "startXY": [
          76.39,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 75.57 96.61 L 124.43 96.61",
        "startXY": [
          75.57,
          96.61
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 124.43 99.33 L 124.43 148.19",
        "startXY": [
          124.43,
          99.33
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
    "char": "k",
    "name": {
      "fr": "k digital",
      "en": "digital k"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"k\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"k\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 80.88 35.00 L 80.88 149.00",
        "startXY": [
          80.88,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 111.47 84.67 L 83.23 110.10",
        "startXY": [
          111.47,
          84.67
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 83.82 114.11 L 119.12 145.89",
        "startXY": [
          83.82,
          114.11
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
      "fr": "l digital",
      "en": "digital l"
    },
    "category": "consonne",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"l\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"l\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 100.00 35.00 L 100.00 149.00",
        "startXY": [
          100,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      }
    ]
  },
  {
    "char": "u",
    "name": {
      "fr": "u digital",
      "en": "digital u"
    },
    "category": "voyelle",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"u\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"u\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 80.15 77.55 L 80.15 121.86",
        "startXY": [
          80.15,
          77.55
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 80.57 121.93 L 94.51 139.15",
        "startXY": [
          80.57,
          121.93
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 94.92 140.32 L 117.08 140.32",
        "startXY": [
          94.92,
          140.32
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 119.85 77.00 L 119.85 149.00",
        "startXY": [
          119.85,
          77
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
    "char": "D",
    "name": {
      "fr": "D digital",
      "en": "digital D"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"D\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"D\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 64.93 36.44 L 64.93 149.00",
        "startXY": [
          64.93,
          36.44
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 65.51 35.00 L 110.53 35.00",
        "startXY": [
          65.51,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 111.99 35.78 L 133.31 63.08",
        "startXY": [
          111.99,
          35.78
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 134.20 65.30 L 134.20 108.59",
        "startXY": [
          134.2,
          65.3
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 135.07 109.62 L 110.24 145.09",
        "startXY": [
          135.07,
          109.62
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 109.67 147.56 L 66.37 147.56",
        "startXY": [
          109.67,
          147.56
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      }
    ]
  },
  {
    "char": "F",
    "name": {
      "fr": "F digital",
      "en": "digital F"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"F\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"F\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 65.80 35.00 L 65.80 149.00",
        "startXY": [
          65.8,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 65.80 35.00 L 134.20 35.00",
        "startXY": [
          65.8,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 65.80 92.00 L 111.40 92.00",
        "startXY": [
          65.8,
          92
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
    "char": "E",
    "name": {
      "fr": "E digital",
      "en": "digital E"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"E\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"E\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 65.51 35.00 L 65.51 149.00",
        "startXY": [
          65.51,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 66.08 149.00 L 134.48 149.00",
        "startXY": [
          66.08,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 65.51 92.00 L 111.11 92.00",
        "startXY": [
          65.51,
          92
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 65.51 35.00 L 133.91 35.00",
        "startXY": [
          65.51,
          35
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
    "char": "I",
    "name": {
      "fr": "I digital",
      "en": "digital I"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"I\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"I\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 98.13 35.56 L 98.13 147.69",
        "startXY": [
          98.13,
          35.56
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 66.36 35.00 L 133.64 35.00",
        "startXY": [
          66.36,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 66.36 149.00 L 133.64 149.00",
        "startXY": [
          66.36,
          149
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
    "char": "H",
    "name": {
      "fr": "H digital",
      "en": "digital H"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"H\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"H\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 71.88 35.38 L 71.88 149.00",
        "startXY": [
          71.88,
          35.38
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 128.12 35.00 L 128.12 148.62",
        "startXY": [
          128.12,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 73.96 92.19 L 127.36 92.19",
        "startXY": [
          73.96,
          92.19
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
    "char": "L",
    "name": {
      "fr": "L digital",
      "en": "digital L"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"L\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"L\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 71.03 35.00 L 71.03 149.00",
        "startXY": [
          71.03,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 71.97 149.00 L 128.97 149.00",
        "startXY": [
          71.97,
          149
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
    "char": "N",
    "name": {
      "fr": "N digital",
      "en": "digital N"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"N\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"N\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 72.92 35.00 L 72.92 149.00",
        "startXY": [
          72.92,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 73.03 35.17 L 126.02 148.83",
        "startXY": [
          73.03,
          35.17
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 127.08 35.00 L 127.08 149.00",
        "startXY": [
          127.08,
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
    "char": "Ñ",
    "name": {
      "fr": "Ñ digital",
      "en": "digital Ñ"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"Ñ\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"Ñ\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 79.69 63.50 L 79.69 149.00",
        "startXY": [
          79.69,
          63.5
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 79.77 63.63 L 119.52 148.87",
        "startXY": [
          79.77,
          63.63
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 120.31 63.50 L 120.31 149.00",
        "startXY": [
          120.31,
          63.5
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 113.47 35.00 L 83.54 35.00",
        "startXY": [
          113.47,
          35
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
    "char": "A",
    "name": {
      "fr": "A digital",
      "en": "digital A"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"A\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"A\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 61.32 54.10 L 61.32 147.64",
        "startXY": [
          61.32,
          54.1
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 61.54 53.61 L 79.41 35.10",
        "startXY": [
          61.54,
          53.61
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 80.03 35.00 L 118.61 35.00",
        "startXY": [
          80.03,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 120.00 35.49 L 137.87 54.00",
        "startXY": [
          120,
          35.49
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 138.68 55.46 L 138.68 149.00",
        "startXY": [
          138.68,
          55.46
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 61.71 101.26 L 137.71 101.26",
        "startXY": [
          61.71,
          101.26
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      }
    ]
  },
  {
    "char": "C",
    "name": {
      "fr": "C digital",
      "en": "digital C"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"C\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"C\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 126.48 35.00 L 91.17 35.00",
        "startXY": [
          126.48,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 89.63 35.09 L 74.22 51.05",
        "startXY": [
          89.63,
          35.09
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 73.52 51.81 L 73.52 132.52",
        "startXY": [
          73.52,
          51.81
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 73.88 132.95 L 89.30 148.91",
        "startXY": [
          73.88,
          132.95
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 89.49 149.00 L 124.80 149.00",
        "startXY": [
          89.49,
          149
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
    "char": "G",
    "name": {
      "fr": "G digital",
      "en": "digital G"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"G\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"G\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 127.56 35.09 L 90.08 35.09",
        "startXY": [
          127.56,
          35.09
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 89.13 35.00 L 72.28 52.45",
        "startXY": [
          89.13,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 71.52 53.83 L 71.52 130.99",
        "startXY": [
          71.52,
          53.83
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 71.92 131.46 L 88.76 148.90",
        "startXY": [
          71.92,
          131.46
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 88.98 149.00 L 127.56 149.00",
        "startXY": [
          88.98,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 128.48 148.45 L 128.48 115.38",
        "startXY": [
          128.48,
          148.45
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 127.19 115.38 L 105.14 115.38",
        "startXY": [
          127.19,
          115.38
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°7",
          "en": "Trace the line #7"
        }
      }
    ]
  },
  {
    "char": "Q",
    "name": {
      "fr": "Q digital",
      "en": "digital Q"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"Q\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"Q\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 115.08 35.08 L 79.98 35.08",
        "startXY": [
          115.08,
          35.08
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 79.09 35.00 L 63.31 51.34",
        "startXY": [
          79.09,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 62.59 52.64 L 62.59 124.92",
        "startXY": [
          62.59,
          52.64
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 62.96 125.35 L 78.74 141.69",
        "startXY": [
          62.96,
          125.35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 78.94 141.78 L 115.08 141.78",
        "startXY": [
          78.94,
          141.78
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 115.80 141.69 L 131.58 125.35",
        "startXY": [
          115.8,
          141.69
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 132.29 124.57 L 132.29 52.29",
        "startXY": [
          132.29,
          124.57
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°7",
          "en": "Trace the line #7"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 132.24 52.06 L 116.17 36.00",
        "startXY": [
          132.24,
          52.06
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°8",
          "en": "Trace the line #8"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 116.16 119.76 L 137.41 149.00",
        "startXY": [
          116.16,
          119.76
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°9",
          "en": "Trace the line #9"
        }
      }
    ]
  },
  {
    "char": "O",
    "name": {
      "fr": "O digital",
      "en": "digital O"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"O\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"O\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 118.83 35.09 L 81.35 35.09",
        "startXY": [
          118.83,
          35.09
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 80.40 35.00 L 63.56 52.45",
        "startXY": [
          80.4,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 62.79 53.83 L 62.79 130.99",
        "startXY": [
          62.79,
          53.83
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 63.19 131.46 L 80.04 148.90",
        "startXY": [
          63.19,
          131.46
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 80.25 149.00 L 118.83 149.00",
        "startXY": [
          80.25,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 119.60 148.90 L 136.44 131.46",
        "startXY": [
          119.6,
          148.9
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 137.21 130.63 L 137.21 53.46",
        "startXY": [
          137.21,
          130.63
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°7",
          "en": "Trace the line #7"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 137.14 53.22 L 120.00 36.07",
        "startXY": [
          137.14,
          53.22
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°8",
          "en": "Trace the line #8"
        }
      }
    ]
  },
  {
    "char": "U",
    "name": {
      "fr": "U digital",
      "en": "digital U"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"U\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"U\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 61.84 35.00 L 61.84 127.22",
        "startXY": [
          61.84,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 61.79 129.20 L 74.69 148.31",
        "startXY": [
          61.79,
          129.2
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 75.93 149.00 L 122.04 149.00",
        "startXY": [
          75.93,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 122.78 148.09 L 138.21 130.95",
        "startXY": [
          122.78,
          148.09
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 138.18 37.05 L 138.18 129.27",
        "startXY": [
          138.18,
          37.05
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
    "char": "V",
    "name": {
      "fr": "V digital",
      "en": "digital V"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"V\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"V\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 81.17 35.71 L 81.17 148.68",
        "startXY": [
          81.17,
          35.71
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 83.33 149.00 L 114.31 120.11",
        "startXY": [
          83.33,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 114.41 120.12 L 118.54 106.62",
        "startXY": [
          114.41,
          120.12
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 118.83 105.61 L 118.83 35.00",
        "startXY": [
          118.83,
          105.61
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
    "char": "W",
    "name": {
      "fr": "W digital",
      "en": "digital W"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"W\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"W\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 66.11 35.00 L 66.11 147.20",
        "startXY": [
          66.11,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 66.26 149.00 L 101.95 126.70",
        "startXY": [
          66.26,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 102.34 111.67 L 102.34 125.70",
        "startXY": [
          102.34,
          111.67
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 104.70 127.30 L 132.70 148.40",
        "startXY": [
          104.7,
          127.3
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 133.89 35.00 L 133.89 147.20",
        "startXY": [
          133.89,
          35
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
      "fr": "X digital",
      "en": "digital X"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"X\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"X\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 71.74 35.00 L 128.26 145.92",
        "startXY": [
          71.74,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 127.81 37.11 L 73.23 149.00",
        "startXY": [
          127.81,
          37.11
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
    "char": "Y",
    "name": {
      "fr": "Y digital",
      "en": "digital Y"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"Y\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"Y\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 77.56 35.48 L 77.56 78.23",
        "startXY": [
          77.56,
          35.48
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 78.74 78.23 L 121.49 78.23",
        "startXY": [
          78.74,
          78.23
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 123.87 35.00 L 123.87 149.00",
        "startXY": [
          123.87,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 121.73 149.00 L 76.13 149.00",
        "startXY": [
          121.73,
          149
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
    "char": "Z",
    "name": {
      "fr": "Z digital",
      "en": "digital Z"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"Z\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"Z\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 59.92 35.34 L 145.81 35.34",
        "startXY": [
          59.92,
          35.34
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 145.95 35.00 L 54.05 148.48",
        "startXY": [
          145.95,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 55.05 149.00 L 140.94 149.00",
        "startXY": [
          55.05,
          149
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
    "char": "K",
    "name": {
      "fr": "K digital",
      "en": "digital K"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"K\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"K\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 69.77 35.00 L 69.77 149.00",
        "startXY": [
          69.77,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 127.89 52.98 L 69.77 98.39",
        "startXY": [
          127.89,
          52.98
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 70.56 98.26 L 130.23 141.62",
        "startXY": [
          70.56,
          98.26
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
    "char": "J",
    "name": {
      "fr": "J digital",
      "en": "digital J"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"J\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"J\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 76.17 35.00 L 134.14 35.00",
        "startXY": [
          76.17,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 113.61 36.21 L 113.61 123.16",
        "startXY": [
          113.61,
          36.21
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 112.99 124.57 L 96.36 148.31",
        "startXY": [
          112.99,
          124.57
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 95.01 149.00 L 80.52 149.00",
        "startXY": [
          95.01,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 79.24 147.90 L 65.86 130.77",
        "startXY": [
          79.24,
          147.9
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      }
    ]
  },
  {
    "char": "T",
    "name": {
      "fr": "T digital",
      "en": "digital T"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"T\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"T\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 44.54 35.00 L 155.46 35.00",
        "startXY": [
          44.54,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 99.08 38.08 L 99.08 149.00",
        "startXY": [
          99.08,
          38.08
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
    "char": "S",
    "name": {
      "fr": "S digital",
      "en": "digital S"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"S\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"S\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 128.09 35.00 L 71.68 35.00",
        "startXY": [
          128.09,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 71.21 35.71 L 71.21 92.12",
        "startXY": [
          71.21,
          35.71
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 72.38 92.59 L 128.79 92.59",
        "startXY": [
          72.38,
          92.59
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 128.79 92.59 L 128.79 149.00",
        "startXY": [
          128.79,
          92.59
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 128.09 149.00 L 71.68 149.00",
        "startXY": [
          128.09,
          149
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
    "char": "P",
    "name": {
      "fr": "P digital",
      "en": "digital P"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"P\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"P\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 72.69 35.00 L 72.69 149.00",
        "startXY": [
          72.69,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 72.69 35.00 L 115.44 35.00",
        "startXY": [
          72.69,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 117.60 35.40 L 126.57 46.47",
        "startXY": [
          117.6,
          35.4
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 127.31 48.06 L 127.31 83.69",
        "startXY": [
          127.31,
          48.06
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 126.65 83.79 L 118.48 95.46",
        "startXY": [
          126.65,
          83.79
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 117.81 96.75 L 75.06 96.75",
        "startXY": [
          117.81,
          96.75
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      }
    ]
  },
  {
    "char": "R",
    "name": {
      "fr": "R digital",
      "en": "digital R"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"R\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"R\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 68.31 35.00 L 68.31 145.30",
        "startXY": [
          68.31,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 68.31 35.00 L 109.67 35.00",
        "startXY": [
          68.31,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 111.76 35.39 L 120.44 46.10",
        "startXY": [
          111.76,
          35.39
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 121.16 47.64 L 121.16 82.11",
        "startXY": [
          121.16,
          47.64
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 121.15 82.49 L 105.08 95.51",
        "startXY": [
          121.15,
          82.49
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 106.22 95.44 L 71.75 95.44",
        "startXY": [
          106.22,
          95.44
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 69.26 94.73 L 131.69 149.00",
        "startXY": [
          69.26,
          94.73
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°7",
          "en": "Trace the line #7"
        }
      }
    ]
  },
  {
    "char": "B",
    "name": {
      "fr": "B digital",
      "en": "digital B"
    },
    "category": "majuscule",
    "zone": "hampe",
    "consigne": {
      "fr": "En digital, la lettre \"B\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"B\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 75.72 35.00 L 75.72 149.00",
        "startXY": [
          75.72,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 75.72 35.00 L 113.72 35.00",
        "startXY": [
          75.72,
          35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 115.65 35.36 L 123.62 45.20",
        "startXY": [
          115.65,
          35.36
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 124.28 46.61 L 124.28 78.28",
        "startXY": [
          124.28,
          46.61
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 124.27 78.63 L 109.51 90.59",
        "startXY": [
          124.27,
          78.63
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 110.56 90.52 L 78.89 90.52",
        "startXY": [
          110.56,
          90.52
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 109.72 91.05 L 124.06 103.51",
        "startXY": [
          109.72,
          91.05
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°7",
          "en": "Trace the line #7"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 124.28 105.30 L 124.28 136.97",
        "startXY": [
          124.28,
          105.3
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°8",
          "en": "Trace the line #8"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 122.99 138.80 L 115.01 148.64",
        "startXY": [
          122.99,
          138.8
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°9",
          "en": "Trace the line #9"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 114.36 149.00 L 76.36 149.00",
        "startXY": [
          114.36,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°10",
          "en": "Trace the line #10"
        }
      }
    ]
  },
  {
    "char": "0",
    "name": {
      "fr": "0 digital",
      "en": "digital 0"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"0\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"0\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 116.12 77.00 L 83.88 77.00",
        "startXY": [
          116.12,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 83.49 77.08 L 76.03 84.81",
        "startXY": [
          83.49,
          77.08
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 75.82 85.06 L 75.82 138.79",
        "startXY": [
          75.82,
          85.06
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 76.02 140.35 L 82.78 148.70",
        "startXY": [
          76.02,
          140.35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 83.88 149.00 L 116.12 149.00",
        "startXY": [
          83.88,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 115.97 148.92 L 123.43 141.19",
        "startXY": [
          115.97,
          148.92
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 124.18 140.58 L 124.18 86.85",
        "startXY": [
          124.18,
          140.58
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°7",
          "en": "Trace the line #7"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 123.98 86.01 L 117.22 77.66",
        "startXY": [
          123.98,
          86.01
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°8",
          "en": "Trace the line #8"
        }
      }
    ]
  },
  {
    "char": "9",
    "name": {
      "fr": "9 digital",
      "en": "digital 9"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"9\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"9\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 123.01 85.60 L 115.57 77.89",
        "startXY": [
          123.01,
          85.6
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 115.18 77.28 L 83.04 77.28",
        "startXY": [
          115.18,
          77.28
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 83.19 77.00 L 75.74 84.71",
        "startXY": [
          83.19,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 75.89 86.57 L 75.89 103.71",
        "startXY": [
          75.89,
          86.57
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 76.09 104.37 L 82.84 112.70",
        "startXY": [
          76.09,
          104.37
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 84.47 113.00 L 111.25 113.00",
        "startXY": [
          84.47,
          113
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 111.19 113.22 L 122.75 102.06",
        "startXY": [
          111.19,
          113.22
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°7",
          "en": "Trace the line #7"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 124.11 86.21 L 124.11 139.79",
        "startXY": [
          124.11,
          86.21
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°8",
          "en": "Trace the line #8"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 124.26 141.29 L 116.82 149.00",
        "startXY": [
          124.26,
          141.29
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°9",
          "en": "Trace the line #9"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 115.18 148.72 L 83.04 148.72",
        "startXY": [
          115.18,
          148.72
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°10",
          "en": "Trace the line #10"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 82.48 148.06 L 75.74 139.73",
        "startXY": [
          82.48,
          148.06
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°11",
          "en": "Trace the line #11"
        }
      }
    ]
  },
  {
    "char": "8",
    "name": {
      "fr": "8 digital",
      "en": "digital 8"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"8\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"8\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 122.91 86.23 L 116.37 78.16",
        "startXY": [
          122.91,
          86.23
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 116.18 77.00 L 85.02 77.00",
        "startXY": [
          116.18,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 85.17 77.07 L 77.95 84.54",
        "startXY": [
          85.17,
          77.07
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 78.10 86.35 L 78.10 102.96",
        "startXY": [
          78.1,
          86.35
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 78.29 103.60 L 84.83 111.67",
        "startXY": [
          78.29,
          103.6
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 86.41 111.96 L 112.37 111.96",
        "startXY": [
          86.41,
          111.96
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 114.50 111.89 L 124.09 124.16",
        "startXY": [
          114.5,
          111.89
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°7",
          "en": "Trace the line #7"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 123.62 124.25 L 123.62 137.76",
        "startXY": [
          123.62,
          124.25
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°8",
          "en": "Trace the line #8"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 123.02 137.24 L 112.80 149.00",
        "startXY": [
          123.02,
          137.24
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°9",
          "en": "Trace the line #9"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 111.85 148.66 L 85.89 148.66",
        "startXY": [
          111.85,
          148.66
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°10",
          "en": "Trace the line #10"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 84.70 148.76 L 76.69 139.21",
        "startXY": [
          84.7,
          148.76
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°11",
          "en": "Trace the line #11"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 76.37 139.31 L 76.37 123.74",
        "startXY": [
          76.37,
          139.31
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°12",
          "en": "Trace the line #12"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 75.91 122.00 L 83.75 112.31",
        "startXY": [
          75.91,
          122
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°13",
          "en": "Trace the line #13"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 114.51 112.78 L 122.35 105.96",
        "startXY": [
          114.51,
          112.78
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°14",
          "en": "Trace the line #14"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 123.10 105.21 L 123.10 87.56",
        "startXY": [
          123.1,
          105.21
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°15",
          "en": "Trace the line #15"
        }
      }
    ]
  },
  {
    "char": "3",
    "name": {
      "fr": "3 digital",
      "en": "digital 3"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"3\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"3\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 77.56 84.54 L 84.78 77.07",
        "startXY": [
          77.56,
          84.54
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 84.63 77.00 L 115.79 77.00",
        "startXY": [
          84.63,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 115.98 78.50 L 122.52 86.57",
        "startXY": [
          115.98,
          78.5
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 122.71 87.56 L 122.71 105.21",
        "startXY": [
          122.71,
          87.56
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 121.96 105.96 L 114.12 112.78",
        "startXY": [
          121.96,
          105.96
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 111.98 111.96 L 86.02 111.96",
        "startXY": [
          111.98,
          111.96
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 114.11 111.89 L 123.70 124.16",
        "startXY": [
          114.11,
          111.89
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°7",
          "en": "Trace the line #7"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 123.23 124.25 L 123.23 137.76",
        "startXY": [
          123.23,
          124.25
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°8",
          "en": "Trace the line #8"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 122.63 137.24 L 112.41 149.00",
        "startXY": [
          122.63,
          137.24
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°9",
          "en": "Trace the line #9"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 111.46 148.66 L 85.50 148.66",
        "startXY": [
          111.46,
          148.66
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°10",
          "en": "Trace the line #10"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 84.31 148.76 L 76.30 139.21",
        "startXY": [
          84.31,
          148.76
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°11",
          "en": "Trace the line #11"
        }
      }
    ]
  },
  {
    "char": "6",
    "name": {
      "fr": "6 digital",
      "en": "digital 6"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"6\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"6\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 123.61 86.19 L 117.10 78.15",
        "startXY": [
          123.61,
          86.19
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 116.05 77.00 L 85.01 77.00",
        "startXY": [
          116.05,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 84.29 77.07 L 77.11 84.51",
        "startXY": [
          84.29,
          77.07
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 76.39 85.97 L 76.39 137.69",
        "startXY": [
          76.39,
          85.97
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 77.57 139.49 L 85.55 149.00",
        "startXY": [
          77.57,
          139.49
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 85.87 148.90 L 111.74 148.90",
        "startXY": [
          85.87,
          148.9
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 112.68 148.72 L 122.86 137.01",
        "startXY": [
          112.68,
          148.72
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°7",
          "en": "Trace the line #7"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 122.94 137.52 L 122.94 124.07",
        "startXY": [
          122.94,
          137.52
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°8",
          "en": "Trace the line #8"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 123.06 123.98 L 113.51 111.75",
        "startXY": [
          123.06,
          123.98
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°9",
          "en": "Trace the line #9"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 111.74 111.83 L 85.87 111.83",
        "startXY": [
          111.74,
          111.83
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°10",
          "en": "Trace the line #10"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 85.46 111.88 L 77.66 118.67",
        "startXY": [
          85.46,
          111.88
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°11",
          "en": "Trace the line #11"
        }
      }
    ]
  },
  {
    "char": "5",
    "name": {
      "fr": "5 digital",
      "en": "digital 5"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"5\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"5\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 114.87 77.00 L 81.21 77.00",
        "startXY": [
          114.87,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 80.27 77.94 L 80.27 105.99",
        "startXY": [
          80.27,
          77.94
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 80.27 106.92 L 108.32 106.92",
        "startXY": [
          80.27,
          106.92
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 109.69 107.77 L 120.05 121.03",
        "startXY": [
          109.69,
          107.77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 120.10 121.14 L 120.10 135.72",
        "startXY": [
          120.1,
          121.14
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 119.08 136.10 L 108.04 148.81",
        "startXY": [
          119.08,
          136.1
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 107.95 149.00 L 79.90 149.00",
        "startXY": [
          107.95,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°7",
          "en": "Trace the line #7"
        }
      }
    ]
  },
  {
    "char": "2",
    "name": {
      "fr": "2 digital",
      "en": "digital 2"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"2\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"2\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 67.39 91.39 L 79.20 77.81",
        "startXY": [
          67.39,
          91.39
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 80.30 77.00 L 116.30 77.00",
        "startXY": [
          80.3,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 116.76 77.91 L 127.84 92.09",
        "startXY": [
          116.76,
          77.91
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 128.30 93.20 L 128.30 108.80",
        "startXY": [
          128.3,
          93.2
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°4",
          "en": "Trace the line #4"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 127.09 109.39 L 66.70 148.61",
        "startXY": [
          127.09,
          109.39
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°5",
          "en": "Trace the line #5"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 67.30 149.00 L 133.30 149.00",
        "startXY": [
          67.3,
          149
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°6",
          "en": "Trace the line #6"
        }
      }
    ]
  },
  {
    "char": "1",
    "name": {
      "fr": "1 digital",
      "en": "digital 1"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"1\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"1\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 100.00 77.00 L 100.00 149.00",
        "startXY": [
          100,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      }
    ]
  },
  {
    "char": "7",
    "name": {
      "fr": "7 digital",
      "en": "digital 7"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"7\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"7\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 80.66 77.00 L 119.34 77.00",
        "startXY": [
          80.66,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 119.34 78.07 L 119.34 149.00",
        "startXY": [
          119.34,
          78.07
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
    "char": "4",
    "name": {
      "fr": "4 digital",
      "en": "digital 4"
    },
    "category": "chiffre",
    "zone": "corps",
    "consigne": {
      "fr": "En digital, la lettre \"4\" s'écrit par segments droits, un trait après l'autre.",
      "en": "In digital style, the letter \"4\" is written with straight segments, one line after another."
    },
    "steps": [
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 79.27 77.00 L 79.27 116.27",
        "startXY": [
          79.27,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°1",
          "en": "Trace the line #1"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 79.27 117.36 L 118.55 117.36",
        "startXY": [
          79.27,
          117.36
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°2",
          "en": "Trace the line #2"
        }
      },
      {
        "family": "trait",
        "variant": "digital-trait",
        "pathD": "M 120.73 77.00 L 120.73 149.00",
        "startXY": [
          120.73,
          77
        ],
        "strokeColor": "#4A3B2A",
        "description": {
          "fr": "Trace le trait n°3",
          "en": "Trace the line #3"
        }
      }
    ]
  }
]
''');

final Map<String, dynamic> DIGITAL_MAP = {
  for (final l in DIGITAL_LETTERS) l['char'] as String: l,
};
