import 'package:go_router/go_router.dart';

import '../features/navigation/presentation/main_screen.dart';
import '../features/watch/presentation/create_watch_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/create-watch',
      name: 'create-watch',
      builder: (context, state) => const CreateWatchScreen(),
    ),
  ],
);
