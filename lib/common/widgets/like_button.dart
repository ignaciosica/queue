import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify_sdk/models/library_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({Key? key, required this.spotifyUri, this.size = 18, this.color}) : super(key: key);
  final String spotifyUri;
  final double size;
  final Color? color;

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late final Future<LibraryState?> libraryStateFuture;

  @override
  void initState() {
    super.initState();
    libraryStateFuture = SpotifySdk.getLibraryState(spotifyUri: widget.spotifyUri);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LibraryState?>(
      future: libraryStateFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && !snapshot.hasError && snapshot.hasData) {
          return LikeButtonWid(
              spotifyUri: widget.spotifyUri, liked: snapshot.data!.isSaved, size: widget.size, color: widget.color);
        } else {
          return Container();
        }
      },
    );
  }
}

class LikeButtonWid extends StatefulWidget {
  const LikeButtonWid({Key? key, required this.spotifyUri, required this.liked, this.size = 18, this.color})
      : super(key: key);
  final String spotifyUri;
  final bool liked;
  final double size;
  final Color? color;

  @override
  State<LikeButtonWid> createState() => _LikeButtonWidState();
}

class _LikeButtonWidState extends State<LikeButtonWid> {
  late bool liked;

  @override
  void initState() {
    liked = widget.liked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const ValueKey('like_button'),
      onPressed: () async {
        if (liked) {
          await SpotifySdk.removeFromLibrary(spotifyUri: widget.spotifyUri);
          setState(() => liked = false);
        } else {
          await SpotifySdk.addToLibrary(spotifyUri: widget.spotifyUri);
          setState(() => liked = true);
        }
      },
      visualDensity: VisualDensity.compact,
      iconSize: widget.size,
      icon: FaIcon(
        liked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
        color: widget.color ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
