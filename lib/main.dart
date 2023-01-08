import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupify/app/app.dart';
import 'package:groupify/auth/auth.dart';
import 'package:groupify/common/common.dart';
import 'package:groupify/firebase_options.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Native called background task: $task");

    for (var i = 0; i < 10; i++) {
      print("Native called background task: $i");
      await Future.delayed(Duration(seconds: 1));
      print(i);
    }

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    var snap = await FirebaseFirestore.instance
        .collection('rooms')
        .doc('23yvA5kACxSCtVJpfBGV')
        .collection('queue')
        .orderBy('created_at', descending: false)
        .get();

    snap.docs.forEach((element) {
      print(element.data());
    });

    await SpotifySdk.connectToSpotifyRemote(
      clientId: 'b9a4881e77f4488eb882788cb106a297',
      redirectUrl: 'https://com.example.groupify/callback/',
      accessToken: inputData!['accessToken'],
    );

    try {
      print('$task try-skip');
      await SpotifySdk.skipNext();
      print('$task skipped successfully');
    } catch (e) {
      print(e);
    }

    // Stream.periodic(const Duration(seconds: 10)).listen((_) {
    //   try {
    //     SpotifySdk.skipNext();
    //   } catch (e) {
    //     print(e);
    //   }
    // });

    print("End native called background task: $task");

    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  return BlocOverrides.runZoned(
    () async {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      final authenticationRepository = AuthRepository();
      await authenticationRepository.user.first;
      await authenticationRepository.connectToSpotify();
      final firestoreRepository = FirestoreRepository(authenticationRepository);
      await firestoreRepository.currentRoomAsync;
      Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

      runApp(App(authenticationRepository: authenticationRepository, firestoreRepository: firestoreRepository));
    },
  );
}
