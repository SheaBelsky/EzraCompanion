import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Allow people to opt into notifications from this tournament

// Allow staff members to enter a password that will opt them into staff-only notifications

// Class imports
import "package:ezra_companion/classes/TournamentListItem.dart";

class TournamentNotifications extends StatefulWidget {
  final bool isSubscribedPublic;
  final bool isSubscribedStaff;
  final TournamentListItem tournamentInfo;
  final Function updateSubscriptionStatus;

  TournamentNotifications({
    Key key,
    this.isSubscribedPublic,
    this.isSubscribedStaff,
    this.tournamentInfo,
    this.updateSubscriptionStatus
  }) : super(key: key);

  @override
  _TournamentNotificationsState createState() => _TournamentNotificationsState();
}

class _TournamentNotificationsState extends State<TournamentNotifications> {

  bool _isSubscribedPublic;
  bool _isSubscribedStaff;

  void initState() {
    _isSubscribedPublic = widget.isSubscribedPublic;
    _isSubscribedStaff = widget.isSubscribedStaff;
  }

  @override
  Widget build(BuildContext context) {
    String buttonTextPublic = _isSubscribedPublic
      ? "Unsubscribe from Public Notifications"
      : "Subscribe to Public Notifications";

    String buttonTextStaff = _isSubscribedStaff
      ? "Unsubscribe from Staff Push Notifications"
      : "Subscribe to Staff Push Notifications";

    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: <Widget>[
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Tournament Notifications",
            style: textTheme.headline
          )
        ),
        Text('Press the below button to subscribe or unsubscribe to public push notifications from the organizers of this tournament!'),
        // if not subscribed, ask person to subscribe
        // if subscribed, ask person to unsubscribe
        RaisedButton(
          child: Text(buttonTextPublic),
          onPressed: () {
            // Update with Firebase
            widget.updateSubscriptionStatus();
            // Change the text of the subscribe button
            setState(() {
              _isSubscribedPublic = !_isSubscribedPublic;
            });
          },
          padding: const EdgeInsets.all(9.0),
        )
      ],
    );
  }
}
