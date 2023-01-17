part of 'now_playing.dart';

class NowPlayingFirestore extends StatelessWidget {
  const NowPlayingFirestore({Key? key, required this.room}) : super(key: key);

  final Room room;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        Positioned.fill(child: SpotifyImageBuilder(imageUri: ImageUri(room.playerState.imageUri))),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.playerState.name,
                        style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        room.playerState.artists.map((e) => e).join(', '),
                        style: textTheme.bodySmall!.copyWith(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SkipButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
