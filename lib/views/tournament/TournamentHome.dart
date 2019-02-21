//import 'dart:async';
//import 'dart:convert';
//import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Class imports
import "package:ezra_companion/views/home/TournamentListItem.dart";

class TournamentHome extends StatelessWidget {
  final TournamentListItem TournamentInfo;

  TournamentHome({Key key, @required this.TournamentInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.map)),
                Tab(icon: Icon(Icons.calendar_today)),
                Tab(icon: Icon(Icons.stars)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
            title: Text(TournamentInfo.name),
          ),
          body: TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
              Icon(Icons.date_range),
              Icon(Icons.zoom_out_map),
            ],
          ),
        ),
      ),
    );
  }
}
