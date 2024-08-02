import 'package:flutter/material.dart';
import 'package:studyforge/nav_pages/aboutUs.dart';

import 'package:studyforge/nav_pages/feedBack.dart';
import 'package:studyforge/nav_pages/home.dart';

class mainPage extends StatefulWidget {
  const mainPage({super.key});

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  List pages = [const homePage(), const AboutUsPage(), const FeedbackPage()];
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed
        backgroundColor: const Color.fromRGBO(248, 248, 248, 1.0),
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: const Color.fromRGBO(0, 51, 102, 1.0),
        unselectedItemColor: const Color.fromRGBO(112, 128, 144, 1.0),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ), //Home
          BottomNavigationBarItem(
            icon: Icon(
              Icons.lightbulb,
            ),
            label: 'About App',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.feedback,
            ),
            label: 'Feedback',
          ),
        ],
      ),
    );
  }
}
