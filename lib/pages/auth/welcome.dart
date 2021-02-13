import 'package:flutter/material.dart';
import 'package:shipbay/services/settings.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to Shipbay",
                style: TextStyle(
                    color: primary,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Please complete your registeration",
                style: TextStyle(color: primary),
              ),
              SizedBox(height: 24.0),
              RaisedButton(
                color: primary,
                child: Text(
                  "Continue",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w400),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/profile');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
