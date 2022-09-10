import 'package:flutter/material.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({Key? key}) : super(key: key);

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add question'),
      ),
      body: Column(
        children: [
          const TextField(key: Key('question')),
          const TextField(key: Key('answer'))],
      )
    );
  }
}
