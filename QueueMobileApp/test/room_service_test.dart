import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/services/room_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  late MockUser user;
  late MockFirebaseAuth auth;
  late FakeFirebaseFirestore firestore;
  late IRoomService roomService;

  setUp(() async {
    user = MockUser(isAnonymous: true, uid: 'anonymous');
    auth = MockFirebaseAuth(mockUser: user);
    firestore = FakeFirebaseFirestore();
    await auth.signInAnonymously();

    setupServiceLocator(firestore, auth);
    roomService = getIt<IRoomService>();

    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    getIt.reset();
  });

  group('join room:', () {
    test('valid room id', () async {
      await firestore.collection('rooms').doc('qwerty').set({
        'name': 'VichiFest!',
        'participants': ['walter'],
      });

      var snap = await firestore.collection('rooms').doc('qwerty').get();

      expect(snap['name'], 'VichiFest!');
      expect((snap['participants'] as List).contains('anonymous'), false);

      var room = await roomService.joinRoom('qwerty');
      expect(room['name'], 'VichiFest!');
      expect((room['participants'] as List).contains('anonymous'), true);
    });

    test('invalid room', () async {
      var room = await roomService.joinRoom('invalid');
      expect(room, null);
    });
  });

  group('create room:', () {
    test('valid room', () async {
      var room = await roomService.createRoom('valid');
      expect(room['name'], 'valid');
      expect(room['player'], 'anonymous');
      expect((room['participants'] as List).contains('anonymous'), true);
    });
  });

  group('leave room:', () {
    test('only participant', () async {
      await firestore.collection('rooms').doc('room').set({
        'name': 'leave',
        'id': 'room',
        'participants': ['anonymous'],
        'player': 'anonymous',
      });

      await roomService.leaveRoom('room');
      var snap = await firestore.collection('rooms').where('id', isEqualTo: 'room').get();

      expect(snap.size, 0);
    });

    test('player', () async {
      await firestore.collection('rooms').doc('room').set({
        'name': 'leave',
        'id': 'room',
        'participants': ['anonymous', 'walter'],
        'player': 'anonymous',
      });

      await roomService.leaveRoom('room');
      var snap = await firestore.collection('rooms').doc('room').get();

      expect((snap.data()!['participants'] as List).contains('anonymous'), false);
      expect(snap.data()!['player'], null);
    });

    test('playernt', () async {
      await firestore.collection('rooms').doc('room').set({
        'name': 'leave',
        'id': 'room',
        'participants': ['anonymous', 'walter'],
        'player': 'walter',
      });

      await roomService.leaveRoom('room');
      var snap = await firestore.collection('rooms').doc('room').get();

      expect((snap.data()!['participants'] as List).contains('anonymous'), false);
      expect(snap.data()!['player'], 'walter');
    });
  });
}
