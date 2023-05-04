import 'package:flutter/material.dart';
import 'package:ipark/Constants/ipark_components.dart';
import 'package:ipark/Constants/ipark_constants.dart';
import 'package:ipark/Screens/onBoarding/onBoardingEmail/on_boarding_email_model.dart';
import 'package:ipark/Screens/onBoarding/onBoardingPassword/on_boarding_password_view.dart';
import 'package:ipark/Services/cloud_firebase_service.dart';

class OnBoardingEmailView extends StatefulWidget {
  final String? name;
  const OnBoardingEmailView({Key? key,required this.name}) : super(key: key);

  @override
  State<OnBoardingEmailView> createState() => _OnBoardingEmailViewState();
}

class _OnBoardingEmailViewState extends State<OnBoardingEmailView> {
  OnBoardingEmailModel model = OnBoardingEmailModel();

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
           IParkComponents.headlineTextWidget(model.emailHeadline,TextAlign.start),
           const Spacer(),
           CustomTextFieldStateful(controller: controller, placeholderText: model.inputPlaceholderText,isPassword: false),
           const SizedBox(height: 32,),
           Center(
             child: LargeCtaButton(textContent: model.continueText, onPressed: (){
               if(controller.text.isNotEmpty) {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => OnBoardingPasswordView(emailString: controller.text,name: widget.name,)));
               } else {
                 CloudFirebaseService.showCustomSnackBar("Please fill up the email", context);
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
