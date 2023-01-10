import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groupify/app/app.dart';
import 'package:groupify/auth/auth.dart';
import 'package:groupify/common/common.dart';
import 'package:groupify/firebase_options.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      if (kDebugMode) print("init firebase: $task");
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      if (kDebugMode) print("init firebase successfully: $task");
    } catch (e) {
      if (kDebugMode) print("init firebase exception: $e");
    }

    try {
      if (kDebugMode) print("init spotifySdk: $task without access token");
      await SpotifySdk.connectToSpotifyRemote(
        clientId: inputData!['clientId'],
        redirectUrl: inputData!['redirectUrl'],
      );
      if (kDebugMode) print("init spotifySdk successfully: $task");
    } catch (e) {
      if (kDebugMode) print("init spotifySdk exception: $e");
    }

    for (var i = 0; i < 1000; i++) {
      var state = await SpotifySdk.getPlayerState();

      if (state == null || state.track == null || state.isPaused) {
        await Future.delayed(const Duration(seconds: 10));
        continue;
      }

      await Future.delayed(Duration(milliseconds: (state.track!.duration - state.playbackPosition - 10 * 1000)));

      if (kDebugMode) print("pp: ${state.playbackPosition}");
      if (kDebugMode) print("td: ${state.track!.duration}");

      var querySnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(inputData!['room'])
          .collection('queue')
          .orderBy('votes_count', descending: true)
          .orderBy('created_at', descending: false)
          .limit(1)
          .get();

      Map<String, dynamic> json = querySnapshot.docs[0].data();
      json['spotify_uri'] = querySnapshot.docs[0].id;
      final firestoreTrack = FirestoreTrack.fromJson(json);

      await SpotifySdk.queue(spotifyUri: 'spotify:track:${firestoreTrack.spotifyUri}');

      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(inputData!['room'])
          .collection('history')
          .doc(firestoreTrack.spotifyUri)
          .set(querySnapshot.docs[0].data());

      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(inputData!['room'])
          .collection('queue')
          .doc(firestoreTrack.spotifyUri)
          .delete();

      await Future.delayed(const Duration(seconds: 10));
    }

    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  return BlocOverrides.runZoned(
    () async {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      final authenticationRepository = AuthRepository();
      await authenticationRepository.user.first;
      await authenticationRepository.connectToSpotify();
      final firestoreRepository = FirestoreRepository(authenticationRepository);
      await firestoreRepository.currentRoomAsync;
      Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

      runApp(App(authenticationRepository: authenticationRepository, firestoreRepository: firestoreRepository));
    },
  );
}
