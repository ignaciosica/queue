import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:queue/firebase_options.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  late final DocumentReference<dynamic> roomRef;
  late final Stream<PlayerState> playerStream;
  late final Stream<DocumentSnapshot<dynamic>> roomStream;

  Workmanager().executeTask((taskName, inputData) async {
    final roomId = await initTask(inputData);

    roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);

    playerStream = SpotifySdk.subscribePlayerState();
    roomStream = roomRef.snapshots();

    playerStream.listen((playerState) async {
      await roomRef.update({'player_state': playerStateToJson(playerState)});
    });

    roomStream.listen((event) async {
      final data = event.data()!;

      if (data['player'] != FirebaseAuth.instance.currentUser!.uid) {
        SpotifySdk.pause();
        Workmanager().cancelAll();
      }

      if (data['skip'].length >= (data['participants'].length / 2)) {
        await queue(roomRef);
        SpotifySdk.skipNext();
      }

      switch (data['task']['requested_action']) {
        case 'pause':
          SpotifySdk.pause();
          break;
        case 'play':
          SpotifySdk.resume();
          break;
        case 'kill':
          SpotifySdk.pause();
          Workmanager().cancelAll();
          break;
      }

      await roomRef.update({'task.requested_action': null});
    });

    while (true) {
      await Future.delayed(const Duration(seconds: 3));

      final ps = await SpotifySdk.getPlayerState();

      if (ps == null || ps.track == null) continue;

      if (ps.track!.duration - ps.playbackPosition < 7 * 1000) {
        await queue(roomRef);
        await Future.delayed(const Duration(seconds: 8));
      }
    }
  });
}

Future<String> initTask(inputData) async {
  try {
    await dotenv.load(fileName: '.env');
    final clientId = dotenv.get('SPOTIFY_CLIENT_ID');
    final redirectUrl = dotenv.get('SPOTIFY_REDIRECT_URI');

    await SpotifySdk.connectToSpotifyRemote(clientId: clientId, redirectUrl: redirectUrl);

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    final roomId = inputData?['roomId'];
    if (roomId == null) throw Exception('task_e: roomId is null');

    return roomId;
  } on Exception catch (e) {
    throw Exception('task_e: init failed with ($e)');
  }
}

Map? playerStateToJson(playerState) {
  return playerState.track == null
      ? null
      : {
          'player_state.duration': playerState.track!.duration,
          'player_state.playback_position': playerState.playbackPosition,
          'player_state.is_paused': playerState.isPaused,
          'player_state.name': playerState.track!.name,
          'player_state.uri': playerState.track!.uri,
          'player_state.image_uri': playerState.track!.imageUri.raw,
          'player_state.artists': playerState.track!.artists.map((e) => e.name).toList(),
        };
}

Future<dynamic> getHead(roomRef) async {
  final snapshot = await roomRef
      .collection('queue')
      .orderBy('votes', descending: true)
      .orderBy('created_at', descending: false)
      .limit(1)
      .get();

  if (snapshot.docs.isEmpty) return null;

  return snapshot.docs[0];
}

Future<void> queue(roomRef) async {
  roomRef.update({'skip': []});

  final head = await getHead(roomRef);
  if (head != null) {
    await roomRef.collection('history').doc(head.id).set(head.data());
    await roomRef.collection('queue').doc(head.id).delete();
    await SpotifySdk.queue(spotifyUri: head.id);
  }
}
