import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/progress.dart';

class PickupDate extends StatefulWidget {
  @override
  _PickupDateState createState() => _PickupDateState();
}

class _PickupDateState extends State<PickupDate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: Text("Pickup date"),
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
                    "Pickup date",
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
                      Navigator.pushReplacementNamed(context, '/pickup-date');
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
