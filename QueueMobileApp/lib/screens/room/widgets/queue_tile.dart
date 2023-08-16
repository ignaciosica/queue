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
            margin: EdgeInsets.zero,
            shadowColor: Colors.transparent,
            color: Colors.black,
            surfaceTintColor: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 4),
                  child: Text('Queue',
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                ),
                ...snapshot.data!.map((e) => TrackTile(e)),
              ],
            ),
          ),
        );
      },
    );
  }
}
