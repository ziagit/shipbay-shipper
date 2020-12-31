import 'package:flutter/material.dart';

class Carriers extends StatefulWidget {
  @override
  _CarriersState createState() => _CarriersState();
}

class _CarriersState extends State<Carriers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: Text("Carriers "),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Carriers "),
      ),
    );
  }
}
