import 'dart:async';

import 'package:cache/cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupify/auth/auth.dart';
import 'package:groupify/common/common.dart';

class FirestoreRepository {
  FirestoreRepository(this._authRepository)
      : _instance = FirebaseFirestore.instance,
        _cache = CacheClient();

  final CacheClient _cache;
  final AuthRepository _authRepository;
  final FirebaseFirestore _instance;


  Future<String> createRoom(String name) async {
    final room = await _instance.collection('rooms').add({
      'name': name,
      'player': _authRepository.currentUser.id,
      'skip': [],
      'users': [_authRepository.currentUser.id],
      'player_state': {
        'duration': 0,
        'playback_position': 0,
        'is_paused': false,
        'uri': '',
      },
    });

    await _instance.collection('rooms').doc(room.id).update({
      'room_id': room.id.substring(0, 5),
    });

    await _instance.collection('users').doc(_authRepository.currentUser.id).update({'active_room': room.id});

    return room.id;
  }

  Future<void> changeVote(String roomId, FirestoreTrack track) async {
    final voted = track.votes.contains(_authRepository.currentUser.id);
    if (voted) {
      await removeVote(roomId, track.spotifyUri);
    } else {
      await addVote(roomId, track.spotifyUri);
    }
  }

  Future<void> setPlayer(String roomId, String playerId) {
    return _instance.collection("rooms").doc(roomId).update({"player": playerId});
  }

  Future<void> addTrackToQueue(String roomId, String trackId) async {
    final track = <String, dynamic>{
      'created_at': DateTime.now().toUtc(),
      'votes': [_authRepository.currentUser.id],
      'votes_count': 1,
    };

    await _instance.collection("rooms").doc(roomId).collection('queue').doc(trackId).set(track);
  }

  Future<void> addVote(String roomId, String spotifyUri) async {
    final track = _instance.collection("rooms").doc(roomId).collection('queue').doc(spotifyUri);

    await track.update({
      "votes_count": FieldValue.increment(1),
      "votes": FieldValue.arrayUnion([_authRepository.currentUser.id]),
    });
  }

  Future<void> removeVote(String roomId, String spotifyUri) async {
    final track = _instance.collection("rooms").doc(roomId).collection('queue').doc(spotifyUri);

    await track.update({
      "votes_count": FieldValue.increment(-1),
      "votes": FieldValue.arrayRemove([_authRepository.currentUser.id]),
    });
  }

  Future<void> removeTrack(String roomId, String spotifyUri) async {
    final track = _instance.collection("rooms").doc(roomId).collection('queue').doc(spotifyUri);

    await track.delete();
  }

  Query<Map<String, dynamic>> getQueueQuery(String roomId) {
    return _instance.collection('rooms').doc(roomId).collection('queue').orderBy('created_at', descending: false);
    //return _instance.collection('rooms').doc(await currentRoom).collection('queue').orderBy('votes_count', descending: true);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getQueueSnapshots(String roomId) {
    return _instance
        .collection('rooms')
        .doc(roomId)
        .collection('queue')
        .orderBy('created_at', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> nextUp(String roomId) {
    return _instance
        .collection('rooms')
        .doc(roomId)
        .collection('queue')
        .orderBy('votes_count', descending: true)
        .orderBy('created_at', descending: false)
        .limit(1)
        .snapshots();
  }

  Future<void> addSkipVote(String roomId) async {
    _instance.collection("rooms").doc(roomId).update({
      "skip": FieldValue.arrayUnion([_authRepository.currentUser.id])
    });
  }

  Future<void> removeSkipVote(String roomId) async {
    _instance.collection("rooms").doc(roomId).update({
      "skip": FieldValue.arrayRemove([_authRepository.currentUser.id])
    });
  }

  Future<void> clearSkipVotes(String roomId) async {
    _instance.collection("rooms").doc(roomId).update({"skip": []});
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getRoom(String roomId) {
    return _instance.collection('rooms').doc(roomId).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getTrack(String roomId, String trackId) {
    return _instance.collection('rooms').doc(roomId).collection('queue').doc(trackId).snapshots();
  }
}
