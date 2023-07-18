import 'package:flutter/material.dart';
import 'package:queue/app/widgets/gradient_app_bar.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: const Text('Queue')),
    );
  }
}
