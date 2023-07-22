import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/main.dart';
import 'package:queue/screens/room/room_screen.dart';
import 'package:queue/services/room_service.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() async {
  final googleSignIn = MockGoogleSignIn();
  final signinAccount = await googleSignIn.signIn();
  final googleAuth = await signinAccount?.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  final user = MockUser(
    isAnonymous: false,
    uid: 'someuid',
    email: 'bob@somedomain.com',
    displayName: 'Bob',
  );
  final auth = MockFirebaseAuth(mockUser: user);
  final result = await auth.signInWithCredential(credential);
  if (kDebugMode) print(result.user?.displayName);

  final firestore = FakeFirebaseFirestore();

  await firestore.collection('rooms').doc('qwerty1234').set({
    'id': 'qwerty',
    'name': 'VichiFest!',
  });

  await firestore
      .collection('rooms')
      .doc('qwerty1234')
      .collection('queue')
      .add({
    'id': '1234',
  });

  if (kDebugMode) {
    print('dump: ${firestore.dump()}');
  }

  setupServiceLocator(firestore, auth);

  group('join room:', () {
    final IRoomService roomService = getIt<IRoomService>();

    test('valid room id', () async {
      var room = await roomService.joinRoom('qwerty');
      expect(room['name'], 'VichiFest!');
    });

    test('invalid room', () async {
      var room = await roomService.joinRoom('invalid');
      expect(room, null);
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
              .docs[0]
              .exists,
          true);
    });
  });
}
