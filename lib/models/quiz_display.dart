class Question {
  String? question;
  List<String>? options;
  String? correctAnswer;

  Question();

  Question.fromSnapshot(snapshot)
      : question = snapshot.data()['question'],
        options = List<String>.from(snapshot.data()['options']),
        correctAnswer = snapshot.data()['correctAnswer'];
}
