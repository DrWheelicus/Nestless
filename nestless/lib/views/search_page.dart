import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nestless/services/authentication.dart';

import 'package:nestless/views/bird_location_page.dart';

class SearchPage extends StatefulWidget {
  final BaseAuth auth;
  final String uid;

  const SearchPage({Key? key, required this.auth, required this.uid})
      : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchString = '';
  String currentDropValue = '[A-Z]';
  List<String> dropItems = ['[A-Z]', '[Z-A]', 'Rarity'];
  List<Map<String, dynamic>> birds = [], selectedBirds = [];
  Color? purple = Colors.deepPurpleAccent[100];

  @override
  void initState() {
    super.initState();
    createBirdList();
  }

  @override
  Widget build(BuildContext context) {
    String birdName;
    int birdCount = selectedBirds.length;
    if (selectedBirds.length > 20) {
      birdCount = 20;
    }
    return Column(children: [
      Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(children: [
          Flexible(
              flex: 4,
              child: Form(
                child: TextFormField(
                    decoration: InputDecoration(
                        focusColor: purple,
                        hintText: 'Search Birds',
                        icon: const Icon(Icons.search)),
                    onChanged: (String? value) {
                      setState(() {
                        _searchString = value.toString();
                        matchBirds();
                        sortBirds();
                      });
                    }),
              )),
          Flexible(
              flex: 1,
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                value: currentDropValue,
                iconEnabledColor: purple,
                iconDisabledColor: purple,
                items: dropItems.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newVal) {
                  setState(() {
                    currentDropValue = newVal.toString();
                    sortBirds();
                  });
                },
              )))
        ]),
      ),
      Flexible(
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              scrollDirection: Axis.vertical,
              itemCount: birdCount,
              itemBuilder: (BuildContext context, int i) {
                birdName = constrainName(selectedBirds[i]['commonName']);
                return Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: GridTile(
                        child: GestureDetector(
                            onTap: () => {
                                  if (selectedBirds[i]['location'] != null)
                                    {
                                      //! Add map page below and uncomment block
                                      //! If bird info needed use selectedBirds[i]
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BirdLocationPage(
                                                      selectedBirds[i])))
                                    }
                                  else
                                    {_showAlertDialog(context)}
                                },
                            child: Column(children: [
                              Image.network(
                                selectedBirds[i]['image'],
                                height: 105,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return const Image(
                                      image: AssetImage(
                                          'assets/images/bird-error.jpg'));
                                },
                              ),
                              Text(
                                birdName,
                                style: TextStyle(
                                    color: purple,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    height: 2),
                              ),
                              Text(
                                selectedBirds[i]['status'],
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic),
                              ),
                            ]))));
              }))
    ]);
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
      if (bird['commonName']
          .toLowerCase()
          .contains(_searchString.toLowerCase())) {
        if (selectedBirds.length >= 20) return;
        selectedBirds.add(bird);
      }
    }
  }

  String constrainName(String name) {
    if (name.length > 18) {
      return name.substring(0, 15) + '...';
    }
    return name;
  }

  void sortBirds() {
    if (currentDropValue == 'Rarity') {
      selectedBirds.sort((a, b) => a['status'].compareTo(b['status']));
    }
    //Sort alphabetically
    else {
      selectedBirds.sort((a, b) => a['commonName'].compareTo(b['commonName']));
    }
    //Reverse for [Z-A] and highest rarity
    if (currentDropValue != '[A-Z]') {
      selectedBirds = List.from(selectedBirds.reversed);
    }
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
                  child: Text("OK",
                      style:
                          TextStyle(fontSize: 20, color: Colors.purpleAccent))),
            ],
          );
        }).then((value) {
      setState(() {});
    });
  }
}
