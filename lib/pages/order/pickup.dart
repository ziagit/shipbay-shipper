import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/progress.dart';

class Pickup extends StatefulWidget {
  @override
  _PickupState createState() => _PickupState();
}

class _PickupState extends State<Pickup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        centerTitle: true,
        title: Text("Pickup"),
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
                    "Shipment source",
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
                  RaisedButton(
                    color: Colors.orange[900],
                    child: Text(
                      "Continue",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/pickup-services');
                    },
                  )
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
