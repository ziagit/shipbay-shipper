import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/services/api.dart';
import 'package:shipbay/services/settings.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
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
      appBar: AppBar(
        backgroundColor: Color(0xF8FAF8),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/carriers');
          },
        ),
      ),

      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: 150.0,
                  child: Image(
                    image: AssetImage('assets/images/coffeequery.png'),
                  ),
                ),
                SizedBox(height: 24.0),
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
                        SizedBox(height: 60.0),
                        SizedBox(
                          width: double.infinity,
                          height: 46.0,
                          child: RaisedButton(
                            color: Colors.orange[900],
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

  Future<Map<String, dynamic>> _register(context) async {
    setState(() {
      _isLoading = true;
    });
    Register instance = Register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
        _confirmPasswordController.text,
        _role,
        context);
    instance.register().then(
          (response) => {
            if (response['token'] != null)
              {
                store.save('token', response['token']),
                setState(() {
                  _isLoading = false;
                }),
                Navigator.pushReplacementNamed(context, '/welcome'),
              }
          },
        );
  }
}
