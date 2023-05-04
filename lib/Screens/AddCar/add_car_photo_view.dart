import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grock/grock.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipark/Constants/ipark_components.dart';
import 'package:ipark/Constants/ipark_constants.dart';
import 'package:ipark/Models/car_model.dart';
import 'package:ipark/Screens/Cars/cars_view.dart';
import 'package:ipark/Screens/page_router.dart';
import 'package:ipark/Services/cloud_firebase_service.dart';
import 'package:ipark/Services/firebase_storage_service.dart';
import 'package:ipark/Services/handle_permissions.dart';

class AddCarPhoto extends StatefulWidget {
  final String title;
  final String brand;
  final String licensePlate;
  final String chassisNumber;


  const AddCarPhoto({Key? key,required this.title, required this.brand, required this.licensePlate, required this.chassisNumber}) : super(key: key);

  @override
  State<AddCarPhoto> createState() => _AddCarPhotoState();
}

class _AddCarPhotoState extends State<AddCarPhoto> {

  File? _imageFile;
  bool _buttonEnabled = true;


  @override
  Widget build(BuildContext context) {

    print(_buttonEnabled);


    return Scaffold(
      appBar: IParkComponents.customAppBar(context),
      body: Padding(
        padding: IParkPaddings.mainScaffoldPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IParkComponents.headlineTextWidget("Add a photo", TextAlign.start),
              const SizedBox(height: 32,),
              imageWidgetDecider(),
              const SizedBox(height: 32,),
              Center(
                child: LargeCtaButton(textContent: "Save your car", onPressed: _buttonEnabled && _imageFile != null ? () async {
                  setState(() {
                    _buttonEnabled = false;
                  });
                String url = await FirebaseStorageService.uploadImageToFirebaseStorage(_imageFile!,  DateTime.now());
                CarModel model = CarModel(widget.title, widget.brand, widget.licensePlate, url, widget.chassisNumber);
                await CloudFirebaseService.addCarDataToFirestore(model, context);
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => CarsView()), (route) => false);
                  setState(() {
                    _buttonEnabled = true;
                  });
                } : null),
              )
            ],
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
                child: Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                  height: 311,
                )),
          ),
          const SizedBox(
            height: 24,
          ),
          Center(
            child: TextButton(
                onPressed: () {
                  setState(() {
                    _imageFile = null;
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
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text("Pick Image"),
            content: Text("Save the image of your car"),
            actions: [
              CupertinoDialogAction(
                  child: Text("Camera"),
                  onPressed: () async {
                    await _pickImage(ImageSource.camera);
                  }),
              CupertinoDialogAction(
                child: Text("Gallery"),
                onPressed: () async {
                  await _pickImage(ImageSource.gallery);
                },
              )
            ],
          ));
    } else {
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
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

}
