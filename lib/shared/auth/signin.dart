import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  Store store = Store();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var _pendingOrder;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: primary),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 80.0,
                  height: 80.0,
                  child: CircleAvatar(
                    radius: 25.0,
                    child: Icon(Icons.person, color: Colors.white),
                    backgroundColor: primary,
                  ),
                  decoration: BoxDecoration(),
                ),
                SizedBox(height: 40.0),
                Text(
                  "Login",
                  style: TextStyle(fontSize: 24.0),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'Username'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: true,
                          decoration: InputDecoration(labelText: 'Password'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(width: 1.0),
                            FlatButton(
                              child: Text("Forget password",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.blue)),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        SizedBox(height: 24.0),
                        SizedBox(
                          width: double.infinity,
                          height: 46.0,
                          child: RaisedButton(
                            color: primary,
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _login(context);
                              }
                            },
                          ),
                        ),
                        Visibility(
                          visible: _isLoading,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(primary),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Visibility(
                                visible: true,
                                child: _pendingOrder != null
                                    ? FlatButton(
                                        onPressed: () {
                                          _guest(context);
                                        },
                                        child: Text("Continue as guest",
                                            style: TextStyle(fontSize: 12.0)),
                                      )
                                    : Container()),
                            FlatButton(
                              child: Text(
                                "Register",
                                style:
                                    TextStyle(color: primary, fontSize: 12.0),
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/signup');
                              },
                            ),
                          ],
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
      // child: Text("This is where your content goes")
    );
  }

  @override
  void initState() {
    _order();
    super.initState();
  }

  _order() async {
    var contacts = await store.read('contacts');
    var additionDetails = await store.read('additional-details');
    setState(() {
      if (contacts != null) {
        _pendingOrder = contacts;
      } else {
        _pendingOrder = additionDetails;
      }
    });
  }

  _guest(context) async {
    if (await store.read('app') == 'moving') {
      Navigator.pushReplacementNamed(context, '/payment');
    } else {
      Navigator.pushReplacementNamed(context, '/payment-details');
    }
  }

  _login(context) async {
    setState(() {
      _isLoading = true;
    });
    if (await store.read('app') == 'moving') {
      var response = await login(
          _emailController.text, _passwordController.text, 'moving/');
      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        store.save('token', jsonData);
        if (_pendingOrder != null) {
          _isLoading = false;
          Navigator.pushReplacementNamed(context, '/payment');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(jsonData['message'])));
      }
    } else {
      var response = await login(
          _emailController.text, _passwordController.text, 'shipping/');
      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        store.save('token', jsonData);
        if (_pendingOrder != null) {
          _isLoading = false;
          Navigator.pushReplacementNamed(context, '/payment-details');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(jsonData['message'])));
      }
    }
  }

  _checkRole(token) async {
    _isLoading = false;
    if (await store.read('app') == 'moving') {
      Navigator.pushReplacementNamed(context, '/payment');
    } else {
      Navigator.pushReplacementNamed(context, '/payment-details');
    }
  }
}
