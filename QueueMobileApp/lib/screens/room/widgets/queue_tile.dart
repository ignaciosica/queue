import 'package:flutter/material.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/screens/room/widgets/track_tile.dart';
import 'package:queue/services/queue_service.dart';

class QueueTile extends StatelessWidget {
  const QueueTile({super.key});

  @override
  Widget build(BuildContext context) {
    final IQueueService queueService = getIt<IQueueService>();
    return StreamBuilder<List>(
      stream: queueService.onQueue,
      initialData: const [],
      builder: (context, snapshot) {
        return SizedBox(
          width: double.infinity,
          child: Card(
            shadowColor: Colors.transparent,
            child: Column(
              children: [
                const Text('Queue'),
                ...snapshot.data! /*.sortedBy<num>((e) => -e['votes'])*/ .map((e) => TrackTile(e)),
              ],
            ),
          ),
        );
      },
    );
  }
}
