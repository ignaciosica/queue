import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cache/cache.dart';
import 'package:flutter/foundation.dart';
import 'package:groupify/auth/auth.dart';
import 'package:http/http.dart' as http;

class BaseApiClientFailure implements Exception {
  BaseApiClientFailure(this.responseBody, this.responseStatus, {this.message, this.requestParams, this.response});

  BaseApiClientFailure.fromResponse(http.Response this.response)
      : responseBody = response.body,
        responseStatus = response.statusCode;

  String? message;
  String? requestParams;
  http.Response? response;

  String responseBody;
  int responseStatus;
}

class QueryFailure extends BaseApiClientFailure {
  QueryFailure(super.responseBody, super.responseStatus);

  QueryFailure.fromResponse(super.response) : super.fromResponse();
}

class CommandFailure extends BaseApiClientFailure {
  CommandFailure(super.responseBody, super.responseStatus);

  CommandFailure.fromResponse(super.response) : super.fromResponse();
}

class InternalServerFailure extends BaseApiClientFailure {
  InternalServerFailure(super.responseBody, super.responseStatus);

  InternalServerFailure.fromResponse(super.response) : super.fromResponse();
}

class BaseApiClient {
  @protected
  BaseApiClient(
    this.authRepository, {
    http.Client? httpClient,
    CacheClient? cache,
  })  : httpClient = httpClient ?? http.Client(),
        cache = cache ?? CacheClient();

  @protected
  final http.Client httpClient;
  @protected
  final CacheClient cache;
  @protected
  final AuthRepository authRepository;

  @protected
  final String baseScheme = 'https';
  @protected
  final String baseHost = 'api.spotify.com';
  @protected
  static const spotifyAccessTokenCacheKey = '__spotify_access_token_cache_key__';

  @protected
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getAccessToken();

    return {HttpHeaders.authorizationHeader: 'Bearer $token', HttpHeaders.contentTypeHeader: 'application/json'};
  }

  Future<String> getAccessToken() async {
    var spotifyAccessToken = cache.read<SpotifyAccessToken>(key: spotifyAccessTokenCacheKey) ?? SpotifyAccessToken.empty;
    if (spotifyAccessToken.isEmpty || spotifyAccessToken.isExpired) {
      spotifyAccessToken = await requestAccessToken();
      cache.write<SpotifyAccessToken>(key: spotifyAccessTokenCacheKey, value: spotifyAccessToken);
    }

    return spotifyAccessToken.accessToken;
  }

  Future<SpotifyAccessToken> requestAccessToken() async {
    var headers = {
      'Authorization': 'Basic YjlhNDg4MWU3N2Y0NDg4ZWI4ODI3ODhjYjEwNmEyOTc6ODJkNmEzMTZjMTA4NDViZDgyZGYxMDU0NTgyMzM4OWU=',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    var request = http.Request('POST', Uri.parse('https://accounts.spotify.com/api/token'));
    request.bodyFields = {'grant_type': 'client_credentials'};
    request.headers.addAll(headers);

    http.StreamedResponse streamedResponse = await request.send();

    if (streamedResponse.statusCode != 200) {
      if (kDebugMode) {
        print(streamedResponse.reasonPhrase);
      }
    }

    final response = await http.Response.fromStream(streamedResponse);
    final bodyJson = jsonDecode(response.body);

    return SpotifyAccessToken(accessToken: bodyJson['access_token'], issuedAt: DateTime.now());
  }

  @protected
  void assessQueryResponse(http.Response response) {
    // ignore: avoid_print
    if (response.statusCode != 200 && kDebugMode) print(response.toString());

    if (response.statusCode == 500) {
      throw InternalServerFailure.fromResponse(response);
    }

    if (response.statusCode != 200) {
      throw QueryFailure.fromResponse(response);
    }
  }

  @protected
  void assessCommandResponse(http.Response response) {
    // ignore: avoid_print
    if (response.statusCode != 200 && kDebugMode) print(response.toString());

    if (response.statusCode == 500) {
      throw InternalServerFailure.fromResponse(response);
    }

    if (response.statusCode != 200) {
      throw CommandFailure.fromResponse(response);
    }
  }
}
