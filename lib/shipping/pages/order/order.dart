import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shipbay/shipping/shipping_appbar.dart';
import 'package:shipbay/shipping/shipping_menu.dart';
import 'package:shipbay/shared/services/colors.dart';

class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: primary));
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: ShippingAppBar(''),
        drawer: ShippingMenu(),
        body: ListView(children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(30.0, 200.0, 30.0, 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "SB",
                    style: TextStyle(
                        color: Colors.white, fontSize: 64.0, height: 0.4),
                  ),
                  Text("ShipBay",
                      style: TextStyle(
                          color: Colors.white, fontSize: 28.0, height: 1.4)),
                  Text(
                    "The way you book your shipment",
                    style: TextStyle(color: Colors.white, height: 1.5),
                  ),
                  SizedBox(height: 56.0),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextFormField(
                      style: TextStyle(fontSize: 14.0),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        hintText: 'Search a postal code',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/pickup');
                          },
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
