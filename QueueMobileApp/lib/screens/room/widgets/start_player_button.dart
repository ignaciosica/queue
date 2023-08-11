import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:queue/app/service_locator.dart';
import 'package:queue/services/queue_service.dart';
import 'package:workmanager/workmanager.dart';

class StartPlayerButton extends StatelessWidget {
  const StartPlayerButton({super.key});

  //TODO: start background task
  //TODO: only show button to selected player

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
          onPressed: () {
            if (kDebugMode) print('before task:${DateTime.now()}');
            Workmanager().registerOneOffTask(
              '1',
              'background_task',
              // inputData: {
              //   //'room': BlocProvider.of<RoomCubit>(context).state.roomId,
              //   'clientId': dotenv.env['client_id'],
              //   'redirectUrl': dotenv.env['redirect_url'],
              // },
            );
            if (kDebugMode) print('after task:${DateTime.now()}');
          },
          icon: const Icon(Icons.speaker_rounded),
          label: const Text('Connect with spotify'),
        );
      },
    );
  }
}
