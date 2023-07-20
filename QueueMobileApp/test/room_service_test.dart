import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queue/main.dart';
import 'package:queue/screens/lobby/lobby_screen.dart';
import 'package:queue/screens/room/room_screen.dart';
import 'package:queue/services/room_service.dart';

void main() async {
  final instance = FakeFirebaseFirestore();

  await instance.collection('rooms').doc('qwerty1234').set({
    'id': 'qwerty',
    'name': 'VichiFest!',
  });

  await instance.collection('rooms').doc('qwerty1234').collection('queue').add({
    'id': '1234',
  });

  if (kDebugMode) {
    print('dump: ${instance.dump()}');
  }

  final RoomService roomService = RoomService(instance);

  group('join room:', () {
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
      await tester.pumpWidget(const MyApp());
      await tester.enterText(find.byType(TextField), 'qwerty');
      await tester.tap(find.text('Join Room'));
      expect(find.byType(RoomScreen), findsOneWidget);
    });
  });
}
