import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:nestless/services/authentication.dart';

class ProfilePage extends StatefulWidget {
  final BaseAuth auth;
  final String uid;

  const ProfilePage({required this.uid, Key? key, required this.auth})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

//Profile Picture URL, List of seen birds, Username, Email, Latest Seen bird

// ! ASSUMING I HAVE THE EMAIL

//Load page -> Get specific user from db -> whenever an edit is made, call a function that edits in firebase.

class _ProfilePageState extends State<ProfilePage> {
  List<Map<String, dynamic>> birds = [];
  String? profilePictureURL;
  final profilePictureURLController = TextEditingController();
  final userNameController = TextEditingController();
  String userName = "";
  final users = FirebaseFirestore.instance.collection('users');

  // Future<void> addUser(String url, String username, String email,  List<Map<String, dynamic>> birdsSeen,  Map<String, dynamic>  latestSeen) {
  //   return users.add({
  //     'url': url,
  //     'username': username,
  //     'email': email,
  //     'birdsSeen': birdsSeen,
  //     'latestSeen': latestSeen,
  //   });
  // }

  @override
  void initState() {
    super.initState();
    createBirdList();
  }

  void getUserInfo() async {
    // String id = widget.auth.getCurrentUser().uid;
    var userDetails = await users.doc(widget.uid).get();
    userName = userDetails['username'];
    profilePictureURL = userDetails['url'];
  }

  @override
  Widget build(BuildContext context) {
    // getUserInfo();
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
                                      String? profilePictureURL =
                                          profilePictureURLController.text;
                                      updateURL(profilePictureURL);
                                    },
                                    child: const Text("Submit"),
                                  ),
                                ]))
                          ],
                        ));
                      });
                },
                child: CircleAvatar(
                    backgroundImage: NetworkImage(profilePictureURL ??
                        "https://static.wikia.nocookie.net/ricksanchez/images/3/30/Birdperson.jpg/revision/latest/top-crop/width/360/height/450?cb=20191107125636"), // ! FUCKING CHANGE THE URL BEFORE YOU SUBMIT JESUS CHRIST
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
                    userName = userNameController.text;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.all(5.0),
                    hintText: userName,
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
                      hintText: widget.uid),
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
              Image.network(birds[0]['image']),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    birds[0]['commonName'],
                    style: TextStyle(
                        color: Colors.deepPurpleAccent[100],
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    birds[0]['status'],
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              )
            ]),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "All Seen Birds",
            style: TextStyle(fontSize: 20),
          ),
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
                    ])));
                  }))
        ]),
      ),
    ));
  }

  void createBirdList() async {
    QuerySnapshot<Map<String, dynamic>> querySnap =
        await FirebaseFirestore.instance.collection('birds').get();
    setState(() {
      for (var docSnap in querySnap.docs) {
        birds.add(docSnap.data());
      }
    });
  }

  String constrainName(String name) {
    if (name.length > 18) {
      return name.substring(0, 15) + '...';
    }
    return name;
  }

  void updateURL(String URL) {
    widget.auth.getCurrentUser().then((user) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'photoUrl': URL});
    });
  }

  void updateUsername(String username) async {
    widget.auth.getCurrentUser().then((user) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'username': username});
    });
  }
}
