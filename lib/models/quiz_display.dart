import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  String? question;
  List<String>? options;
  String? ans;
  bool correctAnswerShown;

  Question({
    this.question,
    this.options,
    this.ans,
    this.correctAnswerShown = false,
  });

  factory Question.fromSnapshot(QueryDocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Question(
      question: data['ques'],
      options: List<String>.from(data['opt']),
      ans: data['ans'],
      correctAnswerShown: data['correctAnswerShown'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ques': question,
      'opt': options,
      'ans': ans,
      'correctAnswerShown': correctAnswerShown,
    };
  }
}
