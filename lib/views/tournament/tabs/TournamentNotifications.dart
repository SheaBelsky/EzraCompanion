import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Allow people to opt into notifications from this tournament

// Allow staff members to enter a password that will opt them into staff-only notifications

// Class imports
import "package:ezra_companion/views/home/TournamentListItem.dart";

class TournamentNotifications extends StatelessWidget {
  final TournamentListItem TournamentInfo;

  const TournamentNotifications({
    Key key,
    this.TournamentInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('This is the notifications page'),
        Text('View more ${TournamentInfo.name}'),
      ],
    );
  }
}
