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

  void startTimer() => timer = Timer(const Duration(seconds: 6), () {
        RepositoryProvider.of<AuthRepository>(context).connectToSpotify();
      });

  void cancelTimer() => timer.cancel();

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
                        Text('P4ssenger', style: textTheme.bodySmall),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.play_arrow_rounded), iconSize: 32),
                ],
              ),
              const Spacer(),
              const SongProgressIndicatorDummy(),
            ],
          ),
        ),
      ],
    );
  }
}
