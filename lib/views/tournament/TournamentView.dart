import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Class imports
import "package:ezra_companion/views/home/TournamentListItem.dart";

// Route imports
import "package:ezra_companion/views/tournament/tabs/TournamentHome.dart";
import "package:ezra_companion/views/tournament/tabs/TournamentMap.dart";
import "package:ezra_companion/views/tournament/tabs/TournamentNotifications.dart";
import "package:ezra_companion/views/tournament/tabs/TournamentResults.dart";
import "package:ezra_companion/views/tournament/tabs/TournamentSchedule.dart";

class TournamentView extends StatefulWidget {
  final TournamentListItem TournamentInfo;

  TournamentView({
    Key key,
    this.TournamentInfo,
  }) : super(key: key);

  @override
  _TournamentViewState createState() => _TournamentViewState();
}

class _TournamentViewState extends State<TournamentView> {
  // Currently selected tab
  int _selectedIndex = 0;

  // Views
  TournamentHome _tournamentHome;
  TournamentMap _tournamentMap;
  TournamentNotifications _tournamentNotifications;
  TournamentResults _tournamentResults;
  TournamentSchedule _tournamentSchedule;

  // List of pages that each tab corresponds to
  List<Widget> _tournamentViewPages;

  // List of tabs on the bottom of the screen
  final List<BottomNavigationBarItem> TournamentViewTabs = [
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

    // Initialize a new instance of each possible view within this tournament
    _tournamentHome = new TournamentHome(TournamentInfo: widget.TournamentInfo);
    _tournamentMap = new TournamentMap(TournamentInfo: widget.TournamentInfo);
    _tournamentNotifications = new TournamentNotifications(TournamentInfo: widget.TournamentInfo);
    _tournamentResults = new TournamentResults(TournamentInfo: widget.TournamentInfo);
    _tournamentSchedule = new TournamentSchedule(TournamentInfo: widget.TournamentInfo);

    // Set the page list based on the initialized views
    _tournamentViewPages = [
      _tournamentHome,
      _tournamentMap,
      _tournamentNotifications,
      _tournamentResults,
      _tournamentSchedule,
    ];
  }

  // Build the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.TournamentInfo.name),
      ),
      body: Center(
        child: _tournamentViewPages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: TournamentViewTabs,
        currentIndex: _selectedIndex,
        fixedColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}
