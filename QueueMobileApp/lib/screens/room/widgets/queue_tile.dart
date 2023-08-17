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
                  child: SizedBox(
                    height: 40,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Queue',
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                              )),
                    ),
                  ),
                ),
                if (snapshot.data?.isNotEmpty ?? false) ...snapshot.data!.map((e) => TrackTile(e)),
                if (snapshot.data?.isEmpty ?? true)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'No tracks in queue',
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
