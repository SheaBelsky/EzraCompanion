import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// Firebase
import "package:ezra_companion/classes/FirebaseManager.dart";

// Class imports
import "package:ezra_companion/classes/FileStorage.dart";
import "package:ezra_companion/classes/TournamentListItem.dart";

// Template imports
import "package:ezra_companion/views/home/TournamentList.dart";

// View imports
import "package:ezra_companion/views/app/Favorites.dart";
import "package:ezra_companion/views/app/Settings.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final FirebaseManager firebaseManager = new FirebaseManager();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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

// TODO: Pass the FirebaseManager to the HomePage state so the notifications are only initialized once
// TODO: Also allow users to "star" a single tournament at a time, so opening/closing the app will re-open that tournament.

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
  // Currently selected tab
  int _selectedIndex = 0;

  static FileStorage _appStateManager = new FileStorage();

  static FirebaseManager _firebaseManager = new FirebaseManager();

  // The state of the app; this is set after reading from the file corresponding to global state
  // Minimizing I/O operations, the file is written to and the state of this variable is updated
  // with the changed values only if the state changes
  Map _appState = null;

  // TODO: What does this do?
  _MyHomePageState();

  // Initialize the state
  @override
  void initState() {
    super.initState();
    print("initState");

    // Set up push notifications when the state for the home page has been initialized
    _firebaseManager.setupMessaging();

    // Set the app state from the global state file
    _appStateManager.readFile()
      .then((Map file) {
        print("file");
        print(file);
        _appState = file;
      });
  }

  // Set the page list based on the initialized views
  List<Widget> get _appViews {
    return [
      TournamentListView(),
      Favorites(),
      Settings()
    ];
  }
  
  /// 
  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Show the tutorial, a loading indicator, or the tournament list
  FutureBuilder TournamentListView() {
    return FutureBuilder(
      future: fetchTournaments(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
        }

        // If there is data, return a TournamentList
        // If not, return a progress indicator until the data is returned
        Widget tournamentListOrLoader = snapshot.hasData
            ? TournamentList(tournaments: snapshot.data)
            : Center(child: CircularProgressIndicator());

        return tournamentListOrLoader;
      },
    );
  }

  /// Updates the state of the app locally to minimize I/O operations
  void updateState(Map file) {
    setState(() {
      _appState = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: _appViews.elementAt(_selectedIndex)
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home'), backgroundColor: Colors.red),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), title: Text('Favorites'), backgroundColor: Colors.red),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('Settings'), backgroundColor: Colors.red),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.red,
        onTap: _onBottomNavTapped,
      )
    );
  }
}
