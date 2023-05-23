import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestion_tache/globals/globals.dart' as globals;
import 'package:gestion_tache/interfaces/Default/accueil.dart';
import 'package:gestion_tache/interfaces/auth/rememberMe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthCheckAndCreate {
  static Future<String?> userLogIn(String mail, String pwd) async {
    FirebaseAuth.instance.setLanguageCode('fr');

    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail, password: pwd);
      //print(result);
      globals.user = result.user;
      Map<String, dynamic> user = {
        'email': result.user?.email,
        'password': pwd,
        'name': result.user?.displayName
      };
      await rememberMe.writeAuthCredential(user);

      return null;
    } on FirebaseAuthException catch (ex) {
      return "${ex.code}: ${ex.message}";
    }
  }

  static Future<String?> createUserAccount(
      String mail, String pwd, String name) async {
    FirebaseAuth.instance.setLanguageCode('fr');

    try {
      var result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: mail, password: pwd);
      var u = result.user;
      u?.updateDisplayName(name);
      return null;
    } on FirebaseAuthException catch (ex) {
      return "${ex.code}: ${ex.message}";
    }
  }

  static Future<bool> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (ex) {
      print(ex.message);
      return false;
    }
  }

  static Future<bool> isAdmin(userID) async {
    CollectionReference admins =
        FirebaseFirestore.instance.collection("users_admin");
    bool isAdmin = false;

    QuerySnapshot querySnapshot = await admins.get();
    //print(querySnapshot.docs);
    for (var doc in querySnapshot.docs) {
      if (doc["userID"] == userID) {
        isAdmin = true;
        //return;
      }
    }
    return isAdmin;
  }

  Future<void> googleSignIn(BuildContext context) async {
    final storage = FlutterSecureStorage();

    AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );

    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      //GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
      if (GoogleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount!.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        try {
          UserCredential result = await auth.signInWithCredential(credential);
          // StoreTokenAndData(userCredential);

          globals.user = result.user;
          Map<String, dynamic> user = {
            'email': result.user?.email,
            //'password': result.user?.,
            'name': result.user?.displayName
          };
          await rememberMe.writeAuthCredential(user);

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => Accueil()),
              (route) => false);
        } catch (e) {
          final snackbar = SnackBar(
            content: Text(
              e.toString(),
              style: GoogleFonts.ebGaramond(
                color: Colors.white,
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.deepPurple.shade500,
            duration: Duration(seconds: 7),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      } else {
        final snackbar = SnackBar(
          content: Text(
            "Impossible de se connecter.\nVeuillez réesayer",
            style: GoogleFonts.ebGaramond(
              color: Colors.white,
              fontSize: 18,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.deepPurple.shade500,
          duration: Duration(seconds: 7),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } catch (e) {
      final snackbar = SnackBar(
        content: Text(
          e.toString(),
          style: GoogleFonts.ebGaramond(
            color: Colors.white,
            fontSize: 18,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple.shade500,
        duration: Duration(seconds: 7),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      UserCredential result = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      globals.user = result.user;
      Map<String, dynamic> user = {
        'email': result.user?.email,
        //'password': result.user?.,
        'name': result.user?.displayName
      };
      await rememberMe.writeAuthCredential(user);

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (builder) => Accueil()), (route) => false);
    } catch (e) {
      final snackbar = SnackBar(
        content: Text(
          e.toString(),
          style: GoogleFonts.ebGaramond(
            color: Colors.white,
            fontSize: 18,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple.shade500,
        duration: Duration(seconds: 7),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
