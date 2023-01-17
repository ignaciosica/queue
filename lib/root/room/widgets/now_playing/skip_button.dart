part of 'now_playing.dart';

class SkipButton extends StatefulWidget {
  const SkipButton({Key? key}) : super(key: key);

  @override
  State<SkipButton> createState() => _SkipButtonState();
}

class _SkipButtonState extends State<SkipButton> {
  void _changeSkipVote(Room room, String roomId) async {
    if (room.skip.contains(RepositoryProvider.of<AuthRepository>(context).currentUser.id)) {
      await RepositoryProvider.of<FirestoreRepository>(context).removeSkipVote(roomId);
    } else {
      await RepositoryProvider.of<FirestoreRepository>(context).addSkipVote(roomId);
    }
  }

  void _skipSong(String roomId) async {
    await RepositoryProvider.of<FirestoreRepository>(context).clearSkipVotes(roomId);
    SpotifySdk.skipNext();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: RepositoryProvider.of<FirestoreRepository>(context).getRoom(BlocProvider.of<RoomCubit>(context).state.roomId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final room = Room.fromJson(snapshot.data!.data()!);
          if (room.skip.length >= (room.users.length / 2).floor()) {
            _skipSong(BlocProvider.of<RoomCubit>(context).state.roomId);
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_next_rounded, size: 36),
                onPressed: () => _changeSkipVote(room, BlocProvider.of<RoomCubit>(context).state.roomId),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
              ExpandedSection(
                expand: room.skip.contains(RepositoryProvider.of<AuthRepository>(context).currentUser.id),
                child: Row(
                  children: [
                    const Icon(Icons.people_alt_rounded, size: 16),
                    Text(
                      '${room.skip.length}/${(room.users.length / 2).floor()}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
