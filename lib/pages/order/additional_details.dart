import 'package:flutter/material.dart';
import 'package:shipbay/models/additional_details_model.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:shipbay/pages/store/store.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xF8FAF8),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/items');
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Container(child: Progress(progress: 73.0)),
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
                          controller: _estimatedCostController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid value';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Estimated shipment value'),
                        ),
                        TextFormField(
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
                                  return 'Please enter a valid name';
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
                                  return 'Please enter a valid phone number';
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
                                  return 'Please enter a valid email';
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
                                  return 'Please enter a valid name';
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
                                  return 'Please enter a valid phone number';
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
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 24.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: 0,
                              backgroundColor: Colors.orange[50],
                              foregroundColor: Colors.orange[900],
                              child: Icon(Icons.keyboard_arrow_left),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/items');
                              },
                            ),
                            SizedBox(width: 16.0),
                            FloatingActionButton(
                              heroTag: 1,
                              backgroundColor: Colors.orange[900],
                              child: Icon(Icons.keyboard_arrow_right),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _next(context);
                                }
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
    );
  }

  @override
  void initState() {
    _init();
    super.initState();
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
    store.save('additional-details', additionalDetailsModel);
    Navigator.pushReplacementNamed(context, '/carriers');
  }
}
