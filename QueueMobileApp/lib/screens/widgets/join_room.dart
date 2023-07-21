import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/services/room_service.dart';

class JoinRoom extends StatefulWidget {
  const JoinRoom({super.key});

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  late final TextEditingController textEditingController;

  final IRoomService _roomService = getIt<IRoomService>();

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
            key: const Key('join_room_textfield_key'),
            controller: textEditingController),
        ElevatedButton(
          key: const Key('join_room_button_key'),
          onPressed: () {
            _roomService.joinRoom(textEditingController.text).then((value) {
              if (value != null) {
                if (kDebugMode) print('pushing to /room with extra: $value');
                context.push('/room', extra: value);
              } else {
                if (kDebugMode) print('invalid room, no navigation');
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid room id')));
              }
            });
          },
          child: const Text('Join Room'),
        ),
      ],
    );
  }
}
