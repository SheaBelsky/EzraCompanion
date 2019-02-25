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
  // Information about this tournament from Ezra
  final TournamentListItem tournamentInfo;

  // Constructor
  TournamentView({
    Key key,
    this.tournamentInfo,
  }) : super(key: key);

  @override
  _TournamentViewState createState() => _TournamentViewState();
}

class _TournamentViewState extends State<TournamentView> {
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

    // Initialize a new instance of each possible view within this tournament
    _tournamentHome = new TournamentHome(tournamentInfo: widget.tournamentInfo);
    _tournamentMap = new TournamentMap(tournamentInfo: widget.tournamentInfo);
    _tournamentNotifications = new TournamentNotifications(tournamentInfo: widget.tournamentInfo);
    _tournamentResults = new TournamentResults(tournamentInfo: widget.tournamentInfo);
    _tournamentSchedule = new TournamentSchedule(tournamentInfo: widget.tournamentInfo);

    // Set the page list based on the initialized views
    _tournamentViewPages = [
      _tournamentHome,
      _tournamentMap,
      _tournamentNotifications,
      _tournamentResults,
      _tournamentSchedule,
    ];
  }

  // TODO: Maintain state of which tournament is favorited. On app load, go right to that tournament. Only allow one tournament to be favorited at a time.
  // Change the color of the star icon based on what tournament is favorited.

  // Build the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.star_border),
            tooltip: "Favorite",
            onPressed: () {
              print("pressed");
            },
          )
        ],
        title: Text(widget.tournamentInfo.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: _tournamentViewPages.elementAt(_selectedIndex)
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _tournamentViewTabs,
        currentIndex: _selectedIndex,
        fixedColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}
