import 'package:groupify/auth/auth.dart';
import 'package:groupify/common/common.dart';
import 'package:groupify/common/repositories/api_clients/spotify_api_client.dart';
import 'package:groupify/common/repositories/base_repository.dart';

class SpotifyRepository extends BaseRepository {
  SpotifyRepository(AuthRepository tokenRepository) : _spotifyApiClient = SpotifyApiClient(tokenRepository);

  final SpotifyApiClient _spotifyApiClient;

  Future<void> removeUserSavedTracks(List<String> trackIds) async {
    await _spotifyApiClient.removeUserSavedTracks(trackIds.map((e) => e.split(':').last).join(","));
  }

  Future<void> addUserSavedTracks(List<String> trackIds) async {
    await _spotifyApiClient.addUserSavedTracks(trackIds.map((e) => e.split(':').last).join(","));
  }

  Future<List<bool>> checkUserSavedTracks(List<String> trackIds) async {
    final list = await _spotifyApiClient.checkUserSavedTracks(trackIds.map((e) => e.split(':').last).join(","));

    return list.cast<bool>();
  }

  SpotifyTrack? tryGetTrack(String trackId) {
    return _spotifyApiClient.tryGetTrack(trackId.split(':').last);
  }

  Future<SpotifyTrack> getTrack(String trackId) async {
    final track = await _spotifyApiClient.getTrack(trackId.split(':').last);

    return track;
  }
}
