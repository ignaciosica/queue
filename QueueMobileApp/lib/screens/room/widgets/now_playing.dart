import 'package:flutter/material.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/services/queue_service.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({super.key});

  @override
  Widget build(BuildContext context) {
    final IQueueService queueService = getIt<IQueueService>();

    return StreamBuilder<dynamic>(
        stream: queueService.getPlayerState(),
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data.isEmpty) {
            return const NowPlayingDummy();
          }

          return SizedBox(
            height: 180,
            child: Card(
              shadowColor: Colors.transparent,
              child: Center(
                child: ListTile(
                  title: Text(snapshot.data['name']),
                  subtitle: Text((snapshot.data['artists'] as List).join(', ')),
                  trailing: Icon(Icons.skip_next),
                ),
              ),
            ),
          );
        });
  }
}

class NowPlayingDummy extends StatelessWidget {
  const NowPlayingDummy({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 180,
      child: Card(
        shadowColor: Colors.transparent,
        child: Center(
          child: ListTile(
            title: Text('Nothing playing right now'),
            subtitle: Text('Queue up some songs!'),
            trailing: Icon(Icons.skip_next),
          ),
        ),
      ),
    );
  }
}
