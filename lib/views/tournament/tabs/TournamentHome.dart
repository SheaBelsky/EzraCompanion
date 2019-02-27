import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;

// View event description, date, location? what else?

// Class imports
import "package:ezra_companion/classes/TournamentListItem.dart";

// Used to display text as a header and subtitle
class TournamentHomeTextItem extends StatelessWidget {
  final String heading;
  final List<String> text;

  TournamentHomeTextItem({
    Key key,
    this.heading,
    this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Start off the list of children with a header
    List<Widget> children = [
      RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: heading,
              style: textTheme.headline
          )
      ),
    ];

    // Add each string as a text element to the children
    text.forEach((String string) => children.add(
        Text(
            string,
            textAlign: TextAlign.center
        )
    ));

    // Some padding to separate sections of text
    children.add(SizedBox(height: 30));

    return Column(
      children: children
    );
  }
}

class TournamentHome extends StatelessWidget {
  final TournamentListItem tournamentInfo;

  const TournamentHome({
    Key key,
    this.tournamentInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> listChildren = [
      TournamentHomeTextItem(
          heading: "Tournament Name",
          text: [
            tournamentInfo.name
          ]
      ),
      TournamentHomeTextItem(
          heading: "Tournament Date",
          text: [
            tournamentInfo.formattedDate
          ]
      ),
      TournamentHomeTextItem(
          heading: "Tournament Location",
          text: [
            tournamentInfo.location
          ]
      ),
    ];
    if (tournamentInfo.description != null) {
      listChildren.add(TournamentHomeTextItem(
          heading: "Tournament Information",
          text: [
            parse(tournamentInfo.description).body.text
          ]
      ));
    }
    return ListView(
      children: listChildren
    );
  }
}
