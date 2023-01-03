import 'package:equatable/equatable.dart';

class SpotifyAccessToken extends Equatable {
  const SpotifyAccessToken({required this.accessToken, required this.issuedAt, this.expiresIn = 3600});

  final String accessToken;
  final DateTime issuedAt;
  final int expiresIn;

  static final empty = SpotifyAccessToken(accessToken: '', issuedAt: DateTime(0));

  bool get isEmpty => accessToken.isEmpty;
  bool get isNotEmpty => accessToken.isNotEmpty;
  bool get isExpired => issuedAt.add(Duration(seconds: expiresIn)).isAfter(DateTime.now());

  @override
  List<Object?> get props => [accessToken];
}
