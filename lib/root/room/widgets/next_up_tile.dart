import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/common/common.dart';

class NextUpTile extends StatefulWidget {
  const NextUpTile({Key? key}) : super(key: key);

  @override
  State<NextUpTile> createState() => _NextUpTileState();
}

class _NextUpTileState extends State<NextUpTile> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: RepositoryProvider.of<FirestoreRepository>(context).nextUp(),
      builder: (context, snapshot) {
        if (snapshot.data!.docs.isEmpty) {
          return Container();
        }

        Map<String, dynamic> json = snapshot.data!.docs[0].data();
        json['spotify_uri'] = snapshot.data!.docs[0].id;

        final firestoreTrack = FirestoreTrack.fromJson(json);

        return BaseTile(
          padding: const EdgeInsets.only(top: 0, left: 8, right: 8),
          margin: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('Next up', style: textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              AnimatedSwitcher(
                duration: Cte.defaultAnimationDuration,
                child: TrackRow(
                  track: firestoreTrack,
                  key: ValueKey('${firestoreTrack.spotifyUri}row'),
                  showActions: false,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
