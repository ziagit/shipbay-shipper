import 'package:flutter/material.dart';
import 'package:shipbay/pages/store/store.dart';
import 'dart:convert';
import 'package:shipbay/services/api.dart';

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
                    width: 100.0,
                    height: 100.0,
                    margin: EdgeInsets.only(top: 30.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://s3.amazonaws.com/creativetim_bucket/new_logo.png'),
                          fit: BoxFit.fill),
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
                          style: TextStyle(color: Colors.white),
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
                  leading: Icon(Icons.person),
                  title: Text(
                    "Profile",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    _profile(context);
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

  Future<String> _profile(context) async {
    String _token = await store.read('token');
    if (_token != null) {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('/shipper');
    } else {
      Navigator.of(context).pushNamed('/signin');
    }
  }

  Future<Map<String, dynamic>> _logout(context) async {
    Logout instance = Logout(context);
    await instance.logout().then((response) => {}).whenComplete(
          () => {
            setState(() {
              _isLogedin = false;
            }),
            Navigator.pushReplacementNamed(context, '/home'),
          },
        );
    return null;
  }

  Future<Map<String, dynamic>> _getDetails() async {
    Details instance = Details();
    Store store = Store();
    String token = await store.read('token');
    if (token != null) {
      await instance
          .details()
          .then((response) => {
                print(response),
                setState(() {
                  _name = response['name'];
                  _email = response['email'];
                  _isLogedin = true;
                }),
              })
          .whenComplete(
            () => {
              setState(() {}),
            },
          );
    }
  }
}
