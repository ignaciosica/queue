import 'package:equatable/equatable.dart';

class SpotifyUserStatus extends Equatable {
  const SpotifyUserStatus({required this.logged});

  final bool logged;

  static const empty = SpotifyUserStatus(logged: false);

  bool get isEmpty => this == SpotifyUserStatus.empty;

  bool get isNotEmpty => this != SpotifyUserStatus.empty;

  @override
  List<Object?> get props => [logged];
}
