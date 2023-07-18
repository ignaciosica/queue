import 'package:go_router/go_router.dart';
import 'package:queue/screens/lobby/lobby_screen.dart';

appRouter() => GoRouter(
        initialLocation: () {
          return '/lobby';
        }.call(),
        routes: [
          GoRoute(
            path: '/room/:id',
            builder: (context, state) => const LobbyScreen(),
          ),
          GoRoute(
            path: '/lobby',
            builder: (context, state) => const LobbyScreen(),
          ),
        ]);
