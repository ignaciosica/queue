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
    return Scaffold(
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
          onPressed: () {
            BlocProvider.of<RoomCubit>(context).setRoomId('');
            Navigator.pop(context);},
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          StreamBuilder<DocumentSnapshot>(
            stream: RepositoryProvider.of<FirestoreRepository>(context)
                .getRoom(BlocProvider.of<RoomCubit>(context).state.roomId),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                final room = Room.fromJson(snapshot.data!.data()!);
                if (RepositoryProvider.of<AuthRepository>(context).currentUser.id == room.player) {
                  return IconButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ParticipantsPage(roomCubit: BlocProvider.of<RoomCubit>(context)))),
                    icon: const Icon(Icons.speaker_group_rounded),
                  );
                }
              } else {
                //Workmanager().cancelAll();
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
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => SearchPage(roomCubit: BlocProvider.of<RoomCubit>(context)))),
        tooltip: 'Search',
        child: const Icon(Icons.search_rounded),
      ),
    );
  }
}
