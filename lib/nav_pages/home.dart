import 'package:flutter/material.dart';
import 'package:studyforge/widgets/quiz.dart';
import '../widgets/card.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _HomePageState();
}

const List<String> plants = [
  "EE Laws",
  "Thermodynamics",
  "Management Contracts & Specs",
  "General Chemistry",
  "College Physics",
  "Programming Engineering",
  "Materials Engineering"
];

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate({String hinttext = "Search topics here"})
      : super(searchFieldLabel: hinttext);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark, // Change background color to black
      primaryColor: const Color.fromRGBO(
          31, 31, 31, 1.0), // Change background color to black
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Color.fromRGBO(230, 155, 0, 1.0), // Change text color to white
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.clear,
          color: Color.fromRGBO(230, 155, 0, 1.0),
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(
        Icons.arrow_back,
        color: Color.fromRGBO(230, 155, 0, 1.0),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in plants) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(
            result,
            style: const TextStyle(
                fontFamily: 'RobotoMedium',
                color: Color.fromRGBO(230, 155, 0, 1.0)),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SecondPage(topicId: result)));
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in plants) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(
            result,
            style: const TextStyle(
                fontFamily: 'RobotoMedium',
                color: Color.fromRGBO(230, 155, 0, 1.0)),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SecondPage(topicId: result)));
          },
        );
      },
    );
  }
}

class _HomePageState extends State<homePage> {
  //Para ito sa shortcut for the List of Plants
  List<Widget> getPlantList() {
    List<Widget> plantitems = [];
    for (int i = 0; i < plants.length; i++) {
      String plant = plants[i];
      String imgname = i.toString();
      var newItem = ListViewCard(
        title: plant,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SecondPage(topicId: plant)));
        },
        imageOfPlant: "assets/Images_of_Plant/$imgname.png",
      );
      plantitems.add(newItem);
    }
    return plantitems;
  }

//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          IconButton(
            onPressed: () {
              // method to show the search bar
              showSearch(
                  context: context,
                  // delegate to customize the search bar
                  delegate: CustomSearchDelegate());
            },
            icon: const Icon(Icons.search,
                color: Color.fromRGBO(230, 155, 0, 1.0)),
          )
        ],
      ),
      backgroundColor: const Color.fromRGBO(31, 31, 31, 1.0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: const Text(
                'Pick a topic!',
                style: TextStyle(
                    fontSize: 35,
                    fontFamily: 'RobotoBold',
                    color: Color.fromRGBO(230, 155, 0, 1.0)),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: const Text(
                  'Test your knowledge among the available resources!',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'RobotoMedium',
                      color: Color.fromRGBO(230, 155, 0, 1.0)),
                  textAlign: TextAlign.left),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 950,
              color: const Color.fromRGBO(230, 155, 0, 1.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text('List of Topics',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'RobotoBold',
                                  color: Color.fromRGBO(31, 31, 31, 1.0)),
                              textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                  GridView.count(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8.0),
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio:
                          MediaQuery.of(context).size.height / 950,
                      crossAxisCount: 2,
                      children: getPlantList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
