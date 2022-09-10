import 'package:flutter/material.dart';
import 'package:untitled/models/question.dart';

import 'widgets/category_picker.dart';
import 'widgets/due_date_selection.dart';
import '../models/todo.dart';
import 'widgets/user_input.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  String question = "";
  String answer = "";
  DateTime? now;

  void onQuestionTextInput(String newInput) {
    setState(() {
      question = newInput;
    });
  }

  void onAnswerTextInput(String newInput) {
    setState(() {
      answer = newInput;
    });
  }

  void _onFinish(BuildContext context) {
    DateTime now = DateTime.now();
    Question newQuestion = Question(
        id: now.millisecondsSinceEpoch,
        question: question,
        answer: answer,
        createdDate: now,
        isDone: false, status: Status.created);
    Navigator.pop(context, newQuestion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add question"),
      ),
      body: ListView(
        children: [
          Wrapper(
            title: "Question:",
            child: UserInput(onTextInput: onQuestionTextInput),
          ),
          const Divider(),
          Wrapper(
            title: "Answer:",
            child: UserInput(onTextInput: onAnswerTextInput),
          ),
          const Divider(),
        ],
      ),
      floatingActionButton: question == "" || answer == ""
          ? const AddButton(onPress: null)
          : AddButton(onPress: () => _onFinish(context)),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key, required this.child, required this.title}) : super(key: key);

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: child,
          ),
        ],
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({Key? key, required this.onPress}) : super(key: key);

  final void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPress,
      label: const Text("Add"),
      icon: const Icon(Icons.add),
      backgroundColor: onPress == null ? Colors.grey : Colors.blue,
    );
  }
}
