// Dart packages
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Class import
import "package:ezra_companion/views/home/TournamentListItem.dart";

// A specific FileStorage instance is created for each unique tournament that this user visits.
class FileStorage {
  final TournamentListItem tournamentInfo;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // The file is stored relative to the key of the tournament
  Future<File> get _localFile async {
    final path = await _localPath;
    return File("$path/${tournamentInfo.key}/counter.txt");
  }

  // Read from the file and return its contents as a Map
  Future<Map> readFile() async {
    try {
      final file = await _localFile;

      String contents = await file.readAsString();

      Map parsedContents = json.decode(contents);

      return parsedContents;
    }
    catch (e) {
      return new Map();
    }
  }

  // Team number, specified events, and if they have opted into notifications
  // already (to hide the buttons.) The server should already know if they
  // have subscribed to a specific topic, so this information should not be
  // saved client-side (and it would be dangerous to do so.)
  Future<File> writeFile (Map file) async {
    final file = await _localFile;

    String contents = json.encode(file);

    return file.writeAsString("$contents");
  }

  // Constructor
  FileStorage({
    this.tournamentInfo
  });
}
