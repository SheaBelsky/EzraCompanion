import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Allow people to opt into notifications from this tournament

// Allow staff members to enter a password that will opt them into staff-only notifications

// Class imports
import "package:ezra_companion/classes/TournamentListItem.dart";

class Favorites extends StatelessWidget {
  const Favorites({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('This is the favorites page. Click the Favorite button in the top-right of any tournament to have it appear here!'),
      ],
    );
  }
}
