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
          emptyBuilder: (context) => Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(9),
                ),
                height: 55,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('No songs in queue', style: TextStyle(color: Theme.of(context).colorScheme.primary))),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
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
