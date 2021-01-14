import 'package:flutter/material.dart';
import 'package:shipbay/models/additional_details_model.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:shipbay/pages/store/store.dart';

class AdditionalDetails extends StatefulWidget {
  @override
  _AdditionalDetailsState createState() => _AdditionalDetailsState();
}

class _AdditionalDetailsState extends State<AdditionalDetails> {
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
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Container(child: Progress(progress: 73.0)),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Additional details",
                        style: TextStyle(fontSize: 24.0, height: 2.0),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _estimatedCostController,
                        decoration: InputDecoration(
                            hintText: 'Estimated shipment value'),
                      ),
                      TextFormField(
                        controller: _instructionsController,
                        decoration: InputDecoration(hintText: 'Instructions'),
                      ),
                      SizedBox(height: 24.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Contacts: ",
                            style: TextStyle(fontSize: 16.0)),
                      ),
                      ExpansionTile(
                        title: Text("Pickup"),
                        children: <Widget>[
                          TextFormField(
                            controller: _pickupNameController,
                            decoration: InputDecoration(hintText: 'Name'),
                          ),
                          TextFormField(
                            controller: _pickupPhoneController,
                            decoration: InputDecoration(hintText: 'Phone'),
                          ),
                          TextFormField(
                            controller: _pickupEmailController,
                            decoration: InputDecoration(hintText: 'Email'),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        title: Text("Delivery"),
                        children: <Widget>[
                          TextFormField(
                            controller: _deliveryNameController,
                            decoration: InputDecoration(hintText: 'Name'),
                          ),
                          TextFormField(
                            controller: _deliveryPhoneController,
                            decoration: InputDecoration(hintText: 'Phone'),
                          ),
                          TextFormField(
                            controller: _deliveryEmailController,
                            decoration: InputDecoration(hintText: 'Email'),
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
                              Navigator.pushReplacementNamed(context, '/items');
                            },
                          ),
                          SizedBox(width: 16.0),
                          FloatingActionButton(
                            heroTag: 1,
                            backgroundColor: Colors.orange[900],
                            child: Icon(Icons.keyboard_arrow_right),
                            onPressed: () {
                              save();
                              Navigator.pushReplacementNamed(
                                  context, '/carriers');
                            },
                          ),
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
    read();
    super.initState();
  }

  read() async {
    Store store = Store();
    var data = await store.read('additional-details');
    print(".........................");
    print(data);
    setState(() {
      _estimatedCostController.text = data['estimated_cost'].toString();
      _instructionsController.text = data['instructions'];
      _pickupNameController.text = data['pickup_name'];
      _pickupPhoneController.text = data['pickup_phone'].toString();
      _pickupEmailController.text = data['pickup_email'];
      _deliveryNameController.text = data['delivery_name'];
      _deliveryPhoneController.text = data['delivery_phone'].toString();
      _deliveryEmailController.text = data['delivery_email'];
    });
  }

  save() {
    Store store = Store();
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
  }
}
