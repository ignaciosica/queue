part of 'room_page.dart';

class RoomView extends StatefulWidget {
  const RoomView({super.key, required this.title});

  final String title;

  @override
  State<RoomView> createState() => _RoomViewState();
}

class _RoomViewState extends State<RoomView> {
  bool enhance = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (await showDialog<bool>(
              context: context,
              builder: (c) => AlertDialog(
                title: const Text('Warning'),
                content: const Text('Do you really want to exit the room?'),
                actions: [
                  TextButton(child: const Text('No'), onPressed: () => Navigator.pop(c, false)),
                  TextButton(child: const Text('Yes'), onPressed: () => Navigator.pop(c, true)),
                ],
              ),
            )) ??
            false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const RoomTitle(),
          elevation: 1,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromRGBO(42, 30, 81, 100), Color.fromRGBO(81, 58, 159, 100)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          leading: IconButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('rooms')
                  .doc(BlocProvider.of<RoomCubit>(context).state.roomId)
                  .update({
                'users': FieldValue.arrayRemove([RepositoryProvider.of<AuthRepository>(context).currentUser!.id]),
                'player': '',
              });

              BlocProvider.of<RoomCubit>(context).setRoomId('');
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          actions: [
            // IconButton(onPressed: () => Workmanager().cancelAll(), icon: const Icon(Icons.stop_rounded)),
            // IconButton(
            //     onPressed: () {
            //       Workmanager().registerOneOffTask(
            //         '1',
            //         'background_task',
            //         inputData: {
            //           'room': BlocProvider.of<RoomCubit>(context).state.roomId,
            //           'clientId': dotenv.env['client_id'],
            //           'redirectUrl': dotenv.env['redirect_url'],
            //         },
            //       );
            //     },
            //     icon: const Icon(Icons.play_arrow_rounded)),
            StreamBuilder<DocumentSnapshot>(
              stream: RepositoryProvider.of<FirestoreRepository>(context)
                  .getRoom(BlocProvider.of<RoomCubit>(context).state.roomId),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  final room = Room.fromJson(snapshot.data!.data()!);
                  if (room.player.isEmpty || RepositoryProvider.of<AuthRepository>(context).currentUser.id == room.player) {
                    Workmanager().registerPeriodicTask(
                      '1',
                      'background_task',
                      inputData: {
                        'room': BlocProvider.of<RoomCubit>(context).state.roomId,
                        'clientId': dotenv.env['client_id'],
                        'redirectUrl': dotenv.env['redirect_url'],
                      },
                    );
                    return IconButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ParticipantsPage())),
                      icon: const Icon(Icons.speaker_group_rounded),
                    );
                  } else {
                    Workmanager().cancelAll();
                    SpotifySdk.pause();
                  }
                } else {
                  Workmanager().cancelAll();
                  SpotifySdk.pause();
                }
                return Container();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                BaseTile(
                  margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                  padding: EdgeInsets.zero,
                  child: NowPlaying(),
                ),
                NextUpTile(),
                BaseTile(
                  padding: EdgeInsets.only(top: 0, left: 8, right: 8),
                  margin: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 16),
                  child: QueueTile(),
                ),
                SizedBox(height: 64),
                //SuggestionsTile(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage())),
          tooltip: 'Search',
          child: const Icon(Icons.search_rounded),
        ),
      ),
    );
  }
}
