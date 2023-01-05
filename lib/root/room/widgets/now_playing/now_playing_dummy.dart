part of 'now_playing.dart';

class NowPlayingDummy extends StatefulWidget {
  const NowPlayingDummy({Key? key}) : super(key: key);

  @override
  State<NowPlayingDummy> createState() => _NowPlayingDummyState();
}

class _NowPlayingDummyState extends State<NowPlayingDummy> {
  late final Timer timer;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  void startTimer() => timer = Timer(const Duration(seconds: 4), () {
        RepositoryProvider.of<AuthRepository>(context).connectToSpotify();
      });

  void cancelTimer() => timer.cancel();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loading...',
                  style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'P4ssenger',
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
            child: SongProgressIndicatorDummy(showLabel: false),
          ),
        ),
      ],
    );
  }
}
