import 'package:flutter/material.dart';
import 'package:shipbay/pages/store/store.dart';
import 'dart:convert';
import 'package:shipbay/services/api.dart';
import 'package:shipbay/services/settings.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
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
            color: Colors.orange[900],
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 80.0,
                    height: 80.0,
                    margin: EdgeInsets.only(top: 30.0),
                    child: CircleAvatar(
                      radius: 25.0,
                      child: Text("S",
                          style: TextStyle(
                              fontSize: 26.0,
                              color: primary,
                              fontWeight: FontWeight.bold)),
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
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text(
                    "Home",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
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
                Divider(),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    "Acount",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/acount');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.details),
                  title: Text(
                    "Profile",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/profile');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.add_box),
                  title: Text(
                    "Orders",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/orders');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.credit_card),
                  title: Text(
                    "Card",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/card');
                  },
                ),
              ],
            ),
          ),
          Visibility(
            visible: !_isLogedin,
            child: ListTile(
              leading: Icon(Icons.arrow_forward),
              title: Text(
                "Login",
                style: TextStyle(fontSize: 14.0),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/signin');
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _getDetails();
    super.initState();
  }

  Future<Map<String, dynamic>> _logout(context) async {
    Logout instance = Logout(context);
    String token = await store.read('token');
    if (token != null) {
      await instance.logout(token).then((response) => {}).whenComplete(
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

  Future<Map<String, dynamic>> _getDetails() async {
    Details instance = Details();

    String token = await store.read('token');
    if (token != null) {
      await instance.details(token).then(
            (response) => {
              setState(
                () {
                  _name = response['name'];
                  _email = response['email'];
                  _isLogedin = true;
                },
              ),
            },
          );
    }
  }
}
