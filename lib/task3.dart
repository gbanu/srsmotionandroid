import 'package:flutter/material.dart';
import './models/question.dart';
import './session_screen/session_screen.dart';
import './widgets/question_list.dart';

import './models/todo.dart';
import './widgets/todo_list.dart';
import './add_screen/add_screen.dart';

class Task3 extends StatefulWidget {
  const Task3({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Task3> createState() => _Task3State();
}

class _Task3State extends State<Task3> {
  List<Question> questions = [
    Question(
        id: 01,
        question: 'Accessibility',
        answer:
            'Objects and environments should be designed to be usable without modification.',
        createdDate: DateTime(2022),
        isDone: false,
        status: Status.created),
    Question(
        id: 01,
        question: 'Fitts Law',
        answer:
        'The time required to move to the target is a function of the target size and distance to the target.',
        createdDate: DateTime(2022),
        isDone: false,
        status: Status.created),
    Question(
        id: 03,
        question: 'Consistency',
        answer:
        'Similar parts should be expressed in similar ways.',
        createdDate: DateTime(2022),
        isDone: false,
        status: Status.created)
  ];

  void _addQuestion(Question newQuestion) {
    setState(() {
      questions.insert(questions.length, newQuestion);
    });
  }

  void _openAddScreen(BuildContext context) async {
    Question? newQuestion = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddScreen(),
        ));
    if (newQuestion != null) {
      _addQuestion(newQuestion);
    }
  }

  void _openSessionScreen(BuildContext context) async {
    print(questions.map((element) => element.status).toList());
    List<Question> updatedQuestions = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SessionScreen(questions: questions),
        ));
    setState(() {
      questions = updatedQuestions;
    });
    print(updatedQuestions.map((element) => element.status).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          ElevatedButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () => _openSessionScreen(context),
            child: const Text('Start SRS Session'),
          ),
          Expanded(
            child: QuestionList(questions: questions),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _openAddScreen(context),
      ),
    );
  }
}
