import 'package:flutter/material.dart';

class GradientAppBar extends AppBar {
  GradientAppBar({super.key, super.title, super.leading, super.actions})
      : super(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromRGBO(42, 30, 81, 100), Color.fromRGBO(81, 58, 159, 100)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            surfaceTintColor: Colors.transparent);
}
