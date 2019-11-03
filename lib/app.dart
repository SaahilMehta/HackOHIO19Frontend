import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final LatLng _center = const LatLng(40, -83);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId currentMarker;
  int idCounter = 1;
  String url = "http://57c2619e.ngrok.io";
  Future<Pins> pins;
  bool showVoting = false;
  int currentTotal = 0;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (markers.containsKey(currentMarker)) {
        final Marker resetMarker = markers[currentMarker].copyWith(iconParam:
        BitmapDescriptor.defaultMarker);
        markers[currentMarker] = resetMarker;
    }
    // Fill in points from API response
    String uri = url + "/pins";

    var res = http
        .get(uri)
        .then((res) => Pins.fromJson(json.decode(res.body)).pins.forEach(
          (pin) => _putMarker(LatLng(pin.latitude, pin.longitude), pin.title, pin.description)));
  }

  void _onMarkerTap(MarkerId mid, LatLng location) {
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
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta,
      ));
      markers[mid] = newMarker;
    });
    setState(() {
      showVoting = true;
    });
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: location,
      zoom: 15.0,
    )));
  }

  void _addMarker(LatLng location, List<String> pinData) async {
    _putMarker(location, pinData[0], pinData[2]);

    String latitude = pinData[3]
        .substring(pinData[3].indexOf('(') + 1, pinData[3].indexOf(','));
    String longitude = pinData[3]
        .substring(pinData[3].indexOf(" ") + 1, pinData[3].indexOf(')'));

    // print("$pinData[3]");
    // print("$latitude, $longitude");

    // HTTP POST to backend
    var url = "http://57c2619e.ngrok.io/pins";
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

  void _putMarker(LatLng location, String title, String description) async {
    idCounter++;
    final MarkerId markerId = MarkerId(title);

    final Marker marker = Marker(
      markerId: markerId,
      position: location,
      infoWindow: InfoWindow(title: title, snippet:  description),
      onTap: () {
        _onMarkerTap(markerId, location);
      },
    );

    setState(() {
      markers[markerId] = marker;
      _onMarkerTap(markerId, location);
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

  void _resetGlobals() {
    setState(() {
      showVoting = false;
      currentTotal = 0;
      if (markers.containsKey(currentMarker)) {
        final Marker resetMarker = markers[currentMarker].copyWith(iconParam:
        BitmapDescriptor.defaultMarker);
        markers[currentMarker] = resetMarker;
      }
    });
  }

  void _determineTapPosition(LatLng argument) async {
    if (userSelectingPosition) {
      userSelectingPosition = false;
      final result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => PinTextInput(argument)));
      _addMarker(argument, result);

    } else {
      _resetGlobals();
    }
  }

  void _updateVoting(int upvotes, int downvotes, MarkerId mid) async {
    // get pin from API response
    var res, i;
    var markerList = markers.values.toList();
    for (i = 0; i < markerList.length; i++) {
      if (markerList[i] == markers[mid]) break;
    }
    if (upvotes > 0) {
      String uri = url + "/pins/$i/upvote";
      res = await http.get(uri);
    }
    if (downvotes > 0) {
      String uri = url + "/pins/$i/downvote";
      res = await http.get(uri);
    }
    String uri = url + "/pins/$i";
    res = await http.get(uri);
    var pin = Pin.fromJson(json.decode(res.body));
    setState(() {
     currentTotal = pin.totalScore;
    }); 
  }

  @override
  Widget build(BuildContext context) {
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
          !showVoting ? Row() : _buildVotingContainer(Colors.black, FontAwesomeIcons.thumbsDown, FontAwesomeIcons.thumbsUp, currentTotal, currentMarker)
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

Row _buildVotingContainer(Color color, IconData downIcon, IconData upIcon, int total_votes, MarkerId mid) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      IconButton(
        icon: Icon(downIcon), 
        color: color,
        onPressed: () {
          _updateVoting(0, 1, mid);
        }
      ),
      Container(
        margin: const EdgeInsets.all(10),
        child: Text(
          "Total Votes: $currentTotal",
        )
      ),
      IconButton(
        icon: Icon(upIcon), 
        color: color,
        onPressed: () {
          _updateVoting(1, 0, mid);
        }
      ),
    ],
  );
}
}
