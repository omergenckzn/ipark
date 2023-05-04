

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {

  static Future<String> uploadImageToFirebaseStorage(
      File imageFile, DateTime date) async {
    String? uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseStorage.instance.ref().child('users/$uid/$date.jpg');
    await ref.putFile(imageFile);
    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<void> deleteImageFromFirebaseStorage(String url) async {
    await FirebaseStorage.instance.refFromURL(url).delete();
  }
}