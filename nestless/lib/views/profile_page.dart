import 'dart:developer';
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

//Profile Picture URL, List of seen birds, Username, Email, Latest Seen bird
//Load page -> Get specific user from db -> whenever an edit is made, call a function that edits in firebase.

class _ProfilePageState extends State<ProfilePage> {
  // String email = "";

  // Future<void> addUser(String url, String username, String email,  List<Map<String, dynamic>> birdsSeen,  Map<String, dynamic>  latestSeen) {
  //   return users.add({
  //     'url': url,
  //     'username': username,
  //     'email': email,
  //     'birdsSeen': birdsSeen,
  //     'latestSeen': latestSeen,
  //   });
  // }
  String? username;  
  String? email;
  String? photoURL;
  String? uid;
  int points = 0;
  List<Map<String, dynamic>> birds = [];
  Map<String, dynamic> latestSeen = {};
  String? profilePictureURL;
  final profilePictureURLController = TextEditingController();
  final userNameController = TextEditingController();
  final users = FirebaseFirestore.instance.collection('users');
  
  
  @override
  void initState() {
    super.initState();
    createBirdList();
      
  }

  // Future<String> getEmail() async{
  //   // return await widget.auth.getCurrentUser().then((user) => user!.email);
  // }

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
                                    padding: EdgeInsets.all(8.0),
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
                    print(value);
                    updateUsername(value.toString());
                    // username = userNameController.text;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.all(5.0),
                    hintText: username,
                  ),
                  // readOnly: true,
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
            // padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            width: MediaQuery.of(context).size.width - 25,
            height: 150,
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.black)
            // ),
            child: Row(children: [
              Image.network(latestSeen['image']?? "https://avatarfiles.alphacoders.com/976/thumb-1920-97632.jpg"),
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
            ],),
          const SizedBox(
            height: 5,
          ),
          Container(
              width: MediaQuery.of(context).size.width - 25,
              height: MediaQuery.of(context).size.height - 551,
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.black)
              // ),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  scrollDirection: Axis.vertical,
                  itemCount: birds.length,
                  itemBuilder: (BuildContext context, int i) {
                    String birdName = constrainName(birds[i]['commonName']);
                    return Card(
                        child: GridTile(
                            child: GestureDetector(
                            onTap: () => {
                              if (birds[i]['location'] != null){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => BirdLocationPage(birds[i])))
                              } else {_showAlertDialog(context)}
                            },
                          child: Column(children: [
                            Image.network(
                              birds[i]['image'],
                              height: 105,
                              errorBuilder: (BuildContext context, Object exception,
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
                              birds[i]['status'],
                              style: const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ]))));
                  }))
        ]),
      ),
    ));
  }

  void createBirdList() async {
    // User? user = await widget.auth.getCurrentUser();
    QuerySnapshot<Map<String, dynamic>> querySnap =
        await FirebaseFirestore.instance.collection('birds').get();
    

    setState(() {
      for (var docSnap in querySnap.docs) {
        birds.add(docSnap.data());
      }

    });
  }

  String pointCalc(){
    points = 0;

    for(int i = 0; i < birds.length; i++){
      String rarityString = birds[i]['status'].split(" ")[0];
      if(rarityString == 'common'){
        points += 30;
      }
      else if(rarityString == 'uncommon'){
        points += 75;
      }
      else if(rarityString == 'irregular'){
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
    // QuerySnapshot<Map<String, dynamic>> querySnap =
    //     await FirebaseFirestore.instance.collection('users').get();
    // String id = widget.auth.getCurrentUser().uid;
    
    print("Pass");
    // print(querySnap.docs);
    var userDetails = await users.doc(widget.uid).get();
    User? user = await widget.auth.getCurrentUser();
    email = user!.email;
    uid = user.uid;
    
    // user.updateDisplayName("Pass");
    username = user.displayName;
    photoURL = user.photoURL;
    // updateUsername("ColiKong");
    // String? 
    // print(email);
    latestSeen = birds[0];
    print(latestSeen['commonName']);
    print("UID below");
    print(uid);
    print("Username below");
    print(username);
    username = userDetails['username'];
    profilePictureURL = userDetails['url'];
  }

  void updateURL(String URL) async{
    User? user = await widget.auth.getCurrentUser();
    setState(() {
    user!.updatePhotoURL(URL);
    
    });

    }
    // widget.auth.getCurrentUser().then((user) {
    //   FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(user!.uid)
    //       .update({'photoUrl': URL});
    // });

  void updateUsername(String username) async {
    User? user = await widget.auth.getCurrentUser();
    user!.updateDisplayName(username);
  //   widget.auth.getCurrentUser().then((user) {
  //     FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user!.uid)
  //         .update({'displayName': username});
  //   });
  // }
  }
  _showAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Location Error"),
            content: Text("No Locations Found"),
            actions: [
              TextButton(
                  onPressed: () {	
                    return Navigator.pop(context);
                  },
                  child: Text("OK", style: TextStyle(fontSize: 20, color: Colors.purpleAccent))),
            ],
          );
        }).then((value) {
      setState(() {});
    });
  }

  @override
  // ignore: must_call_super
  void dispose(){
    userNameController.dispose();
    profilePictureURLController.dispose();
  }
}