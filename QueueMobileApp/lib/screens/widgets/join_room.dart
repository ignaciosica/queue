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

  final RoomService _roomService = getIt<RoomService>();

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(controller: textEditingController),
        ElevatedButton(
          onPressed: () {
            _roomService.joinRoom(textEditingController.text).then((value) => {
                  if (value != null)
                    {
                      context.push('/room', extra: value),
                    }
                  else
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid room id'),
                        ),
                      ),
                    }
                });
          },
          child: const Text('Join Room'),
        ),
      ],
    );
  }
}
