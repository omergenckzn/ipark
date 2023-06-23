import 'package:flutter/material.dart';
import 'package:ipark/Constants/ipark_components.dart';
import 'package:ipark/Constants/ipark_constants.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';


class PremiumView extends StatefulWidget {
  const PremiumView({Key? key}) : super(key: key);

  @override
  State<PremiumView> createState() => _PremiumViewState();
}

class _PremiumViewState extends State<PremiumView> {

  DateTime _pickedDate = DateTime.now();

  void _setDate(DateTime pickedDate) {
    setState(() {
      _pickedDate = pickedDate;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: IParkPaddings.mainScaffoldPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 48,),
            IParkComponents.headlineTextWidget("Density Screening", TextAlign.start),
            Center(child: SizedBox(height: 400,width: 400, child: Image.asset("assets/illustrations/iSparkMapImage.jpg"),)),
            DatePickerTextButtonTime(initialDate: _pickedDate, setDate: _setDate),
            SizedBox(height: 16,),
            IParkComponents.descriptionTextWidget("Ispark Ressam Halim Açık Otoparkı", TextAlign.start),
            SizedBox(height: 8,),
            IParkComponents.descriptionTextWidget("Bahçelievler Merkez, Dizer Sk. No:3, 34180 Bahçelievler/Istanbul", TextAlign.start),
            SizedBox(height: 8,),
            Center(
              child: LargeCtaButton(textContent: "Find empty parking slots", onPressed: (){
                showDialog(context: context, builder: (context){
                  return Dialog(
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Column(
                        children: [
                          SizedBox(height: 32,),
                          Text("Total Parking Places: 100"),
                          SizedBox(height: 8,),
                          Text("Available Slots: 20"),
                          Spacer(),
                          LargeCtaButton(textContent: "Set reservation", onPressed: (){
                            Navigator.of(context).pop();
                          }),
                          SizedBox(height: 16,)
                        ],
                      ),
                    ),
                  );
                });
              }),
            )


          ],
        ),
      ),
    );
  }
}
