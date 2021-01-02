import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/progress.dart';

class Carriers extends StatefulWidget {
  @override
  _CarriersState createState() => _CarriersState();
}

class _CarriersState extends State<Carriers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: Text("Carriers "),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
            child: Column(
          children: <Widget>[
            SizedBox(child: Progress()),
            SizedBox(height: 24.0),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(children: <Widget>[
                  Text("Source city"),
                  Icon(Icons.arrow_right),
                  Text("Destination city")
                ]),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                              child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 50.0,
                                child: Image(
                                  image: AssetImage(
                                      "assets/images/coffeequery.png"),
                                ),
                              ),
                              SizedBox(width: 10.0),
                              SizedBox(
                                  child: Column(
                                children: <Widget>[
                                  Text("Carrier name"),
                                  Text("Carrier Details"),
                                  Text("Carrier rates"),
                                ],
                              ))
                            ],
                          )),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(
                                Icons.info_outline,
                                color: Colors.blueAccent,
                              ),
                              FlatButton(
                                shape: Border.all(color: Colors.orange[900]),
                                child: Text(
                                  'Select',
                                  style: TextStyle(color: Colors.orange[900]),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/signin');
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
