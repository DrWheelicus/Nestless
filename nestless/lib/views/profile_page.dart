// import 'dart:developer';
// import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:nestless/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nestless/views/bird_location_page.dart';

class ProfilePage extends StatefulWidget {
  final BaseAuth auth;
  final String uid;

  const ProfilePage({required this.uid, Key? key, required this.auth})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username;
  String? email;
  String? photoURL;
  String? uid;
  String? latestCommon;
  String? image;
  int points = 0;
  List<Map<String, dynamic>> birdsSeen = [];
  Map<String, dynamic> latestSeen = {};
  String? profilePictureURL;
  final profilePictureURLController = TextEditingController();
  final userNameController = TextEditingController();
  final users = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    getSeenBirds();
  }

  @override
  Widget build(BuildContext context) {
    getUserInfo();
    pointCalc();

    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/forest-background.jpg')),
      ),
      child: GlassContainer(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        borderColor: Colors.transparent,
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Row(children: [
            const SizedBox(
              width: 20,
            ),
            Column(children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            content: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Form(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: profilePictureURLController,
                                      decoration: const InputDecoration(
                                          focusedBorder: OutlineInputBorder()),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      String? photoURL =
                                          profilePictureURLController.text;
                                      updateURL(photoURL);
                                      return Navigator.pop(context);
                                    },
                                    child: const Text("Submit"),
                                  ),
                                ]))
                          ],
                        ));
                      });
                },
                child: CircleAvatar(
                    backgroundImage: NetworkImage(photoURL ??
                        "https://avatarfiles.alphacoders.com/976/thumb-1920-97632.jpg"),
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.edit),
                    radius: 50),
              ),
              const Text("Edit")
            ]),
            const SizedBox(
              width: 20,
            ),
            Column(children: [
              const Text(
                "Username",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 30,
                width: 200,
                child: TextField(
                  controller: userNameController,
                  onSubmitted: (String? value) {
                    updateUsername(value.toString());
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.all(5.0),
                    hintText: username,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "E-mail",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 30,
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.all(5.0),
                      hintText: email),
                  readOnly: true,
                ),
              ),
              const SizedBox(
                height: 15,
              )
            ]),
            const SizedBox(
              width: 10,
            )
          ]),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Most Recent Sighting",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 25,
            height: 150,
            child: Row(children: [
              Image.network(
                latestSeen['image'],
                height: 105,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Image(
                      width: 200,
                      image: AssetImage(
                        'assets/images/bird-error.jpg',
                      ));
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    latestSeen['commonName'],
                    style: TextStyle(
                        color: Colors.deepPurpleAccent[100],
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    latestSeen['status'],
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              )
            ]),
          ),
          const SizedBox(
            height: 7,
          ),
          const Text(
            "All Seen Birds",
            style: TextStyle(fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Points: ",
                style: TextStyle(fontSize: 15),
              ),
              Text(
                pointCalc(),
                style: const TextStyle(fontSize: 15),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
              width: MediaQuery.of(context).size.width - 25,
              height: MediaQuery.of(context).size.height - 551,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  scrollDirection: Axis.vertical,
                  itemCount: birdsSeen.length,
                  itemBuilder: (BuildContext context, int i) {
                    String birdName = constrainName(birdsSeen[i]['commonName']);
                    return Card(
                        child: GridTile(
                            child: GestureDetector(
                                onTap: () => {
                                      if (birdsSeen[i]['location'] != null)
                                        {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BirdLocationPage(
                                                          birdsSeen[i])))
                                        }
                                      else
                                        {_showAlertDialog(context)}
                                    },
                                child: Column(children: [
                                  Image.network(
                                    birdsSeen[i]['image'],
                                    height: 105,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return const Image(
                                          image: AssetImage(
                                        'assets/images/bird-error.jpg',
                                      ));
                                    },
                                  ),
                                  Text(
                                    birdName,
                                    style: TextStyle(
                                        color: Colors.deepPurpleAccent[100],
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    birdsSeen[i]['status'],
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic),
                                  ),
                                ]))));
                  }))
        ]),
      ),
    ));
  }

  void getSeenBirds() async {
    var querySnap = await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.uid)
        .get();

    birdsSeen = [];
    setState(() {
      for (int i = 0; i < querySnap['birdsSeen'].length; i++) {
        birdsSeen.add(querySnap['birdsSeen'][i]);
      }
    });
  }

  String pointCalc() {
    points = 0;

    for (int i = 0; i < birdsSeen.length; i++) {
      String rarityString = birdsSeen[i]['status'].split(" ")[0];
      if (rarityString == 'common') {
        points += 30;
      } else if (rarityString == 'uncommon') {
        points += 75;
      } else if (rarityString == 'irregular') {
        points += 150;
      }
    }

    return points.toString();
  }

  String constrainName(String name) {
    if (name.length > 18) {
      return name.substring(0, 15) + '...';
    }
    return name;
  }

  void getUserInfo() async {
    var querySnap = await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.uid)
        .get();

    username = querySnap['username'];
    email = querySnap['email'];
    photoURL = querySnap['photoURL'];
    latestSeen = querySnap['latestSeen'];
    latestCommon = querySnap['latestSeen']['commonName'];
  }

  void updateURL(String URL) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.uid)
        .update({'photoURL': URL});
    setState(() {});
  }

  void updateUsername(String username) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.uid)
        .update({'username': username});

    setState(() {});
  }

  _showAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Location Error"),
            content: const Text("No Locations Found"),
            actions: [
              TextButton(
                  onPressed: () {
                    return Navigator.pop(context);
                  },
                  child: const Text("OK",
                      style:
                          TextStyle(fontSize: 20, color: Colors.purpleAccent))),
            ],
          );
        }).then((value) {
      setState(() {});
    });
  }

  @override
  // ignore: must_call_super
  void dispose() {
    userNameController.dispose();
    profilePictureURLController.dispose();
  }
}
