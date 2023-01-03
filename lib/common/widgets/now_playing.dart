import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/auth/auth.dart';
import 'package:groupify/common/common.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectionStatus>(
      stream: SpotifySdk.subscribeConnectionStatus(),
      builder: (context, ss) {
        if (ss.connectionState == ConnectionState.none || ss.hasError || !ss.hasData || !ss.data!.connected) {
          return const SizedBox(height: 100, width: double.infinity, child: NowPlayingReconnectDummy());
        }
        return const NowPlayingWid();
      },
    );
  }
}

class NowPlayingWid extends StatefulWidget {
  const NowPlayingWid({Key? key}) : super(key: key);

  @override
  State<NowPlayingWid> createState() => _NowPlayingWidState();
}

class _NowPlayingWidState extends State<NowPlayingWid> with TickerProviderStateMixin {
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
          return const SizedBox(height: 100, width: double.infinity, child: NowPlayingDummy());
        }

        final textTheme = Theme.of(context).textTheme;
        final playerState = ss.data!;
        playerState.isPaused ? _controller.reverse() : _controller.forward();
        _millisecondsElapsed = playerState.playbackPosition.toDouble();

        return SizedBox(
          height: 100,
          width: double.infinity,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: SizedBox(width: 100, child: SpotifyImageBuilder(imageUri: playerState.track!.imageUri)),
              ),
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
                              Text(
                                playerState.track!.name,
                                style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                playerState.track!.artists.map((e) => e.name).join(', '),
                                style: textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              if (playerState.isPaused) {
                                await SpotifySdk.resume();
                                _controller.forward();
                              } else {
                                await SpotifySdk.pause();
                                _controller.reverse();
                              }
                            },
                            icon: AnimatedIcon(icon: AnimatedIcons.play_pause, progress: _myAnimation),
                            iconSize: 32),
                      ],
                    ),
                    const Spacer(),
                    StreamBuilder<int>(
                      stream: Stream<int>.periodic(const Duration(milliseconds: 150), (x) => 150),
                      builder: (context, periodicSnapshot) {
                        if (periodicSnapshot.hasData) {
                          if (!playerState.isPaused) {
                            _millisecondsElapsed += periodicSnapshot.data!.toDouble();
                          }
                        }
                        return Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: LinearProgressIndicator(
                                minHeight: 6,
                                value: _millisecondsElapsed / (playerState.track!.duration),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  durationToString(_millisecondsElapsed.toInt()),
                                  style: textTheme.labelSmall!.copyWith(color: textTheme.bodySmall!.color),
                                ),
                                const Spacer(),
                                Text(
                                  durationToString(playerState.track!.duration),
                                  style: textTheme.labelSmall!.copyWith(color: textTheme.bodySmall!.color),
                                )
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
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

class NowPlayingDummy extends StatelessWidget {
  const NowPlayingDummy({Key? key}) : super(key: key);

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

class NowPlayingReconnectDummy extends StatelessWidget {
  const NowPlayingReconnectDummy({Key? key}) : super(key: key);

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
