import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shipbay/pages/services/app_colors.dart';
import 'package:shipbay/pages/shared/main_menu.dart';
import 'package:shipbay/pages/tracking/tracking.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.orange[900]));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xF8FAF8),
        title: Text(
          "Shipbay",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.location_on),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      drawer: MainMenu(),
      endDrawer: Tracking(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Let’s book your shipment in a few taps.",
              style: TextStyle(
                fontSize: 24.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            RaisedButton(
              color: Colors.orange[900],
              child: Text(
                "Get Quote",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/pickup');
              },
            ),
          ],
        )),
      ),
    );
  }
}
