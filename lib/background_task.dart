import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
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

    Stream.periodic(const Duration(seconds: 5)).listen((event) {
      skipFlag = true;
    });

    var queueFlag = false;
    var trackUri = '';

    Stream.periodic(const Duration(seconds: 10)).listen((event) async {
      var playerState = await SpotifySdk.getPlayerState();
      if (playerState == null || playerState.track == null || playerState.isPaused) return;

      if (trackUri != playerState.track!.uri) {
        trackUri = playerState.track!.uri;
        await FirebaseFirestore.instance.collection('rooms').doc(inputData!['room']).update(playerStateToJson(playerState));
      }

      if (playerState.track!.duration - playerState.playbackPosition < 10 * 1000) {
        queueFlag = true;
      }
    });

    while (true) {
      await Future.delayed(const Duration(seconds: 1));

      if (skipFlag) {
        skipFlag = false;
        var roomJson = await FirebaseFirestore.instance.collection('rooms').doc(inputData!['room']).get();
        var room = Room.fromJson(roomJson.data()!);

        if (room.skip.length >= max(1, (room.users.length / 2).floor())) {
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
  AggregateQuerySnapshot queueCount = await FirebaseFirestore.instance
      .collection('rooms')
      .doc(inputData!['room'])
      .collection('queue').count().get();

  if(queueCount.count == 0) return;

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
}

Map<String, dynamic> playerStateToJson (PlayerState playerState) {
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
