import 'package:flutter/material.dart';
import 'package:shipbay/pages/store/store.dart';
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
                        "Book a shipment",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/pickup');
                      },
                    ),
                  ),
                ),
                Divider(),
                /* ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    "Acount",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/acount');
                  },
                ), */
                ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text(
                    "My Shipments",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/orders');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    "Profile",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/profile');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.credit_card),
                  title: Text(
                    "Payment",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/card');
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
                    "Shipbay",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/home');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.question_answer),
                  title: Text(
                    "How it works",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/how-works');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help_center),
                  title: Text(
                    "Help",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/help');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.list_alt),
                  title: Text(
                    "Terms",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/terms');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.privacy_tip),
                  title: Text(
                    "Privacies",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/privacy');
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
          RaisedButton(
              child: Text("Reset"),
              onPressed: () {
                Store store = Store();
                store.removeOrder();
                Navigator.of(context).pop();
              })
        ],
      ),
    );
  }

  @override
  void initState() {
    _getDetails();
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

  _getDetails() async {
    String token = await store.read('token');
    if (token != null) {
      shipperDetails(token).then(
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
