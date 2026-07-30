import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'theme/amani_theme.dart';
import 'i18n/translations.dart';
import 'screens/welcome_screen.dart';
import 'screens/profile_create_screen.dart';
import 'screens/app_shell.dart';
import 'screens/parcours_screen.dart';
import 'screens/bibliotheque_screen.dart';
import 'screens/communaute_screen.dart';
import 'screens/profil_hub_screen.dart';
import 'screens/cours_family_screen.dart';
import 'screens/exercice_liste_screen.dart';
import 'screens/cours_lettres_formation_screen.dart';
import 'screens/exercice_lettre_screen.dart';
import 'screens/cours_mots_screen.dart';
import 'screens/exercice_mots_screen.dart';
import 'screens/exercice_mots_croises_screen.dart';
import 'services/sign_speech.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/profil',
      builder: (context, state) => const ProfileCreateScreen(),
    ),
    GoRoute(
      path: '/cours/:family',
      builder: (context, state) => CoursFamilyScreen(family: state.pathParameters['family']!),
    ),
    GoRoute(
      path: '/exercice-liste',
      builder: (context, state) => ExerciceListeScreen(
        family: state.uri.queryParameters['family'],
        group: state.uri.queryParameters['group'],
      ),
    ),
    GoRoute(
      path: '/exercice',
      redirect: (context, state) => '/exercice-liste',
    ),
    GoRoute(
      path: '/cours/lettres/formation/:char',
      builder: (context, state) => CoursLettresFormationScreen(
        char: state.pathParameters['char']!,
        pg: state.uri.queryParameters['pg'],
      ),
    ),
    GoRoute(
      path: '/exercice/lettre/:char',
      builder: (context, state) => ExerciceLettreScreen(
        char: state.pathParameters['char']!,
        pg: state.uri.queryParameters['pg'],
      ),
    ),
    GoRoute(
      path: '/cours/mots/:groupId',
      builder: (context, state) => CoursMotsScreen(groupId: state.pathParameters['groupId']!),
    ),
    GoRoute(
      path: '/exercice/mots/:groupId',
      builder: (context, state) => ExerciceMotsScreen(groupId: state.pathParameters['groupId']!),
    ),
    GoRoute(
      path: '/exercice/mots-croises/:puzzleId',
      builder: (context, state) => ExerciceMotsCroisesScreen(puzzleId: state.pathParameters['puzzleId']!),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/accueil',
              builder: (context, state) => const ParcoursScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/bibliotheque',
              builder: (context, state) => const BibliothequeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/communaute',
              builder: (context, state) => const CommunauteScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/mon-profil',
              builder: (context, state) => const ProfilHubScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class AmaniApp extends StatelessWidget {
  const AmaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => SignSpeechService()),
      ],
      child: MaterialApp.router(
        title: 'Gentle Paths Academy',
        theme: AmaniTheme.light,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
