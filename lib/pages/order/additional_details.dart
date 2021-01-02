import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/progress.dart';

class AdditionalDetails extends StatefulWidget {
  @override
  _AdditionalDetailsState createState() => _AdditionalDetailsState();
}

class _AdditionalDetailsState extends State<AdditionalDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xF8FAF8),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/items');
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Container(child: Progress()),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Additional details",
                        style: TextStyle(fontSize: 24.0, height: 2.0),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Estimated shipment value'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Instructions'),
                      ),
                      SizedBox(height: 24.0),
                      Text("Contacts: ", style: TextStyle(fontSize: 16.0)),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'name'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Phone'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Email'),
                      ),
                      SizedBox(height: 24.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FloatingActionButton(
                            heroTag: 0,
                            backgroundColor: Colors.orange[50],
                            foregroundColor: Colors.orange[900],
                            child: Icon(Icons.keyboard_arrow_left),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/items');
                            },
                          ),
                          SizedBox(width: 16.0),
                          FloatingActionButton(
                            heroTag: 1,
                            backgroundColor: Colors.orange[900],
                            child: Icon(Icons.keyboard_arrow_right),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/carriers');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
