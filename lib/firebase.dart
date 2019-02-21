// Dart imports
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Firebase Analytics
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

// Firebase Messaging
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseManager {
  static FirebaseAnalytics _analytics = FirebaseAnalytics();
  static FirebaseMessaging _messaging = FirebaseMessaging();
  static FirebaseAnalyticsObserver _observer = FirebaseAnalyticsObserver(analytics: _analytics);

  void iOSPermission() {
    _messaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _messaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void setupFirebase() {
    if (Platform.isIOS) {
      iOSPermission();
    }

    _messaging.getToken().then((token){
      print("token $token");
    });

    _messaging.configure(
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

  // Getters
  FirebaseAnalytics get analytics {
    return _analytics;
  }

  FirebaseAnalyticsObserver get observer {
    return _observer;
  }

  FirebaseMessaging get messaging {
    return _messaging;
  }

  // Messaging
  void subscribeToTopic(String topic) {
    _messaging.subscribeToTopic(topic);
  }

  void unsubscribeFromTopic(String topic) {
    _messaging.unsubscribeFromTopic(topic);
  }

  // Analytics
  Future<void> _testSetUserId() async {
    await _analytics.setUserId('some-user');
  }

  Future<void> _testSetCurrentScreen() async {
    await _analytics.setCurrentScreen(
      screenName: 'Analytics Demo',
      screenClassOverride: 'AnalyticsDemo',
    );
  }

  Future<void> _testSetAnalyticsCollectionEnabled() async {
    await _analytics.android?.setAnalyticsCollectionEnabled(false);
    await _analytics.android?.setAnalyticsCollectionEnabled(true);
  }

  Future<void> _testSetMinimumSessionDuration() async {
    await _analytics.android?.setMinimumSessionDuration(20000);
  }

  Future<void> _testSetSessionTimeoutDuration() async {
    await _analytics.android?.setSessionTimeoutDuration(2000000);
  }

}