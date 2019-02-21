import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Class imports
import "package:ezra_companion/views/home/TournamentListItem.dart";

class TournamentSchedule extends StatelessWidget {
  final TournamentListItem TournamentInfo;

  const TournamentSchedule({
    Key key,
    this.TournamentInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('This is the schedule page'),
        Text('View more ${TournamentInfo.name}'),
      ],
    );
  }
}
