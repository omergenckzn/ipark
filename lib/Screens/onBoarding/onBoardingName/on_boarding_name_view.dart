import 'package:flutter/material.dart';
import 'package:ipark/Constants/ipark_components.dart';
import 'package:ipark/Constants/ipark_constants.dart';
import 'package:ipark/Screens/onBoarding/onBoardingEmail/on_boarding_email_view.dart';
import 'package:ipark/Screens/onBoarding/onBoardingName/on_boarding_name_model.dart';

class OnBoardingNameView extends StatefulWidget {
  const OnBoardingNameView({Key? key}) : super(key: key);

  @override
  State<OnBoardingNameView> createState() => _OnBoardingNameViewState();
}

class _OnBoardingNameViewState extends State<OnBoardingNameView> {

  OnBoardingNameModel model = OnBoardingNameModel();
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IParkComponents.customAppBar(context),
      body: Padding(
        padding: IParkPaddings.mainScaffoldPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IParkComponents.headlineTextWidget(model.nameHeadline,TextAlign.start),
            const Spacer(),
            CustomTextFieldStateful(controller: controller, placeholderText: model.inputPlaceHolderText, isPassword: false),
            const SizedBox(height: 32,),
            Center(
              child: LargeCtaButton(textContent: model.continueCta, onPressed: (){
                if(controller.text.isNotEmpty) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OnBoardingEmailView(name: controller.text)));
                } else {
                  /// SnackBar
                }

              }),
            ),
            const Spacer(),
            const SizedBox(height: 24,),
          ],
        ),
      ),

    );
  }
}
