import 'package:flutter/material.dart';
import 'package:gestion_tache/interfaces/admin/accueil_admin.dart';
import 'package:gestion_tache/interfaces/auth/rememberMe.dart';
import 'package:gestion_tache/interfaces/auth/authEmailPasswordCheck.dart';
import 'package:gestion_tache/globals/globals.dart' as globals;
import '../Default/accueil.dart';
import 'auth.dart';
import 'authEmailPasswordCheck.dart' as authObject;

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  bool _isLogIn = true;

  void initState() {
    super.initState();
    loadAuthCredential();
    _isLogIn = true;
  }

  void loadAuthCredential() async {
    Map<String, dynamic> credential = await rememberMe.readAuthCredential();
    if (credential.isEmpty == false) {
      var pwd = credential['password'] != null ? credential['password'] : "";
      var rep = await AuthCheckAndCreate.userLogIn(credential['email'], pwd);
      if (rep == null) {
        setState(() {
          _isLogIn = false;
        });

        var isAdmin =
            await authObject.AuthCheckAndCreate.isAdmin(globals.user?.uid);

        if (isAdmin) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AccueilAdmin()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Accueil()),
          );
        }
      } else {
        rememberMe.logOut();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Auth()),
        );
      }
    } else {
      setState(() {
        _isLogIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: const SizedBox(
                  height: 400,
                  child: Image(
                    image: AssetImage("resources/start.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 25.0,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Bienvenue dans votre application de gestion des tâches",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 19),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 65.0,
          ),
          ElevatedButton(
              onPressed: _isLogIn
                  ? null
                  : () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Auth()));
                    },
              style: ElevatedButton.styleFrom(
                elevation: 5.0,
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).secondaryHeaderColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                minimumSize: const Size(200, 50),
              ),
              child: _isLogIn
                  ? CircularProgressIndicator()
                  : Text(
                      ' Allons-y ! '.toUpperCase(),
                      style: const TextStyle(fontSize: 15),
                    )),
        ],
      )),
    );
  }
}
