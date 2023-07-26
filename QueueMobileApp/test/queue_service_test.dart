import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:queue/app/service_locator.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:queue/services/queue_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() async {
  late MockUser user;
  late MockFirebaseAuth auth;
  late FakeFirebaseFirestore firestore;
  late SharedPreferences prefs;
  late IQueueService queueService;

  setUp(() async {
    user = MockUser(isAnonymous: true, uid: 'anonymous');
    auth = MockFirebaseAuth(mockUser: user);
    firestore = FakeFirebaseFirestore();
    await auth.signInAnonymously();

    setupServiceLocator(firestore, auth);
    queueService = getIt<IQueueService>();

    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  tearDown(() {
    getIt.reset();
  });

  group('playerState:', () {
    test('valid', () async {
      final playerState = {
        'name': 'Luv(sic)',
        'artists': ['Nujabes']
      };

      await prefs.setString('roomId', 'qwerty');
      await firestore.collection('rooms').doc('qwerty').set({'player_state': playerState});
      final snap = await queueService.getPlayerState().first;

      expect(snap, playerState);
    });

    test('null', () async {
      const playerState = null;

      await prefs.setString('roomId', 'qwerty');
      await firestore.collection('rooms').doc('qwerty').set({'player_state': playerState});
      final snap = await queueService.getPlayerState().first;

      expect(snap, playerState);
    });

    test('empty', () async {
      const playerState = {};

      await prefs.setString('roomId', 'qwerty');
      await firestore.collection('rooms').doc('qwerty').set({'player_state': playerState});
      final snap = await queueService.getPlayerState().first;

      expect(snap, null);
    });

    test('stream', () async {
      await prefs.setString('roomId', 'qwerty');

      const vals = [
        {
          'name': 'Luv(sic)',
          'artists': ['Nujabes']
        },
        null,
        {
          'name': 'Asilo',
          'artists': ['Drexler']
        },
        null,
      ];

      expectLater(queueService.getPlayerState(), emitsInOrder([vals[0], ...vals]));

      for (var state in vals) {
        await firestore.collection('rooms').doc('qwerty').set({'player_state': state});
      }
    });
  });
}
