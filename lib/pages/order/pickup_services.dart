import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/progress.dart';

class PickupServices extends StatefulWidget {
  @override
  _PickupServicesState createState() => _PickupServicesState();
}

class _PickupServicesState extends State<PickupServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: Text("Pickup services"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
            child: Column(
          children: <Widget>[
            SizedBox(child: Progress()),
            SizedBox(
              child: Column(
                children: <Widget>[
                  Text(
                    "Pickup services",
                    style: TextStyle(fontSize: 24.0, height: 2.0),
                  ),
                  SizedBox(height: 16.0),
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
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton(
                        heroTag: 0,
                        backgroundColor: Colors.orange[50],
                        foregroundColor: Colors.orange[900],
                        child: Icon(Icons.keyboard_arrow_left),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/pickup');
                        },
                      ),
                      SizedBox(width: 16.0),
                      FloatingActionButton(
                        heroTag: 1,
                        backgroundColor: Colors.orange[900],
                        child: Icon(Icons.keyboard_arrow_right),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/pickup-date');
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
