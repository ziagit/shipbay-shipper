import 'package:flutter/material.dart';
import 'package:shipbay/services/settings.dart';

class Completed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Container(
            decoration: _customStyle(context),
            child: SizedBox(
              height: 200.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Perfect! 👌",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Text("The selected carrier recieved a notification"),
                  Text(
                    "Stay in touch, they will contact you as soon as arrive to the pickup location",
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        child:
                            Text("Back home", style: TextStyle(color: primary)),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/track');
                        },
                        child: Text("Track", style: TextStyle(color: primary)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Decoration _customStyle(context) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        new BoxShadow(
          color: Colors.grey.shade200,
          offset: new Offset(0.0, 10.0),
          blurRadius: 10.0,
          spreadRadius: 1.0,
        )
      ],
    );
  }
}
