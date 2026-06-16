import 'package:go_router/go_router.dart';
import '../splash/splash_screen.dart';
import '../features/search/presentation/screens/home_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile/:login',
      builder: (context, state) {
        final login = state.pathParameters['login']!;
        return ProfileScreen(login: login);
      },
    ),
  ],
);
