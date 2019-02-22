import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;

// View event description, date, location? what else?

// Class imports
import "package:ezra_companion/views/home/TournamentListItem.dart";

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
  final TournamentListItem TournamentInfo;

  const TournamentHome({
    Key key,
    this.TournamentInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    // Extract information from the tournament location
    String buildingName = TournamentInfo.location['name'];
    String street1 = TournamentInfo.location['street1'];
    String city = TournamentInfo.location['suburb'];
    String state = TournamentInfo.location['state'];
    String zipcode = TournamentInfo.location['postcode'];

    return ListView(
//      mainAxisAlignment: MainAxisAlignment.center
      children: <Widget>[
        TournamentHomeTextItem(
            heading: "Tournament Name",
            text: [
              TournamentInfo.name
            ]
        ),
        TournamentHomeTextItem(
            heading: "Tournament Date",
            text: [
              formatDate(DateTime.parse(TournamentInfo.date), [MM, ' ', d, ', ', yyyy])
            ]
        ),
        TournamentHomeTextItem(
            heading: "Tournament Location",
            text: [
              buildingName,
              street1,
              "$city, $state $zipcode"
            ]
        ),
        TournamentHomeTextItem(
          heading: "Tournament Information",
          text: [
            parse(TournamentInfo.content["extended"]).body.text
          ]
        )
      ],
    );
  }
}
