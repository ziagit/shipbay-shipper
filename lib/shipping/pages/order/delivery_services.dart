import 'package:flutter/material.dart';
import 'package:shipbay/shipping/shipping_appbar.dart';
import 'package:shipbay/shipping/shipping_menu.dart';
import 'package:shipbay/shared/components/progress.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shipping/services/api.dart';

class DeliveryServices extends StatefulWidget {
  @override
  _DeliveryServicesState createState() => _DeliveryServicesState();
}

class _DeliveryServicesState extends State<DeliveryServices> {
  TextEditingController _timeController = TextEditingController();
  List _selectedServices = List();
  List<dynamic> _services;
  bool _isAppointment = false;
  TimeOfDay _time = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: ShippingAppBar(''),
      drawer: ShippingMenu(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Container(child: Progress(progress: 45.0)),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Delivery services",
                          style: TextStyle(fontSize: 22.0, height: 2.0),
                        ),
                        SizedBox(height: 16.0),
                        _services == null
                            ? Container(
                                child: Text("Loading..."),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: _services.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CheckboxListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    activeColor: primary,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    value: _selectedServices
                                        .contains(_services[index]['code']),
                                    onChanged: (bool selected) {
                                      _onServiceSelected(
                                          selected, _services[index]['code']);
                                    },
                                    title: Text(
                                      _services[index]['name'],
                                      style: TextStyle(fontSize: 11.0),
                                    ),
                                  );
                                }),
                        Visibility(
                          visible: _isAppointment,
                          child: TextFormField(
                            style: TextStyle(fontSize: 14.0),
                            decoration:
                                InputDecoration(labelText: 'Select time'),
                            controller: _timeController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Time is required!';
                              }
                              return null;
                            },
                            onTap: () {
                              _selectTime(context);
                            },
                          ),
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
                Navigator.pushReplacementNamed(context, '/delivery');
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
                _next(context);
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
    _getDeliveryServices();
    _init();
  }

  Future<Null> _selectTime(BuildContext context) async {
    TimeOfDay _timePicker = await showTimePicker(
        context: context,
        initialTime: _time,
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              primarySwatch: Colors.orange,
            ),
            child: child,
          );
        });
    if (_timePicker != null && _timePicker != _time) {
      String stringFormat = _timeFormater(_timePicker);
      setState(() {
        _timeController.text = stringFormat;
      });
    }
  }

  String _timeFormater(_t) {
    String _h = _t.hour < 10 ? "0" + _t.hour.toString() : _t.hour.toString();
    String _m =
        _t.minute < 10 ? "0" + _t.minute.toString() : _t.minute.toString();
    String _ampm = _t.hour >= 12 ? 'pm' : 'am';
    return "$_h:$_m $_ampm";
  }

  _next(context) {
    Store store = Store();
    store.save('delivery-services', _selectedServices);
    if (_selectedServices.contains('ap')) {
      store.save('delivery-appointment-time', _timeController.text);
    } else {
      store.remove('delivery-appointment-time');
    }

    if (_isAppointment && _timeController.text == '') {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Time is required!'),
      ));
    } else {
      Navigator.pushReplacementNamed(context, '/items');
    }
  }

  void _onServiceSelected(bool selected, code) {
    if (selected == true) {
      setState(() {
        _selectedServices.add(code);
      });
      if (code == 'ap') {
        _isAppointment = true;
      }
    } else {
      setState(() {
        _selectedServices.remove(code);
      });
      if (code == 'ap') {
        _isAppointment = false;
      }
    }
  }

  _init() async {
    Store store = Store();
    var data = await store.read('delivery-services');
    var appointment = await store.read('delivery-appointment-time');

    setState(() {
      if (data != null) {
        _selectedServices = data;
        if (data.contains('ap')) {
          _isAppointment = true;
          _timeController.text = appointment;
        }
      }
    });
  }

  _getDeliveryServices() async {
    var response = await getAccessory('shipping/delivery-services');
    setState(() {
      _services = response;
    });
  }
}
