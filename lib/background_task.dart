import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:groupify/common/common.dart';
import 'package:groupify/firebase_options.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    await SpotifySdk.connectToSpotifyRemote(clientId: inputData!['clientId'], redirectUrl: inputData!['redirectUrl']);

    var skipFlag = false;

    // Stream.periodic(const Duration(seconds: 5)).listen((event) {
    //   skipFlag = true;
    // });

    var queueFlag = false;
    var trackUri = '';
    var wasPaused = false;

    SpotifySdk.subscribePlayerState().listen((playerState) async {
      if (playerState.track == null) return;

      if (trackUri != playerState.track!.uri) {
        trackUri = playerState.track!.uri;
        await FirebaseFirestore.instance.collection('rooms').doc(inputData!['room']).update(playerStateToJson(playerState));
      } else {
        if (playerState.isPaused) {
          if (!wasPaused) {
            wasPaused = true;
            await FirebaseFirestore.instance.collection('rooms').doc(inputData!['room']).update({
              'player_state.playback_position': playerState!.playbackPosition,
              'player_state.is_paused': playerState!.isPaused,
            });
          }
        } else {
          wasPaused = false;
          await FirebaseFirestore.instance.collection('rooms').doc(inputData!['room']).update({
            'player_state.playback_position': playerState!.playbackPosition,
            'player_state.is_paused': playerState!.isPaused,
          });
        }
      }
    });

    Stream.periodic(const Duration(seconds: 5)).listen((event) async {
      var playerState = await SpotifySdk.getPlayerState();
      if (playerState == null || playerState.track == null) return;

      if (playerState.track!.duration - playerState.playbackPosition < 10 * 1000) {
        queueFlag = true;
        await Future.delayed(const Duration(seconds: 10));
      }
    });

    var roomCacheJson = await FirebaseFirestore.instance.collection('rooms').doc(inputData!['room']).get();
    var roomCache = Room.fromJson(roomCacheJson.data()!);

    FirebaseFirestore.instance.collection('rooms').doc(inputData!['room']).snapshots().listen((event) {
      if (event.exists) {
        var roomCacheJson = event;
        roomCache = Room.fromJson(roomCacheJson.data()!);
        skipFlag = true;
      }
    });

    while (true) {
      await Future.delayed(const Duration(seconds: 1));

      if (skipFlag) {
        skipFlag = false;

        if (roomCache.skip.length >= max(1, (roomCache.users.length / 2).floor())) {
          await FirebaseFirestore.instance.collection("rooms").doc(inputData!['room']).update({"skip": []});
          await queueNextUp(inputData);
          SpotifySdk.skipNext();
        }
      }

      if (queueFlag) {
        queueFlag = false;
        await queueNextUp(inputData);
      }
    }

    return Future.value(true);
  });
}

Future<void> queueNextUp(inputData) async {
  AggregateQuerySnapshot queueCount =
      await FirebaseFirestore.instance.collection('rooms').doc(inputData!['room']).collection('queue').count().get();

  if (queueCount.count == 0) return;

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
      .collection('queue')
      .doc(firestoreTrack.spotifyUri)
      .delete();
}

Map<String, dynamic> playerStateToJson(PlayerState playerState) {
  return {
    'player_state.artists': playerState!.track?.artists.map((e) => e.name).toList() ?? [],
    'player_state.duration': playerState!.track?.duration ?? 0,
    'player_state.image_uri': playerState!.track?.imageUri.raw ?? '',
    'player_state.name': playerState!.track?.name ?? '',
    'player_state.is_paused': playerState!.isPaused,
    'player_state.playback_position': playerState!.playbackPosition,
    'player_state.uri': playerState!.track?.uri ?? '',
  };
}
