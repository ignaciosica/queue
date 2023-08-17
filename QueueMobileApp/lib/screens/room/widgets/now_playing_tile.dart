import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/screens/room/widgets/play_button.dart';
import 'package:queue/screens/room/widgets/select_player_dropdown.dart';
import 'package:queue/screens/room/widgets/spotify_image_builder.dart';
import 'package:queue/services/queue_service.dart';

class NowPlayingTile extends StatelessWidget {
  const NowPlayingTile({super.key});

  @override
  Widget build(BuildContext context) {
    final IQueueService queueService = getIt<IQueueService>();

    return StreamBuilder<dynamic>(
        stream: queueService.onRoom,
        builder: (context, snapshot) {
          final room = snapshot.data as Map?;
          final playerState = room?['player_state'] as Map?;
          final uid = FirebaseAuth.instance.currentUser!.uid;

          if (kDebugMode) print('image_uri: ${playerState?['image_uri']}');

          return SizedBox(
            height: 180,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
              margin: EdgeInsets.zero,
              shadowColor: Colors.transparent,
              child: Stack(
                children: [
                  if (playerState?['uri'] != null) SpotifyImageBuilder(uri: playerState?['uri']),
                  Padding(
                    padding: const EdgeInsets.only(right: 8, left: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                playerState?['name'] ?? 'No song playing',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ((playerState?['artists'] ?? []) as List).join(', '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SelectPlayerDrowpdown(),
                            const PlayPauseButton(),
                            IconButton.filledTonal(
                                onPressed: () {
                                  room?['skip'].contains(uid)
                                      ? queueService.unSkip()
                                      : queueService.skip();
                                },
                                icon: const Icon(
                                  Icons.skip_next_rounded,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

/*
ExpandedSection(
                              expand: room?['skip'].contains(uid) ?? false,
                              child: ActionChip(
                                onPressed: () {
                                  queueService.unSkip();
                                },
                                label: Text(
                                    '${room?['skip'].length.toString()}/${(room?['participants'].length ~/ 2)}' ??
                                        '0'),
                                avatar: const Icon(Icons.groups_2_rounded),
                              ),
                            ),
*/
