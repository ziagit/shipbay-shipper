import 'package:flutter/material.dart';

class AdditionalDetails extends StatefulWidget {
  @override
  _AdditionalDetailsState createState() => _AdditionalDetailsState();
}

class _AdditionalDetailsState extends State<AdditionalDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: Text("Additional details"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Additional details "),
      ),
    );
  }
}
