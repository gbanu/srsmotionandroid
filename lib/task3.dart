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
  List<ToDo> todos = [];
  List<ToDo> dones = [];
  List<Question> questions = [];

  void _addToDo(ToDo newToDo) {
    setState(() {
      todos.insert(0, newToDo);
    });
  }

  void _addQuestion(Question newQuestion) {
    setState(() {
      questions.insert(questions.length, newQuestion);
    });
  }

  void _onCheck(bool newValue, int id) {
    int index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1 || !todos[index].isDone) {
      setState(() {
        todos[index].isDone = true;
        ToDo newDone = todos.removeAt(index);
        dones.insert(0, newDone);
      });
    }
  }

  void _onUncheck(bool newValue, int id) {
    int index = dones.indexWhere((todo) => todo.id == id);
    if (index != -1 || todos[index].isDone) {
      setState(() {
        dones[index].isDone = false;
        ToDo newToDo = dones.removeAt(index);
        todos.insert(0, newToDo);
      });
    }
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
            // QuestionList(questions: questions),
            // ToDoList(todos: todos, onCheck: _onCheck),
            // ToDoList(todos: dones, onCheck: _onUncheck)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _openAddScreen(context),
        ),
    );
  }
}
