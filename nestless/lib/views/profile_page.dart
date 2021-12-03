import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
} 

class _ProfilePageState extends State<ProfilePage> {
  List<Map<String, dynamic>> birds = [];

  @override
  Widget build(BuildContext context) {
    createBirdList();
    return Scaffold(
      body: 
        Container(
          height: MediaQuery.of(context).size.height, 
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/forest-background.jpg')
            ),
          ),
          child: GlassContainer(
          
          height: MediaQuery.of(context).size.height, 
          width: MediaQuery.of(context).size.width, 
          
          color: Colors.transparent, 
          borderColor: Colors.transparent,
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Row(
                children:[
                  const SizedBox(width: 20,),
                  Column(
                  children: const [CircleAvatar(
                    backgroundImage: NetworkImage(""),//TODO apply a url for the user's profile 
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.edit),
                    radius: 50
                    ),
                    Text("Edit")
                    ]
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    children: const [
                      Text("Username",
                        style: TextStyle(fontSize: 20),
                        ), 
                      SizedBox(height: 5,),
                      SizedBox(
                        height: 30,
                        width: 200,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(5.0),
                            hintText: "ColiKong"
                            ),
                          // readOnly: true,
                          ),
                        ),
                      SizedBox(height: 5,),
                      Text("E-mail",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 5,),
                      SizedBox(
                        height: 30,
                        width: 200,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(5.0),
                            hintText: "colinator0@hotmail.com"
                            ),
                          readOnly: true,
                          ),
                        ),
                        SizedBox(height: 15,)
                      ]
                    ),
                  const SizedBox(width: 10,)
                ]
              ),
              const SizedBox(height: 20,),
              const Text("Most Recent Sighting",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 5,),
              Container(
                // padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                width: MediaQuery.of(context).size.width-25,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black)
                ),
                child: Row(
                  
                  children: [
                    
                    Image.network(birds[0]['image']),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          birds[0]['commonName'],
                          style: TextStyle(
                            color: Colors.deepPurpleAccent[100],
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          birds[0]['status'],
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    )


                    ]
                ),
              ),
              const SizedBox(height: 30,),
              const Text("All Seen Birds",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 5,),
              Container(
                width: MediaQuery.of(context).size.width-25,
                height: MediaQuery.of(context).size.height-551,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black)
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: birds.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: GridTile(
                        child: Column(
                          children: [
                            Image.network(
                              birds[i]['image'],
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return const Image(
                                  image: AssetImage('assets/images/bird-error.jpg')
                                );
                              },
                            ),
                            Text(
                              birds[i]['commonName'],
                              style: TextStyle(
                                color: Colors.deepPurpleAccent[100],
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              birds[i]['status'],
                              style: const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ]
                        )
                      )
                    );
                  }
                )
              )
            ]
          ),
        ),
      )
      );  
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
}