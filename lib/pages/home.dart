import 'package:flutter/material.dart';
import 'package:shipbay/pages/order/payment_details.dart';
import 'package:shipbay/pages/services/app_colors.dart';
import 'package:shipbay/pages/shared/main_menu.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  Future<Null> _xdx() {
    Navigator.pushReplacementNamed(context, '/payment-details');
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: Text("Shipbay"),
        elevation: 0,
      ),
      drawer: MainMenu(),
      endDrawer: PaymentDetails(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Let’s book your shipment in a few taps.",
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            RaisedButton(
              color: Colors.orange[900],
              child: Text("Get Quote", style: TextStyle(color: Colors.white)),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/pickup');
              },
            ),
          ],
        )),
      ),
    );
  }
}
