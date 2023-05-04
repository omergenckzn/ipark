import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ipark/Screens/onBoarding/onBoardingWelcome/on_boarding_welcome_view.dart';
import 'main_navigation_page.dart';


class PageRouter extends StatefulWidget {
  const PageRouter({Key? key}) : super(key: key);

  @override
  State<PageRouter> createState() => _PageRouterState();
}

class _PageRouterState extends State<PageRouter> {

  @override
  Widget build(BuildContext context) {


    bool isSignedIn = checkUserSignedIn();
    return isSignedIn ? const MainNavigationPage() : const OnBoardingWelcomeView();
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
