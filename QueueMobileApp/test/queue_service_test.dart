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

  group('onPlayerState:', () {
    test('valid', () async {
      final playerState = {
        'name': 'Luv(sic)',
        'artists': ['Nujabes']
      };

      await prefs.setString('roomId', 'qwerty');
      await firestore.collection('rooms').doc('qwerty').set({'player_state': playerState});
      final snap = await queueService.onPlayerState.first;

      expect(snap, playerState);
    });

    test('null', () async {
      const playerState = null;

      await prefs.setString('roomId', 'qwerty');
      await firestore.collection('rooms').doc('qwerty').set({'player_state': playerState});
      final snap = await queueService.onPlayerState.first;

      expect(snap, playerState);
    });

    test('empty', () async {
      const playerState = {};

      await prefs.setString('roomId', 'qwerty');
      await firestore.collection('rooms').doc('qwerty').set({'player_state': playerState});
      final snap = await queueService.onPlayerState.first;

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

      expectLater(queueService.onPlayerState, emitsInOrder([vals[0], ...vals]));

      for (var state in vals) {
        await firestore.collection('rooms').doc('qwerty').set({'player_state': state});
      }
    });
  });

  group('getQueue:', () {
    test('stream', () async {
      await prefs.setString('roomId', 'qwerty');
      final ref = firestore.collection('rooms').doc('qwerty').collection('queue');

      var t1 = {
        'uri': 'spotify:track:1',
        'created_at': '001',
        'voters': ['anonymous'],
        'votes': 1,
      };
      var t2 = {
        'uri': 'spotify:track:2',
        'created_at': '002',
        'voters': ['anonymous'],
        'votes': 1,
      };
      var t3 = {
        'uri': 'spotify:track:3',
        'created_at': '003',
        'voters': ['anonymous'],
        'votes': 1,
      };

      expectLater(
          queueService.onQueue,
          emitsInOrder([
            [t1],
            [t1, t2],
            [t1, t2, t3]
          ]));

      await ref.add(t1);
      await ref.add(t2);
      await ref.add(t3);
    });

    test('empty', () async {
      await prefs.setString('roomId', 'qwerty');

      expectLater(await queueService.onQueue.first, []);
    });
  });

  group('queue:', () {
    const t1 = 'spotify:track:1';
    const t2 = 'spotify:track:2';
    const t3 = 'spotify:track:3';

    test('valid queue', () async {
      await prefs.setString('roomId', 'qwerty');

      expectLater(
          queueService.onQueue.map((event) => event.map((e) => e['uri'])),
          emitsInOrder([
            [],
            [t1],
            [t1, t2],
            [t1, t2, t3],
          ]));

      await queueService.queue(t1);
      await queueService.queue(t2);
      await queueService.queue(t3);
    });

    test('valid dequeue', () async {
      await prefs.setString('roomId', 'qwerty');
      final ref = firestore.collection('rooms').doc('qwerty').collection('queue').doc(t1);
      await ref.set({
        'uri': 'spotify:track:1',
        'created_at': '001',
        'voters': [],
        'votes': 0,
      });

      expectLater(
          queueService.onQueue.map((event) => event.map((e) => e['uri'])),
          emitsInOrder([
            [t1],
            []
          ]));

      await queueService.dequeue(t1);
    });

    test('invalid queue', () async {
      await prefs.setString('roomId', 'qwerty');

      expectLater(
          queueService.onQueue.map((event) => event.map((e) => e['uri'])),
          emitsInOrder([
            [],
            [t1],
            [t1, t2],
          ]));

      await queueService.queue(t1);
      await queueService.queue(t1);
      await queueService.queue(t2);
    });

    test('invalid dequeue', () async {
      await prefs.setString('roomId', 'qwerty');
      final ref = firestore.collection('rooms').doc('qwerty').collection('queue').doc(t1);
      await ref.set({
        'uri': 'spotify:track:1',
        'created_at': '001',
        'voters': [],
        'votes': 0,
      });

      expectLater(
          queueService.onQueue.map((event) => event.map((e) => e['uri'])),
          emitsInOrder([
            [t1],
            []
          ]));

      await queueService.dequeue(t2);
      await queueService.dequeue(t1);
    });
  });
  group('votes:', () {
    const t1 = 'spotify:track:1';
    const t2 = 'spotify:track:2';
    test('vote', () async {
      await prefs.setString('roomId', 'qwerty');
      final ref = firestore.collection('rooms').doc('qwerty').collection('queue').doc(t1);

      expectLater(
        queueService.onQueue.map((snap) => snap.map((e) => e['votes'])),
        emitsInOrder([
          [0],
          [1]
        ]),
      );

      await ref.set({
        'uri': 'spotify:track:1',
        'created_at': '001',
        'voters': [],
        'votes': 0,
      });

      await queueService.vote(t1);
    });

    test('invalid vote', () async {
      await prefs.setString('roomId', 'qwerty');
      final ref = firestore.collection('rooms').doc('qwerty').collection('queue').doc(t1);

      expectLater(
        queueService.onQueue.map((snap) => snap.map((e) => e['votes'])),
        emitsInOrder([
          [0]
        ]),
      );

      await ref.set({
        'uri': 'spotify:track:1',
        'created_at': '001',
        'voters': [],
        'votes': 0,
      });

      await queueService.vote(t2);
    });

    test('already voted', () async {
      await prefs.setString('roomId', 'qwerty');
      final ref = firestore.collection('rooms').doc('qwerty').collection('queue').doc(t1);

      expectLater(
        queueService.onQueue.map((snap) => snap.map((e) => e['votes'])),
        emitsInOrder([
          [0],
          [1],
        ]),
      );

      await ref.set({
        'uri': 'spotify:track:1',
        'created_at': '001',
        'voters': [],
        'votes': 0,
      });

      await queueService.vote(t1);
      await queueService.vote(t1);
    });

    test('unvote', () async {
      await prefs.setString('roomId', 'qwerty');
      final ref = firestore.collection('rooms').doc('qwerty').collection('queue').doc(t1);

      expectLater(
        queueService.onQueue.map((snap) => snap.map((e) => e['votes'])),
        emitsInOrder([
          [1],
          [0]
        ]),
      );

      await ref.set({
        'uri': 'spotify:track:1',
        'created_at': '001',
        'voters': ['anonymous'],
        'votes': 1,
      });

      await queueService.unvote(t1);
    });

    test('invalid unvote', () async {
      await prefs.setString('roomId', 'qwerty');
      final ref = firestore.collection('rooms').doc('qwerty').collection('queue').doc(t1);

      expectLater(
        queueService.onQueue.map((snap) => snap.map((e) => e['votes'])),
        emitsInOrder([
          [1],
        ]),
      );

      await ref.set({
        'uri': 'spotify:track:1',
        'created_at': '001',
        'voters': ['anonymous'],
        'votes': 1,
      });

      await queueService.unvote(t2);
    });

    test('already unvoted', () async {
      await prefs.setString('roomId', 'qwerty');
      final ref = firestore.collection('rooms').doc('qwerty').collection('queue').doc(t1);

      expectLater(
        queueService.onQueue.map((snap) => snap.map((e) => e['votes'])),
        emitsInOrder([
          [1],
          [0],
        ]),
      );

      await ref.set({
        'uri': 'spotify:track:1',
        'created_at': '001',
        'voters': ['anonymous'],
        'votes': 1,
      });

      await queueService.unvote(t1);
      await queueService.unvote(t1);
    });

    group('vote unvote', () {
      const t1 = 'spotify:track:1';
      const t2 = 'spotify:track:2';

      test('sequence vuv', () async {
        await prefs.setString('roomId', 'qwerty');
        final ref = firestore.collection('rooms').doc('qwerty').collection('queue').doc(t1);

        expectLater(
          queueService.onQueue.map((snap) => snap.map((e) => e['votes'])),
          emitsInOrder([
            [0],
            [1],
            [0],
            [1],
          ]),
        );

        await ref.set({
          'uri': 'spotify:track:1',
          'created_at': '001',
          'voters': [],
          'votes': 0,
        });

        await queueService.vote(t1);
        await queueService.unvote(t1);
        await queueService.vote(t1);
        await queueService.unvote(t1);
      });

      test('sequence vVuvUVu', () async {
        await prefs.setString('roomId', 'qwerty');
        final ref = firestore.collection('rooms').doc('qwerty').collection('queue');

        expectLater(
          queueService.onQueue.map((snap) => snap.map((e) => e['votes'])),
          emitsInOrder([
            [0],
            [0, 0],
            [1, 0],
            [1, 1],
            [0, 1],
            [1, 1],
            [1, 0],
            [1, 1],
            [0, 1],
          ]),
        );

        await ref.doc(t1).set({
          'uri': t1,
          'created_at': '001',
          'voters': [],
          'votes': 0,
        });
        await ref.doc(t2).set({
          'uri': t2,
          'created_at': '002',
          'voters': [],
          'votes': 0,
        });

        await queueService.vote(t1);
        await queueService.vote(t2);
        await queueService.unvote(t1);
        await queueService.vote(t1);
        await queueService.unvote(t2);
        await queueService.vote(t2);
        await queueService.unvote(t1);
      });
    });

    group('skip:', () {
      test('valid skip', () async {});
      test('invalid skip', () async {});

      test('skip after unskip', () async {});
    });
  });
}
