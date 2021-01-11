import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:shipbay/models/accessory.dart';
import 'package:shipbay/models/pickup_address.dart';
import 'package:shipbay/pages/shared/google_address.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/services/settings.dart';
import 'package:shipbay/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

class Pickup extends StatefulWidget {
  @override
  _PickupState createState() => _PickupState();
}

class _PickupState extends State<Pickup> {
  PickupAddress addressLoad;
  TextEditingController _addressController;
  String groupValue = 'bs';

  String country;
  String state;
  String city;
  String zip;
  String street;
  String street_number;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: primary));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  SizedBox(child: Progress(progress: 0.0)),
                  SizedBox(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Pickup address",
                          style: TextStyle(fontSize: 24.0, height: 2.0),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(hintText: 'Postal code'),
                          onChanged: (keyword) {
                            _openDialog(context, keyword);
                          },
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Radio(
                                    activeColor: primary,
                                    value: "bs",
                                    groupValue: groupValue,
                                    onChanged: (val) {
                                      setState(() {
                                        groupValue = val;
                                      });
                                    }),
                                Text(
                                  "Business",
                                  style: TextStyle(fontSize: 11.0),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Radio(
                                    activeColor: primary,
                                    value: "rs",
                                    groupValue: groupValue,
                                    onChanged: (val) {
                                      setState(() {
                                        groupValue = val;
                                      });
                                    }),
                                Text(
                                  "Residential",
                                  style: TextStyle(fontSize: 11.0),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Radio(
                                    activeColor: primary,
                                    value: "sp",
                                    groupValue: groupValue,
                                    onChanged: (val) {
                                      setState(() {
                                        groupValue = val;
                                      });
                                    }),
                                Text(
                                  "Special location",
                                  style: TextStyle(fontSize: 11.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        FloatingActionButton(
                          heroTag: 1,
                          backgroundColor: primary,
                          child: Icon(Icons.keyboard_arrow_right),
                          onPressed: () {
                            save();
                            Navigator.pushReplacementNamed(
                                context, '/pickup-services');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    read();
  }

  _openDialog(context, keyword) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Builder(
          builder: (context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return Container(
              height: height - 400,
              width: width - 100,
              child: GoogleAddress(selectedAddress: selected, keyword: keyword),
            );
          },
        ),
      ),
    ).then(
      (value) {},
    );
  }

  save() async {
    PickupAddress address = PickupAddress();
    address.country = country;
    address.state = state;
    address.city = city;
    address.zip = zip;
    address.street = street;
    address.street_number = street_number;
    address.location_type = groupValue;
    Store store = Store();
    store.save('src', address);
  }

  read() async {
    Store store = Store();
    var data = await store.read('src');
  }

  addressDetails(placeId) async {
    String placeDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    var res = await http.get(placeDetailsUrl);
    Map data = jsonDecode(res.body);

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
  }

  Future<List<Accessory>> _getAccessories() async {
    Accessories instance = Accessories("location-type");
    return instance.getData();
  }

  selected(selectedAddress) {
    setState(() {
      _addressController =
          TextEditingController(text: selectedAddress.description);
      addressDetails(selectedAddress.place_id);
    });
  }
}
