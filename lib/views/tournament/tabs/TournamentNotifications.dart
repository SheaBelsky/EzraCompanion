import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Allow people to opt into notifications from this tournament

// Allow staff members to enter a password that will opt them into staff-only notifications

// Class imports
import "package:ezra_companion/classes/TournamentListItem.dart";

class TournamentNotifications extends StatelessWidget {
  final TournamentListItem tournamentInfo;

  const TournamentNotifications({
    Key key,
    this.tournamentInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('This is the notifications page'),
        Text('View more ${tournamentInfo.name}'),
      ],
    );
  }
}
