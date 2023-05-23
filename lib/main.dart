import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gestion_tache/http/http_messaging.dart';
import 'firebase_options.dart';
import 'interfaces/auth/start.dart';
import 'package:gestion_tache/globals/globals.dart' as globals;
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);//démarre l'image

  FlutterNativeSplash.remove();
  await Firebase.initializeApp(
    name: 'flutter-gestion-tache-firebase-here',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    AdaptiveTheme(
      light: ThemeData(
        primaryColor: const Color.fromARGB(255, 68, 21, 151),
        secondaryHeaderColor: Colors.white,
        primaryColorDark: Colors.redAccent,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 68, 21, 151),
        secondaryHeaderColor: Colors.white,
        primaryColorDark: Colors.redAccent,
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MyApp(theme: theme, darkTheme: darkTheme),
    ),
  );
}


class MyApp extends StatelessWidget {
  final ThemeData theme;
  final ThemeData darkTheme;

  const MyApp({Key? key, required this.theme, required this.darkTheme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestionnaire de tache',
      theme: theme,
      darkTheme: darkTheme,
      home: const Start(),
    );
  }
}
