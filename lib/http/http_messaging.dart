import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gestion_tache/globals/globals.dart' as globals;

class HttpMessaging {
  init() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    //print("fcmtoken ${fcmToken}");

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    messaging.subscribeToTopic("taches_publiques");

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      globals.notification = message.data;
      globals.notificationNumber = 1;
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("_messaging onMessageOpenedApp: $message");
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
}
