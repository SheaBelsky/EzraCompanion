// Dart packages
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Class import
import "package:ezra_companion/classes/TournamentListItem.dart";

/// A specific FileStorage instance is created for each unique tournament that this user visits.
/// It is not required for there to be a tournament associated with the file storage ()
class FileStorage {
  final TournamentListItem tournamentInfo;

  // Constructor
  FileStorage({
    this.tournamentInfo
  });

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future getValue(String key) async {
    Map file = await readFile();
    if (file.containsKey(key)) {
      return file[key];
    }
    else {
      return null;
    }
  }

  // The file is stored relative to the key of the tournament
  Future<File> get _localFile async {
    final path = await _localPath;
    try {
      if (tournamentInfo != null) {
        // If there is tournament information, this state is being maintained for a specific tournament
        return File("$path/state_${tournamentInfo.key}.txt");
      }
      else {
        // If there is not tournament information, this is assumed to be part of the global app state
        return File("$path/state_global.txt");
      }
    }
    catch (e) {
      return null;
    }
  }

  // Read from the file and return its contents as a Map
  Future<Map> readFile() async {
    try {
      final file = await _localFile;

      if (file is File) {
        String contents = await file.readAsString();

        Map parsedContents = json.decode(contents);

        return parsedContents;
      }
      else {
        return new Map();
      }
    }
    catch (e) {
      return new Map();
    }
  }

  /// Team number, specified events, and if they have opted into notifications
  /// already (to hide the buttons.) The server should already know if they
  /// have subscribed to a specific topic, so this information should not be
  /// saved client-side (and it would be dangerous to do so.)
  Future<Map> updateFile (String key, value) async {
    // Get the local file
    final file = await _localFile;
    final fileContents = await readFile();

    // Update the Map
    fileContents.update(
      key,
      (e) {
        return value;
      },
      ifAbsent: () {
        return value;
      }
    );

    // Stringify the map
    String updatedContents = json.encode(fileContents);

    // Update the file
    await file.writeAsString("$updatedContents");

    // Return the updated map
    return fileContents;
  }

  /// Resets the state of the file
  Future<Map> resetState () async {
    // Get the local file
    final file = await _localFile;

    final newFileContents = new Map();

    // Stringify the map
    String updatedContents = json.encode(newFileContents);

    // Update the file
    await file.writeAsString("$newFileContents");

    // Return the updated map
    return newFileContents;
  }
}
