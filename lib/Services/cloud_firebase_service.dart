import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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


  Future<UserCredential> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print('Error creating user: $e');
      }
      throw e;
    }
  }

  static Future<UserCredential?> signInOrCreateAccountWithEmail(String email, String password,BuildContext context) async {
    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        try {
          // User does not exist, create new account
          return await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            showCustomSnackBar("The password is weak",context);
            return null;
          } else if (e.code == 'email-already-in-use') {
            showCustomSnackBar('The account already exists for that email.', context);
            return null;
          } else {
            showCustomSnackBar("Error creating account", context);
          }
        } catch (e) {
          showCustomSnackBar("Error creating account", context);
        }
      } else if (e.code == 'wrong-password') {
        showCustomSnackBar("Wrong password", context);
        return null;
      } else if (e.code == 'invalid-email') {
        showCustomSnackBar("Invalid email", context);
        return null;
      } else if (e.code == 'user-disabled') {
        showCustomSnackBar("The user is disabled please try another account", context);
        return null;
      } else {
        showCustomSnackBar("Error signing in", context);
        return null;
      }
    } catch (e) {
      showCustomSnackBar("Error signing in or creating account", context);
      return null;
    }
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showCustomSnackBar(String content,BuildContext context) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> resetPasswordWithEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else {
        print('Error sending password reset email: $e');
      }
      throw e;
    }
  }


}