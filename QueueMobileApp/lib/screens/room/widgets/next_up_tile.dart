import 'package:flutter/material.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/screens/room/widgets/track_tile.dart';
import 'package:queue/services/queue_service.dart';

class NextUpTile extends StatelessWidget {
  const NextUpTile({super.key});

  @override
  Widget build(BuildContext context) {
    final IQueueService queueService = getIt<IQueueService>();
    return StreamBuilder(
      stream: queueService.onHead,
      initialData: const [],
      builder: (context, snapshot) {
        if (snapshot.data == null) return const SizedBox.shrink();
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
                  child: Text('Next up',
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                ),
                TrackTile(snapshot.data),
              ],
            ),
          ),
        );
      },
    );
  }
}
