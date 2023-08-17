import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/app/widgets/gradient_app_bar.dart';
import 'package:queue/screens/room/widgets/next_up_tile.dart';
import 'package:queue/screens/room/widgets/now_playing_tile.dart';
import 'package:queue/screens/room/widgets/queue_tile.dart';
import 'package:queue/screens/room/widgets/search_tile.dart';
import 'package:queue/screens/room/widgets/start_player_button.dart';
import 'package:queue/services/room_service.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen(this.room, {super.key});
  final dynamic room;

  @override
  Widget build(BuildContext context) {
    final IRoomService roomService = getIt<IRoomService>();

    return Scaffold(
      appBar: GradientAppBar(
        title: const Text('Queue'),
        leading: IconButton(
          icon: const Icon(Icons.logout_rounded),
          onPressed: () async {
            await roomService.leaveRoom(room['id']).then((_) => context.go('/lobby'));
          },
        ),
      ),
      floatingActionButton: const SearchTile(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          children: const [
            SizedBox(height: 8),
            NowPlayingTile(),
            SizedBox(height: 4),
            StartPlayerButton(),
            SizedBox(height: 4),
            NextUpTile(),
            SizedBox(height: 8),
            QueueTile(),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
