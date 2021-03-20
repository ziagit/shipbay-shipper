import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/settings.dart';

Future<http.Response> login(email, password, path) async {
  try {
    var response = await http.post(
      '$baseUrl$path' + 'auth/signin',
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{"email": email, "password": password}),
    );
    return response;
  } catch (err) {
    print('err: ${err.toString()}');
  }
  return null;
}

Future<http.Response> getMe(path, token) async {
  try {
    var response = await http.get('$baseUrl$path', headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded'
    });
    return response.statusCode == 200 ? response : null;
  } catch (err) {
    print('err: ${err.toString()}');
  }
  return null;
}

Future<http.Response> register(data, path) async {
  print(data);
  try {
    var response = await http.post('$baseUrl$path',
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
    await http.post('$baseUrl' + 'auth/signout', headers: {
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

Future<http.Response> getData(path) async {
  print("about path $path");
  try {
    var response = await http.get('$baseUrl$path', headers: {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    });
    return response;
  } catch (err) {
    print('err charging user: ${err.toString()}');
  }
  return null;
}

Future<List> getFaqs(path) async {
  try {
    var response = await http.get('$baseUrl$path', headers: {
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
