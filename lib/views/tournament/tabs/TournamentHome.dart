import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// View event description, date, location? what else?

// Class imports
import "package:ezra_companion/views/home/TournamentListItem.dart";

class TournamentHome extends StatelessWidget {
  final TournamentListItem TournamentInfo;

  const TournamentHome({
    Key key,
    this.TournamentInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('This is the home page'),
        Text('View more ${TournamentInfo.name}'),
      ],
    );
  }
}
