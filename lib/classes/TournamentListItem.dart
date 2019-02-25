import 'package:date_format/date_format.dart';

// This class consumes information from Ezra and stores it in an easily-accessible manner
// Aims to decrease the number of API requests we send back to Ezra
// TODO: Write helper functions, like for the location or content, rather than formatting each field individually in a Widget
class TournamentListItem {
  final Map content;
  final String date;
  final String id;
  final String key;
  final Map location;
  final String name;

  /// Constructor
  TournamentListItem({
    this.content,
    this.date,
    this.id,
    this.key,
    this.location,
    this.name,
  });

  String get shortName {
    String shortName = name;

    // If it's a regional, we can remove what's before it
    if (name.contains('Regional') && name.contains('-')) {
      shortName = name.split('-')[1];
    }

    return shortName;
  }

  /// Formats the date of the tournament to be a human readable form
  /// January 1, 2019
  String get formattedDate {
    return formatDate(DateTime.parse(date), [MM, ' ', d, ', ', yyyy]);
  }

  /// Formats the location of the tournament to be a human readable form
  /// Cornell University
  /// 123 East Avenue
  /// Ithaca, NY 14853
  List<String> get formattedLocation {
    // Extract information from the tournament location
    String buildingName = location['name'] != null ? location['name'] : "";
    String street1 = location['street1'] != null ? location['street1'] : "";
    String city = location['suburb'] != null ? location['suburb'] : "";
    String state = location['state'] != null ? location['state'] : "";
    String zipcode = location['postcode'] != null ? location['postcode'] : "";

    return [
      buildingName,
      street1,
      "$city, $state $zipcode"
    ];
  }

  factory TournamentListItem.fromJson(Map<String, dynamic> json) {
    return TournamentListItem(
      content: json['content'],
      date: json['date'],
      id: json['_id'],
      key: json['key'],
      location: json['location'],
      name: json['name']
    );
  }
}
