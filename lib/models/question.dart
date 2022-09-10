
class Question {
  int id;
  String question;
  String answer;
  DateTime createdDate;
  bool isDone;
  Status status;

  Question({
    required this.id,
    required this.question,
    required this.answer,
    required this.createdDate,
    required this.isDone,
    required this.status,
  });
}

enum Status {
  created, bad, ok, good, remembered
}