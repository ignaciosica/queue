import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:queue/app/app_router.dart';
import 'package:queue/app/service_locator.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:workmanager/workmanager.dart';
import 'app/background_task.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAuth.instance.signInAnonymously();

  setupServiceLocator(FirebaseFirestore.instance, FirebaseAuth.instance);

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = appRouter();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightGreen,
          brightness: Brightness.dark,
          background: const ColorScheme.dark().background,
        ),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
