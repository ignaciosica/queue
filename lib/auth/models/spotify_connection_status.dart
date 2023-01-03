import 'package:equatable/equatable.dart';
import 'package:spotify_sdk/models/connection_status.dart';

class SpotifyConnectionStatus extends Equatable {
  const SpotifyConnectionStatus({required this.connectionStatus});

  final ConnectionStatus? connectionStatus;

  static const empty = SpotifyConnectionStatus(connectionStatus: null);

  bool get isEmpty => this == SpotifyConnectionStatus.empty;

  bool get isNotEmpty => this != SpotifyConnectionStatus.empty;

  @override
  List<Object?> get props => [connectionStatus];
}
