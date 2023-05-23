import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gestion_tache/http/http_messaging.dart';
import 'firebase_options.dart';
import 'interfaces/auth/start.dart';
import 'package:gestion_tache/globals/globals.dart' as globals;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized(); // add this line
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);//gerer l'icone au moment de l'init
  FlutterNativeSplash.remove();
  await Firebase.initializeApp(
    name: 'flutter-gestion-tache-firebase-here',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  void initState() {
    super.initState();
    HttpMessaging().init();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Gestionnaire de tache',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 68, 21, 151),
        secondaryHeaderColor: Colors.white,
        primaryColorDark: Colors.redAccent,
      ),
      //home: const Home(),
      home: const Start(),
    );
  }
}
