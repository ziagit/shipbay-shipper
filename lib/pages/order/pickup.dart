import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shipbay/models/accessory.dart';
import 'package:shipbay/models/pickup_address_model.dart';
import 'package:shipbay/pages/shared/google_address.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/services/settings.dart';
import 'package:shipbay/services/api.dart';
import 'dart:async';

class Pickup extends StatefulWidget {
  @override
  _PickupState createState() => _PickupState();
}

class _PickupState extends State<Pickup> {
  TextEditingController _addressController = TextEditingController();
  String groupValue = 'bs';

  String country;
  String state;
  String city;
  String zip;
  String street;
  String street_number;
  String formatted_address;

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
    read();
    super.initState();
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
    PickupAddressModel pickupAddressModel = PickupAddressModel();
    Store store = Store();
    pickupAddressModel.country = country;
    pickupAddressModel.state = state;
    pickupAddressModel.city = city;
    pickupAddressModel.zip = zip;
    pickupAddressModel.street = street;
    pickupAddressModel.street_number = street_number;
    pickupAddressModel.formatted_address = formatted_address;
    pickupAddressModel.location_type = groupValue;
    await store.save('pickup', pickupAddressModel);
  }

  read() async {
    Store store = Store();
    var data = await store.read('pickup');
    if (data != null) {
      setState(() {
        country = data['country'];
        state = data['state'];
        city = data['city'];
        zip = data['zip'];
        street = data['street'];
        street_number = data['street_number'];
        groupValue =
            (data['location_type'] == null) ? 'bs' : data['location_type'];
        formatted_address = data['formatted_address'];
        _addressController.text = data['formatted_address'];
      });
    }
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
    formatted_address = data['result']['formatted_address'];
  }

  Future<List<Accessory>> _getAccessories() async {
    Accessories instance = Accessories("location-type");
    return instance.getData();
  }

  selected(selectedAddress) {
    if (selectedAddress.description != null) {
      setState(() {
        _addressController.text = selectedAddress.description;
        addressDetails(selectedAddress.place_id);
      });
    }
  }
}
