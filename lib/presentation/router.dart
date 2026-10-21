import 'package:go_router/go_router.dart';
import 'package:portal_remoto/presentation/pages/placeholder/placeholder_page.dart';
import 'package:portal_remoto/presentation/pages/splash/splash_page.dart';

final router = GoRouter(
  initialLocation: SplashPage.route,
  routes: [
    GoRoute(
      path: SplashPage.route,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: PlaceholderPage.route,
      builder: (context, state) => const PlaceholderPage(),
    ),
  ],
);
