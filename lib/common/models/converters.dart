import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class TimestampConverter extends JsonConverter<Timestamp, dynamic> {
  const TimestampConverter();

  @override
  fromJson(json) {
    return json as Timestamp;
  }

  @override
  toJson(object) {
    return Timestamp;
  }
}
