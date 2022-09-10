import 'package:flutter/material.dart';

class UserInput extends StatelessWidget {
  const UserInput({Key? key, required this.onTextInput}) : super(key: key);

  final void Function(String) onTextInput;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onTextInput,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }
}
