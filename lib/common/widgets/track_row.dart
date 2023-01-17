import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/common/common.dart';
import 'package:groupify/root/room/room.dart';

class TrackRow extends StatelessWidget {
  const TrackRow({Key? key, required this.track, this.position = 4, this.showActions = true}) : super(key: key);

  final FirestoreTrack track;
  final int position;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final spotifyRepo = RepositoryProvider.of<SpotifyRepository>(context);

    return FutureBuilder<SpotifyTrack>(
        initialData: spotifyRepo.tryGetTrack(track.spotifyUri),
        future: spotifyRepo.getTrack(track.spotifyUri),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return TrackRowWid(
              spotifyTrack: snapshot.data!,
              position: position,
              showActions: showActions,
              firestoreTrack: track,
              key: ValueKey(track.spotifyUri),
            );
          }
          if (snapshot.connectionState == ConnectionState.done && !snapshot.hasError && snapshot.hasData) {
            return TrackRowWid(
              spotifyTrack: snapshot.data!,
              position: position,
              showActions: showActions,
              firestoreTrack: track,
              key: ValueKey(track.spotifyUri),
            );
          } else {
            return TrackRowDummy(position: position, key: ValueKey('${track.spotifyUri}_dummy'));
          }
        });
  }
}

class TrackRowWid extends StatefulWidget {
  const TrackRowWid({
    Key? key,
    required this.spotifyTrack,
    required this.position,
    required this.firestoreTrack,
    this.showActions = true,
  }) : super(key: key);
  final SpotifyTrack spotifyTrack;
  final FirestoreTrack firestoreTrack;
  final int position;
  final bool showActions;

  @override
  State<TrackRowWid> createState() => _TrackRowWidState();
}

class _TrackRowWidState extends State<TrackRowWid> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(9),
          onTap: () async {
            final fireRepo = RepositoryProvider.of<FirestoreRepository>(context);
            await fireRepo.changeVote(BlocProvider.of<RoomCubit>(context).state.roomId, widget.firestoreTrack);
          },
          child: Ink(
            height: 55,
            decoration: BoxDecoration(
              color: widget.position >= 0 && widget.position <= 3
                  ? Theme.of(context).colorScheme.primary.withOpacity((0.30 / widget.position))
                  : null,
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
                if (widget.showActions)
                  CustomAnimatedIcon(
                      iconA: LikeButton(spotifyUri: 'spotify:track:${widget.firestoreTrack.spotifyUri}'),
                      iconB: IconButton(
                        onPressed: () async {
                          final fireRepo = RepositoryProvider.of<FirestoreRepository>(context);
                          await fireRepo.removeTrack(BlocProvider.of<RoomCubit>(context).state.roomId, widget.firestoreTrack.spotifyUri);
                        },
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(
                          Icons.remove_circle_outline_rounded,
                          size: 18,
                          color: CupertinoColors.destructiveRed,
                        ),
                      ),
                      showA: widget.firestoreTrack.votes.isNotEmpty),
                VoteCounter(track: widget.firestoreTrack),
                //const SizedBox(width: 4)
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class TrackRowDummy extends StatelessWidget {
  const TrackRowDummy({Key? key, required this.position}) : super(key: key);
  final int position;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(9),
          onTap: null,
          child: Ink(
            height: 50,
            decoration: BoxDecoration(
              color: position >= 0 && position <= 3
                  ? Theme.of(context).colorScheme.primary.withOpacity((0.30 / position))
                  : null,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: const SizedBox(width: 50),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(''),
                      Text('', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
