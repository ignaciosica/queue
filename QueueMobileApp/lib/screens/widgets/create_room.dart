import 'package:flutter/material.dart';

class CreateRoom extends StatelessWidget {
  const CreateRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextField(),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Create Room'),
        ),
      ],
    );
  }
}