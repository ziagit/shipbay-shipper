import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shipbay/models/accessory.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:shipbay/services/settings.dart';
import 'package:shipbay/services/api.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Pickup extends StatefulWidget {
  @override
  _PickupState createState() => _PickupState();
}

class _PickupState extends State<Pickup> {
  String displayName = "";

  String groupValue = 'bs';
  Future<List<Accessory>> _getAccessories() async {
    Accessories instance = Accessories("location-type");
    return instance.getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('displayName');
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: primary));
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
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  SizedBox(child: Progress(progress: 0.0)),
                  SizedBox(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Pickup address",
                          style: TextStyle(fontSize: 24.0, height: 2.0),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Postal code'),
                          onChanged: (val) {
                            findPlace(val);
                          },
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Radio(
                                    activeColor: primary,
                                    value: "bs",
                                    groupValue: groupValue,
                                    onChanged: (val) {
                                      groupValue = val;
                                      setState(() {});
                                    }),
                                Text(
                                  "Business",
                                  style: TextStyle(fontSize: 11.0),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Radio(
                                    activeColor: primary,
                                    value: "rs",
                                    groupValue: groupValue,
                                    onChanged: (val) {
                                      groupValue = val;
                                      setState(() {});
                                    }),
                                Text(
                                  "Residential",
                                  style: TextStyle(fontSize: 11.0),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Radio(
                                    activeColor: primary,
                                    value: "sp",
                                    groupValue: groupValue,
                                    onChanged: (val) {
                                      groupValue = val;
                                      setState(() {});
                                    }),
                                Text(
                                  "Special location",
                                  style: TextStyle(fontSize: 11.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        FloatingActionButton(
                          heroTag: 1,
                          backgroundColor: primary,
                          child: Icon(Icons.keyboard_arrow_right),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/pickup-services');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  void findPlace(String placeName) async {
    String key = "AIzaSyAQTHaD2g0BjmczBlX73Vv-KthtHzdRYPk";
    if (placeName.length > 1) {
      String autoComplete =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$key&sessiontoken=1234567890&components:ca";
      var res = await http.get(autoComplete);
      if (res == "failed") {
        return;
      }
      Map data = jsonDecode(res.body);

      print("Response from google");
      print(data['predictions'][0]['description']);
    }
  }
}
