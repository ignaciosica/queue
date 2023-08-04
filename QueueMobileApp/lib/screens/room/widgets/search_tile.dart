import 'package:flutter/material.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/screens/room/widgets/track_tile.dart';
import 'package:queue/services/spotify_service.dart';
import 'package:queue/services/queue_service.dart';
import 'package:collection/collection.dart';

class SearchTile extends StatelessWidget {
  const SearchTile({super.key});

  @override
  Widget build(BuildContext context) {
    final IQueueService queueService = getIt<IQueueService>();
    ISpotifyService spotifyService = getIt<ISpotifyService>();

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: SearchAnchor.bar(
          barElevation: MaterialStateProperty.all(0),
          barBackgroundColor:
              MaterialStateProperty.all(Theme.of(context).colorScheme.secondaryContainer),
          suggestionsBuilder: (context, query) {
            return [
              StreamBuilder(
                stream: queueService.onQueue,
                initialData: const [],
                builder: (context, queueSnap) {
                  return FutureBuilder<List>(
                    future: spotifyService.search(query.text),
                    initialData: const [],
                    builder: (context, searchSnap) {
                      if (queueSnap.data == null || searchSnap.data == null) return Container();
                      final tracks = searchSnap.data!.map((e) {
                        var trackInQueue =
                            queueSnap.data!.firstWhereOrNull((t) => t['uri'] == e['uri']);
                        if (trackInQueue != null) {
                          return trackInQueue;
                        } else {
                          return {
                            'uri': e['uri'],
                            'votes': 0,
                            'voters': [],
                            'isInQueue': false,
                            'song': {
                              'name': e['name'],
                              'artists': e['artists'],
                              'album': e['album'],
                            },
                          };
                        }
                      });

                      return Column(
                        children: [...tracks.map((e) => TrackTile(e))],
                      );
                    },
                  );
                },
              )
            ];
          },
        ));
  }
}
