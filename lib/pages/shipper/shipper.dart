import 'package:flutter/material.dart';

class Shipper extends StatefulWidget {
  @override
  _ShipperState createState() => _ShipperState();
}

class _ShipperState extends State<Shipper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: Text("Shipper"),
      ),
      body: Text("Shipper page"),
    );
  }
}
