import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queue/services/spotify_service.dart';

void main() async {
  late ISpotifyService spotifyService;

  setUp(() async {
    await dotenv.load(fileName: '.env');
    spotifyService = SpotifyService();
  });

  group('search', () {
    test('should return a list of tracks', () async {
      final tracks = await spotifyService.search('test');
      expect(tracks, isA<List>());
    });
  });
}
