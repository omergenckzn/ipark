
import 'package:flutter/material.dart';
import 'package:ipark/Constants/ipark_components.dart';
import 'package:ipark/Constants/ipark_constants.dart';
import 'package:ipark/Screens/AddCar/add_car_photo_view.dart';


class AddCarView extends StatefulWidget {
  const AddCarView({Key? key}) : super(key: key);

  @override
  State<AddCarView> createState() => _AddCarViewState();
}

class _AddCarViewState extends State<AddCarView> {



  final TextEditingController controllerCarTitle = TextEditingController();
  final TextEditingController controllerBrand = TextEditingController();
  final TextEditingController controllerLicensePlate = TextEditingController();
  final TextEditingController controllerChassisNumber = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IParkComponents.customAppBar(context),
      body: Padding(
        padding: IParkPaddings.mainScaffoldPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IParkComponents.headlineTextWidget("Add your car", TextAlign.start),
            const SizedBox(height: 32,),
            CustomTextFieldStateful(controller: controllerCarTitle, placeholderText: "Car Title", isPassword: false),
            const SizedBox(height: 16,),
            CustomTextFieldStateful(controller: controllerBrand, placeholderText: "Brand", isPassword: false),
            const SizedBox(height: 16,),
            CustomTextFieldStateful(controller: controllerLicensePlate, placeholderText: "License Plate", isPassword: false),
            const SizedBox(height: 16,),
            CustomTextFieldStateful(controller: controllerChassisNumber, placeholderText: "Chassis Number", isPassword: false),
            const SizedBox(height: 32,),
            Center(child: LargeCtaButton(textContent: "Continue", onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddCarPhoto(title: controllerCarTitle.text, brand: controllerBrand.text, licensePlate: controllerLicensePlate.text, chassisNumber: controllerChassisNumber.text)));
            })),

          ],
        ),
      ),
    );
  }


}
