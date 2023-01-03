part of 'root_page.dart';

class RootView extends StatefulWidget {
  const RootView({super.key, required this.title});

  final String title;

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  int _counter = 0;
  bool enhance = false;

  static Future<void> _connectToSpotifyRemote(String accessToken) async {
    await SpotifySdk.connectToSpotifyRemote(
      clientId: 'b9a4881e77f4488eb882788cb106a297',
      redirectUrl: "http://mysite.com/callback",
      accessToken: accessToken,
    );
  }

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        //title: Text(widget.title),
        title: const RoomTitle(),
        elevation: 1,
        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () async {
              BlocProvider.of<AppBloc>(context).add(AppLogoutRequested());
            },
            icon: const Icon(Icons.logout_rounded),
          )
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
                child: NowPlayingAlt2(),
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
              //SuggestionsTile(),
            ],
          ),
        ),
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: _incrementCounter, tooltip: 'Skip', child: const Icon(Icons.search)
              // CustomAnimatedIcon(
              //   iconA: const Icon(Icons.skip_next_rounded, key: ValueKey('ia')),
              //   iconB: const Icon(Icons.people_rounded, key: ValueKey('ib')),
              //   showA: _counter % 2 == 1,
              // ),
              ),
    );
  }
}

/*
BaseTile(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Search', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    style: Theme.of(context).textTheme.bodyLarge,
                    textInputAction: TextInputAction.search,
                    suffix: IconButton(onPressed: () {}, icon: const Icon(Icons.clear)),
                  ),
                  //FormzTextInput<SearchCubit>(title: 'Search', propKey: 'query')
                ],
              ),
            ),
 */
