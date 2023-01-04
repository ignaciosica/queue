part of 'now_playing.dart';

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
