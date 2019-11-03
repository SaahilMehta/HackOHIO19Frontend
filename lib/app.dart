import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'input.dart';
import 'pin.dart';
import 'package:http/http.dart' as http;

class MyHome extends StatefulWidget {
  MyHomePage createState() => MyHomePage();
}

class MyHomePage extends State<MyHome> {
  bool userSelectingPosition = false;
  // AppState appState = AppState();
  GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId currentMarker;
  int idCounter = 1;
  String url = "http://8fd924eb.ngrok.io";
  Future<Pins> pins;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // Fill in points from API response
    String uri = url + "/pins";

    var res = http
        .get(uri)
        .then((res) => Pins.fromJson(json.decode(res.body)).pins.forEach(
          (pin) => _putMarker(LatLng(pin.latitude, pin.longitude), pin.title)));
  }

  void _onMarkerTap(MarkerId mid) {
    final Marker tapped = markers[mid];
    if (tapped == null) return;
    setState(() {
      if (markers.containsKey(currentMarker)) {
        final Marker resetMarker = markers[currentMarker].copyWith(iconParam:
        BitmapDescriptor.defaultMarker);
        markers[currentMarker] = resetMarker;
      }
      currentMarker = mid;
      final Marker newMarker = tapped.copyWith(iconParam:
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue,
      ));
      markers[mid] = newMarker;
    });
  }

  void _addMarker(LatLng location, List<String> pinData) async {
    _putMarker(location, pinData[0]);

    String latitude = pinData[3]
        .substring(pinData[3].indexOf('(') + 1, pinData[3].indexOf(','));
    String longitude = pinData[3]
        .substring(pinData[3].indexOf(" ") + 1, pinData[3].indexOf(')'));

    // print("$pinData[3]");
    // print("$latitude, $longitude");

    // HTTP POST to backend
    var url = "http://8fd924eb.ngrok.io/pins";
    var response = await http.post(url, headers:{"Content-Type":"application/json"} ,body: utf8.encode(json.encode({
      'title': pinData[0],
//      'tags': pinData[1],
      'description': pinData[2],
      'latitude': location.latitude,
      'longitude': location.longitude,
      // 'datetime_posted': pinData[4],
    })));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    print("$pinData");
  }

  void _putMarker(LatLng location, String title) async {
    final int markerCount = markers.length;
    idCounter++;
    final MarkerId markerId = MarkerId(title);

    final Marker marker = Marker(
      markerId: markerId,
      position: location,
      infoWindow: InfoWindow(title: idValue),
      onTap: () {
        _onMarkerTap(markerId);
      },
      //add functions to drag/tap/whatever here
    );

    setState(() {
      markers[markerId] = marker;
    });

    print("Pin added to map at $location");
  }

  void _deleteMarker() {
    setState(() {
      if (markers.containsKey(currentMarker)) {
        markers.remove(currentMarker);
      }
    });
  }

  _determineTapPosition(LatLng argument) async {
    if (userSelectingPosition) {
      userSelectingPosition = false;
      final result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => PinTextInput(argument)));
      _addMarker(argument, result);

      // print('DEBUG------');
      // for (var i = 0; i < result.length; i++) {
      //   print("$result[i]\n");
      // }

    }
  }

//    mapController.addMarker(
//      MarkerOptions(
//        position: center, //fix me
//        infoWindowText: InfoWindow("title", "content"),
//        icon: FontAwesomeIcons.mapPin,
//      ),
//    );

  @override
  Widget build(BuildContext context) {
    // Widget thumbTack = IconButton(
    //   // Use the FontAwesomeIcons class for the IconData
    //     icon: Icon(FontAwesomeIcons.mapPin),
    //     onPressed: () { print("Pressed"); }
    // );
    return Scaffold(
        appBar: AppBar(
          title: Text('Pin App'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: Set<Marker>.of(markers.values),
            onTap: _determineTapPosition,
          ),
        ]),
        drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          Container(
            height: 80.0,
            child: DrawerHeader(
              child: Text(
                'Options',
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              // margin: EdgeInsets.all(0),
            ),
          ),
          ListTile(
            title: Text('Select Categories'),
            onTap: () {
              // Close drawer
              // Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Top Pins'),
            onTap: () {
              // Navigator.pop(context);
            },
          )
        ])),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('Press the screen to select a location');
            userSelectingPosition = true;
          },
          tooltip: 'Drop pin',
          child: const Icon(Icons.add),
        ));
  }
}
