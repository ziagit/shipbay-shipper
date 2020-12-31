import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/main_menu.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: Text("Shipbay"),
      ),
      drawer: MainMenu(),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Let’s book your shipment in a few taps."),
          RaisedButton(
            color: Colors.orange[900],
            child: Text(
              "Get Quote",
              style: TextStyle(color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/pickup');
            },
          ),
        ],
      )),
    );
  }
}
