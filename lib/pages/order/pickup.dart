import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

class Pickup extends StatefulWidget {
  @override
  _PickupState createState() => _PickupState();
}

class _PickupState extends State<Pickup> {
  _google() async {
    Prediction prediction = await PlacesAutocomplete.show(
        context: context,
        apiKey: "AIzaSyAQTHaD2g0BjmczBlX73Vv-KthtHzdRYPk",
        mode: Mode.fullscreen, // Mode.overlay
        language: "en",
        components: [Component(Component.country, "pk")]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.orange[900]));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xF8FAF8),
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
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Radio(
                                value: 1,
                                groupValue: null,
                                onChanged: (val) {
                                  setState(() {
                                    //do nothing
                                  });
                                }),
                            Text(
                              "Business",
                              style: TextStyle(fontSize: 11.0),
                            ),
                            Radio(
                                value: 1,
                                groupValue: null,
                                onChanged: (val) {
                                  setState(() {
                                    //do nothing
                                  });
                                }),
                            Text(
                              "Residential",
                              style: TextStyle(fontSize: 11.0),
                            ),
                            Radio(
                                value: 1,
                                groupValue: null,
                                onChanged: (val) {
                                  setState(() {
                                    //do nothing
                                  });
                                }),
                            Text(
                              "Special location",
                              style: TextStyle(fontSize: 11.0),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        FloatingActionButton(
                          heroTag: 1,
                          backgroundColor: Colors.orange[900],
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
}
