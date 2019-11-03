import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PinTextInput extends StatefulWidget {

  final LatLng coords;

  PinTextInput(this.coords) {
    print(this.coords);
  }

  @override
  PinTextInputState createState() => new PinTextInputState(this.coords); 
}

class PinTextInputState extends State<PinTextInput> {
  final LatLng coords;

  PinTextInputState(this.coords);

  TextEditingController titleController = new TextEditingController();
  TextEditingController categoryController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  List<String> pinInfo = new List(5);

  @override
  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Enter Pin Data"), backgroundColor: Colors.green[800]),
      body: new Column(
        children: <Widget>[
          new TextField(
            decoration: new InputDecoration(
              hintText: "Pin Title"
            ), 
            onChanged: (String str) {
              setState(() {
                pinInfo[0] = str;
                // print("PRINT PIN1 $str\n"); 
              });
            },
            controller: titleController,
          ), 
          new TextField(
            decoration: new InputDecoration(
              hintText: "Pin Category"
            ), 
            onChanged: (String str) {
              setState(() {
                pinInfo[1] = str; 
                // print("PRINT PIN1 $str\n");
              });
            },
            controller: categoryController,
          ),
          new TextField(
            decoration: new InputDecoration(
              hintText: "Pin Descrption"
            ), 
            onChanged: (String str) {
              setState(() {
                pinInfo[2] = str; 
                // print("PRINT PIN1 $str\n");
              });
            },
            controller: descriptionController,
          ), 
          new Padding(padding: new EdgeInsets.only(top: 20.0)),
          new RaisedButton(
            child: new Text("Save Pin"),
            onPressed: () {
              pinInfo[3] = this.coords.toString();
              print("PRINT LAT-LONG $pinInfo[3]\n");
              pinInfo[4] = DateTime.now().toString();
              Navigator.pop(context, pinInfo);
            }
          )
        ],
      )
    );
  }
}