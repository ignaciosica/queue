// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC5hfQkLY72q_pr3TI1RcAhQqTGsWyShjo',
    appId: '1:115607063090:web:4b70d48d81e2b71a644a2b',
    messagingSenderId: '115607063090',
    projectId: 'groupify-796f3',
    authDomain: 'groupify-796f3.firebaseapp.com',
    storageBucket: 'groupify-796f3.appspot.com',
    measurementId: 'G-31MD6YQ2Y1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBysQOOeTyPHEhBbIATrQOkZ4Rkd5EOwEY',
    appId: '1:115607063090:android:e3c8558fef9d3721644a2b',
    messagingSenderId: '115607063090',
    projectId: 'groupify-796f3',
    storageBucket: 'groupify-796f3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyADoDVtZ9wqU7cI0fXDprdV-9XMepEBaEk',
    appId: '1:115607063090:ios:9ea6f8d22a528e99644a2b',
    messagingSenderId: '115607063090',
    projectId: 'groupify-796f3',
    storageBucket: 'groupify-796f3.appspot.com',
    iosClientId: '115607063090-cas2s5qg09fhcu3q728mtjot5smiopd5.apps.googleusercontent.com',
    iosBundleId: 'com.example.groupify',
  );
}