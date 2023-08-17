import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:queue/app/cache_client.dart';

abstract class ISpotifyService {
  Future<List> search(String query);
  Future<dynamic> getTrack(String id);
}

class SpotifyService implements ISpotifyService {
  SpotifyService();

  final String baseScheme = 'https';
  final String baseHost = 'api.spotify.com';
  final Client httpClient = Client();
  final CacheClient cacheClient = CacheClient();

  static const tokenCacheKey = '__spotify_access_token_cache_key__';
  static const queryCacheKey = '__query_cache_key__';

  @override
  Future<List> search(String query) async {
    if (query.isEmpty) return List.empty();
    var tracks = cacheClient.read<List>(key: query + queryCacheKey);
    if (tracks != null) return tracks;

    const path = '/v1/search';
    final uri = Uri(scheme: baseScheme, host: baseHost, path: path, query: 'q=$query&type=track');

    final response = await httpClient.get(uri, headers: await getAuthHeaders());

    final json = jsonDecode(response.body);
    final List<dynamic> items = json['tracks']['items'];

    cacheClient.write<List>(key: query + queryCacheKey, value: items);

    return items;
  }

  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getAccessToken();

    return {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
  }

  Future<String> getAccessToken() async {
    var accessToken = cacheClient.read<AccessToken>(key: tokenCacheKey) ?? AccessToken.empty;
    if (accessToken.isEmpty || accessToken.isExpired) {
      accessToken = await requestAccessToken();
      cacheClient.write<AccessToken>(key: tokenCacheKey, value: accessToken);
    }

    return accessToken.accessToken;
  }

  Future<AccessToken> requestAccessToken() async {
    final clientId = dotenv.env['SPOTIFY_CLIENT_ID'];
    final clientSecret = dotenv.env['SPOTIFY_CLIENT_SECRET'];

    String credentials = "$clientId:$clientSecret";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);

    var headers = {
      'Authorization': 'Basic $encoded',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var request = Request('POST', Uri.parse('https://accounts.spotify.com/api/token'));
    request.bodyFields = {'grant_type': 'client_credentials'};
    request.headers.addAll(headers);

    StreamedResponse streamedResponse = await request.send();

    final response = await Response.fromStream(streamedResponse);
    final bodyJson = jsonDecode(response.body);

    return AccessToken(accessToken: bodyJson['access_token'], issuedAt: DateTime.now());
  }

  @override
  Future<dynamic> getTrack(String id) async {
    if (id.isEmpty) return null;
    var track = cacheClient.read<Map>(key: id + queryCacheKey);
    if (track != null) return track;

    final path = '/v1/tracks/${id.substring(id.lastIndexOf(":") + 1)}';
    final uri = Uri(scheme: baseScheme, host: baseHost, path: path);

    final response = await httpClient.get(uri, headers: await getAuthHeaders());

    final json = jsonDecode(response.body);

    cacheClient.write<Map>(key: id + queryCacheKey, value: json);

    return json;
  }
}

class AccessToken extends Equatable {
  const AccessToken({required this.accessToken, required this.issuedAt, this.expiresIn = 3600});

  final String accessToken;
  final DateTime issuedAt;
  final int expiresIn;

  static final empty = AccessToken(accessToken: '', issuedAt: DateTime(0));

  bool get isEmpty => accessToken.isEmpty;

  bool get isNotEmpty => accessToken.isNotEmpty;

  bool get isExpired => issuedAt.add(Duration(seconds: expiresIn)).isBefore(DateTime.now());

  @override
  List<Object?> get props => [accessToken];
}
