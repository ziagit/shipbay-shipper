import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/main_menu.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/services/settings.dart';
import 'package:shipbay/services/api.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: primary),
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.edit,
                color: primary,
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      drawer: MainMenu(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
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
                              style: TextStyle(color: primary, fontSize: 18.0)),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${card['name']}",
                              style:
                                  TextStyle(color: fontColor, fontSize: 12.0),
                            )),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${card['email']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
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
                        style: TextStyle(color: Colors.green, fontSize: 12.0)),
                  ),
                  (_paymentStatus == null || _paymentStatus == 'unpaid')
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            children: [
                              _processing
                                  ? Row(
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
                          child: FlatButton(
                            child: Text("Process order"),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/payment-details');
                            },
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
    Future.delayed(Duration.zero, () {
      if (ModalRoute.of(context).settings.arguments != null) {
        _paymentMessage = ModalRoute.of(context).settings.arguments;
      }
    });
    _init();
  }

  _init() async {
    var token = await store.read('token');
    var data = await getCard(token);
    setState(() {
      card = data;
    });
  }

  _charge() async {
    _processing = true;
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
        _paymentMessage = response['message'];
        _successColor = Colors.green;
        _paymentStatus = response['status'];
      });
      _processing = false;
      print("cussssssssssxssssssssssss.....");
      print(response);
    } else {
      Navigator.pushReplacementNamed(context, '/pickup');
    }
  }
}
