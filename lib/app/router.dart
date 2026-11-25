import 'package:go_router/go_router.dart';

import '../features/auth/presentation/auth_gate.dart';
import '../features/watch/presentation/create_watch_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const AuthGate(),
    ),
    GoRoute(
      path: '/create-watch',
      name: 'create-watch',
      builder: (context, state) => const CreateWatchScreen(),
    ),
  ],
);
