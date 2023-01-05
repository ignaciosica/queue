import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groupify/common/common.dart';

class QueueTile extends StatelessWidget {
  const QueueTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text('Queue', style: textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        FirestoreListView<Map<String, dynamic>>(
          physics: const NeverScrollableScrollPhysics(),
          pageSize: 10,
          query: RepositoryProvider.of<FirestoreRepository>(context).getQueueQuery(),
          shrinkWrap: true,
          emptyBuilder: (context) => const Text('empty'),
          errorBuilder: (context, obj, st) => const Text('error'),
          itemBuilder: (context, snapshot) {
            Map<String, dynamic> json = snapshot.data();
            json['spotify_uri'] = snapshot.id;
            final firestoreTrack = FirestoreTrack.fromJson(json);

            return TrackRow(
              track: firestoreTrack,
              position: 4,
              key: ValueKey('${firestoreTrack.spotifyUri}row'),
            );
          },
        ),
      ],
    );
  }
}
