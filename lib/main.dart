/*
 * Copyright 2019 Google LLC
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     https://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'map_markers.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId currentMarker;
  int idCounter = 1;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _addMarker() {
    final int markerCount = markers.length;
    final String idValue = 'marker_id_$idCounter';
    idCounter++;
    final MarkerId markerId = MarkerId(idValue);

    final Marker marker = Marker(
      markerId: markerId,
      position: _center, //fix me
      infoWindow: InfoWindow(title: "placeholder"),
      //add functions to drag/tap/whatever here
    );

    setState(() {
      markers[markerId] = marker;
    });
  }
  
  void _deleteMarker() {
    setState(() {
      if (markers.containsKey(currentMarker)) {
        markers.remove(currentMarker);
      }
    });
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
    Widget thumbTack = IconButton(
      // Use the FontAwesomeIcons class for the IconData
        icon: Icon(FontAwesomeIcons.mapPin),
        onPressed: () { print("Pressed"); }
    );
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children: [
          GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: Set<Marker>.of(markers.values),
        ),
          Positioned(
            top: 40,
            right: 20,
            child: FlatButton(
              child: Text('add'),
              onPressed: _addMarker,
            ),
          )
        ]
      ),
      )
    );
  }
}
