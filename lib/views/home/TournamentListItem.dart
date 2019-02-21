class TournamentListItem {
  final String id;
  final String date;
  final String key;
  final String name;

  TournamentListItem({
    this.id,
    this.date,
    this.key,
    this.name
  });

  factory TournamentListItem.fromJson(Map<String, dynamic> json) {
    return TournamentListItem(
      id: json['_id'],
      date: json['date'],
      key: json['key'],
      name: json['name'],
    );
  }
}
