import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nestless/services/authentication.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Bird {
  String name;
  String sName;
  String stat;
  dynamic image;

  Bird(this.name, this.sName, this.stat, this.image);

  Map<String, dynamic> toMap() {
    return {
      'commonName': name,
      'image': image,
      'sciName': sName,
      'status': stat,
    };
  }
}

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
  final user = FirebaseFirestore.instance.collection('user');

  dynamic selectedStat;
  dynamic selectedImg;

  int choiceIndex = 0;
  List<String> statsList = [
    "common / Native",
    "uncommon / Native",
    "irregular / Native"
  ];

  late Map<String, dynamic> birdList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          child: Column(
        children: [
          const SizedBox(height: 10),
          const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://avatarfiles.alphacoders.com/976/thumb-1920-97632.jpg"),
              backgroundColor: Colors.blue,
              radius: 50),
          const SizedBox(height: 20),
          const Text("Save Your Collection!"),
          const SizedBox(height: 5),
          Row(
            children: [
              Container(width: 20),
              const Text("Bird Name:"),
              Container(width: 50),
              Flexible(
                  child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder()))),
              Container(width: 42),
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
          Row(children: [
            Container(width: 20),
            const Text("Select a Status:"),
            Container(width: 50),
            Flexible(
                child: Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(statsList.length, (index) {
                return ChoiceChip(
                  labelPadding: const EdgeInsets.all(2.0),
                  label: Text(
                    statsList[index],
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.white, fontSize: 14),
                  ),
                  selected: choiceIndex == index,
                  selectedColor: Colors.deepPurple,
                  onSelected: (value) {
                    setState(() {
                      choiceIndex = value ? index : choiceIndex;
                      selectedStat = statsList[choiceIndex];
                    });
                  },
                  elevation: 1,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                );
              }),
            ))
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: selectedImg != null
                          ? FileImage(selectedImg)
                          : const NetworkImage(
                                  'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg')
                              as ImageProvider,
                    )),
              ),
              const SizedBox(width: 15),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      imgFromCamera();
                    },
                    child: const Text('Take A Photo'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      imgFromGallery();
                    },
                    child: const Text('Upload Photo'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              _showAlertDialog(context);
              // print();
            },
            child: const Text('Submit Bird Info'),
          ),
        ],
      )),
    );
  }

  Future imgFromCamera() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      File file = File(image!.path);
      selectedImg = file;
    });
  }

  Future imgFromGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      File file = File(image!.path);
      selectedImg = file;
    });
  }

  addData(var data) async {
    var querySnap = await user.doc(widget.uid).get();

    querySnap['birdsSeen'].add({
      'commonName': data['commonName'],
      'image': data['image'],
      'sciName': data['sciName'],
      'status': data['status']
    });
  }

  updateData(var data) async {
    var querySnap = await user.doc(widget.uid);

    querySnap.update({
      'latestSeen.commonName': data['commonName'],
      'latestSeen.sciName': data['sciName'],
      'latestSeen.status': data['status']
    });
  }

  _showAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Save Data"),
            content: const Text("Please Confirm"),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                  onPressed: () {
                    return Navigator.pop(context);
                  },
                  child: const Text("Cancel",
                      style:
                          TextStyle(fontSize: 20, color: Colors.purpleAccent))),
              Container(width: 50),
              TextButton(
                  onPressed: () async {
                    birdList = (Bird(nameController.text, sNameController.text,
                            selectedStat, selectedImg.toString())
                        .toMap());

                    addData(birdList);
                    updateData(birdList);

                    return Navigator.pop(context);
                  },
                  child: const Text("Confirm",
                      style:
                          TextStyle(fontSize: 20, color: Colors.purpleAccent))),
            ],
          );
        }).then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    sNameController.dispose();
    super.dispose();
  }
}
