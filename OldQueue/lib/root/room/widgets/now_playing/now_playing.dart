import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/auth/auth.dart';
import 'package:groupify/common/common.dart';
import 'package:groupify/root/room/room.dart';
import 'package:groupify/root/room/widgets/now_playing/play_pause_button.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

part 'now_playing_dummy.dart';

part 'now_playing_firestore.dart';

part 'now_playing_reconnect_dummy.dart';

part 'now_playing_wid.dart';

part 'skip_button.dart';

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
      child: StreamBuilder<DocumentSnapshot>(
          stream:
              RepositoryProvider.of<FirestoreRepository>(context).getRoom(BlocProvider.of<RoomCubit>(context).state.roomId),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              final room = Room.fromJson(snapshot.data!.data()!);

              // if (RepositoryProvider.of<AuthRepository>(context).currentUser.id == room.player) {
                return StreamBuilder<ConnectionStatus>(
                  stream: stream,
                  builder: (context, snapshot2) {
                    if (!snapshot2.hasError && snapshot2.hasData && snapshot2.data!.connected) {
                      return NowPlayingFirestore(room: room);
                    }
                    return const NowPlayingReconnectDummy();
                  },
                );
              // }
              // return NowPlayingFirestore(room: room);
            }
            return const NowPlayingDummy();
          }),
    );
  }
}
