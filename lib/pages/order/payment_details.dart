import 'package:flutter/material.dart';

class PaymentDetails extends StatefulWidget {
  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: Text("PaymentDetails "),
        centerTitle: true,
      ),
      body: Center(
        child: Text("PaymentDetails "),
      ),
    );
  }
}
