import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/root/room/room.dart';

class SongProgressIndicator extends StatefulWidget {
  const SongProgressIndicator({Key? key, this.color, this.showLabel = true}) : super(key: key);
  final Color? color;
  final bool showLabel;

  @override
  State<SongProgressIndicator> createState() => _SongProgressIndicatorState();
}

class _SongProgressIndicatorState extends State<SongProgressIndicator> {
  late final TextTheme textTheme;
  late double _millisecondsElapsed;

  @override
  void initState() {
    _millisecondsElapsed = 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;

    return BlocBuilder<SpotifyPlayerCubit, SpotifyPlayerState>(
      builder: (context, state) {
        if (state.track == null) {
          return SongProgressIndicatorDummy(color: widget.color, showLabel: widget.showLabel);
        }

        _millisecondsElapsed = state.playbackPosition.toDouble();

        return StreamBuilder<int>(
          stream: Stream<int>.periodic(const Duration(milliseconds: 150), (x) => 150),
          builder: (context, periodicSnapshot) {
            if (periodicSnapshot.hasData) {
              if (!state.isPaused) {
                _millisecondsElapsed += periodicSnapshot.data!.toDouble();
              } else {
                _millisecondsElapsed = state.playbackPosition.toDouble();
              }
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: LinearProgressIndicator(
                    color: widget.color,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.40),
                    minHeight: 6,
                    value: _millisecondsElapsed / (state.track!.duration),
                  ),
                ),
                if (widget.showLabel) const SizedBox(height: 4),
                if (widget.showLabel)
                  Row(
                    children: [
                      Text(
                        durationToString(_millisecondsElapsed.toInt()),
                        style: textTheme.labelSmall!.copyWith(color: textTheme.bodySmall!.color),
                      ),
                      const Spacer(),
                      Text(
                        durationToString(state.track!.duration),
                        style: textTheme.labelSmall!.copyWith(color: textTheme.bodySmall!.color),
                      )
                    ],
                  ),
              ],
            );
          },
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

class SongProgressIndicatorDummy extends StatelessWidget {
  const SongProgressIndicatorDummy({Key? key, this.color, required this.showLabel}) : super(key: key);

  final Color? color;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: LinearProgressIndicator(minHeight: 6, color: color ?? Colors.white),
        ),
        if (showLabel) const SizedBox(height: 4),
        if (showLabel)
          Row(
            children: [
              const Spacer(),
              Text('0:00', style: textTheme.labelSmall!.copyWith(color: textTheme.bodySmall!.color))
            ],
          ),
      ],
    );
  }
}
