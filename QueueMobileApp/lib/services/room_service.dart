import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IRoomService {
  Future<dynamic> joinRoom(String roomName);
  Future<dynamic> createRoom(String roomName);
}

class RoomService implements IRoomService {
  RoomService(this._firestore);

  final FirebaseFirestore _firestore;
  static const String _collectionName = 'rooms';

  @override
  Future createRoom(String roomName) {
    // TODO: implement createRoom
    throw UnimplementedError();
  }

  @override
  Future joinRoom(String roomId) async {
    var query = await _firestore
        .collection(_collectionName)
        .where('id', isEqualTo: roomId)
        .get();

    return query.size == 1 ? query.docs[0].data() : null;
  }
}
