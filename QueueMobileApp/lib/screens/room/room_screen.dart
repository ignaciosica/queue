import 'package:flutter/material.dart';
import 'package:queue/app/widgets/gradient_app_bar.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen(this.room, {super.key});
  final dynamic room;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: Text(room['name'])),
    );
  }
}
