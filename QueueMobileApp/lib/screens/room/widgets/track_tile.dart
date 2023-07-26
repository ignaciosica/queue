import 'package:flutter/material.dart';

class TrackTile extends StatelessWidget {
  const TrackTile(this.track, {super.key});
  final dynamic track;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(track['uri']),
        subtitle: const Text('Artist Name'),
        trailing: const Icon(Icons.add));
  }
}
