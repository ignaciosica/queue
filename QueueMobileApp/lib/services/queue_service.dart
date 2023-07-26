import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IQueueService {
  Stream<dynamic> getNowPlaying();
}

class QueueService implements IQueueService {
  QueueService(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  static const String _collectionName = 'rooms';

  @override
  Stream getNowPlaying() async* {
    final prefs = await SharedPreferences.getInstance();
    final roomId = prefs.getString('roomId');
    if (roomId != null) {
      final reference = _firestore.collection(_collectionName).doc(roomId);
      yield* reference.snapshots().asyncMap((snap) => snap.data()?['player_state'] as Map?);
    } else {
      yield null;
    }
  }
}
