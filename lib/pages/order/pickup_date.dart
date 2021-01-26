import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shipbay/models/pickup_date_model.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:shipbay/pages/store/store.dart';
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
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/pickup-services');
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Container(child: Progress(progress: 25.0)),
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
                                    context, '/pickup-services');
                              },
                            ),
                            SizedBox(width: 16.0),
                            FloatingActionButton(
                              heroTag: 1,
                              backgroundColor: primary,
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

  Future<Null> _selectDate(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2020),
        lastDate: DateTime(2050),
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
