import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shipbay/models/accessory.dart';
import 'package:shipbay/models/carrier_model.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/services/settings.dart';
import 'package:stripe_payment/stripe_payment.dart';

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
      "http://35.184.16.20/api/carriers-rate",
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
      var response = await http.post('$baseUrl/auth/signin',
          body: body,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'});
      var data = jsonDecode(response.body);
      return data;
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
      var response = await http.post('$baseUrl/auth/signup',
          body: body,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'});
      var data = jsonDecode(response.body);
      if (data['token'] != null) {
        return data;
      }
      return null;
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
  Future<Map<String, dynamic>> logout(token) async {
    try {
      await http.post('$baseUrl/auth/signout', headers: {
        'Authorization': 'Bearer ${token}',
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
  Future<Map<String, dynamic>> details(token) async {
    try {
      var response = await http.get('$baseUrl/auth/me', headers: {
        'Authorization': 'Bearer ${token}',
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

class ItemType {
  ItemType();
  Future<Map<String, dynamic>> types() async {
    try {
      var response = await http.get('$baseUrl/item-type',
          headers: {'Content-Type': 'application/x-www-form-urlencoded'});
      var data = jsonDecode(response.body);
      return data;
    } catch (err) {
      print('err: ${err.toString()}');
    }
    return null;
  }
}

Future<Map<String, dynamic>> getProfile(token) async {
  try {
    var response = await http.get(
      '$baseUrl/shipper/details',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
    );
    return jsonDecode(response.body);
  } catch (err) {
    print('err: ${err.toString()}');
  }
  return null;
}

Future<Map<String, dynamic>> save(data, token) async {
  try {
    final response = await http.post('$baseUrl/shipper/details',
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        },
        body: data);
    return jsonDecode(response.body);
  } catch (err) {
    print('err: ${err.toString()}');
  }
  return null;
}

Future<List> getOrders(token) async {
  try {
    var response = await http.get('$baseUrl/shipper/orders', headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded'
    });
    return jsonDecode(response.body);
  } catch (err) {
    print('err: ${err.toString()}');
  }
  return null;
}

Future<Map> getOrder(id, token) async {
  try {
    var response = await http.get('$baseUrl/shipper/orders/' + id, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded'
    });
    return jsonDecode(response.body);
  } catch (err) {
    print('err: ${err.toString()}');
  }
  return null;
}

Future<Map> getCard(token) async {
  try {
    var response = await http.get('$baseUrl/shipper/card-details', headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded'
    });
    return jsonDecode(response.body);
  } catch (err) {
    print('err: ${err.toString()}');
  }
  return null;
}

Future<Map<String, dynamic>> addCard(carrier, data, token) async {
  try {
    var response = await http.post(
      '$baseUrl/charge',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: jsonEncode(<String, Object>{
        'price': carrier['price'],
        'stripeToken': data['token'],
        'email': data['email'],
        'address': data['address'],
        'city': data['city'],
        'state': data['state'],
        'postalcode': data['postalcode'],
        'name': data['name']
      }),
    );
    return jsonDecode(response.body);
  } catch (err) {
    print('err charging user: ${err.toString()}');
  }
  return null;
}

Future<Map<String, dynamic>> chargeNow(carrier, data) async {
  try {
    var response = await http.post(
      '$baseUrl/charge',
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, Object>{
        'price': carrier['price'],
        'stripeToken': data['token'],
        'email': data['email'],
        'address': data['address'],
        'city': data['city'],
        'state': data['state'],
        'postalcode': data['postalcode'],
        'name': data['name']
      }),
    );
    return jsonDecode(response.body);
  } catch (err) {
    print('err charging user: ${err.toString()}');
  }
  return null;
}

Future<Map<String, dynamic>> chargeCustomer(carrier, billing, token) async {
  try {
    var response = await http.post(
      '$baseUrl/charge-customer',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        "price": carrier['price'],
        "id": billing['orderId'],
        "email": billing['email']
      }),
    );
    return jsonDecode(response.body);
  } catch (err) {
    print('err charging user: ${err.toString()}');
  }
  return null;
}
