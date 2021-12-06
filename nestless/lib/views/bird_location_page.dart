import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

var birdLocation = [];

Map<String, dynamic> locationMap = {
  "Cochrane": LatLng(49.147492170525624, -81.0280137279443),
  "Durham": LatLng(44.043002338330055, -78.99646903630611),
  "Frontenac": LatLng(44.6736689668133, -76.69721695509365),
  "Haliburton": LatLng(45.04808412206183, -78.50673798368301),
  "Halton": LatLng(43.53870616955673, -79.89386616342586),
  "Hastings": LatLng(44.310775371012596, -77.95690229178028),
  "Huron": LatLng(43.67747219161803, -81.46847822428738),
  "Kawartha Lakes": LatLng(44.497681046941494, -78.7936483701656),
  "Kenora": LatLng(49.807518363110454, -94.43778609206711),
  "Middlesex": LatLng(43.01516646412307, -81.4387512598386),
  "Muskoka County": LatLng(45.07626736095936, -79.56368570837442),
  "Niagara County": LatLng(43.09727045468845, -79.04379299010748),
  "Nipissing": LatLng(46.09770325900121, -79.51540395025195),
  "Ottawa": LatLng(45.25067730088814, -75.78064022411635),
  "Oxford": LatLng(43.11440700341908, -80.7802419103672),
  "Parry Sound": LatLng(45.350868226439765, -80.03556464743606),
  "Peel": LatLng(43.74587614311995, -79.78503255969794),
  "Renfrew": LatLng(45.47752798869933, -76.68765708218773),
  "Simcoe": LatLng(42.83964112738611, -80.30396069908679),
  "Sudbury": LatLng(46.603799902885804, -81.0435565674404),
  "Thunder bay": LatLng(48.48250756159512, -89.27345208077877),
  "Toronto": LatLng(43.73056118675157, -79.36639424040379),
  "Waterloo": LatLng(43.479955089129746, -80.54431844794482),
  "York": LatLng(43.68880067270585, -79.47557963432018)
};

class BirdLocationPage extends StatefulWidget {
  Map<String, dynamic> selectedBirds;

  BirdLocationPage(this.selectedBirds);

  @override
  State<BirdLocationPage> createState() =>
      _BirdLocationPageState(this.selectedBirds);
}

class _BirdLocationPageState extends State<BirdLocationPage> {
  Map<String, dynamic> selectedBirds;
  _BirdLocationPageState(this.selectedBirds);
  var center = LatLng(43.86567452537625, -79.19257823567597);
  var myLocation = LatLng(43.86567452537625, -79.19257823567597);
  String locationName = "";
  List<Marker> markerList = [];
  List<CircleMarker> circleList = [];

  getLocations(Map map) {
    map.keys.forEach((key) {
      birdLocation.add(key);
    });
  }

  @override
  void initState() {
    super.initState();
    getLocations(selectedBirds['location']);
    for (int i = 0; i < birdLocation.length; i++) {
      markerList.add(
        Marker(
            point: locationMap[birdLocation[i]],
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  setState(() {
                    locationName = birdLocation[i];
                  });
                },
                icon: const Icon(Icons.location_on),
                iconSize: 30.0,
                color: Colors.blueAccent,
              );
            }),
      );
      circleList.add(CircleMarker(
          point: locationMap[birdLocation[i]],
          color: Colors.blue.withOpacity(0.1),
          borderStrokeWidth: 3.0,
          borderColor: Colors.blue,
          radius: 100));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Positioned.fill(
          child: Opacity(opacity: 0.5, child: Container(color: Colors.black))),
      Padding(
          padding: const EdgeInsets.all(30.0),
          child: Stack(children: [
            Positioned.fill(
                child: FlutterMap(
                    options: MapOptions(zoom: 9.0, center: myLocation),
                    layers: [
                  TileLayerOptions(
                      urlTemplate:
                          "https://api.mapbox.com/styles/v1/caspeer1/ckwk0q0gs727u15n0za67z7pt/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiY2FzcGVlcjEiLCJhIjoiY2t3anlkZ3A3MW4wajJ3bm9hNWFxZzl1NiJ9.RAJ1MnWBMPyoqXH7Fdhn3A",
                      additionalOptions: {
                        'accessToken':
                            'pk.eyJ1IjoiY2FzcGVlcjEiLCJhIjoiY2t3anlkZ3A3MW4wajJ3bm9hNWFxZzl1NiJ9.RAJ1MnWBMPyoqXH7Fdhn3A',
                        'id': 'mapbox.mapbox-streets-v8'
                      }),
                  CircleLayerOptions(circles: circleList),
                  MarkerLayerOptions(markers: markerList)
                ])),
            Positioned(
                bottom: 25,
                left: 25,
                child: Opacity(
                    opacity: 0.9,
                    child: Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.blue),
                        height: 50,
                        width: 125,
                        child: Stack(children: [
                          const Positioned(
                              top: 5,
                              left: 5,
                              child: Text("Selected Location:",
                                  style: TextStyle(color: Colors.white))),
                          Positioned(
                              bottom: 5,
                              left: 5,
                              child: Text(locationName,
                                  style: const TextStyle(color: Colors.white)))
                        ])))),
            Positioned(
                top: 25,
                right: 15,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Close"))),
            Positioned(
                bottom: 25,
                right: -35,
                child: ElevatedButton(
                    onPressed: () async {
                      Position userCoords = await _currentLocation();
                      var userLocation =
                          LatLng(userCoords.latitude, userCoords.longitude);
                      setState(() {
                        // myLocation = userLocation;
                        if (myLocation !=
                            LatLng(43.86567452537625, -79.19257823567597)) {
                          markerList.removeLast();
                        }
                        markerList.add(
                          Marker(
                              point: myLocation,
                              builder: (BuildContext context) {
                                return IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.circle_outlined),
                                  iconSize: 30.0,
                                  color: Colors.blueAccent,
                                );
                              }),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      minimumSize: const Size(150, 48),
                    ),
                    child: const Icon(Icons.my_location)))
          ]))
    ]));
  }

  Future<Position> _currentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }
}

class Location {
  String name, address;
  LatLng coordinates;

  Location(this.name, this.address, this.coordinates);
}
