import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SpotifyImageBuilder extends StatefulWidget {
  const SpotifyImageBuilder({Key? key, required this.imageUri}) : super(key: key);
  final ImageUri imageUri;

  @override
  State<SpotifyImageBuilder> createState() => _SpotifyImageBuilderState();
}

class _SpotifyImageBuilderState extends State<SpotifyImageBuilder> {
  static const url =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/A_black_image.jpg/640px-A_black_image.jpg';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SpotifySdk.getImage(imageUri: widget.imageUri, dimension: ImageDimension.large),
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        if (kDebugMode) print('snapshot:$snapshot');
        if (snapshot.hasData) {
          final provider = MemoryImage(snapshot.data!);
          return FutureBuilder<PaletteGenerator>(
              future: PaletteGenerator.fromImageProvider(provider),
              builder: (context, snapshot) {
                final color = snapshot.data?.dominantColor?.color ?? Colors.black;

                return Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                              colors: [color.withOpacity(0.2), color.withOpacity(0.4)], radius: 1),
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
