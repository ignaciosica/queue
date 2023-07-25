import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/main.dart';
import 'package:queue/screens/room/room_screen.dart';
import 'package:queue/services/room_service.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:uuid/uuid.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() async {
  final user = MockUser(
    isAnonymous: true,
    uid: 'anonymous',
  );
  final auth = MockFirebaseAuth(mockUser: user);
  await auth.signInAnonymously();

  final firestore = FakeFirebaseFirestore();

  await firestore.collection('rooms').doc('qwerty').set({
    'name': 'VichiFest!',
    'participants': ['walter'],
  });

  await firestore.collection('rooms').doc('qwerty').collection('queue').add({
    'id': '1234',
  });

  if (kDebugMode) {
    print('dump: ${firestore.dump()}');
  }

  setupServiceLocator(firestore, auth);

  group('join room:', () {
    final IRoomService roomService = getIt<IRoomService>();

    test('valid room id', () async {
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
    final IRoomService roomService = getIt<IRoomService>();
    test('valid room', () async {
      var room = await roomService.createRoom('new room');
      expect(room['name'], 'new room');
      expect(room['player'], 'anonymous');
      expect((room['participants'] as List).contains('anonymous'), true);
    });
  });

  group('leave room:', () {
    final IRoomService roomService = getIt<IRoomService>();
    test('only participant', () async {
      await firestore.collection('rooms').doc('room_1').set({
        'name': 'leave',
        'id': 'room_1',
        'participants': ['anonymous'],
        'player': 'anonymous',
      });

      await roomService.leaveRoom('room_1');
      var snap = await firestore
          .collection('rooms')
          .where('id', isEqualTo: 'room_1')
          .get();

      expect(snap.size, 0);
    });

    test('player', () async {
      await firestore.collection('rooms').doc('room_2').set({
        'name': 'leave',
        'id': 'room_2',
        'participants': ['anonymous', 'walter'],
        'player': 'anonymous',
      });

      await roomService.leaveRoom('room_2');
      var snap = await firestore.collection('rooms').doc('room_2').get();

      expect(
          (snap.data()!['participants'] as List).contains('anonymous'), false);
      expect(snap.data()!['player'], null);
    });

    test('playernt', () async {
      await firestore.collection('rooms').doc('room_2').set({
        'name': 'leave',
        'id': 'room_2',
        'participants': ['anonymous', 'walter'],
        'player': 'walter',
      });

      await roomService.leaveRoom('room_2');
      var snap = await firestore.collection('rooms').doc('room_2').get();

      expect(
          (snap.data()!['participants'] as List).contains('anonymous'), false);
      expect(snap.data()!['player'], 'walter');
    });
  });

  group('lobby screen join room:', () {
    testWidgets('valid room (navigation):', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MyApp()));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('join_room_textfield_key')),
        'qwerty',
      );

      await tester.tap(find.byKey(const Key('join_room_button_key')));
      await tester.pumpAndSettle();
      expect(find.byType(RoomScreen), findsOneWidget);
    });

    testWidgets('invalid room (navigation):', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MyApp()));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('join_room_textfield_key')),
        'invalid',
      );

      await tester.tap(find.byKey(const Key('join_room_button_key')));
      await tester.pumpAndSettle();
      expect(find.byType(RoomScreen), findsNothing);
    });
  });

  group('lobby screen create room:', () {
    testWidgets('create room auth:', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(
          await (await firestore
                  .collection('rooms')
                  .where('name', isEqualTo: 'NachoFest!')
                  .get())
              .size,
          0);

      await tester.enterText(
        find.byKey(const Key('create_room_textfield_key')),
        'NachoFest!',
      );

      await tester.tap(find.byKey(const Key('create_room_button_key')));
      await tester.pumpAndSettle();
      if (kDebugMode) print(firestore.dump());
      expect(find.byType(RoomScreen), findsOneWidget);
      expect(
          await (await firestore
                  .collection('rooms')
                  .where('name', isEqualTo: 'NachoFest!')
                  .get())
              .size,
          1);
    });
    test('test create', () async {
      var roomId = const Uuid().v4().substring(0, 5).toLowerCase();

      // Generate "locally" a new document in a collection
      var document = firestore.collection('collectionName').doc();

      // Get the new document Id
      var documentUuid = document.id;

      // Sets the new document with its uuid as property
      //var response = await document.set({
      //  'uuid': documentUuid.substring(0, 5).toLowerCase(),
      //});

      print(firestore.dump());
    });
  });
}
