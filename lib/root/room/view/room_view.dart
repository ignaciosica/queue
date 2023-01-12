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
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (enhance) {
                Workmanager().cancelAll();
              } else {
                Workmanager().registerOneOffTask(
                  "task-identifier",
                  "simpleTask",
                  inputData: {
                    "room": '23yvA5kACxSCtVJpfBGV',
                    "clientId": 'b9a4881e77f4488eb882788cb106a297',
                    "redirectUrl": 'https://com.example.groupify/callback/',
                  },
                  constraints: Constraints(
                    networkType: NetworkType.connected,
                    requiresBatteryNotLow: false,
                    requiresCharging: false,
                    requiresDeviceIdle: false,
                    requiresStorageNotLow: false,
                  ),
                );
              }
              enhance = !enhance;
            },
            icon: const Icon(Icons.speaker_group_rounded),
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
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage())),
        tooltip: 'Search',
        child: const Icon(Icons.search_rounded),
      ),
    );
  }
}
