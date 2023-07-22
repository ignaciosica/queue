import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/services/room_service.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({super.key});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
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
            key: const Key('create_room_textfield_key'),
            controller: textEditingController),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              key: const Key('create_room_button_key'),
              onPressed: () {
                _roomService
                    .createRoom(textEditingController.text)
                    .then((value) {
                  if (value != null) {
                    if (kDebugMode)
                      print('pushing to /room with extra: $value');
                    context.push('/room', extra: value);
                  } else {
                    if (kDebugMode) print('creation failed, no navigation');
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('creation failed')));
                  }
                });
              },
              child: const Text('Create Room'),
            ),
            if (FirebaseAuth.instance.currentUser?.isAnonymous ?? true) ...[
              const SizedBox(width: 16),
              ElevatedButton(
                  onPressed: () => context.push('/sign-in'),
                  child: const Text('Sign in'))
            ]
          ],
        ),
      ],
    );
  }
}
