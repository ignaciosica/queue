import 'package:flutter/material.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/services/spotify_service.dart';

class SearchTile extends StatelessWidget {
  const SearchTile({super.key});

  @override
  Widget build(BuildContext context) {
    ISpotifyService spotifyService = getIt<ISpotifyService>();

    return SearchAnchor.bar(
      barElevation: MaterialStateProperty.all(0),
      barBackgroundColor:
          MaterialStateProperty.all(Theme.of(context).colorScheme.secondaryContainer),
      suggestionsBuilder: (context, query) {
        return [
          FutureBuilder(
            future: spotifyService.search(query.text),
            initialData: [],
            builder: (context, snapshot) {
              return Column(
                children: [Text(snapshot.data.toString())],
              );
            },
          )
        ];
      },
    );
  }
}
