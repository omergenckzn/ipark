import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grock/grock.dart';
import 'package:ipark/Constants/ipark_components.dart';
import 'package:ipark/Models/car_data.dart';
import 'package:ipark/Models/car_model.dart';
import 'package:ipark/Models/customer_model.dart';
import 'package:ipark/Services/firebase_storage_service.dart';

class CloudFirebaseService {
  static Future<UserCredential> signInWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
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

  static Future<UserCredential?> signInOrCreateAccountWithEmail(
      CustomerModel model, String password, BuildContext context) async {
    try {
      return await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: model.email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        try {
          // User does not exist, create new account
          return await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: model.email, password: password);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            showCustomSnackBar("The password is weak", context);
            return null;
          } else if (e.code == 'email-already-in-use') {
            showCustomSnackBar(
                'The account already exists for that email.', context);
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
        showCustomSnackBar(
            "The user is disabled please try another account", context);
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

  static Future addCustomerUserData(
      CustomerModel model, BuildContext context) async {
    if (FirebaseAuth.instance.currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('customerUsers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(model.toMap());
      } catch (e) {
        showCustomSnackBar("Something went wrong", context);
        throw e;
      }
    } else {
      showCustomSnackBar("Something went wrong", context);
    }
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      showCustomSnackBar(String content, BuildContext context) =>
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(content)));

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> resetPasswordWithEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
      } else {}
      throw e;
    }
  }

  static Future<void> addCarDataToFirestore(
      CarModel model, BuildContext context) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference carUserCollectionRef =
          FirebaseFirestore.instance.collection("customerUsers");

      carUserCollectionRef.doc(uid).update({
        'carPlates': FieldValue.arrayUnion([model.licencePlate])
      });

      CollectionReference carCollectionRef =
          FirebaseFirestore.instance.collection("cars");
      carCollectionRef.doc(model.licencePlate).set({
        'uid': uid,
        "name": model.name,
        "licencePlate": model.licencePlate,
        "brand": model.brand,
        "imageUrl": model.imageUrl,
        "chassisNumber": model.chassisNumber,
      }, SetOptions(merge: true));
    } catch (e) {
      CloudFirebaseService.showCustomSnackBar(
          "Something went wrong. Please try again", context);
    }
  }

  static Stream<List<CarData>> getCarDataFromFirestore(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference userDocument =
        FirebaseFirestore.instance.collection("customerUsers").doc(uid);
    CollectionReference carCollectionRef =
        FirebaseFirestore.instance.collection('cars');

    return Stream.fromFuture(
        userDocument.get().then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        List<String> carPlatesList =
            List<String>.from(snapshot.get('carPlates'));

        List<Future<CarData?>> futures = [];
        carPlatesList.forEach((plate) {
          futures.add(
              carCollectionRef.doc(plate).get().then((DocumentSnapshot data) {
            if (data.exists && data != null) {
              return CarData(
                  data['licencePlate'],
                  CarModel(data['name'], data['brand'], data["licencePlate"],
                      data["imageUrl"], data["chassisNumber"], uid));
            } else {
              return null;
            }
          }));
        });

        return Future.wait(futures).then((carDataList) {
          return carDataList
              .where((carData) => carData != null)
              .cast<CarData>()
              .toList();
        });
      } else {
        return Future.value(<CarData>[]); // Return an empty list
      }
    }));
  }

  static Future<void> deleteCarFromFirestore(
      String docId, String url, BuildContext context) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference userCarCollectionRef =
          FirebaseFirestore.instance.collection('customerUsers');
      userCarCollectionRef.doc(uid).update({
        'carPlates': FieldValue.arrayRemove([docId])
      });
      CollectionReference carCollectionRef =
          FirebaseFirestore.instance.collection('cars');
      await carCollectionRef.doc(docId).delete();
      await FirebaseStorageService.deleteImageFromFirebaseStorage(url);
    } catch (e) {
      CloudFirebaseService.showCustomSnackBar(
          "Something went wrong. Please try again", context);
    }
  }

  static Future<void> startCharging(
      String plateNumber, DateTime startDate, BuildContext context) async {
    try {
      DocumentReference carDocRef =
          FirebaseFirestore.instance.collection('cars').doc(plateNumber);
      DocumentSnapshot<Object?> snapshot = await carDocRef.get();

      if (snapshot.exists) {
        final Map<String, dynamic>? data =
            snapshot.data() as Map<String, dynamic>;

        if (data != null) {
          String carOwnerUid = data['uid'];
          DocumentReference userRef = FirebaseFirestore.instance
              .collection("customerUsers")
              .doc(carOwnerUid);

          DocumentSnapshot pendingPaymentsDoc = await FirebaseFirestore.instance
              .collection('customerUsers')
              .doc(carOwnerUid)
              .collection('pendingPaymentDoc')
              .doc(plateNumber)
              .get();



           CarModel carModel = CarModel.fromMap(data);

          if (!pendingPaymentsDoc.exists) {
            await userRef.collection('pendingPaymentDoc').doc(plateNumber).set({
              'startDate': Timestamp.fromDate(startDate),
              'carPlateNumber': carModel.licencePlate,
              'carImageUrl': carModel.imageUrl,
            });
            CloudFirebaseService.showCustomSnackBar(
                "Check in successful", context);
          } else {
            CloudFirebaseService.showCustomSnackBar(
                'The customer has another transaction. Please ask for payments for registering new one.',
                context);
          }
        } else {
          CloudFirebaseService.showCustomSnackBar(
              "The car is not registered to the system.", context);
        }
      } else {
        CloudFirebaseService.showCustomSnackBar(
            "The car is not registered to the system.", context);
      }
    } catch (e) {
      CloudFirebaseService.showCustomSnackBar(
          "Something went wrong. Please try again", context);
    }
  }

  static Future<void> endCharging(
      String plateNumber, DateTime endDate, BuildContext context) async {
    try {
      DocumentReference carDocRef =
          FirebaseFirestore.instance.collection('cars').doc(plateNumber);
      DocumentSnapshot<Object?> snapshot = await carDocRef.get();

      if (snapshot.exists) {
        final Map<String, dynamic>? data =
            snapshot.data() as Map<String, dynamic>;

        if (data != null) {
          String carOwnerUid = data['uid'];
          DocumentReference userRef = FirebaseFirestore.instance
              .collection("customerUsers")
              .doc(carOwnerUid);

          DocumentReference pendingPaymentsRef =
              userRef.collection('pendingPaymentDoc').doc(plateNumber);
          DocumentSnapshot pendingPaymentsDoc = await pendingPaymentsRef.get();

          if (pendingPaymentsDoc.exists) {
            Map data = pendingPaymentsDoc.data() as Map<String, dynamic>;

            if (data['endDate'] == null) {
              pendingPaymentsRef.update({
                'endDate': Timestamp.fromDate(endDate),
              });
              CloudFirebaseService.showCustomSnackBar(
                  "Checkout successful", context);
            } else {
              CloudFirebaseService.showCustomSnackBar(
                  "The car is already charged", context);
            }
          } else {
            CloudFirebaseService.showCustomSnackBar(
                "The car has not being checked in yet.", context);
          }
        } else {
          CloudFirebaseService.showCustomSnackBar(
              "The car is not registered to the system.", context);
        }
      } else {
        CloudFirebaseService.showCustomSnackBar(
            "The car is not registered to the system.", context);
      }
    } catch (e) {
      CloudFirebaseService.showCustomSnackBar(
          "Something went wrong. Please try again", context);
    }
  }

  static Future<List<Map<String, dynamic>>> getPendingPayments() async {
    List<Map<String, dynamic>> documentList = [];
    String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('customerUsers')
          .doc(uid)
          .collection('pendingPaymentDoc')
          .get();

      for (int i = 0; i < querySnapshot.docs.length; i++) {
        QueryDocumentSnapshot doc = querySnapshot.docs[i];
        if (doc.data() != null && doc.data().isNotEmpty) {
          documentList.add(doc.data() as Map<String, dynamic>);
        }
      }

      return documentList;

    } catch (e) {
      return [];
    }
  }


  static Future<List<Map<String, dynamic>>> getPreviousPayments() async {
    List<Map<String, dynamic>> documentList = [];
    String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('customerUsers')
          .doc(uid)
          .collection('completedPayments')
          .get();

      for (int i = 0; i < querySnapshot.docs.length; i++) {
        QueryDocumentSnapshot doc = querySnapshot.docs[i];
        if (doc.data() != null && doc.data().isNotEmpty) {
          documentList.add(doc.data() as Map<String, dynamic>);
        }
      }

      return documentList;

    } catch (e) {
      return [];
    }
  }

  static void executePayment(String licensePlate, BuildContext context) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference documentReference = firestore.collection('customerUsers').doc(uid).collection('pendingPaymentDoc').doc(licensePlate);

    DocumentSnapshot documentSnapshot = await firestore.collection('customerUsers').doc(uid).collection('pendingPaymentDoc').doc(licensePlate).get();

    await firestore.collection('customerUsers').doc(uid).collection('completedPayments').doc(licensePlate+DateTime.now().toString()).set(documentSnapshot.data() as Map<String, dynamic>);

    documentReference.delete().then((value) {
      CloudFirebaseService.showCustomSnackBar("You successfully pay the parking ticket", context);
    }).catchError((error) {
      CloudFirebaseService.showCustomSnackBar("Something went wrong. Please contact our employees.", context);
    });
  }


}
