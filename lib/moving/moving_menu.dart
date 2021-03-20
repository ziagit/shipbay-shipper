import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/colors.dart';

class MovingMenu extends StatefulWidget {
  @override
  _MovingMenuState createState() => _MovingMenuState();
}

class _MovingMenuState extends State<MovingMenu> {
  Store store = Store();
  String _name;
  String _email;
  bool _isLogedin = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.0),
            color: primary,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 80.0,
                    height: 80.0,
                    margin: EdgeInsets.only(top: 30.0),
                    child: CircleAvatar(
                      radius: 25.0,
                      child: Icon(Icons.person, color: primary),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Visibility(
                    visible: _isLogedin,
                    child: Column(
                      children: [
                        Text(
                          "$_name",
                          style: TextStyle(fontSize: 22.0, color: Colors.white),
                        ),
                        Text(
                          "$_email",
                          style: TextStyle(fontSize: 12.0, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _isLogedin,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 7.0, 16.0, 0.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40.0,
                    child: RaisedButton(
                      color: primary,
                      child: Text(
                        "Let's move",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/from');
                      },
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text(
                    "My moves",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/customer-orders');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    "Profile",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/customer-profile');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.credit_card),
                  title: Text(
                    "Payment",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/customer-card-details');
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.arrow_back),
                  title: Text(
                    "Logout",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    _logout(context);
                  },
                ),
              ],
            ),
          ),
          Visibility(
            visible: !_isLogedin,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text(
                    "Home",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/home');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help_center),
                  title: Text(
                    "Help",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    _navigate(context, '/help');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.list_alt),
                  title: Text(
                    "Terms",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    _navigate(context, '/terms');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.privacy_tip),
                  title: Text(
                    "Privacies",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    _navigate(context, '/privacy');
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.arrow_forward),
                  title: Text(
                    "Signin",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/signin');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person_add),
                  title: Text(
                    "Signup",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/signup');
                  },
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
    _getMe();
    super.initState();
  }

  _logout(context) async {
    String token = await store.read('token');
    if (token != null) {
      logout(token, context).then((response) => {}).whenComplete(
            () => {
              setState(() {
                _isLogedin = false;
              }),
              Navigator.pushReplacementNamed(context, '/home'),
            },
          );
      return null;
    }
  }

  _getMe() async {
    String token = await store.read('token');
    if (token != null && await store.read('app') == 'moving') {
      var response = await getMe('moving/auth/me', token);
      var jsonData = jsonDecode(response.body);
      setState(
        () {
          _name = jsonData['name'];
          _email = jsonData['email'];
          _isLogedin = true;
        },
      );
    }
  }

  _navigate(context, path) {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, path, arguments: 'moving/');
  }
}
