import 'package:flutter/material.dart';

class LobbyForm extends StatefulWidget {
  const LobbyForm(this.label, this.onPressed, {super.key});

  final void Function(String) onPressed;
  final String label;

  @override
  State<LobbyForm> createState() => _LobbyFormState();
}

class _LobbyFormState extends State<LobbyForm> {
  late final TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final keyText = widget.label.toLowerCase().replaceAll(' ', '_');

    return Column(
      children: [
        TextField(
            key: Key('${keyText}_textfield_key'),
            controller: textEditingController),
        ElevatedButton(
          key: Key('${keyText}_button_key'),
          onPressed: () => widget.onPressed(textEditingController.text),
          child: Text(widget.label),
        ),
      ],
    );
  }
}
