class Question {
  String? question;
  List<String>? options;
  String? ans;

  Question();

  Question.fromSnapshot(snapshot)
      : question = snapshot.data()['ques'],
        options = List<String>.from(snapshot.data()['opt']),
        ans = snapshot.data()['ans'];
}
