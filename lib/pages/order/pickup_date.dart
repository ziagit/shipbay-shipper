import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shipbay/models/pickup_date_model.dart';
import 'package:shipbay/pages/shared/custom_appbar.dart';
import 'package:shipbay/pages/shared/main_menu.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/pages/tracking/tracking.dart';
import 'package:shipbay/services/settings.dart';

class PickupDate extends StatefulWidget {
  @override
  _PickupDateState createState() => _PickupDateState();
}

class _PickupDateState extends State<PickupDate> {
  Store store = Store();

  bool _isAppointment = false;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(''),
      drawer: MainMenu(),
      endDrawer: Tracking(),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Container(child: Progress(progress: 28.0)),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "When to pickup?",
                          style: TextStyle(fontSize: 22.0, height: 2.0),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _dateController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid address';
                            }
                            return null;
                          },
                          decoration:
                              InputDecoration(hintText: 'Select a date'),
                          onTap: () {
                            _selectDate(context);
                          },
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              activeColor: primary,
                              value: _isAppointment,
                              onChanged: (bool val) {
                                setState(() {
                                  _isAppointment = val;
                                  if (!val) {
                                    _timeController.text = null;
                                  }
                                });
                              },
                            ),
                            Text(
                              "Appointment",
                              style: TextStyle(fontSize: 11.0),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: _isAppointment,
                          child: TextFormField(
                            controller: _timeController,
                            onTap: () {
                              _selectTime(context);
                            },
                            decoration:
                                InputDecoration(hintText: 'Select time'),
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
                Navigator.pushReplacementNamed(context, '/pickup-services');
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

  Future<Null> _selectDate(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: _date.subtract(Duration(days: 0)),
        lastDate: DateTime(2100),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
              primarySwatch: Colors.deepOrange,
            ),
            child: child,
          );
        });
    if (_datePicker != null && _datePicker != _date) {
      DateFormat formater = DateFormat('yyyy-MM-dd');
      String stringFormat = formater.format(_datePicker);

      setState(() {
        _dateController = TextEditingController(text: stringFormat);
      });
    }
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
        _timeController = TextEditingController(text: stringFormat);
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

  _next(context) async {
    PickupDateModel pickupDateModel = PickupDateModel();
    pickupDateModel.date = _dateController.text;
    pickupDateModel.time = _isAppointment ? _timeController.text : null;
    pickupDateModel.is_appointment = _isAppointment;
    await store.save('pickup-date', pickupDateModel);
    Navigator.pushReplacementNamed(context, '/delivery');
  }

  _init() async {
    var data = await store.read('pickup-date');
    if (data != null) {
      setState(() {
        _dateController.text = data['date'];
        _timeController.text = data['time'];
        _isAppointment = data['is_appointment'];
      });
    }
  }
}
