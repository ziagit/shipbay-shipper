import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/settings.dart';

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

Future<List> getAccessory(path) async {
  try {
    var response = await http.get("$baseUrl$path");
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return jsonData;
    }
  } catch (err) {
    print('err: ${err.toString()}');
  }
}

Future<Map<String, dynamic>> getProfile(token) async {
  try {
    var response = await http.get(
      '$baseUrl' + 'shipping/shipper/details',
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
    final response = await http.post('$baseUrl' + 'shipping/shipper/details',
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
  print(id);
  try {
    final response = await http.put('$baseUrl' + 'shipping/shipper/details/$id',
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
    var response = await http.get('$baseUrl' + 'shipping/shipper/orders',
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
    var response = await http.get('$baseUrl' + 'shipping/shipper/orders/' + id,
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
    var response = await http.get('$baseUrl' + 'shipping/shipper/card-details',
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
      '$baseUrl' + 'shipping/charge',
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
      '$baseUrl' + 'shipping/charge',
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
      '$baseUrl' + 'shipping/charge',
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
      '$baseUrl' + 'shipping/charge-customer',
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

Future<http.Response> confirm(data, token) async {
  try {
    if (token == null) {
      var response = await http.post('$baseUrl' + 'shipping/confirm',
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'Charset': 'utf-8'
          },
          body: data);
      return response;
    } else {
      var response = await http.post('$baseUrl' + 'shipping/confirm',
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json;charset=UTF-8',
            'Charset': 'utf-8',
          },
          body: data);
      return response;
    }
  } catch (err) {
    print('err confirmming: ${err.toString()}');
  }
  return null;
}

Future<http.Response> carrierList(data, path) async {
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

Future<http.Response> getTerms() async {
  try {
    var response = await http.get('$baseUrl/get-terms', headers: {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    });
    return response;
  } catch (err) {
    print('err charging user: ${err.toString()}');
  }
  return null;
}

Future<http.Response> getPrivacy() async {
  try {
    var response = await http.get('$baseUrl/get-privacy', headers: {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    });
    return response;
  } catch (err) {
    print('err charging user: ${err.toString()}');
  }
  return null;
}

Future<http.Response> getFaq() async {
  try {
    var response = await http.get('$baseUrl/get-faq', headers: {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    });
    return response;
  } catch (err) {
    print('err charging user: ${err.toString()}');
  }
  return null;
}

Future<List> getCarrierFaq() async {
  try {
    var response = await http.get('$baseUrl/get-carrier-faq', headers: {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    });
    var jsonData = jsonDecode(response.body);
    return jsonData;
  } catch (err) {
    print('err charging user: ${err.toString()}');
  }
  return null;
}

Future<List> getShipperFaq() async {
  try {
    var response = await http.get('$baseUrl/get-shipper-faq', headers: {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    });
    var jsonData = jsonDecode(response.body);
    return jsonData;
  } catch (err) {
    print('err charging user: ${err.toString()}');
  }
  return null;
}

Future<http.Response> getAbout() async {
  try {
    var response = await http.get('$baseUrl/get-about', headers: {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    });
    return response;
  } catch (err) {
    print('err charging user: ${err.toString()}');
  }
  return null;
}
