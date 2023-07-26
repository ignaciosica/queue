import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/main.dart';
import 'package:queue/screens/room/room_screen.dart';
import 'package:queue/screens/room/widgets/now_playing_tile.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() async {
  late MockUser user;
  late MockFirebaseAuth auth;
  late FakeFirebaseFirestore firestore;
  late SharedPreferences prefs;

  setUp(() async {
    user = MockUser(isAnonymous: true, uid: 'anonymous');
    auth = MockFirebaseAuth(mockUser: user);
    firestore = FakeFirebaseFirestore();
    await auth.signInAnonymously();

    setupServiceLocator(firestore, auth);

    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  tearDown(() {
    getIt.reset();
  });

  group('lobby screen join room:', () {
    testWidgets('valid room (navigation):', (tester) async {
      await firestore.collection('rooms').doc('qwerty').set({
        'name': 'qwerty',
        'participants': ['walter'],
      });

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
    }, variant: ValueVariant({'invalid'}));
  });

  group('nowPlaying:', () {
    testWidgets('null', (tester) async {
      await firestore.collection('rooms').doc('qwerty').set({
        'name': 'qwerty',
        'participants': ['walter'],
      });

      await prefs.setString('roomId', 'qwerty');

      await tester.pumpWidget(const MaterialApp(home: NowPlayingTile()));
      await tester.pumpAndSettle();
      expect(find.byType(NowPlayingTileDummy), findsOneWidget);
    });
    testWidgets('valid', (tester) async {
      await firestore.collection('rooms').doc('qwerty').set({
        'name': 'VichiFest!',
        'participants': ['walter']
      });

      await prefs.setString('roomId', 'player_state');
      await firestore.collection('rooms').doc('player_state').set({
        'name': 'VichiFest!',
        'participants': ['walter'],
      });

      await tester.pumpWidget(const MaterialApp(home: NowPlayingTile()));
      await tester.pumpAndSettle();
      expect(find.byType(NowPlayingTileDummy), findsOneWidget);

      await firestore.collection('rooms').doc('player_state').update({
        'player_state': {
          'name': 'Asilo',
          'artists': ['Jorge Drexler', 'Mon Laferte'],
        }
      });

      await tester.pumpAndSettle();
      expect(find.byType(NowPlayingTileDummy), findsNothing);

      await firestore.collection('rooms').doc('player_state').update({
        'player_state': null,
      });

      await tester.pumpAndSettle();
      expect(find.byType(NowPlayingTileDummy), findsOneWidget);
    });
  });

  group('lobby screen create room:', () {
    testWidgets('create room auth:', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(
          await (await firestore.collection('rooms').where('name', isEqualTo: 'NachoFest!').get())
              .size,
          0);

      await tester.enterText(
        find.byKey(const Key('create_room_textfield_key')),
        'NachoFest!',
      );

      await tester.tap(find.byKey(const Key('create_room_button_key')));
      await tester.pumpAndSettle();
      expect(find.byType(RoomScreen), findsOneWidget);
      expect(
          await (await firestore.collection('rooms').where('name', isEqualTo: 'NachoFest!').get())
              .size,
          1);
    });
  });
}
