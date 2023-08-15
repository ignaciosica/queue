import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/services/queue_service.dart';
import 'package:workmanager/workmanager.dart';

class StartPlayerButton extends StatelessWidget {
  const StartPlayerButton({super.key});

  @override
  Widget build(BuildContext context) {
    final IQueueService queueService = getIt<IQueueService>();
    final auth = FirebaseAuth.instance;

    return StreamBuilder(
      stream: queueService.onRoom,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData || snapshot.data['player'] != auth.currentUser!.uid) {
          return const SizedBox.shrink();
        }

        return ElevatedButton.icon(
          onPressed: () async {
            Workmanager().registerOneOffTask('1', 'bk', inputData: {'roomId': snapshot.data['id']});
          },
          icon: const Icon(Icons.speaker_rounded),
          label: const Text('Connect with spotify'),
        );
      },
    );
  }
}
