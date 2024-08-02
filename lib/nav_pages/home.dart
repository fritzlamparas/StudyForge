import 'package:flutter/material.dart';
import 'package:studyforge/widgets/quiz.dart';
import '../widgets/card.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _HomePageState();
}

const List<String> plants = [
  "Digital Logic Design",
  "Computer Architecture",
  "Embedded Systems",
  "Software Development",
  "Operating Systems",
  "Networks and Security",
  "Electronics",
  "Machine Learning"
];

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate({String hinttext = "Search topics here"})
      : super(searchFieldLabel: hinttext);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light, // Change background color to black
      primaryColor: const Color.fromRGBO(0, 51, 102, 1.0),
      appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(248, 248, 248, 1.0)),

      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Color.fromRGBO(0, 51, 102, 1.0), // Change text color to white
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color.fromRGBO(
            248, 248, 248, 1.0), // Green color for the search field background
        hintStyle: TextStyle(
            color: Color.fromRGBO(0, 51, 102, 1.0)), // Color for the hint text
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
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
          color: Color.fromRGBO(0, 51, 102, 1.0),
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
        color: Color.fromRGBO(0, 51, 102, 1.0),
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
                color: Color.fromRGBO(0, 51, 102, 1.0)),
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
                color: Color.fromRGBO(0, 51, 102, 1.0)),
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
      backgroundColor: const Color.fromRGBO(0, 51, 102, 1.0),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Pick a topic!',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.1,
                        fontFamily: 'RobotoBold',
                        color: const Color.fromRGBO(248, 248, 248, 1.0)),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Test your knowledge among the available resources!',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontFamily: 'RobotoMedium',
                        color: const Color.fromRGBO(248, 248, 248, 1.0)),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return getPlantList()[index];
                },
                childCount: plants.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: (MediaQuery.of(context).size.width / 2) /
                    (MediaQuery.of(context).size.height / 3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
