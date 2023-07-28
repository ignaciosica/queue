import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/services/queue_service.dart';

class TrackTile extends StatelessWidget {
  const TrackTile(this.track, {super.key});
  final dynamic track;

  @override
  Widget build(BuildContext context) {
    final IQueueService queueService = getIt<IQueueService>();

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final selected = track['voters']?.contains(uid);

    return ListTile(
      title: Text(track['uri']),
      subtitle: const Text('Artist Name'),
      trailing: track['votes'] != 0
          ? Text(track['votes'].toString())
          : IconButton.filledTonal(
              onPressed: () => queueService.dequeue(track['uri']),
              icon: const Icon(Icons.remove_circle_outline_rounded)),
      selected: selected,
      onTap: selected
          ? () => queueService.unvote(track['uri'])
          : () => queueService.vote(track['uri']),
    );
  }
}
