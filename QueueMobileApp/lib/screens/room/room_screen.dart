import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/app/widgets/gradient_app_bar.dart';
import 'package:queue/screens/room/widgets/now_playing_tile.dart';
import 'package:queue/screens/room/widgets/queue_tile.dart';
import 'package:queue/screens/room/widgets/search_tile.dart';
import 'package:queue/services/room_service.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen(this.room, {super.key});
  final dynamic room;

  @override
  Widget build(BuildContext context) {
    final IRoomService roomService = getIt<IRoomService>();

    return Scaffold(
      appBar: GradientAppBar(
        title: Text(room['name']),
        leading: IconButton(
          icon: const Icon(Icons.logout_rounded),
          onPressed: () async {
            await roomService.leaveRoom(room['id']).then((_) => context.go('/lobby'));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.speaker_rounded),
            onPressed: () => context.push('/speaker'),
          ),
          //profile button
        ],
      ),
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            NowPlayingTile(),
            SearchTile(),
            QueueTile(),
          ],
        ),
      ),
    );
  }
}
