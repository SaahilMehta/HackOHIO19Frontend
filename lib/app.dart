import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'input.dart';

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

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // get markers from DB, store into set 
  }

  void _onMarkerTap(MarkerId mid) {
    print("MARKER $mid TAPPED");
  }

  void _addMarker(LatLng location) {
    final int markerCount = markers.length;
    final String idValue = 'marker_id_$idCounter';
    idCounter++;
    final MarkerId markerId = MarkerId(idValue);

    final Marker marker = Marker(
      markerId: markerId,
      position: location, //fix me
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

    void _determineTapPosition(LatLng argument) {
      if(userSelectingPosition) {
        //  _addMarker(argument);
        userSelectingPosition = false;
        Navigator.push(context, MaterialPageRoute(builder: (context) => PinTextInput(argument)));
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

        body: Stack(
          children: [                     
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
               zoom: 11.0,
              ),
              markers: Set<Marker>.of(markers.values),
              onTap: _determineTapPosition,              
              ),
            ]           
          ),

        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 80.0,
                child:DrawerHeader(
                  child: Text('Options',),
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
              ]
            )
          ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('Press the screen to select a location');
            userSelectingPosition = true;
            },
          tooltip: 'Drop pin',
          child: const Icon(Icons.add),
        )
      );
    }
}
