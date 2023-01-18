import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/auth/auth.dart';
import 'package:groupify/common/common.dart';
import 'package:groupify/root/participants/participants.dart';
import 'package:groupify/root/root.dart';
import 'package:groupify/root/search/search.dart';

part 'room_view.dart';

class RoomPage extends StatelessWidget {
  const RoomPage({Key? key, required this.roomCubit}) : super(key: key);

  static Route route(RoomCubit roomCubit) => MaterialPageRoute<void>(builder: (_) => RoomPage(roomCubit: roomCubit));

  static Page page(RoomCubit roomCubit) => MaterialPage<void>(child: RoomPage(roomCubit: roomCubit));

  final RoomCubit roomCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => SpotifyPlayerCubit()),
        BlocProvider<RoomCubit>(create: (BuildContext context) => roomCubit),
      ],
      child: const RoomView(title: 'Groupify'),
    );
  }
}
