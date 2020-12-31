import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/progress.dart';

class DeliveryServices extends StatefulWidget {
  @override
  _DeliveryServicesState createState() => _DeliveryServicesState();
}

class _DeliveryServicesState extends State<DeliveryServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: Text("Delivery services"),
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
                    "Delivery services",
                    style: TextStyle(fontSize: 24.0, height: 2.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                          value: false,
                          onChanged: (val) {
                            setState(() {
                              //do nothing
                            });
                          }),
                      Text(
                        "Inside pick-up",
                        style: TextStyle(fontSize: 11.0),
                      ),
                      Checkbox(
                          value: false,
                          onChanged: (val) {
                            setState(() {
                              //do nothing
                            });
                          }),
                      Text(
                        "Tailgate",
                        style: TextStyle(fontSize: 11.0),
                      ),
                      Checkbox(
                          value: false,
                          onChanged: (val) {
                            setState(() {
                              //do nothing
                            });
                          }),
                      Text(
                        "Appointment",
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
                          Navigator.pushReplacementNamed(context, '/delivery');
                        },
                      ),
                      SizedBox(width: 12.0),
                      FloatingActionButton(
                        heroTag: 1,
                        backgroundColor: Colors.orange[900],
                        child: Icon(Icons.keyboard_arrow_right),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/items');
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
