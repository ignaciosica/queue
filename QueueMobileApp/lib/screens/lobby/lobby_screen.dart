import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/app/widgets/gradient_app_bar.dart';
import 'package:queue/screens/lobby/widgets/lobby_form.dart';
import 'package:queue/services/room_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final IRoomService _roomService = getIt<IRoomService>();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey('roomId')) {
        assert(prefs.getString('roomId') != null);

        _roomService
            .joinRoom(prefs.getString('roomId') ?? 'invalid')
            .then(goToRoom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: const Text('Queue')),
      body: Column(
        children: [
          LobbyForm(
            'Join Room',
            (val) => _roomService.joinRoom(val).then(goToRoom),
            key: const Key('join_room'),
          ),
          LobbyForm(
            'Create Room',
            (val) => _roomService.createRoom(val).then(goToRoom),
            key: const Key('create_room'),
          ),
        ],
      ),
    );
  }

  void goToRoom(room) {
    if (room != null) {
      if (kDebugMode) print('pushing to /room with extra: $room');
      context.pushReplacement('/room', extra: room);
    } else {
      if (kDebugMode) print('invalid room, no navigation');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Invalid room id')));
    }
  }
}
