import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Allow people to opt into notifications from this tournament

// Allow staff members to enter a password that will opt them into staff-only notifications

// Class imports
import "package:ezra_companion/classes/TournamentListItem.dart";

class Settings extends StatelessWidget {
  final Function handleResetButtonPress;
  const Settings({
    Key key,
    this.handleResetButtonPress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('This is the settings page'),
        RaisedButton(
          child: Text("reset"),
          onPressed: (() async {
            await handleResetButtonPress();
            // alert to something...
            print('done');
          }),
        )
      ],
    );
  }
}
