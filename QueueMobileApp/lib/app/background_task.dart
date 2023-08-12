import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:queue/firebase_options.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (kDebugMode) print('taskName:$taskName');

    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    final clientId = dotenv.get('SPOTIFY_CLIENT_ID');
    final redirectUrl = dotenv.get('SPOTIFY_REDIRECT_URI');

    if (kDebugMode) print('clientId:$clientId');
    if (kDebugMode) print('redirect:$redirectUrl');

    final connection =
        await SpotifySdk.connectToSpotifyRemote(clientId: clientId, redirectUrl: redirectUrl);

    SpotifySdk.pause();

    await Future.delayed(const Duration(seconds: 2));

    SpotifySdk.resume();

    if (kDebugMode) print('connection:${connection.toString()}');

    return Future.value(true);
  });
}
