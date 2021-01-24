import 'package:flutter/material.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/services/settings.dart';
import 'package:shipbay/models/item_model.dart';
import 'package:shipbay/pages/shared/divider.dart';

class Confirmation extends StatefulWidget {
  @override
  _ConfirmationState createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  Store store = Store();
  //pickup details
  String _pickupAddress;
  String _pickupName;
  String _pickupEmail;
  String _pickupPhone;
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
  String _carrierName;
  double _price;
  //Billing details
  String _email;
  String _status;
  var _items = List<ItemModel>();
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
            Navigator.pushReplacementNamed(context, '/payment-details');
          },
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: _customStyle(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Pickup details",
                      style: TextStyle(fontWeight: FontWeight.bold)),
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
            padding: EdgeInsets.all(30.0),
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: _customStyle(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Delivery details",
                      style: TextStyle(fontWeight: FontWeight.bold)),
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
                  child: Text("Loading"),
                )
              : Container(
                  height: 200.0,
                  child: Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: _customStyle(context),
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: _items.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Text(_items[index].description),
                                  SizedBox(width: 20.0),
                                  Text(
                                      ": ${_items[index].weight.toString()} Pounds"),
                                ],
                              );
                            },
                          ),
                          DividerWidget(),
                          Text("Total weight: ${dw()} Pounds")
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    init();
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

  double dw() {
    double total = 0;
    for (int i = 0; i < _items.length; i++) {
      double sub = _items[i].weight * _items[i].number;
      total = total + sub;
    }
    return total;
  }

  init() async {
    var pickup = await store.read('pickup');
    var delivery = await store.read('delivery');
    var _savedItem = await store.read('items');
    var additionalDetails = await store.read('additional-details');

    setState(() {
      //pickup
      _pickupAddress = pickup['formatted_address'];
      _pickupName = additionalDetails['pickup_name'];
      _pickupPhone = additionalDetails['pickup_phone'].toString();
      _pickupEmail = additionalDetails['pickup_email'];
      //delivery
      _deliveryAddress = delivery['formatted_address'];
      _deliveryName = additionalDetails['delivery_name'];
      _deliveryPhone = additionalDetails['delivery_phone'].toString();
      _deliveryEmail = additionalDetails['delivery_email'];
      //item
      for (int i = 0; i < _savedItem.length; i++) {
        ItemModel _item = ItemModel();
        _item.description = _savedItem[i]['description'];
        _item.type = _savedItem[i]['type'];
        _item.length = _savedItem[i]['length'];
        _item.width = _savedItem[i]['width'];
        _item.height = _savedItem[i]['height'];
        _item.weight = _savedItem[i]['weight'];
        _item.number = _savedItem[i]['number'];
        _items.add(_item);
      }

      print("...............item................");
      print(_items[0].description);
    });
  }
}
