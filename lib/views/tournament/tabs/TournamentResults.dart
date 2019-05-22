import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

// Consume the Ezra results API, allow people to view results on teams and events from here

// Class imports
import "package:ezra_companion/classes/ErrorPage.dart";
import "package:ezra_companion/classes/TournamentListItem.dart";

class TournamentResults extends StatefulWidget {
    final TournamentListItem tournamentInfo;

    const TournamentResults({
        Key key,
        this.tournamentInfo,
    }) : super(key: key);

    @override
    _TournamentResultsState createState() => _TournamentResultsState();
}

// https://stackoverflow.com/questions/51998995/invalid-arguments-illegal-argument-in-isolate-message-object-is-a-closure
/// A function that converts a response body into a List<Tournament>
List parseApiResponse(String responseBody) {
    final decodedBody = json.decode(responseBody);
    if (decodedBody is List && decodedBody.length > 0) {
        return decodedBody;
    }
    else {
        return [];
    }
}

class _TournamentResultsState extends State<TournamentResults> {
    final AsyncMemoizer _memoizer = AsyncMemoizer();

    int _dropdownIndex;

    List<String> _eventNames;

    TextStyle _rowTextStyle = new TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
    );

    void initState() {
        _dropdownIndex = 0;
        _eventNames = [];
    }

    List<TableRow> createTableRowsFromIndex(List data, int eventIndex) {
        // Event data is not normally sorted from the API, this sorts it by place within the event
        if (eventIndex < 998) {
            data.sort((teamA, teamB) {
                return teamA["name"].compareTo(teamB["name"]);
            });
        }
        else {
            data.sort((teamA, teamB) {
                int teamAScore = teamA["finalScore"];
                int teamBScore = teamB["finalScore"];
                return teamAScore - teamBScore;
            });
        }

        // Create a list of rows based on each team's performance in this event (or a final aspect)
        List<TableRow> tableRows = List<TableRow>.from(data.map((team) {
            String teamName = team["name"];
            String teamPlace;

            List teamEvents = team["events"];

            // Sort each event by name (this is already done by Ezra, but sometimes it isn't perfect for some reason)
            teamEvents.sort((eventA, eventB) {
                return eventA["eventName"].compareTo(eventB["eventName"]);
            });

            // Determine where to look for information that will populate the current row
            if (eventIndex == 998) {
                // Final scores
                teamPlace = "${team["finalScore"] != null ? team["finalScore"] : "N/A"}";
            }
            else if (eventIndex == 999) {
                // Final places
                teamPlace = "${team["finalPlace"] != null ? team["finalPlace"] : "N/A"}";
            }
            else {
                // Regular event
                Map currentEvent = teamEvents[eventIndex];
                teamPlace = "${currentEvent["place"]}";
            }

            // Create a TableRow
            return TableRow(
                children: <TableCell>[
                    TableCell(
                        child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Center(
                                child: Text(
                                    teamName,
                                    style: _rowTextStyle,
                                    textAlign: TextAlign.center,
                                )
                            )
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                        child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Center(
                                child: Text(
                                    teamPlace,
                                    style: _rowTextStyle,
                                    textAlign: TextAlign.center,
                                )
                            )
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                ],
            );
        }));

        // Insert header rows for the table
        tableRows.insert(
            0,
            TableRow(
                decoration: BoxDecoration(
                    color: Colors.red
                ),
                children: <TableCell>[
                    TableCell(
                        child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Center(
                                child: Text(
                                    "Team Name",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                )
                            )
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                    TableCell(
                        child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Center(
                                child: Text(
                                    "Score",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                )
                            )
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                    ),
                ]
            )
        );
        return tableRows;
    }

    // Get event names
    List<DropdownMenuItem> getDropdownChoices(List data) {
        int eventIndex = 0;
        List<DropdownMenuItem> dropdownChoices = List<DropdownMenuItem>.from(
            data[0]["events"].map((currentEvent) {
                DropdownMenuItem item = DropdownMenuItem(
                    child: Text(currentEvent["eventName"]),
                    value: eventIndex,
                );
                eventIndex++;
                return item;
            })
        );
        dropdownChoices.addAll([
            DropdownMenuItem(
                child: Text("Final Scores"),
                value: 998
            ),
            DropdownMenuItem(
                child: Text("Final Places"),
                value: 999
            )
        ]);
        return dropdownChoices;
    }

    Future<List> get tournamentResults async {
        List parsedTournamentResults = await this._memoizer.runOnce(() async {
            // See if results have already been saved for this tournament
            // If they have, pull them up
            // If not, make a request for them
            // If they are there, save them locally
            // If they are not there, save nothing
            http.Client client = http.Client();
            http.Response resultsApiResponse = await client.get("https://www.ezratech.us/competition/${widget.tournamentInfo.key}/api/results");
            if (resultsApiResponse.statusCode == 200) {
                // Parse each event
                final parsedResults = await compute(parseApiResponse, resultsApiResponse.body);

                return parsedResults;
            }
            else {
                String error = json.decode(resultsApiResponse.body)['error'];
                return Future.error(error);
            }
        });
        return parsedTournamentResults;
    }

    @override
    Widget build(BuildContext context) {
        return FutureBuilder(
            future: tournamentResults,
            builder: (context, snapshot) {
                if (snapshot.hasError) {
                    return ErrorPage(
                        errorToShow: snapshot.error is String
                            ? snapshot.error
                            : "There was an unexpected error, please try again."
                    );
                }
                if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                }
                else {
                    if (snapshot.data is List && snapshot.data.length > 0) {
                        return SingleChildScrollView(
                            child: Column(
                                children: <Widget>[
                                    DropdownButton(
                                        items: getDropdownChoices(snapshot.data),
                                        onChanged: (dropdownChoice) {
                                            if (dropdownChoice is int) {
                                                setState(() {
                                                   _dropdownIndex = dropdownChoice;
                                                });
                                            }
                                        },
                                        value: _dropdownIndex,
                                    ),
                                    Table(
                                        border: TableBorder.all(
                                            color: Colors.black,
                                            style: BorderStyle.solid,
                                            width: 1.0
                                        ),
                                        children: createTableRowsFromIndex(snapshot.data, _dropdownIndex)
                                    )
                                ],
                            )
                        );
                    }
                    else {
                        TextStyle _rowTextStyle = new TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                        );
                        // no data
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
                                        style: _rowTextStyle,
                                        textAlign: TextAlign.center
                                    ),
                                ]
                            )
                        );
                    }
                }
            }
        );
    }
}
