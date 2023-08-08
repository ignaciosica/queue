import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IQueueService {
  Stream get onPlayerState;
  Stream get onRoom;
  Stream<List> get onQueue;
  Future queue(String uri, {dynamic song});
  Future dequeue(String uri);
  Future vote(String uri);
  Future unvote(String uri);
  Future skip();
  Future unSkip();
  Future setPlayer(String uid);
}

//TODO: refactor to expose one queue stream for entire service
//TODO: refactor to expose one player state stream for entire service

class QueueService implements IQueueService {
  QueueService(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  static const String _collection = 'rooms';

  Stream getPlayerState() async* {
    final prefs = await SharedPreferences.getInstance();
    final roomId = prefs.getString('roomId');
    if (roomId != null) {
      final reference = _firestore.collection(_collection).doc(roomId);
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
  Stream get onPlayerState => getPlayerState().asBroadcastStream();

  Stream getRoom() async* {
    final prefs = await SharedPreferences.getInstance();
    final roomId = prefs.getString('roomId');
    if (roomId != null) {
      final reference = _firestore.collection(_collection).doc(roomId);
      yield* reference.snapshots().map((snap) => snap.data());
    } else {
      yield null;
    }
  }

  @override
  Stream get onRoom => getRoom().asBroadcastStream();

  Stream<List> getQueue() async* {
    final prefs = await SharedPreferences.getInstance();
    final roomId = prefs.getString('roomId');

    if (roomId != null) {
      final queue = _firestore.collection(_collection).doc(roomId).collection('queue');

      yield* queue.snapshots().map((snap) {
        final songs = snap.docs.map((song) => song.data()).toList();

        return songs;
      });
    } else {
      yield [];
    }
  }

  @override
  Stream<List> get onQueue => getQueue().asBroadcastStream();

  @override
  Future queue(String uri, {dynamic song}) async {
    final prefs = await SharedPreferences.getInstance();
    final roomId = prefs.getString('roomId');
    final ref = _firestore.collection(_collection).doc(roomId).collection('queue').doc(uri);

    final uid = _auth.currentUser?.uid;
    assert(uid != null, 'User must be signed in to queue a song');

    if (roomId == null) return;

    var track = await ref.get();
    if (track.exists) {
      var voters = (track.data()!['voters']) as List;

      if (!voters.contains(uid)) {
        await ref.update({
          'votes': voters.length + 1,
          'voters': FieldValue.arrayUnion([uid]),
          if (song != null) 'song': song,
        });
      }
    } else {
      await ref.set({
        'created_at': DateTime.timestamp(),
        'uri': uri,
        'votes': 1,
        'voters': [uid],
        if (song != null) 'song': song,
      });
    }
  }

  @override
  Future dequeue(String uri) async {
    final prefs = await SharedPreferences.getInstance();
    final roomId = prefs.getString('roomId');
    final ref = _firestore.collection(_collection).doc(roomId).collection('queue').doc(uri);

    final uid = _auth.currentUser?.uid;
    assert(uid != null, 'User must be signed in to queue a song');

    if (roomId == null) return;

    var track = await ref.get();

    if (track.exists) {
      var voters = (track.data()!['voters']) as List;

      if (voters.isEmpty) await ref.delete();
    }
  }

  @override
  Future vote(String uri) async {
    final prefs = await SharedPreferences.getInstance();
    final roomId = prefs.getString('roomId');
    final ref = _firestore.collection(_collection).doc(roomId).collection('queue').doc(uri);

    final uid = _auth.currentUser?.uid;
    assert(uid != null, 'User must be signed in to queue a song');

    if (roomId == null) return;

    var track = await ref.get();
    if (track.exists) {
      var voters = (track.data()!['voters']) as List;

      if (!voters.contains(uid)) {
        await ref.update({
          'votes': voters.length + 1,
          'voters': FieldValue.arrayUnion([uid]),
        });
      }
    }
  }

  @override
  Future unvote(String uri) async {
    final prefs = await SharedPreferences.getInstance();
    final roomId = prefs.getString('roomId');
    final ref = _firestore.collection(_collection).doc(roomId).collection('queue').doc(uri);

    final uid = _auth.currentUser?.uid;
    assert(uid != null, 'User must be signed in to queue a song');

    if (roomId == null) return;

    var track = await ref.get();
    if (track.exists) {
      var voters = (track.data()!['voters']) as List;

      if (voters.contains(uid)) {
        await ref.update({
          'votes': voters.length - 1,
          'voters': FieldValue.arrayRemove([uid]),
        });
      }
    }
  }

  @override
  Future skip() async {
    final prefs = await SharedPreferences.getInstance();
    final roomId = prefs.getString('roomId');
    final ref = _firestore.collection(_collection).doc(roomId);

    final uid = _auth.currentUser?.uid;
    assert(uid != null, 'User must be signed in to queue a song');

    if (roomId == null) return;

    await ref.update({
      'skip': FieldValue.arrayUnion([uid])
    });
  }

  @override
  Future unSkip() async {
    final prefs = await SharedPreferences.getInstance();
    final roomId = prefs.getString('roomId');
    final ref = _firestore.collection(_collection).doc(roomId);

    final uid = _auth.currentUser?.uid;
    assert(uid != null, 'User must be signed in to queue a song');

    if (roomId == null) return;

    await ref.update({
      'skip': FieldValue.arrayRemove([uid])
    });
  }

  @override
  Future setPlayer(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final roomId = prefs.getString('roomId');
    final ref = _firestore.collection(_collection).doc(roomId);

    if (roomId == null) return;

    await ref.update({
      'player': uid,
    });
  }
}
