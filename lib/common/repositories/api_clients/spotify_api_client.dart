import 'dart:convert';

import 'package:groupify/common/common.dart';
import 'package:groupify/common/repositories/api_clients/base_api_client.dart';

class SpotifyApiClient extends BaseApiClient {
  SpotifyApiClient(super.authRepository);

  Future<void> removeUserSavedTracks(String trackIds) async {
    const path = '/v1/me/tracks';
    final uri = Uri(scheme: baseScheme, host: baseHost, path: path, queryParameters: {'ids': trackIds});

    final response = await httpClient.delete(uri, headers: await getAuthHeaders());

    assessQueryResponse(response);
  }

  Future<void> addUserSavedTracks(String trackIds) async {
    const path = '/v1/me/tracks';
    final uri = Uri(scheme: baseScheme, host: baseHost, path: path, queryParameters: {'ids': trackIds});

    final response = await httpClient.put(uri, headers: await getAuthHeaders());

    assessQueryResponse(response);
  }

  Future<List> checkUserSavedTracks(String trackIds) async {
    const path = '/v1/me/tracks/contains';
    final uri = Uri(scheme: baseScheme, host: baseHost, path: path, queryParameters: {'ids': trackIds});

    final response = await httpClient.get(uri, headers: await getAuthHeaders());

    assessQueryResponse(response);

    final List list = json.decode(response.body);

    return list;
  }

  SpotifyTrack? tryGetTrack(String trackId) {
    return cache.read<SpotifyTrack>(key: trackId);
  }

  Future<SpotifyTrack> getTrack(String trackId) async {
    final cachedTrack = cache.read<SpotifyTrack>(key: trackId);
    if (cachedTrack != null) return cachedTrack;
    final path = '/v1/tracks/$trackId';
    final uri = Uri(scheme: baseScheme, host: baseHost, path: path);

    final response = await httpClient.get(uri, headers: await getAuthHeaders());

    assessQueryResponse(response);

    final SpotifyTrack track = SpotifyTrack.fromJson(json.decode(response.body));
    cache.write<SpotifyTrack>(key: trackId, value: track);

    return track;
  }
}
