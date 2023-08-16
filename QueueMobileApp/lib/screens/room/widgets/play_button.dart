import 'package:flutter/material.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/services/queue_service.dart';

import 'custom_animated_icon.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({super.key});

  @override
  Widget build(BuildContext context) {
    final IQueueService queueService = getIt<IQueueService>();
    return StreamBuilder(
        stream: queueService.onRoom,
        builder: (context, snapshot) {
          final room = snapshot.data as Map?;
          final isPaused = room?['player_state']?['is_paused'] ?? true;

          return IconButton.filledTonal(
            onPressed: () {},
            icon: CustomAnimatedIcon(
              iconB: const Icon(Icons.play_arrow_rounded, key: ValueKey('play')),
              iconA: const Icon(Icons.pause_rounded, key: ValueKey('pause')),
              showA: isPaused,
            ),
          );
        });
  }
}
