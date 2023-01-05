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

        final textTheme = Theme.of(context).textTheme;
        final playerState = ss.data!;
        playerState.isPaused ? _controller.reverse() : _controller.forward();

        return Stack(
          children: [
            Positioned.fill(child: SpotifyImageBuilderAlt(imageUri: playerState.track!.imageUri)),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(16),
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
