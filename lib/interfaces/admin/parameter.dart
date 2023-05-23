import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestion_tache/interfaces/admin/accueil_admin.dart';
import 'package:gestion_tache/interfaces/auth/auth.dart';
import 'package:gestion_tache/interfaces/auth/rememberMe.dart';

class Parameter extends StatefulWidget {
  const Parameter({super.key});

  _Parameter createState() => _Parameter();
}

class _Parameter extends State<Parameter> {
  void _deleteLoginCredentials() {
    rememberMe.logOut();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Accueil Administrateur",
            style: TextStyle(
                color: Theme.of(context).primaryColor, fontFamily: 'Raleway'),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccueilAdmin()));
            },
            icon: const Icon(
              Icons.home,
            ),
            color: Theme.of(context).primaryColor,
          ),
          actions: [
            IconButton(
              style: const ButtonStyle(),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                _deleteLoginCredentials();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Auth()));
              },
              icon: const Icon(
                Icons.logout_rounded,
              ),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
        body: Row(
          children: [
            SwitchExample(),
          ],
        ),
      ),
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: Colors.red,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
      },
    );
  }
}
