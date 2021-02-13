import 'package:flutter/material.dart';
import 'package:shipbay/models/additional_details_model.dart';
import 'package:shipbay/pages/shared/custom_appbar.dart';
import 'package:shipbay/pages/shared/main_menu.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/pages/tracking/tracking.dart';
import 'package:shipbay/services/settings.dart';

class AdditionalDetails extends StatefulWidget {
  @override
  _AdditionalDetailsState createState() => _AdditionalDetailsState();
}

class _AdditionalDetailsState extends State<AdditionalDetails> {
  Store store = Store();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _estimatedCostController = TextEditingController();
  TextEditingController _instructionsController = TextEditingController();
  TextEditingController _pickupNameController = TextEditingController();
  TextEditingController _pickupPhoneController = TextEditingController();
  TextEditingController _pickupEmailController = TextEditingController();
  TextEditingController _deliveryNameController = TextEditingController();
  TextEditingController _deliveryPhoneController = TextEditingController();
  TextEditingController _deliveryEmailController = TextEditingController();
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
                Container(child: Progress(progress: 65.0)),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Additional details",
                          style: TextStyle(fontSize: 22.0, height: 2.0),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          style: TextStyle(fontSize: 14.0),
                          controller: _estimatedCostController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid value';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Estimated shipment value(\$)'),
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 14.0),
                          controller: _instructionsController,
                          decoration:
                              InputDecoration(labelText: 'Instructions'),
                        ),
                        SizedBox(height: 24.0),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Contacts: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        ExpansionTile(
                          title: Text("Pickup"),
                          children: <Widget>[
                            TextFormField(
                              controller: _pickupNameController,
                              style: TextStyle(fontSize: 12.0),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return validate(
                                      'Please enter a valid name for pickup!');
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Name',
                              ),
                            ),
                            TextFormField(
                              controller: _pickupPhoneController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(labelText: 'Phone'),
                              style: TextStyle(fontSize: 12.0),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return validate(
                                      'Please enter a valid phone number for pickup!');
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _pickupEmailController,
                              decoration: InputDecoration(labelText: 'Email'),
                              style: TextStyle(fontSize: 12.0),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return validate(
                                      'Please enter a valid email for pickup!');
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text("Delivery"),
                          children: <Widget>[
                            TextFormField(
                              controller: _deliveryNameController,
                              decoration: InputDecoration(labelText: 'Name'),
                              style: TextStyle(fontSize: 12.0),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return validate(
                                      'Please enter a valid name for delivery!');
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _deliveryPhoneController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(labelText: 'Phone'),
                              style: TextStyle(fontSize: 12.0),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return validate(
                                      'Please enter a valid phone number for delivery!');
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _deliveryEmailController,
                              decoration: InputDecoration(labelText: 'Email'),
                              style: TextStyle(fontSize: 12.0),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return validate(
                                      'Please enter a valid email for delivery!');
                                }
                                return null;
                              },
                            ),
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
                Navigator.pushReplacementNamed(context, '/items');
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
    _init();
    super.initState();
  }

  validate(value) {
    return _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  _init() async {
    var data = await store.read('additional-details');
    setState(() {
      if (data != null) {
        _estimatedCostController.text = data['estimated_cost'].toString();
        _instructionsController.text = data['instructions'];
        _pickupNameController.text = data['pickup_name'];
        _pickupPhoneController.text = data['pickup_phone'].toString();
        _pickupEmailController.text = data['pickup_email'];
        _deliveryNameController.text = data['delivery_name'];
        _deliveryPhoneController.text = data['delivery_phone'].toString();
        _deliveryEmailController.text = data['delivery_email'];
      }
    });
  }

  _next(context) {
    AdditionalDetailsModel additionalDetailsModel = AdditionalDetailsModel();
    additionalDetailsModel.estimated_cost =
        double.parse(_estimatedCostController.text);
    additionalDetailsModel.instructions = _instructionsController.text;
    additionalDetailsModel.pickup_name = _pickupNameController.text;
    additionalDetailsModel.pickup_phone =
        int.parse(_pickupPhoneController.text);
    additionalDetailsModel.pickup_email = _pickupEmailController.text;
    additionalDetailsModel.delivery_name = _deliveryNameController.text;
    additionalDetailsModel.delivery_phone =
        int.parse(_deliveryPhoneController.text);
    additionalDetailsModel.delivery_email = _deliveryEmailController.text;
    if (additionalDetailsModel.estimated_cost == null ||
        additionalDetailsModel.pickup_name == null ||
        additionalDetailsModel.pickup_email == null ||
        additionalDetailsModel.pickup_phone == null ||
        additionalDetailsModel.delivery_name == null ||
        additionalDetailsModel.delivery_email == null ||
        additionalDetailsModel.delivery_phone == null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please provide a valid contact information!"),
      ));
    }
    store.save('additional-details', additionalDetailsModel);
    Navigator.pushReplacementNamed(context, '/carriers');
  }
}
