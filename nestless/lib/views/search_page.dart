import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
} 

class _SearchPageState extends State<SearchPage> {
  String _searchString = '';
  List<Map<String, dynamic>> birds = [];
  List<Map<String, dynamic>> selectedBirds = [];

  @override
  void initState() {
    super.initState();
    createBirdList();
  }

  @override 
  Widget build(BuildContext context) {
    int birdCount = selectedBirds.length;
    if (selectedBirds.length > 20) { birdCount = 20; }
    return Column(
      children: [
        Form(
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Search Bird',   
              icon: Icon(Icons.search)
            ),
            onChanged: (String? value) {
              setState(() {
                _searchString = value.toString();
                matchBirds();
              });
            }
          ),
        ),
        Flexible(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2
            ),
            scrollDirection: Axis.vertical,
            itemCount: birdCount,
            itemBuilder: (BuildContext context, int i) {
              return Container(
                child: GridTile(
                  child: Column(
                    children: [
                      Image.network(
                        selectedBirds[i]['image'],
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return const Image(
                            image: AssetImage('assets/images/bird-error.jpg')
                          );
                        },
                      ),
                      Text(
                        selectedBirds[i]['commonName'],
                        style: TextStyle(
                          color: Colors.deepPurpleAccent[100],
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        selectedBirds[i]['status'],
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

  void matchBirds() {
    selectedBirds = [];
    for (Map<String, dynamic> bird in birds) {
      if (bird['commonName'].contains(_searchString)) {
        selectedBirds.add(bird);
      }
    }
  }
}