import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/auth/auth.dart';
import 'package:groupify/common/common.dart';
import 'package:groupify/root/participants/participants.dart';
import 'package:groupify/root/root.dart';
import 'package:groupify/root/search/search.dart';
import 'package:workmanager/workmanager.dart';

part 'room_view.dart';

class RoomPage extends StatelessWidget {
  const RoomPage({Key? key, required this.roomId}) : super(key: key);

  static Route route(String roomId) => MaterialPageRoute<void>(builder: (_) => RoomPage(roomId: roomId));

  static Page page(String roomId) => MaterialPage<void>(child: RoomPage(roomId: roomId));

  final String roomId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => SpotifyPlayerCubit()),
        BlocProvider(create: (BuildContext context) => RoomCubit(roomId)),
      ],
      child: const RoomView(title: 'Groupify'),
    );
  }
}
