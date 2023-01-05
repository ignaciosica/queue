import 'dart:convert';

import 'package:flutter/foundation.dart';

class JsonEncodeException implements Exception {
  JsonEncodeException(this.obj, {this.message, this.innerException});

  dynamic obj;
  String? message;
  Exception? innerException;
}

class BaseRepositoryFailure implements Exception {
  BaseRepositoryFailure(this.message, {this.innerException});

  final String message;
  final Exception? innerException;
}

class BaseRepository {
  @protected
  String tryJsonEncode(dynamic obj) {
    try {
      return jsonEncode(obj);
    } on Exception catch (e) {
      if (kDebugMode) print(e);

      throw JsonEncodeException(obj, innerException: e, message: 'Could not encode ${obj.runtimeType}');
    }
  }
}
