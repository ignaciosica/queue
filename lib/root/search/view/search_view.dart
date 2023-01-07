part of 'search_page.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state.query.isEmpty) return Container();
            return FutureBuilder<List<SpotifyTrack>>(
              future: RepositoryProvider.of<SpotifyRepository>(context).searchTracks(state.query),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final track = snapshot.data![index];
                    return TrackRowWid2(spotifyTrack: track);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class TrackRowWid2 extends StatefulWidget {
  const TrackRowWid2({Key? key, required this.spotifyTrack}) : super(key: key);
  final SpotifyTrack spotifyTrack;

  @override
  State<TrackRowWid2> createState() => _TrackRowWidState2();
}

class _TrackRowWidState2 extends State<TrackRowWid2> {
  FirestoreTrack? firestoreTrack;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: RepositoryProvider.of<FirestoreRepository>(context).getTrack(widget.spotifyTrack.id),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          Map<String, dynamic> json = snapshot.data!.data()!;
          json['spotify_uri'] = snapshot.data!.id;
          firestoreTrack = FirestoreTrack.fromJson(json);
        }

        return Column(
          children: [
            const SizedBox(height: 8),
            InkWell(
              borderRadius: BorderRadius.circular(9),
              onTap: () async {
                final fireRepo = RepositoryProvider.of<FirestoreRepository>(context);
                if (firestoreTrack != null) await fireRepo.changeVote(firestoreTrack!);
                if (firestoreTrack == null) await fireRepo.addTrackToQueue(widget.spotifyTrack.id);
              },
              child: Ink(
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.network(widget.spotifyTrack.album.images[1].url),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.spotifyTrack.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.spotifyTrack.artists.map((e) => e.name).join(', '),
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    LikeButton(spotifyUri: widget.spotifyTrack.uri),
                    SizedBox(
                      width: 35,
                      child: firestoreTrack != null
                          ? VoteCounter(track: firestoreTrack!)
                          : Icon(Icons.add_circle_rounded, color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}