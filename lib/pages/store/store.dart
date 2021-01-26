import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Store {
  read(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return json.decode(prefs.getString(key));
    } else {
      return null;
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

  removeOrder() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('pickup');
    prefs.remove('delivery');
    prefs.remove('pickup-services');
    prefs.remove('pickup-date');
    prefs.remove('delivery-services');
    prefs.remove('delivery-appointment-time');
    prefs.remove('item-condition');
    prefs.remove('temperature');
    prefs.remove('additional-details');
    prefs.remove('items');
    prefs.remove('billing');
    prefs.remove('carrier');
  }

  check(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key) ? true : false;
  }
}
