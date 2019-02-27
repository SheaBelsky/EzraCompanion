import "dart:convert";
import "package:date_format/date_format.dart";

// This class consumes information from Ezra and stores it in an easily-accessible manner
// Aims to decrease the number of API requests we send back to Ezra
// TODO: Write helper functions, like for the location or content, rather than formatting each field individually in a Widget
class TournamentListItem {
  final String description;
  final String date;
  final String id;
  final String key;
  final String location;
  final String name;

  /// Constructor
  TournamentListItem({
    this.description,
    this.date,
    this.id,
    this.key,
    this.location,
    this.name,
  });

  String get shortName {
    String shortName = name;

    // If it"s a regional, we can remove what"s before it
    if (name.contains("Regional") && name.contains("-")) {
      shortName = name.split("-")[1];
    }

    return shortName;
  }

  /// Formats the date of the tournament to be a human readable form
  /// January 1, 2019
  String get formattedDate {
    return formatDate(DateTime.parse(date), [MM, " ", d, ", ", yyyy]);
  }

  factory TournamentListItem.fromJson(Map<String, dynamic> inputJson) {
    String location;
    try {
      Map jsonLocation = new Map<dynamic, dynamic>.from(inputJson["location"]);
      String buildingName = jsonLocation["name"] != null ? jsonLocation["name"] : "";
      String street1 = jsonLocation["street1"] != null ? jsonLocation["street1"] : "";
      String city = jsonLocation["suburb"] != null ? jsonLocation["suburb"] : "";
      String state = jsonLocation["state"] != null ? jsonLocation["state"] : "";
      String zipcode = jsonLocation["postcode"] != null ? jsonLocation["postcode"] : "";
      location = "$buildingName $street1, $city $state $zipcode";
    }
    catch (e) {
      print("Error in parsing tournament location:");
      print(e);
      print("Input JSON");
      print(inputJson);
      print("----");
      location = "";
    }

    return TournamentListItem(
      description: inputJson["description"],
      date: inputJson["date"],
      id: inputJson["_id"],
      key: inputJson["key"],
      location: location,
      name: inputJson["name"]
    );
  }

  /// Converts this TournamentListItem to a JSON
  Map toJson() {
    Map returnMap = {
      "description": description != null ? description : "",
      "date": date != null ? date : "",
      "id": id != null ? id : "",
      "key": key != null ? key : "",
      "location": location != null ? location : "",
      "name": name != null ? name : ""
    };
    return returnMap;
  }
}
