class TournamentListItem {
  final Map content;
  final String date;
  final String id;
  final String key;
  final Map location;
  final String name;

  TournamentListItem({
    this.content,
    this.date,
    this.id,
    this.key,
    this.location,
    this.name,
  });

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
