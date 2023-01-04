part of 'now_playing.dart';

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
