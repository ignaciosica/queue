import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/common/common.dart';
import 'package:flutter/services.dart';


class RoomTitle extends StatelessWidget {
  const RoomTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: RepositoryProvider.of<FirestoreRepository>(context).getRoom(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading room");
          }
          var roomDocument = snapshot.data;
          return GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: snapshot.data!.id.substring(0, 5))).then((_){
                //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Room code copied to clipboard")));
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  roomDocument!["name"],
                  style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                ),
                Text(
                  '  #${snapshot.data!.id.substring(0, 5)}',
                  style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        });
  }
}
