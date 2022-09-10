import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class ToDoListTile extends StatelessWidget {
  const ToDoListTile({Key? key, required this.todo, required this.onCheck}) : super(key: key);

  final void Function(bool, int) onCheck;
  final ToDo todo;

  Color get _color {
    if (todo.isDone) {
      return Colors.grey.shade400;
    } else if (todo.dueDate.isBefore(DateTime.now())) {
      return Colors.red;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _color,
      child: CheckboxListTile(
        secondary: CircleAvatar(
          child: Icon(todo.category.iconData),
        ),
        title: Text(todo.name),
        subtitle: Text(DateFormat('dd.MM.yyyy').format(todo.dueDate)),
        value: todo.isDone,
        onChanged: (newValue) {
          if (newValue != null) onCheck(newValue, todo.id);
        },
        selected: todo.isDone,
      ),
    );
  }
}
