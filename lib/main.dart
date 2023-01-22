import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:groupify/app/app.dart';
import 'package:groupify/auth/auth.dart';
import 'package:groupify/background_task.dart';
import 'package:groupify/common/common.dart';
import 'package:groupify/firebase_options.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
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

      runApp(App(authenticationRepository: authenticationRepository, firestoreRepository: firestoreRepository));
    },
  );
}
