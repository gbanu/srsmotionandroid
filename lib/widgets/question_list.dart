import 'package:flutter/material.dart';

import '../models/question.dart';
import '../widgets/question_list_item.dart';


class QuestionList extends StatelessWidget {
  const QuestionList({Key? key, required this.questions}) : super(key: key);

  final List<Question> questions;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        Question question = questions[index];
        return QuestionListItem(
          question: question,
        );
      },
    );
  }
}
