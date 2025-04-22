import 'package:flutter/material.dart';
import 'package:studyforge/nav_pages/aboutus.dart';
import 'package:studyforge/nav_pages/feedback.dart';
import 'package:studyforge/nav_pages/home.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  final List<Widget> pages = [
    const homePage(),
    const AboutusPage(),
    const FeedbackPage(),
  ];
  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'StudyForge requires an internet connection to get the latest updates.',
              style: TextStyle(
                  color: Color.fromRGBO(248, 248, 248, 1.0),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: 'RobotoMedium')),
          backgroundColor: Color.fromRGBO(112, 128, 144, 1.0),
          duration: Duration(seconds: 5),
        ),
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "StudyForge",
          style: TextStyle(
              color: Color.fromRGBO(0, 51, 102, 1.0),
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(248, 248, 248, 1.0),
        shadowColor: const Color.fromRGBO(0, 51, 102, 1.0),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
            icon: const Icon(Icons.search,
                color: Color.fromRGBO(0, 51, 102, 1.0)),
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
          ),
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
