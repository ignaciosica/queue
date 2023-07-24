import 'package:go_router/go_router.dart';
import 'package:queue/screens/lobby/lobby_screen.dart';

import '../screens/room/room_screen.dart';

appRouter() => GoRouter(
        initialLocation: () {
          return '/lobby';
        }.call(),
        routes: [
          GoRoute(
            path: '/room',
            builder: (context, state) => RoomScreen(state.extra),
          ),
          GoRoute(
            path: '/lobby',
            builder: (context, state) => const LobbyScreen(),
          ),
        ]);
