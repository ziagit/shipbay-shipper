import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shipbay/models/address.dart';
import 'package:shipbay/models/placePredictions.dart';
import 'package:shipbay/services/settings.dart';

class PredictionTile extends StatelessWidget {
  String country;
  String state;
  String city;
  String zip;
  String street;
  String street_number;

  final PlacePredictions placePredictions;
  PredictionTile({Key key, this.placePredictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        getPlaceAddressDetails(placePredictions, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10.0),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0),
                      Text(
                        placePredictions.main_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        placePredictions.secondary_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8.0),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(width: 10.0)
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(
      PlacePredictions placePredictions, context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          width: 70.0,
          height: 70.0,
          child: new Padding(
            padding: const EdgeInsets.all(5.0),
            child: new Center(
              child: new CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(primary),
              ),
            ),
          ),
        );
      },
    );

    String placeDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=${placePredictions.place_id}&key=$mapKey";
    var res = await http.get(placeDetailsUrl);
    Map data = jsonDecode(res.body);

    Navigator.pop(context);

    for (var component in data['result']['address_components']) {
      var types = component['types'];
      if (types.indexOf("street_number") > -1) {
        street_number = component['long_name'];
      }
      if (types.indexOf("route") > -1) {
        street = component['long_name'];
      }
      if (types.indexOf("locality") > -1) {
        city = component['long_name'];
      }
      if (types.indexOf("administrative_area_level_1") > -1) {
        state = component['short_name'];
      }
      if (types.indexOf("postal_code") > -1) {
        zip = component['long_name'];
      }
      if (types.indexOf("country") > -1) {
        country = component['long_name'];
      }
    }
    Address address = Address(country, state, city, zip, street, street_number);
  }
}
