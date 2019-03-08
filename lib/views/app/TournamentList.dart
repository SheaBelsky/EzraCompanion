import 'dart:async';
import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Class imports
import "package:ezra_companion/classes/TournamentListItem.dart";

// Route imports
import "package:ezra_companion/views/tournament/TournamentView.dart";

/// Make a request to Ezra and get a list of tournaments
/// TODO: Store the results of this locally, check for new tournaments every so often (every week?)
Future<List<TournamentListItem>> fetchTournaments(http.Client client) async {
  final response = await client.get('https://www.ezratech.us/api/tournaments/search?appOptIn=true');

  if (response.statusCode == 200) {
    // Use the compute function to run parseTournaments
    // Depends on package:flutter/foundation:dart
    return compute(parseTournaments, response.body);
  }
  else {
    // TODO: Error handling? How?
    print(response);
  }
}

/// A function that converts a response body into a List<Tournament>
List<TournamentListItem> parseTournaments(String responseBody) {
  final decodedBody = json.decode(responseBody);
  // The API returns all the competitions in the 'competitions' property of the object.
  // It is necessary to access that before parsing anything as a Tournament.
  final parsed = decodedBody.cast<Map<String, dynamic>>();

  // Parse each tournament as an instantiation of the TournamentListItem class
  return parsed.map<TournamentListItem>((json) => TournamentListItem.fromJson(json)).toList();
}

/// Represents a list of tournaments
class TournamentList extends StatelessWidget {
  final Function addFavorite;
  final Function removeFavorite;
  final List favoriteTournaments;
  final List tournaments;

  TournamentList({
    Key key,
    this.addFavorite,
    this.removeFavorite,
    this.favoriteTournaments,
    this.tournaments
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Return a ListView composed of Tournaments
    return ListView.builder(
      itemCount: tournaments.length,
      itemBuilder: (context, index) {
        // Create a ListTile for this Tournament
        String formattedDate = formatDate(DateTime.parse(tournaments[index].date), [MM, ' ', d, ', ', yyyy]);
        // Format the date for display purposes
        return ListTile(
          subtitle: Text(formattedDate),
          title: Text(tournaments[index].name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  TournamentListItem currentTournament = tournaments[index];
                  return TournamentView(
                    addFavorite: addFavorite,
                    isFavorited: favoriteTournaments.contains(currentTournament.ezraId),
                    removeFavorite: removeFavorite,
                    tournamentInfo: currentTournament
                  );
                }
              ),
            );
          }
        );
      },
    );
  }
}
