import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/settings.dart';

Future<List> getData(path) async {
  try {
    var response = await http.get("$baseUrl$path");
    var jsonData = jsonDecode(response.body);
    return jsonData;
  } catch (err) {
    print('err: ${err.toString()}');
  }
}

Future<http.Response> getMovers(data, path) async {
  try {
    var response = await http.post('$baseUrl$path',
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

Future<Map<String, dynamic>> shipperDetails(token) async {
  try {
    var response = await http.get('$baseUrl' + 'moving/auth/me', headers: {
      'Authorization': 'Bearer ${token}',
      'Content-Type': 'application/json'
    });
    return jsonDecode(response.body);
  } catch (err) {
    print('err: ${err.toString()}');
  }
  return null;
}

Future<Map<String, dynamic>> getProfile(token) async {
  try {
    var response = await http.get(
      '$baseUrl' + 'moving/shipper/details',
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
    final response = await http.post('$baseUrl' + 'moving/shipper/details',
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
    final response = await http.put(
        '$baseUrl' + 'moving/shipper/details/' + id.toString(),
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
    var response = await http.get('$baseUrl' + 'moving/shipper/orders',
        headers: {
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
    var response = await http.get('$baseUrl' + 'moving/shipper/orders/' + id,
        headers: {
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
    var response = await http.get('$baseUrl' + 'moving/shipper/card-details',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        });
    return jsonDecode(response.body);
  } catch (err) {
    print('err: ${err.toString()}');
  }
  return null;
}

Future<Map<String, dynamic>> addCustomer(data, token) async {
  try {
    var response = await http.post(
      '$baseUrl' + 'moving/charge',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, Object>{
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

Future<Map<String, dynamic>> addCard(carrier, data, token) async {
  try {
    var response = await http.post(
      '$baseUrl' + 'moving/charge',
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

Future<Map<String, dynamic>> chargeNow(mover, data) async {
  String path = "moving/charge";
  try {
    var response = await http.post(
      '$baseUrl$path',
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, Object>{
        'price': mover['price'],
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

Future<Map<String, dynamic>> chargeCustomer(mover, billing, token) async {
  try {
    var response = await http.post(
      '$baseUrl' + 'moving/charge-customer',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        "price": mover['price'],
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

Future<http.Response> confirm(data, token, path) async {
  try {
    if (token == null) {
      var response = await http.post('$baseUrl$path',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'Charset': 'utf-8'
          },
          body: data);
      return response;
    } else {
      var response = await http.post('$baseUrl$path',
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json;charset=UTF-8',
            'Charset': 'utf-8',
          },
          body: data);
      return response;
    }
  } catch (err) {
    print('err charging user: ${err.toString()}');
  }
  return null;
}

Future<Map> getDestance(from, to) async {
  try {
    var response = await http.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$from&destinations=$to&mode=driving&language=en-EN&key=$mapKey");
    Map data = jsonDecode(response.body);
    return data;
  } catch (err) {
    print('err getting destance: ${err.toString()}');
  }
  return null;
}
