import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HttpMessaging {
  init(context) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    //print("fcmtoken ${fcmToken}");

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    messaging.subscribeToTopic("taches");

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
      // print('Got a message whilst in the foreground!');
      // print('Message data: ${message.data}');

      // if (message.notification != null) {
      //   print('Message also contained a notification: ${message.notification}');
      // }

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Notification"),
              content: Text(message.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
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
