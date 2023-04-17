import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipark/Screens/onBoarding/onBoardingWelcome/on_boarding_welcome_view.dart';




preloadIcons() async {
  await precachePicture(
      ExactAssetPicture(
        SvgPicture.svgStringDecoderBuilder, // See UPDATE below!
        'assets/illustrations/illus_parkingSpace.svg',
      ),
      null
  );
}


void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await preloadIcons();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      home: OnBoardingWelcomeView(),
    );
  }
}

