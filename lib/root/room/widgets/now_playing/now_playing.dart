import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/auth/auth.dart';
import 'package:groupify/common/common.dart';
import 'package:groupify/root/cubit/spotify_player_cubit.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

part 'now_playing_dummy.dart';
part 'now_playing_reconnect_dummy.dart';
part 'now_playing_wid.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({Key? key}) : super(key: key);

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  final Stream<ConnectionStatus> stream = SpotifySdk.subscribeConnectionStatus();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: StreamBuilder<ConnectionStatus>(
        stream: stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.done:
              return const NowPlayingReconnectDummy();
            case ConnectionState.waiting:
              return const NowPlayingDummy();
            case ConnectionState.active:
              if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.connected) {
                return const NowPlayingReconnectDummy();
              }

              return const NowPlayingWid();
          }
        },
      ),
    );
  }
}
