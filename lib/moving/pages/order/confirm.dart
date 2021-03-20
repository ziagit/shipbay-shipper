import 'package:flutter/material.dart';
import 'package:shipbay/moving/moving_menu.dart';
import 'package:shipbay/moving/moving_appbar.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'dart:convert';
import 'package:shipbay/moving/services/api.dart';

class Confirm extends StatefulWidget {
  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  Store store = Store();
  //pickup details
  var _from;
  var _fromType;
  var _fromState;
  //delivery details
  var _to;
  var _toType;
  var _toState;
  //contacts
  var _contacts;
  //Carrier details
  var _mover;
  //Billing details
  var _billing;
  //other information
  var _date;
  String _movingType;
  var _movingSize;
  var _officeSize;
  var _moverNumber;
  var _vehicle;
  var _supplies = List();
  bool _isSubmiting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MovingAppBar(''),
      drawer: MovingMenu(),
      body: ListView(
        children: [
          Center(
            child: Text(
              "Confirm the order",
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
                    child: Text("Frome",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: primary)),
                  ),
                  Row(
                    children: [
                      Text("Address: "),
                      SizedBox(width: 12.0),
                      Flexible(
                          child: Text(
                              _from == null ? '' : _from['formatted_address'])),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Location type: "),
                      SizedBox(width: 12.0),
                      Flexible(
                        child:
                            Text(_fromType == null ? '' : _fromType['title']),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("What will be used: "),
                      SizedBox(width: 12.0),
                      Text(
                        _fromState == null ? '' : _fromState['title'],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Stair: "),
                      SizedBox(width: 12.0),
                      Flexible(
                        child: Text(
                          _fromState == null ? '' : _fromState['floor'],
                        ),
                      ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "To",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: primary),
                    ),
                  ),
                  Row(
                    children: [
                      Text("Address: "),
                      SizedBox(width: 12.0),
                      Flexible(
                          child: Text(
                              _to == null ? '' : _to['formatted_address'])),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Location type: "),
                      SizedBox(width: 12.0),
                      Flexible(
                        child: Text(
                          _toType == null ? '' : _toType['title'],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("What will be used: "),
                      SizedBox(width: 12.0),
                      Text(_toState == null ? '' : _toState['title']),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Floor: "),
                      SizedBox(width: 12.0),
                      Flexible(
                          child:
                              Text(_toState == null ? '' : _toState['floor'])),
                    ],
                  ),
                ],
              ),
            ),
          ),
          (_supplies == null)
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
                              "Selected supplies",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: primary),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: _supplies.length,
                            itemBuilder: (context, index) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${_supplies == null ? '' : _supplies[index]['name']}: ${_supplies[index]['number']}",
                                ),
                              );
                            },
                          ),
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
                      "Contact details",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: primary),
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Name: ${_contacts == null ? '' : _contacts['name']}")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Phone: ${_contacts == null ? '' : _contacts['phone']}")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Email: ${_contacts == null ? '' : _contacts['email']}"))
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
                      "Mover details",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: primary),
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Name: ${_mover == null ? '' : _mover['last_name']}")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Company: ${_mover == null ? '' : _mover['company']}")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Price: \$${_mover == null ? '' : _mover['price']}"))
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
                      child: Text(
                          "Email: ${_billing == null ? '' : _billing['email']}")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Status: ${_billing == null ? '' : "Paid"}")),
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
                      "Other information",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: primary),
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child:
                          Text("Date: ${_date == null ? '' : _date['date']}")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child:
                          Text("Time: ${_date == null ? '' : _date['time']}")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Moving type: ${_movingType == null ? '' : _movingType}")),
                  _movingSize != null
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "Moving size: ${_movingSize == null ? '' : _movingSize['title']}"))
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "Moving size: ${_officeSize == null ? '' : _officeSize['title']}")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Number of requested movers: ${_moverNumber == null ? '' : _moverNumber['number']}")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Requested vehicle: ${_vehicle == null ? '' : _vehicle['name']}")),
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

  _init() async {
    var from = await store.read('from');
    var fromType = await store.read('from-location-type');
    var fromState = await store.read('from-state');
    var to = await store.read('to');
    var toType = await store.read('to-location-type');
    var toState = await store.read('to-state');
    var date = await store.read('moving-date');
    var movingSize = await store.read('moving-size');
    var officeSize = await store.read('office-size');
    var moverNumbers = await store.read('number-of-movers');
    var vehicle = await store.read('vehicle');
    var supplies = await store.read('supplies');
    var movingType = await store.read('type');
    var mover = await store.read('mover');
    var billing = await store.read('billing');
    var contacts = await store.read('contacts');
    setState(
      () {
        _movingType = movingType;
        _from = from;
        _fromType = fromType;
        _fromState = fromState;
        _to = to;
        _toType = toType;
        _toState = toState;
        _contacts = contacts;
        _date = date;
        _billing = billing;
        _mover = mover;
        _moverNumber = moverNumbers;
        _vehicle = vehicle;
        _movingSize = movingSize;
        _officeSize = officeSize;
        for (int i = 0; i < supplies.length; i++) {
          if (supplies[i]['number'] is String) {
            _supplies.add(supplies[i]);
            print(supplies[i]);
          }
        }
      },
    );
  }

  void _submit(context) async {
    setState(() {
      _isSubmiting = true;
    });
    String _token = await store.read('token');
    try {
      var response = await confirm(
          jsonEncode(
            <String, Object>{
              "billing": {
                "id": _billing['orderId'],
                "email": _billing['email'],
                "status": _billing['status']
              },
              "carrier": _mover,
              "contacts": _contacts,
              "from": {
                "city": _from['city'],
                "country": _from['country'],
                "formatted_address": _from['formatted_address'],
                "state": _from['state'],
                "street": _from['street'],
                "street_number": _from['street_number'],
                "zip": _from['zip'],
                "type": _fromType,
                "from_state": _fromState
              },
              "moving_size": _movingSize,
              "office_size": _officeSize,
              "moving_date": _date,
              "number_of_movers": _moverNumber,
              "to": {
                "city": _to['city'],
                "country": _to['country'],
                "formatted_address": _to['formatted_address'],
                "state": _to['state'],
                "street": _to['street'],
                "street_number": _to['street_number'],
                "zip": _to['zip'],
                "type": _toType,
                "to_state": _toState
              },
              "supplies": _supplies,
              "type": _movingType,
              "vehicle": _vehicle
            },
          ),
          _token,
          'moving/confirm');
      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        //clean the store
        print("order creaded successfully!...");
        print(jsonData);
        store.removeMovingOrder();
        Navigator.pushReplacementNamed(context, '/completed');
      } else {
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
}
