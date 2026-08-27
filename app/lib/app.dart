import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'theme/amani_theme.dart';
import 'services/mode_libre_controller.dart';
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
import 'screens/exercice_mots_meles_screen.dart';
import 'screens/cours_syllabes_screen.dart';
import 'screens/exercice_syllabes_screen.dart';
import 'screens/cours_calcul_screen.dart';
import 'screens/exercice_calcul_screen.dart';
import 'screens/exercice_calcul_vrai_faux_screen.dart';
import 'screens/exercice_calcul_compose_screen.dart';
import 'services/sign_speech.dart';
import 'services/progress_service.dart';
import 'services/backend_sync_service.dart';
import 'services/family_service.dart';
import 'hooks/use_writing_style.dart';
import 'hooks/use_animation_speed.dart';
import 'hooks/use_accessibility_settings.dart';
import 'widgets/points_toast_host.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

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
      path: '/cours/calcul/:topicId',
      builder: (context, state) =>
          CoursCalculScreen(topicId: state.pathParameters['topicId']!),
    ),
    GoRoute(
      path: '/exercice/calcul/:topicId',
      builder: (context, state) => ExerciceCalculScreen(
        topicId: state.pathParameters['topicId']!,
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
    GoRoute(
      path: '/exercice/mots-meles/:puzzleId',
      builder: (context, state) => ExerciceMotsMelesScreen(
        puzzleId: state.pathParameters['puzzleId']!,
      ),
    ),
    GoRoute(
      path: '/exercice/calcul-vrai-faux/:levelIndex',
      builder: (context, state) => ExerciceCalculVraiFauxScreen(
        levelIndex: state.pathParameters['levelIndex']!,
      ),
    ),
    GoRoute(
      path: '/exercice/calcul-compose/:levelIndex',
      builder: (context, state) => ExerciceCalculComposeScreen(
        levelIndex: state.pathParameters['levelIndex']!,
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
      ],
    ),
  ],
);

class AmaniApp extends StatelessWidget {
  final FamilyService familyService;

  const AmaniApp({super.key, required this.familyService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Déjà chargé (et migré depuis un éventuel profil unique) avant
        // `runApp` — voir main.dart — donc tous les autres services par
        // enfant ci-dessous voient d'emblée le bon espace de nommage.
        ChangeNotifierProvider.value(value: familyService),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => SignSpeechService()),
        ChangeNotifierProvider(create: (_) => AnimationSpeedProvider()),
        ChangeNotifierProvider(create: (_) => AccessibilitySettings()),
        ChangeNotifierProvider(create: (_) => ModeLibreController()),
        // Réglages par enfant : rechargés à chaque changement d'enfant actif
        // (voir FamilyService.switchTo) via ChangeNotifierProxyProvider,
        // plutôt que recréés — pour ne jamais perdre les autres abonnés.
        ChangeNotifierProxyProvider<FamilyService, WritingStyleProvider>(
          create: (_) => WritingStyleProvider(),
          update: (context, family, previous) {
            previous!.rechargerPourEnfantActif();
            return previous;
          },
        ),
        ChangeNotifierProxyProvider<FamilyService, BackendSyncService>(
          create: (_) => BackendSyncService(),
          update: (context, family, previous) {
            previous!.rechargerPourEnfantActif();
            return previous;
          },
        ),
        ChangeNotifierProxyProvider2<
          FamilyService,
          BackendSyncService,
          ProgressProvider
        >(
          create: (context) =>
              ProgressProvider(context.read<BackendSyncService>()),
          update: (context, family, backend, previous) {
            previous!.rechargerPourEnfantActif();
            return previous;
          },
        ),
      ],
      // La police de toute l'appli suit le format d'écriture actif (ou
      // OpenDyslexic si l'accessibilité l'impose) et la mise en page entière
      // suit la langue active (RTL pour l'arabe) : ce Consumer force
      // MaterialApp à se reconstruire dès que l'un de ces réglages change,
      // sans redémarrage.
      child: Consumer3<WritingStyleProvider, LanguageProvider, AccessibilitySettings>(
        builder: (context, _, languageProvider, accessibility, _) {
          setDyslexiaFontOverride(accessibility.dyslexiaFont);
          return MaterialApp.router(
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
              // Réglage "taille de l'interface" (Profil > Réglages) :
              // agrandit/réduit le texte (et tout ce qui en dépend) dans
              // toute l'app, sur le même principe que les réglages
              // d'accessibilité "Taille d'affichage" d'iOS/Android.
              child: MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(accessibility.uiScale)),
                child: Stack(children: [?child, const PointsToastHost()]),
              ),
            ),
          );
        },
      ),
    );
  }
}
