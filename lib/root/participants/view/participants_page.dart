import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/common/common.dart';
import 'package:groupify/root/room/room.dart';

part 'participants_view.dart';

class ParticipantsPage extends StatelessWidget {
  const ParticipantsPage({Key? key, required this.roomCubit}) : super(key: key);

  final RoomCubit roomCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => roomCubit),
      ],
      child: const ParticipantsView(),
    );
  }
}
