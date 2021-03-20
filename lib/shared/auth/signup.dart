import 'package:flutter/material.dart';
import 'package:shipbay/shared/services/api.dart';
import 'dart:convert';
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/colors.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  Store store = Store();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String _role = 'shipper';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.0,
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
                    child: Icon(Icons.person_add, color: Colors.white),
                    backgroundColor: primary,
                  ),
                  decoration: BoxDecoration(),
                ),
                SizedBox(height: 40.0),
                Text(
                  "Register",
                  style: TextStyle(fontSize: 24.0),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _nameController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Name'),
                        ),
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Email'),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Password'),
                        ),
                        TextFormField(
                          controller: _confirmPasswordController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid password';
                            }
                            return null;
                          },
                          decoration:
                              InputDecoration(labelText: 'Confirm password'),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new Radio(
                              value: 'shipper',
                              groupValue: _role,
                              onChanged: _handleRole,
                              activeColor: primary,
                            ),
                            new Text(
                              'Shipper',
                              style: new TextStyle(fontSize: 16.0),
                            ),
                            new Radio(
                              value: 'mover',
                              groupValue: _role,
                              onChanged: _handleRole,
                              activeColor: primary,
                            ),
                            new Text(
                              'Mover',
                              style: new TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        SizedBox(
                          width: double.infinity,
                          height: 46.0,
                          child: RaisedButton(
                            color: primary,
                            child: Text(
                              "Signup",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _register(context);
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Visibility(
                          visible: _isLoading,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(primary),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(width: 1.0),
                            FlatButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/signin');
                              },
                              child: Text(
                                'Signin',
                                style:
                                    TextStyle(color: primary, fontSize: 12.0),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                            )
                          ],
                        )
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
      // child: Text("This is where your content goes")
    );
  }

  _handleRole(value) {
    setState(() {
      _role = value;
    });
  }

  void _register(context) async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("Passwords not matchs!")));
      return null;
    }
    setState(() {
      _isLoading = true;
    });
    if (_role == 'shipper') {
      var response = await register(
          jsonEncode(<String, dynamic>{
            "name": _nameController.text,
            "email": _emailController.text,
            "password": _passwordController.text,
            "password_confirmation": _confirmPasswordController.text,
            "type": _role,
          }),
          "shipping/auth/signup");
      var jsonData = jsonDecode(response.body);
      if (response != null) {
        print(jsonData);
        store.save('token', jsonData);
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacementNamed(
          context,
          '/welcome',
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(jsonData)));
      }
    } else {
      var response = await register(
          jsonEncode(<String, dynamic>{
            "name": _nameController.text,
            "email": _emailController.text,
            "password": _passwordController.text,
            "password_confirmation": _confirmPasswordController.text,
            "type": _role,
          }),
          "moving/auth/signup");
      var jsonData = jsonDecode(response.body);

      if (response != null) {
        store.save('token', jsonData);
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacementNamed(
          context,
          '/welcome',
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(jsonData)));
      }
    }
  }
}
