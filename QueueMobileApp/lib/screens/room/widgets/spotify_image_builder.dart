import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:queue/services/spotify_service.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:queue/app/service_locator.dart';

class SpotifyImageBuilder extends StatelessWidget {
  const SpotifyImageBuilder({Key? key, required this.uri}) : super(key: key);
  final String uri;

  static const url =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/A_black_image.jpg/640px-A_black_image.jpg';

  @override
  Widget build(BuildContext context) {
    ISpotifyService spotifyService = getIt<ISpotifyService>();

    return FutureBuilder(
      future: spotifyService.getTrack(uri),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          final provider = CachedNetworkImageProvider(snapshot.data['album']['images'][0]['url']);

          return FutureBuilder<PaletteGenerator>(
              future: PaletteGenerator.fromImageProvider(provider),
              builder: (context, snapshot) {
                final color = snapshot.data?.vibrantColor?.color ??
                    snapshot.data?.dominantColor?.color ??
                    Colors.black;

                return ClipRRect(
                  borderRadius: BorderRadius.circular(23),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                                colors: [color.withOpacity(0.2), color.withOpacity(0.4)],
                                radius: 1),
                          ),
                          position: DecorationPosition.foreground,
                          child: FadeInImage(
                            image: provider,
                            fit: BoxFit.fitWidth,
                            placeholder: const CachedNetworkImageProvider(url),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(colors: [
                              Colors.black38.withOpacity(0.1),
                              Colors.black38.withOpacity(0.3)
                            ], radius: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        } else if (snapshot.hasError) {
          return SizedBox(
            width: ImageDimension.large.value.toDouble(),
            height: ImageDimension.large.value.toDouble(),
            //child: const Center(child: Text('Error getting image')),
            child: Container(),
          );
        } else {
          return SizedBox(
            width: ImageDimension.large.value.toDouble(),
            height: ImageDimension.large.value.toDouble(),
          );
        }
      },
    );
  }
}
