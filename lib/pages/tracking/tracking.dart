import 'package:flutter/material.dart';
import 'package:shipbay/services/settings.dart';

class Tracking extends StatefulWidget {
  @override
  _TrackingState createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/pickup');
              },
              icon: Icon(Icons.arrow_forward),
            ),
          ),
          Center(
            child: Text("Load the data here"),
          )
        ],
      )),
    );
  }
}
