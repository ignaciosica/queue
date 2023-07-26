import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IQueueService {
  Stream<dynamic> getPlayerState();
  Stream<dynamic> getQueue();
}

class QueueService implements IQueueService {
  QueueService(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  static const String _collectionName = 'rooms';

  @override
  Stream getPlayerState() async* {
    final prefs = await SharedPreferences.getInstance();
    final roomId = prefs.getString('roomId');
    if (roomId != null) {
      final reference = _firestore.collection(_collectionName).doc(roomId);
      yield* reference.snapshots().map((snap) {
        final playerState = snap.data()?['player_state'] as Map?;

        if (playerState == null || playerState.isEmpty) return null;

        return playerState;
      });
    } else {
      yield null;
    }
  }

  @override
  Stream getQueue() async* {
    final prefs = await SharedPreferences.getInstance();
    final roomId = prefs.getString('roomId');
    if (roomId != null) {
      final queue = _firestore.collection(_collectionName).doc(roomId).collection('queue');

      yield* queue.snapshots().map((snap) {
        final songs = snap.docs.map((song) => song.data()).toList();

        return songs;
      });
    } else {
      yield [];
    }
  }
}
