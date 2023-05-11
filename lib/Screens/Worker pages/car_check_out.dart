import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grock/grock.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipark/Constants/ipark_components.dart';
import 'package:ipark/Constants/ipark_constants.dart';
import 'package:ipark/Services/cloud_firebase_service.dart';
import 'package:ipark/Services/ffi.dart';
import 'package:ipark/Services/handle_permissions.dart';
import 'package:permission_handler/permission_handler.dart';

class CarCheckOut extends StatefulWidget {
  const CarCheckOut({Key? key}) : super(key: key);

  @override
  State<CarCheckOut> createState() => _CarCheckOutState();
}

class _CarCheckOutState extends State<CarCheckOut> {

  String? imagePath;
  File? _imageFile;
  DateTime _pickedDate = DateTime.now();
  TextEditingController controller = TextEditingController();

  void _setDate(DateTime pickedDate) {
    setState(() {
      _pickedDate = pickedDate;
    });
  }

  @override
  void initState() {
    Permission.manageExternalStorage.request().then((value) => print("manageExternalStorage: ${value}"));
    Permission.storage.request().then((value) => print("storage: ${value}"));
    super.initState();
  }

  void _onConvertClick() async {
    if (imagePath != null) {
      List<String> outputPath = imagePath!.split(".");
      outputPath[outputPath.length - 2] = "${outputPath[outputPath.length - 2]}_gray";
      print(outputPath.join("."));

      convertImageToGrayImage(imagePath!, outputPath.join("."));

      setState(() {
        imagePath = outputPath.join(".");
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: IParkPaddings.workerScaffoldPadding,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                IParkComponents.headlineTextWidget("Car check out", TextAlign.start),
                const SizedBox(height: 8,),
                IParkComponents.descriptionTextWidget("Please scan the car plate and enter the ending date.", TextAlign.start),

                const SizedBox(height: 48,),
                DatePickerTextButton(initialDate: _pickedDate, setDate: _setDate),
                const SizedBox(height: 24,),
                imageWidgetDecider(),

                const SizedBox(height: 32,),

                CustomTextFieldStateful(controller: controller, placeholderText: "Car plate", isPassword: false),
                const SizedBox(height: 32,),
                Center(child: LargeCtaButton(textContent: "Start charging", onPressed: () async {

                  await CloudFirebaseService.endCharging(controller.text, _pickedDate,context,);
                  Navigator.of(context).pop();

                })),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageWidgetDecider() {
    if (_imageFile == null) {
      return InkWell(
        onTap: () async {
          if (Platform.isIOS) {
            cameraOrGallery(context);
          } else {
            bool cameraPerm = await HandlePermissions.checkCameraPermission();
            if (cameraPerm) {
              cameraOrGallery(context);
            } else {
              Grock.toast(
                  text: "Camera",
                  duration: const Duration(seconds: 3));
              Navigator.pop(context);
            }
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey),
          ),
          child: Center(
            child: Text(
              "Add photo",
              style: IParkStyles.font18GreyTextStyle,
            ),
          ),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(File(imagePath!), gaplessPlayback: true,height: 311,)),
          ),
          const SizedBox(
            height: 24,
          ),
          Center(
            child: TextButton(
                onPressed: () {
                  setState(() {
                    _imageFile = null;
                    imagePath = null;
                  });
                },
                child: Text(
                  "Delete",
                  style: IParkStyles.font18GreyTextStyle,
                )),
          )
        ],
      );
    }
  }

  void cameraOrGallery(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Pick Image"),
          content: Text("Save the image of your car"),
          actions: [
            TextButton(
                onPressed: () async {
                  await _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
                child: Text("Camera")),
            TextButton(
                onPressed: () async {
                  await _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
                child: Text("Gallery")),
          ],
        ));

  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
        _imageFile = File(pickedFile.path);
      });
    }
  }


}
