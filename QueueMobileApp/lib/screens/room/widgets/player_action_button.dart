import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/services/queue_service.dart';

class PlayerActionButton extends StatelessWidget {
  const PlayerActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final IQueueService queueService = getIt<IQueueService>();
    final auth = FirebaseAuth.instance;

    return StreamBuilder(
      stream: queueService.onRoom,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data['player'] != auth.currentUser!.uid) {
          return const SizedBox.shrink();
        }

        return Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.speaker_rounded),
              label: const Text('Connect with spotify'),
            ),
          ],
        );
      },
    );
  }
}
