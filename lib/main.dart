import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// Class imports
import "package:ezra_companion/views/home/TournamentListItem.dart";

// Route imports
import "package:ezra_companion/views/home/TournamentList.dart";

// Firebase Analytics
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

// Firebase Messaging
import 'package:firebase_messaging/firebase_messaging.dart';
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) {
      iOSPermission();
    }

    _firebaseMessaging.getToken().then((token){
      print("token $token");
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Set up push notifications with Firebase
    firebaseCloudMessagingListeners();

    // Create the app
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: MyHomePage(
          title: 'Flutter Demo Shea Home Page',
          storage: CounterStorage(),
          analytics: analytics,
          observer: observer,
      ),
      navigatorObservers: <NavigatorObserver>[observer],
    );
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File("$path/counter.txt");
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      String contents = await file.readAsString();

      return int.parse(contents);
    }
    catch (e) {
      return 0;
    }
  }

  Future<File> writeCounter (int counter) async {
    final file = await _localFile;
    return file.writeAsString("$counter");
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final CounterStorage storage;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  MyHomePage({
    Key key,
    this.title,
    this.analytics,
    this.observer,
    @required this.storage
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(analytics, observer);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(this.analytics, this.observer);

  int _counter = 0;
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<TournamentListItem>>(
          future: fetchTournaments(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }

            // If there is data, return a TournamentList
            // If not, return a progress indicator until the data is returned
            return snapshot.hasData
                ? TournamentList(tournaments: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        )
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("I am a different page"),
      ),
      body: Center(
        child: RaisedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          label: Text("go back"),
          icon: new Icon(FontAwesomeIcons.creditCard)
        ),
      )
    );
  }
}
