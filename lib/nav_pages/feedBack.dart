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
      title: const Text('Feedback Sent'),
      content: Text(title),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'))
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // AppBar para sa taas ng design
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "StudyForge",
            style: TextStyle(
                color: Color.fromRGBO(230, 155, 0, 1.0),
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromRGBO(31, 31, 31, 1.0),
          shadowColor: const Color.fromRGBO(230, 155, 0, 1.0),
        ),

        //body of the application
        backgroundColor: const Color.fromRGBO(31, 31, 31, 1.0),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Feedback",
                style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: 'RobotoBold',
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(230, 155, 0, 1.0)),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Give me your feedback!",
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'RobotoMedium',
                  color: Colors.white,
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
                          fillColor: Colors.white,
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
                          fillColor: Colors.white,
                          hintText: "Message",
                          border: OutlineInputBorder(),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(150),
                        ],
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
                        minWidth: double.infinity,
                        color: const Color.fromRGBO(230, 155, 0, 1.0),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const SimpleDialog(
                                      'Your feedback has been submitted.');
                                });
                            Map<String, dynamic> data = {
                              "Name": nameOfuser.text,
                              "Email": emailOfuser.text,
                              "Message": messageOfuser.text,
                              "Time": FieldValue.serverTimestamp(),
                            };
                            setState(() {
                              nameOfuser.clear();
                              emailOfuser.clear();
                              messageOfuser.clear();
                            });
                            FirebaseFirestore.instance
                                .collection("FeedbackMessages")
                                .add(data);
                          }
                        },
                        child: const Text(
                          "SUBMIT",
                          style: TextStyle(
                            fontFamily: 'RobotoBold',
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(31, 31, 31, 1.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}