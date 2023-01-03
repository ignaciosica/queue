import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SpotifySdk.getImage(
        imageUri: widget.imageUri,
        dimension: ImageDimension.large,
      ),
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.hasData) {
          return FadeInImage(
            image: MemoryImage(snapshot.data!),
            fit: BoxFit.fitWidth,
            placeholder: const CachedNetworkImageProvider(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/A_black_image.jpg/640px-A_black_image.jpg'),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            width: ImageDimension.large.value.toDouble(),
            height: ImageDimension.large.value.toDouble(),
            child: const Center(child: Text('Error getting image')),
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

class SpotifyImageBuilderAlt extends StatefulWidget {
  const SpotifyImageBuilderAlt({Key? key, required this.imageUri}) : super(key: key);
  final ImageUri imageUri;

  @override
  State<SpotifyImageBuilderAlt> createState() => _SpotifyImageBuilderAltState();
}

class _SpotifyImageBuilderAltState extends State<SpotifyImageBuilderAlt> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SpotifySdk.getImage(
        imageUri: widget.imageUri,
        dimension: ImageDimension.large,
      ),
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.hasData) {
          final provider = MemoryImage(snapshot.data!);

          return FutureBuilder<PaletteGenerator>(
              future: PaletteGenerator.fromImageProvider(provider),
              builder: (context, snapshot) {
                final color = snapshot.data?.darkMutedColor?.color ?? Colors.black;

                return Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              color.withOpacity(0.2),
                              color.withOpacity(0.4),
                              color.withOpacity(0.6),
                              color.withOpacity(0.8),
                            ],
                            radius: 1,
                          ),
                        ),
                        position: DecorationPosition.foreground,
                        child: FadeInImage(
                          image: provider,
                          fit: BoxFit.fitWidth,
                          placeholder: const CachedNetworkImageProvider(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/A_black_image.jpg/640px-A_black_image.jpg'),
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
            child: const Center(child: Text('Error getting image')),
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
