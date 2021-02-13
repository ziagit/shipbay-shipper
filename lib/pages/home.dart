import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shipbay/services/settings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // TRUE: register page, FALSE: login page
  bool _register = true;

  void _changeScreen() {
    setState(() {
      // sets it to the opposite of the current screen
      _register = !_register;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: primary));
    return Scaffold(
        body: SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.3, 0.5, 0.7, 0.9],
            colors: [
              Colors.orange[800],
              Colors.orange[300],
              Colors.orange[200],
              Colors.orange[200],
              Colors.orange[200],
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Container(height: 100.0),
            ),
            Column(
              children: [
                Text(
                  "ShipBay",
                  style: TextStyle(
                      fontSize: 36.0,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800]),
                ),
                Text(
                  "Truck & Muscle, Anytime You Need It",
                  style: TextStyle(
                    height: 2.5,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Load, haul, and deliver just about anything, whenever you need it!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 43.0,
                    child: RaisedButton(
                      color: primary,
                      child: Text(
                        "GET STARTED",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/pickup');
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
