import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shipbay/moving/moving_menu.dart';
import 'package:shipbay/moving/services/api.dart';
import 'package:shipbay/shared/components/checkout.dart';
import 'package:shipbay/moving/moving_appbar.dart';
import 'package:shipbay/shared/components/progress.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/store.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  double _progress = 95.0;
  bool _loading = false;
  String _paymentMessage = "Add your card information";
  Color _successColor = Colors.black;
  bool _paymentStatus;
  Store store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MovingAppBar(''),
      drawer: MovingMenu(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(child: Progress(progress: _progress)),
                Text(
                  "Payment information",
                  style: TextStyle(fontSize: 22.0, height: 2.0),
                ),
                SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        offset: Offset(0.0, 10.0),
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                      )
                    ],
                  ),
                  height: 150.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        _paymentMessage ?? '',
                        style: TextStyle(color: _successColor ?? ''),
                      ),
                      (_paymentStatus == false || _paymentStatus == null)
                          ? FlatButton(
                              color: primary,
                              child: Text(
                                "Add",
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.white),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              onPressed: () {
                                _openDialog(context);
                              },
                            )
                          : FlatButton(
                              color: primary,
                              child: Text(
                                "Complete",
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.white),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/confirm-move');
                              },
                            ),
                      SizedBox(height: 12.0),
                      _loading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Loading"),
                                JumpingDotsProgressIndicator(
                                  fontSize: 20.0,
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _openDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Builder(
          builder: (context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return Container(
              height: height - 400,
              width: width - 100,
              child: Checkout(),
            );
          },
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context, false), // passing false
            child: Text('Cancel'),
          ),
        ],
      ),
    ).then((Object value) {
      if (value != false) {
        setState(() {
          _loading = true;
        });
        _charge(value);
      }
    });
  }

  _init() async {
    var billing = await store.read('billing');
    if (billing != null && billing['status'] == true) {
      setState(() {
        _progress = 100.0;
        _paymentStatus = billing['status'];
        _paymentMessage = billing['message'];
        _successColor = Colors.green;
      });
    }
  }

  _charge(card) async {
    var token = await store.read('token');
    var carrier = await store.read('mover');
    if (token != null) {
      print("xxxxxxxxxxx");
      _addCard(carrier, card, token);
    } else {
      _chargeNow(carrier, card);
    }
  }

  _addCard(carrier, card, token) async {
    var jsonData = await addCard(carrier, card, token);
    if (jsonData["error"] != null) {
      throw HttpException(jsonData["error"]["message"]);
    }
    store.save('billing', {
      'status': jsonData['status'],
      'email': jsonData['email'],
      'message': jsonData['message'],
      'orderId': jsonData['id']
    });
    setState(() {
      _loading = false;
    });
    Navigator.pushReplacementNamed(context, '/customer-card-details',
        arguments: jsonData['message']);
  }

  _chargeNow(mover, data) async {
    var jsonData = await chargeNow(mover, data);
    if (jsonData["error"] != null) {
      throw HttpException(jsonData["error"]["message"]);
    }
    store.save('billing', {
      'status': jsonData['status'],
      'email': jsonData['email'],
      'message': jsonData['message'],
      'orderId': jsonData['id']
    });
    setState(() {
      _progress = 100.0;
      _paymentMessage = jsonData['message'];
      _successColor = Colors.green;
      _paymentStatus = jsonData['status'];
      _loading = false;
    });
  }
}
