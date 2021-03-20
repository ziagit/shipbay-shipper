import 'package:flutter/material.dart';
import 'package:shipbay/shipping/shipping_appbar.dart';
import 'package:shipbay/shipping/shipping_menu.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shipping/models/item_model.dart';
import 'package:shipbay/shared/components/divider.dart';
import 'dart:convert';
import 'package:shipbay/shipping/services/api.dart';

class Confirmation extends StatefulWidget {
  @override
  _ConfirmationState createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  Store store = Store();
  Map order = {};
  //pickup details
  String _pickupAddress;
  String _pickupName;
  String _pickupEmail;
  String _pickupPhone;
  String _instructions;
  //delivery details
  String _deliveryAddress;
  String _deliveryName;
  String _deliveryEmail;
  String _deliveryPhone;
  //Item details
  String _itemDescript;
  String _totalWeight;
  double _estimationCost;
  //Carrier details
  int _carrierId;
  String _carrierName;
  String _carrierCompany;
  double _carrierPrice;
  //Billing details
  String _email;
  String _status;
  String _orderId;
  var _items = List<ItemModel>();
  bool _isSubmiting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ShippingAppBar(''),
      drawer: ShippingMenu(),
      body: ListView(
        children: [
          Center(
            child: Text(
              "Confirmation",
              style: TextStyle(fontSize: 22.0, height: 2.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: _customStyle(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Pickup details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: primary)),
                  ),
                  Row(
                    children: [
                      Text("Name: "),
                      SizedBox(width: 12.0),
                      Flexible(
                          child: Text(_pickupName == null ? '' : _pickupName)),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Email: "),
                      SizedBox(width: 12.0),
                      Flexible(
                          child:
                              Text(_pickupEmail == null ? '' : _pickupEmail)),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Phone: "),
                      SizedBox(width: 12.0),
                      Text(_pickupPhone == null ? '' : _pickupPhone),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Address: "),
                      SizedBox(width: 12.0),
                      Flexible(
                          child: Text(
                              _pickupAddress == null ? '' : _pickupAddress)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: _customStyle(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Delivery details",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: primary),
                    ),
                  ),
                  Row(
                    children: [
                      Text("Name: "),
                      SizedBox(width: 12.0),
                      Flexible(
                          child:
                              Text(_deliveryName == null ? '' : _deliveryName)),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Email: "),
                      SizedBox(width: 12.0),
                      Flexible(
                          child: Text(
                              _deliveryEmail == null ? '' : _deliveryEmail)),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Phone: "),
                      SizedBox(width: 12.0),
                      Text(_deliveryPhone == null ? '' : _deliveryPhone),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Address: "),
                      SizedBox(width: 12.0),
                      Flexible(
                          child: Text(_deliveryAddress == null
                              ? ''
                              : _deliveryAddress)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          (_items == null)
              ? Container(
                  child: SizedBox(
                  height: 30.0,
                  width: 30.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(primary),
                  ),
                ))
              : Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: _customStyle(context),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Item details",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: primary),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: _items.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        "${_items[index].description}: ${_items[index].weight.toString()} Pounds"),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        "Numbers: ${_items[index].number.toString()}"),
                                  )
                                ],
                              );
                            },
                          ),
                          DividerWidget(),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Total weight: ${dw()} Pounds"))
                        ],
                      ),
                    ),
                  ),
                ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: _customStyle(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Carrier details",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: primary),
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Name: $_carrierName")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Company: $_carrierCompany")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Price: $_carrierPrice"))
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: _customStyle(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Billing details",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: primary),
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Email: $_email")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Status: $_status")),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.grey.shade200,
                    offset: new Offset(0.0, 10.0),
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                  )
                ],
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "By clicking on submit you will agree to our terms and conditions",
                        style: TextStyle(fontSize: 12.0)),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FlatButton(
                      onPressed: () {
                        //
                      },
                      child: Text(
                        "Read more...",
                        style: TextStyle(color: Colors.blue, fontSize: 12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _isSubmiting
              ? Container(
                  padding: EdgeInsets.all(20.0),
                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(primary),
                    backgroundColor: Colors.grey[300],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 46.0,
                    child: RaisedButton(
                      color: primary,
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        _submit(context);
                      },
                    ),
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

  double dw() {
    double total = 0;
    for (int i = 0; i < _items.length; i++) {
      double sub = _items[i].weight * _items[i].number;
      total = total + sub;
    }
    return total;
  }

  void _submit(context) async {
    String _token = await store.read('token');
    setState(() {
      _isSubmiting = true;
    });
    try {
      var response = await confirm(
          jsonEncode(
            <String, Object>{
              "id": _orderId,
              "billing": {"email": _email, "status": _status},
              "carrier": {
                "id": _carrierId,
                "name": _carrierName,
                "price": _carrierPrice
              },
              "src": order['src'],
              "pickDate": order['pickDate'],
              "des": order['des'],
              "myItem": order['myItem'],
              "shipper": {
                "deliveryEmail": _deliveryEmail,
                "deliveryName": _deliveryName,
                "deliveryPhone": _deliveryPhone,
                "estimatedValue": _estimationCost,
                "instructions": _instructions,
                "pickupEmail": _pickupEmail,
                "pickupName": _pickupName,
                "pickupPhone": _pickupPhone
              }
            },
          ),
          _token);
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        //clean the store
        print("order creaded successfully!...");
        print(jsonData);
        store.removeOrder();
        Navigator.pushReplacementNamed(context, '/completed');
      } else {
        print("oh! something is wront......");
        print(jsonData['error']['message']);
        setState(() {
          _isSubmiting = false;
        });
      }
    } catch (err) {
      setState(() {
        _isSubmiting = false;
      });
      print("..............Something is wrong.................");
      print('err: ${err.toString()}');
    }
    return null;
  }

  _init() async {
    var pickupServices = await store.read('pickup-services');
    var deliveryServices = await store.read('delivery-services');
    var pickupDate = await store.read('pickup-date');
    var deliveryAppointmentTime = await store.read('delivery-appointment-time');
    var itemConditions = await store.read('item-condition');
    var itemTemperature = await store.read('temperature');

    var pickup = await store.read('pickup');
    var delivery = await store.read('delivery');
    var savedItem = await store.read('items');
    var carrier = await store.read('carrier');
    var billing = await store.read('billing');
    var additionalDetails = await store.read('additional-details');

    setState(
      () {
        //pickup
        _pickupAddress = pickup['formatted_address'];
        _pickupName = additionalDetails['pickup_name'];
        _pickupPhone = additionalDetails['pickup_phone'].toString();
        _pickupEmail = additionalDetails['pickup_email'];
        _instructions = additionalDetails['instructions'];
        _estimationCost = additionalDetails['estimated_cost'];
        //delivery
        _deliveryAddress = delivery['formatted_address'];
        _deliveryName = additionalDetails['delivery_name'];
        _deliveryPhone = additionalDetails['delivery_phone'].toString();
        _deliveryEmail = additionalDetails['delivery_email'];
        //item
        for (int i = 0; i < savedItem.length; i++) {
          ItemModel _item = ItemModel();
          _item.description = savedItem[i]['description'];
          _item.type = savedItem[i]['type'];
          _item.length = savedItem[i]['length'];
          _item.width = savedItem[i]['width'];
          _item.height = savedItem[i]['height'];
          _item.weight = savedItem[i]['weight'];
          _item.number = savedItem[i]['number'];
          _items.add(_item);
        }
        //carrier
        _carrierId = carrier['id'];
        _carrierName = carrier['last_name'];
        _carrierCompany = carrier['company'];
        _carrierPrice = carrier['price'];
        //billing
        _email = billing['email'];
        _status = billing['status'];
        _orderId = billing['orderId'];
      },
    );
    order['src'] = pickup;
    order['src']['accessories'] = [];
    order['src']['accessories'].add(pickup['location_type']);
    for (int i = 0; i < pickupServices.length; i++) {
      order['src']['accessories'].add(pickupServices[i]);
    }
    if (pickupDate['time'] != null) {
      order['src']['accessories'].add('ap');
    }
    order['src']['appointmentTime'] = pickupDate['time'];
    order['pickDate'] = pickupDate['date'];

    order['des'] = delivery;
    order['des']['accessories'] = [];
    order['des']['accessories'].add(delivery['location_type']);
    for (int i = 0; i < deliveryServices.length; i++) {
      order['des']['accessories'].add(deliveryServices[i]);
    }
    order['des']['appointmentTime'] = deliveryAppointmentTime;
    order['myItem'] = {};
    order['myItem']['items'] = savedItem;
    order['myItem']['conditions'] = [];
    for (int i = 0; i < itemConditions.length; i++) {
      order['myItem']['conditions'].add(itemConditions[i]);
    }
    order['myItem']['maxTemp'] =
        itemTemperature == null ? null : itemTemperature['max_temp'];
    order['myItem']['minTemp'] =
        itemTemperature == null ? null : itemTemperature['min_temp'];
  }
}
