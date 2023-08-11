import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (kDebugMode) print('secon:${dotenv.maybeGet('SPOTIFY_CLIENT_ID')}');
    if (kDebugMode) print('redirect:${dotenv.maybeGet('SPOTIFY_REDIRECT_URI')}');

    return Future.value(true);
  });
}
