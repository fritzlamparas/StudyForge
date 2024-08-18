import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimpleDialog extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final title;
  const SimpleDialog(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(248, 248, 248, 1.0),
      title: const Text('Feedback Sent',
          style: TextStyle(
            color: Color.fromRGBO(0, 51, 102, 1.0),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          )),
      content: Text(title),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK',
                style: TextStyle(
                  color: Color.fromRGBO(0, 51, 102, 1.0),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )))
      ],
    );
  }
}

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final nameOfuser = TextEditingController();
  final emailOfuser = TextEditingController();
  final messageOfuser = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<bool> isTypeSelected = [false, false, false, true, true];

  String sanitizeDocumentId(String name) {
    // Replace spaces with underscores and remove any non-alphanumeric characters
    return name.trim().replaceAll(' ', '_').replaceAll(RegExp(r'[^\w]'), '');
  }

  String formatDate(DateTime dateTime) {
    String month = dateTime.month.toString().padLeft(2, '0');
    String day = dateTime.day.toString().padLeft(2, '0');
    String year = dateTime.year.toString().substring(2); // Get last two digits
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String second = dateTime.second.toString().padLeft(2, '0');
    return "$month$day$year$hour$minute$second";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 51, 102, 1.0),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: const Text(
                  "Feedback",
                  style: TextStyle(
                      fontSize: 28.0,
                      fontFamily: 'RobotoBold',
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(248, 248, 248, 1.0)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Give me your feedback!",
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'RobotoMedium',
                  color: Color.fromRGBO(248, 248, 248, 1.0),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: nameOfuser,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Name",
                          border: OutlineInputBorder(),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-z A-Z á-ú Á-Ú 0-9]"))
                        ],
                        validator: (nameOfuser) {
                          if (nameOfuser == null || nameOfuser.isEmpty) {
                            return 'Please enter your name.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: emailOfuser,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(248, 248, 248, 1.0),
                          hintText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        validator: (emailOfuser) {
                          if (emailOfuser == null || emailOfuser.isEmpty) {
                            return 'Please enter your email.';
                          } else if (emailOfuser.isNotEmpty) {
                            String emailOfuser1 = emailOfuser.toString();
                            String pattern =
                                r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$";
                            if (RegExp(pattern).hasMatch(emailOfuser1) ==
                                false) {
                              return 'Please enter your email properly.';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: messageOfuser,
                        maxLength: 150,
                        maxLengthEnforcement: MaxLengthEnforcement.none,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(248, 248, 248, 1.0),
                          hintText: "Message",
                          border: OutlineInputBorder(),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(150),
                        ],
                        buildCounter: (BuildContext context,
                            {required int currentLength,
                            required int? maxLength,
                            required bool isFocused}) {
                          return Text(
                            '$currentLength/$maxLength',
                            style: const TextStyle(
                                fontFamily: 'RobotoMedium',
                                color: Color.fromRGBO(248, 248, 248, 1.0)),
                          );
                        },
                        validator: (messageOfuser) {
                          if (messageOfuser == null || messageOfuser.isEmpty) {
                            return 'Please enter a message.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8.0),
                      MaterialButton(
                        height: 50.0,
                        minWidth: MediaQuery.of(context).size.width / 2 -
                            32.0, // Adjust the width to be half minus padding
                        color: const Color.fromRGBO(248, 248, 248, 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const SimpleDialog(
                                    'Your feedback has been submitted.');
                              },
                            );
                            Map<String, dynamic> data = {
                              "Name": nameOfuser.text,
                              "Email": emailOfuser.text,
                              "Message": messageOfuser.text,
                              "Time": FieldValue.serverTimestamp(),
                            };
                            String sanitizedUserName =
                                sanitizeDocumentId(nameOfuser.text);
                            String formattedDate = formatDate(DateTime.now());
                            String documentId =
                                "${sanitizedUserName}_$formattedDate";
                            setState(() {
                              nameOfuser.clear();
                              emailOfuser.clear();
                              messageOfuser.clear();
                            });
                            FirebaseFirestore.instance
                                .collection("FeedbackMessages")
                                .doc(documentId)
                                .set(data);
                          }
                        },
                        child: const Text(
                          "SUBMIT",
                          style: TextStyle(
                            fontFamily: 'RobotoBold',
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 51, 102, 1.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
