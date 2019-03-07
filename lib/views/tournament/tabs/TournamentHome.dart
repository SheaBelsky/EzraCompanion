import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

// View event description, date, location? what else?

// Class imports
import "package:ezra_companion/classes/TournamentListItem.dart";

// Used to display text as a header and subtitle
class TournamentHomeTextItem extends StatelessWidget {
  final Widget childWidget;
  final String heading;
  final List<String> text;

  TournamentHomeTextItem({
    Key key,
    this.childWidget,
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

    if (text is List) {
      // Add each string as a text element to the children
      text.forEach((String string) => children.add(
          Text(
              string,
              textAlign: TextAlign.center
          )
      ));
    }
    else if (childWidget is Widget) {
      children.add(childWidget);
    }

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
      HtmlView description = new HtmlView(
          data: tournamentInfo.description,
          scrollable: false
      );
      listChildren.add(TournamentHomeTextItem(
          heading: "Tournament Description",
          childWidget: description
      ));
    }
    return ListView(
      children: listChildren
    );
  }
}
