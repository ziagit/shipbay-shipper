import 'package:flutter/material.dart';

class Delivery extends StatefulWidget {
  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: Text("Delivery"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Delivery "),
      ),
    );
  }
}
