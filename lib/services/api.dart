import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shipbay/models/accessory.dart';
import 'package:shipbay/models/carrier_model.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/services/settings.dart';

class Countries {
  String name;
  String code;
  String url;
  Countries({this.name, this.code, this.url});
  Future<void> getData() async {
    try {
      var response = await http.get("$baseUrl$url");
      Map data = jsonDecode(response.body);
      name = data['name'];
      code = data['code'];
    } catch (e) {
      print('Caught error $e');
      name = "Could not get the country";
    }
  }
}

class Accessories {
  String url;
  Accessories(this.url);
  Future<List<Accessory>> getData() async {
    var response = await http.get("$baseUrl$url");
    var jsonData = jsonDecode(response.body);
    List<Accessory> accessories = [];
    for (var a in jsonData) {
      Accessory accessory = Accessory(a['index'], a['name'], a['code']);
      accessories.add(accessory);
    }
    return accessories;
  }
}

class Carriers {
  String url;
  Map order;
  Carriers(this.url, this.order);
  Future<List<Carrier>> getCarriers() async {
    var response = await http.post(
      "http://104.154.95.189/api/carriers-rate",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'order': order,
      }),
    );
    var jsonData = jsonDecode(response.body);
    return jsonData;
  }
}

class Login {
  String email;
  String password;
  BuildContext context;
  Login(this.email, this.password, this.context);
  Store store = Store();

  Future<Map<String, dynamic>> login() async {
    try {
      Map<String, dynamic> body = {
        'email': email,
        'password': password,
      };
      var response = await http.post('http://192.168.2.36:8000/api/auth/signin',
          body: body,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'});
      var data = jsonDecode(response.body);
      if (data['token'] != null) {
        store.save('token', data['token']);
      }
    } catch (err) {
      print('err: ${err.toString()}');
    }
    return null;
  }
}

class Register {
  String name;
  String email;
  String password;
  String password_confirmation;
  String role;
  BuildContext context;
  Register(this.name, this.email, this.password, this.password_confirmation,
      this.role, this.context);
  Future<Map<String, dynamic>> register() async {
    try {
      Map<String, dynamic> body = {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password_confirmation,
        'role': role,
      };
      var response = await http.post('http://192.168.2.36:8000/api/auth/signup',
          body: body,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'});
      var data = jsonDecode(response.body);
      if (data['token'] != null) {
        Store store = Store();
        store.save('token', data['token']);
      }
    } catch (err) {
      print('err: ${err.toString()}');
    }
    return null;
  }
}

class Logout {
  Store store = Store();
  BuildContext context;
  Logout(this.context);
  Future<Map<String, dynamic>> logout() async {
    String _token = await store.read('token');
    try {
      var response = await http
          .post('http://192.168.2.36:8000/api/auth/signout', headers: {
        'Authorization': 'Bearer ${_token}',
        'Content-Type': 'application/x-www-form-urlencoded'
      });
      store.remove('token');
      Navigator.of(context).pop();
    } catch (err) {
      print('err: ${err.toString()}');
    }
    return null;
  }
}

class Details {
  Details();
  Future<Map<String, dynamic>> details() async {
    Store store = Store();
    String _token = await store.read('token');
    try {
      var response =
          await http.get('http://192.168.2.36:8000/api/auth/me', headers: {
        'Authorization': 'Bearer ${_token}',
        'Content-Type': 'application/x-www-form-urlencoded'
      });
      var data = jsonDecode(response.body);
      return data;
    } catch (err) {
      print('err: ${err.toString()}');
    }
    return null;
  }
}
