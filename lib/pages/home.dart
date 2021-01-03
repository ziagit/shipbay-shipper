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
      backgroundColor: Colors.orange[900],
      appBar: AppBar(
        backgroundColor: Color(0xF8FAF8),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      drawer: MainMenu(),
      endDrawer: Tracking(),
      body: ListView(children: <Widget>[
        Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 200.0, 30.0, 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "SB",
                  style: TextStyle(
                      color: Colors.white, fontSize: 64.0, height: 0.4),
                ),
                Text("ShipBay",
                    style: TextStyle(
                        color: Colors.white, fontSize: 38.0, height: 1.0)),
                Text(
                  "The way you book your shipment",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Search a postal code'),
                ),
                SizedBox(height: 54.0),
                RaisedButton(
                  color: Colors.white,
                  child: Text(
                    "Quotation",
                    style: TextStyle(
                        color: Colors.orange[900], fontWeight: FontWeight.w600),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/pickup');
                  },
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
