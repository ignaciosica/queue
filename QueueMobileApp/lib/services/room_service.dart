import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

abstract class IRoomService {
  Future<dynamic> joinRoom(String roomId);
  Future<dynamic> createRoom(String roomName);
  Future<void> leaveRoom(String roomId);
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
          'id': roomId,
          'name': roomName,
          'participants': [authorId],
          'player': authorId,
          'player_state': null,
          'skip': [],
        },
      );

      final doc = await reference.get();

      SharedPreferences.getInstance()
          .then((prefs) => prefs.setString('roomId', roomId));

      return doc.data();
    } on Exception catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }

  @override
  Future joinRoom(String roomId) async {
    try {
      final query = await _firestore
          .collection(_collectionName)
          .where(FieldPath.documentId, isEqualTo: roomId)
          .get();

      if (query.size == 0) return null;

      var reference = _firestore.collection(_collectionName).doc(roomId);

      await reference.update({
        'participants': FieldValue.arrayUnion([_auth.currentUser!.uid])
      });

      SharedPreferences.getInstance()
          .then((prefs) => prefs.setString('roomId', roomId));

      final doc = await reference.get();

      return doc.data();
    } on Exception catch (e) {
      if (kDebugMode) print(e.toString());
      return null;
    }
  }

  @override
  Future leaveRoom(String roomId) async {
    try {
      var ref = _firestore.collection(_collectionName).doc(roomId);

      await _firestore.runTransaction((transaction) async {
        await transaction.get(ref).then((value) {
          if ((value.data()!['participants'] as List)
              .every((element) => element == _auth.currentUser!.uid)) {
            transaction.delete(ref);
          } else {
            transaction.update(ref, {
              'participants': FieldValue.arrayRemove([_auth.currentUser!.uid])
            });

            if (value.data()!['player'] == _auth.currentUser!.uid) {
              transaction.update(ref, {'player': null, 'player_state': null});
            }
          }
        });
      });

      SharedPreferences.getInstance().then((prefs) => prefs.remove('roomId'));
    } on Exception catch (e) {
      if (kDebugMode) print(e.toString());
      return null;
    }
  }
}
