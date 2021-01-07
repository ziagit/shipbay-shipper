import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shipbay/models/accessory.dart';
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
