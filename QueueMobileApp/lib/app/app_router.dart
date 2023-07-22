import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:queue/screens/lobby/lobby_screen.dart';

import '../screens/room/room_screen.dart';

appRouter() => GoRouter(
        redirect: (context, state) async {
          return null;
        },
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
          GoRoute(
            path: '/sign-in',
            builder: (context, state) {
              return SignInScreen(
                actions: [
                  AuthStateChangeAction<SignedIn>(
                    (context, state) => Navigator.pop(context),
                  ),
                ],
              );
            },
          )
        ]);
