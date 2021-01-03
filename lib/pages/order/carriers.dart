import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/progress.dart';

class Carriers extends StatefulWidget {
  @override
  _CarriersState createState() => _CarriersState();
}

class _CarriersState extends State<Carriers> {
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
            Navigator.pushReplacementNamed(context, '/additional-details');
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Container(child: Progress(progress: 85.0)),
                SizedBox(height: 24.0),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(children: <Widget>[
                      Text("Source city"),
                      Icon(Icons.arrow_right),
                      Text("Destination city")
                    ]),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Image(
                            image: AssetImage('assets/images/coffeequery.png'),
                          ),
                          title: Text("Carrier"),
                          subtitle: Text("Read more about this carrier"),
                        ),
                        ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: Text('Select'),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/signin');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
