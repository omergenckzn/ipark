import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ipark/Services/ffi.dart';
import 'package:permission_handler/permission_handler.dart';


class TestCpp extends StatefulWidget {
  const TestCpp({Key? key}) : super(key: key);

  @override
  State<TestCpp> createState() => _TestCppState();
}

class _TestCppState extends State<TestCpp> {

  String? imagePath;
  int processMillisecond = 0;


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
      Stopwatch stopwatch = new Stopwatch()..start();
      convertImageToGrayImage(imagePath!, outputPath.join("."));
      print('Image convert executed in ${stopwatch.elapsed}');
      processMillisecond = stopwatch.elapsedMilliseconds;
      stopwatch.stop();
      this.setState(() {
        imagePath = outputPath.join(".");
      });
    }
  }

  void _onSelectImageClick() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (image == null) return;
    setState(() => this.imagePath = image.path);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: imagePath != null ? Image.file(File(imagePath!), gaplessPlayback: true) : Container()),
          ElevatedButton(onPressed: (){_onSelectImageClick();
          }, child: Text("Select")),
          ElevatedButton(onPressed: (){
            _onConvertClick();
          }, child: Text("Convert"))
        ],
      ),
    );
  }
}
