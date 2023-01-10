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
      if (kDebugMode) print("init spotifySdk: $task");
      await SpotifySdk.connectToSpotifyRemote(
        clientId: inputData!['clientId'],
        redirectUrl: inputData!['redirectUrl'],
        accessToken: inputData!['accessToken'],
      );
      if (kDebugMode) print("init spotifySdk successfully: $task");
    } catch (e) {
      if (kDebugMode) print("init spotifySdk exception: $e");
    }

    var state = await SpotifySdk.subscribePlayerState().first;
    var playing = state.track!.uri;

    for (var i = 0; i < 1000; i++) {
      await Future.delayed(const Duration(seconds: 1));

      var state = await SpotifySdk.subscribePlayerState().first;

      if (kDebugMode) print("pp: ${state.playbackPosition}");
      if (kDebugMode) print("td: ${state.track!.duration}");

      if (state.track!.duration - state.playbackPosition < 10 * 1000 && playing == state.track!.uri) {
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
        playing = 'spotify:track:${firestoreTrack.spotifyUri}';

        await SpotifySdk.queue(spotifyUri: 'spotify:track:${firestoreTrack.spotifyUri}');
        if (kDebugMode) print("added ${firestoreTrack.spotifyUri} to queue");

        FirebaseFirestore.instance
            .collection('rooms')
            .doc(inputData!['room'])
            .collection('history')
            .doc(firestoreTrack.spotifyUri)
            .set(querySnapshot.docs[0].data());

        FirebaseFirestore.instance
            .collection('rooms')
            .doc(inputData!['room'])
            .collection('queue')
            .doc(firestoreTrack.spotifyUri)
            .delete();

        if (kDebugMode) print("removed ${firestoreTrack.spotifyUri} from queue");
      }

      if (kDebugMode) print(i);
    }

    var snap = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(inputData!['room'])
        .collection('queue')
        .orderBy('created_at', descending: false)
        .get();

    snap.docs.forEach((element) {
      print(element.data());
    });

    SpotifySdk.subscribePlayerState().listen((event) {
      print(event.isPaused);
    });

    try {
      print('$task try-skip');
      await SpotifySdk.skipNext();
      print('$task skipped successfully');
    } catch (e) {
      print(e);
    }

    print("End native called background task: $task");

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
