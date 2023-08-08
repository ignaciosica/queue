import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:queue/app/service_locator.dart';

import 'package:queue/services/queue_service.dart';

class SelectPlayerDrowpdown extends StatelessWidget {
  const SelectPlayerDrowpdown({super.key});

  @override
  Widget build(BuildContext context) {
    final IQueueService queueService = getIt<IQueueService>();
    final auth = FirebaseAuth.instance;

    return StreamBuilder(
      stream: queueService.onRoom,
      builder: (BuildContext context, AsyncSnapshot<dynamic> s1) {
        if (!s1.hasData) {
          return const SizedBox.shrink();
        }

        return IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                isDismissible: true,
                showDragHandle: true,
                builder: (BuildContext context) {
                  return StreamBuilder(
                      stream: queueService.onRoom,
                      builder: (BuildContext context, AsyncSnapshot<dynamic> s2) {
                        if (!s2.hasData) {
                          return const SizedBox.shrink();
                        }

                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ...s2.data['participants']
                                  .map<Widget>((e) => ListTile(
                                        leading: const CircleAvatar(),
                                        title: Text(e),
                                        selected: e == s2.data['player'],
                                        onTap: () {
                                          queueService.setPlayer(e);
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(9)),
                                      ))
                                  .toList(),
                            ],
                          ),
                        );
                      });
                },
              );
            },
            icon: Icon(
              Icons.speaker_group_rounded,
              color: auth.currentUser!.uid == s1.data['player']
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ));
      },
    );
  }
}
