import 'package:flutter/material.dart';
import 'package:shipbay/services/settings.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
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
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Text("in welcome page"),
            RaisedButton(
                child: Text("go to account"),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/shipper");
                })
          ],
        ),
      ),
    );
  }
}
