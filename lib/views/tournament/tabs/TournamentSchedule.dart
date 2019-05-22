import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

// Consume the Ezra schedule API, allow people to view their schedule based on their team number

// Class imports
import "package:ezra_companion/classes/ErrorPage.dart";
import "package:ezra_companion/classes/TournamentListItem.dart";

class TournamentSchedule extends StatefulWidget {
    final fileStorage;
    final TournamentListItem tournamentInfo;

    const TournamentSchedule({
        Key key,
        this.fileStorage,
        this.tournamentInfo,
    }) : super(key: key);

    @override
    _TournamentSchedueleState createState() => _TournamentSchedueleState();
}

// https://stackoverflow.com/questions/51998995/invalid-arguments-illegal-argument-in-isolate-message-object-is-a-closure
// A function that converts a response body into a List
List parseApiResponse(String responseBody) {
    final decodedBody = json.decode(responseBody);
    if (decodedBody['events'] is List && decodedBody['events'].length > 0) {
        return decodedBody['events'];
    }
    else {
        return [];
    }
}

class _TournamentSchedueleState extends State<TournamentSchedule> {
    final AsyncMemoizer _memoizer = AsyncMemoizer();

    String _error;

    List<String> _eventNames;

    int _teamNumber = 0;

    final _teamNumberController = TextEditingController();

    TextStyle _rowHeaderStyle = new TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
    );

    TextStyle _rowTextStyle = new TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w300,
        color: Colors.black45,
    );

    void initState() {
        _error = '';
        _eventNames = [];
    }

    List<TableRow> createTableRows(List events) {
        // Create a list of rows based on each team's performance in this event (or a final aspect)
        List<TableRow> tableRows = List<TableRow>.from(
            events.map((event) {
                // Create a TableRow
                String formattedTimeString = '';
                Map times = new Map<String, dynamic>.from(event['times']);
                times.keys.forEach((timeKey) {
                   formattedTimeString = times[timeKey]['formattedTimeString'];
                });
                return TableRow(
                    children: <TableCell>[
                        TableCell(
                            child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Column(
                                    children: <Widget>[
                                        Text(
                                            event['name'],
                                            style: _rowHeaderStyle,
                                            textAlign: TextAlign.center,
                                        ),
                                        Text(
                                            formattedTimeString,
                                            style: _rowTextStyle,
                                            textAlign: TextAlign.center,
                                        ),
                                        Divider(
                                            height: 20
                                        )
                                    ],
                                )
                            ),
                            verticalAlignment: TableCellVerticalAlignment.middle,
                        ),
                    ],
                );
            })
        );
        return tableRows;
    }

    Widget resetTeamNumber() {
        return RaisedButton(
            child: Text("Reset Team Number"),
            onPressed: () {
                widget.fileStorage.updateFile("teamNumber", "0")
                    .then((Map newState) {
                    setState(() {
                        _teamNumber = 0;
                    });
                });
            },
            padding: const EdgeInsets.all(9.0),
        );
    }

    FutureBuilder tournamentScheduleFuture(int teamNumber) {
        return FutureBuilder(
            future: getTournamentSchedule(teamNumber),
            builder: (context, scheduleSnapshot) {
                if (scheduleSnapshot.hasError) {
                    return ErrorPage(
                        children: <Widget>[
                            resetTeamNumber()
                        ],
                        errorToShow: scheduleSnapshot.error,
                    );
                }
                if (!scheduleSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                }
                else {
                    if (scheduleSnapshot.data is List && scheduleSnapshot.data.length > 0) {
                        return SingleChildScrollView(
                            child: Column(
                                children: <Widget>[
                                    Table(
                                        children: createTableRows(scheduleSnapshot.data)
                                    ),
                                    resetTeamNumber()
                                ],
                            )
                        );
                    }
                    else {
                        return ErrorPage(
                            children: [
                                resetTeamNumber()
                            ],
                            errorToShow: "There was an error displaying events for your team, please try again.",
                        );
                    }
                }
            }
        );
    }

    Future<int> getTeamNumber() async {
        String teamNumber = await widget.fileStorage.getValue("teamNumber");
        if (teamNumber != null) {
            return int.parse(teamNumber);
        }
        else {
            return 0;
        }
    }

    Future<List> getTournamentSchedule(int teamNumberInput) async {
        // See if this team's schedule has already been saved for this tournament
        // If it has, pull it up
        // If not, make a request for them
        // If they are there, save them locally
        // If they are not there, save nothing
        http.Client client = http.Client();
        String requestUrl = "https://www.ezratech.us/competition/${widget.tournamentInfo.key}/schedule/teamNumber/$teamNumberInput";
        http.Response scheduleApiResponse = await client.get(requestUrl);
        if (scheduleApiResponse.statusCode == 200) {
            // Parse each event
            final parsedResults = await compute(parseApiResponse, scheduleApiResponse.body);
            return parsedResults;
        }
        else {
            String error = json.decode(scheduleApiResponse.body)['error'];
            return Future.error(error);
        }
    }

    @override
    Widget build(BuildContext context) {
        final TextTheme textTheme = Theme.of(context).textTheme;
        return FutureBuilder(
            future: getTeamNumber(),
            builder: (context, teamNumberSnapshot) {
                if (teamNumberSnapshot.hasError) {
                    return ErrorPage(
                        children: [
                            resetTeamNumber()
                        ],
                        errorToShow: teamNumberSnapshot.error is String
                            ? teamNumberSnapshot.error
                            : "There was an unexpected error, please try again."
                    );
                }
                if (!teamNumberSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                }
                else {
                    int teamNumber = teamNumberSnapshot.data;
                    if (teamNumber == 0) {
                        return Padding(
                            padding: new EdgeInsets.all(25.0),
                            child: Column(
                                children: <Widget>[
                                    RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            text: "Tournament Schedule",
                                            style: textTheme.headline
                                        )
                                    ),
                                    Text("Enter your team number to see your team's customized schedule."),
                                    TextField(
                                        controller: _teamNumberController,
                                        decoration: new InputDecoration(
                                            alignLabelWithHint: true,
                                            labelText: "Enter your team number",
                                            labelStyle: _rowTextStyle
                                        ),
                                        keyboardType: TextInputType.number,
                                        maxLength: 2,
                                        maxLines: 1,
                                        minLines: 1,
                                    ),
                                    // if not subscribed, ask person to subscribe
                                    // if subscribed, ask person to unsubscribe
                                    RaisedButton(
                                        child: Text("Get Schedule"),
                                        onPressed: () {
                                            widget.fileStorage.updateFile("teamNumber", _teamNumberController.text)
                                                .then((Map newState) {
                                                    setState(() {
                                                        _teamNumber = int.parse(_teamNumberController.text);
                                                    });
                                            });
                                        },
                                        padding: const EdgeInsets.all(9.0),
                                    )
                                ],
                            )
                        );
                    }
                    else {
                        return tournamentScheduleFuture(teamNumber);
                    }
                }
            }
        );
    }
}
