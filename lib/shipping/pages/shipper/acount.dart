import 'package:flutter/material.dart';
import 'package:shipbay/shipping/shipping_menu.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/settings.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Acount extends StatefulWidget {
  @override
  _AcountState createState() => _AcountState();
}

class _AcountState extends State<Acount> {
  String _name;
  String _email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: primary,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.edit,
                color: primary,
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      drawer: ShippingMenu(),
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
      var response = await http.get('$baseUrl/auth/me', headers: {
        'Authorization': 'Bearer $_token',
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
