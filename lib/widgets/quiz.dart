import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyforge/models/quiz_display.dart';

class SecondPage extends StatefulWidget {
  final String topicId;

  const SecondPage({Key? key, required this.topicId}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<Object> _questionsList = [];
  int correctAnswers = 0;
  int totalQuestions = 0;
  int answeredQuestions = 0;
  bool isLoading = false; // Add a loading indicator variable

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getQuestionsList();
  }

  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(230, 155, 0, 1.0),
          title: const Text(
            "Result",
            style: TextStyle(
              color: Color.fromRGBO(31, 31, 31, 1.0),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Score: $correctAnswers/$totalQuestions',
                style: const TextStyle(
                  color: Color.fromRGBO(31, 31, 31, 1.0),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Do you want to take the quiz again?",
                style: TextStyle(
                  color: Color.fromRGBO(31, 31, 31, 1.0),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text(
                "Home",
                style: TextStyle(color: Color.fromRGBO(31, 31, 31, 1.0)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                "Review",
                style: TextStyle(color: Color.fromRGBO(31, 31, 31, 1.0)),
              ),
            ),
            TextButton(
              onPressed: () {
                _resetQuiz();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                "Retake",
                style: TextStyle(color: Color.fromRGBO(31, 31, 31, 1.0)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String htopic = widget.topicId;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color.fromRGBO(230, 155, 0, 1.0)),
        centerTitle: true,
        title: Text(
          "Quiz: $htopic",
          style: const TextStyle(
            color: Color.fromRGBO(230, 155, 0, 1.0),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color.fromRGBO(31, 31, 31, 1.0),
        shadowColor: const Color.fromRGBO(230, 155, 0, 1),
      ),
      body: SafeArea(
        child: Container(
          color: const Color.fromRGBO(31, 31, 31, 1.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _questionsList.length,
                    itemBuilder: (context, index) {
                      return QuizCard(
                        _questionsList[index] as Question,
                        onAnswerSubmitted: (isCorrect) {
                          if (isCorrect) {
                            setState(() {
                              correctAnswers++;
                            });
                          }
                          setState(() {
                            answeredQuestions++;
                          });
                          if (answeredQuestions == totalQuestions) {
                            _showResetConfirmationDialog(); // Show score dialog if all questions are answered
                          }
                        },
                      );
                    },
                    padding: const EdgeInsets.only(top: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showResetConfirmationDialog();
        },
        backgroundColor: const Color.fromRGBO(31, 31, 31, 1.0),
        child: isLoading
            ? const CircularProgressIndicator(
                color: Color.fromRGBO(230, 155, 0, 1.0),
              ) // Show loading indicator
            : const Icon(
                Icons.more_horiz,
                color: Color.fromRGBO(230, 155, 0, 1.0),
              ),
      ),
    );
  }

  void _resetQuiz() {
    setState(() {
      isLoading = true; // Set loading to true when starting to fetch questions
    });

    // Simulate a delay to show the loading indicator (replace with your actual data fetching logic)
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        correctAnswers = 0;
        totalQuestions = 0;
        answeredQuestions = 0;
        _questionsList.clear();
        getQuestionsList();
        isLoading = false;
      });
    });
  }

  Future getQuestionsList() async {
    var data =
        await FirebaseFirestore.instance.collection(widget.topicId).get();
    setState(() {
      _questionsList =
          List.from(data.docs.map((doc) => Question.fromSnapshot(doc)));
      totalQuestions = _questionsList.length;

      // Shuffle the questions
      _questionsList.shuffle();

      // Shuffle the options for each question
      _questionsList.forEach((question) {
        (question as Question).options?.shuffle();
      });
    });
  }
}

class QuizCard extends StatefulWidget {
  final Question _question;
  final Function(bool) onAnswerSubmitted;

  const QuizCard(this._question, {Key? key, required this.onAnswerSubmitted})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  int selectedOptionIndex = -1;
  bool isCorrect = false;
  bool answerSubmitted = false;
  List<bool> optionSelectedList = [];
  bool showCorrectAnswer =
      false; // Track whether the user wants to see correct answers

  @override
  void initState() {
    super.initState();
    optionSelectedList = List.filled(widget._question.options!.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(230, 155, 0, 1.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              widget._question.question ?? "",
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children:
                  List.generate(widget._question.options?.length ?? 0, (index) {
                final option = widget._question.options![index];
                return Row(
                  children: [
                    if (answerSubmitted && selectedOptionIndex == index)
                      Icon(
                        isCorrect ? Icons.check : Icons.close,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: answerSubmitted
                            ? () {}
                            : () {
                                if (!answerSubmitted) {
                                  bool userAnswerIsCorrect =
                                      option == widget._question.ans;
                                  handleOptionSelection(
                                      userAnswerIsCorrect, index);
                                  widget.onAnswerSubmitted(userAnswerIsCorrect);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: optionSelectedList[index]
                              ? isCorrect
                                  ? const Color.fromRGBO(230, 155, 0, 1.0)
                                  : const Color.fromRGBO(230, 155, 0, 1.0)
                              : const Color.fromRGBO(31, 31, 31, 1.0),
                        ),
                        child: Text(
                          // Show correct answer if requested
                          showCorrectAnswer ? option : option,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: optionSelectedList[index]
                                ? const Color.fromRGBO(31, 31, 31, 1.0)
                                : const Color.fromRGBO(230, 155, 0, 1.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            if (showCorrectAnswer && answerSubmitted)
              Text(
                'Correct Answer: ${widget._question.ans}',
                style: const TextStyle(
                  color: Color.fromRGBO(31, 31, 31, 1.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void handleOptionSelection(bool userAnswerIsCorrect, int index) {
    setState(() {
      isCorrect = userAnswerIsCorrect;
      answerSubmitted = true;
      selectedOptionIndex = index;
      optionSelectedList[index] = true;
    });

    // Show correct answer if the user selected the wrong option
    if (!userAnswerIsCorrect) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          showCorrectAnswer = true;
        });
      });
    }
  }
}
