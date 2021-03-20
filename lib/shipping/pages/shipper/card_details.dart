import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shipbay/shared/components/checkout.dart';
import 'package:shipbay/shipping/shipping_menu.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shipping/services/api.dart';
import 'package:progress_indicators/progress_indicators.dart';

class CardDetails extends StatefulWidget {
  @override
  _CardDetailsState createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  String _paymentMessage = "Not paid yet!";
  bool _processing = false;
  Color _successColor = Colors.black;
  String _paymentStatus;
  Store store = Store();
  var card;
  var pendingOrder;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.edit,
                color: primary,
              ),
              onPressed: () => _openDialog(context),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      drawer: ShippingMenu(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: pendingOrder == null
            ? ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(100.0),
                    child: Image.asset("assets/images/card.png"),
                  ),
                  card == null
                      ? Container(
                          padding: EdgeInsets.all(20.0),
                          decoration: _customStyle(context),
                          child: Column(
                            children: [
                              Text("No card added"),
                              FlatButton(
                                color: primary,
                                onPressed: () {
                                  _openDialog(context);
                                },
                                child: Text("Add",
                                    style: TextStyle(color: Colors.white)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)),
                              )
                            ],
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: _customStyle(context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Card details",
                                    style: TextStyle(
                                        color: primary, fontSize: 18.0)),
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${card['name']}",
                                    style: TextStyle(
                                        color: fontColor, fontSize: 12.0),
                                  )),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${card['email']}",
                                  style: TextStyle(
                                      color: fontColor, fontSize: 12.0),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: FlatButton(
                                  child: Text("New order",
                                      style: TextStyle(color: primary)),
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/pickup');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              )
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(100.0),
                    child: Image.asset("assets/images/card.png"),
                  ),
                  card == null
                      ? Container(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Loading"),
                                JumpingDotsProgressIndicator(
                                  fontSize: 20.0,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: _customStyle(context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Card details",
                                    style: TextStyle(
                                        color: primary, fontSize: 18.0)),
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${card['name']}",
                                    style: TextStyle(
                                        color: fontColor, fontSize: 12.0),
                                  )),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${card['email']}",
                                  style: TextStyle(
                                      color: fontColor, fontSize: 12.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(height: 24.0),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: _customStyle(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("$_paymentMessage",
                              style: TextStyle(
                                  color: Colors.green, fontSize: 12.0)),
                        ),
                        (_paymentStatus == null || _paymentStatus == 'unpaid')
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  children: [
                                    _processing
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text("Processing"),
                                              JumpingDotsProgressIndicator(
                                                fontSize: 20.0,
                                              ),
                                            ],
                                          )
                                        : FlatButton(
                                            child: Text("Pay now"),
                                            onPressed: () {
                                              _charge();
                                            },
                                          ),
                                  ],
                                ),
                              )
                            : Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("Completing"),
                                    JumpingDotsProgressIndicator(
                                      fontSize: 20.0,
                                    ),
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),
                ],
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

  @override
  void initState() {
    super.initState();
    _init();
    Future.delayed(Duration.zero, () {
      if (ModalRoute.of(context).settings.arguments != null) {
        _paymentMessage = ModalRoute.of(context).settings.arguments;
      }
    });
  }

  _init() async {
    var token = await store.read('token');
    pendingOrder = await store.read('additional-details');
    var response = await getCard(token);
    print('................');
    print(response);
    setState(() {
      card = response;
    });
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
        _addCustomer(value);
      }
    });
  }

  _addCustomer(value) async {
    var token = await store.read('token');
    var response = await addCustomer(value, token);
    if (response["error"] != null) {
      throw HttpException(response["error"]["message"]);
    }
    _init();
    setState(() {
      card = response;
      _paymentMessage = response['message'];
      _successColor = Colors.green;
      _paymentStatus = response['status'];
    });
  }

  _charge() async {
    setState(() {
      _processing = true;
    });
    var token = await store.read('token');
    var carrier = await store.read('carrier');
    var billing = await store.read('billing');
    if (billing != null) {
      var response = await chargeCustomer(carrier, billing, token);
      store.save('billing', {
        'status': response['status'],
        'email': response['email'],
        'message': response['message'],
        'orderId': response['id']
      });
      setState(() {
        _processing = false;
        _paymentMessage = response['message'];
        _successColor = Colors.green;
        _paymentStatus = response['status'];
      });
      Navigator.pushReplacementNamed(context, '/payment-details');
    } else {
      Navigator.pushReplacementNamed(context, '/pickup');
    }
  }
}
