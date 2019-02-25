import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Consume the Ezra results API, allow people to view results on teams and events from here

// Class imports
import "package:ezra_companion/classes/TournamentListItem.dart";

class TournamentResults extends StatelessWidget {
  final TournamentListItem tournamentInfo;

  const TournamentResults({
    Key key,
    this.tournamentInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('This is the results page'),
        Text('View more ${tournamentInfo.name}'),
      ],
    );
  }
}
