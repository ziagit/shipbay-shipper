import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/progress.dart';

class Delivery extends StatefulWidget {
  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: Text("Delivery"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
            child: Column(
          children: <Widget>[
            SizedBox(
              child: Progress(),
            ),
            SizedBox(
              child: Column(
                children: <Widget>[
                  Text(
                    "Shipment destination",
                    style: TextStyle(fontSize: 24.0, height: 2.0),
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Postal code'),
                  ),
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
                      SizedBox(width: 12.0),
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
        )),
      ),
    );
  }
}
