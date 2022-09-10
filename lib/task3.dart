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

  List<Question> questions = [];


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
          // bottom: const TabBar(tabs: [
          //   Tab(text: "ToDo"),
          //   Tab(text: "Done"),
          // ]),
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
