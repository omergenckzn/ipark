import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ipark/Constants/ipark_components.dart';
import 'package:ipark/Constants/ipark_constants.dart';
import 'package:ipark/Models/customer_model.dart';
import 'package:ipark/Screens/main_navigation_page.dart';
import 'package:ipark/Screens/onBoarding/onBoardingPassword/on_boarding_password_model.dart';
import 'package:ipark/Screens/page_router.dart';
import 'package:ipark/Services/cloud_firebase_service.dart';

class OnBoardingPasswordView extends StatefulWidget {
  final String emailString;
  final String? name;

  const OnBoardingPasswordView({Key? key, required this.emailString, required this.name}) : super(key: key);

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
            IParkComponents.headlineTextWidget(model.passwordHeadline,TextAlign.start),
            const Spacer(),
            CustomTextFieldStateful(controller: controller, placeholderText: model.passwordInputPlaceholder,isPassword: true),
            const SizedBox(height: 32,),
            Center(child: LargeCtaButton(textContent: model.loginButtonText,onPressed: () async {

              if(widget.name != null) {
                CustomerModel customerModel = CustomerModel(name: widget.name!, email: widget.emailString);
                UserCredential? user = await CloudFirebaseService.signInOrCreateAccountWithEmail(customerModel, controller.text,context);
                if(user != null) {
                  await CloudFirebaseService.addCustomerUserData(customerModel, context);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MainNavigationPage()));
                }
              } else {
               await CloudFirebaseService.signInWithEmailPassword(widget.emailString, controller.text, context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PageRouter()));
              }

            }),),
            const Spacer(),
            const SizedBox(height: 24,),
          ],
        ),
      ),
    );
  }
}
