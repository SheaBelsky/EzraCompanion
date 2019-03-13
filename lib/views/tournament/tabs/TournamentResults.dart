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
                    new Icon(Icons.stars),
                    SizedBox(height: 30),
                    new Text(
                        "Results from this tournament will be available after the conclusion of the tournament. Check back here to see them when they've been released!",
                        style: textStyle,
                        textAlign: TextAlign.center
                    ),
                ]
            )
        );
    }
}
