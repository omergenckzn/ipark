import 'package:flutter/material.dart';
import 'package:ipark/Constants/ipark_components.dart';
import 'package:ipark/Constants/ipark_constants.dart';
import 'package:ipark/Screens/onBoarding/onBoardingPassword/on_boarding_password_model.dart';
import 'package:ipark/Services/cloud_firebase_service.dart';

class OnBoardingPasswordView extends StatefulWidget {
  final String emailString;

  const OnBoardingPasswordView({Key? key, required this.emailString}) : super(key: key);

  @override
  State<OnBoardingPasswordView> createState() => _OnBoardingPasswordViewState();
}

class _OnBoardingPasswordViewState extends State<OnBoardingPasswordView> {

  OnBoardingPasswordModel model = OnBoardingPasswordModel();
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
            IParkComponents.headlineTextWidget(model.passwordHeadline),
            const Spacer(),
            CustomTextFieldStateful(controller: controller, placeholderText: model.passwordInputPlaceholder,isPassword: true),
            const SizedBox(height: 32,),
            Center(child: LargeCtaButton(textContent: model.loginButtonText,onPressed: (){
              CloudFirebaseService.signInOrCreateAccountWithEmail(widget.emailString, controller.text,context);
              //Handle login işlemleri
            }),),
            const Spacer(),
            const SizedBox(height: 24,),
          ],
        ),
      ),
    );
  }
}
