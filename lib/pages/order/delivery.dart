import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/progress.dart';

class Delivery extends StatefulWidget {
  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  String groupValue = 'bs';
  @override
  Widget build(BuildContext context) {
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
            Navigator.pushReplacementNamed(context, '/pickup-date');
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Container(child: Progress(progress: 37.0)),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Delivery address",
                        style: TextStyle(fontSize: 24.0, height: 2.0),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Postal code'),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Radio(
                                  activeColor: Colors.orange[900],
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
                      SizedBox(height: 24.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FloatingActionButton(
                            heroTag: 0,
                            backgroundColor: Colors.orange[50],
                            foregroundColor: Colors.orange[900],
                            child: Icon(Icons.keyboard_arrow_left),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/pickup-date');
                            },
                          ),
                          SizedBox(width: 16.0),
                          FloatingActionButton(
                            heroTag: 1,
                            backgroundColor: Colors.orange[900],
                            child: Icon(Icons.keyboard_arrow_right),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/delivery-services');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
