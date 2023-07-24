import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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

      final reference = await _firestore.collection(_collectionName).add(
        {
          'name': roomName,
          'participants': [authorId],
          'player': authorId,
          'player_state': null,
          'skip': [],
        },
      );

      await reference
          .update({'id': reference.id.substring(0, 5).toLowerCase()});

      final doc = await reference.get();

      return doc.data();
    } on Exception catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }

  @override
  Future joinRoom(String roomId) async {
    var query = await _firestore
        .collection(_collectionName)
        .where('id', isEqualTo: roomId)
        .get();

    if (query.size != 1) return null;

    var updated = await _firestore
        .collection(_collectionName)
        .doc(query.docs[0].id)
        .update({
      'participants': FieldValue.arrayUnion([_auth.currentUser!.uid])
    });

    return query.size == 1 ? query.docs[0].data() : null;
  }
}
