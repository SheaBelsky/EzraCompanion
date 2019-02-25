import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Allow people to open a map of the tournament if it is specified by an organizer (need to embed custom image and allow zooming, scrolling, etc.)
// If no map is specified, consume the event location and handoff to the default map client

// Class imports
import "package:ezra_companion/classes/TournamentListItem.dart";

class TournamentMap extends StatelessWidget {
  final TournamentListItem tournamentInfo;

  const TournamentMap({
    Key key,
    this.tournamentInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('This is the map page'),
        Text('View more ${tournamentInfo.name}'),
      ],
    );
  }
}
