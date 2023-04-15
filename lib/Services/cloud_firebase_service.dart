import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class CloudFirebaseService {

  static Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        /// Display a snackbar
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ///Display a snackbar
        print('Wrong password provided for that user.');
      }
      throw e;
    }
  }


}