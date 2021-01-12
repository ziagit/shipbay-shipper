import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/services/settings.dart';

class DeliveryServices extends StatefulWidget {
  @override
  _DeliveryServicesState createState() => _DeliveryServicesState();
}

class _DeliveryServicesState extends State<DeliveryServices> {
  TextEditingController _timeController = TextEditingController();

  Map<String, bool> _services = {
    'Inside pickup': false,
    'Tailgate': false,
    'Appointment': false,
  };
  bool _isAppointment = false;
  TimeOfDay _time = TimeOfDay.now();

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
            Navigator.pushReplacementNamed(context, '/delivery');
          },
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Container(child: Progress(progress: 50.0)),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Delivery services",
                        style: TextStyle(fontSize: 24.0, height: 2.0),
                      ),
                      SizedBox(height: 16.0),
                      ListView(
                        shrinkWrap: true,
                        children: _services.keys.map((String key) {
                          return new CheckboxListTile(
                            activeColor: primary,
                            title: new Text(
                              key,
                              style: TextStyle(fontSize: 11.0),
                            ),
                            value: _services[key],
                            onChanged: (bool val) {
                              print("checkbox value: $key");
                              setState(() {
                                if (key == "Appointment") {
                                  _isAppointment = !_isAppointment;
                                }
                                _services[key] = val;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      Visibility(
                        visible: _isAppointment,
                        child: TextFormField(
                          controller: _timeController,
                          onTap: () {
                            _selectTime(context);
                          },
                          decoration: InputDecoration(hintText: 'Select time'),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FloatingActionButton(
                            heroTag: 0,
                            backgroundColor: inActive,
                            foregroundColor: primary,
                            child: Icon(Icons.keyboard_arrow_left),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/delivery');
                            },
                          ),
                          SizedBox(width: 12.0),
                          FloatingActionButton(
                            heroTag: 1,
                            backgroundColor: primary,
                            child: Icon(Icons.keyboard_arrow_right),
                            onPressed: () {
                              save();
                              Navigator.pushReplacementNamed(context, '/items');
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
    super.initState();
    read();
  }

  Future<Null> _selectTime(BuildContext context) async {
    TimeOfDay _timePicker = await showTimePicker(
        context: context,
        initialTime: _time,
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              primarySwatch: Colors.deepOrange,
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

  save() {
    Store store = Store();
    store.save('delivery-services', _services);
    if (_services['Appointment']) {
      store.save('delivery-appointment-time', _timeController.text);
    } else {
      store.remove('delivery-appointment-time');
    }
  }

  read() async {
    Store store = Store();
    var data = await store.read('delivery-services');
    var appointment = await store.read('delivery-appointment-time');

    if (data != null) {
      setState(() {
        _services['Inside pickup'] = data['Inside pickup'];
        _services['Tailgate'] = data['Tailgate'];
        _services['Appointment'] = data['Appointment'];
        _isAppointment = data['Appointment'];
        if (appointment != null) {
          _timeController.text = appointment;
        }
      });
    }
  }
}
