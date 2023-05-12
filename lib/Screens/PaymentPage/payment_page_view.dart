import 'package:flutter/material.dart';
import 'package:ipark/Constants/ipark_components.dart';
import 'package:ipark/Constants/ipark_constants.dart';
import 'package:ipark/Screens/page_router.dart';
import 'package:ipark/Services/cloud_firebase_service.dart';

class PaymentPageView extends StatefulWidget {

  final int durationInMinutes;
  final String plateNumber;

  const PaymentPageView({Key? key, required this.durationInMinutes, required this.plateNumber}) : super(key: key);

  @override
  State<PaymentPageView> createState() => _PaymentPageViewState();
}

class _PaymentPageViewState extends State<PaymentPageView> {


  @override
  Widget build(BuildContext context) {
    double price = widget.durationInMinutes * 0.5;


    return Scaffold(
      appBar: IParkComponents.customAppBar(context),
      body: Padding(
        padding: IParkPaddings.mainScaffoldPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IParkComponents.headlineTextWidget("Payment process",TextAlign.start),
            SizedBox(height: 96,),
            Row(
              children: [
                Text("Total Duration: ",style: IParkStyles.font32HeadlineTextStyle,),
                Text(widget.durationInMinutes.toString()+ " minutes", style: IParkStyles.font28HeadlineTextStyle,),
              ],
            ),
            SizedBox(height: 16,),
            Row(
              children: [
                Text("Price:  ",style: IParkStyles.font32HeadlineTextStyle,),
                Text(price.toString() + " TL", style: IParkStyles.font28HeadlineTextStyle,),
              ],
            ),

            const SizedBox(height: 32,),
            Spacer(),
            Center(
              child: LargeCtaButton(textContent: "Pay", onPressed: () {

                 CloudFirebaseService.executePayment(widget.plateNumber, context);
                 Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => PageRouter()), (route) => false);

              }),
            ),
            const SizedBox(height: 24,),
          ],
        ),
      ),
    );
  }
}
