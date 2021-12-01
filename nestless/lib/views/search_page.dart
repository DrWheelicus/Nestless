import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
} 

class _SearchPageState extends State<SearchPage> {
  final birds = FirebaseFirestore.instance.collection('birds');
  String _searchString = '';
  
  @override 
  Widget build(BuildContext context) {
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
              });
            }
          ),
        ),
        Flexible(
          child: StreamBuilder(
            stream: getBirds(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return const Text("No Data");
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2
                ),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int i) {
                  return Container(
                    child: GridTile(
                      child: Column(
                        children: [
                          //TODO: Get image to appear / format card
                          Text(snapshot.data!.docs[i]['commonName']),
                          Text(snapshot.data!.docs[i]['status']),
                          // Image.network(snapshot.data!.docs[i]['image']),
                        ]
                      )
                    )
                  );
                }
              );
            }
          ),
        )
      ]
    );
  }
  //TODO: Implement partial strings
  Stream<QuerySnapshot<Map<String, dynamic>>> getBirds() {
    return birds
      .where('commonName', isEqualTo: _searchString)
      .get()
      .asStream();
  }
}