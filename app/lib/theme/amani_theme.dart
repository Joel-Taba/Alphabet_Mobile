import 'package:flutter/material.dart';

/// Nom de la police "Baloo 2", embarquée hors-ligne (voir pubspec.yaml,
/// assets/fonts/Baloo2-Variable.ttf) — aucune requête réseau au démarrage.
const String kBalooFontFamily = 'Baloo 2';

/// Palette de couleurs Amani — exacte copie de la charte graphique React
class AmaniColors {
  AmaniColors._();

  // Fonds
  static const background = Color(0xFFF5EDE0);
  static const backgroundAlt = Color(0xFFEFE3CE);
  static const surface = Color(0xFFFBF6EC);

  // Textes
  static const textPrimary = Color(0xFF4A3B2A);
  static const textSecondary = Color(0xFF7A6A55);

  // Primaire (brun-doré)
  static const primary = Color(0xFFA9784F);
  static const primaryDark = Color(0xFF8B5E3C);
  static const primaryForeground = Color(0xFFFBF6EC);

  // Secondaire (vert nature)
  static const secondary = Color(0xFF8FBF6F);
  static const secondaryDark = Color(0xFF6FA050);
  static const secondaryForeground = Color(0xFF4A3B2A);

  // Statuts
  static const success = Color(0xFF7CB37A);
  static const error = Color(0xFFE05252);
  static const warning = Color(0xFFE3B873);
  static const disabled = Color(0xFFD8CFC0);

  // Couleurs des signes
  static const signTrait = Color(0xFF4A3B2A);
  static const signCourbe = Color(0xFFE05252);
  static const signCrochet = Color(0xFF4A90E2);
  static const signPoint = Color(0xFF4A3B2A);

  // Paliers
  static const palier1 = Color(0xFF8FBF6F);
  static const palier1Dark = Color(0xFF5E8E3E);
  static const palier2 = Color(0xFFA9784F);
  static const palier2Dark = Color(0xFF7A5332);
  static const palier3 = Color(0xFF4A90E2);
  static const palier3Dark = Color(0xFF2D6BBF);

  // Animaux podium
  static const gold = Color(0xFFF3D07A);
  static const silver = Color(0xFFD8CFC0);
  static const bronze = Color(0xFFE0A98C);
}

/// Ombres standardisées
class AmaniShadows {
  AmaniShadows._();

  static const card = [
    BoxShadow(
      color: Color(0x1F4A3B2A),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  static const modal = [
    BoxShadow(
      color: Color(0x404A3B2A),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
}

/// Thème complet de l'application
class AmaniTheme {
  AmaniTheme._();

  /// Polices de repli pour les caractères absents de Baloo 2 (emoji, etc.) —
  /// résolues via les polices système d'Android/iOS ; sans effet si absentes.
  static const List<String> _emojiFallback = [
    'Noto Color Emoji',
    'Apple Color Emoji',
    'Segoe UI Emoji',
  ];

  static const TextStyle titleStyle = TextStyle(
    fontFamily: kBalooFontFamily,
    fontFamilyFallback: _emojiFallback,
    fontWeight: FontWeight.w700,
    color: AmaniColors.textPrimary,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontFamily: kBalooFontFamily,
    fontFamilyFallback: _emojiFallback,
    fontWeight: FontWeight.w500,
    color: AmaniColors.textPrimary,
  );

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AmaniColors.background,
      colorScheme: const ColorScheme.light(
        primary: AmaniColors.primary,
        onPrimary: AmaniColors.primaryForeground,
        secondary: AmaniColors.secondary,
        onSecondary: AmaniColors.secondaryForeground,
        surface: AmaniColors.surface,
        onSurface: AmaniColors.textPrimary,
        error: AmaniColors.error,
        onError: Colors.white,
      ),
      textTheme: const TextTheme().apply(
        bodyColor: AmaniColors.textPrimary,
        displayColor: AmaniColors.textPrimary,
        fontFamily: kBalooFontFamily,
      ),
      fontFamily: kBalooFontFamily,
      fontFamilyFallback: _emojiFallback,
      appBarTheme: const AppBarTheme(
        backgroundColor: AmaniColors.background,
        foregroundColor: AmaniColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AmaniColors.surface,
        selectedItemColor: AmaniColors.secondary,
        unselectedItemColor: AmaniColors.disabled,
      ),
    );
  }
}
