import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:queue/screens/lobby/lobby_screen.dart';

import '../screens/room/room_screen.dart';

appRouter() => GoRouter(
        // redirect: (context, state) async {
        //   return FirebaseAuth.instance.currentUser == null ? '/sign-in' : null;
        // },
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
          // GoRoute(
          //   path: '/sign-in',
          //   builder: (context, state) {
          //     return SignInScreen(
          //       oauthButtonVariant: OAuthButtonVariant.icon,
          //       showAuthActionSwitch: false,
          //       footerBuilder: (context, action) => Align(
          //         alignment: Alignment.centerLeft,
          //         child: TextButton(
          //           style: ButtonStyle(
          //               padding: MaterialStateProperty.all<EdgeInsets>(
          //                   const EdgeInsets.all(4)),
          //               visualDensity: VisualDensity.comfortable),
          //           onPressed: () => FirebaseAuth.instance.signInAnonymously(),
          //           child: const Text('Continue anonymously'),
          //         ),
          //       ),
          //       actions: [
          //         AuthStateChangeAction<UserCreated>(
          //           (context, state) => Navigator.pop(context),
          //         ),
          //         AuthStateChangeAction<SignedIn>(
          //           (context, state) => Navigator.pop(context),
          //         ),
          //       ],
          //     );
          //   },
          // )
        ]);
