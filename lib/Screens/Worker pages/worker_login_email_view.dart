import 'package:flutter/material.dart';
import 'package:ipark/Constants/ipark_components.dart';
import 'package:ipark/Constants/ipark_constants.dart';
import 'package:ipark/Screens/Worker%20pages/worker_login_password_view.dart';
import 'package:ipark/Services/cloud_firebase_service.dart';

class WorkerLoginEmailView extends StatefulWidget {
  const WorkerLoginEmailView({Key? key}) : super(key: key);

  @override
  State<WorkerLoginEmailView> createState() => _WorkerLoginEmailViewState();
}

class _WorkerLoginEmailViewState extends State<WorkerLoginEmailView> {


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
            IParkComponents.headlineTextWidget("Enter your e-mail.",TextAlign.start),
            const Spacer(),
            CustomTextFieldStateful(controller: controller, placeholderText: "Email",isPassword: false),
            const SizedBox(height: 32,),
            Center(
              child: LargeCtaButton(textContent: "Continue", onPressed: (){
                if(controller.text.isNotEmpty) {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => WorkerLoginPasswordView()));
                } else {
                  CloudFirebaseService.showCustomSnackBar("Please fill up the email", context);
                }

              }),
            ),
            const Spacer(),
            const SizedBox(height: 24,),
          ],
        ),
      )
    );
  }
}
