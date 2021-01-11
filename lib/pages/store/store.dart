import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Store {
  read(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('src')) {
      return json.decode(prefs.getString('src'));
    } else {
      print("not exist............");
    }
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  check(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key) ? true : false;
  }
}