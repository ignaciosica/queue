import 'package:flutter/material.dart';
import 'package:queue/app/widgets/gradient_app_bar.dart';
import 'package:queue/screens/widgets/create_room.dart';
import 'package:queue/screens/widgets/join_room.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: const Text('Queue')),
      body: const Column(
        children: [
          JoinRoom(),
          CreateRoom(),
        ],
      ),
    );
  }
}
