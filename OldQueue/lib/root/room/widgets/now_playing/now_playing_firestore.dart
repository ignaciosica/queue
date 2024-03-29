part of 'now_playing.dart';

class NowPlayingFirestore extends StatelessWidget {
  const NowPlayingFirestore({Key? key, required this.room}) : super(key: key);

  final Room room;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if(room.playerState.uri.isEmpty){
      return const NowPlayingDummy();
    }

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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(RepositoryProvider.of<AuthRepository>(context).currentUser.id == room.player)const PlayPauseButton(),
                    const SkipButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SongProgressIndicatorFirestore(color: Colors.white, showLabel: false, room: room),
          ),
        ),
      ],
    );
  }
}
