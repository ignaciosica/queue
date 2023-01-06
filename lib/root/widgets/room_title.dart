import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/root/cubit/root_cubit.dart';

class RoomTitle extends StatelessWidget {
  const RoomTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rootCubit = BlocProvider.of<RootCubit>(context);

    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('rooms').doc(rootCubit.state.readProperty<String>('room_id')).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading room");
          }
          var roomDocument = snapshot.data;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '#${snapshot.data!.id.substring(0, 5)}',
                style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 14),
              ),
              Text(
                roomDocument!["name"],
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
              ),
            ],
          );
        });
  }
}
