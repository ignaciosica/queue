import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:queue/firebase_options.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:workmanager/workmanager.dart';

//TODO: listen playerState stream and update firestore
//TODO: listen room stream and check for skip and queue
//TODO: kill background task if player changes

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    if (kDebugMode) print('roomId:${inputData!['roomId']}');

    try {
      final clientId = dotenv.get('SPOTIFY_CLIENT_ID');
      if (kDebugMode) print('clientId:$clientId');

      final redirectUrl = dotenv.get('SPOTIFY_REDIRECT_URI');
      if (kDebugMode) print('redirect:$redirectUrl');

      await SpotifySdk.connectToSpotifyRemote(clientId: clientId, redirectUrl: redirectUrl);
    } on Exception catch (e) {
      if (kDebugMode) print('error:$e');
    }

    final playerStream = SpotifySdk.subscribePlayerState();

    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(inputData!['roomId']);
    final roomStream = roomRef.snapshots();

    playerStream.listen((playerState) async {
      if (playerState.track == null) {
        await roomRef.update({'player_state': null});
      } else {
        await roomRef.update({
          'player_state.duration': playerState.track!.duration,
          'player_state.playback_position': playerState.playbackPosition,
          'player_state.is_paused': playerState.isPaused,
          'player_state.name': playerState.track!.name,
          'player_state.uri': playerState.track!.uri,
          'player_state.image_uri': playerState.track!.imageUri.raw,
          'player_state.artists': playerState.track!.artists.map((e) => e.name).toList(),
        });
      }
    });

    roomStream.listen((event) {
      if (event.data()!['player'] != FirebaseAuth.instance.currentUser!.uid) {
        Workmanager().cancelAll();
      }
    });

    for (int i = 0; i < 100; i++) {
      await Future.delayed(const Duration(seconds: 1));
      if (kDebugMode) print('i:$i');
    }

    return Future.value(true);
  });
}
