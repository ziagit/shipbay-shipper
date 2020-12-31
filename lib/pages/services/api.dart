import 'dart:convert';
import 'package:http/http.dart';

class Countries {
  String name;
  String code;
  String url;

  Countries({this.name, this.code, this.url});

  Future<void> getData() async {
    try {
      Response response = await get("http://104.154.95.189/api/$url");
      Map data = jsonDecode(response.body);
      name = data['name'];
      code = data['code'];
    } catch (e) {
      print('Caught error $e');
      name = "Could not get the country name";
    }
  }
}
