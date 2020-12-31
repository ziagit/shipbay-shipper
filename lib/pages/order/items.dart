import 'package:flutter/material.dart';

class Items extends StatefulWidget {
  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: Text("Items"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Items "),
      ),
    );
  }
}
