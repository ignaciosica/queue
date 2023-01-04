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
          return const SizedBox(height: 160, width: double.infinity, child: NowPlayingDummy());
        }

        BlocProvider.of<SpotifyPlayerCubit>(context).playerStateChanged(ss.data);

        final textTheme = Theme.of(context).textTheme;
        final playerState = ss.data!;
        playerState.isPaused ? _controller.reverse() : _controller.forward();

        return SizedBox(
          height: 160,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: SpotifyImageBuilderAlt(imageUri: playerState.track!.imageUri),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(8),
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
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Row(
                        children: [
                          const SizedBox(width: 22),
                          const Expanded(child: SongProgressIndicator(color: Colors.white, showLabel: false)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LikeButton(spotifyUri: playerState.track!.uri, color: Colors.white, size: 21),
                                CustomAnimatedIcon(
                                  iconA: IconButton(
                                    key: const ValueKey('play_button'),
                                    onPressed: () async {
                                      await SpotifySdk.resume();
                                      _controller.forward();
                                    },
                                    icon: const Icon(Icons.play_arrow_rounded),
                                    visualDensity: VisualDensity.compact,
                                    iconSize: 32,
                                  ),
                                  iconB: IconButton(
                                    key: const ValueKey('pause_button'),
                                    onPressed: () async {
                                      await SpotifySdk.pause();
                                      _controller.reverse();
                                    },
                                    icon: const Icon(Icons.pause_rounded),
                                    visualDensity: VisualDensity.compact,
                                    iconSize: 32,
                                  ),
                                  showA: playerState.isPaused,
                                ),
                                IconButton(
                                  //constraints: const BoxConstraints(maxHeight: 32),
                                  onPressed: () async {
                                    await SpotifySdk.skipNext();
                                    //setState(() {});
                                  },
                                  icon: const Icon(Icons.skip_next_rounded),
                                  iconSize: 32,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
