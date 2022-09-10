import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../widgets/todo_listtile.dart';

class ToDoList extends StatelessWidget {
  const ToDoList({Key? key, required this.todos, required this.onCheck}) : super(key: key);

  final void Function(bool, int) onCheck;
  final List<ToDo> todos;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        ToDo todo = todos[index];
        return ToDoListTile(
          todo: todo,
          onCheck: onCheck,
        );
      },
    );
  }
}
