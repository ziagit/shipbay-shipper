import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/main_menu.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/services/settings.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Shipper extends StatefulWidget {
  @override
  _ShipperState createState() => _ShipperState();
}

class _ShipperState extends State<Shipper> {
  String _name;
  String _email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: primary),
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.location_on,
                color: primary,
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      drawer: MainMenu(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
            child: Column(
          children: [
            Text("$_name"),
            Text("$_email"),
          ],
        )),
      ),
    );
  }

  @override
  void initState() {
    _getDetails();
    super.initState();
  }

  Future<Map<String, dynamic>> _getDetails() async {
    Store store = Store();
    String _token = await store.read('token');
    try {
      var response =
          await http.get('http://192.168.2.36:8000/api/auth/me', headers: {
        'Authorization': 'Bearer ${_token}',
        'Content-Type': 'application/x-www-form-urlencoded'
      });
      var data = jsonDecode(response.body);
      setState(() {
        _name = data['name'];
        _email = data['email'];
      });
    } catch (err) {
      print('err: ${err.toString()}');
    }
    return null;
  }
}
