import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/services/settings.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentDetails extends StatefulWidget {
  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  double _progress = 85.0;
  String _paymentMessage = "Add your card information";
  Color _successColor = Colors.black;
  String _paymentStatus;
  Store store = Store();
  static String secret = 'sk_test_56YIJKckMHED0F2f2blzocI100b5TAZDa8';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                SizedBox(child: Progress(progress: _progress)),
                SizedBox(height: 30.0),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
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
                  ),
                  height: 150.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        _paymentMessage,
                        style: TextStyle(
                            color: _successColor == null ? '' : _successColor),
                      ),
                      _paymentStatus == null
                          ? RaisedButton(
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
                          : RaisedButton(
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
                                Navigator.pushNamed(context, '/confirm');
                              },
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  _openDialog(context) {
    showDialog(
      context: context,
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
      ),
    ).then((Object value) {
      setState(() {
        charge(value);
      });
    });
  }

  void init() async {
    var data = await store.read('billing');
    if (data != null) {
      setState(() {
        _progress = 100.0;
        _paymentStatus = data['status'];
        _paymentMessage = data['message'];
        _successColor = Colors.green;
        print("kkkkkkkkkkkkkkkk");
      });
    }
    print("...........billing.........");
    print(data);
  }

  Future<Map<String, dynamic>> charge(data) async {
    print(data['token']);
    var carrier = await store.read('carrier');
    try {
      var response = await http.post(
        'http://192.168.2.19:8000/api/charge',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(<String, Object>{
          'price': carrier['price'],
          'stripeToken': data['token'],
          'email': data['email'],
          'address': data['address'],
          'city': data['city'],
          'state': data['state'],
          'postalcode': data['postalcode'],
          'name': data['name']
        }),
      );
      var jsonData = jsonDecode(response.body);
      store.save('billing', {
        'status': jsonData['status'],
        'email': jsonData['email'],
        'message': jsonData['message']
      });
      store.save('orderId', jsonData['id']);
      setState(() {
        _progress = 100.0;
        _paymentMessage = jsonData['message'];
        _successColor = Colors.green;
        _paymentStatus = jsonData['status'];
      });
      print("............................");
      print(jsonData);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }
}

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameOnCardController = new TextEditingController();
  TextEditingController cardNumberController = new TextEditingController();
  TextEditingController cvcController = new TextEditingController();
  TextEditingController expYearController = new TextEditingController();
  TextEditingController expMonthController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController postalcodeController = new TextEditingController();
  String _stripeError;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    StripePayment.setOptions(
      StripeOptions(
          publishableKey: "pk_test_0G9HHVR4XmO3EFy80yElsydL0011AX8fxz",
          merchantId: "Test",
          androidPayMode: 'test'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: TextField(
              autofocus: true,
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              style: TextStyle(fontSize: 14.0)),
        ),
        Flexible(
          child: TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
              style: TextStyle(fontSize: 14.0)),
        ),
        Row(
          children: [
            Flexible(
              child: TextField(
                  controller: cityController,
                  decoration: InputDecoration(labelText: 'City'),
                  style: TextStyle(fontSize: 14.0)),
            ),
            Flexible(
              child: TextField(
                  controller: stateController,
                  decoration: InputDecoration(labelText: 'State'),
                  style: TextStyle(fontSize: 14.0)),
            ),
            Flexible(
              child: TextField(
                  controller: postalcodeController,
                  decoration: InputDecoration(labelText: 'Postalcode'),
                  style: TextStyle(fontSize: 14.0)),
            ),
          ],
        ),
        Flexible(
          child: TextField(
              controller: nameOnCardController,
              decoration: InputDecoration(labelText: 'Name on card'),
              style: TextStyle(fontSize: 14.0)),
        ),
        Flexible(
          child: TextField(
            controller: cardNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Card number',
              prefixIcon: Icon(Icons.credit_card),
            ),
            style: TextStyle(fontSize: 14.0),
          ),
        ),
        Row(
          children: [
            Flexible(
              child: TextField(
                controller: cvcController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'CVC'),
                style: TextStyle(fontSize: 12.0),
              ),
            ),
            Flexible(
              child: TextField(
                controller: expMonthController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Exp month'),
                style: TextStyle(fontSize: 12.0),
              ),
            ),
            Flexible(
              child: TextField(
                controller: expYearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Exp year'),
                style: TextStyle(fontSize: 12.0),
              ),
            ),
          ],
        ),
        Text(
          (_stripeError == null) ? '' : _stripeError,
          style: TextStyle(fontSize: 10.0, color: Colors.red),
        ),
        SizedBox(height: 40.0),
        _isLoading
            ? SizedBox(
                height: 30.0,
                width: 30.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(primary),
                ),
              )
            : RaisedButton(
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 12.0, color: Colors.white),
                ),
                color: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red),
                ),
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  final CreditCard shippingCard = CreditCard(
                    number: cardNumberController.text,
                    expMonth: int.parse(expMonthController.text),
                    expYear: int.parse(expYearController.text),
                    cvc: cvcController.text,
                  );

                  StripePayment.createTokenWithCard(shippingCard).then((token) {
                    setState(() {
                      _stripeError = null;
                      _isLoading = false;
                    });
                    final data = {
                      'token': token.tokenId,
                      'email': emailController.text,
                      'address': addressController.text,
                      'city': cityController.text,
                      'state': stateController.text,
                      'postalcode': postalcodeController.text,
                      'name': nameOnCardController.text
                    };
                    Navigator.pop(context, data);
                  }).catchError(
                    (error) => {
                      setState(() {
                        _isLoading = false;
                        _stripeError = error.message;
                      }),
                    },
                  );
                },
              )
      ],
    );
  }
}
