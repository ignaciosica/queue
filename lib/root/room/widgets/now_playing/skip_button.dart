part of 'now_playing.dart';

class SkipButton extends StatefulWidget {
  const SkipButton({Key? key}) : super(key: key);

  @override
  State<SkipButton> createState() => _SkipButtonState();
}

class _SkipButtonState extends State<SkipButton> {
  int _voteCount = 0;
  bool _voted = false;

  void _incrementVoteCount() {
    setState(() {
      _voted = !_voted;
      SpotifySdk.skipNext();
      _voteCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.skip_next_rounded, size: 36),
          onPressed: _incrementVoteCount,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
        ),
        ExpandedSection(
          expand: _voted,
          child: Row(
            children: [
              const Icon(Icons.people_alt_rounded, size: 16),
              Text(' $_voteCount/2'),
            ],
          ),
        ),
      ],
    );
  }
}
