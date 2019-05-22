import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Class imports
import "package:ezra_companion/classes/FileStorage.dart";
import "package:ezra_companion/classes/TournamentListItem.dart";

// Route imports
import "package:ezra_companion/views/tournament/tabs/TournamentHome.dart";
import "package:ezra_companion/views/tournament/tabs/TournamentMap.dart";
import "package:ezra_companion/views/tournament/tabs/TournamentNotifications.dart";
import "package:ezra_companion/views/tournament/tabs/TournamentResults.dart";
import "package:ezra_companion/views/tournament/tabs/TournamentSchedule.dart";

class TournamentView extends StatefulWidget {
  final Function addFavorite;
  final Function removeFavorite;

  bool isFavorited;

  final firebaseManager;

  // Information about this tournament from Ezra
  final TournamentListItem tournamentInfo;

  // Constructor
  TournamentView({
    Key key,
    this.addFavorite,
    this.firebaseManager,
    this.isFavorited,
    this.removeFavorite,
    this.tournamentInfo,
  }) : super(key: key);

  @override
  _TournamentViewState createState() => _TournamentViewState();
}

class _TournamentViewState extends State<TournamentView> {
  Map _appState;

  bool _heartFilled;

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  // Currently selected tab
  int _selectedIndex = 0;

  // File storage to persist state for this tournament
  FileStorage _fileStorage;

  // Views
  TournamentHome _tournamentHome;
  TournamentMap _tournamentMap;
  TournamentNotifications _tournamentNotifications;
  TournamentResults _tournamentResults;
  TournamentSchedule _tournamentSchedule;

  // List of pages that each tab corresponds to
  List<Widget> _tournamentViewPages;

  // List of tabs on the bottom of the screen
  final List<BottomNavigationBarItem> _tournamentViewTabs = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home'), backgroundColor: Colors.red),
    BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Map'), backgroundColor: Colors.red),
    BottomNavigationBarItem(icon: Icon(Icons.notifications_active), title: Text('Notifications'), backgroundColor: Colors.red),
    BottomNavigationBarItem(icon: Icon(Icons.calendar_today), title: Text('Schedule'), backgroundColor: Colors.red),
    BottomNavigationBarItem(icon: Icon(Icons.stars), title: Text('Results'), backgroundColor: Colors.red),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Initialize state
  void initState() {
    super.initState();

    // Initialize a new FileStorage instance
    _fileStorage = new FileStorage(tournamentInfo: widget.tournamentInfo);

    // Favorite heart status
    _heartFilled = widget.isFavorited;
  }

  Future<Map> initializeTournament() async {
    Map tournamentState = await this._memoizer.runOnce(() async {
      // Read from the file corresponding to this tournament
      Map loadedTournamentState = await _fileStorage.readFile();

      // Update local state
      _updateLocalState(loadedTournamentState);

      // Initialize a new instance of each possible view within this tournament
      _tournamentHome = new TournamentHome(
        tournamentInfo: widget.tournamentInfo
      );
      _tournamentMap = new TournamentMap(
        tournamentInfo: widget.tournamentInfo
      );
      bool isSubscribedPublic = loadedTournamentState["publicSubscriptionStatus"] != null
        ? loadedTournamentState["publicSubscriptionStatus"] == "true"
        : false;
      bool isSubscribedStaff = loadedTournamentState["staffSubscriptionStatus"] != null
        ? loadedTournamentState["staffSubscriptionStatus"] == "true"
        : false;
      _tournamentNotifications = new TournamentNotifications(
        isSubscribedPublic: isSubscribedPublic,
        isSubscribedStaff: isSubscribedStaff,
        tournamentInfo: widget.tournamentInfo,
        updateSubscriptionStatus: _updatePublicSubscriptionStatus
      );
      _tournamentResults = new TournamentResults(
        tournamentInfo: widget.tournamentInfo
      );
      _tournamentSchedule = new TournamentSchedule(
        fileStorage: _fileStorage,
        tournamentInfo: widget.tournamentInfo,
      );
      // Set the page list based on the initialized views
      _tournamentViewPages = [
        _tournamentHome,
        _tournamentMap,
        _tournamentNotifications,
        _tournamentSchedule,
        _tournamentResults,
      ];

      return loadedTournamentState;
    });
    return tournamentState;
  }

  /// Updates the local state of the app
  void _updateLocalState (Map newAppState) {
    setState(() {
      _appState = newAppState;
    });
  }

  // Manage push notification subscription stuff
  bool _currentPublicSubscriptionStatus() {
    if (_appState["publicSubscriptionStatus"] != null) {
      return _appState["publicSubscriptionStatus"] == "true";
    }
    else {
      return false;
    }
  }

  bool _currentStaffSubscriptionStatus() {
    if (_appState["staffSubscriptionStatus"] != null) {
      return _appState["staffSubscriptionStatus"] == "true";
    }
    else {
      return false;
    }
  }

  /// Running this function inverts the value of the user's subscription status, and updates Firebase & the app's state accordingly
  void _updatePublicSubscriptionStatus() {
    // The value will be "true" or "false"; two ! converts it to a boolean, three will invert it
    bool newPublicSubscriptionStatus = !_currentPublicSubscriptionStatus();
    // If we are now subscribing to notifications
    if (newPublicSubscriptionStatus == true) {
      widget.firebaseManager.subscribeToTopic("${widget.tournamentInfo.key}-publicNotifications");
    }
    // If we are now unsubscribing from notifications
    else {
      widget.firebaseManager.unsubscribeFromTopic("${widget.tournamentInfo.key}-publicNotifications");
    }
    _fileStorage.updateFile("publicSubscriptionStatus", "$newPublicSubscriptionStatus").then(_updateLocalState);
  }

  // Build the widget
  @override
  Widget build(BuildContext context) {
      // Ignore the maps and results page for padding
      double padding;
      switch(_selectedIndex) {
          case 1:
              padding = 0.0;
              break;
          case 4:
              padding = 5.0;
              break;
          default:
              padding = 15.0;
      }
      final TextTheme textTheme = Theme.of(context).textTheme;

    return FutureBuilder(
      future: initializeTournament(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        else {
          return Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: _heartFilled == true ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                  tooltip: "Favorite",
                  onPressed: () {
                    // If the tournament is not favorited, they are making it favorite
                    if (!_heartFilled) {
                      widget.addFavorite(widget.tournamentInfo.ezraId);
                    }
                    // If the tournament is favorited, they are making it unfavorited
                    else {
                      widget.removeFavorite(widget.tournamentInfo.ezraId);
                    }
                    setState(() {
                      _heartFilled = !_heartFilled;
                    });
                  },
                )
              ],
              title: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold
                    ),
                    text: widget.tournamentInfo.name,
                  )
              ),
            ),
            body: Padding(
                padding: EdgeInsets.all(padding),
                child: Center(
                    child: _tournamentViewPages.elementAt(_selectedIndex)
                )
            ),
            bottomNavigationBar: BottomNavigationBar(
                items: _tournamentViewTabs,
                currentIndex: _selectedIndex,
                fixedColor: Colors.white,
                onTap: _onItemTapped,
            ),
          );
        }
      }
    );
  }
}
