import 'package:flutter/material.dart';
import 'package:ipark/Constants/ipark_components.dart';
import 'package:ipark/Constants/ipark_constants.dart';
import 'package:ipark/Screens/Worker%20pages/worker_main_page.dart';
import 'package:ipark/Services/cloud_firebase_service.dart';

class WorkerLoginPasswordView extends StatefulWidget {
  const WorkerLoginPasswordView({Key? key}) : super(key: key);

  @override
  State<WorkerLoginPasswordView> createState() => _WorkerLoginPasswordViewState();
}

class _WorkerLoginPasswordViewState extends State<WorkerLoginPasswordView> {

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
              IParkComponents.headlineTextWidget("Enter your password.",TextAlign.start),
              const Spacer(),
              CustomTextFieldStateful(controller: controller, placeholderText: "password",isPassword: false),
              const SizedBox(height: 32,),
              Center(
                child: LargeCtaButton(textContent: "Login", onPressed: (){
                  if(controller.text.isNotEmpty) {
                    if(controller.text == "12345") {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => WorkerMainPage()), (route) => false);
                    } else {
                      CloudFirebaseService.showCustomSnackBar("Your password is incorrect", context);
                    }
                  } else {
                    CloudFirebaseService.showCustomSnackBar("Please fill up the password", context);
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
