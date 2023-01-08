part of 'root_page.dart';

class RootView extends StatefulWidget {
  const RootView({super.key, required this.title});

  final String title;

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  bool enhance = false;

  static Future<void> _connectToSpotifyRemote(String accessToken) async {
    await SpotifySdk.connectToSpotifyRemote(
      clientId: 'b9a4881e77f4488eb882788cb106a297',
      redirectUrl: "http://mysite.com/callback",
      accessToken: accessToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const RoomTitle(),
        elevation: 1,
        centerTitle: true,
        //backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromRGBO(42, 30, 81, 100), Color.fromRGBO(81, 58, 159, 100)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async => Workmanager().cancelAll(),
            icon: const Icon(Icons.stop_rounded),
          ),
          IconButton(
            onPressed: () async {
              Workmanager().registerOneOffTask(
                "task-identifier",
                "simpleTask",
                inputData: {"accessToken": await RepositoryProvider.of<AuthRepository>(context).getSpotifyAccessToken()},
                constraints: Constraints(
                  networkType: NetworkType.connected,
                  requiresBatteryNotLow: false,
                  requiresCharging: false,
                  requiresDeviceIdle: false,
                  requiresStorageNotLow: false,
                ),
              );
            },
            icon: const Icon(Icons.not_started_rounded),
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
              BaseTile(
                padding: EdgeInsets.only(top: 0, left: 8, right: 8),
                margin: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 16),
                child: NextUpTile(),
              ),
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
