import 'package:flutter/material.dart';

class DeliveryServices extends StatefulWidget {
  @override
  _DeliveryServicesState createState() => _DeliveryServicesState();
}

class _DeliveryServicesState extends State<DeliveryServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: Text("Delivery services"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Delivery services "),
      ),
    );
  }
}
