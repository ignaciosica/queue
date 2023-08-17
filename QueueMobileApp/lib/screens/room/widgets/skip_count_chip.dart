import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/app/widgets/expanded_section.dart';
import 'package:queue/services/queue_service.dart';

class SkipCountChip extends StatelessWidget {
  const SkipCountChip({super.key});

  @override
  Widget build(BuildContext context) {
    final IQueueService queueService = getIt<IQueueService>();

    return StreamBuilder(
      stream: queueService.onRoom,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final room = snapshot.data as Map?;
        final uid = FirebaseAuth.instance.currentUser!.uid;

        return ExpandedSection(
          expand: room?['skip'].contains(uid) ?? false,
          child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ActionChip(
              shadowColor: Colors.transparent,
              visualDensity: VisualDensity.compact,
              onPressed: () {
                queueService.unSkip();
              },
              label: Text(
                  '${room?['skip'].length.toString()}/${(room?['participants'].length ~/ 2)}' ??
                      '0'),
              avatar: const Icon(Icons.groups_2_rounded),
            ),
          ),
        );
      },
    );
  }
}
