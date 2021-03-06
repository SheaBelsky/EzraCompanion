import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Allow people to open a map of the tournament if it is specified by an organizer (need to embed custom image and allow zooming, scrolling, etc.)
// If no map is specified, consume the event location and handoff to the default map client

// Class imports
import "package:ezra_companion/classes/TournamentListItem.dart";

class TournamentMap extends StatelessWidget {
  final TournamentListItem tournamentInfo;

  TournamentMap({
    Key key,
    this.tournamentInfo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String venueMapExtension = tournamentInfo.venueMapExtension;
    String venueMapUrl = tournamentInfo.venueMapUrl;

    String googleDocsLink = "https://docs.google.com/gview?embedded=true&url=$venueMapUrl";
    if (venueMapExtension.length > 0 && venueMapUrl.length > 0) {
      // Display the map here
      switch(venueMapExtension) {
        case 'pdf':
          return WebView(
            initialUrl: googleDocsLink,
            javascriptMode: JavascriptMode.unrestricted,
          );
        case 'jpg':
        case 'jpeg':
        case 'png':
          break;
        default:
          print(tournamentInfo);
          print("default");
          break;
      }
    }
    else {
      TextStyle pageTextStyle = new TextStyle(
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
                new Icon(Icons.map),
                SizedBox(height: 30),
                new Text(
                    "No map has been provided for this tournament; ask your organizers to upload one, then you'll see it here!",
                    style: pageTextStyle,
                    textAlign: TextAlign.center
                ),
              ]
          )
      );
    }
  }
}
