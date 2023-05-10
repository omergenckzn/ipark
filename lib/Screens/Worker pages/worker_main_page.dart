import 'package:flutter/material.dart';
import 'package:ipark/Constants/ipark_components.dart';
import 'package:ipark/Constants/ipark_constants.dart';

class WorkerMainPage extends StatefulWidget {
  const WorkerMainPage({Key? key}) : super(key: key);

  @override
  State<WorkerMainPage> createState() => _WorkerMainPageState();
}

class _WorkerMainPageState extends State<WorkerMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32,vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IParkComponents.headlineTextWidget("Admin", TextAlign.start),
              const SizedBox(height: 48,),
              Center(
                child: Column(
                  children: [
                    LargeCtaButton(textContent: 'Car check in', onPressed: () {

                    }),
                    const SizedBox(height: 32,),
                    LargeCtaButton(textContent: 'Car checkout', onPressed: (){

                    }),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
