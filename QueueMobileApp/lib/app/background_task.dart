import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:queue/firebase_options.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:workmanager/workmanager.dart';

//TODO: listen room stream and check for skip and queue

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

    queue() async {
      final query = roomRef
          .collection('queue')
          .orderBy('votes', descending: true)
          .orderBy('created_at', descending: false)
          .limit(1);

      final snapshot = (await query.get());

      roomRef.update({'skip': []});

      if (snapshot.docs.isEmpty) return;

      final track = snapshot.docs[0];

      await roomRef.collection('history').doc(track.id).set(track.data());
      SpotifySdk.queue(spotifyUri: track.id);
      await roomRef.collection('queue').doc(track.id).delete();
    }

    roomStream.listen((event) async {
      final data = event.data()!;
      if (data['player'] != FirebaseAuth.instance.currentUser!.uid) {
        SpotifySdk.pause();
        Workmanager().cancelAll();
      }

      if (data['skip'].length >= (data['participants'].length / 2)) {
        await queue.call();
        SpotifySdk.skipNext();
      }

      switch (data['task']['requested_action']) {
        case 'pause':
          SpotifySdk.pause();
          await roomRef.update({'task.requested_action': null});
          break;
        case 'play':
          SpotifySdk.resume();
          await roomRef.update({'task.requested_action': null});
          break;
        case 'kill':
          SpotifySdk.pause();
          await roomRef.update({'task.requested_action': null});
          Workmanager().cancelAll();
          break;
        default:
      }
    });

    int a = 0;

    while (true) {
      await Future.delayed(const Duration(seconds: 3));
      if (kDebugMode) print('a:${a++}');

      final playerState = await SpotifySdk.getPlayerState();

      if (playerState == null || playerState.track == null) continue;

      if (playerState.track!.duration - playerState.playbackPosition < 7 * 1000) {
        await queue.call();
        await Future.delayed(const Duration(seconds: 10));
      }
    }
  });
}
