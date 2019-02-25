import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Class imports
import "package:ezra_companion/classes/TournamentListItem.dart";

class TournamentSchedule extends StatelessWidget {
  final TournamentListItem tournamentInfo;

  const TournamentSchedule({
    Key key,
    this.tournamentInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('This is the schedule page'),
        Text('View more ${tournamentInfo.name}'),
      ],
    );
  }
}
