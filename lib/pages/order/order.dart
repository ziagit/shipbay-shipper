import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shipbay/pages/order/pickup.dart';

class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Text("load progressbar"),
          ),
          Container(child: Pickup())
        ],
      ),
    );
  }
}
