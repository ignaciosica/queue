import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/app/widgets/expanded_section.dart';
import 'package:queue/screens/room/widgets/select_player_dropdown.dart';
import 'package:queue/screens/room/widgets/start_player_button.dart';
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

          // if (room == null || room.isEmpty || playerState == null || playerState.isEmpty) {
          //   return const NowPlayingTileDummy();
          // }

          return SizedBox(
            height: 180,
            child: Card(
              shadowColor: Colors.transparent,
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListTile(
                            title: Text(playerState?['name'] ?? 'No song playing'),
                            subtitle: Text(((playerState?['artists'] ?? []) as List).join(', ')),
                          ),
                          StartPlayerButton(),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SelectPlayerDrowpdown(),
                        IconButton(
                            onPressed: () {
                              room?['skip'].contains(uid)
                                  ? queueService.unSkip()
                                  : queueService.skip();
                            },
                            icon: const Icon(Icons.skip_next_rounded)),
                        ExpandedSection(
                          expand: room?['skip'].contains(uid),
                          child: Text(room?['skip'].length.toString() ?? '0'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
