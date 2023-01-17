part of 'now_playing.dart';

class NowPlayingWid extends StatefulWidget {
  const NowPlayingWid({Key? key}) : super(key: key);

  @override
  State<NowPlayingWid> createState() => _NowPlayingWidState();
}

class _NowPlayingWidState extends State<NowPlayingWid> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Cte.defaultAnimationDuration);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: SpotifySdk.subscribePlayerState(),
      builder: (context, ss) {
        if (ss.connectionState != ConnectionState.active || ss.hasError || !ss.hasData || ss.data!.track == null) {
          return const NowPlayingDummy();
        }

        BlocProvider.of<SpotifyPlayerCubit>(context).playerStateChanged(ss.data);

        // final player_state = <String, dynamic>{
        //   'artists': ss.data!.track?.artists.map((e) => e.name).toList() ?? [],
        //   'duration': ss.data!.track?.duration ?? 0,
        //   'image_uri': ss.data!.track?.imageUri ?? '',
        //   'name': ss.data!.track?.name ??   '',
        //   'is_paused': ss.data!.isPaused,
        //   'playback_position': ss.data!.playbackPosition,
        //   'uri': ss.data!.track?.uri ?? '',
        // };
        //
        // FirebaseFirestore.instance.collection('rooms').doc(BlocProvider.of<RoomCubit>(context).state.roomId).update({'player_state': player_state});
        // FirebaseFirestore.instance.collection('rooms').doc(BlocProvider.of<RoomCubit>(context).state.roomId).update({'test': 'player_state'});

        FirebaseFirestore.instance.collection('rooms').doc(BlocProvider.of<RoomCubit>(context).state.roomId).update({
          'player_state.artists': ss.data!.track?.artists.map((e) => e.name).toList() ?? [],
          'player_state.duration': ss.data!.track?.duration ?? 0,
          'player_state.image_uri': ss.data!.track?.imageUri.raw ?? '',
          'player_state.name': ss.data!.track?.name ?? '',
          'player_state.is_paused': ss.data!.isPaused,
          'player_state.playback_position': ss.data!.playbackPosition,
          'player_state.uri': ss.data!.track?.uri ?? '',
        });

        final textTheme = Theme.of(context).textTheme;
        final playerState = ss.data!;
        playerState.isPaused ? _controller.reverse() : _controller.forward();

        return Stack(
          children: [
            Positioned.fill(child: SpotifyImageBuilder(imageUri: playerState.track!.imageUri)),
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
                            playerState.track!.name,
                            style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            playerState.track!.artists.map((e) => e.name).join(', '),
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
            const Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SongProgressIndicator(color: Colors.white, showLabel: false),
              ),
            ),
          ],
        );
      },
    );
  }
}
