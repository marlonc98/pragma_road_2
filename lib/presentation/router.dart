import 'package:go_router/go_router.dart';
import 'package:portal_remoto/presentation/pages/character_detail/character_detail_page.dart';
import 'package:portal_remoto/presentation/pages/characters/characters_page.dart';
import 'package:portal_remoto/presentation/pages/splash/splash_page.dart';

final router = GoRouter(
  initialLocation: SplashPage.route,
  routes: [
    GoRoute(
      path: SplashPage.route,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: CharactersPage.route,
      builder: (context, state) => const CharactersPage(),
    ),
    GoRoute(
      path: CharacterDetailPage.route,
      builder: (context, state) => CharacterDetailPage(
        id: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
      ),
    ),
  ],
);
