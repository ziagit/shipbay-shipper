import 'package:flutter/material.dart';
import 'package:shipbay/models/accessory.dart';
import 'package:shipbay/models/delivery_address_model.dart';
import 'package:shipbay/pages/shared/custom_appbar.dart';
import 'package:shipbay/pages/shared/google_address.dart';
import 'package:shipbay/pages/shared/main_menu.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/pages/tracking/tracking.dart';
import 'package:shipbay/services/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shipbay/services/settings.dart';

class Delivery extends StatefulWidget {
  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  TextEditingController _addressController = TextEditingController();
  String groupValue = 'bs';
  List types;
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(''),
      drawer: MainMenu(),
      endDrawer: Tracking(),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Container(child: Progress(progress: 36.0)),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Delivery address",
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
                Navigator.pushReplacementNamed(context, '/pickup-date');
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
                if (_formKey.currentState.validate()) {
                  _next(context);
                }
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
    _init();
    _getLocationType();
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

  _next(context) async {
    DeliveryAddressModel deliveryAddressModel = DeliveryAddressModel();
    Store store = Store();
    deliveryAddressModel.country = country;
    deliveryAddressModel.state = state;
    deliveryAddressModel.city = city;
    deliveryAddressModel.zip = zip;
    deliveryAddressModel.street = street;
    deliveryAddressModel.street_number = street_number;
    deliveryAddressModel.formatted_address = formatted_address;
    deliveryAddressModel.location_type = groupValue;
    if (deliveryAddressModel.country == null ||
        deliveryAddressModel.state == null ||
        deliveryAddressModel.city == null ||
        deliveryAddressModel.zip == null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please select a valid address!'),
      ));
    } else {
      await store.save('delivery', deliveryAddressModel);
      Navigator.pushReplacementNamed(context, '/delivery-services');
    }
  }

  _init() async {
    Store store = Store();
    var data = await store.read('delivery');
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

  selected(selectedAddress) {
    if (selectedAddress.description != null) {
      setState(() {
        _addressController.text = selectedAddress.description;
        addressDetails(selectedAddress.place_id);
      });
    }
  }

  _getLocationType() async {
    List response = await getLocationType();
    setState(() {
      types = response;
    });
  }
}
