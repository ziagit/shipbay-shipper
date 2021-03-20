import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shipbay/moving/models/from_address_model.dart';
import 'package:shipbay/moving/moving_menu.dart';
import 'package:shipbay/moving/services/api.dart';
import 'package:shipbay/moving/moving_appbar.dart';
import 'package:shipbay/shared/components/google_address.dart';
import 'package:shipbay/shared/components/progress.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/settings.dart';

class From extends StatefulWidget {
  @override
  _FromState createState() => _FromState();
}

class _FromState extends State<From> {
  Store store = Store();
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
      appBar: MovingAppBar(''),
      drawer: MovingMenu(),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                SizedBox(child: Progress(progress: 5.0)),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Moving from?",
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
                      SizedBox(height: 20.0),
                      Text("Location types"),
                      types == null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Loading"),
                                JumpingDotsProgressIndicator(
                                  fontSize: 20.0,
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: types.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          50, 10, 50, 10),
                                      child: SizedBox(
                                        width: 200,
                                        height: 46.0,
                                        child: RaisedButton(
                                            color: primary,
                                            child: Text(
                                              "${types[index]['title']}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.0)),
                                            onPressed: () {
                                              _next(context, types[index]);
                                            }),
                                      ),
                                    );
                                  },
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 10, 50, 10),
                                  child: SizedBox(
                                    width: 300,
                                    height: 46.0,
                                    child: RaisedButton(
                                      child: Text(
                                        "Back",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: primary),
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                            context, '/moving');
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
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

  _next(context, type) async {
    FromAddressModel fromAddressModel = FromAddressModel();
    fromAddressModel.country = country;
    fromAddressModel.state = state;
    fromAddressModel.city = city;
    fromAddressModel.zip = zip;
    fromAddressModel.street = street;
    fromAddressModel.street_number = street_number;
    fromAddressModel.formatted_address = formatted_address;
    if (fromAddressModel.country == null ||
        fromAddressModel.state == null ||
        fromAddressModel.city == null ||
        fromAddressModel.zip == null ||
        fromAddressModel.formatted_address == null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please select a valid address!'),
      ));
    } else if (fromAddressModel.state != 'BC') {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "'${fromAddressModel.state}' is not in our courage yet!",
          style: TextStyle(color: Colors.red),
        ),
      ));
    } else {
      await store.save('from', fromAddressModel);
      await store.save('from-location-type', type);
      if (type['code'] == 'apartment') {
        Navigator.pushReplacementNamed(context, '/from-state');
      } else {
        await store.remove("from-state");
        Navigator.pushReplacementNamed(context, '/to');
      }
    }
  }

  _init() async {
    var data = await store.read('from');
    if (data != null) {
      setState(() {
        country = data['country'];
        state = data['state'];
        city = data['city'];
        zip = data['zip'];
        street = data['street'];
        street_number = data['street_number'];
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
    List response = await getData('moving/location-types');
    print(response);
    setState(() {
      types = response;
    });
  }
}
