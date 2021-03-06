import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:shipbay/shipping/models/pickup_address_model.dart';
import 'package:shipbay/shared/components/google_address.dart';
import 'package:shipbay/shipping/shipping_appbar.dart';
import 'package:shipbay/shipping/shipping_menu.dart';
import 'package:shipbay/shared/components/progress.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shipping/services/api.dart';
import 'package:shipbay/shared/services/settings.dart';

class Pickup extends StatefulWidget {
  @override
  _PickupState createState() => _PickupState();
}

class _PickupState extends State<Pickup> {
  Store store = Store();
  String groupValue = 'bs';
  List types;
  TextEditingController _addressController = TextEditingController();

  String country;
  String state;
  String city;
  String zip;
  String street;
  String street_number;
  String formatted_address;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: primary));
    return Scaffold(
      key: _scaffoldKey,
      appBar: ShippingAppBar(''),
      drawer: ShippingMenu(),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                SizedBox(child: Progress(progress: 0.0)),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Shipping from?",
                        style: TextStyle(fontSize: 22.0, height: 2.0),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(hintText: 'Postal code'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a valid address';
                          }
                          return null;
                        },
                        onChanged: (keyword) {
                          _openDialog(context, keyword);
                        },
                      ),
                      SizedBox(height: 16.0),
                      types == null
                          ? Container(
                              child: Text("Loading..."),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: types.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: <Widget>[
                                    Radio(
                                        activeColor: primary,
                                        value: "${types[index]['code']}",
                                        groupValue: groupValue,
                                        onChanged: (val) {
                                          setState(() {
                                            groupValue = val;
                                          });
                                        }),
                                    Text(
                                      "${types[index]['name']}",
                                      style: TextStyle(fontSize: 11.0),
                                    ),
                                  ],
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: inActive,
              foregroundColor: primary,
              heroTag: "btn",
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Icon(Icons.keyboard_arrow_left),
            ),
            SizedBox(
              width: 40,
            ),
            FloatingActionButton(
              backgroundColor: primary,
              heroTag: "btn2",
              onPressed: () {
                _next(context);
              },
              child: Icon(Icons.keyboard_arrow_right),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getLocationType();
    _init();
  }

  void _openDialog(context, keyword) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
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
      (value) {
        print(value);
      },
    );
  }

  _next(context) async {
    PickupAddressModel pickupAddressModel = PickupAddressModel();
    pickupAddressModel.country = country;
    pickupAddressModel.state = state;
    pickupAddressModel.city = city;
    pickupAddressModel.zip = zip;
    pickupAddressModel.street = street;
    pickupAddressModel.street_number = street_number;
    pickupAddressModel.formatted_address = formatted_address;
    pickupAddressModel.location_type = groupValue;
    if (pickupAddressModel.country == null ||
        pickupAddressModel.state == null ||
        pickupAddressModel.city == null ||
        pickupAddressModel.zip == null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please select a valid address!'),
      ));
    } else if (pickupAddressModel.state != 'BC') {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "'${pickupAddressModel.state}' is not in our courage yet!",
          style: TextStyle(color: Colors.red),
        ),
      ));
    } else {
      await store.save('pickup', pickupAddressModel);
      Navigator.pushReplacementNamed(context, '/pickup-services');
    }
  }

  _init() async {
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
    String placeDetailsUrl = "$googleDetails?place_id=$placeId&key=$mapKey";
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

  selected(selectedAddress) {
    if (selectedAddress.description != null) {
      setState(() {
        _addressController.text = selectedAddress.description;
        addressDetails(selectedAddress.place_id);
      });
    }
  }

  _getLocationType() async {
    List response = await getAccessory('shipping/location-type');
    setState(() {
      types = response;
    });
  }
}
