import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ipark/Screens/test_cpp.dart';

class PageRouter extends StatefulWidget {
  const PageRouter({Key? key}) : super(key: key);

  @override
  State<PageRouter> createState() => _PageRouterState();
}

class _PageRouterState extends State<PageRouter> {
  @override
  Widget build(BuildContext context) {
    bool isSignedIn = checkUserSignedIn();
    return isSignedIn ? const TestCpp() : const TestCpp();
  }

  bool checkUserSignedIn() {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }
}
