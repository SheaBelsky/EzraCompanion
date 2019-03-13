import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Class imports
import "package:ezra_companion/classes/TournamentListItem.dart";

class TournamentSchedule extends StatelessWidget {
    final firebaseManager;
    final TournamentListItem tournamentInfo;

    const TournamentSchedule({
        Key key,
        this.firebaseManager,
        this.tournamentInfo,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        TextStyle textStyle = new TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
        );
        return Padding(
            padding: new EdgeInsets.all(25.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    new Icon(Icons.calendar_today),
                    SizedBox(height: 30),
                    new Text(
                        "Coming soon!",
                        style: textStyle,
                        textAlign: TextAlign.center
                    ),
                ]
            )
        );
    }
}
