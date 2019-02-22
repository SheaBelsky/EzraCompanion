import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

// Firebase
import "firebase.dart";

// Class imports
import "package:ezra_companion/views/home/TournamentListItem.dart";

// Route imports
import "package:ezra_companion/views/home/TournamentList.dart";


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final FirebaseManager firebaseManager = new FirebaseManager();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Set up push notifications with Firebase
    firebaseManager.setupFirebase();

    // Create the app
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: MyHomePage(
          title: 'Ezra Companion',
      ),
      navigatorObservers: <NavigatorObserver>[firebaseManager.observer],
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<TournamentListItem>>(
          future: fetchTournaments(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }

            // If there is data, return a TournamentList
            // If not, return a progress indicator until the data is returned
            return snapshot.hasData
                ? TournamentList(tournaments: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        )
      ),
    );
  }
}
