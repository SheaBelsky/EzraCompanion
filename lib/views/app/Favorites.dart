import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:ezra_companion/classes/TournamentListItem.dart';

// Route imports
import "package:ezra_companion/views/tournament/TournamentView.dart";

class Favorites extends StatelessWidget {
  final Function addFavorite;
  final Function removeFavorite;
  final List tournaments;

  const Favorites({
    Key key,
    this.addFavorite,
    this.removeFavorite,
    this.tournaments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Return a ListView composed of Tournaments
    if (tournaments.length > 0) {
      return ListView.builder(
        itemCount: tournaments.length,
        itemBuilder: (context, index) {
          // Create a ListTile for this Tournament
          String formattedDate = formatDate(DateTime.parse(tournaments[index].date), [MM, ' ', d, ', ', yyyy]);
          // Format the date for display purposes
          return ListTile(
            leading: Icon(Icons.favorite),
            subtitle: Text(formattedDate),
            title: Text(tournaments[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return TournamentView(
                      addFavorite: addFavorite,
                      isFavorited: true,
                      removeFavorite: removeFavorite,
                      tournamentInfo: tournaments[index]
                    );
                  }
                ),
              );
            }
          );
        },
      );
    }
    else {
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
            new Icon(Icons.favorite_border),
            SizedBox(height: 30),
            new Text(
              "You don't have any favorite tournaments yet!",
              style: textStyle,
              textAlign: TextAlign.center
            ),
            SizedBox(height: 30),
            new Text(
              "Click the favorite button in the top-right of a tournament to put it here!",
              style: textStyle,
              textAlign: TextAlign.center
            ),
          ]
        )
      );
    }
  }
}
