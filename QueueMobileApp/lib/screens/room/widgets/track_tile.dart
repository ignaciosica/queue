import 'package:cached_network_image/cached_network_image.dart';
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
    final isInQueue = track['isInQueue'] ?? true;

    final t = Theme.of(context);

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          width: 60,
          height: 60,
          imageUrl: track['song']['album']['images'][1]['url'],
          fit: BoxFit.cover,
        ),
      ),
      title: Text(track['song']['name'], maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        track['song']['artists'].map((a) => a['name']).join(', '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: t.textTheme.bodyMedium!.copyWith(color: t.colorScheme.onSurface.withOpacity(0.6)),
      ),
      trailing: track['votes'] != 0
          ? Padding(
              padding: const EdgeInsets.only(right: 4),
              child: CircleAvatar(
                  radius: 20,
                  backgroundColor: !selected ? Colors.transparent : t.colorScheme.primary,
                  child: Text(
                    track['votes'].toString(),
                    style: TextStyle(
                        color: !selected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold),
                  )),
            )
          : isInQueue
              ? IconButton.outlined(
                  onPressed: () => queueService.dequeue(track['uri']),
                  icon: const Icon(Icons.remove_circle_outline_rounded))
              : null,
      //selected: selected,
      onTap: selected
          ? () => queueService.unvote(track['uri'])
          : () => isInQueue
              ? queueService.vote(track['uri'])
              : queueService.queue(track['uri'], song: track['song']),
    );
  }
}
