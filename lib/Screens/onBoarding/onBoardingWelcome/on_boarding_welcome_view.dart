import 'package:flutter/material.dart';
import 'package:ipark/Constants/ipark_components.dart';
import 'package:ipark/Constants/ipark_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipark/Screens/onBoarding/onBoardingEmail/on_boarding_email_view.dart';
import 'package:ipark/Screens/onBoarding/onBoardingWelcome/on_boarding_welcome_model.dart';

class OnBoardingWelcomeView extends StatefulWidget {
  const OnBoardingWelcomeView({Key? key}) : super(key: key);

  @override
  State<OnBoardingWelcomeView> createState() => _OnBoardingWelcomeViewState();
}

class _OnBoardingWelcomeViewState extends State<OnBoardingWelcomeView> {

  OnBoardingWelcomeModel model = OnBoardingWelcomeModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: IParkPaddings.mainScaffoldPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 96,),
            Center(child: SvgPicture.asset(model.welcomeIllusPath,height: 200,)),
            const SizedBox(height: 32,),
            Text(model.welcomeHeadline, style: IParkStyles.font32HeadlineTextStyle,textAlign: TextAlign.center,),
            const SizedBox(height: 24,),
            Text(model.welcomeDescription,style: IParkStyles.font16DescriptionTextStyle,textAlign: TextAlign.center,),
            const Spacer(),
            LargeCtaButton(textContent: model.welcomeCtaButtonText, onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const OnBoardingEmailView()));

            }),
            const SizedBox(height: 8,),
            TextButton(
              onPressed: () {

              },
              child: Text(model.welcomeTextButtonText,style: IParkStyles.font16TextButtonTextStyle),
            )

          ],
        )
      ),
    );
  }
}
