import 'package:flutter/material.dart';

class ToDo {
  int id;
  String name;
  DateTime dueDate;
  DateTime creationDate;
  bool isDone;
  ToDoCategory category;

  ToDo({
    required this.id,
    required this.name,
    required this.dueDate,
    required this.creationDate,
    required this.isDone,
    required this.category,
  });
}

class ToDoCategory {
  String name;
  IconData iconData;
  int id;

  ToDoCategory({
    required this.name,
    required this.iconData,
    required this.id,
  });
}
