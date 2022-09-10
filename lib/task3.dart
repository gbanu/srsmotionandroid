import 'package:flutter/material.dart';
import 'package:untitled/models/question.dart';

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: const TabBar(tabs: [
            Tab(text: "ToDo"),
            Tab(text: "Done"),
          ]),
        ),
        body: TabBarView(
          children: [
            ToDoList(todos: todos, onCheck: _onCheck),
            ToDoList(todos: dones, onCheck: _onUncheck)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _openAddScreen(context),
        ),
      ),
    );
  }
}
