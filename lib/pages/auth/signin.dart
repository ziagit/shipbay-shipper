import 'package:flutter/material.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/services/api.dart';
import 'package:shipbay/services/settings.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
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
                            color: Colors.orange[900],
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
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/payment-details');
                                },
                                child: Text("Continue as guest",
                                    style: TextStyle(fontSize: 12.0)),
                              ),
                            ),
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
    _pendingOrder();
    super.initState();
  }

  _pendingOrder() async {
    Store store = Store();
    var data = store.read('pickup');
    if (data != null) {
      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>> _login(context) async {
    setState(() {
      _isLoading = true;
    });
    Login instance =
        Login(_emailController.text, _passwordController.text, context);
    await instance.login().then((response) => {}).whenComplete(
          () => {
            setState(
              () {
                _isLoading = false;
              },
            ),
            Navigator.pushReplacementNamed(context, '/home'),
          },
        );
  }
}
