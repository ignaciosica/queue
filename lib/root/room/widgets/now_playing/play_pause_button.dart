
import 'package:flutter/material.dart';
import 'package:groupify/common/common.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class PlayPauseButton extends StatefulWidget {
  const PlayPauseButton({super.key});

  @override
  State<PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  late bool isPaused;
  late final Stream<PlayerState> stream;

  @override
  void initState() {
    super.initState();
    stream = SpotifySdk.subscribePlayerState();
    isPaused = true;
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<PlayerState>(
      stream: stream,
      builder: (context, snapshot) {
        isPaused = snapshot.data?.isPaused ?? true;
        return InkWell(
          onTap: (){
            if(snapshot.hasData && snapshot.data != null){
              snapshot.data?.isPaused ?? false ? SpotifySdk.resume() : SpotifySdk.pause();
            }
          },
          child: CustomAnimatedIcon(
            iconA: const Icon(Icons.play_arrow_rounded, key: ValueKey('play'), size: 36),
            iconB: const Icon(Icons.pause_rounded, key: ValueKey('pause'), size: 36),
            showA: isPaused,
          ),
        );
      }
    );
  }
}