import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
    final Function handleResetButtonPress;

    const Settings({
        Key key,
        this.handleResetButtonPress
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        final TextTheme textTheme = Theme.of(context).textTheme;

        return Center(
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                    children: <Widget>[
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: "About",
                                style: textTheme.headline
                            )
                        ),
                        Text('The Ezra Companion is the official app for Ezra, the premier Science Olympiad tournament management system.'),
                        SizedBox(height: 30),
                        Text('Use this app to instantly view important information about a tournament, see a map of the tournament if available, and receive push notifications from tournament organizers.'),
                        SizedBox(height: 30),
                        Text('If you are experiencing issues with the app, please press the below button to file a support ticket on our website.'),
                        SizedBox(height: 30),
                        RaisedButton(
                            child: Text("Create Support Ticket"),
                            onPressed: () {
                                launch('https://www.ezratech.us/support');
                            }
                        )
                    ],
                )
            )
        );
    }
}
