import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nestless/services/authentication.dart';
import 'package:image_picker/image_picker.dart';

//
//  just the skeleton code for now, not pushing anything more cuz i dont want anything to explode
//

class AddBirdPage extends StatefulWidget {
  final BaseAuth auth;
  final String uid;

  const AddBirdPage({
    Key? key,
    required this.auth,
    required this.uid,
  }) : super(key: key);

  @override
  State<AddBirdPage> createState() => _AddBirdPageState();
}

class _AddBirdPageState extends State<AddBirdPage> {
  final nameController = TextEditingController();
  final sNameController = TextEditingController();
  final statusController = TextEditingController();

  dynamic currentImg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          child: Column(
        children: [
          const SizedBox(height: 70),
          Row(
            children: [
              Container(width: 20),
              const Text("Name:"),
              Container(width: 76),
              Flexible(
                  child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder()))),
              Container(width: 50),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(width: 20),
              const Text("Scientific Name:"),
              Container(width: 15),
              Flexible(
                  child: TextField(
                controller: sNameController,
                decoration:
                    const InputDecoration(focusedBorder: OutlineInputBorder()),
              )),
              Container(width: 50),
            ],
          ),
          Row(
            children: [
              Container(width: 20),
              const Text("Status:"),
              Container(width: 72),
              Flexible(
                  child: TextField(
                      controller: statusController,
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder()))),
              Container(width: 50),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              //Navigator.pop(context);
              //imgFromCamera();
              imgFromGallery();
            },
            child: const Text('Test Button for camera/gallery'),
          ),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: currentImg != null
                  ? FileImage(currentImg)
                  : const NetworkImage(
                          'https://clipart.world/wp-content/uploads/2020/06/Question-Mark-clipart-transparent.png')
                      as ImageProvider,
            )),
          )
        ],
      )),
    );
  }

  Future imgFromCamera() async {
    // it works but it'll take 5 years for the camera to pop up
    var image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      File file = File(image!.path);
      currentImg = file;
    });
  }

  Future imgFromGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      File file = File(image!.path);
      currentImg = file;
    });
  }
}
