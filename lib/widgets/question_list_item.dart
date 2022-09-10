import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/question.dart';

class QuestionListItem extends StatelessWidget {
  const QuestionListItem({Key? key, required this.question}) : super(key: key);

  final Question question;

  Color get _color {
    if (question.status == Status.remembered) {
      return Colors.green.shade200;
    } else if (question.status == Status.created) {
      return Colors.blue.shade100;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _color,
      child: ListTile(
        title: Text(question.question),
      )
    );
  }
}
