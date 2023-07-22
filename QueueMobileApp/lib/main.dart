import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:queue/app/app_router.dart';
import 'package:queue/app/service_locator.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupServiceLocator(FirebaseFirestore.instance, FirebaseAuth.instance);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      routerConfig: appRouter(),
    );
  }
}
