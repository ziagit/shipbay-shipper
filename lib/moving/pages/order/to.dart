import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shipbay/moving/models/to_address_model.dart';
import 'package:shipbay/moving/moving_menu.dart';
import 'package:shipbay/moving/services/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shipbay/moving/moving_appbar.dart';
import 'package:shipbay/shared/components/google_address.dart';
import 'package:shipbay/shared/components/progress.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/settings.dart';

class To extends StatefulWidget {
  @override
  _ToState createState() => _ToState();
}

class _ToState extends State<To> {
  Store store = Store();
  TextEditingController _addressController = TextEditingController();
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
      appBar: MovingAppBar(''),
      drawer: MovingMenu(),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Container(child: Progress(progress: 12.0)),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Moving to",
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
                        Text("Location type"),
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
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          30.0)),
                                              onPressed: () {
                                                _next(context, types[index]);
                                              }),
                                        ),
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        50, 10, 50, 10),
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
                                              new BorderRadius.circular(30.0),
                                        ),
                                        onPressed: () async {
                                          _back(context);
                                        },
                                      ),
                                    ),
                                  )
                                ],
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

  _next(context, type) async {
    ToAddressModel toAddressModel = ToAddressModel();
    toAddressModel.country = country;
    toAddressModel.state = state;
    toAddressModel.city = city;
    toAddressModel.zip = zip;
    toAddressModel.street = street;
    toAddressModel.street_number = street_number;
    toAddressModel.formatted_address = formatted_address;
    if (toAddressModel.country == null ||
        toAddressModel.state == null ||
        toAddressModel.city == null ||
        toAddressModel.zip == null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please select a valid address!'),
      ));
    } else if (toAddressModel.state != 'BC') {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "'${toAddressModel.state}' is not in our courage yet!",
          style: TextStyle(color: Colors.red),
        ),
      ));
    } else {
      await store.save('to', toAddressModel);
      await store.save('to-location-type', type);
      if (type['code'] == 'apartment') {
        Navigator.pushReplacementNamed(context, '/to-state');
      } else {
        await store.remove("to-state");
        if (await store.read("type") == "office") {
          Navigator.pushReplacementNamed(context, '/office-sizes');
        } else {
          Navigator.pushReplacementNamed(context, '/moving-sizes');
        }
      }
    }
  }

  _back(context) async {
    if (await store.read('from-state') != null) {
      Navigator.pushReplacementNamed(context, '/from-state');
    } else {
      Navigator.pushReplacementNamed(context, '/from');
    }
  }

  _init() async {
    var data = await store.read('to');
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
    setState(() {
      types = response;
    });
  }
}
