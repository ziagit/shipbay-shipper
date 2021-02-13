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

Future<List> getLocationType() async {
  try {
    var response = await http.get("$baseUrl/location-type");
    var jsonData = jsonDecode(response.body);
    return jsonData;
  } catch (err) {
    print('err: ${err.toString()}');
  }
}

Future<List<dynamic>> getPickServices() async {
  try {
    var response = await http.get("$baseUrl/pick-services");
    var jsonData = jsonDecode(response.body);
    return jsonData;
  } catch (err) {
    print('err: ${err.toString()}');
  }
}

Future<http.Response> login(email, password) async {
  try {
    var response = await http.post(
      '$baseUrl/auth/signin',
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{"email": email, "password": password}),
    );
    return response;
  } catch (err) {
    print('err: ${err.toString()}');
  }
  return null;
}

Future<http.Response> register(data) async {
  try {
    var response = await http.post('$baseUrl/auth/signup',
        headers: {'Content-Type': 'application/json'}, body: data);
    return response;
  } catch (err) {
    print('err: ${err.toString()}');
  }
  return null;
}

Future<Map<String, dynamic>> logout(token, context) async {
  Store store = Store();
  try {
    await http.post('$baseUrl/auth/signout', headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });
    store.remove('token');
    Navigator.of(context).pop();
  } catch (err) {
    print('err: ${err.toString()}');
  }
  return null;
}

Future<Map<String, dynamic>> shipperDetails(token) async {
  try {
    var response = await http.get('$baseUrl/auth/me', headers: {
      'Authorization': 'Bearer ${token}',
      'Content-Type': 'application/json'
    });
    return jsonDecode(response.body);
  } catch (err) {
    print('err: ${err.toString()}');
  }
  return null;
}

class ItemType {
  ItemType();
  Future<Map<String, dynamic>> types() async {
    try {
      var response = await http.get('$baseUrl/item-type',
          headers: {'Content-Type': 'application/json'});
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
        'Content-Type': 'application/json'
      },
    );
    return jsonDecode(response.body);
  } catch (err) {
    print('err: ${err.toString()}');
  }
  return null;
}

Future<http.Response> saveProfile(data, token) async {
  try {
    final response = await http.post('$baseUrl/shipper/details',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: data);
    return response;
  } catch (err) {
    print('err: ${err.toString()}');
  }
  return null;
}

Future<http.Response> updateProfile(id, data, token) async {
  try {
    final response = await http.put('$baseUrl/shipper/details/' + id.toString(),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: data);
    return response;
  } catch (err) {
    print('err: ${err.toString()}');
  }
  return null;
}

Future<List> getOrders(token) async {
  try {
    var response = await http.get('$baseUrl/shipper/orders', headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
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
      'Content-Type': 'application/json'
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
      'Content-Type': 'application/json'
    });
    return jsonDecode(response.body);
  } catch (err) {
    print('err: ${err.toString()}');
  }
  return null;
}

Future<Map<String, dynamic>> addCard(carrier, data, token) async {
  print(data);
  try {
    var response = await http.post(
      '$baseUrl/charge',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
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

Future<http.Response> confirm(data) async {
  try {
    var response = await http.post('$baseUrl/confirm',
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Charset': 'utf-8'
        },
        body: data);
    return response;
  } catch (err) {
    print('err charging user: ${err.toString()}');
  }
  return null;
}

Future<http.Response> carrierList(data) async {
  try {
    var response = await http.post('$baseUrl/carriers-rate',
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Charset': 'utf-8'
        },
        body: data);
    return response;
  } catch (err) {
    print('err charging user: ${err.toString()}');
  }
  return null;
}
