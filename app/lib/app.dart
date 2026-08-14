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
import 'screens/cours_syllabes_screen.dart';
import 'screens/exercice_syllabes_screen.dart';
import 'services/sign_speech.dart';
import 'services/progress_service.dart';
import 'services/backend_sync_service.dart';
import 'hooks/use_writing_style.dart';
import 'hooks/use_animation_speed.dart';
import 'screens/plus_screen.dart';
import 'widgets/points_toast_host.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
    GoRoute(
      path: '/profil',
      builder: (context, state) => const ProfileCreateScreen(),
    ),
    GoRoute(
      path: '/cours/:family',
      builder: (context, state) =>
          CoursFamilyScreen(family: state.pathParameters['family']!),
    ),
    GoRoute(
      path: '/exercice-liste',
      builder: (context, state) => ExerciceListeScreen(
        family: state.uri.queryParameters['family'],
        group: state.uri.queryParameters['group'],
        amaniEval: state.uri.queryParameters['amaniEval'],
      ),
    ),
    GoRoute(path: '/exercice', redirect: (context, state) => '/exercice-liste'),
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
        amaniEval: state.uri.queryParameters['amaniEval'],
      ),
    ),
    GoRoute(
      path: '/cours/syllabes/:consonant',
      builder: (context, state) =>
          CoursSyllabesScreen(consonant: state.pathParameters['consonant']!),
    ),
    GoRoute(
      path: '/exercice/syllabes/:consonant',
      builder: (context, state) => ExerciceSyllabesScreen(
        consonant: state.pathParameters['consonant']!,
        amaniEval: state.uri.queryParameters['amaniEval'],
      ),
    ),
    GoRoute(
      path: '/cours/mots/:groupId',
      builder: (context, state) =>
          CoursMotsScreen(groupId: state.pathParameters['groupId']!),
    ),
    GoRoute(
      path: '/exercice/mots/:groupId',
      builder: (context, state) => ExerciceMotsScreen(
        groupId: state.pathParameters['groupId']!,
        amaniEval: state.uri.queryParameters['amaniEval'],
        onlyWordId: state.uri.queryParameters['word'],
      ),
    ),
    GoRoute(
      path: '/exercice/mots-croises/:puzzleId',
      builder: (context, state) => ExerciceMotsCroisesScreen(
        puzzleId: state.pathParameters['puzzleId']!,
      ),
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
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/plus',
              builder: (context, state) => const PlusScreen(),
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
        ChangeNotifierProvider(create: (_) => WritingStyleProvider()),
        ChangeNotifierProvider(create: (_) => AnimationSpeedProvider()),
        ChangeNotifierProvider(create: (_) => BackendSyncService()),
        ChangeNotifierProxyProvider<BackendSyncService, ProgressProvider>(
          create: (context) =>
              ProgressProvider(context.read<BackendSyncService>()),
          update: (context, backend, previous) => previous!,
        ),
      ],
      // La police de toute l'appli suit le format d'écriture actif, et la
      // mise en page entière suit la langue active (RTL pour l'arabe) : ces
      // Consumer forcent MaterialApp à se reconstruire dès que l'un ou
      // l'autre change, sans redémarrage.
      child: Consumer2<WritingStyleProvider, LanguageProvider>(
        builder: (context, _, languageProvider, _) => MaterialApp.router(
          title: 'Gentle Paths Academy',
          theme: AmaniTheme.light,
          routerConfig: _router,
          debugShowCheckedModeBanner: false,
          // Superpose le popup "+N points" au-dessus de l'écran courant, quel
          // qu'il soit — voir PointsToastHost, monté une seule fois ici pour
          // flotter sur toute l'app (équivalent de MobileShell côté web).
          builder: (context, child) => Directionality(
            textDirection: rtlLangs.contains(languageProvider.lang)
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Stack(children: [?child, const PointsToastHost()]),
          ),
        ),
      ),
    );
  }
}
