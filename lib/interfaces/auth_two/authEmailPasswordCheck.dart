import 'package:firebase_auth/firebase_auth.dart';
import 'package:gestion_tache/globals/globals.dart' as globals;
import 'package:gestion_tache/interfaces/auth/rememberMe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthCheckAndCreate {
  static Future<String?> userLogIn(String mail, String pwd) async {
    FirebaseAuth.instance.setLanguageCode('fr');

    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail, password: pwd);
      print(result.user?.email);
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
    CollectionReference tasks =
        FirebaseFirestore.instance.collection('administrators');
    bool isAdmin = false;

    await tasks.get().then((value) => value.docs.forEach((doc) {
          if (doc['userID'] == userID) {
            isAdmin = true;
            return;
          }
        }));

    return isAdmin;
  }
}
