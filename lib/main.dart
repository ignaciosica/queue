import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:groupify/app/app.dart';
import 'package:groupify/auth/auth.dart';
import 'package:groupify/background_task.dart';
import 'package:groupify/common/common.dart';
import 'package:groupify/firebase_options.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:workmanager/workmanager.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  return BlocOverrides.runZoned(
    () async {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      await dotenv.load(fileName: '.env');
      HydratedBloc.storage = await HydratedStorage.build(storageDirectory: await getApplicationDocumentsDirectory());
      final authenticationRepository = AuthRepository();
      await authenticationRepository.user.first;
      await authenticationRepository.connectToSpotify();
      final firestoreRepository = FirestoreRepository(authenticationRepository);
      Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
      Workmanager().cancelAll();

      RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
      Isolate.spawn(_isolateMain, rootIsolateToken);

      runApp(App(authenticationRepository: authenticationRepository, firestoreRepository: firestoreRepository));
    },
  );
}

void _isolateMain(RootIsolateToken rootIsolateToken) async {
  // Register the background isolate with the root isolate.
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await SpotifySdk.connectToSpotifyRemote(clientId: 'b9a4881e77f4488eb882788cb106a297', redirectUrl: 'https://com.example.groupify/callback/');
  } catch (e) {
    print(e);
  }

  int a = 0;

  while(true){
    await Future.delayed(const Duration(seconds: 1));
    print(a++);
    SpotifySdk.getPlayerState().then((value) => (value?.isPaused ?? false )? SpotifySdk.resume() : SpotifySdk.pause());
  }

  // You can now use the shared_preferences plugin.
  // SharedPreferences sharedPreferences =
  // await SharedPreferences.getInstance();
  // print(sharedPreferences.getBool(‘isDebug’));
}
