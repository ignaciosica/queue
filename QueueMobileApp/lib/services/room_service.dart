import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

abstract class IRoomService {
  Future<dynamic> joinRoom(String roomName);
  Future<dynamic> createRoom(String roomName);
}

class RoomService implements IRoomService {
  RoomService(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  static const String _collectionName = 'rooms';

  @override
  Future createRoom(String roomName) async {
    try {
      final String? authorId = _auth.currentUser?.uid;

      assert(authorId != null, 'authorId must not be null');
      if (authorId == null) throw Exception('authorId is null');

      var roomId = const Uuid().v4().substring(0, 5).toLowerCase();

      var reference = _firestore.collection(_collectionName).doc(roomId);

      await reference.set(
        {
          'name': roomName,
          'participants': [authorId],
          'player': authorId,
          'player_state': null,
          'skip': [],
        },
      );

      final doc = await reference.get();

      return doc.data();
    } on Exception catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }

  @override
  Future joinRoom(String roomId) async {
    try {
      var reference = _firestore.collection(_collectionName).doc(roomId);

      await reference.update({
        'participants': FieldValue.arrayUnion([_auth.currentUser!.uid])
      });

      return (await reference.get()).data();
    } on Exception catch (e) {
      if (kDebugMode) print(e.toString());
      return null;
    }
  }
}
