import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/auth/auth.dart';
import 'package:groupify/common/common.dart';
import 'package:groupify/root/cubit/spotify_player_cubit.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class NowPlayingAlt2 extends StatefulWidget {
  const NowPlayingAlt2({Key? key}) : super(key: key);

  @override
  State<NowPlayingAlt2> createState() => _NowPlayingAlt2State();
}

class _NowPlayingAlt2State extends State<NowPlayingAlt2> {
  late final Stream<ConnectionStatus> stream;

  @override
  void initState() {
    super.initState();
    stream = SpotifySdk.subscribeConnectionStatus();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: StreamBuilder<ConnectionStatus>(
        stream: stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.done:
              return const NowPlayingAltReconnectDummy();
            case ConnectionState.waiting:
              return const NowPlayingAltDummy();
            case ConnectionState.active:
              if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.connected) {
                return const NowPlayingAltReconnectDummy();
              }

              return const NowPlayingAltWid();
          }
        },
      ),
    );
  }
}

class NowPlayingAltWid extends StatefulWidget {
  const NowPlayingAltWid({Key? key}) : super(key: key);

  @override
  State<NowPlayingAltWid> createState() => _NowPlayingAltWidState();
}

class _NowPlayingAltWidState extends State<NowPlayingAltWid> with TickerProviderStateMixin {
  late Animation<double> _myAnimation;
  late AnimationController _controller;
  late double _millisecondsElapsed;

  @override
  void initState() {
    super.initState();

    _millisecondsElapsed = 0;
    _controller = AnimationController(vsync: this, duration: Cte.defaultAnimationDuration);
    _myAnimation = CurvedAnimation(curve: Curves.linear, parent: _controller);
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
        _millisecondsElapsed = playerState.playbackPosition.toDouble();

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
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(width: 22),
                          const Expanded(child: SongProgressIndicator(color: Colors.white, showLabel: false)),
                          // Expanded(
                          //   child: StreamBuilder<int>(
                          //     stream: Stream<int>.periodic(const Duration(milliseconds: 150), (x) => 150),
                          //     builder: (context, periodicSnapshot) {
                          //       if (periodicSnapshot.hasData) {
                          //         if (!playerState.isPaused) {
                          //           _millisecondsElapsed += periodicSnapshot.data!.toDouble();
                          //         }
                          //       }
                          //       return ClipRRect(
                          //         borderRadius: BorderRadius.circular(9),
                          //         child: LinearProgressIndicator(
                          //           color: Colors.white,
                          //           minHeight: 4,
                          //           value: _millisecondsElapsed / (playerState.track!.duration),
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),
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

  String durationToString(int milliseconds) {
    final elapsedDuration = Duration(milliseconds: milliseconds.toInt());
    return '${elapsedDuration.inMinutes.remainder(60)}:'
        '${elapsedDuration.inSeconds.remainder(60) < 10 ? 0 : ''}'
        '${elapsedDuration.inSeconds.remainder(60)}';
  }
}

class NowPlayingAltDummy extends StatelessWidget {
  const NowPlayingAltDummy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(9), child: SizedBox(width: 100, child: Container())),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Loading...', style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
                        Text('p4ssenger', style: textTheme.bodySmall),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.play_arrow_rounded), iconSize: 32),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(9), child: const LinearProgressIndicator(minHeight: 6)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Spacer(),
                      Text('0:00', style: textTheme.labelSmall!.copyWith(color: textTheme.bodySmall!.color)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NowPlayingAltReconnectDummy extends StatelessWidget {
  const NowPlayingAltReconnectDummy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        label: const Text('Reconnect'),
        icon: const Icon(Icons.multitrack_audio_rounded, color: Colors.white),
        onPressed: () => RepositoryProvider.of<AuthRepository>(context).connectToSpotify(),
        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      ),
    );
  }
}
