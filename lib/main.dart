// Flutter and Dart
import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';
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

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  // The state of the app; this is set after reading from the file corresponding to global state
  // Minimizing I/O operations, the file is written to and the state of this variable is updated
  // with the changed values only if the state changes
  Map _appState;

  // TODO: What does this do?
  _MyHomePageState();

  // Initialize the state
  @override
  void initState() {
    super.initState();

    // Set up push notifications when the state for the home page has been initialized
    _firebaseManager.setupMessaging();
  }

  Future<List<TournamentListItem>> initializeApp() async {
    var loadedTournaments = await this._memoizer.runOnce(() async {
      Map loadedAppState = await _appStateManager.readFile();

      DateTime now = DateTime.now();

      // If this date has never been set before, it means this is the user's first time
      DateTime lastUpdatedAt = loadedAppState["tournamentsUpdatedAt"] != null
          ? DateTime.parse(loadedAppState["tournamentsUpdatedAt"])
          : now;

      // If the last time the tournaments were updated was 7 or more days ago, update them now
      if (lastUpdatedAt.difference(now).inDays >= 7 || lastUpdatedAt == now) {
        List tournaments = await fetchTournaments(http.Client());
        String stringTournaments = json.encode(tournaments);
        await _appStateManager.updateFile("tournaments", stringTournaments);
        Map updatedState = await _appStateManager.updateFile("tournamentsUpdatedAt", now.toString());
        updatedState["mapTournaments"] = tournaments;
        setState(() {
          _appState = updatedState;
        });
        return tournaments;
      }
      else {
        String stringTournaments = await _appStateManager.getValue("tournaments");
        List<TournamentListItem> convertedTournaments = await compute(parseTournaments, stringTournaments);
        loadedAppState["mapTournaments"] = convertedTournaments;
        setState(() {
          _appState = loadedAppState;
        });
        return convertedTournaments;
      }
    });
    return loadedTournaments;
  }

  /**
   * Manages this app's global state
   */

  /// Sets the navigation of the app
  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _resetState() async {
    Map newState = await _appStateManager.resetState();
    _updateLocalState(newState);
  }

  /// Updates the local state of the app
  void _updateLocalState (Map newAppState) {
    setState(() {
      _appState = newAppState;
    });
  }

  /// Updates the state of the app locally to minimize I/O operations
  void updateState(Map file) {
    setState(() {
      _appState = file;
    });
  }

  /**
   * Manages favorites
   */
  /// Returns a filtered list of tournaments based on the favorites set by this user
  List<TournamentListItem> _getFavoriteTournaments() {
    if (_appState is Map && _appState["favorites"] is String) {
      // Parse favorites
      Iterable rawFavorites = json.decode(_appState["favorites"]);
      List<String> parsedFavorites = rawFavorites.map((tournament) => "$tournament").toList();

      // Parse tournaments
      Iterable rawTournaments = json.decode(_appState["tournaments"]);
      List<TournamentListItem> parsedTournaments = rawTournaments.map((tournament) {
        Map parsedCurrentTournament;
        if (tournament is String) {
          parsedCurrentTournament = json.decode(tournament);
        }
        else if (tournament is Map) {
          parsedCurrentTournament = tournament;
        }
        return TournamentListItem.fromJson(parsedCurrentTournament);
      }).toList();

      // If there are favorites and tournaments
      if (parsedTournaments is List && parsedTournaments.length > 0 && parsedFavorites is List && parsedFavorites.length > 0) {
        List favorites = parsedTournaments.where((tournament) {
          return parsedFavorites.contains(tournament.ezraId);
        }).toList();
        return favorites;
      }
      else {
        return [];
      }
    }
    else {
      return [];
    }
  }

  List _getFavoriteTournamentIDs() {
    List favoriteTournaments = _getFavoriteTournaments();
    List favoriteIDs = [];
    if (favoriteTournaments is List && favoriteTournaments.length > 0) {
      favoriteIDs = favoriteTournaments.map((tournament) => tournament.ezraId).toList();
    }
    return favoriteIDs;
  }

  /// Removes a favorite from the list of favorites
  void _addFavorite(String tournamentID) {
    List favoriteIDs = _getFavoriteTournamentIDs();
    favoriteIDs.add(tournamentID);
    String stringFavorites = json.encode(favoriteIDs);
    _appStateManager.updateFile("favorites", stringFavorites).then(_updateLocalState);
  }

  /// Removes a favorite from the list of favorites
  void _removeFavorite(String tournamentID) {
    List favoriteIDs = _getFavoriteTournamentIDs();
    favoriteIDs.remove(tournamentID);
    String stringFavorites = json.encode(favoriteIDs);
    _appStateManager.updateFile("favorites", stringFavorites).then(_updateLocalState);
  }

  /**
   * Views
   */
  /// If there is data, return a TournamentList
  /// If not, return a progress indicator until the data is returned
  Widget _favoritesView (List<TournamentListItem> tournaments)  {
    if (tournaments is List && tournaments.length != 0) {
      List<TournamentListItem> favoriteTournaments = _getFavoriteTournaments();
      return Favorites(
          addFavorite: _addFavorite,
          removeFavorite: _removeFavorite,
          tournaments: favoriteTournaments
      );
    }
    else {
      return Center(child: CircularProgressIndicator());
    }
  }

  /// Settings view
  Widget _settingsView () {
    return Settings(
      handleResetButtonPress: _resetState,
    );
  }

  /// If there is data, return a TournamentList
  /// If not, return a progress indicator until the data is returned
  Widget _tournamentListView (List<TournamentListItem> tournaments)  {
    if (tournaments is List && tournaments.length != 0) {
      return TournamentList(
          addFavorite: _addFavorite,
          favoriteTournaments: _getFavoriteTournaments(),
          removeFavorite: _removeFavorite,
          tournaments: tournaments
      );
    }
    else {
      return Center(child: CircularProgressIndicator());
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
        }

        List<TournamentListItem> tournaments = snapshot.hasData ? snapshot.data : [];

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
              child: [
                _tournamentListView(tournaments),
                _favoritesView(tournaments),
                _settingsView()
              ][_selectedIndex]
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
      },
    );
  }
}
