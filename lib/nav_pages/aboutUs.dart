// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 51, 102, 1.0),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: const Text(
                'About StudyForge',
                style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'RobotoBold',
                    color: Color.fromRGBO(248, 248, 248, 1.0)),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: const Text(
                'StudyForge is a mobile app designed to aid computer engineering students in preparing for their exams. The app employs a quiz tool to test users on crucial exam topics, providing a streamlined and effective study experience with its user-friendly interface. StudyForge is an essential companion for students seeking comprehensive review in the field of computer engineering.',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'RobotoMedium',
                    color: Color.fromRGBO(248, 248, 248, 1.0),
                    height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: const Text('App Creator',
                  style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'RobotoBold',
                      color: Color.fromRGBO(248, 248, 248, 1.0)),
                  textAlign: TextAlign.center),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const CircleAvatar(
                        backgroundColor: Color.fromRGBO(248, 248, 248, 1.0),
                        radius: 60,
                        child: CircleAvatar(
                          radius: 55,
                          backgroundImage:
                              AssetImage('assets/images/Fritz_pic.jpg'),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: const Text(
                          'Engr. Fritz Lamparas',
                          style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'RobotoMedium',
                              color: Color.fromRGBO(248, 248, 248, 1.0)),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
