import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/services/api.dart';
import 'package:shipbay/services/settings.dart';

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
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
                                          Navigator.pushReplacementNamed(
                                              context, '/payment-details');
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
    var data = await store.read('additional-details');
    setState(() {
      _pendingOrder = data;
    });
  }

  _login(context) async {
    setState(() {
      _isLoading = true;
    });

    var response = await login(_emailController.text, _passwordController.text);
    var jsonData = jsonDecode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      if (_pendingOrder != null) {
        _isLoading = false;
        store.save('token', jsonData);
        Navigator.pushReplacementNamed(context, '/payment-details');
      } else {
        _isLoading = false;
        store.save('token', jsonData);
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
