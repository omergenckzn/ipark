import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirestoreProvider extends ChangeNotifier {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

   Map _data = {"email": "", "name":"",};
   Map get data => _data;


   FirestoreProvider() {
     String? uid = firebaseAuth.currentUser?.uid;
     if(uid != null) {
       instance.collection('customerUsers').doc(uid).snapshots().listen((snapshot) {
         if(snapshot.exists) {
           _data = snapshot.data() as Map;
           notifyListeners();
         } else {
           notifyListeners();
         }
       });
     }else {

     }
   }
}

class DocumentListener extends ChangeNotifier {
  StreamSubscription<QuerySnapshot>? _subscription;
  String? cacheUid = FirebaseAuth.instance.currentUser?.uid;

  DocumentListener() {
    _subscription = FirebaseFirestore.instance
        .collection('customerUsers')
        .doc(cacheUid)
        .collection("pendingPaymentDoc").snapshots().
        listen((event) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}