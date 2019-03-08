import "dart:convert";
import "package:date_format/date_format.dart";

// This class consumes information from Ezra and stores it in an easily-accessible manner
// Aims to decrease the number of API requests we send back to Ezra
// TODO: Write helper functions, like for the location or content, rather than formatting each field individually in a Widget
class TournamentListItem {
  final String description;
  final String date;
  final String ezraId;
  final String key;
  final String location;
  final String name;
  final String venueMapExtension;
  final String venueMapUrl;

  /// Constructor
  TournamentListItem({
    this.description,
    this.date,
    this.ezraId,
    this.key,
    this.location,
    this.name,
    this.venueMapExtension,
    this.venueMapUrl,
  });


  /// Formats the date of the tournament to be a human readable form
  /// January 1, 2019
  String get formattedDate {
    return formatDate(DateTime.parse(date), [MM, " ", d, ", ", yyyy]);
  }

  /// Return the shorter version of this tournament's name
  String get shortName {
    String shortName = name;

    // If it"s a regional, we can remove what"s before it
    if (name.contains("Regional") && name.contains("-")) {
      shortName = name.split("-")[1];
    }

    return shortName;
  }


  factory TournamentListItem.fromJson(Map<String, dynamic> inputJson) {
    return TournamentListItem(
      description: inputJson["description"],
      date: inputJson["date"],
      ezraId: inputJson["ezraId"],
      key: inputJson["key"],
      location: inputJson["location"],
      name: inputJson["name"],
      venueMapExtension: inputJson["venueMapExtension"],
      venueMapUrl: inputJson["venueMapUrl"],
    );
  }

  /// Converts this TournamentListItem to a JSON
  Map toJson() {
    Map returnMap = {
      "description": description != null ? description : "",
      "date": date != null ? date : "",
      "ezraId": ezraId != null ? ezraId : "",
      "key": key != null ? key : "",
      "location": location != null ? location : "",
      "name": name != null ? name : "",
      "venueMapExtension": venueMapExtension != null ? venueMapExtension : "",
      "venueMapUrl": venueMapUrl != null ? venueMapUrl : "",
    };
    return returnMap;
  }
}
