import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shipbay/models/shipper_model.dart';
import 'package:shipbay/pages/shared/main_menu.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/services/settings.dart';
import 'package:shipbay/services/api.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Store store = Store();
  var shipper;
  @override
  Widget build(BuildContext context) {
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
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.edit,
                color: primary,
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      drawer: MainMenu(),
      body: Container(
        child: shipper == null
            ? Container(
                child: Center(child: Text("No shipper")),
              )
            : Column(
                children: [
                  Container(
                    height: 180.0,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          width: 80.0,
                          height: 80.0,
                          margin: EdgeInsets.only(top: 10.0),
                          child: CircleAvatar(
                            radius: 25.0,
                            child: Text(shipper['last_name'][0].toUpperCase(),
                                style: TextStyle(
                                    fontSize: 26.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            backgroundColor: primary,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(shipper['last_name'],
                            style: TextStyle(
                                color: primary,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.0),
                        Text(shipper['first_name'],
                            style: TextStyle(color: fontColor, fontSize: 12.0)),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: _customStyle(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                "${shipper['full_address']['street']}, ${shipper['full_address']['street_number']}",
                                style:
                                    TextStyle(color: primary, fontSize: 18.0)),
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${shipper['full_address']['city']}, ${shipper['full_address']['state']}, ${shipper['full_address']['zip']}",
                                style:
                                    TextStyle(color: fontColor, fontSize: 12.0),
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${shipper['full_address']['country']['name']}",
                                style:
                                    TextStyle(color: fontColor, fontSize: 12.0),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: _customStyle(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("${shipper['contact']['name']}",
                                style:
                                    TextStyle(color: primary, fontSize: 18.0)),
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${shipper['contact']['phone']}",
                                style:
                                    TextStyle(color: fontColor, fontSize: 12.0),
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${shipper['contact']['email']}",
                                style:
                                    TextStyle(color: fontColor, fontSize: 12.0),
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  @override
  void initState() {
    _get();
    super.initState();
  }

  Decoration _customStyle(context) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        new BoxShadow(
          color: Colors.grey.shade200,
          offset: new Offset(0.0, 10.0),
          blurRadius: 10.0,
          spreadRadius: 1.0,
        )
      ],
    );
  }

  _get() async {
    var token = await store.read('token');
    var data = await getProfile(token);
    if (data.length != 0) {
      setState(() {
        shipper = data;
      });
    } else {
      _openDialog();
    }
  }

  _openDialog() {
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
                height: height - 400, width: width - 100, child: AddShipper());
          },
        ),
      ),
    ).then((value) {
      _get();
    });
  }
}

class AddShipper extends StatefulWidget {
  @override
  _AddShipperState createState() => _AddShipperState();
}

class _AddShipperState extends State<AddShipper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Store store = Store();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _zipController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressIdController = TextEditingController();
  TextEditingController _contactIdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 16.0),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(labelText: 'First name'),
                    style: TextStyle(fontSize: 12.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid name';
                      }
                      return null;
                    },
                  ),
                ),
                Flexible(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(labelText: 'Last name'),
                    style: TextStyle(fontSize: 12.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a valid name';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: TextFormField(
                    controller: _countryController,
                    decoration: InputDecoration(labelText: 'Country'),
                    style: TextStyle(fontSize: 12.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter a valid country';
                      }
                      return null;
                    },
                  ),
                ),
                Flexible(
                  child: TextFormField(
                    controller: _stateController,
                    decoration: InputDecoration(labelText: 'State'),
                    style: TextStyle(fontSize: 12.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter a valid state';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(hintText: 'City'),
                    style: TextStyle(fontSize: 12.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter a valid city';
                      }
                      return null;
                    },
                  ),
                ),
                Flexible(
                  child: TextFormField(
                    controller: _zipController,
                    decoration: InputDecoration(hintText: 'Zip'),
                    style: TextStyle(fontSize: 12.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter a valid zip';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(hintText: 'Address'),
                    style: TextStyle(fontSize: 12.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter a valid address';
                      }
                      return null;
                    },
                  ),
                ),
                Flexible(
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Phone'),
                    style: TextStyle(fontSize: 12.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter a valid phone';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            FlatButton(
                child: Text(
                  "Save",
                  style: TextStyle(color: primary),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _save();
                  }
                })
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  _save() async {
    var token = await store.read('token');
    var response = await save({
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
      "country": 1.toString(),
      "state": _stateController.text,
      "city": _cityController.text,
      "zip": _zipController.text,
      "address": _addressController.text,
      "phone": _phoneController.text
    }, token);
    if (response['errors'] != null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Please provide valid data")),
      );
    } else {
      Navigator.pop(context);
    }
  }
}
