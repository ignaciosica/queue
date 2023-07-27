import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:queue/app/cache_client.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

abstract class ISpotifyService {
  Future search(String query);
}

class SpotifyService implements ISpotifyService {
  SpotifyService();

  final String baseScheme = 'https';
  final String baseHost = 'api.spotify.com';
  final Client httpClient = Client();
  final CacheClient cacheClient = CacheClient();

  Future search(String query) async {
    const path = '/v1/search';
    final uri = Uri(scheme: baseScheme, host: baseHost, path: path, query: 'q=$query&type=track');

    final response = await httpClient.get(uri, headers: await getAuthHeaders());

    final json = jsonDecode(response.body);
    final List<dynamic> items = json['tracks']['items'];

    return Future.value(items);
  }

  Future<Map<String, String>> getAuthHeaders() async {
    var token = cacheClient.read(key: 'spotify_access_token');

    if (token == null) {
      token = await SpotifySdk.getAccessToken(
          clientId: dotenv.env['SPOTIFY_CLIENT_ID']!,
          redirectUrl: 'https://com.example.queue/callback/');

      cacheClient.write(key: 'spotify_access_token', value: token);
    }

    return {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
  }
}
