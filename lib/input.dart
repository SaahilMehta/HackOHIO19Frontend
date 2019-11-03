import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class SecondRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     print("Second Route");
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Second Route"),
//       ),
//       body: Center(
//         child: RaisedButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text('Go back!'),
//         ),
//       ),
//     );
//   }
// }

class PinTextInput extends StatefulWidget {

  final LatLng coords;

  PinTextInput(this.coords) {
    print(this.coords);
  }

  @override
  PinTextInputState createState() => new PinTextInputState(); 
}

class PinTextInputState extends State<PinTextInput> {

  TextEditingController titleController = new TextEditingController();
  TextEditingController categoryController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  List<String> pinInfo = new List(3);

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
            onSubmitted: (String str) {
              setState(() {
                pinInfo[0] = str; 
              });
            },
            controller: titleController,
          ), 
          new TextField(
            decoration: new InputDecoration(
              hintText: "Pin Category"
            ), 
            onSubmitted: (String str) {
              setState(() {
                pinInfo[1] = str; 
              });
            },
            controller: categoryController,
          ),
          new TextField(
            decoration: new InputDecoration(
              hintText: "Pin Descrption"
            ), 
            onSubmitted: (String str) {
              setState(() {
                pinInfo[3] = str; 
              });
            },
            controller: descriptionController,
          ), 
          new Padding(padding: new EdgeInsets.only(top: 20.0)),
          new RaisedButton(
            child: new Text("Save Pin"),
            onPressed: () {
              Navigator.pop(context);
            }
          )
        ],
      )
    );
  }
}