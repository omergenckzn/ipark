import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ipark/Constants/ipark_components.dart';
import 'package:ipark/Models/car_data.dart';
import 'package:ipark/Models/car_model.dart';
import 'package:ipark/Models/customer_model.dart';
import 'package:ipark/Services/firebase_storage_service.dart';


class CloudFirebaseService {

  static Future<UserCredential> signInWithEmailPassword(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showCustomSnackBar("User is not found. Try sign in.", context);

      } else if (e.code == 'wrong-password') {
        showCustomSnackBar("The password is wrong..", context);

      }
      throw e;
    }
  }


  // Future<UserCredential> signUpWithEmailPassword(String email, String password) async {
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return userCredential;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       print('The password provided is too weak.');
  //     } else if (e.code == 'email-already-in-use') {
  //       print('The account already exists for that email.');
  //     } else {
  //       print('Error creating user: $e');
  //     }
  //     throw e;
  //   }
  // }

  static Future<UserCredential?> signInOrCreateAccountWithEmail(CustomerModel model, String password,BuildContext context) async {
    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(email: model.email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        try {
          // User does not exist, create new account
          return await FirebaseAuth.instance.createUserWithEmailAndPassword(email: model.email, password: password);
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

  static Stream<DocumentSnapshot> userDataStream() {
    String? userUid = FirebaseAuth.instance.currentUser?.uid;
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection('customerUsers').doc(userUid);
    return documentReference.snapshots();
  }

  static Future addCustomerUserData(CustomerModel model,BuildContext context) async {

    if(FirebaseAuth.instance.currentUser != null) {
      try {
        await FirebaseFirestore.instance.collection('customerUsers').doc(FirebaseAuth.instance.currentUser!.uid).set(model.toMap());

      } catch (e) {
        showCustomSnackBar("Something went wrong", context);
        throw e;
      }
    } else {
      showCustomSnackBar("Something went wrong", context);
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

      } else {

      }
      throw e;
    }
  }

  static Future<void> addCarDataToFirestore(CarModel model, BuildContext context) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference carUserCollectionRef = FirebaseFirestore.instance.collection("customerUsers");

      carUserCollectionRef.doc(uid).update({'carPlates' : FieldValue.arrayUnion([model.licencePlate])});

      CollectionReference carCollectionRef = FirebaseFirestore.instance.collection("cars");
      carCollectionRef.doc(model.licencePlate).set({
        'uid': uid,
        "name": model.name,
        "licencePlate": model.licencePlate,
        "brand": model.brand,
        "imageUrl": model.imageUrl,
        "chassisNumber":model.chassisNumber,
      },SetOptions(merge: true));
    } catch (e) {
      CloudFirebaseService.showCustomSnackBar("Something went wrong. Please try again", context);
    }
  }

  static Stream<List<CarData>> getCarDataFromFirestore(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference userDocument = FirebaseFirestore.instance.collection("customerUsers").doc(uid);
    CollectionReference carCollectionRef = FirebaseFirestore.instance.collection('cars');

    return Stream.fromFuture(userDocument.get().then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        List<String> carPlatesList = List<String>.from(snapshot.get('carPlates'));

        List<Future<CarData?>> futures = [];
        carPlatesList.forEach((plate) {
          futures.add(carCollectionRef.doc(plate).get().then((DocumentSnapshot data) {
            if (data.exists && data != null) {
              return CarData(data['licencePlate'], CarModel(data['name'], data['brand'], data["licencePlate"], data["imageUrl"], data["chassisNumber"], uid));
            } else {
              return null;
            }
          }));
        });

        return Future.wait(futures).then((carDataList) {
          return carDataList.where((carData) => carData != null).cast<CarData>().toList();
        });
      } else {
        return Future.value(<CarData>[]); // Return an empty list
      }
    }));
  }



  static Future<void> deleteCarFromFirestore(String docId,String url ,BuildContext context) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference userCarCollectionRef = FirebaseFirestore.instance.collection('customerUsers');
      userCarCollectionRef.doc(uid).update({'carPlates' : FieldValue.arrayRemove([docId])});
      CollectionReference carCollectionRef = FirebaseFirestore.instance.collection('cars');
      await carCollectionRef.doc(docId).delete();
      await FirebaseStorageService.deleteImageFromFirebaseStorage(url);
    } catch (e) {
      CloudFirebaseService.showCustomSnackBar("Something went wrong. Please try again", context);
    }
  }


}