import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/services/settings.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:shipbay/services/api.dart';

class PaymentDetails extends StatefulWidget {
  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  double _progress = 85.0;
  bool _loading = false;
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(child: Progress(progress: _progress)),
                Text(
                  "Payment details",
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
                      (_paymentStatus == 'unpaid' || _paymentStatus == null)
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
                                Navigator.pushReplacementNamed(
                                    context, '/confirm');
                              },
                            ),
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
    _init();
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
      _charge(value);
    });
  }

  _charge(card) async {
    var token = await store.read('token');
    var carrier = await store.read('carrier');
    if (token != null) {
      _addCard(carrier, card, token);
    } else {
      _chargeNow(carrier, card);
    }
    setState(() {
      _loading = true;
    });
  }

  _init() async {
    var billing = await store.read('billing');
    if (billing != null && billing['status'] == 'paid') {
      setState(() {
        _progress = 100.0;
        _paymentStatus = billing['status'];
        _paymentMessage = billing['message'];
        _successColor = Colors.green;
      });
    }
  }

  _addCard(carrier, card, token) async {
    var jsonData = await addCard(carrier, card, token);
    store.save('billing', {
      'status': jsonData['status'],
      'email': jsonData['email'],
      'message': jsonData['message'],
      'orderId': jsonData['id']
    });
    Navigator.pushReplacementNamed(context, '/card',
        arguments: jsonData['message']);
  }

  _chargeNow(carrier, data) async {
    var jsonData = await chargeNow(carrier, data);
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
    });
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
  final _formKey = GlobalKey<FormState>();

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
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Flexible(
            child: TextFormField(
              autofocus: true,
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              style: TextStyle(fontSize: 14.0),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
          ),
          Flexible(
            child: TextFormField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
              style: TextStyle(fontSize: 14.0),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a valid address';
                }
                return null;
              },
            ),
          ),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: cityController,
                  decoration: InputDecoration(labelText: 'City'),
                  style: TextStyle(fontSize: 14.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid city';
                    }
                    return null;
                  },
                ),
              ),
              Flexible(
                child: TextFormField(
                  controller: stateController,
                  decoration: InputDecoration(labelText: 'State'),
                  style: TextStyle(fontSize: 14.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid state';
                    }
                    return null;
                  },
                ),
              ),
              Flexible(
                child: TextFormField(
                  controller: postalcodeController,
                  decoration: InputDecoration(labelText: 'Postalcode'),
                  style: TextStyle(fontSize: 14.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid postalcode';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          Flexible(
            child: TextFormField(
              controller: nameOnCardController,
              decoration: InputDecoration(labelText: 'Name on card'),
              style: TextStyle(fontSize: 14.0),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a valid name';
                }
                return null;
              },
            ),
          ),
          Flexible(
            child: TextFormField(
              controller: cardNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [LengthLimitingTextInputFormatter(16)],
              decoration: InputDecoration(
                labelText: 'Card number',
                prefixIcon: Icon(Icons.credit_card),
              ),
              style: TextStyle(fontSize: 14.0),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a valid card number';
                }
                return null;
              },
            ),
          ),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: cvcController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(3)],
                  decoration: InputDecoration(labelText: 'CVC'),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a 3 digits number';
                    }
                    return null;
                  },
                ),
              ),
              Flexible(
                child: TextFormField(
                  controller: expMonthController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(2)],
                  decoration: InputDecoration(labelText: 'Exp month'),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid 2 ditis month';
                    }
                    return null;
                  },
                ),
              ),
              Flexible(
                child: TextFormField(
                  controller: expYearController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(2)],
                  decoration: InputDecoration(labelText: 'Exp year'),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid 2 digits year';
                    }
                    return null;
                  },
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
                    if (_formKey.currentState.validate()) {
                      setState(
                        () {
                          _isLoading = true;
                        },
                      );
                      final CreditCard shippingCard = CreditCard(
                        number: cardNumberController.text,
                        expMonth: int.parse(expMonthController.text),
                        expYear: int.parse(expYearController.text),
                        cvc: cvcController.text,
                      );

                      StripePayment.createTokenWithCard(shippingCard).then(
                        (token) {
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
                        },
                      ).catchError(
                        (error) => {
                          setState(
                            () {
                              _isLoading = false;
                              _stripeError = error.message;
                            },
                          ),
                        },
                      );
                    }
                  },
                )
        ],
      ),
    );
  }
}
